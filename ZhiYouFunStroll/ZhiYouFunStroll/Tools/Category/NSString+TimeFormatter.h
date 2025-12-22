//
//  NSString+TimeFormatter.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (TimeFormatter)
/// 少于 1 小时（0-3599秒）：显示分钟（不足 1 分钟的显示 1 分钟）
/// 1 小时以上（≥3600秒）：显示 "X小时Y分钟"
/// 特殊要求：45秒 → 1分钟，125秒 → 2分钟，3665秒 → 1小时1分钟
+ (NSString *)formatTimeFromSeconds:(NSInteger)totalSeconds;

@end

NS_ASSUME_NONNULL_END
