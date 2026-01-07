//
//  AFNetworkingManage.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SuccessHandler)(id responseObject);
typedef void (^FailureHandler)(NSError *error);

@interface AFNetworkingManage : NSObject

/// 普通网络请求
+ (void)requestWithUrl:(NSString *)url
             params:(NSDictionary *)params
         requestType:(NSString *)requestType
                isBody:(BOOL)isBody
               isToken:(BOOL)isToken
      successHanler:(SuccessHandler)success
     failureHandler:(FailureHandler)failure;


/// 带有上传图片的请求
+ (void)requestImageWithUrl:(NSString *)url
             params:(NSDictionary *)params
         requestType:(NSString *)requestType
                  imageList:(NSArray *)imageList
      successHanler:(SuccessHandler)success
     failureHandler:(FailureHandler)failure;

@end

NS_ASSUME_NONNULL_END
