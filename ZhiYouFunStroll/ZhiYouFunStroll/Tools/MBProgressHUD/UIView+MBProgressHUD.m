//
//  UIView+MBProgressHUD.m
//  MBProgressHUD网络加载视图
//
//  Created by DFSJ on 2017/7/21.
//  Copyright © 2017年 dfsj. All rights reserved.
//

#import "UIView+MBProgressHUD.h"

@implementation UIView (MBProgressHUD)

// 只显示活动指示
- (MBProgressHUD *)showActivity
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
    if (nil == hud) {
        
        hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.bezelView.color=[[UIColor blackColor]colorWithAlphaComponent:0.8];
        hud.contentColor = [UIColor whiteColor];
    }
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

// 显示活动指示及文本
- (MBProgressHUD *)showActivityWithText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
    if (nil == hud) {
        hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    }
//    hud.labelText = text;
//    hud.dimBackground = YES;
    
    hud.label.text = text;
    hud.bezelView.color=[[UIColor blackColor]colorWithAlphaComponent:0.8];
    hud.contentColor = [UIColor whiteColor];

    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

// 移除活动指示
- (void)hideActivity
{
//    [[MBProgressHUD HUDForView:self] hide:YES];
    
    [[MBProgressHUD HUDForView:self]hideAnimated:YES];
}

// 不显示活动指示，只显示文本，指定显示时长
- (MBProgressHUD *)showTextNoActivity:(NSString *)text timeLength:(CGFloat)time
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.color=[[UIColor blackColor]colorWithAlphaComponent:0.8];
    hud.contentColor = [UIColor whiteColor];
//    hud.labelText = text;
//    [hud hide:YES afterDelay:time];
    
    
    hud.label.text = text;
    [hud hideAnimated:YES afterDelay:time];
    return hud;
}

// 显示文本及指定图片，指定显示时长
- (MBProgressHUD *)showText:(NSString *)text image:(UIImage *)image timeLength:(CGFloat)time
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.color=[[UIColor blackColor]colorWithAlphaComponent:0.8];
    hud.contentColor = [UIColor whiteColor];
//    hud.labelText = text;
//    [hud hide:YES afterDelay:time];
    //
    
    hud.label.text = text;
    [hud hideAnimated:YES afterDelay:time];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imageView;
    return hud;
}

// 显示文本及指定图片，指定显示时长
- (MBProgressHUD *)showText:(NSString *)text imageName:(NSString *)imageName timeLength:(CGFloat)time
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.color=[[UIColor blackColor]colorWithAlphaComponent:0.8];
    hud.contentColor = [UIColor whiteColor];
//    hud.labelText = text;
//    [hud hide:YES afterDelay:time];
    //
    
    hud .label.text = text;
    [hud hideAnimated:YES afterDelay:time];
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imageView;
    return hud;
}

@end
