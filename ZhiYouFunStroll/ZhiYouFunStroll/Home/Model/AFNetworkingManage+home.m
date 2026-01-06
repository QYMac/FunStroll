//
//  AFNetworkingManage+Home.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/24.
//

#import "AFNetworkingManage+Home.h"

@implementation AFNetworkingManage (Home)

// 获取首页列表
+ (void)homeListCurrent:(NSString *)current size:(NSString *)size keyword:(NSString *)keyword success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = @"/app/appPost/homePage";
    NSDictionary *parameters = @{@"current":current,@"size":size,@"keyword":keyword};
    
    BOOL isToken = NO;
    if ([UserModel sharedUserModel].isAutoLogin == YES) {
        isToken = YES;
    }
    [self requestWithUrl:url params:parameters requestType:@"GET" isBody:NO isToken:isToken successHanler:success failureHandler:failure];
}

// 帖子点赞/取消点赞
+ (void)homeLikePostId:(NSString *)postId success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = [NSString stringWithFormat:@"/app/appPost/toggleLike/%@",postId];
    NSDictionary *parameters = @{};
    [self requestWithUrl:url params:parameters requestType:@"POST" isBody:NO isToken:YES successHanler:success failureHandler:failure];
}

/// 帖子收藏，取消收藏
+ (void)homeCollectPostId:(NSString *)postId success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = [NSString stringWithFormat:@"/app/appPost/toggleCollect/%@",postId];
    NSDictionary *parameters = @{};
    [self requestWithUrl:url params:parameters requestType:@"POST" isBody:NO isToken:YES successHanler:success failureHandler:failure];
}

@end
