//
//  MapLayerView.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/4.
//

#import "MapLayerView.h"

@interface MapLayerView ()

@property (nonatomic,strong) UIButton *chooseBut;
@property (nonatomic,strong) UIButton *chooseBut1;
@property (nonatomic,strong) UIButton *chooseBut2;

@end

@implementation MapLayerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
        self.backgroundColor = RGB(240, 240, 240);
        
        [self addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15*DDHorizontalFlexibleRatio());
            make.top.mas_equalTo(15*DDHorizontalFlexibleRatio());
            make.right.mas_equalTo(-120*DDHorizontalFlexibleRatio());
            make.height.mas_equalTo(20*DDHorizontalFlexibleRatio());
        }];
        
        [self addSubview:self.exitBut];
        [self.exitBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(50*DDHorizontalFlexibleRatio());
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(-10*DDHorizontalFlexibleRatio());
        }];
        
        self.bgView1.layer.cornerRadius = 6;
        self.bgView1.layer.masksToBounds = YES;
        [self addSubview:self.bgView1];
        [self.bgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15*DDHorizontalFlexibleRatio());
            make.top.mas_equalTo(self.titleL.mas_bottom).offset(15*DDHorizontalFlexibleRatio());
            make.right.mas_equalTo(-15*DDHorizontalFlexibleRatio());
            make.height.mas_equalTo(120*DDHorizontalFlexibleRatio());
        }];
        
        [self.bgView1 addSubview:self.mapBut1];
        [self.mapBut1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25*DDHorizontalFlexibleRatio());
            make.top.mas_equalTo(15*DDHorizontalFlexibleRatio());
            make.width.mas_equalTo(100*DDHorizontalFlexibleRatio());
            make.height.mas_equalTo(68*DDHorizontalFlexibleRatio());
        }];
        
        [self.bgView1 addSubview:self.mapBut2];
        [self.mapBut2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mapBut1.mas_right).offset(15*DDHorizontalFlexibleRatio());
            make.top.mas_equalTo(self.mapBut1.mas_top).offset(0);
            make.width.mas_equalTo(self.mapBut1.mas_width);
            make.height.mas_equalTo(self.mapBut1.mas_height);
        }];
        
        [self.bgView1 addSubview:self.mapBut3];
        [self.mapBut3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mapBut2.mas_right).offset(15*DDHorizontalFlexibleRatio());
            make.top.mas_equalTo(self.mapBut2.mas_top).offset(0);
            make.width.mas_equalTo(self.mapBut1.mas_width);
            make.height.mas_equalTo(self.mapBut1.mas_height);
        }];
        
        [self.bgView1 addSubview:self.mapButTitle1];
        [self.mapButTitle1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mapBut1.mas_left).offset(0);
            make.top.mas_equalTo(self.mapBut1.mas_bottom).offset(5*DDHorizontalFlexibleRatio());
            make.right.mas_equalTo(self.mapBut1.mas_right).offset(0);
            make.height.mas_equalTo(20*DDHorizontalFlexibleRatio());
        }];
        
        [self.bgView1 addSubview:self.mapButTitle2];
        [self.mapButTitle2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mapBut2.mas_left).offset(0);
            make.top.mas_equalTo(self.mapBut2.mas_bottom).offset(5*DDHorizontalFlexibleRatio());
            make.right.mas_equalTo(self.mapBut2.mas_right).offset(0);
            make.height.mas_equalTo(20*DDHorizontalFlexibleRatio());
        }];
        
        [self.bgView1 addSubview:self.mapButTitle3];
        [self.mapButTitle3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mapBut3.mas_left).offset(0);
            make.top.mas_equalTo(self.mapBut3.mas_bottom).offset(5*DDHorizontalFlexibleRatio());
            make.right.mas_equalTo(self.mapBut3.mas_right).offset(0);
            make.height.mas_equalTo(20*DDHorizontalFlexibleRatio());
        }];
        
        
        [self addSubview:self.titleL1];
        [self.titleL1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15*DDHorizontalFlexibleRatio());
            make.top.mas_equalTo(self.bgView1.mas_bottom).offset(15*DDHorizontalFlexibleRatio());
            make.right.mas_equalTo(-120*DDHorizontalFlexibleRatio());
            make.height.mas_equalTo(20*DDHorizontalFlexibleRatio());
        }];
        
        self.bgView2.layer.cornerRadius = 6;
        self.bgView2.layer.masksToBounds = YES;
        [self addSubview:self.bgView2];
        [self.bgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15*DDHorizontalFlexibleRatio());
            make.top.mas_equalTo(self.titleL1.mas_bottom).offset(15*DDHorizontalFlexibleRatio());
            make.right.mas_equalTo(-15*DDHorizontalFlexibleRatio());
            make.height.mas_equalTo(120*DDHorizontalFlexibleRatio());
        }];
        
        [self.bgView2 addSubview:self.mapBut4];
        [self.mapBut4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25*DDHorizontalFlexibleRatio());
            make.top.mas_equalTo(15*DDHorizontalFlexibleRatio());
            make.width.mas_equalTo(self.mapBut1.mas_width);
            make.height.mas_equalTo(self.mapBut1.mas_height);
        }];
        
        [self.bgView2 addSubview:self.mapBut5];
        [self.mapBut5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mapBut4.mas_right).offset(15*DDHorizontalFlexibleRatio());
            make.top.mas_equalTo(self.mapBut4.mas_top).offset(0);
            make.width.mas_equalTo(self.mapBut1.mas_width);
            make.height.mas_equalTo(self.mapBut1.mas_height);
        }];
        
        [self.bgView2 addSubview:self.mapButTitle4];
        [self.mapButTitle4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mapBut4.mas_left).offset(0);
            make.top.mas_equalTo(self.mapBut4.mas_bottom).offset(5*DDHorizontalFlexibleRatio());
            make.right.mas_equalTo(self.mapBut4.mas_right).offset(0);
            make.height.mas_equalTo(20*DDHorizontalFlexibleRatio());
        }];
        
        [self.bgView2 addSubview:self.mapButTitle5];
        [self.mapButTitle5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mapBut5.mas_left).offset(0);
            make.top.mas_equalTo(self.mapBut5.mas_bottom).offset(5*DDHorizontalFlexibleRatio());
            make.right.mas_equalTo(self.mapBut5.mas_right).offset(0);
            make.height.mas_equalTo(20*DDHorizontalFlexibleRatio());
        }];
        
        
        
        
        _bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 35)];
        _bgImg.hidden = NO;
        [self addSubview:_bgImg];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)RGB(255, 176, 79).CGColor, (__bridge id)RGB(255, 105, 31).CGColor];
        gradientLayer.locations = @[@(0.0f), @(1.0f)];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1.0);
        gradientLayer.frame = CGRectMake(0, 0, 80, 34);
        [_bgImg.layer addSublayer:gradientLayer];
        
        UIGraphicsBeginImageContextWithOptions(_bgImg.bounds.size, NO, 0.0);
        [_bgImg.layer renderInContext:UIGraphicsGetCurrentContext()];
        _bgImg1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        _bgImg.hidden = YES;
        [_bgImg removeFromSuperview];
        _bgImg = nil;
        
        [self addSubview:self.titleL2];
        [self.titleL2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15*DDHorizontalFlexibleRatio());
            make.top.mas_equalTo(self.bgView2.mas_bottom).offset(15*DDHorizontalFlexibleRatio());
            make.right.mas_equalTo(-120*DDHorizontalFlexibleRatio());
            make.height.mas_equalTo(20*DDHorizontalFlexibleRatio());
        }];
        
        
        [self insertSubview:self.mapBut6 atIndex:3];
        [self.mapBut6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15*DDHorizontalFlexibleRatio());
            make.top.mas_equalTo(self.titleL2.mas_bottom).offset(15*DDHorizontalFlexibleRatio());
            make.width.mas_equalTo((kWidth - 32)/3);
            make.height.mas_equalTo(30*DDHorizontalFlexibleRatio());
        }];
        
        [self.mapBut6 layoutIfNeeded];
        [self.mapBut6 setPartialCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft radius:15*DDHorizontalFlexibleRatio() borderWidth:1 borderColor:RGB(242, 201, 168) forButton:self.mapBut6];
        
        [self insertSubview:self.mapBut7 atIndex:2];
        [self.mapBut7 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mapBut6.mas_right).offset(-1);
            make.top.mas_equalTo(self.mapBut6.mas_top);
            make.width.mas_equalTo(self.mapBut6.mas_width);
            make.height.mas_equalTo(self.mapBut6.mas_height);
        }];
        
        [self insertSubview:self.mapBut8 atIndex:1];
        [self.mapBut8 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mapBut7.mas_right).offset(-1);
            make.top.mas_equalTo(self.mapBut7.mas_top);
            make.width.mas_equalTo(self.mapBut6.mas_width);
            make.height.mas_equalTo(self.mapBut6.mas_height);
        }];
        
        [self.mapBut8 layoutIfNeeded];
        [self.mapBut8 setPartialCorners:UIRectCornerTopRight | UIRectCornerBottomRight radius:15*DDHorizontalFlexibleRatio() borderWidth:1 borderColor:RGB(255, 105, 31) forButton:self.mapBut8];
        
        
        
        [self addSubview:self.titleL3];
        [self.titleL3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15*DDHorizontalFlexibleRatio());
            make.top.mas_equalTo(self.mapBut7.mas_bottom).offset(15*DDHorizontalFlexibleRatio());
            make.right.mas_equalTo(-120*DDHorizontalFlexibleRatio());
            make.height.mas_equalTo(20*DDHorizontalFlexibleRatio());
        }];
        
        self.bgView3.layer.cornerRadius = 6;
        self.bgView3.layer.masksToBounds = YES;
        [self addSubview:self.bgView3];
        [self.bgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15*DDHorizontalFlexibleRatio());
            make.top.mas_equalTo(self.titleL3.mas_bottom).offset(15*DDHorizontalFlexibleRatio());
            make.right.mas_equalTo(-15*DDHorizontalFlexibleRatio());
            make.height.mas_equalTo(60*DDHorizontalFlexibleRatio());
        }];
        
        [self.bgView3 addSubview:self.mapBut9];
        [self.mapBut9 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15*DDHorizontalFlexibleRatio());
            make.top.mas_equalTo(10*DDHorizontalFlexibleRatio());
            make.width.mas_equalTo(40*DDHorizontalFlexibleRatio());
            make.bottom.mas_equalTo(-10*DDHorizontalFlexibleRatio());
        }];
        
        [self.bgView3 addSubview:self.mapBut10];
        [self.mapBut10 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mapBut9.mas_right).offset(15*DDHorizontalFlexibleRatio());
            make.top.mas_equalTo(self.mapBut9.mas_top).offset(0);
            make.width.mas_equalTo(self.mapBut9.mas_width);
            make.bottom.mas_equalTo(self.mapBut9.mas_bottom).offset(0);
        }];
    }
    
    return self;
}

