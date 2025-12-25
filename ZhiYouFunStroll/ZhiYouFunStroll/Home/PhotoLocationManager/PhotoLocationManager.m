//
//  PhotoLocationManager.m
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import "PhotoLocationManager.h"

@interface PhotoLocationInfo ()

@end

@implementation PhotoLocationInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        _coordinate = kCLLocationCoordinate2DInvalid;
        _hasLocation = NO;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"PhotoLocationInfo: identifier=%@, hasLocation=%@, coordinate=(%f, %f), address=%@",
            self.localIdentifier,
            self.hasLocation ? @"YES" : @"NO",
            self.coordinate.latitude,
            self.coordinate.longitude,
            self.formattedAddress ?: @"N/A"];
}

@end

@interface PhotoLocationManager () <AMapSearchDelegate>

@property (nonatomic, strong) AMapSearchAPI *searchAPI;
@property (nonatomic, strong) NSMutableDictionary<NSString *, PhotoReverseGeocodeCompletion> *geocodeCompletions;
@property (nonatomic, strong) NSMutableDictionary<NSString *, PhotoLocationInfo *> *requestToPhotoMap; // 请求坐标字符串 -> 照片
@property (nonatomic, strong) NSMutableArray<PhotoLocationInfo *> *pendingGeocodePhotos;
@property (nonatomic, strong) NSArray<PhotoLocationInfo *> *originalPhotos; // 保存原始照片数组
@property (nonatomic, copy, nullable) BatchReverseGeocodeCompletion batchCompletion;
@property (nonatomic, assign) NSInteger pendingGeocodeCount;

@end

static PhotoLocationManager *_sharedManager;

@implementation PhotoLocationManager

+ (instancetype)shared {
    @synchronized(self) {
        if (!_sharedManager) {
            _sharedManager = [[self alloc] init];
        }
    }
    return _sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _searchAPI = [[AMapSearchAPI alloc] init];
        _searchAPI.delegate = self;
        _geocodeCompletions = [NSMutableDictionary dictionary];
        _requestToPhotoMap = [NSMutableDictionary dictionary];
        _pendingGeocodePhotos = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 权限检查

+ (PHAuthorizationStatus)authorizationStatus {
    return [PHPhotoLibrary authorizationStatus];
}

+ (void)requestAuthorizationWithCompletion:(void(^)(PHAuthorizationStatus status))completion {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (@available(iOS 14, *)) {
        if (status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited) {
            if (completion) {
                completion(status);
            }
            return;
        }
    } else {
        // Fallback on earlier versions
    }
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(status);
            }
        });
    }];
}

#pragma mark - 获取照片

- (void)fetchAllPhotosWithCompletion:(PhotoLocationFetchCompletion)completion {
    [self fetchPhotosWithLocationOnly:NO completion:completion];
}

- (void)fetchPhotosWithLocationWithCompletion:(PhotoLocationFetchCompletion)completion {
    [self fetchPhotosWithLocationOnly:YES completion:completion];
}

- (void)fetchPhotosWithLocationOnly:(BOOL)locationOnly completion:(PhotoLocationFetchCompletion)completion {
    // 检查权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (@available(iOS 14, *)) {
        if (status != PHAuthorizationStatusAuthorized && status != PHAuthorizationStatusLimited) {
            NSError *error = [NSError errorWithDomain:@"PhotoLocationManager"
                                                 code:-1
                                             userInfo:@{NSLocalizedDescriptionKey: @"相册访问权限未授权"}];
            if (completion) {
                completion(@[], error);
            }
            return;
        }
    } else {
        // Fallback on earlier versions
    }
    
    // 在后台队列执行照片获取
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray<PhotoLocationInfo *> *photoInfos = [NSMutableArray array];
        
        // 获取所有照片资源
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
        
        NSLog(@"找到 %lu 张照片", (unsigned long)assets.count);
        
        [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
            PhotoLocationInfo *info = [[PhotoLocationInfo alloc] init];
            info.asset = asset;
            info.localIdentifier = asset.localIdentifier;
            info.creationDate = asset.creationDate;
            
            // 提取GPS信息
            if (asset.location) {
                CLLocationCoordinate2D coord = asset.location.coordinate;
                info.coordinate = coord;
                info.hasLocation = YES;
                
                // 验证坐标是否有效
                if (CLLocationCoordinate2DIsValid(coord)) {
                    [photoInfos addObject:info];
                }
            } else if (!locationOnly) {
                // 如果没有GPS信息但需要所有照片，也添加
                info.hasLocation = NO;
                [photoInfos addObject:info];
            }
        }];
        
        NSLog(@"提取到 %lu 张照片（有位置信息：%lu 张）", 
              (unsigned long)photoInfos.count,
              (unsigned long)[photoInfos filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hasLocation == YES"]].count);
        
        // 回到主线程回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion([photoInfos copy], nil);
            }
        });
    });
}

