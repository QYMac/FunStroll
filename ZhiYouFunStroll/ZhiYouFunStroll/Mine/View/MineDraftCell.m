//
//  MineDraftCell.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/11.
//

#import "MineDraftCell.h"

@implementation MineDraftCell

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
    // 背景图
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    /*
    // 半透明遮罩层
    UIView *overlayView = [[UIView alloc] init];
    overlayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.contentView addSubview:overlayView];
    [overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
     */
    
    // 图标
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.contentView).offset(-20);
        make.width.height.mas_equalTo(20);
    }];
    
    // 标题
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(10);
    }];
    
    // 副标题
    [self.contentView addSubview:self.subtitleLabel];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
    }];
    
    [self.contentView addSubview:self.nexImg];
    [self.nexImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.subtitleLabel);
        make.left.mas_equalTo(self.subtitleLabel.mas_right).offset(2);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(10);
    }];
}

#pragma mark - Public Methods
- (void)configureDraftCount:(NSInteger)count backgroundImage:(UIImage *)bgImage {
    if (bgImage) {
        self.bgImageView.image = bgImage;
    }
    
    NSString *subtitle = [NSString stringWithFormat:@"有%ld篇笔记待发布", (long)count];
    self.subtitleLabel.text = subtitle;
}

#pragma mark - Lazy Loading
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
        _bgImageView.image = [UIImage imageNamed:@"my_bg"];
    }
    return _bgImageView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"caogao_m"];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

- (UIImageView *)nexImg {
    if (!_nexImg) {
        _nexImg = [[UIImageView alloc] init];
        _nexImg.image = [UIImage imageNamed:@"my_next"];;
    }
    return _nexImg;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"本地草稿";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.text = @"有1篇笔记待发布";
        _subtitleLabel.textColor = [UIColor whiteColor];
        _subtitleLabel.font = [UIFont systemFontOfSize:10];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subtitleLabel;
}

@end
