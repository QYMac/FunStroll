//
//  MineViewTableViewCell.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/28.
//

#import "MineViewTableViewCell.h"

@implementation MineViewTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;//去除cell的点击效果
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.userInfoBgView];
        [self.userInfoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        self.userInfoImg.layer.cornerRadius = 6;
        self.userInfoImg.layer.masksToBounds = YES;
        [self.userInfoBgView addSubview:self.userInfoImg];
        [self.userInfoImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-15);
            make.top.mas_equalTo(40);
        }];

        
        self.avatarImage.layer.cornerRadius = 40;
        self.avatarImage.layer.masksToBounds = YES;
        [self.userInfoBgView addSubview:self.avatarImage];
        [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(80);
            make.centerX.mas_equalTo(self.userInfoImg);
            make.top.mas_equalTo(0);
        }];
        
        self.avatarImage.layer.cornerRadius = 40;
        self.avatarImage.layer.masksToBounds = YES;
        [self.userInfoBgView addSubview:self.avatarImage];
        [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(80);
            make.centerX.mas_equalTo(self.userInfoImg);
            make.top.mas_equalTo(0);
        }];
        
        [self.userInfoBgView addSubview:self.userNameBut];
        [self.userNameBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(30);
            make.centerX.mas_equalTo(self.avatarImage).offset(-10);
            make.top.mas_equalTo(self.avatarImage.mas_bottom).offset(10);
        }];
        
        [self.userInfoBgView addSubview:self.exitLoginBut];
        [self.exitLoginBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(30);
            make.left.mas_equalTo(self.userNameBut.mas_right).offset(0);
            make.centerY.mas_equalTo(self.userNameBut);
        }];
        
        [self.userInfoBgView addSubview:self.introductionBut];
        [self.introductionBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(30);
            make.top.mas_equalTo(self.userNameBut.mas_bottom).offset(0);
        }];
        
        self.orderBgView.layer.cornerRadius = 6;
        self.orderBgView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.orderBgView];
        [self.orderBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-15);
        }];
        
        [self.orderBgView addSubview:self.orderTitle];
        [self.orderTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(10);
        }];
        
        [self.orderBgView addSubview:self.next_order];
        [self.next_order mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(0);
        }];
        
        [self.orderBgView addSubview:self.orderBut1];
        [self.orderBut1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.width.mas_equalTo(80*DDHorizontalFlexibleRatio());
            make.height.mas_equalTo(60);
            make.bottom.mas_equalTo(-5);
        }];
        
        [self.orderBgView addSubview:self.orderBut2];
        [self.orderBut2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.orderBut1.mas_right).offset(5);
            make.width.mas_equalTo(80*DDHorizontalFlexibleRatio());
            make.height.mas_equalTo(60);
            make.bottom.mas_equalTo(-5);
        }];
        
        [self.orderBgView addSubview:self.orderBut3];
        [self.orderBut3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.orderBut2.mas_right).offset(5);
            make.width.mas_equalTo(80*DDHorizontalFlexibleRatio());
            make.height.mas_equalTo(60);
            make.bottom.mas_equalTo(-5);
        }];
        
        [self.orderBgView addSubview:self.orderBut4];
        [self.orderBut4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.orderBut3.mas_right).offset(5);
            make.width.mas_equalTo(80*DDHorizontalFlexibleRatio());
            make.height.mas_equalTo(60);
            make.bottom.mas_equalTo(-5);
        }];
        
        
        self.myCellListBgView.layer.cornerRadius = 6;
        self.myCellListBgView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.myCellListBgView];
        [self.myCellListBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(45);
        }];
        
        [self.myCellListBgView addSubview:self.headImg];
        [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.height.mas_equalTo(20);
            make.centerY.mas_equalTo(self.myCellListBgView);
        }];
        
        [self.myCellListBgView addSubview:self.headTitle];
        [self.headTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImg.mas_right).offset(10);
            make.height.mas_equalTo(25);
            make.right.mas_equalTo(-80);
            make.centerY.mas_equalTo(self.headImg);
        }];
        
        
        [self.myCellListBgView addSubview:self.nextPageImg];
        [self.nextPageImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(10);
            make.centerY.mas_equalTo(self.headImg);
        }];
        
    }
    return self;
}


