//
//  ResourceModel.h
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 资源模型
@interface ResourceModel : NSObject

/// 评论ID
@property (nonatomic, strong, nullable) NSString *commentId;

/// 创建者
@property (nonatomic, strong, nullable) NSString *createBy;

/// 创建时间
@property (nonatomic, strong, nullable) NSString *createTime;

/// 删除标志
@property (nonatomic, assign) NSInteger delFlag;

/// 描述
@property (nonatomic, strong, nullable) NSString *desc;

/// 视频URL
@property (nonatomic, strong, nullable) NSString *movUrl;

/// 帖子ID
@property (nonatomic, strong, nullable) NSString *postId;

/// 资源ID
@property (nonatomic, strong, nullable) NSString *resourceId;

/// 资源类型
@property (nonatomic, assign) NSInteger resourceType;

/// 资源类型枚举
@property (nonatomic, strong, nullable) NSString *resourceTypeEnum;

/// 资源URL
@property (nonatomic, strong, nullable) NSString *resourceUrl;

/// 排序
@property (nonatomic, assign) NSInteger sort;

/// 更新者
@property (nonatomic, strong, nullable) NSString *updateBy;

/// 更新时间
@property (nonatomic, strong, nullable) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END

