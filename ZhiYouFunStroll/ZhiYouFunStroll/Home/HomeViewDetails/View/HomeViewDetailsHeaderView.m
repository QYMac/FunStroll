//
//  HomeViewDetailsHeaderView.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/1.
//

#import "HomeViewDetailsHeaderView.h"

@implementation HomeViewDetailsHeaderView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.bgView.layer.cornerRadius = 6;
        self.bgView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-10);
            make.top.mas_equalTo(10);
        }];
        
        self.headImg.image = [UIImage imageNamed:@"myBg"];
        self.headImg.layer.cornerRadius = 6;
        self.headImg.layer.masksToBounds = YES;
        [self.bgView addSubview:self.headImg];
        [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(160);
            make.top.mas_equalTo(10);
        }];
        
        [self.bgView addSubview:self.nameL];
        [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(self.headImg.mas_bottom).offset(10);
            make.right.mas_equalTo(-100);
            make.height.mas_equalTo(25);
        }];
        
        [self.bgView addSubview:self.numberL];
        [self.numberL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameL.mas_right).offset(10);
            make.centerY.mas_equalTo(self.nameL);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(25);
        }];
        
        [self.bgView addSubview:self.scoreL];
        [self.scoreL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameL.mas_left).offset(0);
            make.top.mas_equalTo(self.nameL.mas_bottom).offset(0);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(25);
        }];
        
        self.starsView.selectable = NO;
        self.starsView.supportDecimal = NO;
        [self.bgView addSubview:self.starsView];
        [self.starsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.scoreL.mas_centerY).offset(1.5);
            make.left.mas_equalTo(self.scoreL.mas_right).offset(0);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
        }];
        
        [self.bgView addSubview:self.collectionBut];
        [self.collectionBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(self.numberL.mas_bottom).offset(10);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        
        [self.bgView addSubview:self.shareBut];
        [self.shareBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.collectionBut.mas_left).offset(-5);
            make.top.mas_equalTo(self.collectionBut.mas_top).offset(0);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        
        [self.bgView addSubview:self.addressBut];
        [self.addressBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.shareBut.mas_left).offset(-5);
            make.top.mas_equalTo(self.shareBut.mas_top).offset(0);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        
        [self.bgView addSubview:self.iphoneBut];
        [self.iphoneBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.addressBut.mas_left).offset(-5);
            make.top.mas_equalTo(self.addressBut.mas_top).offset(0);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        
        [self.bgView addSubview:self.addressL];
        [self.addressL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.iphoneBut.mas_left).offset(-10);
            make.top.mas_equalTo(self.scoreL.mas_bottom).offset(0);
            make.left.mas_equalTo(self.scoreL.mas_left).offset(0);
            make.height.mas_equalTo(20);
        }];
        
        [self.bgView addSubview:self.statusL];
        [self.statusL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(60);
            make.top.mas_equalTo(self.addressL.mas_bottom).offset(15);
            make.left.mas_equalTo(self.addressL.mas_left).offset(0);
            make.height.mas_equalTo(20);
        }];
        
        [self.bgView addSubview:self.timeL];
        [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(self.addressL.mas_bottom).offset(15);
            make.left.mas_equalTo(self.statusL.mas_right).offset(10);
            make.height.mas_equalTo(20);
        }];
        
    }
    return self;
}

#pragma mark - 按钮点击事件

- (void)iphoneButClick:(UIButton *)sender{
    
}

- (void)addressButClick:(UIButton *)sender{
    
}

- (void)shareButClick:(UIButton *)sender{
    
}

- (void)collectionButClick:(UIButton *)sender{
    
}

#pragma mark - 懒加载

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIImageView *)headImg{
    if (!_headImg) {
        _headImg = [[UIImageView alloc]init];
        _headImg.contentMode = UIViewContentModeScaleToFill;
        _headImg.backgroundColor = RGB(240, 240, 240);
    }
    return _headImg;
}

- (UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]init];
        _nameL.text = @"观音山森林公园";
        _nameL.font = [UIFont systemFontOfSize:16];
    }
    return _nameL;
}

- (UILabel *)numberL{
    if (!_numberL) {
        _numberL = [[UILabel alloc]init];
        _numberL.text = @"12000人次游览";
        _numberL.font = [UIFont systemFontOfSize:10];
        _numberL.textColor = RGB(173, 173, 173);
        _numberL.textAlignment = NSTextAlignmentRight;
    }
    return _numberL;
}

- (UILabel *)scoreL{
    if (!_scoreL) {
        _scoreL = [[UILabel alloc]init];
        _scoreL.text = @"4.8分";
        _scoreL.font = [UIFont systemFontOfSize:12];
        _scoreL.textColor = RGB(255, 105, 31);
    }
    return _scoreL;
}

- (ServiceStarView *)starsView{
    if (!_starsView) {
        _starsView = [[ServiceStarView alloc] initWithStarSize:CGSizeMake(15, 15) space:3 numberOfStar:5];
        _starsView.score = 4.8;
    }
    return _starsView;
}

- (UIButton *)collectionBut{
    if (!_collectionBut) {
        _collectionBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionBut setImage:[UIImage imageNamed:@"home_SC"] forState:UIControlStateNormal];
        [_collectionBut addTarget:self action:@selector(collectionButClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionBut;
}

- (UIButton *)shareBut{
    if (!_shareBut) {
        _shareBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBut setImage:[UIImage imageNamed:@"home_FX"] forState:UIControlStateNormal];
        [_shareBut addTarget:self action:@selector(shareButClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBut;
}

- (UIButton *)addressBut{
    if (!_addressBut) {
        _addressBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addressBut setImage:[UIImage imageNamed:@"home_address"] forState:UIControlStateNormal];
        [_addressBut addTarget:self action:@selector(addressButClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addressBut;
}

- (UIButton *)iphoneBut{
    if (!_iphoneBut) {
        _iphoneBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iphoneBut setImage:[UIImage imageNamed:@"home_iphone"] forState:UIControlStateNormal];
        [_iphoneBut addTarget:self action:@selector(iphoneButClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _iphoneBut;
}

- (UILabel *)addressL{
    if (!_addressL) {
        _addressL = [[UILabel alloc]init];
        _addressL.text = @"架山路190号    距离您12.6km";
        _addressL.font = [UIFont systemFontOfSize:10];
        _addressL.textColor = RGB(173, 173, 173);
    }
    return _addressL;
}

- (UILabel *)statusL{
    if (!_statusL) {
        _statusL = [[UILabel alloc]init];
        _statusL.text = @"开园中";
        _statusL.font = [UIFont systemFontOfSize:14];
        _statusL.textColor = RGB(255, 105, 31);
    }
    return _statusL;
}

- (UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]init];
        _timeL.text = @"开园时间：09:00-18:00";
        _timeL.font = [UIFont systemFontOfSize:12];
        _timeL.textColor = RGB(173, 173, 173);
        _timeL.textAlignment = NSTextAlignmentRight;
    }
    return _timeL;
}

@end
