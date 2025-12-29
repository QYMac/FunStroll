//
//  DeviceInfoHelper.h
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// SIM卡状态
typedef NS_ENUM(NSInteger, SIMCardStatus) {
    SIMCardStatusUnknown = 0,      // 未知状态
    SIMCardStatusAvailable,        // 有SIM卡
    SIMCardStatusNotAvailable,     // 无SIM卡
    SIMCardStatusRestricted        // 受限（可能无权限或设备不支持）
};

/// 设备信息辅助类
@interface DeviceInfoHelper : NSObject

/// 检查设备是否有SIM卡
/// @return SIMCardStatus SIM卡状态
+ (SIMCardStatus)checkSIMCardStatus;

/// 检查设备是否有SIM卡（布尔值）
/// @return YES表示有SIM卡，NO表示无SIM卡或状态未知
+ (BOOL)hasSIMCard;

/// 获取SIM卡运营商名称
/// @return 运营商名称，如果无法获取则返回nil
+ (nullable NSString *)getCarrierName;

/// 检查设备是否支持蜂窝网络（可能没有SIM卡但支持蜂窝网络）
/// @return YES表示设备支持蜂窝网络，NO表示不支持
+ (BOOL)supportsCellularNetwork;

@end

NS_ASSUME_NONNULL_END

