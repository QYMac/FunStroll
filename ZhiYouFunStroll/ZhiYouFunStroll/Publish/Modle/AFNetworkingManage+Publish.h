//
//  AFNetworkingManage+Publish.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2026/1/19.
//

#import "AFNetworkingManage.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFNetworkingManage (Publish)

/// 创建用户帖子
+ (void)createPublishTitle:(NSString *)title content:(NSString *)content visibility:(NSString *)visibility resources:(NSArray *)resources success:(SuccessHandler)success failureHandler:(FailureHandler)failure;


@end

NS_ASSUME_NONNULL_END
