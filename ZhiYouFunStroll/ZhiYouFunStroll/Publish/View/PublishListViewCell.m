//
//  PublishListViewCell.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/4.
//

#import "PublishListViewCell.h"

@implementation PublishListViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;//去除cell的点击效果
        self.backgroundColor = [UIColor whiteColor];
        
        self.bgView.layer.cornerRadius = 6;
        self.bgView.layer.borderWidth = 1;
        self.bgView.layer.borderColor = RGB(240, 240, 240).CGColor;
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(100);
            make.bottom.mas_equalTo(-10);
        }];
        
        [self.bgView addSubview:self.headImg];
        [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(25);
        }];
        
        [self.bgView addSubview:self.headL];
        [self.headL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(25);
        }];
        
        self.image.layer.cornerRadius = 6;
        self.image.layer.masksToBounds = YES;
        [self.bgView addSubview:self.image];
        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImg.mas_right).offset(10);
            make.centerY.mas_equalTo(self.headImg);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(80);
        }];
        
        [self.bgView addSubview:self.nameL];
        [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.image.mas_right).offset(10);
            make.top.mas_equalTo(self.image.mas_top).offset(0);
            make.right.mas_equalTo(-100);
            make.height.mas_equalTo(20);
        }];
        
        [self.bgView addSubview:self.statusL];
        [self.statusL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.nameL.mas_top).offset(0);
            make.left.mas_equalTo(self.nameL.mas_right).offset(10);
            make.height.mas_equalTo(20);
        }];
        
        [self.bgView addSubview:self.contentL];
        [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameL.mas_left).offset(0);
            make.top.mas_equalTo(self.nameL.mas_bottom).offset(5);
            make.right.mas_equalTo(-15);
        }];
        
        [self.bgView addSubview:self.timeL1];
        [self.timeL1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.bottom.mas_equalTo(self.image.mas_bottom).offset(0);
            make.width.mas_equalTo(80);
            make.left.mas_equalTo(self.nameL.mas_left).offset(0);
        }];
        
        [self.bgView addSubview:self.timeL2];
        [self.timeL2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.bottom.mas_equalTo(self.image.mas_bottom).offset(0);
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(self.timeL1.mas_right).offset(10);
        }];
        
        
    }
    return self;
}

- (void)publishListViewCellIndexPath:(NSIndexPath *)indexPath dict:(NSDictionary *)dict{
    if (indexPath.row == 0) {
        self.statusL.text = @"草稿";
    } else if (indexPath.row == 1) {
        self.statusL.text = @"待审核";
        self.headImg.image = [UIImage imageNamed:@"rectangleHead"];
    } else if (indexPath.row == 2) {
        self.statusL.text = @"已发布";
        self.statusL.textColor = RGB(173, 173, 173);
        self.headImg.image = [UIImage imageNamed:@"rectangleHead"];
    }
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
        _headImg = [[UIImageView alloc] init];
        //_headImg.backgroundColor = RGB(189, 189, 189);
        _headImg.image = [UIImage imageNamed:@"rectangleHead_on"];
        //_headImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headImg;
}

- (UILabel *)headL{
    if (!_headL) {
        _headL = [[UILabel alloc]init];
        _headL.text = @"图\n文\n动\n态";
        _headL.font = [UIFont systemFontOfSize:10];
        _headL.textColor = [UIColor whiteColor];
        _headL.numberOfLines = 0;
        _headL.textAlignment = NSTextAlignmentCenter;
    }
    return _headL;
}

- (UIImageView *)image{
    if (!_image) {
        _image = [[UIImageView alloc] init];
        _image.backgroundColor = RGB(240, 240, 240);
        _image.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _image;
}

- (UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]init];
        _nameL.text = @"东莞两日游";
        _nameL.font = [UIFont systemFontOfSize:15];
        _nameL.textColor = [UIColor blackColor];
    }
    return _nameL;
}

- (TopLeftLabel *)contentL{
    if (!_contentL) {
        _contentL = [[TopLeftLabel alloc]init];
        _contentL.text = @"2025.10.01-2025.10.2";
        _contentL.font = [UIFont systemFontOfSize:12];
        _contentL.textColor = RGB(173, 173, 173);
        _contentL.numberOfLines = 2;
    }
    return _contentL;
}

- (UILabel *)statusL{
    if (!_statusL) {
        _statusL = [[UILabel alloc]init];
        _statusL.text = @"草稿";
        _statusL.font = [UIFont systemFontOfSize:12];
        _statusL.textColor = [UIColor redColor];
        _statusL.textAlignment = NSTextAlignmentRight;
    }
    return _statusL;
}

- (UILabel *)timeL1{
    if (!_timeL1) {
        _timeL1 = [[UILabel alloc]init];
        _timeL1.text = @"时长:2天1晚";
        _timeL1.font = [UIFont systemFontOfSize:12];
        _timeL1.textColor = RGB(173, 173, 173);
        _timeL1.textAlignment = NSTextAlignmentLeft;
    }
    return _timeL1;
}

- (UILabel *)timeL2{
    if (!_timeL2) {
        _timeL2 = [[UILabel alloc]init];
        _timeL2.text = @"创建时间:2025.9.30 11:50";
        _timeL2.font = [UIFont systemFontOfSize:10];
        _timeL2.textColor = RGB(173, 173, 173);
        _timeL2.textAlignment = NSTextAlignmentRight;
    }
    return _timeL2;
}

@end
