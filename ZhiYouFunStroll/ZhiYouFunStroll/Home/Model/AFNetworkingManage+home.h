//
//  AFNetworkingManage+Home.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/24.
//

#import "AFNetworkingManage.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFNetworkingManage (Home)

/// 获取首页列表
+ (void)homeListCurrent:(NSString *)current size:(NSString *)size keyword:(NSString *)keyword success:(SuccessHandler)success failureHandler:(FailureHandler)failure;

/// 帖子点赞，取消点赞
+ (void)homeLikePostId:(NSString *)postId success:(SuccessHandler)success failureHandler:(FailureHandler)failure;

/// 帖子收藏，取消收藏
+ (void)homeCollectPostId:(NSString *)postId success:(SuccessHandler)success failureHandler:(FailureHandler)failure;

@end

NS_ASSUME_NONNULL_END
