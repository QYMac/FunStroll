//
//  AFNetworkingManage+Mine.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/17.
//

#import "AFNetworkingManage+Mine.h"

@implementation AFNetworkingManage (Mine)

+ (void)GetAlibabaCloudTokenPlatform:(NSString *)platform success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = @"/app/fusionAuth/getFusionAuthToken";
    NSDictionary *parameters = @{@"platform":platform};
    [self requestWithUrl:url params:parameters requestType:@"GET" successHanler:success failureHandler:failure];
}

@end
