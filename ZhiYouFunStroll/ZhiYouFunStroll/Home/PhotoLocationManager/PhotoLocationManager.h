//
//  PhotoLocationManager.h
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

/// 照片位置信息模型
@interface PhotoLocationInfo : NSObject

/// 照片资源
@property (nonatomic, strong) PHAsset *asset;
/// 照片的本地标识符
@property (nonatomic, copy) NSString *localIdentifier;
/// 照片的创建日期
@property (nonatomic, strong) NSDate *creationDate;
/// 照片的经纬度（如果有）
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
/// 是否有GPS信息
@property (nonatomic, assign) BOOL hasLocation;
/// 反地理编码后的地址信息
@property (nonatomic, strong, nullable) AMapReGeocode *addressInfo;
/// 地址字符串（格式化后的完整地址）
@property (nonatomic, copy, nullable) NSString *formattedAddress;

@end

/// 获取相册照片并解析位置信息的回调
typedef void(^PhotoLocationFetchCompletion)(NSArray<PhotoLocationInfo *> *photos, NSError * _Nullable error);
/// 单个照片反地理编码完成的回调
typedef void(^PhotoReverseGeocodeCompletion)(PhotoLocationInfo *photo, NSError * _Nullable error);
/// 批量反地理编码完成的回调
typedef void(^BatchReverseGeocodeCompletion)(NSArray<PhotoLocationInfo *> *photos, NSError * _Nullable error);

/// 相册照片位置信息管理器
@interface PhotoLocationManager : NSObject

/// 单例
+ (instancetype)shared;

/// 获取相册中所有照片（异步）
/// @param completion 完成回调，返回包含位置信息的照片数组
- (void)fetchAllPhotosWithCompletion:(PhotoLocationFetchCompletion)completion;

/// 获取相册中所有有GPS信息的照片（异步）
/// @param completion 完成回调，返回包含位置信息的照片数组
- (void)fetchPhotosWithLocationWithCompletion:(PhotoLocationFetchCompletion)completion;

/// 对单个照片进行反地理编码
/// @param photoInfo 照片信息对象
/// @param completion 完成回调
- (void)reverseGeocodeForPhoto:(PhotoLocationInfo *)photoInfo
                    completion:(PhotoReverseGeocodeCompletion)completion;

/// 批量对照片进行反地理编码
/// @param photos 照片信息数组
/// @param completion 完成回调，返回已更新地址信息的照片数组
- (void)batchReverseGeocodeForPhotos:(NSArray<PhotoLocationInfo *> *)photos
                           completion:(BatchReverseGeocodeCompletion)completion;

/// 检查相册访问权限
/// @return 权限状态：0-未确定，1-受限，2-拒绝，3-授权
+ (PHAuthorizationStatus)authorizationStatus;

/// 请求相册访问权限
/// @param completion 权限请求完成回调
+ (void)requestAuthorizationWithCompletion:(void(^)(PHAuthorizationStatus status))completion;

@end

NS_ASSUME_NONNULL_END

