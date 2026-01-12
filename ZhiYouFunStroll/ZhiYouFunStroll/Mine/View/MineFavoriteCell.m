//
//  MineFavoriteCell.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/12.
//

#import "MineFavoriteCell.h"

@implementation MineFavoriteCell

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
    // 封面图
    [self.contentView addSubview:self.coverImageView];
    self.coverImageView.layer.cornerRadius = 4;
    self.coverImageView.layer.masksToBounds = YES;
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(self.coverImageView.mas_height).multipliedBy(1);  // 宽高比1:1
    }];
    
    // 箭头
    [self.contentView addSubview:self.arrowImageView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(6.5);
        make.height.mas_equalTo(12);
    }];
    
    // 标题
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coverImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-10);
        make.top.mas_equalTo(self.coverImageView.mas_top).offset(5);
    }];
    
    // 副标题
    [self.contentView addSubview:self.subtitleLabel];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.right.mas_equalTo(self.titleLabel.mas_right);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
}

#pragma mark - Public Methods
- (void)configureWithCoverUrl:(NSString *)coverUrl
                        title:(NSString *)title
                     subtitle:(NSString *)subtitle {
    // 封面图
    NSString *cover = [CheckTool replaceNullValue:coverUrl];
    if (cover.length > 0) {
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:cover] placeholderImage:[UIImage imageNamed:@""]];
    }
    
    // 标题
    self.titleLabel.text = [CheckTool replaceNullValue:title];
    
    // 副标题
    self.subtitleLabel.text = [CheckTool replaceNullValue:subtitle];
}

#pragma mark - Lazy Loading
- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.backgroundColor = RGB(240, 240, 240);
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGB(51, 51, 51);
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textColor = RGB(153, 153, 153);
        _subtitleLabel.font = [UIFont systemFontOfSize:12];
        _subtitleLabel.numberOfLines = 1;
    }
    return _subtitleLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"nex_m"];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _arrowImageView;
}

@end
