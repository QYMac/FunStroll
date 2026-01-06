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
@property (nonatomic, strong) UIButton *tabBarBut;

@end

@implementation FunStrollTabBar

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.translucent = NO;// tabBar 不透明

    
    [self addSubview:self.sendBtn];
    
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
    
    /*
    self.bgView.layer.cornerRadius = 50/2;
    self.bgView.frame = CGRectMake(20, 5, kWidth - 40, 50);
    [self addSubview:self.bgView];
    
    self.bgView.layer.masksToBounds = NO;
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    self.bgView.layer.shadowOpacity = 0.2;//不透明度
    self.bgView.layer.shadowRadius = 5;//半径
    
    CGFloat tabBarButWidth = kWidth - 80;
    for (int i = 0; i < 5; i++) {
        self.tabBarBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.tabBarBut setImage:[UIImage imageNamed:@"shopping_off"] forState:UIControlStateNormal];
        self.tabBarBut.frame = CGRectMake((tabBarButWidth/5*i) + 20, 0, tabBarButWidth/5, 50);
        [self.tabBarBut addTarget:self action:@selector(tabBarButClick:) forControlEvents:UIControlEventTouchUpInside];
        self.tabBarBut.tag = 100 + i;
        [self.bgView addSubview:self.tabBarBut];
    }
     */
}

- (void)tabBarButClick:(UIButton *)sender{
    if (self.tabBarButClickBlcok) {
        self.tabBarButClickBlcok(sender.tag);
    }
}

//发布
- (void)didClickPublishBtn:(UIButton*)sender {
    
    if (self.didClickPublishBtn) {
        self.didClickPublishBtn(sender.selected);
    }
    
    
    if (sender.selected == NO) {
        sender.selected = YES;
//        [UIView animateWithDuration:0.3 animations:^{
//            sender.transform = CGAffineTransformMakeRotation(M_PI/4);
//        } completion:^(BOOL finished) {
//            
//        }];
    } else {
        sender.selected = NO;
//        [UIView animateWithDuration:0.3 animations:^{
//            sender.transform = CGAffineTransformIdentity;
//        } completion:^(BOOL finished) {
//            
//        }];
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
        [_sendBtn addTarget:self action:@selector(didClickPublishBtn:) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.adjustsImageWhenHighlighted = NO;
        _sendBtn.backgroundColor = RGB(51, 51, 51);
        [_sendBtn setTitle:@"+" forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:25];
        _sendBtn.size = CGSizeMake(56, 43);
        _sendBtn.centerX = kWidth / 2;
        _sendBtn.centerY = (tabBarHeight-bottomHeight)/2 + 7.5;
        _sendBtn.layer.cornerRadius = 9;
        _sendBtn.layer.masksToBounds = YES;
        _middleBtn = _sendBtn;
    }
    return _sendBtn;
}


- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

@end
