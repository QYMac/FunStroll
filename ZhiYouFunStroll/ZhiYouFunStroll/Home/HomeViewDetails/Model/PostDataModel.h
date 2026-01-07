//
//  PostDataModel.h
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import <Foundation/Foundation.h>
#import "ResourceModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 帖子数据模型
@interface PostDataModel : NSObject

/// 收藏数
@property (nonatomic, assign) NSInteger collectCount;

/// 是否已收藏
@property (nonatomic, assign) NSInteger collected;

/// 评论数
@property (nonatomic, assign) NSInteger commentCount;

/// 内容
@property (nonatomic, strong, nullable) NSString *content;

/// 创建者
@property (nonatomic, strong, nullable) NSString *createBy;

/// 创建时间
@property (nonatomic, strong, nullable) NSString *createTime;

/// 创建时间格式化
@property (nonatomic, strong, nullable) NSString *createTimeFormatted;

/// 下架原因
@property (nonatomic, strong, nullable) NSString *delistReason;

/// 下架时间
@property (nonatomic, strong, nullable) NSString *delistTime;

/// 是否可编辑
@property (nonatomic, assign) NSInteger editable;

/// 点赞数
@property (nonatomic, assign) NSInteger likeCount;

/// 点赞数格式化
@property (nonatomic, strong, nullable) NSString *likeCountFormatted;

/// 是否已点赞
@property (nonatomic, assign) NSInteger liked;

/// 操作者
@property (nonatomic, strong, nullable) NSString *operator;

/// 帖子ID
@property (nonatomic, strong, nullable) NSString *postId;

/// 省份
@property (nonatomic, strong, nullable) NSString *province;

/// 发布时间
@property (nonatomic, strong, nullable) NSString *publishTime;

/// 排名分数
@property (nonatomic, strong, nullable) NSString *rankingScore;

/// 阅读数
@property (nonatomic, assign) NSInteger readCount;

/// 资源列表
@property (nonatomic, strong, nullable) NSArray<ResourceModel *> *resources;

/// 分享数
@property (nonatomic, assign) NSInteger shareCount;

/// 排序
@property (nonatomic, assign) NSInteger sort;

/// 来源类型
@property (nonatomic, strong, nullable) NSString *sourceType;

/// 状态
@property (nonatomic, strong, nullable) NSString *status;

/// 标题
@property (nonatomic, strong, nullable) NSString *title;

/// 行程ID
@property (nonatomic, strong, nullable) NSString *tripId;

/// 更新者
@property (nonatomic, strong, nullable) NSString *updateBy;

/// 更新时间
@property (nonatomic, strong, nullable) NSString *updateTime;

/// 更新时间格式化
@property (nonatomic, strong, nullable) NSString *updateTimeFormatted;

/// 用户头像
@property (nonatomic, strong, nullable) NSString *userAvatar;

/// 用户ID
@property (nonatomic, strong, nullable) NSString *userId;

/// 用户昵称
@property (nonatomic, strong, nullable) NSString *userNickname;

/// 用户名
@property (nonatomic, strong, nullable) NSString *username;

/// 可见性
@property (nonatomic, strong, nullable) NSString *visibility;

/// 权重
@property (nonatomic, assign) NSInteger weight;

@end

NS_ASSUME_NONNULL_END

