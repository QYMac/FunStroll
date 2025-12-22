//
//  NSString+TimeFormatter.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/12.
//

#import "NSString+TimeFormatter.h"

@implementation NSString (TimeFormatter)

+ (NSString *)formatTimeFromSeconds:(NSInteger)totalSeconds {
    if (totalSeconds < 0) {
        return @"0分钟";
    }
    
    NSInteger hours = totalSeconds / 3600;
    NSInteger minutes = (totalSeconds % 3600) / 60;
    NSInteger seconds = totalSeconds % 60;
    
    // 处理分钟数（如果有剩余秒数，分钟数加1）
    if (totalSeconds < 3600) {
        // 1小时内
        if (seconds > 0) {
            minutes += 1;
        }
        // 如果总秒数小于60秒，但大于0秒，确保显示1分钟
        if (totalSeconds > 0 && minutes == 0) {
            minutes = 1;
        }
        return [NSString stringWithFormat:@"%ld分钟", (long)minutes];
    } else {
        // 1小时以上
        // 处理分钟数，如果有剩余秒数，分钟数加1
        if (seconds > 0) {
            minutes += 1;
        }
        // 如果分钟数达到60，则进位到小时
        if (minutes >= 60) {
            hours += minutes / 60;
            minutes = minutes % 60;
        }
        
        if (minutes > 0) {
            return [NSString stringWithFormat:@"%ld小时%ld分钟", (long)hours, (long)minutes];
        } else {
            return [NSString stringWithFormat:@"%ld小时", (long)hours];
        }
    }
}

@end