#pragma mark - 按钮点击

- (void)exitButClick:(UIButton *)sender{
    if (self.didMapLayerViewBlcok) {
        self.didMapLayerViewBlcok();
    }
}

- (void)mapButClick:(UIButton *)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
        sender.layer.borderWidth = 1;
        sender.layer.borderColor = RGB(255, 105, 31).CGColor;
        
        _chooseBut.selected = NO;
        _chooseBut.layer.borderWidth = 1;
        _chooseBut.layer.borderColor = [UIColor clearColor].CGColor;
        
        if (sender.tag == 101) {
            self.mapButTitle1.textColor = RGB(255, 105, 31);
            self.mapButTitle2.textColor = RGB(145, 145, 145);
            self.mapButTitle3.textColor = RGB(145, 145, 145);
        } else if (sender.tag == 102) {
            self.mapButTitle1.textColor = RGB(145, 145, 145);
            self.mapButTitle2.textColor = RGB(255, 105, 31);
            self.mapButTitle3.textColor = RGB(145, 145, 145);
        } else if (sender.tag == 103) {
            self.mapButTitle1.textColor = RGB(145, 145, 145);
            self.mapButTitle2.textColor = RGB(145, 145, 145);
            self.mapButTitle3.textColor = RGB(255, 105, 31);
        }
        
        if (self.changeLayerBlcok) {
            self.changeLayerBlcok(sender.tag);
        }
        
    }
    
    _chooseBut1.selected = NO;
    _chooseBut1.layer.borderWidth = 1;
    _chooseBut1.layer.borderColor = [UIColor clearColor].CGColor;
    self.mapButTitle4.textColor = RGB(145, 145, 145);
    self.mapButTitle5.textColor = RGB(145, 145, 145);
    _chooseBut1 = [UIButton new];
    
    _chooseBut = sender;
}

