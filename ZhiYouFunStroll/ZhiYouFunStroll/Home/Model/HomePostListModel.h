//
//  HomePostListModel.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2026/01/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 帖子记录模型 (records 中的每条记录)
@interface HomePostRecordModel : NSObject

@property (nonatomic, assign) BOOL collected;           // 是否收藏
@property (nonatomic, copy) NSString *coverImage;       // 封面图片
@property (nonatomic, assign) NSInteger likeCount;      // 点赞数
@property (nonatomic, copy) NSString *likeCountFormatted; // 格式化的点赞数
@property (nonatomic, assign) BOOL liked;               // 是否已点赞
@property (nonatomic, copy) NSString *postId;           // 帖子ID
@property (nonatomic, copy) NSString *title;            // 标题
@property (nonatomic, copy) NSString *userAvatar;       // 用户头像
@property (nonatomic, copy) NSString *userNickname;     // 用户昵称

@end

#pragma mark - 帖子分页模型 (posts)
@interface HomePostsModel : NSObject

@property (nonatomic, assign) NSInteger current;        // 当前页
@property (nonatomic, assign) NSInteger pages;          // 总页数
@property (nonatomic, strong) NSArray<HomePostRecordModel *> *records; // 记录列表
@property (nonatomic, assign) NSInteger size;           // 每页大小
@property (nonatomic, assign) NSInteger total;          // 总数

@end

#pragma mark - 数据模型 (data)
@interface HomePostListDataModel : NSObject

@property (nonatomic, strong) HomePostsModel *posts;    // 帖子分页数据
@property (nonatomic, copy, nullable) NSString *userCard; // 用户卡片
@property (nonatomic, strong) NSArray *dataArr;    // 帖子分页数据

@end

#pragma mark - 首页帖子列表响应模型
@interface HomePostListModel : NSObject

@property (nonatomic, assign) NSInteger code;           // 状态码
@property (nonatomic, copy, nullable) NSString *msg;    // 消息
@property (nonatomic, assign) BOOL ok;                  // 是否成功
@property (nonatomic, strong) HomePostListDataModel *data; // 数据

@end

NS_ASSUME_NONNULL_END
