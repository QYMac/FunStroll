//
//  AFNetworkingErrorHelper.m
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import "AFNetworkingErrorHelper.h"

@implementation AFNetworkingErrorHelper

+ (NSString *)getFriendlyErrorMessage:(NSError *)error {
    if (!error) {
        return @"未知错误";
    }
    
    // 1. 首先检查是否是网络连接错误
    NSString *networkMessage = [self getNetworkErrorMessage:error];
    if (networkMessage) {
        return networkMessage;
    }
    
    // 2. 检查是否是超时错误
    NSString *timeoutMessage = [self getTimeoutErrorMessage:error];
    if (timeoutMessage) {
        return timeoutMessage;
    }
    
    // 3. 检查是否有HTTP状态码
    NSInteger statusCode = [self getHTTPStatusCode:error];
    if (statusCode > 0) {
        NSString *statusMessage = [CheckTool replaceNullValue:[self getHTTPStatusCodeMessage:statusCode]];
        if (statusMessage && statusMessage.length > 0) {
            // 尝试从服务器响应中获取错误信息
            NSString *serverMessage = [self getServerErrorMessage:error];
            if (serverMessage && serverMessage.length > 0) {
                //return [NSString stringWithFormat:@"%@：%@", statusMessage, serverMessage];
                return serverMessage;
            }
            return statusMessage;
        }
    }
    
    // 4. 尝试从服务器响应中获取错误信息
    NSString *serverMessage = [self getServerErrorMessage:error];
    if (serverMessage && serverMessage.length > 0) {
        return serverMessage;
    }
    
    // 5. 使用错误描述
    if (error.localizedDescription && error.localizedDescription.length > 0) {
        return error.localizedDescription;
    }
    
    return @"请求失败，请稍后重试";
}

+ (NSString *)getDetailedErrorMessage:(NSError *)error {
    if (!error) {
        return @"未知错误";
    }
    
    NSMutableString *message = [NSMutableString string];
    
    // 友好提示
    NSString *friendlyMessage = [self getFriendlyErrorMessage:error];
    [message appendString:friendlyMessage];
    
    // 添加详细信息（用于调试）
    [message appendString:@"\n\n[调试信息]"];
    [message appendFormat:@"\n错误域: %@", error.domain ?: @"未知"];
    [message appendFormat:@"\n错误代码: %ld", (long)error.code];
    
    NSInteger statusCode = [self getHTTPStatusCode:error];
    if (statusCode > 0) {
        [message appendFormat:@"\nHTTP状态码: %ld", (long)statusCode];
    }
    
    NSString *requestURL = [self getRequestURL:error];
    if (requestURL) {
        [message appendFormat:@"\n请求URL: %@", requestURL];
    }
    
    NSString *responseString = [self getResponseString:error];
    if (responseString && responseString.length > 0) {
        // 只显示前500个字符
        NSString *shortResponse = responseString.length > 500 ?
            [responseString substringToIndex:500] : responseString;
        [message appendFormat:@"\n服务器响应: %@", shortResponse];
    }
    
    return [message copy];
}

+ (NSString *)getHTTPStatusCodeMessage:(NSInteger)statusCode {
    switch (statusCode) {
        case 400:
            return @"请求参数错误";
        case 401:
            return @"未授权，请重新登录";
        case 403:
            return @"访问被拒绝";
        case 404:
            return @"请求的资源不存在";
        case 405:
            return @"请求方法不被允许";
        case 408:
            return @"请求超时";
        case 409:
            return @"资源冲突";
        case 413:
            return @"请求数据过大";
        case 414:
            return @"请求URL过长";
        case 415:
            return @"不支持的媒体类型";
        case 422:
            return @"请求参数验证失败";
        case 429:
            return @"请求过于频繁，请稍后重试";
        case 500:
            return @"服务器内部错误";
        case 501:
            return @"服务器不支持该功能";
        case 502:
            return @"网关错误";
        case 503:
            return @"服务暂不可用，请稍后重试";
        case 504:
            return @"网关超时";
        default:
            if (statusCode >= 400 && statusCode < 500) {
                return @"客户端请求错误";
            } else if (statusCode >= 500 && statusCode < 600) {
                return @"服务器错误";
            }
            return nil;
    }
}

