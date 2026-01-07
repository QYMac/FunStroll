//
//  CommentListModel.h
//  test
//
//  Created on 2025/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 评论项模型（records 数组中的单个评论）
@interface CommentItem : NSObject

/// 评论ID
@property (nonatomic, strong, nullable) NSString *commentId;

/// 帖子ID
@property (nonatomic, strong, nullable) NSString *postId;

/// 用户ID
@property (nonatomic, strong, nullable) NSString *userId;

/// 父评论ID（回复评论时使用）
@property (nonatomic, strong, nullable) NSString *parentCommentId;

/// 评论内容
@property (nonatomic, strong, nullable) NSString *content;

/// 点赞数
@property (nonatomic, assign) NSInteger likesNumber;

/// 点赞数格式化（如 "1.1万"）
@property (nonatomic, strong, nullable) NSString *likesNumberFormatted;

/// 创建时间（ISO 8601 格式，如 "2025-01-15T10:30:00"）
@property (nonatomic, strong, nullable) NSString *createTime;

/// 状态
@property (nonatomic, strong, nullable) NSString *status;

/// 用户头像
@property (nonatomic, strong, nullable) NSString *userAvatar;

/// 用户昵称
@property (nonatomic, strong, nullable) NSString *userNickname;

/// 是否是作者
@property (nonatomic, assign) BOOL isAuthor;

/// 是否已点赞
@property (nonatomic, assign) BOOL isLiked;

/// 省份
@property (nonatomic, strong, nullable) NSString *province;

/// 资源列表（评论中的图片/视频等）
@property (nonatomic, strong, nullable) NSArray *resources;

@end

/// 评论列表模型（包含响应和分页信息）
@interface CommentListModel : NSObject

/// 响应码
@property (nonatomic, assign) NSInteger code;

/// 消息
@property (nonatomic, strong, nullable) NSString *msg;

/// 评论记录列表
@property (nonatomic, strong, nullable) NSArray<CommentItem *> *records;

/// 总记录数
@property (nonatomic, assign) NSInteger total;

/// 每页大小
@property (nonatomic, assign) NSInteger size;

/// 当前页码
@property (nonatomic, assign) NSInteger current;

/// 总页数
@property (nonatomic, assign) NSInteger pages;

@end

NS_ASSUME_NONNULL_END

