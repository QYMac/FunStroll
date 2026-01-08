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
    [self requestWithUrl:url params:parameters requestType:@"GET" isBody:NO isToken:NO successHanler:success failureHandler:failure];
}

// 获取阿里云一键登录认证结果加手机号码
+ (void)LoginToken:(NSString *)token success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = @"/app/fusionAuth/getVerifyWithFusionAuthToken";
    NSDictionary *parameters = @{@"token":token};
    [self requestWithUrl:url params:parameters requestType:@"GET" isBody:NO isToken:NO successHanler:success failureHandler:failure];
}

// 一键登录接口获取用户信息
+ (void)LoginMobile:(NSString *)mobile grant_type:(NSString *)grant_type scope:(NSString *)scope loginLocation:(NSString *)loginLocation deviceInfo:(NSString *)deviceInfo code:(NSString *)code success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = @"/auth/oauth2/token";
    NSDictionary *parameters = @{@"mobile":mobile,@"grant_type":grant_type,@"scope":scope,@"loginLocation":loginLocation,@"deviceInfo":deviceInfo,@"appVersion":[UserModel sharedUserModel].app_Version,@"code":code};
    [self requestWithUrl:url params:parameters requestType:@"POST" isBody:NO isToken:NO successHanler:success failureHandler:failure];
}

// 获取验证码
+ (void)LoginMobile:(NSString *)mobile success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = [NSString stringWithFormat:@"/app/appmobile/%@",mobile];
    //NSDictionary *parameters = @{@"mobile":mobile};
    [self requestWithUrl:url params:@{} requestType:@"GET" isBody:NO isToken:NO successHanler:success failureHandler:failure];
}

// 验证码登录
+ (void)LoginMobile:(NSString *)mobile code:(NSString *)code grant_type:(NSString *)grant_type scope:(NSString *)scope loginLocation:(NSString *)loginLocation deviceInfo:(NSString *)deviceInfo success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = @"/auth/oauth2/token";
    NSDictionary *parameters = @{@"mobile":mobile,@"code":code,@"grant_type":grant_type,@"scope":scope,@"loginLocation":loginLocation,@"deviceInfo":deviceInfo,@"appVersion":[UserModel sharedUserModel].app_Version};
    [self requestWithUrl:url params:parameters requestType:@"POST" isBody:NO isToken:NO successHanler:success failureHandler:failure];
}

// 账号密码登录
+ (void)LoginUsername:(NSString *)username password:(NSString *)password grant_type:(NSString *)grant_type scope:(NSString *)scope mobile:(NSString *)mobile loginLocation:(NSString *)loginLocation deviceInfo:(NSString *)deviceInfo success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = @"/auth/oauth2/token";
    NSDictionary *parameters = @{@"username":username,@"password":password,@"grant_type":grant_type,@"scope":scope,@"mobile":mobile,@"loginLocation":loginLocation,@"deviceInfo":deviceInfo,@"appVersion":[UserModel sharedUserModel].app_Version};
    [self requestWithUrl:url params:parameters requestType:@"POST" isBody:NO isToken:NO successHanler:success failureHandler:failure];
}

// 更新token
+ (void)LoginRefresh_token:(NSString *)refresh_token grant_type:(NSString *)grant_type scope:(NSString *)scope success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = @"/api/auth/oauth2/token";
    NSDictionary *parameters = @{@"refresh_token":refresh_token,@"grant_type":grant_type,@"scope":scope};
    [self requestWithUrl:url params:parameters requestType:@"POST" isBody:NO isToken:NO successHanler:success failureHandler:failure];
}

// 验证手机号码
+ (void)LoginVerificationPhoneCode:(NSString *)code success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = @"/app/appuser/verifyOldPhone";
    NSDictionary *parameters = @{@"code":code};
    [self requestWithUrl:url params:parameters requestType:@"POST" isBody:YES isToken:YES successHanler:success failureHandler:failure];
}

// 更换手机号码
+ (void)LoginRefreshPhoneChangeToken:(NSString *)phoneChangeToken newPhone:(NSString *)newPhone code:(NSString *)code success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = @"/app/appuser/bindNewPhone";
    NSDictionary *parameters = @{@"phoneChangeToken":phoneChangeToken,@"newPhone":newPhone,@"code":code};
    [self requestWithUrl:url params:parameters requestType:@"POST" isBody:YES isToken:YES successHanler:success failureHandler:failure];
}

// 检查是否设置了密码
+ (void)LoginIsSetPasswordSuccess:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = @"/app/appuser/password/status";
    NSDictionary *parameters = @{};
    [self requestWithUrl:url params:parameters requestType:@"GET" isBody:YES isToken:YES successHanler:success failureHandler:failure];
}

// 验证原密码
+ (void)LoginOldPassword:(NSString *)oldPassword success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = @"/app/appuser/password/verify";
    NSDictionary *parameters = @{@"oldPassword":oldPassword};
    [self requestWithUrl:url params:parameters requestType:@"POST" isBody:YES isToken:YES successHanler:success failureHandler:failure];
}

// 设置新密码
+ (void)LoginPasswordChangeToken:(NSString *)passwordChangeToken newPassword:(NSString *)newPassword confirmPassword:(NSString *)confirmPassword success:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    NSString *url = @"/app/appuser/password/set";
    NSDictionary *parameters = @{@"passwordChangeToken":passwordChangeToken,@"newPassword":newPassword,@"confirmPassword":confirmPassword};
    [self requestWithUrl:url params:parameters requestType:@"POST" isBody:YES isToken:YES successHanler:success failureHandler:failure];
}


@end
