//
//  AFNetworkingErrorHelper.h
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// AFNetworking错误信息辅助类
@interface AFNetworkingErrorHelper : NSObject

/// 获取友好的错误提示信息
/// @param error NSError对象
/// @return 友好的错误提示字符串
+ (NSString *)getFriendlyErrorMessage:(NSError *)error;

/// 获取详细的错误信息（用于调试）
/// @param error NSError对象
/// @return 详细的错误信息字符串
+ (NSString *)getDetailedErrorMessage:(NSError *)error;

/// 获取HTTP状态码对应的友好提示
/// @param statusCode HTTP状态码
/// @return 友好的提示信息
+ (NSString *)getHTTPStatusCodeMessage:(NSInteger)statusCode;

/// 判断错误类型并返回对应的友好提示
/// @param error NSError对象
/// @return 错误类型描述（如"网络连接失败"、"请求超时"等）
+ (NSString *)getErrorTypeMessage:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