+ (NSString *)getErrorTypeMessage:(NSError *)error {
    if (!error) {
        return @"未知错误";
    }
    
    // 检查网络错误
    NSString *networkMessage = [self getNetworkErrorMessage:error];
    if (networkMessage) {
        return @"网络连接错误";
    }
    
    // 检查超时错误
    NSString *timeoutMessage = [self getTimeoutErrorMessage:error];
    if (timeoutMessage) {
        return @"请求超时";
    }
    
    // 检查HTTP错误
    NSInteger statusCode = [self getHTTPStatusCode:error];
    if (statusCode > 0) {
        if (statusCode >= 400 && statusCode < 500) {
            return @"客户端错误";
        } else if (statusCode >= 500 && statusCode < 600) {
            return @"服务器错误";
        }
        return @"HTTP错误";
    }
    
    return @"未知错误";
}

#pragma mark - Private Methods

+ (NSString *)getNetworkErrorMessage:(NSError *)error {
    if (!error) {
        return nil;
    }
    
    NSString *domain = error.domain;
    if (!domain || domain.length == 0) {
        return nil;
    }
    
    NSInteger code = error.code;
    
    // NSURLErrorDomain 表示网络相关错误
    if ([domain isEqualToString:NSURLErrorDomain]) {
        switch (code) {
            case NSURLErrorNotConnectedToInternet:
                return @"网络连接失败，请检查网络设置";
            case NSURLErrorNetworkConnectionLost:
                return @"网络连接已断开，请重试";
            case NSURLErrorCannotFindHost:
                return @"无法找到服务器，请检查网络连接";
            case NSURLErrorCannotConnectToHost:
                return @"无法连接到服务器，请稍后重试";
            case NSURLErrorDNSLookupFailed:
                return @"DNS解析失败，请检查网络连接";
            case NSURLErrorInternationalRoamingOff:
                return @"已关闭国际漫游，无法连接网络";
            case NSURLErrorCallIsActive:
                return @"正在通话中，无法连接网络";
            case NSURLErrorDataNotAllowed:
                return @"当前网络不允许数据连接";
            case NSURLErrorSecureConnectionFailed:
                return @"安全连接失败，请稍后重试";
            case NSURLErrorServerCertificateHasBadDate:
            case NSURLErrorServerCertificateUntrusted:
            case NSURLErrorServerCertificateHasUnknownRoot:
            case NSURLErrorServerCertificateNotYetValid:
                return @"服务器证书验证失败";
            case NSURLErrorClientCertificateRejected:
                return @"客户端证书被拒绝";
            case NSURLErrorClientCertificateRequired:
                return @"需要客户端证书";
            case NSURLErrorCannotLoadFromNetwork:
                return @"无法从网络加载数据";
            default:
                return @"网络连接失败，请检查网络设置";
        }
    }
    
    return nil;
}

+ (NSString *)getTimeoutErrorMessage:(NSError *)error {
    if (!error) {
        return nil;
    }
    
    NSString *domain = error.domain;
    if (!domain || domain.length == 0) {
        return nil;
    }
    
    NSInteger code = error.code;
    
    // 超时错误
    if ([domain isEqualToString:NSURLErrorDomain] && code == NSURLErrorTimedOut) {
        return @"请求超时，请检查网络连接后重试";
    }
    
    // 检查错误描述中是否包含超时关键词
    NSString *description = error.localizedDescription;
    if (description && description.length > 0) {
        NSString *lowercaseDescription = description.lowercaseString;
        if ([lowercaseDescription containsString:@"timeout"] ||
            [lowercaseDescription containsString:@"超时"]) {
            return @"请求超时，请检查网络连接后重试";
        }
    }
    
    return nil;
}

+ (NSInteger)getHTTPStatusCode:(NSError *)error {
    if (!error) {
        return -1;
    }
    
    NSDictionary *userInfo = error.userInfo;
    if (!userInfo) {
        return -1;
    }
    
    // 尝试多种方式获取HTTP状态码
    NSHTTPURLResponse *response = nil;
    
    // 方式1: AFNetworking的key
    response = userInfo[@"AFNetworkingOperationFailingURLResponseErrorKey"];
    if (response && [response isKindOfClass:[NSHTTPURLResponse class]]) {
        return response.statusCode;
    }
    
    // 方式2: 系统标准的key
    response = userInfo[@"NSErrorFailingURLResponseKey"];
    if (response && [response isKindOfClass:[NSHTTPURLResponse class]]) {
        return response.statusCode;
    }
    
    // 方式3: 遍历userInfo查找NSHTTPURLResponse
    for (NSString *key in userInfo.allKeys) {
        id value = userInfo[key];
        if ([value isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)value;
            return httpResponse.statusCode;
        }
    }
    
    return -1;
}