- (void)mapBut1Click:(UIButton *)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
        sender.layer.borderWidth = 1;
        sender.layer.borderColor = RGB(255, 105, 31).CGColor;
        
        _chooseBut1.selected = NO;
        _chooseBut1.layer.borderWidth = 1;
        _chooseBut1.layer.borderColor = [UIColor clearColor].CGColor;
        
        if (sender.tag == 104) {
            self.mapButTitle4.textColor = RGB(255, 105, 31);
            self.mapButTitle5.textColor = RGB(145, 145, 145);
        } else if (sender.tag == 105) {
            self.mapButTitle4.textColor = RGB(145, 145, 145);
            self.mapButTitle5.textColor = RGB(255, 105, 31);
        }
        
        if (self.changeSkinBlcok) {
            self.changeSkinBlcok(sender.tag);
        }
    }
    
    _chooseBut.selected = NO;
    _chooseBut.layer.borderWidth = 1;
    _chooseBut.layer.borderColor = [UIColor clearColor].CGColor;
    self.mapButTitle1.textColor = RGB(145, 145, 145);
    self.mapButTitle2.textColor = RGB(145, 145, 145);
    self.mapButTitle3.textColor = RGB(145, 145, 145);
    _chooseBut = [UIButton new];
    
    _chooseBut1 = sender;
}