#pragma mark - 反地理编码

- (void)reverseGeocodeForPhoto:(PhotoLocationInfo *)photoInfo
                    completion:(PhotoReverseGeocodeCompletion)completion {
    if (!photoInfo.hasLocation || !CLLocationCoordinate2DIsValid(photoInfo.coordinate)) {
        NSError *error = [NSError errorWithDomain:@"PhotoLocationManager"
                                             code:-2
                                         userInfo:@{NSLocalizedDescriptionKey: @"照片没有有效的GPS信息"}];
        if (completion) {
            completion(photoInfo, error);
        }
        return;
    }
    
    // 如果已经有地址信息，直接返回
    if (photoInfo.addressInfo) {
        if (completion) {
            completion(photoInfo, nil);
        }
        return;
    }
    
    // 创建逆地理编码请求
    AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:photoInfo.coordinate.latitude
                                                longitude:photoInfo.coordinate.longitude];
    request.requireExtension = YES; // 返回扩展信息
    
    // 生成请求唯一标识（使用坐标字符串）
    NSString *requestKey = [NSString stringWithFormat:@"%.6f,%.6f", 
                           photoInfo.coordinate.latitude, 
                           photoInfo.coordinate.longitude];
    
    // 保存回调和照片映射
    NSString *photoKey = photoInfo.localIdentifier;
    if (completion) {
        self.geocodeCompletions[photoKey] = completion;
    }
    self.requestToPhotoMap[requestKey] = photoInfo;
    
    // 发起请求
    [self.searchAPI AMapReGoecodeSearch:request];
}

- (void)batchReverseGeocodeForPhotos:(NSArray<PhotoLocationInfo *> *)photos
                           completion:(BatchReverseGeocodeCompletion)completion {
    if (photos.count == 0) {
        if (completion) {
            completion(@[], nil);
        }
        return;
    }
    
    // 过滤出有位置信息且还没有地址信息的照片
    NSMutableArray<PhotoLocationInfo *> *photosToGeocode = [NSMutableArray array];
    for (PhotoLocationInfo *photo in photos) {
        if (photo.hasLocation && CLLocationCoordinate2DIsValid(photo.coordinate) && !photo.addressInfo) {
            [photosToGeocode addObject:photo];
        }
    }
    
    if (photosToGeocode.count == 0) {
        if (completion) {
            completion(photos, nil);
        }
        return;
    }
    
    // 保存批量回调和原始照片数组
    self.batchCompletion = completion;
    self.originalPhotos = photos; // 保存原始数组
    self.pendingGeocodePhotos = [photosToGeocode mutableCopy];
    self.pendingGeocodeCount = photosToGeocode.count;
    
    // 逐个进行反地理编码（避免请求过快）
    [self performNextGeocode];
}

