//
//  AFNetworkingManage+Login.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/18.
//

#import "AFNetworkingManage+Login.h"

@implementation AFNetworkingManage (Login)

// 获取阿里云一键登录token
+ (void)LoginPlatform:(NSString *)platform success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = @"/app/fusionAuth/getFusionAuthToken";
    NSDictionary *parameters = @{@"platform":platform};
    [self requestWithUrl:url params:parameters requestType:@"GET" successHanler:success failureHandler:failure];
}

// 获取阿里云一键登录认证结果加手机号码
+ (void)LoginToken:(NSString *)token uccess:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = @"/app/fusionAuth/getVerifyWithFusionAuthToken";
    NSDictionary *parameters = @{@"token":token};
    [self requestWithUrl:url params:parameters requestType:@"GET" successHanler:success failureHandler:failure];
}

// 一键登录接口获取用户信息
+ (void)LoginMobile:(NSString *)mobile grant_type:(NSString *)grant_type scope:(NSString *)scope success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = @"/auth/oauth2/token";
    NSDictionary *parameters = @{@"mobile":mobile,@"grant_type":grant_type,@"scope":scope};
    [self requestWithUrl:url params:parameters requestType:@"POST" successHanler:success failureHandler:failure];
}

// 获取验证码
+ (void)LoginMobile:(NSString *)mobile uccess:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = [NSString stringWithFormat:@"/app/appmobile/%@",mobile];
    //NSDictionary *parameters = @{@"mobile":mobile};
    [self requestWithUrl:url params:@{} requestType:@"GET" successHanler:success failureHandler:failure];
}

// 验证码登录
+ (void)LoginMobile:(NSString *)mobile code:(NSString *)code grant_type:(NSString *)grant_type scope:(NSString *)scope uccess:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = @"/auth/oauth2/token";
    NSDictionary *parameters = @{@"mobile":mobile,@"code":code,@"grant_type":grant_type,@"scope":scope};
    [self requestWithUrl:url params:parameters requestType:@"POST" successHanler:success failureHandler:failure];
}

// 更新token
+ (void)LoginRefresh_token:(NSString *)refresh_token grant_type:(NSString *)grant_type scope:(NSString *)scope uccess:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = @"/api/auth/oauth2/token";
    NSDictionary *parameters = @{@"refresh_token":refresh_token,@"grant_type":grant_type,@"scope":scope};
    [self requestWithUrl:url params:parameters requestType:@"POST" successHanler:success failureHandler:failure];
}

@end
