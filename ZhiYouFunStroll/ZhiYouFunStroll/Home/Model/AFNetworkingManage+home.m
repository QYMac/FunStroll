//
//  AFNetworkingManage+Home.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/24.
//

#import "AFNetworkingManage+Home.h"

@implementation AFNetworkingManage (Home)

// 获取首页列表
+ (void)homeCurrent:(NSString *)current size:(NSString *)size keyword:(NSString *)keyword success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = @"/app/appPost/homePage";
    NSDictionary *parameters = @{@"current":current,@"size":size,@"keyword":keyword};
    [self requestWithUrl:url params:parameters requestType:@"GET" isBody:NO successHanler:success failureHandler:failure];
}

@end