- (void)setIndexPathCell:(NSIndexPath *)indexPathCell{
    
    self.userInfoBgView.hidden = YES;
    self.orderBgView.hidden = YES;
    self.myCellListBgView.hidden = NO;
    
    if (indexPathCell.row == 0) {
        self.userInfoBgView.hidden = NO;
        self.myCellListBgView.hidden = YES;
        
        //创建毛玻璃效果
        [self.userInfoImg layoutIfNeeded];
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = CGRectMake(0, 0, kWidth - 30, 185-40);

        // 添加到UIImageView
        [self.userInfoImg addSubview:blurEffectView];
        
        CGSize size = [self.userNameBut.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.userNameBut.titleLabel.font}];// 计算文字size
        [self.userNameBut setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
        [self.userNameBut mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(size.width+ 30);
        }];
        
    } else if (indexPathCell.row == 1) {
        self.orderBgView.hidden = NO;
        self.myCellListBgView.hidden = YES;
    }
}

#pragma mark - 按钮点击

- (void)userNameBtnClick:(UIButton *)sender{
    
}

- (void)exitLoginButClick:(UIButton *)sender{
    
}

- (void)introductionButClick:(UIButton *)sender{
    
}

- (void)next_orderBtnClick:(UIButton *)sender{
    
}

- (void)next_order1BtnClick:(UIButton *)sender{
    
}

- (void)next_order2BtnClick:(UIButton *)sender{
    
}

- (void)next_order3BtnClick:(UIButton *)sender{
    
}

- (void)next_order4BtnClick:(UIButton *)sender{
    
}



#pragma mark - 懒加载
- (UIView *)userInfoBgView{
    if (!_userInfoBgView) {
        _userInfoBgView = [[UIView alloc]init];
        _userInfoBgView.backgroundColor = [UIColor clearColor];
    }
    return _userInfoBgView;
}

- (UIImageView *)userInfoImg{
    if (!_userInfoImg) {
        _userInfoImg = [[UIImageView alloc]init];
        _userInfoImg.image = [UIImage imageNamed:@"myUserBg"];
        //_userInfoImg.backgroundColor = [UIColor clearColor];
    }
    return _userInfoImg;
}

- (UIImageView *)avatarImage{
    if (!_avatarImage) {
        _avatarImage = [[UIImageView alloc]init];
        _avatarImage.backgroundColor = RGB(240, 240, 240);
    }
    return _avatarImage;
}

