//
//  MineHeaderView.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/11.
//

#import "MineHeaderView.h"

@interface MineHeaderView ()

@property (nonatomic, strong) UIView *avatarContainer;

@end

@implementation MineHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(244, 244, 244);
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 背景图
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        //make.height.mas_equalTo(320);
    }];
    
    // 设置按钮
    [self addSubview:self.settingButton];
    CGFloat topFloat = statusBarHeight;
    if ([DeviceInfoHelper isDynamicIsland] == YES) {
        topFloat = statusBarHeight + 10;
    }
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topFloat);
        make.right.mas_equalTo(-15);
        make.width.height.mas_equalTo(30);
    }];
    
    // 头像容器(虚线边框)
    self.avatarContainer = [[UIView alloc] init];
    self.avatarContainer.backgroundColor = [UIColor clearColor];
    [self addSubview:self.avatarContainer];
    [self.avatarContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(topFloat + 78);
        make.width.height.mas_equalTo(50);
    }];
    
    // 头像
    [self.avatarContainer addSubview:self.avatarImageView];
    self.avatarImageView.layer.cornerRadius = 25;
    self.avatarImageView.layer.masksToBounds = YES;
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.avatarContainer);
        make.width.height.mas_equalTo(50);
    }];
    
    // 添加头像点击手势
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapped)];
    self.avatarContainer.userInteractionEnabled = YES;
    [self.avatarContainer addGestureRecognizer:avatarTap];
    
    // 用户名
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarContainer.mas_left);
        make.top.mas_equalTo(self.avatarContainer.mas_bottom).offset(10);
    }];
    
    
    // 用户ID
    [self addSubview:self.idLabel];
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarContainer.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(15);
    }];
    
    // 双箭(用户名旁边)
    [self addSubview:self.arrowBut];
    [self.arrowBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.idLabel.mas_right).offset(30);
        make.top.mas_equalTo(self.idLabel.mas_top).offset(-20);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    // 个人简介
    [self addSubview:self.bioLabel];
    [self.bioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left).offset(0);
        make.top.mas_equalTo(self.idLabel.mas_bottom).offset(17.5);
        make.right.mas_lessThanOrEqualTo(-35);
    }];
    
    // 编辑按钮
    [self addSubview:self.editBioButton];
    [self.editBioButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bioLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.bioLabel);
        make.width.height.mas_equalTo(20);
    }];
    
    // TabBar切换视图
    [self addSubview:self.tabBarView];
    [self.tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.bioLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];
    
    [self.tabBarView layoutIfNeeded];
    [self.tabBarView addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(22, 22)];
    
    // 警告横幅
    [self addSubview:self.alertBannerView];
    [self.alertBannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.tabBarView.mas_bottom).offset(5);
        make.height.mas_equalTo(45);
    }];
    
    // 警告图标
    UIImageView *alertIcon = [[UIImageView alloc] init];
    alertIcon.image = [UIImage imageNamed:@"jinggao_m"];
    alertIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.alertBannerView addSubview:alertIcon];
    [alertIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.alertBannerView);
        make.width.height.mas_equalTo(15);
    }];
    
    // 警告文本
    [self.alertBannerView addSubview:self.alertLabel];
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(alertIcon.mas_right).offset(10);
        make.right.mas_equalTo(-45);
        make.centerY.mas_equalTo(self.alertBannerView);
    }];
    
    [self.alertBannerView addSubview:self.arrowBut1];
    [self.arrowBut1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.alertLabel);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    // 警告横幅点击手势
    UITapGestureRecognizer *alertTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alertBannerTapped)];
    [self.alertBannerView addGestureRecognizer:alertTap];
    
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.tabBarView.mas_top);
    }];
    
}

#pragma mark - Actions
- (void)settingButtonClicked {
    if (self.settingButtonClickBlock) {
        self.settingButtonClickBlock();
    }
}

- (void)editBioClicked {
    if (self.editBioClickBlock) {
        self.editBioClickBlock();
    }
}

- (void)avatarTapped {
    if (self.avatarClickBlock) {
        self.avatarClickBlock();
    }
}

- (void)alertBannerTapped {
    if (self.alertBannerClickBlock) {
        self.alertBannerClickBlock();
    }
}

- (void)arrowButClicked{
    
}

- (void)arrowBut1Clicked{
    
}