- (void)mapBut2Click:(UIButton *)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sender setBackgroundImage:_bgImg1 forState:UIControlStateNormal];
        
        _chooseBut2.selected = NO;
        [_chooseBut2 setTitleColor:RGB(255, 105, 31) forState:UIControlStateNormal];
        [_chooseBut2 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        if (self.changeBgBlcok) {
            self.changeBgBlcok(sender.tag);
        }
    }
    
    _chooseBut.selected = NO;
    _chooseBut.layer.borderWidth = 1;
    _chooseBut.layer.borderColor = [UIColor clearColor].CGColor;
    self.mapButTitle1.textColor = RGB(145, 145, 145);
    self.mapButTitle2.textColor = RGB(145, 145, 145);
    self.mapButTitle3.textColor = RGB(145, 145, 145);
    _chooseBut = [UIButton new];
    
    _chooseBut1.selected = NO;
    _chooseBut1.layer.borderWidth = 1;
    _chooseBut1.layer.borderColor = [UIColor clearColor].CGColor;
    self.mapButTitle4.textColor = RGB(145, 145, 145);
    self.mapButTitle5.textColor = RGB(145, 145, 145);
    _chooseBut1 = [UIButton new];
    
    self.mapBut1.selected = YES;
    self.mapBut1.layer.borderWidth = 1;
    self.mapBut1.layer.borderColor = RGB(255, 105, 31).CGColor;
    self.mapButTitle1.textColor = RGB(255, 105, 31);
    _chooseBut = self.mapBut1;
    
    _chooseBut2 = sender;
}


