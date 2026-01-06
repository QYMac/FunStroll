//
//  FMDBManager.m
//  PixelCloud
//
//  Created by Qingyun Wei on 2025/2/25.
//

#import "FMDBManager.h"

@implementation FMDBManager

#pragma mark - 储存
// 储存首页列表数据
+ (void)saveHomeList:(NSArray *)homeList andHandle:(void (^ _Nullable)(BOOL isSuccess))handle{
    // 因为首页的数据会随时更新清空表再存新的
    [FMDBTool clearTableWithTab:kHomePageList andHandle:^(BOOL isSuccess) {
        [FMDBTool saveDataListWithTabName:kHomePageList dataList:homeList andHandle:^(BOOL isSuccess) {
            if (isSuccess == YES) {
                NSLog(@"储存首页列表成功！");
            } else {
                NSLog(@"储存首页列表失败！");
            }
            handle(isSuccess);
        }];
    }];
}

// 储存帖子评论数据
+ (void)saveCommentDict:(NSDictionary*)commentDict andHandle:(void (^ _Nullable)(BOOL isSuccess))handle{
    [FMDBTool clearTableWithTab:kCommentData andHandle:^(BOOL isSuccess) {
        [FMDBTool saveDataListWithTabName:kCommentData dataList:@[commentDict] andHandle:^(BOOL isSuccess) {
            if (isSuccess == YES) {
                NSLog(@"储存帖子评论成功！");
            } else {
                NSLog(@"储存帖子评论失败！");
            }
            handle(isSuccess);
        }];
    }];
}

#pragma mark - 查询
+ (void)searchHomeDataListKeyword:(NSString *)keyword andHandle:(void (^ _Nullable)(NSArray * _Nullable homeList))handle{
    
    NSString *conditionStr = [NSString stringWithFormat:@"WHERE title LIKE '%%%@%%';",keyword];
    [FMDBTool searchObjWithTable:kHomePageList condition:conditionStr andHandle:^(NSArray * _Nullable dataArray) {
        handle(dataArray);
    }];
}

/// 查询帖子评论数据
+ (void)searchCommentAndHandle:(void (^ _Nullable)(NSArray * _Nullable commentList))handle{
    [FMDBTool searchObjWithTable:kCommentData condition:@"" andHandle:^(NSArray * _Nullable dataArray) {
        handle(dataArray);
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
