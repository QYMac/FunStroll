//
//  LoginUserViewController.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginUserViewController : UIViewController

@property (nonatomic,assign) BOOL isSelected; // 是否同意协议
@property (nonatomic,assign) BOOL isPasswordLogin; // 是否密码登录

// 点击协议block
@property (nonatomic,copy) void(^selectedButClickBlcok)(BOOL isSelected);

@end

NS_ASSUME_NONNULL_END
