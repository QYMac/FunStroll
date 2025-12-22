//
//  WeatherViewCell.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/5.
//

#import "WeatherViewCell.h"

@implementation WeatherViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;//去除cell的点击效果
        self.backgroundColor = [UIColor clearColor];
        
        
    }
    return self;
}

- (void)weatherViewCellIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        self.bgView1.hidden = NO;
        [self setupAddressWeatherView];
    } else if (indexPath.row == 1) {
        self.bgView2.hidden = NO;
        [self setupAddressTemperatureView];
        
    }
}

- (void)setupAddressWeatherView{
    self.bgView1.layer.cornerRadius = 6;
    self.bgView1.layer.masksToBounds = YES;
    [self.contentView addSubview:self.bgView1];
    [self.bgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(145);
    }];
    
    [self.bgView1 addSubview:self.addressTitleL];
    [self.addressTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(20);
    }];
    
    [self.bgView1 addSubview:self.cityL];
    [self.cityL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.addressTitleL.mas_bottom).offset(0);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
    }];
    
    [self.bgView1 addSubview:self.temperatureL1];
    [self.temperatureL1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.cityL.mas_bottom).offset(0);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
    }];
    
    [self.bgView1 addSubview:self.temperatureL2];
    [self.temperatureL2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.temperatureL1.mas_bottom).offset(10);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(20);
    }];
}

- (void)setupAddressTemperatureView{
    self.bgView2.layer.cornerRadius = 6;
    self.bgView2.layer.masksToBounds = YES;
    [self.contentView addSubview:self.bgView2];
    [self.bgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(250);
    }];
    
    [self.bgView2 addSubview:self.titleL1];
    [self.titleL1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(20);
    }];

}

#pragma mark - 懒加载
- (UIView *)bgView1{
    if (!_bgView1) {
        _bgView1 = [[UIView alloc]init];
        _bgView1.backgroundColor = [UIColor whiteColor];
        _bgView1.hidden = YES;
    }
    return _bgView1;
}

- (UILabel *)addressTitleL{
    if (!_addressTitleL) {
        _addressTitleL = [[UILabel alloc]init];
        _addressTitleL.text = @"我的位置";
        _addressTitleL.font = [UIFont systemFontOfSize:12];
        _addressTitleL.textColor = [UIColor blackColor];
        _addressTitleL.textAlignment = NSTextAlignmentCenter;
    }
    return _addressTitleL;
}

- (UILabel *)cityL{
    if (!_cityL) {
        _cityL = [[UILabel alloc]init];
        _cityL.text = @"东莞";
        _cityL.font = [UIFont boldSystemFontOfSize:24];
        _cityL.textColor = [UIColor blackColor];
        _cityL.textAlignment = NSTextAlignmentCenter;
    }
    return _cityL;
}


- (UILabel *)temperatureL1{
    if (!_temperatureL1) {
        _temperatureL1 = [[UILabel alloc]init];
        _temperatureL1.text = @"  26°";
        _temperatureL1.font = [UIFont boldSystemFontOfSize:36];
        _temperatureL1.textColor = RGB(249, 143, 73);
        _temperatureL1.textAlignment = NSTextAlignmentCenter;
    }
    return _temperatureL1;
}

- (UILabel *)temperatureL2{
    if (!_temperatureL2) {
        _temperatureL2 = [[UILabel alloc]init];
        _temperatureL2.text = @"最高：30°    最低：24°";
        _temperatureL2.font = [UIFont boldSystemFontOfSize:12];
        _temperatureL2.textColor = [UIColor blackColor];
        _temperatureL2.textAlignment = NSTextAlignmentCenter;
    }
    return _temperatureL2;
}

- (UIView *)bgView2{
    if (!_bgView2) {
        _bgView2 = [[UIView alloc]init];
        _bgView2.backgroundColor = [UIColor whiteColor];
        _bgView2.hidden = YES;
    }
    return _bgView2;
}

- (UILabel *)titleL1{
    if (!_titleL1) {
        _titleL1 = [[UILabel alloc]init];
        _titleL1.text = @"短时内无降雨";
        _titleL1.font = [UIFont systemFontOfSize:12];
        _titleL1.textColor = [UIColor blackColor];
        //_titleL1.textAlignment = NSTextAlignmentCenter;
    }
    return _titleL1;
}


@end
