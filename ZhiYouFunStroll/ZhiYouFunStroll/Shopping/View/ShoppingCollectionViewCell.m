//
//  ShoppingCollectionViewCell.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/27.
//

#import "ShoppingCollectionViewCell.h"

@implementation ShoppingCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius= 6;
        self.contentView.layer.masksToBounds= YES;
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.borderColor = RGB(240, 240, 240).CGColor;
        
        self.shoppingImage.layer.cornerRadius = 6;
        self.shoppingImage.layer.masksToBounds= YES;
        [self.contentView addSubview:self.shoppingImage];
        [self.shoppingImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(100);
            make.left.top.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
        
        [self.contentView addSubview:self.shoppingBut];
        [self.shoppingBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(45);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-15);
        }];
        
        [self.contentView addSubview:self.nameL];
        [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(self.shoppingImage.mas_bottom).offset(10);
        }];
        
        [self.contentView addSubview:self.moneyTitleL];
        [self.moneyTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(30);
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-15);
        }];
        
        [self.contentView addSubview:self.moneyL];
        [self.moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(self.shoppingBut.mas_left).offset(-10);
            make.left.mas_equalTo(self.moneyTitleL.mas_right).offset(0);
            make.bottom.mas_equalTo(-15);
        }];
        
    }
    return self;
}

#pragma mark - 按钮点击
- (void)shoppingButClick:(UIButton *)sender{
    
}

#pragma mark - 懒加载
- (UIImageView *)shoppingImage{
    if (!_shoppingImage) {
        _shoppingImage = [[UIImageView alloc]init];
        _shoppingImage.backgroundColor = RGB(240, 240, 240);
        _shoppingImage.contentMode = UIViewContentModeScaleToFill;
    }
    return _shoppingImage;
}

- (UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]init];
        _nameL.textColor = [UIColor blackColor];
        _nameL.text = @"萌宠主题";
        _nameL.font = [UIFont systemFontOfSize:15];
        _nameL.textAlignment = NSTextAlignmentCenter;
    }
    return _nameL;
}

- (UILabel *)moneyTitleL{
    if (!_moneyTitleL) {
        _moneyTitleL = [[UILabel alloc]init];
        _moneyTitleL.textColor = RGB(173, 173, 173);
        _moneyTitleL.text = @"售价:";
        _moneyTitleL.font = [UIFont systemFontOfSize:12];
    }
    return _moneyTitleL;
}

- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.textColor = RGB(255, 46, 46);
        _moneyL.text = @"¥9.9";
        _moneyL.font = [UIFont systemFontOfSize:12];
    }
    return _moneyL;
}

- (UIButton *)shoppingBut{
    if (!_shoppingBut) {
        _shoppingBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shoppingBut setBackgroundImage:[UIImage imageNamed:@"shopping"] forState:UIControlStateNormal];
        [_shoppingBut setTitle:@"购买" forState:UIControlStateNormal];
        [_shoppingBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _shoppingBut.titleLabel.font = [UIFont systemFontOfSize:12];
        [_shoppingBut addTarget:self action:@selector(shoppingButClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shoppingBut;
}

@end