+ (NSString *)getServerErrorMessage:(NSError *)error {
    if (!error) {
        return nil;
    }
    
    NSDictionary *userInfo = error.userInfo;
    if (!userInfo) {
        return nil;
    }
    
    // 尝试获取响应数据
    NSData *responseData = nil;
    
    // 方式1: AFNetworking的key
    responseData = userInfo[@"AFNetworkingOperationFailingURLResponseDataErrorKey"];
    if (!responseData || ![responseData isKindOfClass:[NSData class]]) {
        // 方式2: 系统标准的key
        responseData = userInfo[@"NSErrorFailingURLResponseDataKey"];
    }
    
    if (!responseData || ![responseData isKindOfClass:[NSData class]]) {
        // 方式3: 遍历查找
        for (NSString *key in userInfo.allKeys) {
            id value = userInfo[key];
            if ([value isKindOfClass:[NSData class]]) {
                responseData = (NSData *)value;
                break;
            }
        }
    }
    
    if (!responseData || responseData.length == 0) {
        return nil;
    }
    
    // 限制数据大小（最多1MB）
    if (responseData.length > 1024 * 1024) {
        return nil;
    }
    
    // 尝试解析为JSON
    @try {
        NSError *jsonError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData
                                                       options:0
                                                         error:&jsonError];
        
        if (!jsonError && jsonObject) {
            // 尝试从常见的错误信息字段中提取
            if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)jsonObject;
                
                // 常见的错误信息字段
                NSArray *messageKeys = @[@"message", @"msg", @"error", @"errorMsg",
                                        @"errorMessage", @"errMsg", @"reason", @"description",
                                        @"msgInfo", @"error_info", @"errorInfo", @"err"];
                
                for (NSString *key in messageKeys) {
                    id value = dict[key];
                    if ([value isKindOfClass:[NSString class]] && [(NSString *)value length] > 0) {
                        return (NSString *)value;
                    }
                }
                
                // 尝试从data字段中获取
                id dataValue = dict[@"data"];
                if ([dataValue isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dataDict = (NSDictionary *)dataValue;
                    for (NSString *key in messageKeys) {
                        id value = dataDict[key];
                        if ([value isKindOfClass:[NSString class]] && [(NSString *)value length] > 0) {
                            return (NSString *)value;
                        }
                    }
                }
            }
        }
    } @catch (NSException *exception) {
        // JSON解析失败，忽略
        NSLog(@"解析服务器错误信息异常: %@", exception.reason);
    }
    
    // 如果JSON解析失败，尝试转换为字符串（只取前200个字符）
    @try {
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        if (responseString && responseString.length > 0) {
            // 只返回前200个字符
            if (responseString.length > 200) {
                return [responseString substringToIndex:200];
            }
            return responseString;
        }
    } @catch (NSException *exception) {
        NSLog(@"转换响应字符串异常: %@", exception.reason);
    }
    
    return nil;
}

+ (NSString *)getRequestURL:(NSError *)error {
    if (!error) {
        return nil;
    }
    
    NSDictionary *userInfo = error.userInfo;
    if (!userInfo) {
        return nil;
    }
    
    @try {
        // 方式1: AFNetworking的key
        NSURLRequest *urlRequest = userInfo[@"AFNetworkingOperationFailingURLRequestErrorKey"];
        if ([urlRequest isKindOfClass:[NSURLRequest class]]) {
            return urlRequest.URL.absoluteString;
        }
        
        // 方式2: 系统标准的key
        id urlValue = userInfo[@"NSErrorFailingURLKey"];
        if ([urlValue isKindOfClass:[NSURL class]]) {
            return ((NSURL *)urlValue).absoluteString;
        } else if ([urlValue isKindOfClass:[NSString class]]) {
            return (NSString *)urlValue;
        }
    } @catch (NSException *exception) {
        NSLog(@"获取请求URL异常: %@", exception.reason);
    }
    
    return nil;
}

+ (NSString *)getResponseString:(NSError *)error {
    if (!error) {
        return nil;
    }
    
    NSDictionary *userInfo = error.userInfo;
    if (!userInfo) {
        return nil;
    }
    
    // 尝试获取响应数据
    NSData *responseData = nil;
    
    @try {
        responseData = userInfo[@"AFNetworkingOperationFailingURLResponseDataErrorKey"];
        if (!responseData || ![responseData isKindOfClass:[NSData class]]) {
            responseData = userInfo[@"NSErrorFailingURLResponseDataKey"];
        }
        
        if (!responseData || ![responseData isKindOfClass:[NSData class]]) {
            return nil;
        }
        
        // 限制大小
        if (responseData.length > 1024 * 1024) {
            return nil;
        }
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        return responseString;
    } @catch (NSException *exception) {
        NSLog(@"获取响应字符串异常: %@", exception.reason);
        return nil;
    }
}

@end
