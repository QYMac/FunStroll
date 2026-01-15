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


// 带有上传图片的请求
+ (void)requestImageWithUrl:(NSString *)url params:(NSDictionary *)params requestType:(NSString *)requestType imageList:(NSArray *)imageList successHanler:(SuccessHandler)success failureHandler:(FailureHandler)failure{
    
    //表单请求，上传文件
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",nil];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    /*
    NSDictionary *httpHeader = [AFNetworkingHeaders headersDictionary];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    NSDictionary *headerFieldValueDictionary = httpHeader;
    if (headerFieldValueDictionary != nil) {
        for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
            NSString *value = headerFieldValueDictionary[httpHeaderField];
            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
            [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            //[manager.requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    manager.requestSerializer = requestSerializer;
     */
    
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,url] parameters:params headers:[AFNetworkingHeaders headersDictionary] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
        for (int i = 0; i < imageList.count; i++) {
            UIImage *image = [imageList objectAtIndexCheck:i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"images/blog/%@%dfile.png",str,i];
            //将图片以表单形式上传
            [formData appendPartWithFileData:imageData name:@"images" fileName:fileName mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
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

@end
