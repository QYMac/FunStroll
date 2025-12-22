//
//  FunStrollTabBar.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/24.
//

#import "FunStrollTabBar.h"

@interface FunStrollTabBar ()

@property (nonatomic, strong) UIButton *middleBtn;
@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation FunStrollTabBar

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    //self.translucent = NO;// tabBar 不透明

    [self addSubview:self.sendBtn];
    
    self.tabImage.contentMode = UIViewContentModeScaleAspectFit;
    self.tabImage.image = [UIImage imageNamed:@"tabBarImage"];
    
    self.tabImage.frame = CGRectMake(0, -15, kWidth, self.frame.size.height);
    [self insertSubview:self.tabImage atIndex:0];
    
    self.tabBgImage.frame = CGRectMake(0, 50, kWidth, self.frame.size.height);
    [self insertSubview:self.tabBgImage atIndex:1];
    
    //[self.sendBtn setImagePositionWithType:SSImagePositionTypeTop spacing:4];
    // 其他位置按钮
    NSUInteger count = self.subviews.count;
    for (NSUInteger i = 0 , j = 0; i < count; i++)
    {
        UIView *view = self.subviews[i];
        Class class = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:class])
        {
            view.width = self.width / 5.0;
            view.x = self.width * j / 5.0;
            j++;
            if (j == 2)
            {
                j++;
            }
        }
    }
    
}

//发布
- (void)didClickPublishBtn:(UIButton*)sender {
    
    if (self.didClickPublishBtn) {
        self.didClickPublishBtn(sender.selected);
    }
    
    if (sender.selected == NO) {
        sender.selected = YES;
        [UIView animateWithDuration:0.3 animations:^{
            sender.transform = CGAffineTransformMakeRotation(M_PI/4);
        } completion:^(BOOL finished) {
            
        }];
    } else {
        sender.selected = NO;
        [UIView animateWithDuration:0.3 animations:^{
            //sender.transform = CGAffineTransformMakeRotation(-M_PI/3);
            sender.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.isHidden == NO)
    {
        CGPoint newP = [self convertPoint:point toView:self.middleBtn];
        if ( [self.middleBtn pointInside:newP withEvent:event])
        {
            return self.middleBtn;
        }else
        {
            return [super hitTest:point withEvent:event];
        }
    }
    else
    {
        return [super hitTest:point withEvent:event];
    }
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setBackgroundImage:[UIImage imageNamed:@"addInfo"] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(didClickPublishBtn:) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.adjustsImageWhenHighlighted = NO;
        _sendBtn.size = CGSizeMake(60*DDHorizontalFlexibleRatio(), 60*DDHorizontalFlexibleRatio());
        _sendBtn.centerX = kWidth / 2;
        _sendBtn.centerY = 2.0;
        _middleBtn = _sendBtn;
    }
    return _sendBtn;
}

- (UIImageView *)tabImage{
    if (!_tabImage) {
        _tabImage = [[UIImageView alloc] init];
    }
    return _tabImage;
}
- (UIImageView *)tabBgImage{
    if (!_tabBgImage) {
        _tabBgImage = [[UIImageView alloc] init];
        _tabBgImage.backgroundColor = [UIColor whiteColor];
    }
    return _tabBgImage;
}

@end
