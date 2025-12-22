//
//  FMDBManager.m
//  PixelCloud
//
//  Created by Qingyun Wei on 2025/2/25.
//

#import "FMDBManager.h"

@implementation FMDBManager



//获取当前GMT时间
+ (NSString *)save_currentGMTWithFormater:(NSString *)dateFormat {
    NSDate *date = [NSDate date];
    NSTimeZone *gmtStr = [NSTimeZone timeZoneWithName:@"GMT"];
    [NSTimeZone setDefaultTimeZone:gmtStr];
    NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
    dateFormater.dateFormat= dateFormat;
    dateFormater.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    return [CheckTool replaceNullValue:[dateFormater stringFromDate:date]];
}

@end
