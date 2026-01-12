//
//  ProfileHeaderView.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/12.
//

#import "ProfileHeaderView.h"

@interface ProfileHeaderView ()

@property (nonatomic, strong) UIView *avatarContainer;

@end

@implementation ProfileHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(250, 250, 250);
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 头像容器
    [self addSubview:self.avatarContainer];
    [self.avatarContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(30);
        make.width.height.mas_equalTo(70);
    }];
    
    // 头像
    [self.avatarContainer addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    // 相机图标
    [self.avatarContainer addSubview:self.cameraIcon];
    [self.cameraIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(-3);
        make.width.height.mas_equalTo(17);
    }];
    
    // 添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapped)];
    self.avatarContainer.userInteractionEnabled = YES;
    [self.avatarContainer addGestureRecognizer:tap];
}

#pragma mark - Actions
- (void)avatarTapped {
    if (self.avatarTappedBlock) {
        self.avatarTappedBlock();
    }
}

#pragma mark - Public Methods
- (void)setAvatarImage:(UIImage *)image {
    self.avatarImageView.image = image;
}

- (void)setAvatarWithUrl:(NSString *)url {
    if (url.length > 0) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"touxiang_m"]];
    }
}

#pragma mark - Lazy Loading
- (UIView *)avatarContainer {
    if (!_avatarContainer) {
        _avatarContainer = [[UIView alloc] init];
        _avatarContainer.backgroundColor = [UIColor clearColor];
    }
    return _avatarContainer;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 35;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.backgroundColor = RGB(240, 240, 240);
        _avatarImageView.image = [UIImage imageNamed:@"touxiang_m"];
    }
    return _avatarImageView;
}

- (UIImageView *)cameraIcon {
    if (!_cameraIcon) {
        _cameraIcon = [[UIImageView alloc] init];
        _cameraIcon.image = [UIImage imageNamed:@"user_Camera"];
        _cameraIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _cameraIcon;
}

@end
