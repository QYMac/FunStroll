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
+ (void)LoginToken:(NSString *)token success:(SuccessHandler)success failureHandler:(FailureHandler)failure;

/// 一键登录接口获取用户信息
+ (void)LoginMobile:(NSString *)mobile grant_type:(NSString *)grant_type scope:(NSString *)scope success:(SuccessHandler)success failureHandler:(FailureHandler)failure;

/// 获取验证码
+ (void)LoginMobile:(NSString *)mobile success:(SuccessHandler)success failureHandler:(FailureHandler)failure;

/// 验证码登录
+ (void)LoginMobile:(NSString *)mobile code:(NSString *)code grant_type:(NSString *)grant_type scope:(NSString *)scope success:(SuccessHandler)success failureHandler:(FailureHandler)failure;

/// 更新token
+ (void)LoginRefresh_token:(NSString *)refresh_token grant_type:(NSString *)grant_type scope:(NSString *)scope success:(SuccessHandler)success failureHandler:(FailureHandler)failure;

/// 验证手机号码
+ (void)LoginVerificationPhoneCode:(NSString *)code success:(SuccessHandler)success failureHandler:(FailureHandler)failure;

/// 更换手机号码
+ (void)LoginRefreshPhoneChangeToken:(NSString *)phoneChangeToken newPhone:(NSString *)newPhone code:(NSString *)code success:(SuccessHandler)success failureHandler:(FailureHandler)failure;

/// 检查是否设置了密码
+ (void)LoginIsSetPasswordSuccess:(SuccessHandler)success failureHandler:(FailureHandler)failure;

/// 验证原密码
+ (void)LoginOldPassword:(NSString *)oldPassword success:(SuccessHandler)success failureHandler:(FailureHandler)failure;

/// 设置新密码
+ (void)LoginPasswordChangeToken:(NSString *)phoneChangeToken newPassword:(NSString *)newPassword confirmPassword:(NSString *)confirmPassword success:(SuccessHandler)success failureHandler:(FailureHandler)failure;

@end

NS_ASSUME_NONNULL_END
