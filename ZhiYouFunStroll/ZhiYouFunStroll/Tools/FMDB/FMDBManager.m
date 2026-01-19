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

#pragma mark - 草稿相关
// 获取草稿图片保存目录
+ (NSString *)draftImagesDirectory {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *draftImagesPath = [documentsPath stringByAppendingPathComponent:@"DraftImages"];
    
    // 创建目录（如果不存在）
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:draftImagesPath]) {
        [fileManager createDirectoryAtPath:draftImagesPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return draftImagesPath;
}

// 保存草稿
+ (void)saveDraftWithTitle:(NSString *)title
                   content:(NSString *)content
            visibilityType:(NSInteger)visibilityType
                    images:(NSArray<UIImage *> *)images
                 andHandle:(void (^ _Nullable)(BOOL isSuccess))handle {
    
    // 生成唯一草稿ID
    NSString *draftId = [NSString stringWithFormat:@"%lld", (long long)([[NSDate date] timeIntervalSince1970] * 1000)];
    
    // 保存图片到本地，获取文件名数组（只存文件名，不存绝对路径）
    NSMutableArray *imageNames = [NSMutableArray array];
    NSString *draftImagesDir = [self draftImagesDirectory];
    
    NSLog(@"草稿图片保存目录: %@", draftImagesDir);
    NSLog(@"待保存图片数量: %lu", (unsigned long)images.count);
    
    for (NSInteger i = 0; i < images.count; i++) {
        UIImage *image = images[i];
        NSString *imageName = [NSString stringWithFormat:@"%@_%ld.jpg", draftId, (long)i];
        NSString *imagePath = [draftImagesDir stringByAppendingPathComponent:imageName];
        
        // 压缩并保存图片
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        if (imageData && [imageData writeToFile:imagePath atomically:YES]) {
            // 只存储文件名，不存储绝对路径
            [imageNames addObject:imageName];
            NSLog(@"草稿图片保存成功: %@", imageName);
        } else {
            NSLog(@"草稿图片保存失败: %@", imagePath);
        }
    }
    
    NSLog(@"成功保存 %lu 张草稿图片", (unsigned long)imageNames.count);
    
    // 将图片文件名数组转换为JSON字符串
    NSString *imagePathsJson = @"";
    if (imageNames.count > 0) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:imageNames options:0 error:nil];
        imagePathsJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    // 获取当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *createTime = [formatter stringFromDate:[NSDate date]];
    
    // 构建草稿数据
    NSDictionary *draftDict = @{
        @"draftId": draftId,
        @"title": [CheckTool replaceNullValue:title],
        @"content": [CheckTool replaceNullValue:content],
        @"visibilityType": @(visibilityType),
        @"imagePaths": imagePathsJson,
        @"createTime": createTime
    };
    
    // 保存到数据库
    [FMDBTool saveDataListWithTabName:kPublishDraftList dataDict:draftDict andHandle:^(BOOL isSuccess) {
        if (isSuccess) {
            NSLog(@"保存草稿成功！");
        } else {
            NSLog(@"保存草稿失败！");
        }
        if (handle) {
            handle(isSuccess);
        }
    }];
}

// 查询所有草稿
+ (void)searchDraftListAndHandle:(void (^ _Nullable)(NSArray * _Nullable dataArray))handle {
    [FMDBTool searchObjWithTable:kPublishDraftList condition:@"ORDER BY createTime DESC" andHandle:^(NSArray * _Nullable dataArray) {
        if (handle) {
            handle(dataArray);
        }
    }];
}

// 删除指定草稿
+ (void)deleteDraftWithDraftId:(NSString *)draftId andHandle:(void (^ _Nullable)(BOOL isSuccess))handle {
    // 先查询草稿获取图片路径
    NSDictionary *draft = [FMDBTool searchObjWithTable:kPublishDraftList key:@"draftId" value:draftId];
    
    // 删除本地图片文件
    if (draft) {
        NSString *imagePathsJson = draft[@"imagePaths"];
        if (imagePathsJson.length > 0) {
            NSData *jsonData = [imagePathsJson dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *imagePaths = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            for (NSString *path in imagePaths) {
                if ([fileManager fileExistsAtPath:path]) {
                    [fileManager removeItemAtPath:path error:nil];
                }
            }
        }
    }
    
    // 删除数据库记录
    [FMDBTool deleteDataWithTab:kPublishDraftList key:@"draftId" value:[CheckTool replaceNullValue:draftId] andHandle:^(BOOL isSuccess) {
        if (handle) {
            handle(isSuccess);
        }
    }];
}

// 清空所有草稿
+ (void)clearAllDraftsAndHandle:(void (^ _Nullable)(BOOL isSuccess))handle {
    // 删除所有草稿图片
    NSString *draftImagesDir = [self draftImagesDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager contentsOfDirectoryAtPath:draftImagesDir error:nil];
    for (NSString *file in files) {
        NSString *filePath = [draftImagesDir stringByAppendingPathComponent:file];
        [fileManager removeItemAtPath:filePath error:nil];
    }
    
    // 清空数据库表
    [FMDBTool clearTableWithTab:kPublishDraftList andHandle:^(BOOL isSuccess) {
        if (handle) {
            handle(isSuccess);
        }
    }];
}

// 加载草稿图片（从文件名数组加载多张图片）
+ (NSArray<UIImage *> *)loadDraftImagesWithPaths:(NSArray<NSString *> *)imageNames {
    NSMutableArray *images = [NSMutableArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *draftImagesDir = [self draftImagesDirectory];
    
    for (NSString *name in imageNames) {
        if (![name isKindOfClass:[NSString class]] || name.length == 0) {
            NSLog(@"无效的图片名称");
            continue;
        }
        
        // 判断是文件名还是完整路径
        NSString *fullPath;
        if ([name hasPrefix:@"/"]) {
            // 兼容旧数据：如果是完整路径，尝试提取文件名
            fullPath = [draftImagesDir stringByAppendingPathComponent:[name lastPathComponent]];
        } else {
            // 新数据：文件名，拼接完整路径
            fullPath = [draftImagesDir stringByAppendingPathComponent:name];
        }
        
        if ([fileManager fileExistsAtPath:fullPath]) {
            UIImage *image = [UIImage imageWithContentsOfFile:fullPath];
            if (image) {
                [images addObject:image];
                NSLog(@"加载草稿图片成功: %@", fullPath);
            } else {
                NSLog(@"加载草稿图片失败，图片为nil: %@", fullPath);
            }
        } else {
            NSLog(@"草稿图片文件不存在: %@", fullPath);
        }
    }
    
    NSLog(@"共加载 %lu 张草稿图片", (unsigned long)images.count);
    return [images copy];
}

@end
