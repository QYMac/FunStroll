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

/// 上传帖子图片
/// @param images 图片数组
/// @param imgAuditServiceType 图片审核服务类型
/// @param success 成功回调
/// @param failure 失败回调
+ (void)uploadPostImages:(NSArray<UIImage *> *)images
    imgAuditServiceType:(NSString *)imgAuditServiceType
          successHanler:(SuccessHandler)success
         failureHandler:(FailureHandler)failure;

@end

NS_ASSUME_NONNULL_END