- (void)performNextGeocode {
    if (self.pendingGeocodePhotos.count == 0) {
        // 所有请求完成
        if (self.batchCompletion) {
            // 返回原始照片数组（地址信息已更新）
            self.batchCompletion(self.originalPhotos, nil);
            self.batchCompletion = nil;
            self.originalPhotos = nil;
        }
        return;
    }
    
    PhotoLocationInfo *photo = [self.pendingGeocodePhotos firstObject];
    [self.pendingGeocodePhotos removeObjectAtIndex:0];
    
    __weak typeof(self) weakSelf = self;
    [self reverseGeocodeForPhoto:photo completion:^(PhotoLocationInfo *photoInfo, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        if (error) {
            NSLog(@"反地理编码失败: %@", error.localizedDescription);
        }
        
        // 延迟一下再处理下一个，避免请求过快
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf performNextGeocode];
        });
    }];
}

#pragma mark - AMapSearchDelegate

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    // 通过请求坐标查找对应的照片
    NSString *requestKey = [NSString stringWithFormat:@"%.6f,%.6f", 
                           request.location.latitude, 
                           request.location.longitude];
    PhotoLocationInfo *matchedPhoto = self.requestToPhotoMap[requestKey];
    
    // 清理映射
    [self.requestToPhotoMap removeObjectForKey:requestKey];
    
    if (!matchedPhoto) {
        NSLog(@"警告：未找到对应的照片，请求坐标: %@", requestKey);
        return;
    }
    
    if (response.regeocode == nil) {
        NSError *error = [NSError errorWithDomain:@"PhotoLocationManager"
                                             code:-3
                                         userInfo:@{NSLocalizedDescriptionKey: @"反地理编码返回结果为空"}];
        
        PhotoReverseGeocodeCompletion completion = self.geocodeCompletions[matchedPhoto.localIdentifier];
        if (completion) {
            completion(matchedPhoto, error);
            [self.geocodeCompletions removeObjectForKey:matchedPhoto.localIdentifier];
        }
        return;
    }
    
    // 更新照片的地址信息
    matchedPhoto.addressInfo = response.regeocode;
    
    // 格式化地址字符串
    if (response.regeocode.formattedAddress) {
        matchedPhoto.formattedAddress = response.regeocode.formattedAddress;
    } else if (response.regeocode.addressComponent) {
        AMapAddressComponent *component = response.regeocode.addressComponent;
        NSMutableString *address = [NSMutableString string];
        if (component.province) {
            [address appendString:component.province];
        }
        if (component.city) {
            [address appendString:component.city];
        }
        if (component.district) {
            [address appendString:component.district];
        }
        if (component.township) {
            [address appendString:component.township];
        }
        if (component.neighborhood && component.neighborhood.length > 0) {
            [address appendString:component.neighborhood];
        }
        if (component.building && component.building.length > 0) {
            [address appendString:component.building];
        }
        matchedPhoto.formattedAddress = [address copy];
    }
    
    // 调用回调
    PhotoReverseGeocodeCompletion completion = self.geocodeCompletions[matchedPhoto.localIdentifier];
    if (completion) {
        completion(matchedPhoto, nil);
        [self.geocodeCompletions removeObjectForKey:matchedPhoto.localIdentifier];
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"反地理编码请求失败: %@", error.localizedDescription);
    
    // 尝试找到对应的照片并调用失败回调
    if ([request isKindOfClass:[AMapReGeocodeSearchRequest class]]) {
        AMapReGeocodeSearchRequest *regeoRequest = (AMapReGeocodeSearchRequest *)request;
        NSString *requestKey = [NSString stringWithFormat:@"%.6f,%.6f", 
                                regeoRequest.location.latitude, 
                                regeoRequest.location.longitude];
        
        PhotoLocationInfo *matchedPhoto = self.requestToPhotoMap[requestKey];
        
        // 清理映射
        [self.requestToPhotoMap removeObjectForKey:requestKey];
        
        if (matchedPhoto) {
            PhotoReverseGeocodeCompletion completion = self.geocodeCompletions[matchedPhoto.localIdentifier];
            if (completion) {
                completion(matchedPhoto, error);
                [self.geocodeCompletions removeObjectForKey:matchedPhoto.localIdentifier];
            }
        }
    }
}

@end

