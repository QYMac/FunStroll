//
//  AFNetworkingManage.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/17.
//

#import "AFNetworkingManage.h"
#import "AFNetworkingHeaders.h"
#import "AFHTTPSessionManager.h"
#import "UserModel.h"

@implementation AFNetworkingManage

/// 检查并处理 424 状态码（用户凭证已过期）
+ (void)handleStatusCode424IfNeeded:(NSURLSessionDataTask *)task {
    if (task && [task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = httpResponse.statusCode;
        
        if (statusCode == 424) {
            // 用户凭证已过期，删除用户信息并退回登录页面
            [UserModel deleteUserInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UserModel logoutView];
            });
        }
    }
}

+ (void)requestWithUrl:(NSString *)url params:(NSDictionary *)params requestType:(NSString *)requestType isBody:(BOOL)isBody isToken:(BOOL)isToken successHanler:(SuccessHandler)success failureHandler:(FailureHandler)failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if (isBody == YES) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    //response.removesKeysWithNullValues = YES; // 去空值
    manager.responseSerializer = response;
    
    /*
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    NSDictionary *headerFieldValueDictionary = [AFNetworkingHeaders headersDictionary];
    if (headerFieldValueDictionary != nil) {
        for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
            NSString *value = headerFieldValueDictionary[httpHeaderField];
            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
            [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        }
    }
    
    manager.requestSerializer = requestSerializer;
     */
    
    NSDictionary *headersDictionary = [AFNetworkingHeaders headersDictionary];
    if (isToken == NO) {
        headersDictionary = [AFNetworkingHeaders noTokenHeadersDictionary];
    }
    
    if ([requestType isEqualToString:@"GET"]) {
        [manager GET:[NSString stringWithFormat:@"%@%@",BASE_URL,url] parameters:params headers:headersDictionary progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 检查状态码 424（用户凭证已过期）
            [self handleStatusCode424IfNeeded:task];
            
            if (failure) {
                failure(error);
            }
        }];
        
    }else{
        [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,url] parameters:params headers:headersDictionary progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 检查状态码 424（用户凭证已过期）
            [self handleStatusCode424IfNeeded:task];
            
            if (failure) {
                failure(error);
            }
        }];
    }
}

// 上传帖子图片（数组）
+ (void)uploadPostImages:(NSArray<UIImage *> *)images imgAuditServiceType:(NSString *)imgAuditServiceType successHanler:(SuccessHandler)success failureHandler:(FailureHandler)failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = response;
    
    // 构建 URL，imgAuditServiceType 作为 Query 参数
    NSString *urlString = [NSString stringWithFormat:@"%@/app/appPost/uploadImage?imgAuditServiceType=%@", BASE_URL, imgAuditServiceType ?: @""];
    
    [manager POST:urlString parameters:nil headers:[AFNetworkingHeaders headersDictionary] constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmssSSS";
        
        for (NSInteger i = 0; i < images.count; i++) {
            UIImage *image = images[i];
            
            // 图片转 Data
            NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
            if (!imageData) {
                imageData = UIImagePNGRepresentation(image);
            }
            
            // 生成文件名
            NSString *dateStr = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@_%ld.jpg", dateStr, (long)i];
            
            // 添加文件到 FormData
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 上传进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 检查状态码 424（用户凭证已过期）
        [self handleStatusCode424IfNeeded:task];
        
        if (failure) {
            failure(error);
        }
    }];
}

@end
