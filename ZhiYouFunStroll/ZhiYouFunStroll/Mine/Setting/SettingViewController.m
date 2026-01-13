//
//  SettingViewController.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/12.
//

#import "SettingViewController.h"
#import "AboutViewController.h"

@interface SettingViewController ()

@property (nonatomic, strong) UIView *aboutView;
@property (nonatomic, strong) UIButton *logoutButton;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(245, 245, 245);
    self.title = @"设置";
    
    [self setupNavigationBar];
    [self setupUI];
}

- (void)setupNavigationBar {
    // 返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 30, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)setupUI {
    // 关于趣逛
    self.aboutView = [[UIView alloc] init];
    self.aboutView.backgroundColor = [UIColor whiteColor];
    self.aboutView.layer.cornerRadius = 8;
    self.aboutView.layer.masksToBounds = YES;
    [self.view addSubview:self.aboutView];
    [self.aboutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(15);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(44);
    }];
    
    // 关于趣逛 - 图标
    UIImageView *aboutIcon = [[UIImageView alloc] init];
    aboutIcon.image = [UIImage imageNamed:@"about_icon"];
    aboutIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.aboutView addSubview:aboutIcon];
    [aboutIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.aboutView);
        make.width.height.mas_equalTo(14);
    }];
    
    // 关于趣逛 - 标题
    UILabel *aboutLabel = [[UILabel alloc] init];
    aboutLabel.text = @"关于趣逛";
    aboutLabel.font = [UIFont systemFontOfSize:14];
    aboutLabel.textColor = RGB(51, 51, 51);
    [self.aboutView addSubview:aboutLabel];
    [aboutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(aboutIcon.mas_right).offset(10);
        make.centerY.mas_equalTo(self.aboutView);
    }];
    
    // 关于趣逛 - 箭头
    UIImageView *arrowIcon = [[UIImageView alloc] init];
    arrowIcon.image = [UIImage imageNamed:@"user_next"];
    arrowIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.aboutView addSubview:arrowIcon];
    [arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.aboutView);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(12);
    }];
    
    // 添加点击手势
    UITapGestureRecognizer *aboutTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aboutTapped)];
    [self.aboutView addGestureRecognizer:aboutTap];
    
    // 退出登录按钮
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    self.logoutButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.logoutButton.backgroundColor = [UIColor whiteColor];
    self.logoutButton.layer.cornerRadius = 8;
    self.logoutButton.layer.masksToBounds = YES;
    [self.logoutButton addTarget:self action:@selector(logoutButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.logoutButton];
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.aboutView.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - Actions
- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)aboutTapped {
    AboutViewController *aboutVC = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

- (void)logoutButtonClicked {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"确定要退出登录吗？"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * _Nonnull action) {
        [self doLogout];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)doLogout {
    // 清除用户数据
    //[UserModel clearObjectForKey:kUserName];
    //[UserModel clearObjectForKey:kAccount];
    //[UserModel clearObjectForKey:kPhoneNumber];
    
    // 跳转到登录页面
    // TODO: 跳转到登录页面或回到首页
    [UserModel sharedUserModel].isAutoLogin = NO;
    [UserModel logoutView];
}

#pragma mark - Navigation Bar
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
