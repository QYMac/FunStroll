//
//  LocalDraftCell.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/12.
//

#import "LocalDraftCell.h"

@implementation LocalDraftCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 封面图（带边框）
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.coverImageView.mas_width).multipliedBy(1.2);
    }];
    
    
    // 标题
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverImageView.mas_bottom).offset(15);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    // 日期
    [self.contentView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
    }];
    
    // 删除按钮
    [self.contentView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.dateLabel);
        make.width.height.mas_equalTo(20);
    }];
}

#pragma mark - Public Methods
- (void)configureWithCoverUrl:(NSString *)coverUrl
                        title:(NSString *)title
                         date:(NSString *)date {
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:coverUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.titleLabel.text = title;
    self.dateLabel.text = date;
}

#pragma mark - Actions
- (void)deleteButtonClicked {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

#pragma mark - Lazy Loading
- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.backgroundColor = RGB(240, 240, 240);
    }
    return _coverImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = RGB(51, 51, 51);
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.textColor = RGB(153, 153, 153);
    }
    return _dateLabel;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"shanchu_m"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

@end
