//
//  ProfileInfoCell.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/12.
//

#import "ProfileInfoCell.h"

@implementation ProfileInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 背景卡片
    [self.contentView addSubview:self.bgCardView];
    [self.bgCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.bottom.mas_equalTo(0);
    }];
    
    // 标题
    [self.bgCardView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.bgCardView);
        make.width.mas_equalTo(60);
    }];
    
    // 右侧图标
    [self.bgCardView addSubview:self.accessoryIcon];
    [self.accessoryIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.bgCardView);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(12);
    }];
    
    // 值
    [self.bgCardView addSubview:self.valueLabel];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(20);
        make.right.mas_equalTo(self.accessoryIcon.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.bgCardView);
    }];
    
    // 分割线
    [self.bgCardView addSubview:self.separatorLine];
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - Public Methods
- (void)configureWithTitle:(NSString *)title
                     value:(NSString *)value
               placeholder:(NSString *)placeholder
                  cellType:(ProfileCellType)cellType {
    
    self.titleLabel.text = title;
    
    // 根据是否有值设置显示
    if (value.length > 0) {
        self.valueLabel.text = value;
        self.valueLabel.textColor = RGB(51, 51, 51);
    } else {
        self.valueLabel.text = placeholder;
        self.valueLabel.textColor = RGB(187, 187, 187);
    }
    
    // 根据类型设置图标
    switch (cellType) {
        case ProfileCellTypeDefault: {
            self.accessoryIcon.hidden = YES;
            [self.valueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-15);
            }];
            break;
        }
        case ProfileCellTypeEdit: {
            self.accessoryIcon.hidden = NO;
            self.accessoryIcon.image = [UIImage imageNamed:@"user_next"];
            [self.valueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.accessoryIcon.mas_left).offset(-10);
            }];
            break;
        }
        case ProfileCellTypeArrow: {
            self.accessoryIcon.hidden = NO;
            self.accessoryIcon.image = [UIImage imageNamed:@"user_next"];
            [self.valueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.accessoryIcon.mas_left).offset(-10);
            }];
            break;
        }
        default:
            break;
    }
}

- (void)configurePosition:(ProfileCellPosition)position {
    CGFloat cornerRadius = 8;
    
    // 重置圆角
    self.bgCardView.layer.mask = nil;
    
    UIRectCorner corners = 0;
    BOOL showSeparator = NO;
    
    switch (position) {
        case ProfileCellPositionOnly: {
            // 唯一一个，四角圆角，不显示分割线
            corners = UIRectCornerAllCorners;
            showSeparator = NO;
            break;
        }
        case ProfileCellPositionFirst: {
            // 第一个，顶部圆角，不显示分割线
            corners = UIRectCornerTopLeft | UIRectCornerTopRight;
            showSeparator = NO;
            break;
        }
        case ProfileCellPositionMiddle: {
            // 中间，无圆角，显示分割线
            corners = 0;
            showSeparator = YES;
            break;
        }
        case ProfileCellPositionLast: {
            // 最后一个，底部圆角，不显示分割线
            corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            showSeparator = NO;
            break;
        }
        default:
            break;
    }
    
    self.separatorLine.hidden = !showSeparator;
    
    // 需要在 layoutSubviews 之后设置圆角 mask
    dispatch_async(dispatch_get_main_queue(), ^{
        if (corners != 0) {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bgCardView.bounds
                                                      byRoundingCorners:corners
                                                            cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.path = path.CGPath;
            self.bgCardView.layer.mask = maskLayer;
        } else {
            self.bgCardView.layer.mask = nil;
        }
    });
}

#pragma mark - Lazy Loading
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = RGB(153, 153, 153);
    }
    return _titleLabel;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.font = [UIFont systemFontOfSize:14];
        _valueLabel.textColor = RGB(51, 51, 51);
        _valueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _valueLabel;
}

- (UIImageView *)accessoryIcon {
    if (!_accessoryIcon) {
        _accessoryIcon = [[UIImageView alloc] init];
        _accessoryIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _accessoryIcon;
}

- (UIView *)bgCardView {
    if (!_bgCardView) {
        _bgCardView = [[UIView alloc] init];
        _bgCardView.backgroundColor = [UIColor whiteColor];
    }
    return _bgCardView;
}

- (UIView *)separatorLine {
    if (!_separatorLine) {
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = RGB(238, 238, 238);
    }
    return _separatorLine;
}

@end
