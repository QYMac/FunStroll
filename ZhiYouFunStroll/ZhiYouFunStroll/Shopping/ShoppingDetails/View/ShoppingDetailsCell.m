//
//  ShoppingDetailsCell.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/2.
//

#import "ShoppingDetailsCell.h"

@implementation ShoppingDetailsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;//去除cell的点击效果
        self.backgroundColor = [UIColor clearColor];
        
        self.bgView.layer.cornerRadius = 6;
        self.bgView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
        
        self.themeImg.layer.cornerRadius = 6;
        self.themeImg.layer.masksToBounds = YES;
        [self.bgView addSubview:self.themeImg];
        [self.themeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(250);
        }];
        
        [self.bgView addSubview:self.contentL];
        [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.themeImg.mas_left).offset(0);
            make.right.mas_equalTo(self.themeImg.mas_right).offset(0);
            make.top.mas_equalTo(self.themeImg.mas_bottom).offset(10);
        }];
        
        [self.bgView addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.themeImg.mas_left).offset(0);
            make.right.mas_equalTo(-120);
            make.top.mas_equalTo(self.contentL.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
        }];
        
        [self.bgView addSubview:self.moneyTitleL];
        [self.moneyTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.themeImg.mas_left).offset(0);
            make.width.mas_equalTo(30);
            make.top.mas_equalTo(self.titleL.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
        }];
        
        [self.bgView addSubview:self.moneyL];
        [self.moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.moneyTitleL.mas_right).offset(0);
            make.right.mas_equalTo(self.titleL.mas_right).offset(0);
            make.centerY.mas_equalTo(self.moneyTitleL);
            make.height.mas_equalTo(20);
        }];
        
        self.purchaseBut.layer.cornerRadius = 3;
        self.purchaseBut.layer.masksToBounds = YES;
        [self.bgView addSubview:self.purchaseBut];
        [self.purchaseBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(50);
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.moneyTitleL);
            make.height.mas_equalTo(25);
        }];
        
        self.dressingBut.layer.cornerRadius = 3;
        self.dressingBut.layer.masksToBounds = YES;
        [self.bgView addSubview:self.dressingBut];
        [self.dressingBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
            make.right.mas_equalTo(self.purchaseBut.mas_left).offset(-10);
            make.centerY.mas_equalTo(self.purchaseBut);
            make.height.mas_equalTo(25);
        }];
        
        
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.moneyL.mas_bottom).offset(20);
        }];
        
    }
    return self;
}

#pragma mark - 按钮点击
- (void)dressingButClick:(UIButton *)sender{
    
}

- (void)purchaseButClick:(UIButton *)sender{
    
}

#pragma mark - 懒加载
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIImageView *)themeImg{
    if (!_themeImg) {
        _themeImg = [[UIImageView alloc] init];
        _themeImg.backgroundColor = RGB(240, 240, 240);
        _themeImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _themeImg;
}

- (UILabel *)contentL{
    if (!_contentL) {
        _contentL = [[UILabel alloc]init];
        _contentL.text = @"点开界面就被软乎乎的猫咪动态环绕，傲娇款用肉垫轻拍屏幕、慵懒款蜷成毛球打盹，仿佛真有只小奶猫趴在手机里撒娇，瞬间治愈所有疲惫。";
        _contentL.font = [UIFont systemFontOfSize:12];
        _contentL.textColor = RGB(173, 173, 173);
        _contentL.numberOfLines = 0;
    }
    return _contentL;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"萌宠主题";
        _titleL.font = [UIFont systemFontOfSize:15];
        _titleL.textColor = [UIColor blackColor];
    }
    return _titleL;
}

- (UILabel *)moneyTitleL{
    if (!_moneyTitleL) {
        _moneyTitleL = [[UILabel alloc]init];
        _moneyTitleL.text = @"售价";
        _moneyTitleL.font = [UIFont systemFontOfSize:12];
        _moneyTitleL.textColor = RGB(173, 173, 173);
    }
    return _moneyTitleL;
}

- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.text = @"¥9.9";
        _moneyL.font = [UIFont systemFontOfSize:12];
        _moneyL.textColor = [UIColor redColor];
    }
    return _moneyL;
}

- (UIButton *)dressingBut{
    if (!_dressingBut) {
        _dressingBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dressingBut setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_dressingBut setTitle:@"立即评装扮" forState:UIControlStateNormal];
        [_dressingBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _dressingBut.titleLabel.font = [UIFont systemFontOfSize:12];
        [_dressingBut addTarget:self action:@selector(dressingButClick:) forControlEvents:UIControlEventTouchUpInside];
        _dressingBut.backgroundColor = RGB(209, 209, 209);
    }
    return _dressingBut;
}

- (UIButton *)purchaseBut{
    if (!_purchaseBut) {
        _purchaseBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_purchaseBut setBackgroundImage:[UIImage imageNamed:@"shopping"] forState:UIControlStateNormal];
        [_purchaseBut setTitle:@"购买" forState:UIControlStateNormal];
        [_purchaseBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _purchaseBut.titleLabel.font = [UIFont systemFontOfSize:12];
        [_purchaseBut addTarget:self action:@selector(purchaseButClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _purchaseBut;
}

@end
