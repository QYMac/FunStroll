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

#pragma mark - 保存图片到相册

- (void)saveImageToPhotoLibrary:(UIImage *)image completion:(PhotoSaveCompletion)completion {
    [self saveImageToPhotoLibrary:image albumName:nil completion:completion];
}

- (void)saveImageToPhotoLibrary:(UIImage *)image albumName:(nullable NSString *)albumName completion:(PhotoSaveCompletion)completion {
    if (!image) {
        NSError *error = [NSError errorWithDomain:@"PhotoLocationManager"
                                             code:-1
                                         userInfo:@{NSLocalizedDescriptionKey: @"图片不能为空"}];
        if (completion) {
            completion(NO, error, nil);
        }
        return;
    }
    
    // 检查权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (@available(iOS 14, *)) {
        if (status != PHAuthorizationStatusAuthorized && status != PHAuthorizationStatusLimited) {
            NSError *error = [NSError errorWithDomain:@"PhotoLocationManager"
                                                 code:-2
                                             userInfo:@{NSLocalizedDescriptionKey: @"相册访问权限未授权"}];
            if (completion) {
                completion(NO, error, nil);
            }
            return;
        }
    } else {
        // Fallback on earlier versions
    }
    
    // 保存图片
    __block NSString *assetIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        assetIdentifier = request.placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success && assetIdentifier) {
                // 如果需要保存到指定相册
                if (albumName && albumName.length > 0) {
                    [self addAssetWithIdentifier:assetIdentifier toAlbum:albumName completion:completion];
                } else {
                    if (completion) {
                        completion(YES, nil, assetIdentifier);
                    }
                }
            } else {
                if (completion) {
                    completion(NO, error, nil);
                }
            }
        });
    }];
}

- (void)saveImageDataToPhotoLibrary:(NSData *)imageData completion:(PhotoSaveCompletion)completion {
    [self saveImageDataToPhotoLibrary:imageData albumName:nil completion:completion];
}

- (void)saveImageDataToPhotoLibrary:(NSData *)imageData albumName:(nullable NSString *)albumName completion:(PhotoSaveCompletion)completion {
    if (!imageData || imageData.length == 0) {
        NSError *error = [NSError errorWithDomain:@"PhotoLocationManager"
                                             code:-1
                                         userInfo:@{NSLocalizedDescriptionKey: @"图片数据不能为空"}];
        if (completion) {
            completion(NO, error, nil);
        }
        return;
    }
    
    UIImage *image = [UIImage imageWithData:imageData];
    if (!image) {
        NSError *error = [NSError errorWithDomain:@"PhotoLocationManager"
                                             code:-3
                                         userInfo:@{NSLocalizedDescriptionKey: @"图片数据格式无效"}];
        if (completion) {
            completion(NO, error, nil);
        }
        return;
    }
    
    [self saveImageToPhotoLibrary:image albumName:albumName completion:completion];
}

- (void)saveImageFromURLToPhotoLibrary:(NSURL *)imageURL completion:(PhotoSaveCompletion)completion {
    [self saveImageFromURLToPhotoLibrary:imageURL albumName:nil completion:completion];
}

- (void)saveImageFromURLToPhotoLibrary:(NSURL *)imageURL albumName:(nullable NSString *)albumName completion:(PhotoSaveCompletion)completion {
    if (!imageURL) {
        NSError *error = [NSError errorWithDomain:@"PhotoLocationManager"
                                             code:-1
                                         userInfo:@{NSLocalizedDescriptionKey: @"图片URL不能为空"}];
        if (completion) {
            completion(NO, error, nil);
        }
        return;
    }
    
    // 检查权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (@available(iOS 14, *)) {
        if (status != PHAuthorizationStatusAuthorized && status != PHAuthorizationStatusLimited) {
            NSError *error = [NSError errorWithDomain:@"PhotoLocationManager"
                                                 code:-2
                                             userInfo:@{NSLocalizedDescriptionKey: @"相册访问权限未授权"}];
            if (completion) {
                completion(NO, error, nil);
            }
            return;
        }
    } else {
        // Fallback on earlier versions
    }
    
    // 保存图片
    __block NSString *assetIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:imageURL];
        assetIdentifier = request.placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success && assetIdentifier) {
                // 如果需要保存到指定相册
                if (albumName && albumName.length > 0) {
                    [self addAssetWithIdentifier:assetIdentifier toAlbum:albumName completion:completion];
                } else {
                    if (completion) {
                        completion(YES, nil, assetIdentifier);
                    }
                }
            } else {
                if (completion) {
                    completion(NO, error, nil);
                }
            }
        });
    }];
}

