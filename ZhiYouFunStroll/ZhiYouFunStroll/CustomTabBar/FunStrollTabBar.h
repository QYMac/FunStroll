//
//  FunStrollTabBar.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FunStrollTabBar : UITabBar

@property (nonatomic,copy) void(^didClickPublishBtn)(BOOL isSelected);

@property (nonatomic,strong) UIImageView *tabImage;
@property (nonatomic,strong) UIImageView *tabBgImage;

@end

NS_ASSUME_NONNULL_END
