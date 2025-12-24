//
//  FMDBManager.m
//  PixelCloud
//
//  Created by Qingyun Wei on 2025/2/25.
//

#import "FMDBManager.h"

@implementation FMDBManager

// 储存首页列表数据
+ (void)saveHomeList:(NSDictionary *)homeList andHandle:(void (^ _Nullable)(BOOL isSuccess))handle{
    
    [FMDBTool deleteDataWithTab:kHomePageList key:@"" value:@"" andHandle:^(BOOL isSuccess) {
        [FMDBTool saveDataListWithTabName:kHomePageList dataList:@[homeList] andHandle:^(BOOL isSuccess) {
            if (isSuccess == YES) {
                NSLog(@"储存首页列表成功！");
            } else {
                NSLog(@"储存首页列表失败！");
            }
            handle(isSuccess);
        }];
    }];
}

//获取当前GMT时间
+ (NSString *)save_currentGMTWithFormater:(NSString *)dateFormat {
    
    NSDate *date = [NSDate date];
    NSTimeZone *gmtStr = [NSTimeZone timeZoneWithName:@"GMT"];
    [NSTimeZone setDefaultTimeZone:gmtStr];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    dateFormater.dateFormat = dateFormat;
    dateFormater.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    return [CheckTool replaceNullValue:[dateFormater stringFromDate:date]];
}

@end
