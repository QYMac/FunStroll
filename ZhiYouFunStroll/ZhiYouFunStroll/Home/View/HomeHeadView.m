//
//  HomeHeadView.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/30.
//

#import "HomeHeadView.h"

@interface HomeHeadView ()

@end

@implementation HomeHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.bgImgView.layer.cornerRadius = 0;
        self.bgImgView.layer.masksToBounds = YES;
        [self addSubview:self.bgImgView];
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
        }];
        
        [self.bgImgView insertSubview:self.bgImg atIndex:0];
        [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            //make.bottom.mas_equalTo(0);
        }];
        
        self.bgView.frame = CGRectMake(0, self.frame.size.height - 44, kWidth, 44);
        [self addSubview:self.bgView];
        [self.bgView addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(22, 22)];
        
        [self addSubview:self.labelImg];
        [self.labelImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(77);
            make.height.mas_equalTo(24);
            make.centerY.mas_equalTo(self.bgView);
        }];
    }
    return self;
}

#pragma mark - 懒加载
- (UIImageView *)bgImg{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] init];
        _bgImg.backgroundColor = RGB(240, 240, 240);
        _bgImg.image = [UIImage imageNamed:@"home_bgImg"];
        //_bgImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImg;
}

- (UIImageView *)labelImg{
    if (!_labelImg) {
        _labelImg = [[UIImageView alloc] init];
        _labelImg.image = [UIImage imageNamed:@"home_label"];
    }
    return _labelImg;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIView alloc] init];
        _bgImgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgImgView;
}

@end
