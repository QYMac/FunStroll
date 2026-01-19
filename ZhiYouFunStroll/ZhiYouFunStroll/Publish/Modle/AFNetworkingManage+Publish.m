//
//  AFNetworkingManage+Publish.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2026/1/19.
//

#import "AFNetworkingManage+Publish.h"

@implementation AFNetworkingManage (Publish)

/// 创建用户帖子
+ (void)createPublishTitle:(NSString *)title content:(NSString *)content visibility:(NSString *)visibility resources:(NSArray *)resources success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = @"/app/appPost/publishDirect";
    NSDictionary *parameters = @{@"title":title,@"content":content,@"visibility":visibility,@"resources":resources};
    [self requestWithUrl:url params:parameters requestType:@"POST" isBody:YES isToken:YES successHanler:success failureHandler:failure];
}

@end
