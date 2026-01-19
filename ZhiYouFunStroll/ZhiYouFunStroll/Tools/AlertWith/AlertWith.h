//
//  AlertWith.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertWith : NSObject

/// 只有标题
+ (void)showAlertWithMessageText:(NSString *)message;

/// 只有标题，带回调
+ (void)showAlertWithMessageText:(NSString *)message completion:(void(^)(void))completion;

/// 标题和内容
+ (void)showAlertWithMessageText:(NSString *)message contentText:(NSString *)contentText;

/// 只有标题，提示请求接口错误
+ (void)showAlertWithError:(NSError *)error;

/// 提示开启定位
+ (void)showLocationDeniedAlert;

/// 确认取消弹窗
+ (void)showConfirmAlertWithTitle:(NSString *)title
                          message:(NSString *)message
                     confirmTitle:(NSString *)confirmTitle
                      cancelTitle:(NSString *)cancelTitle
                   confirmHandler:(void(^)(void))confirmHandler
                    cancelHandler:(void(^)(void))cancelHandler;

@end

NS_ASSUME_NONNULL_END
