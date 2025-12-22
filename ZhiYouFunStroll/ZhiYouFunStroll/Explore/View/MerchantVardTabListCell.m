//
//  MerchantVardTabListCell.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/27.
//

#import "MerchantVardTabListCell.h"

@implementation MerchantVardTabListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;//去除cell的点击效果
    
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        [self.bgView addSubview:self.fgView];
        [self.fgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(3);
            make.right.mas_equalTo(-3);
            make.bottom.mas_equalTo(-1);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.contentView addSubview:self.nameL];
        [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(5);
            make.right.mas_equalTo(-100);
            make.left.mas_equalTo(15);
        }];
        
        [self.contentView addSubview:self.addressL];
        [self.addressL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(10);
            make.top.mas_equalTo(self.nameL.mas_bottom).offset(0);
            make.right.mas_equalTo(-100);
            make.left.mas_equalTo(15);
        }];
        
        [self.contentView addSubview:self.distanceL];
        [self.distanceL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.centerY.mas_equalTo(self.contentView);
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(self.addressL.mas_right).offset(10);
        }];
        
    }
    return self;
}

#pragma mark - 懒加载
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.3;
    }
    return _bgView;
}

- (UIView *)fgView{
    if (!_fgView) {
        _fgView = [[UIView alloc]init];
        _fgView.backgroundColor = [UIColor whiteColor];
    }
    return _fgView;
}


- (UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]init];
        _nameL.text = @"观音山森林公园";
        _nameL.font = [UIFont systemFontOfSize:12];
        _nameL.textColor = [UIColor whiteColor];
    }
    return _nameL;
}

- (UILabel *)addressL{
    if (!_addressL) {
        _addressL = [[UILabel alloc]init];
        _addressL.text = @"樟木头镇石新社区笔架山路190号";
        _addressL.font = [UIFont systemFontOfSize:10];
        _addressL.textColor = [UIColor whiteColor];
    }
    return _addressL;
}

- (UILabel *)distanceL{
    if (!_distanceL) {
        _distanceL = [[UILabel alloc]init];
        _distanceL.text = @"3.6公里";
        _distanceL.font = [UIFont systemFontOfSize:12];
        _distanceL.textColor = [UIColor whiteColor];
        _distanceL.textAlignment = NSTextAlignmentRight;
    }
    return _distanceL;
}

@end