#pragma mark - Public Methods
- (void)updateWithUserName:(NSString *)userName
                    userId:(NSString *)userId
                       bio:(NSString *)bio
                 avatarUrl:(NSString *)avatarUrl {
    self.nameLabel.text = [CheckTool replaceNullValue:userName];
    self.idLabel.text = [NSString stringWithFormat:@"ID:%@", [CheckTool replaceNullValue:userId]];
    
    NSString *bioText = [CheckTool replaceNullValue:bio];
    if (bioText.length == 0) {
        bioText = @"给自己写点什么，更多人认识您";
    }
    self.bioLabel.text = bioText;
    
    NSString *avatar = [CheckTool replaceNullValue:avatarUrl];
    if (avatar.length > 0) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"touxiang_m"]];
    }
}

- (void)setAlertMessage:(NSString *)message hidden:(BOOL)hidden {
    self.alertBannerView.hidden = hidden;
    self.alertLabel.text = message;
}

#pragma mark - Lazy Loading
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"userbg_m"];
        //_bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        //_bgImageView.clipsToBounds = YES;
    }
    return _bgImageView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.backgroundColor = RGB(240, 240, 240);
        _avatarImageView.image = [UIImage imageNamed:@"touxiang_m"];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"这里显示姓名";
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        _nameLabel.textColor = RGB(51, 51, 51);
    }
    return _nameLabel;
}

- (UIButton *)arrowBut {
    if (!_arrowBut) {
        _arrowBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrowBut setImage:[UIImage imageNamed:@"nex_m"] forState:UIControlStateNormal];
        [_arrowBut addTarget:self action:@selector(arrowButClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arrowBut;
}

- (UILabel *)idLabel {
    if (!_idLabel) {
        _idLabel = [[UILabel alloc] init];
        _idLabel.text = @"ID:TCL12346";
        _idLabel.font = [UIFont systemFontOfSize:12];
        _idLabel.textColor = RGB(153, 153, 153);
    }
    return _idLabel;
}

- (UILabel *)bioLabel {
    if (!_bioLabel) {
        _bioLabel = [[UILabel alloc] init];
        _bioLabel.text = @"给自己写点什么，更多人认识您";
        _bioLabel.font = [UIFont systemFontOfSize:12];
        _bioLabel.textColor = RGB(102, 102, 102);
        _bioLabel.numberOfLines = 0;
    }
    return _bioLabel;
}

- (UIButton *)editBioButton {
    if (!_editBioButton) {
        _editBioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBioButton setImage:[UIImage imageNamed:@"bianji_m"] forState:UIControlStateNormal];
        [_editBioButton addTarget:self action:@selector(editBioClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBioButton;
}

- (UIButton *)settingButton {
    if (!_settingButton) {
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingButton setImage:[UIImage imageNamed:@"shezhi_m"] forState:UIControlStateNormal];
        [_settingButton addTarget:self action:@selector(settingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingButton;
}

- (MineTabBarView *)tabBarView {
    if (!_tabBarView) {
        _tabBarView = [[MineTabBarView alloc] init];
        _tabBarView.backgroundColor = [UIColor whiteColor];
        WeakSelf
        _tabBarView.tabChangedBlock = ^(MineTabType tabType) {
            if (weakSelf.tabChangedBlock) {
                weakSelf.tabChangedBlock(tabType);
            }
        };
    }
    return _tabBarView;
}

- (UIView *)alertBannerView {
    if (!_alertBannerView) {
        _alertBannerView = [[UIView alloc] init];
        _alertBannerView.backgroundColor = [UIColor whiteColor];
        _alertBannerView.userInteractionEnabled = YES;
    }
    return _alertBannerView;
}

- (UILabel *)alertLabel {
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc] init];
        _alertLabel.text = @"1条笔记发布异常";
        _alertLabel.textColor = [UIColor blackColor];
        _alertLabel.font = [UIFont systemFontOfSize:12];
    }
    return _alertLabel;
}

- (UIButton *)arrowBut1 {
    if (!_arrowBut1) {
        _arrowBut1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrowBut1 setImage:[UIImage imageNamed:@"nex_m"] forState:UIControlStateNormal];
        [_arrowBut1 addTarget:self action:@selector(arrowBut1Clicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arrowBut1;
}


- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.alpha = 0;
        _bgView.userInteractionEnabled = NO;
    }
    return _bgView;
}

@end
