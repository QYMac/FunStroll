//
//  AFNetworkingManage.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/17.
//

#import "AFNetworkingManage.h"
#import "AFNetworkingHeaders.h"
#import "AFHTTPSessionManager.h"

@implementation AFNetworkingManage

+ (void)requestWithUrl:(NSString *)url params:(NSDictionary *)params requestType:(NSString *)requestType isBody:(BOOL)isBody isToken:(BOOL)isToken successHanler:(SuccessHandler)success failureHandler:(FailureHandler)failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if (isBody == YES) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    //去空值
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    manager.responseSerializer = response;
    //移除 NULL 值
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    
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
            if (failure) {
                failure(error);
            }
        }];
    }
}

@end