- (void)mapBut3Click:(UIButton *)sender{
    if (self.changeRoadBlcok) {
        self.changeRoadBlcok(sender.tag);
    }
}

- (void)mapBut4Click:(UIButton *)sender{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

#pragma mark - 懒加载
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"图层设置";
        _titleL.font = [UIFont systemFontOfSize:16];
        _titleL.textColor = [UIColor blackColor];
    }
    return _titleL;
}

- (UIButton *)exitBut{
    if (!_exitBut) {
        _exitBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exitBut setImage:[UIImage imageNamed:@"Exit_Map"] forState:UIControlStateNormal];
        [_exitBut addTarget:self action:@selector(exitButClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitBut;
}

- (UIView *)bgView1{
    if (!_bgView1) {
        _bgView1 = [[UIView alloc]init];
        _bgView1.backgroundColor = [UIColor whiteColor];
    }
    return _bgView1;
}

- (UIButton *)mapBut1{
    if (!_mapBut1) {
        _mapBut1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mapBut1 setBackgroundImage:[UIImage imageNamed:@"mapBut1"] forState:UIControlStateNormal];
        [_mapBut1 addTarget:self action:@selector(mapButClick:) forControlEvents:UIControlEventTouchUpInside];
        _mapBut1.selected = YES;
        _mapBut1.tag = 101;
        _mapBut1.layer.cornerRadius = 6;
        _mapBut1.layer.masksToBounds = YES;
        _mapBut1.layer.borderWidth = 1;
        _mapBut1.layer.borderColor = RGB(255, 105, 31).CGColor;
        _chooseBut = _mapBut1;
        
    }
    return _mapBut1;
}

- (UIButton *)mapBut2{
    if (!_mapBut2) {
        _mapBut2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mapBut2 setBackgroundImage:[UIImage imageNamed:@"mapBut2"] forState:UIControlStateNormal];
        [_mapBut2 addTarget:self action:@selector(mapButClick:) forControlEvents:UIControlEventTouchUpInside];
        _mapBut2.selected = NO;
        _mapBut2.tag = 102;
        _mapBut2.layer.cornerRadius = 6;
        _mapBut2.layer.masksToBounds = YES;
    }
    return _mapBut2;
}

- (UIButton *)mapBut3{
    if (!_mapBut3) {
        _mapBut3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mapBut3 setBackgroundImage:[UIImage imageNamed:@"mapBut3"] forState:UIControlStateNormal];
        [_mapBut3 addTarget:self action:@selector(mapButClick:) forControlEvents:UIControlEventTouchUpInside];
        _mapBut3.selected = NO;
        _mapBut3.tag = 103;
        _mapBut3.layer.cornerRadius = 6;
        _mapBut3.layer.masksToBounds = YES;
    }
    return _mapBut3;
}

- (UILabel *)mapButTitle1{
    if (!_mapButTitle1) {
        _mapButTitle1 = [[UILabel alloc]init];
        _mapButTitle1.text = @"标准地图";
        _mapButTitle1.font = [UIFont systemFontOfSize:12];
        _mapButTitle1.textColor = RGB(255, 105, 31);
        _mapButTitle1.textAlignment = NSTextAlignmentCenter;
    }
    return _mapButTitle1;
}

- (UILabel *)mapButTitle2{
    if (!_mapButTitle2) {
        _mapButTitle2 = [[UILabel alloc]init];
        _mapButTitle2.text = @"卫星地图";
        _mapButTitle2.font = [UIFont systemFontOfSize:12];
        _mapButTitle2.textAlignment = NSTextAlignmentCenter;
        _mapButTitle2.textColor = RGB(145, 145, 145);
    }
    return _mapButTitle2;
}

