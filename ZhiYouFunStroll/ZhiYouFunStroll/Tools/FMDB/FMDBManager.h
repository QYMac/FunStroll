//
//  FMDBManager.h
//  PixelCloud
//
//  Created by Qingyun Wei on 2025/2/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMDBManager : NSObject

#pragma mark - 储存
/// 储存首页列表数据
+ (void)saveHomeList:(NSArray *)homeList andHandle:(void (^ _Nullable)(BOOL isSuccess))handle;

/// 储存帖子评论数据
+ (void)saveCommentDict:(NSDictionary *)commentDict andHandle:(void (^ _Nullable)(BOOL isSuccess))handle;

/// 储存探索搜索历史列表
+ (void)saveExploreSearchList:(NSString *)searchText andHandle:(void (^ _Nullable)(BOOL isSuccess))handle;

#pragma mark - 查询
/// 查询首页列表数据
+ (void)searchHomeDataListKeyword:(NSString *)keyword andHandle:(void (^ _Nullable)(NSArray * _Nullable dataArray))handle;

/// 查询帖子评论数据
+ (void)searchCommentAndHandle:(void (^ _Nullable)(NSArray * _Nullable dataArray))handle;

/// 查询探索搜索历史列表
+ (void)searchExploreSearchListAndHandle:(void (^ _Nullable)(NSArray * _Nullable dataArray))handle;

#pragma mark - 删除
/// 删除探索搜索历史
+ (void)deleteExploreSearchText:(NSString *)searchText andHandle:(void (^ _Nullable)(BOOL isSuccess))handle;

#pragma mark - 草稿相关
/// 保存草稿（标题、正文、可见性、图片路径数组）
+ (void)saveDraftWithTitle:(NSString *)title
                   content:(NSString *)content
            visibilityType:(NSInteger)visibilityType
                    images:(NSArray<UIImage *> *)images
                 andHandle:(void (^ _Nullable)(BOOL isSuccess))handle;

/// 查询所有草稿
+ (void)searchDraftListAndHandle:(void (^ _Nullable)(NSArray * _Nullable dataArray))handle;

/// 删除指定草稿
+ (void)deleteDraftWithDraftId:(NSString *)draftId andHandle:(void (^ _Nullable)(BOOL isSuccess))handle;

/// 清空所有草稿
+ (void)clearAllDraftsAndHandle:(void (^ _Nullable)(BOOL isSuccess))handle;

/// 获取草稿图片保存目录
+ (NSString *)draftImagesDirectory;

/// 加载草稿图片
+ (NSArray<UIImage *> *)loadDraftImagesWithPaths:(NSArray<NSString *> *)imagePaths;

@end

NS_ASSUME_NONNULL_END
