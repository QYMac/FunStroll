//
//  DeviceInfoHelper.m
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import "DeviceInfoHelper.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <UIKit/UIKit.h>

@implementation DeviceInfoHelper

+ (SIMCardStatus)checkSIMCardStatus {
    // 方法1: 检查设备是否支持蜂窝网络硬件
    if (![self supportsCellularNetworkHardware]) {
        return SIMCardStatusNotAvailable;
    }
    
    // 方法2: 通过CoreTelephony检查运营商信息
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    
    // iOS 12.0+ 使用新的API
    if (@available(iOS 12.0, *)) {
        NSDictionary<NSString *, CTCarrier *> *carriers = networkInfo.serviceSubscriberCellularProviders;
        NSDictionary<NSString *, NSString *> *radioAccess = networkInfo.serviceCurrentRadioAccessTechnology;
        
        if (carriers.count == 0) {
            return SIMCardStatusNotAvailable;
        }
        
        // 严格检查是否有有效的SIM卡
        // 需要同时满足多个条件：有效的运营商名称 + 有效的MCC/MNC + 网络连接类型
        for (NSString *key in carriers.allKeys) {
            CTCarrier *carrier = carriers[key];
            
            if (!carrier) {
                continue;
            }
            
            // 检查1: 运营商名称必须存在且不为空（不能只是"Carrier"这种默认值）
            NSString *carrierName = carrier.carrierName;
            if (!carrierName || carrierName.length == 0) {
                continue;
            }
            
            // 检查运营商名称不是默认的占位符（某些设备没有SIM卡时会显示"Carrier"）
            NSString *lowercaseName = [carrierName lowercaseString];
            if ([lowercaseName isEqualToString:@"carrier"] ||
                [lowercaseName containsString:@"unknown"] ||
                [lowercaseName isEqualToString:@""]) {
                continue;
            }
            
            // 检查2: 必须有有效的移动国家代码（MCC）和移动网络代码（MNC）
            NSString *mcc = carrier.mobileCountryCode;
            NSString *mnc = carrier.mobileNetworkCode;
            
            /*
            // MCC应该是3位数字，MNC应该是2-3位数字
            if (!mcc || mcc.length != 3 || ![self isNumericString:mcc]) {
                continue;
            }
            
            if (!mnc || mnc.length < 2 || mnc.length > 3 || ![self isNumericString:mnc]) {
                continue;
            }
             */
            
            // 检查3: 必须有ISO国家代码
            NSString *isoCountryCode = carrier.isoCountryCode;
            if (!isoCountryCode || isoCountryCode.length != 2) {
                continue;
            }
            
            // 检查4: 检查是否有实际的蜂窝网络连接（不仅仅是Wi-Fi）
            // 这是最关键的判断：如果有radioAccessTechnology，说明有实际的蜂窝网络连接，确认有SIM卡
            NSString *radioTech = radioAccess[key];
            if (radioTech && radioTech.length > 0) {
                // 有实际的蜂窝网络连接，确认有SIM卡
                return SIMCardStatusAvailable;
            } else {
                // 如果没有radioAccessTechnology，可能是以下几种情况：
                // 1. 飞行模式 - 有SIM卡但关闭了蜂窝网络
                // 2. 仅Wi-Fi连接 - 没有SIM卡或关闭了蜂窝网络
                // 3. 没有SIM卡
                
                // 为了更准确，我们只在这些情况下才认为可能有SIM卡：
                // - MCC/MNC都是有效的（不是默认值）
                // - 运营商名称是真实的有效值（不是"Carrier"等占位符）
                // - ISO国家代码有效
                
                // 进一步检查：如果MCC是"000"或MNC是"00"，很可能是默认值，不是真实的SIM卡信息
                if ([mcc isEqualToString:@"000"] || [mnc isEqualToString:@"00"] || [mnc isEqualToString:@"000"]) {
                    continue; // 可能是默认值，继续检查下一个
                }
                
                // 如果所有信息都看起来有效，才认为可能有SIM卡
                // 但为了更保守，这种情况返回"未知状态"而不是"有SIM卡"
                // 因为无法100%确定（可能是Wi-Fi only的情况）
                // 但考虑到用户反馈的问题，如果没有radioAccessTechnology，我们更倾向于认为没有SIM卡
                // 除非有其他明确证据
                continue; // 继续检查其他carrier，如果没有找到任何有radioAccessTechnology的，则认为没有SIM卡
            }
        }
        
        // 所有carrier都不满足条件，说明没有有效的SIM卡
        return SIMCardStatusNotAvailable;
    } else {
        // iOS 12.0以下使用旧API
        CTCarrier *carrier = networkInfo.subscriberCellularProvider;
        NSString *radioTech = networkInfo.currentRadioAccessTechnology;
        
        if (!carrier) {
            return SIMCardStatusNotAvailable;
        }
        
        // 严格检查运营商信息
        NSString *carrierName = carrier.carrierName;
        if (!carrierName || carrierName.length == 0) {
            return SIMCardStatusNotAvailable;
        }
        
        // 检查不是默认占位符
        NSString *lowercaseName = [carrierName lowercaseString];
        if ([lowercaseName isEqualToString:@"carrier"] ||
            [lowercaseName containsString:@"unknown"] ||
            [lowercaseName isEqualToString:@""]) {
            return SIMCardStatusNotAvailable;
        }
        
        // 检查MCC和MNC
        NSString *mcc = carrier.mobileCountryCode;
        NSString *mnc = carrier.mobileNetworkCode;
        
        if (!mcc || mcc.length != 3 || ![self isNumericString:mcc]) {
            return SIMCardStatusNotAvailable;
        }
        
        if (!mnc || mnc.length < 2 || mnc.length > 3 || ![self isNumericString:mnc]) {
            return SIMCardStatusNotAvailable;
        }
        
        // 检查ISO国家代码
        NSString *isoCountryCode = carrier.isoCountryCode;
        if (!isoCountryCode || isoCountryCode.length != 2) {
            return SIMCardStatusNotAvailable;
        }
        
        // 如果有radioAccessTechnology，更确认有SIM卡
        if (radioTech && radioTech.length > 0) {
            return SIMCardStatusAvailable;
        }
        
        // 如果没有radioAccessTechnology，需要更严格的判断
        // 检查MCC/MNC不是默认值
        if ([mcc isEqualToString:@"000"] || [mnc isEqualToString:@"00"] || [mnc isEqualToString:@"000"]) {
            return SIMCardStatusNotAvailable; // 可能是默认值
        }
        
        // 即使没有radioAccessTechnology，如果其他信息都有效，可能是飞行模式
        // 但为了更准确，如果没有radioAccessTechnology，我们保守地认为可能是Wi-Fi only
        // 返回未知状态，让调用者知道无法确定
        return SIMCardStatusUnknown;
    }
}

