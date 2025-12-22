//
//  AFNetworkingManage+Mine.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/17.
//

#import "AFNetworkingManage.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFNetworkingManage (Mine)

+ (void)GetAlibabaCloudTokenPlatform:(NSString *)platform success:(SuccessHandler)success failureHandler:(FailureHandler)failure;


@end

NS_ASSUME_NONNULL_END
