//
//  LocationAddressHelper.h
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 定位地址完成回调
/// @param regeocode 反地理编码结果（包含地址信息）
/// @param coordinate 坐标
/// @param error 错误信息，如果成功则为nil
typedef void(^LocationAddressCompletion)(AMapReGeocode * _Nullable regeocode, CLLocationCoordinate2D coordinate, NSError * _Nullable error);

/// 定位地址辅助类（单次定位）
@interface LocationAddressHelper : NSObject

/// 单例
+ (instancetype)shared;

/// 获取当前地址（单次定位）
/// @param completion 完成回调
- (void)getCurrentAddressWithCompletion:(LocationAddressCompletion)completion;

/// 根据坐标获取地址信息
/// @param coordinate 坐标
/// @param completion 完成回调
- (void)getAddressForCoordinate:(CLLocationCoordinate2D)coordinate
                      completion:(LocationAddressCompletion)completion;

/// 取消当前的定位请求
- (void)cancel;

@end

NS_ASSUME_NONNULL_END

