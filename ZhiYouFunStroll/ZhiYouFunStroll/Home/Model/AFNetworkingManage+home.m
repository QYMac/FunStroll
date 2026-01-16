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
    [self requestWithUrl:url params:parameters requestType:@"GET" isBody:NO isToken:YES successHanler:success failureHandler:failure];
}

// 帖子点赞/取消点赞
+ (void)homeLikePostId:(NSString *)postId success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = [NSString stringWithFormat:@"/app/appPost/toggleLike/%@",postId];
    NSDictionary *parameters = @{};
    [self requestWithUrl:url params:parameters requestType:@"POST" isBody:YES isToken:YES successHanler:success failureHandler:failure];
}

/// 帖子收藏，取消收藏
+ (void)homeCollectPostId:(NSString *)postId success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = [NSString stringWithFormat:@"/app/appPost/toggleCollect/%@",postId];
    NSDictionary *parameters = @{};
    [self requestWithUrl:url params:parameters requestType:@"POST" isBody:YES isToken:YES successHanler:success failureHandler:failure];
}

/// 获取帖子详情
+ (void)homeGetDetailsPostId:(NSString *)postId success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = [NSString stringWithFormat:@"/app/appPost/%@",postId];
    NSDictionary *parameters = @{};
    [self requestWithUrl:url params:parameters requestType:@"GET" isBody:NO isToken:YES successHanler:success failureHandler:failure];
}

// 获取评论列表
+ (void)homeGetDetailsCommentPostId:(NSString *)postId current:(NSString *)current size:(NSString *)size sortType:(NSString *)sortType userId:(NSString *)userId keyword:(NSString *)keyword success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = @"/app/appPostComment/page";
    NSDictionary *parameters = @{@"postId":postId,@"current":current,@"size":size,@"sortType":sortType,@"userId":userId,@"keyword":keyword};
    [self requestWithUrl:url params:parameters requestType:@"GET" isBody:NO isToken:YES successHanler:success failureHandler:failure];
}

/// 添加评论
+ (void)homeAddCommentPostId:(NSString *)postId parentCommentId:(NSString *)parentCommentId content:(NSString *)content resources:(NSArray *)resources success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = @"/app/appPostComment/insertComment";
    NSDictionary *parameters = @{@"postId":postId,@"content":content,@"parentCommentId":parentCommentId,@"resources":resources};
    [self requestWithUrl:url params:parameters requestType:@"POST" isBody:YES isToken:YES successHanler:success failureHandler:failure];
}


// 上传图片
+ (void)uploadImageList:(NSArray *)imageList success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = @"/app/appPost/uploadImage";
    NSDictionary *parameters = @{};
    //[self requestImageWithUrl:url params:parameters requestType:@"POST" imageList:imageList successHanler:success failureHandler:failure];
    [self uploadPostImages:imageList imgAuditServiceType:@"app" successHanler:success failureHandler:failure];
}

@end
