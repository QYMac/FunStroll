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
            if (handle) {
                handle(isSuccess);
            }
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
            if (handle) {
                handle(isSuccess);
            }
        }];
    }];
}

// 储存探索搜索历史列表
+ (void)saveExploreSearchList:(NSString *)searchText andHandle:(void (^ _Nullable)(BOOL isSuccess))handle{
    NSDictionary *dict = @{@"searchText":[CheckTool replaceNullValue:searchText]};
    [FMDBTool saveDataListWithTabName:kExploreSearchList dataDict:dict andHandle:^(BOOL isSuccess) {
        if (handle) {
            handle(isSuccess);
        }
    }];
}

#pragma mark - 查询
+ (void)searchHomeDataListKeyword:(NSString *)keyword andHandle:(void (^ _Nullable)(NSArray * _Nullable dataArray))handle{
    
    NSString *conditionStr = [NSString stringWithFormat:@"WHERE title LIKE '%%%@%%';",keyword];
    [FMDBTool searchObjWithTable:kHomePageList condition:conditionStr andHandle:^(NSArray * _Nullable dataArray) {
        if (handle) {
            handle(dataArray);
        }
    }];
}

// 查询帖子评论数据
+ (void)searchCommentAndHandle:(void (^ _Nullable)(NSArray * _Nullable dataArray))handle{
    [FMDBTool searchObjWithTable:kCommentData condition:@"" andHandle:^(NSArray * _Nullable dataArray) {
        if (handle) {
            handle(dataArray);
        }
    }];
}

// 查询探索搜索历史列表
+ (void)searchExploreSearchListAndHandle:(void (^ _Nullable)(NSArray * _Nullable dataArray))handle{
    [FMDBTool searchObjWithTable:kExploreSearchList condition:@"" andHandle:^(NSArray * _Nullable dataArray) {
        if (handle) {
            handle(dataArray);
        }
    }];
}


#pragma mark - 删除
// 删除探索搜索历史
+ (void)deleteExploreSearchText:(NSString *)searchText andHandle:(void (^ _Nullable)(BOOL isSuccess))handle{
    [FMDBTool deleteDataWithTab:kExploreSearchList key:@"searchText" value:[CheckTool replaceNullValue:searchText] andHandle:^(BOOL isSuccess) {
        if (handle) {
            handle(isSuccess);
        }
    }];
}

@end
