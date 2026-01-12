//
//  CollectionListCell.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2026/1/12.
//

#import "CollectionListCell.h"

@implementation CollectionListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 4;
        self.contentView.layer.masksToBounds = YES;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.center.mas_equalTo(self);
        make.width.height.mas_equalTo(80);
    }];
}

#pragma mark - 懒加载
- (UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.backgroundColor = RGB(240, 240, 240);
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverImageView;
}

- (TopLeftLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[TopLeftLabel alloc] init];
        _titleLabel.textColor = RGB(51, 51, 51);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = RGB(153, 153, 153);
        _addressLabel.font = [UIFont systemFontOfSize:12];
    }
    return _addressLabel;
}

@end
