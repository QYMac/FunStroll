//
//  SetShadow.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SetShadow : NSObject

+ (void)setShadow:(UIView *)bgView;

+ (void)setShadowBut:(UIButton *)bgViewBut;

+ (void)setShadowTextField:(UITextField *)textField;

@end

NS_ASSUME_NONNULL_END
