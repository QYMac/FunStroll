//
//  SetShadow.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/26.
//

#import "SetShadow.h"

@implementation SetShadow

+ (void)setShadow:(UIView *)bgView{
    bgView.layer.masksToBounds = NO;
    bgView.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    bgView.layer.shadowOffset = CGSizeMake(2, 2);//偏移距离
    bgView.layer.shadowOpacity = 0.1;//不透明度
    bgView.layer.shadowRadius = 2;//半径
}

+ (void)setShadowBut:(UIButton *)bgViewBu{
    bgViewBu.layer.masksToBounds = NO;
    bgViewBu.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    bgViewBu.layer.shadowOffset = CGSizeMake(2, 2);//偏移距离
    bgViewBu.layer.shadowOpacity = 0.1;//不透明度
    bgViewBu.layer.shadowRadius = 2;//半径
}

+ (void)setShadowTextField:(UITextField *)textField{
    textField.layer.masksToBounds = NO;
    textField.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    textField.layer.shadowOffset = CGSizeMake(2, 2);//偏移距离
    textField.layer.shadowOpacity = 0.1;//不透明度
    textField.layer.shadowRadius = 2;//半径
}



@end
