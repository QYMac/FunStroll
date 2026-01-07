//
//  DateHelper.h
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 日期格式化辅助类
@interface DateHelper : NSObject

/// 格式化日期字符串
/// @param dateString 日期字符串，格式为 @"yyyy-MM-dd HH:mm:ss"，如 @"2026-01-04 16:03:26"
/// @return 格式化后的日期字符串：
///         - 如果是当年，返回 @"MM-dd" 格式，如 @"01-04"
///         - 如果不是当年，返回 @"yyyy-MM-dd" 格式，如 @"2025-01-04"
///         如果解析失败，返回 nil
+ (nullable NSString *)formatDateString:(NSString *)dateString;

/// 格式化日期字符串（带默认值）
/// @param dateString 日期字符串
/// @param defaultString 解析失败时返回的默认字符串，如果为 nil 则返回空字符串
/// @return 格式化后的日期字符串
+ (NSString *)formatDateString:(NSString *)dateString defaultString:(nullable NSString *)defaultString;

/// 获取相对时间描述
/// @param dateString 日期字符串，格式为 @"yyyy-MM-dd HH:mm:ss"，如 @"2026-01-04 16:03:26"
/// @return 相对时间描述：
///         - 小于60秒：@"X秒前"
///         - 小于60分钟：@"X分钟前"
///         - 小于24小时：@"X小时前"
///         - 小于30天：@"X天前"
///         - 小于12个月：@"X个月前"
///         - 大于等于12个月：@"X年前"
///         如果解析失败或时间在未来，返回 nil
+ (nullable NSString *)relativeTimeString:(NSString *)dateString;

/// 获取相对时间描述（带默认值）
/// @param dateString 日期字符串
/// @param defaultString 解析失败时返回的默认字符串，如果为 nil 则返回空字符串
/// @return 相对时间描述
+ (NSString *)relativeTimeString:(NSString *)dateString defaultString:(nullable NSString *)defaultString;

@end

NS_ASSUME_NONNULL_END