/// 将资源添加到指定相册
- (void)addAssetWithIdentifier:(NSString *)assetIdentifier toAlbum:(NSString *)albumName completion:(PhotoSaveCompletion)completion {
    // 查找或创建相册
    PHAssetCollection *album = [self findOrCreateAlbum:albumName];
    if (!album) {
        NSError *error = [NSError errorWithDomain:@"PhotoLocationManager"
                                             code:-4
                                         userInfo:@{NSLocalizedDescriptionKey: @"无法创建或找到指定相册"}];
        if (completion) {
            completion(NO, error, assetIdentifier);
        }
        return;
    }
    
    // 获取资源
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetIdentifier] options:nil];
    if (assets.count == 0) {
        NSError *error = [NSError errorWithDomain:@"PhotoLocationManager"
                                             code:-5
                                         userInfo:@{NSLocalizedDescriptionKey: @"无法找到保存的资源"}];
        if (completion) {
            completion(NO, error, assetIdentifier);
        }
        return;
    }
    
    PHAsset *asset = assets.firstObject;
    
    // 将资源添加到相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:album];
        [albumChangeRequest addAssets:@[asset]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(success, error, assetIdentifier);
            }
        });
    }];
}

/// 查找或创建相册
- (nullable PHAssetCollection *)findOrCreateAlbum:(NSString *)albumName {
    if (!albumName || albumName.length == 0) {
        return nil;
    }
    
    // 查找相册
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.predicate = [NSPredicate predicateWithFormat:@"title = %@", albumName];
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                                                subtype:PHAssetCollectionSubtypeAny
                                                                                                options:options];
    
    if (collections.count > 0) {
        return collections.firstObject;
    }
    
    // 创建相册
    __block NSString *albumIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *createRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
        albumIdentifier = createRequest.placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    
    if (albumIdentifier) {
        PHFetchResult<PHAssetCollection *> *newCollections = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[albumIdentifier] options:nil];
        if (newCollections.count > 0) {
            return newCollections.firstObject;
        }
    }
    
    return nil;
}

#pragma mark - 保存网络图片

- (void)saveNetworkImageToPhotoLibrary:(NSString *)imageURLString completion:(PhotoSaveCompletion)completion {
    [self saveNetworkImageToPhotoLibrary:imageURLString albumName:nil completion:completion];
}

- (void)saveNetworkImageToPhotoLibrary:(NSString *)imageURLString albumName:(nullable NSString *)albumName completion:(PhotoSaveCompletion)completion {
    if (!imageURLString || imageURLString.length == 0) {
        NSError *error = [NSError errorWithDomain:@"PhotoLocationManager"
                                             code:-1
                                         userInfo:@{NSLocalizedDescriptionKey: @"图片URL不能为空"}];
        if (completion) {
            completion(NO, error, nil);
        }
        return;
    }
    
    // 检查是否是网络URL
    NSURL *url = [NSURL URLWithString:imageURLString];
    if (!url) {
        NSError *error = [NSError errorWithDomain:@"PhotoLocationManager"
                                             code:-2
                                         userInfo:@{NSLocalizedDescriptionKey: @"无效的URL格式"}];
        if (completion) {
            completion(NO, error, nil);
        }
        return;
    }
    
    // 如果是 file:// 协议，直接使用本地文件保存方法
    if ([url.scheme isEqualToString:@"file"]) {
        [self saveImageFromURLToPhotoLibrary:url albumName:albumName completion:completion];
        return;
    }
    
    // 检查权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status != PHAuthorizationStatusAuthorized && status != PHAuthorizationStatusLimited) {
        NSError *error = [NSError errorWithDomain:@"PhotoLocationManager"
                                             code:-3
                                         userInfo:@{NSLocalizedDescriptionKey: @"相册访问权限未授权"}];
        if (completion) {
            completion(NO, error, nil);
        }
        return;
    }
    
    // 下载网络图片
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(NO, error, nil);
                }
            });
            return;
        }
        
        if (!data || data.length == 0) {
            NSError *dataError = [NSError errorWithDomain:@"PhotoLocationManager"
                                                     code:-4
                                                 userInfo:@{NSLocalizedDescriptionKey: @"下载的图片数据为空"}];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(NO, dataError, nil);
                }
            });
            return;
        }
        
        // 将图片数据转换为 UIImage
        UIImage *image = [UIImage imageWithData:data];
        if (!image) {
            NSError *imageError = [NSError errorWithDomain:@"PhotoLocationManager"
                                                     code:-5
                                                 userInfo:@{NSLocalizedDescriptionKey: @"图片数据格式无效"}];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(NO, imageError, nil);
                }
            });
            return;
        }
        
        // 保存图片到相册
        [self saveImageToPhotoLibrary:image albumName:albumName completion:completion];
    }];
    
    [task resume];
}

@end

