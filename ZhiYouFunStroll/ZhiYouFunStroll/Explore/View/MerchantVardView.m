//
//  MerchantVardView.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/26.
//

#import "MerchantVardView.h"

@implementation MerchantVardView

#pragma mark -- 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3;
        
        [self addSubview:self.vardImage];
        self.vardImage.layer.cornerRadius = 3;
        self.vardImage.layer.masksToBounds = YES;
        [self.vardImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(15);
            make.width.height.mas_equalTo(80);
        }];
        
        [self addSubview:self.nameL];
        [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.vardImage.mas_top).offset(0);
            make.left.mas_equalTo(self.vardImage.mas_right).offset(15);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(20);
        }];
        
        [self addSubview:self.distanceBut];
        [self.distanceBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameL.mas_bottom).offset(5);
            make.left.mas_equalTo(self.vardImage.mas_right).offset(7.5);
            make.width.mas_equalTo(110);
            make.height.mas_equalTo(20);
        }];
        
        [self addSubview:self.statusL];
        [self.statusL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.vardImage.mas_bottom).offset(0);
            make.left.mas_equalTo(self.vardImage.mas_right).offset(15);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(20);
        }];
        
        [self addSubview:self.addressL];
        [self.addressL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.vardImage.mas_top).offset(0);
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(self.nameL.mas_right).offset(10);
            make.height.mas_equalTo(20);
        }];
        
        [self addSubview:self.iphoneBut];
        [self.iphoneBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.distanceBut.mas_top).offset(0);
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(self.distanceBut.mas_right).offset(10);
            make.height.mas_equalTo(20);
        }];
        
        [self addSubview:self.timeL];
        [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.statusL.mas_bottom).offset(0);
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(self.statusL.mas_right).offset(10);
            make.height.mas_equalTo(20);
        }];
    }
    
    return self;
}

#pragma mark - 懒加载
- (UIImageView *)vardImage{
    if (!_vardImage) {
        _vardImage = [[UIImageView alloc]init];
        _vardImage.image = [UIImage imageNamed:@"home2"];
        _vardImage.contentMode = UIViewContentModeScaleToFill;
        _vardImage.backgroundColor = RGB(240, 240, 240);
    }
    return _vardImage;
}

- (UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]init];
        _nameL.text = @"观音山森林公园";
        _nameL.numberOfLines = 2;
        _nameL.font = [UIFont systemFontOfSize:16];
    }
    return _nameL;
}

- (UIButton *)distanceBut{
    if (!_distanceBut) {
        _distanceBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_distanceBut setTitle:@"距离您12.6km" forState:UIControlStateNormal];
        [_distanceBut setImage:[UIImage imageNamed:@"addressImg"] forState:UIControlStateNormal];
        [_distanceBut setTitleColor:RGB(173, 173, 173) forState:UIControlStateNormal];
        _distanceBut.titleLabel.font = [UIFont systemFontOfSize:12];
        _distanceBut.userInteractionEnabled = NO;
        [_distanceBut setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
        
    }
    return _distanceBut;
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

- (UILabel *)addressL{
    if (!_addressL) {
        _addressL = [[UILabel alloc]init];
        _addressL.text = @"架山路190号";
        _addressL.font = [UIFont systemFontOfSize:10];
        _addressL.textColor = RGB(173, 173, 173);
        _addressL.textAlignment = NSTextAlignmentRight;
    }
    return _addressL;
}

- (UIButton *)iphoneBut{
    if (!_iphoneBut) {
        _iphoneBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iphoneBut setTitle:@"025-263421" forState:UIControlStateNormal];
        [_iphoneBut setImage:[UIImage imageNamed:@"iphoneImg"] forState:UIControlStateNormal];
        [_iphoneBut setTitleColor:RGB(173, 173, 173) forState:UIControlStateNormal];
        _iphoneBut.titleLabel.font = [UIFont systemFontOfSize:12];
        // 按钮文字靠右
        _iphoneBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_iphoneBut setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
        
    }
    return _iphoneBut;
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
