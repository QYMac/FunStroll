//
//  AlertWith.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/2.
//

#import "AlertWith.h"

@implementation AlertWith

// 标题
+ (void)showAlertWithMessageText:(NSString *)message{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [[TabBarViewController takeCurrentVC] presentViewController:alert animated:YES completion:nil];
}

+ (void)showLocationDeniedAlert{
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"定位权限被拒绝"
                         message:@"请在设置中开启定位权限以使用此功能"
                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *settingsAction = [UIAlertAction
        actionWithTitle:@"去设置"
                  style:UIAlertActionStyleDefault
                handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
            [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:nil];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction
        actionWithTitle:@"取消"
                  style:UIAlertActionStyleCancel
                handler:nil];
    
    [alert addAction:settingsAction];
    [alert addAction:cancelAction];
    [[TabBarViewController takeCurrentVC] presentViewController:alert animated:YES completion:nil];
}


// 标题和内容
+ (void)showAlertWithMessageText:(NSString *)message contentText:(NSString *)contentText{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:message message:contentText preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [[TabBarViewController takeCurrentVC] presentViewController:alert animated:YES completion:nil];
}

@end