- (UILabel *)mapButTitle3{
    if (!_mapButTitle3) {
        _mapButTitle3 = [[UILabel alloc]init];
        _mapButTitle3.text = @"公交地图";
        _mapButTitle3.font = [UIFont systemFontOfSize:12];
        _mapButTitle3.textAlignment = NSTextAlignmentCenter;
        _mapButTitle3.textColor = RGB(145, 145, 145);
    }
    return _mapButTitle3;
}

- (UILabel *)titleL1{
    if (!_titleL1) {
        _titleL1 = [[UILabel alloc]init];
        _titleL1.text = @"趣—UI";
        _titleL1.font = [UIFont systemFontOfSize:14];
        _titleL1.textColor = [UIColor blackColor];
    }
    return _titleL1;
}

- (UIView *)bgView2{
    if (!_bgView2) {
        _bgView2 = [[UIView alloc]init];
        _bgView2.backgroundColor = [UIColor whiteColor];
    }
    return _bgView2;
}

- (UIButton *)mapBut4{
    if (!_mapBut4) {
        _mapBut4 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mapBut4 setBackgroundImage:[UIImage imageNamed:@"mapBut4"] forState:UIControlStateNormal];
        [_mapBut4 addTarget:self action:@selector(mapBut1Click:) forControlEvents:UIControlEventTouchUpInside];
        _mapBut4.selected = NO;
        _mapBut4.tag = 104;
        _mapBut4.layer.cornerRadius = 6;
        _mapBut4.layer.masksToBounds = YES;
    }
    return _mapBut4;
}

- (UIButton *)mapBut5{
    if (!_mapBut5) {
        _mapBut5 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mapBut5 setBackgroundImage:[UIImage imageNamed:@"mapBut5"] forState:UIControlStateNormal];
        [_mapBut5 addTarget:self action:@selector(mapBut1Click:) forControlEvents:UIControlEventTouchUpInside];
        _mapBut5.selected = NO;
        _mapBut5.tag = 105;
        _mapBut5.layer.cornerRadius = 6;
        _mapBut5.layer.masksToBounds = YES;
    }
    return _mapBut5;
}

- (UILabel *)mapButTitle4{
    if (!_mapButTitle4) {
        _mapButTitle4 = [[UILabel alloc]init];
        _mapButTitle4.text = @"龙年限定";
        _mapButTitle4.font = [UIFont systemFontOfSize:12];
        _mapButTitle4.textColor = RGB(145, 145, 145);
        _mapButTitle4.textAlignment = NSTextAlignmentCenter;
    }
    return _mapButTitle4;
}

- (UILabel *)mapButTitle5{
    if (!_mapButTitle5) {
        _mapButTitle5 = [[UILabel alloc]init];
        _mapButTitle5.text = @"XX限定";
        _mapButTitle5.font = [UIFont systemFontOfSize:12];
        _mapButTitle5.textColor = RGB(145, 145, 145);
        _mapButTitle5.textAlignment = NSTextAlignmentCenter;
    }
    return _mapButTitle5;
}

- (UILabel *)titleL2{
    if (!_titleL2) {
        _titleL2 = [[UILabel alloc]init];
        _titleL2.text = @"外观设置";
        _titleL2.font = [UIFont systemFontOfSize:14];
        _titleL2.textColor = [UIColor blackColor];
    }
    return _titleL2;
}

- (UIButton *)mapBut6{
    if (!_mapBut6) {
        _mapBut6 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mapBut6 setBackgroundImage:_bgImg1 forState:UIControlStateNormal];
        _mapBut6.titleLabel.font = [UIFont systemFontOfSize:12];
        [_mapBut6 setTitle:@"经典模式" forState:UIControlStateNormal];
        [_mapBut6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mapBut6 addTarget:self action:@selector(mapBut2Click:) forControlEvents:UIControlEventTouchUpInside];
        //_mapBut6.backgroundColor = RGB(255, 105, 31);
        _mapBut6.selected = YES;
        _mapBut6.tag = 106;
        _mapBut6.layer.borderWidth = 1;
        _mapBut6.layer.borderColor = RGB(242, 201, 168).CGColor;
        _chooseBut2 = _mapBut6;
    }
    return _mapBut6;
}

