//
//  AFNetworkingManage+Login.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/18.
//

#import "AFNetworkingManage.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFNetworkingManage (Login)

/// 获取阿里云一键登录token
+ (void)LoginPlatform:(NSString *)platform success:(SuccessHandler)success failureHandler:(FailureHandler)failure;

/// 获取阿里云一键登录认证结果加手机号码
+ (void)LoginToken:(NSString *)token uccess:(SuccessHandler)success failureHandler:(FailureHandler)failure;

/// 一键登录接口获取用户信息
+ (void)LoginMobile:(NSString *)mobile grant_type:(NSString *)grant_type scope:(NSString *)scope success:(SuccessHandler)success failureHandler:(FailureHandler)failure;

/// 获取验证码
+ (void)LoginMobile:(NSString *)mobile uccess:(SuccessHandler)success failureHandler:(FailureHandler)failure;

/// 验证码登录
+ (void)LoginMobile:(NSString *)mobile code:(NSString *)code grant_type:(NSString *)grant_type scope:(NSString *)scope uccess:(SuccessHandler)success failureHandler:(FailureHandler)failure;

/// 更新token
+ (void)LoginRefresh_token:(NSString *)refresh_token grant_type:(NSString *)grant_type scope:(NSString *)scope uccess:(SuccessHandler)success failureHandler:(FailureHandler)failure;

@end

NS_ASSUME_NONNULL_END
