//
//  LoginViewController.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/18.
//

#import "LoginViewController.h"
#import "LoginUserViewController.h"

@interface LoginViewController ()

@property (nonatomic,strong) UIImageView *logoImg;
@property (nonatomic,strong) UILabel *logoL;
@property (nonatomic,strong) UIButton *backBut;
@property (nonatomic,strong) UIButton *iphonLoginBut;
@property (nonatomic,strong) UIButton *passwordLoginBut;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    [self setupLoginUI];
    
}

- (void)setupLoginUI{
    
    [self.view addSubview:self.backBut];
    [self.backBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.height.mas_equalTo(44);
        make.top.mas_equalTo(statusBarHeight);
    }];
    
    [self.view addSubview:self.logoImg];
    [self.logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topHeight + 50);
        make.left.mas_equalTo(50);
        make.height.mas_equalTo(200);
        make.right.mas_equalTo(-50);
    }];
    
    [self.view addSubview:self.logoL];
    [self.logoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoImg.mas_bottom).offset(15);
        make.left.mas_equalTo(50);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-50);
    }];
    
    self.iphonLoginBut.layer.cornerRadius = 45/2;
    self.iphonLoginBut.layer.masksToBounds = YES;
    [self.view addSubview:self.iphonLoginBut];
    [self.iphonLoginBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(- bottomHeight - 150);
        make.left.mas_equalTo(50);
        make.height.mas_equalTo(45);
        make.right.mas_equalTo(-50);
    }];
    
    self.passwordLoginBut.layer.cornerRadius = 45/2;
    self.passwordLoginBut.layer.masksToBounds = YES;
    [self.view addSubview:self.passwordLoginBut];
    [self.passwordLoginBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iphonLoginBut.mas_bottom).offset(15);
        make.left.mas_equalTo(50);
        make.height.mas_equalTo(45);
        make.right.mas_equalTo(-50);
    }];
    
}

#pragma mark - 按钮点击
- (void)iphonLoginButClick:(UIButton *)sender{
    
    // 阿里云一键登录
    [[AlicomFusionAuthTokenManager shareInstance].handler stopSceneWithTemplateId:LOGIN_TEMPLATEID];
    [[AlicomFusionAuthTokenManager shareInstance].handler destroy];
    [AlicomFusionAuthTokenManager shareInstance].handler = nil;
    [[AlicomFusionAuthTokenManager shareInstance] oneClickLogin];
    [AlicomFusionAuthTokenManager shareInstance].loginOutclickBlcok = ^{
        
    };
}

- (void)passwordLoginButClick:(UIButton *)sender{
    LoginUserViewController *navc = [[LoginUserViewController alloc] init];
    [self.navigationController pushViewController:navc animated:YES];
}

- (void)backButClick:(UIButton *)sender{
    
}

#pragma mark - 懒加载
- (UIButton *)backBut{
    if (!_backBut) {
        _backBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBut setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backBut addTarget:self action:@selector(backButClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _backBut;
}

- (UIImageView *)logoImg{
    if (!_logoImg) {
        _logoImg = [[UIImageView alloc]init];;
        _logoImg.backgroundColor = RGB(215, 215, 215);
    }
    return _logoImg;
}

- (UILabel *)logoL{
    if (!_logoL) {
        _logoL = [[UILabel alloc]init];
        _logoL.text = @"记录每一次出发  分享每一程趣事";
        _logoL.font = [UIFont systemFontOfSize:15];
        _logoL.textColor = [UIColor blackColor];
        _logoL.textAlignment = NSTextAlignmentCenter;
    }
    return _logoL;
}

- (UIButton *)iphonLoginBut{
    if (!_iphonLoginBut) {
        _iphonLoginBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iphonLoginBut setTitle:@"手机号登录" forState:UIControlStateNormal];
        _iphonLoginBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [_iphonLoginBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _iphonLoginBut.backgroundColor = RGB(215, 215, 215);
        [_iphonLoginBut addTarget:self action:@selector(iphonLoginButClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _iphonLoginBut;
}

- (UIButton *)passwordLoginBut{
    if (!_passwordLoginBut) {
        _passwordLoginBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_passwordLoginBut setTitle:@"密码登录" forState:UIControlStateNormal];
        _passwordLoginBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [_passwordLoginBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _passwordLoginBut.backgroundColor = RGB(215, 215, 215);
        [_passwordLoginBut addTarget:self action:@selector(passwordLoginButClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _passwordLoginBut;
}


// 在 viewWillAppear: 方法中隐藏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

@end