- (UIButton *)userNameBut{
    if (!_userNameBut) {
        _userNameBut = [[UIButton alloc] init];
        [_userNameBut setImage:[UIImage imageNamed:@"editName"] forState:UIControlStateNormal];
        [_userNameBut setTitle:@"用户昵称" forState:UIControlStateNormal];
        _userNameBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [_userNameBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_userNameBut setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
        [_userNameBut addTarget:self action:@selector(userNameBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _userNameBut;
}

- (UIButton *)exitLoginBut{
    if (!_exitLoginBut) {
        _exitLoginBut = [[UIButton alloc] init];
        [_exitLoginBut setImage:[UIImage imageNamed:@"tuiChu"] forState:UIControlStateNormal];
        [_exitLoginBut addTarget:self action:@selector(exitLoginButClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _exitLoginBut;
}


- (UIButton *)introductionBut{
    if (!_introductionBut) {
        _introductionBut = [[UIButton alloc] init];
        [_introductionBut setTitle:@"此用户暂无个人简介~" forState:UIControlStateNormal];
        _introductionBut.titleLabel.font = [UIFont systemFontOfSize:10];
        [_introductionBut setTitleColor:RGB(140, 140, 140) forState:UIControlStateNormal];
        [_introductionBut addTarget:self action:@selector(introductionButClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _introductionBut;
}


- (UIView *)orderBgView{
    if (!_orderBgView) {
        _orderBgView = [[UIView alloc]init];
        _orderBgView.backgroundColor = [UIColor whiteColor];
    }
    return _orderBgView;
}

- (UILabel *)orderTitle{
    if (!_orderTitle) {
        _orderTitle = [[UILabel alloc]init];
        _orderTitle.text = @"我的订单";
        _orderTitle.font = [UIFont systemFontOfSize:15];
        _orderTitle.textColor = [UIColor blackColor];
    }
    return _orderTitle;
}

- (UIButton *)next_order{
    if (!_next_order) {
        _next_order = [[UIButton alloc] init];
        [_next_order setImage:[UIImage imageNamed:@"next_order"] forState:UIControlStateNormal];
        [_next_order setTitle:@"全部订单" forState:UIControlStateNormal];
        _next_order.titleLabel.font = [UIFont systemFontOfSize:12];
        [_next_order setTitleColor:RGB(173, 173, 173) forState:UIControlStateNormal];
        [_next_order setImagePositionWithType:SSImagePositionTypeRight spacing:5];
        [_next_order addTarget:self action:@selector(next_orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _next_order;
}

- (UIButton *)orderBut1{
    if (!_orderBut1) {
        _orderBut1 = [[UIButton alloc] init];
        [_orderBut1 setImage:[UIImage imageNamed:@"daiFuKuan"] forState:UIControlStateNormal];
        [_orderBut1 setTitle:@"待付款" forState:UIControlStateNormal];
        _orderBut1.titleLabel.font = [UIFont systemFontOfSize:12];
        [_orderBut1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_orderBut1 setImagePositionWithType:SSImagePositionTypeTop spacing:5];
        [_orderBut1 addTarget:self action:@selector(next_order1BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _orderBut1;
}

- (UIButton *)orderBut2{
    if (!_orderBut2) {
        _orderBut2 = [[UIButton alloc] init];
        [_orderBut2 setImage:[UIImage imageNamed:@"daiFaHuo"] forState:UIControlStateNormal];
        [_orderBut2 setTitle:@"已付款" forState:UIControlStateNormal];
        _orderBut2.titleLabel.font = [UIFont systemFontOfSize:12];
        [_orderBut2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_orderBut2 setImagePositionWithType:SSImagePositionTypeTop spacing:5];
        [_orderBut2 addTarget:self action:@selector(next_order2BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _orderBut2;
}

- (UIButton *)orderBut3{
    if (!_orderBut3) {
        _orderBut3 = [[UIButton alloc] init];
        [_orderBut3 setImage:[UIImage imageNamed:@"daiShouHuo"] forState:UIControlStateNormal];
        [_orderBut3 setTitle:@"待收货" forState:UIControlStateNormal];
        _orderBut3.titleLabel.font = [UIFont systemFontOfSize:12];
        [_orderBut3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_orderBut3 setImagePositionWithType:SSImagePositionTypeTop spacing:5];
        [_orderBut3 addTarget:self action:@selector(next_order3BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _orderBut3;
}

- (UIButton *)orderBut4{
    if (!_orderBut4) {
        _orderBut4 = [[UIButton alloc] init];
        [_orderBut4 setImage:[UIImage imageNamed:@"tuiKuan"] forState:UIControlStateNormal];
        [_orderBut4 setTitle:@"退款/售后" forState:UIControlStateNormal];
        _orderBut4.titleLabel.font = [UIFont systemFontOfSize:12];
        [_orderBut4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_orderBut4 setImagePositionWithType:SSImagePositionTypeTop spacing:5];
        [_orderBut4 addTarget:self action:@selector(next_order4BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _orderBut4;
}

- (UIView *)myCellListBgView{
    if (!_myCellListBgView) {
        _myCellListBgView = [[UIView alloc]init];
        _myCellListBgView.backgroundColor = [UIColor whiteColor];
    }
    return _myCellListBgView;
}

- (UIImageView *)headImg{
    if (!_headImg) {
        _headImg = [[UIImageView alloc]init];
    }
    return _headImg;
}

- (UIImageView *)nextPageImg{
    if (!_nextPageImg) {
        _nextPageImg = [[UIImageView alloc]init];
        _nextPageImg.image = [UIImage imageNamed:@"next_page"];
    }
    return _nextPageImg;
}

- (UILabel *)headTitle{
    if (!_headTitle) {
        _headTitle = [[UILabel alloc]init];
        _headTitle.text = @"";
        _headTitle.font = [UIFont systemFontOfSize:15];
        _headTitle.textColor = [UIColor blackColor];
    }
    return _headTitle;
}

@end
