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

/// 标题和内容
+ (void)showAlertWithMessageText:(NSString *)message contentText:(NSString *)contentText;

/// 提示开启定位
+ (void)showLocationDeniedAlert;

@end

NS_ASSUME_NONNULL_END