- (UIButton *)mapBut7{
    if (!_mapBut7) {
        _mapBut7 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mapBut7 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _mapBut7.titleLabel.font = [UIFont systemFontOfSize:12];
        [_mapBut7 setTitle:@"深色模式" forState:UIControlStateNormal];
        [_mapBut7 setTitleColor:RGB(255, 105, 31) forState:UIControlStateNormal];
        [_mapBut7 addTarget:self action:@selector(mapBut2Click:) forControlEvents:UIControlEventTouchUpInside];
        _mapBut7.selected = NO;
        _mapBut7.tag = 107;
        _mapBut7.layer.borderWidth = 1;
        _mapBut7.layer.borderColor = RGB(242, 201, 168).CGColor;
    }
    return _mapBut7;
}

- (UIButton *)mapBut8{
    if (!_mapBut8) {
        _mapBut8 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mapBut8 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _mapBut8.titleLabel.font = [UIFont systemFontOfSize:12];
        [_mapBut8 setTitle:@"跟随系统" forState:UIControlStateNormal];
        [_mapBut8 setTitleColor:RGB(255, 105, 31) forState:UIControlStateNormal];
        [_mapBut8 addTarget:self action:@selector(mapBut2Click:) forControlEvents:UIControlEventTouchUpInside];
        _mapBut8.selected = NO;
        _mapBut8.tag = 108;
        _mapBut8.layer.borderWidth = 1;
        _mapBut8.layer.borderColor = RGB(242, 201, 168).CGColor;;
    }
    return _mapBut8;
}


- (UILabel *)titleL3{
    if (!_titleL3) {
        _titleL3 = [[UILabel alloc]init];
        _titleL3.text = @"地图显示";
        _titleL3.font = [UIFont systemFontOfSize:14];
        _titleL3.textColor = [UIColor blackColor];
    }
    return _titleL3;
}

- (UIView *)bgView3{
    if (!_bgView3) {
        _bgView3 = [[UIView alloc]init];
        _bgView3.backgroundColor = [UIColor whiteColor];
    }
    return _bgView3;
}

- (UIButton *)mapBut9{
    if (!_mapBut9) {
        _mapBut9 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mapBut9 setImage:[UIImage imageNamed:@"mapHongDeng"] forState:UIControlStateNormal];
        _mapBut9.titleLabel.font = [UIFont systemFontOfSize:12];
        [_mapBut9 setTitle:@"路况" forState:UIControlStateNormal];
        [_mapBut9 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_mapBut9 addTarget:self action:@selector(mapBut3Click:) forControlEvents:UIControlEventTouchUpInside];
        [_mapBut9 setImagePositionWithType:SSImagePositionTypeTop spacing:5];
        _mapBut9.tag = 109;
    }
    return _mapBut9;
}

- (UIButton *)mapBut10{
    if (!_mapBut10) {
        _mapBut10 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mapBut10 setImage:[UIImage imageNamed:@"mapSC"] forState:UIControlStateNormal];
        _mapBut10.titleLabel.font = [UIFont systemFontOfSize:12];
        [_mapBut10 setTitle:@"收藏" forState:UIControlStateNormal];
        [_mapBut10 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_mapBut10 addTarget:self action:@selector(mapBut4Click:) forControlEvents:UIControlEventTouchUpInside];
        [_mapBut10 setImagePositionWithType:SSImagePositionTypeTop spacing:5];
        _mapBut10.tag = 110;
    }
    return _mapBut10;
}

@end
