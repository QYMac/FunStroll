//
//  DateHelper.m
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import "DateHelper.h"

@implementation DateHelper

+ (nullable NSString *)formatDateString:(NSString *)dateString {
    return [self formatDateString:dateString defaultString:nil];
}

+ (NSString *)formatDateString:(NSString *)dateString defaultString:(nullable NSString *)defaultString {
    if (!dateString || dateString.length == 0) {
        return defaultString ?: @"";
    }
    
    // 日期格式化器
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    inputFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    inputFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    inputFormatter.timeZone = [NSTimeZone systemTimeZone];
    
    // 解析输入日期字符串
    NSDate *date = [inputFormatter dateFromString:dateString];
    if (!date) {
        return defaultString ?: @"";
    }
    
    // 获取当前年份
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger currentYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger dateYear = [calendar component:NSCalendarUnitYear fromDate:date];
    
    // 创建输出格式化器
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    outputFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    outputFormatter.timeZone = [NSTimeZone systemTimeZone];
    
    // 根据是否当年选择格式
    if (dateYear == currentYear) {
        // 当年：返回 MM-dd
        outputFormatter.dateFormat = @"MM-dd";
    } else {
        // 非当年：返回 yyyy-MM-dd
        outputFormatter.dateFormat = @"yyyy-MM-dd";
    }
    
    return [outputFormatter stringFromDate:date];
}

+ (nullable NSString *)relativeTimeString:(NSString *)dateString {
    return [self relativeTimeString:dateString defaultString:nil];
}

+ (NSString *)relativeTimeString:(NSString *)dateString defaultString:(nullable NSString *)defaultString {
    if (!dateString || dateString.length == 0) {
        return defaultString ?: @"";
    }
    
    // 日期格式化器
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    inputFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    inputFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    inputFormatter.timeZone = [NSTimeZone systemTimeZone];
    
    // 解析输入日期字符串
    NSDate *date = [inputFormatter dateFromString:dateString];
    if (!date) {
        return defaultString ?: @"";
    }
    
    // 获取当前时间
    NSDate *now = [NSDate date];
    
    // 如果时间在未来，返回默认值
    if ([date compare:now] == NSOrderedDescending) {
        return defaultString ?: @"";
    }
    
    // 计算时间差（秒）
    NSTimeInterval timeInterval = [now timeIntervalSinceDate:date];
    
    // 使用日历计算更精确的时间差
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond)
                                                fromDate:date
                                                  toDate:now
                                                 options:0];
    
    // 根据时间差返回相应的描述
    if (components.year > 0) {
        return [NSString stringWithFormat:@"%ld年前", (long)components.year];
    } else if (components.month > 0) {
        return [NSString stringWithFormat:@"%ld个月前", (long)components.month];
    } else if (components.day > 0) {
        return [NSString stringWithFormat:@"%ld天前", (long)components.day];
    } else if (components.hour > 0) {
        return [NSString stringWithFormat:@"%ld小时前", (long)components.hour];
    } else if (components.minute > 0) {
        return [NSString stringWithFormat:@"%ld分钟前", (long)components.minute];
    } else if (timeInterval > 0) {
        // 小于1分钟，显示秒数
        NSInteger seconds = (NSInteger)timeInterval;
        return [NSString stringWithFormat:@"%ld秒前", (long)seconds];
    } else {
        // 时间相同或异常情况
        return @"刚刚";
    }
}

@end

