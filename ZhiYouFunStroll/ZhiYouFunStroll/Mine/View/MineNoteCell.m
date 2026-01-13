//
//  MineNoteCell.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/11.
//

#import "MineNoteCell.h"

@implementation MineNoteCell

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
    // 封面图 (顶部圆角)
    [self.contentView addSubview:self.coverImageView];
    self.coverImageView.layer.masksToBounds = YES;
    //self.coverImageView.layer.cornerRadius = 8;
    //self.coverImageView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;  // 只有顶部圆角
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.coverImageView.mas_width).multipliedBy(1.2);
    }];
    
    // 标题
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverImageView.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(40);
    }];
    
    // 用户头像
    self.avatarImageView.layer.cornerRadius = 12.5;
    self.avatarImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
        make.width.height.mas_equalTo(25);
    }];
    
    // 点赞按钮
    [self.contentView addSubview:self.likeButton];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.avatarImageView);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    
    // 用户昵称
    [self.contentView addSubview:self.nicknameLabel];
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(5);
        make.centerY.mas_equalTo(self.avatarImageView);
        make.right.mas_equalTo(self.likeButton.mas_left).offset(-5);
    }];
}

#pragma mark - Public Methods
- (void)configureWithCoverUrl:(NSString *)coverUrl
                        title:(NSString *)title
                    avatarUrl:(NSString *)avatarUrl
                     nickname:(NSString *)nickname
                    likeCount:(NSInteger)likeCount
                      isLiked:(BOOL)isLiked {
    
    // 封面图
    NSString *cover = [CheckTool replaceNullValue:coverUrl];
    if (cover.length > 0) {
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:cover] placeholderImage:[UIImage imageNamed:@""]];
    }
    
    // 标题
    NSString *titleStr = [CheckTool replaceNullValue:title];
    NSInteger num = [LabelSpacing needLinesWithWidth:self.frame.size.width - 20 textStr:titleStr font:14];
    if (num >= 2) {
        num = 2;
    }
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(num * 18);
    }];
    self.titleLabel.text = titleStr;
    
    // 头像
    NSString *avatar = [CheckTool replaceNullValue:avatarUrl];
    if (avatar.length > 0) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"touxiang_m"]];
    }
    
    // 昵称
    self.nicknameLabel.text = [CheckTool replaceNullValue:nickname];
    
    // 点赞数
    NSString *likeCountStr = [DateHelper formatNumber:(int)likeCount];
    [self.likeButton setTitle:likeCountStr forState:UIControlStateNormal];
    
    // 点赞状态
    self.isLiked = isLiked;
    if (isLiked) {
        [self.likeButton setImage:[UIImage imageNamed:@"like_off"] forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"like_on"] forState:UIControlStateNormal];
    }
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
        _titleLabel = [[TopLeftLabel alloc] init];
        _titleLabel.textColor = RGB(51, 51, 51);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.backgroundColor = RGB(240, 240, 240);
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.image = [UIImage imageNamed:@"touxiang_m"];
    }
    return _avatarImageView;
}

- (UILabel *)nicknameLabel {
    if (!_nicknameLabel) {
        _nicknameLabel = [[UILabel alloc] init];
        _nicknameLabel.textColor = RGB(102, 102, 102);
        _nicknameLabel.font = [UIFont systemFontOfSize:12];
    }
    return _nicknameLabel;
}

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeButton setImage:[UIImage imageNamed:@"like_on"] forState:UIControlStateNormal];
        [_likeButton setTitle:@"0" forState:UIControlStateNormal];
        [_likeButton setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _likeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_likeButton setImagePositionWithType:SSImagePositionTypeLeft spacing:2];
    }
    return _likeButton;
}

@end