+ (BOOL)hasSIMCard {
    SIMCardStatus status = [self checkSIMCardStatus];
    return (status == SIMCardStatusAvailable);
}

+ (nullable NSString *)getCarrierName {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    
    if (@available(iOS 12.0, *)) {
        NSDictionary<NSString *, CTCarrier *> *carriers = networkInfo.serviceSubscriberCellularProviders;
        
        // 获取第一个有效的运营商名称（使用严格的检查）
        for (NSString *key in carriers.allKeys) {
            CTCarrier *carrier = carriers[key];
            if ([self hasValidCarrierInfo:carrier]) {
                return carrier.carrierName;
            }
        }
    } else {
        CTCarrier *carrier = networkInfo.subscriberCellularProvider;
        if ([self hasValidCarrierInfo:carrier]) {
            return carrier.carrierName;
        }
    }
    
    return nil;
}

+ (BOOL)supportsCellularNetwork {
    // 这个方法检查设备是否支持蜂窝网络（硬件层面）
    // 即使没有SIM卡，设备也可能支持蜂窝网络硬件
    return [self supportsCellularNetworkHardware];
}

// 检查设备硬件是否支持蜂窝网络
+ (BOOL)supportsCellularNetworkHardware {
    // 检查设备型号
    NSString *model = [[UIDevice currentDevice].model lowercaseString];
    
    // iPhone 都支持蜂窝网络硬件
    if ([model containsString:@"iphone"]) {
        return YES;
    }
    
    // 对于iPad，需要进一步检查（部分iPad支持，部分不支持）
    if ([model containsString:@"ipad"]) {
        // 可以通过检查设备型号标识符来判断
        // 但由于iOS限制，这里简化处理
        // 实际可以通过检查是否能够获取到任何运营商信息来判断硬件支持
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        
        // 如果能创建networkInfo对象，说明设备至少支持查询蜂窝网络信息
        // 但这不能100%确定，因为即使没有蜂窝网络的设备也能创建这个对象
        // 更可靠的方法是检查是否有任何运营商信息（即使是空的）
        
        // 这里返回YES，让上层通过更严格的方法来判断
        return YES;
    }
    
    // iPod touch 不支持蜂窝网络硬件
    if ([model containsString:@"ipod"]) {
        return NO;
    }
    
    return NO;
}

// 检查字符串是否为纯数字
+ (BOOL)isNumericString:(NSString *)string {
    if (!string || string.length == 0) {
        return NO;
    }
    
    NSCharacterSet *nonNumericSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [string rangeOfCharacterFromSet:nonNumericSet].location == NSNotFound;
}

// 检查运营商信息是否有效
+ (BOOL)hasValidCarrierInfo:(CTCarrier *)carrier {
    if (!carrier) {
        return NO;
    }
    
    // 检查运营商名称
    NSString *carrierName = carrier.carrierName;
    if (!carrierName || carrierName.length == 0) {
        return NO;
    }
    
    NSString *lowercaseName = [carrierName lowercaseString];
    if ([lowercaseName isEqualToString:@"carrier"] ||
        [lowercaseName containsString:@"unknown"]) {
        return NO;
    }
    
    // 检查MCC和MNC
    NSString *mcc = carrier.mobileCountryCode;
    NSString *mnc = carrier.mobileNetworkCode;
    
    if (!mcc || mcc.length != 3 || ![self isNumericString:mcc]) {
        return NO;
    }
    
    if (!mnc || mnc.length < 2 || mnc.length > 3 || ![self isNumericString:mnc]) {
        return NO;
    }
    
    // 检查ISO国家代码
    NSString *isoCountryCode = carrier.isoCountryCode;
    if (!isoCountryCode || isoCountryCode.length != 2) {
        return NO;
    }
    
    return YES;
}

@end

