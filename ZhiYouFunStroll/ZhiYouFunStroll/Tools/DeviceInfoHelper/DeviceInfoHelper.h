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

/// 获取设备型号名称（如"iPhone 16"、"iPhone 15 Pro"、"iPad Pro 12.9英寸"等）
/// @return 设备型号名称，如果无法识别则返回设备标识符
+ (NSString *)getDeviceModelName;

/// 获取设备标识符（如"iPhone17,1"、"iPad14,1"等）
/// @return 设备标识符
+ (NSString *)getDeviceIdentifier;


/// 判断是否为刘海屏（iPhone X及以后）
+ (BOOL)hasNotch;

/// 判断是否为灵动岛设备（iPhone 14 Pro及以后）
+ (BOOL)isDynamicIsland;


@end

NS_ASSUME_NONNULL_END

