//
//  AboutViewController.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/12.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *appIconView;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UIView *menuView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(250, 250, 250);
    self.title = @"关于趣逛";
    
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
    // 顶部白色背景区域（包含图标、版本号和菜单）
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.headerView.layer.cornerRadius = 8;
    self.headerView.layer.masksToBounds = YES;
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    // App图标容器
    UIView *iconContainer = [[UIView alloc] init];
    iconContainer.backgroundColor = [UIColor clearColor];
    [self.headerView addSubview:iconContainer];
    [iconContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headerView);
        make.top.mas_equalTo(30);
        make.width.height.mas_equalTo(100);
    }];
    
    // App图标
    self.appIconView = [[UIImageView alloc] init];
    self.appIconView.image = [UIImage imageNamed:@"logo"];
    //self.appIconView.contentMode = UIViewContentModeScaleAspectFit;
    [iconContainer addSubview:self.appIconView];
    [self.appIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(iconContainer);
        make.width.height.mas_equalTo(80);
    }];
    
    // 版本号
    self.versionLabel = [[UILabel alloc] init];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (!version) {
        version = @"0.1.0";
    }
    self.versionLabel.text = [NSString stringWithFormat:@"V%@", version];
    self.versionLabel.font = [UIFont systemFontOfSize:14];
    self.versionLabel.textColor = RGB(153, 153, 153);
    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:self.versionLabel];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headerView);
        make.top.mas_equalTo(iconContainer.mas_bottom).offset(0);
    }];
    
    // 菜单区域（放在headerView上）
    self.menuView = [[UIView alloc] init];
    self.menuView.backgroundColor = [UIColor clearColor];
    [self.headerView addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.versionLabel.mas_bottom).offset(15);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    // 菜单项
    NSArray *menuItems = @[@"检测更新", @"用户协议", @"隐私政策"];
    NSArray *menuIcons = @[@"user_next", @"user_next", @"user_next"];  // 检测更新用不同图标
    
    UIView *lastItem = nil;
    for (int i = 0; i < menuItems.count; i++) {
        UIView *itemView = [self createMenuItemWithTitle:menuItems[i] iconName:menuIcons[i] tag:i];
        [self.menuView addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastItem) {
                make.top.mas_equalTo(lastItem.mas_bottom);
            } else {
                make.top.mas_equalTo(0);
            }
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
            if (i == menuItems.count - 1) {
                make.bottom.mas_equalTo(0);
            }
        }];
        lastItem = itemView;
    }
}

- (UIView *)createMenuItemWithTitle:(NSString *)title iconName:(NSString *)iconName tag:(NSInteger)tag {
    UIView *itemView = [[UIView alloc] init];
    itemView.backgroundColor = [UIColor whiteColor];
    itemView.tag = tag;
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = RGB(51, 51, 51);
    [itemView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(itemView);
    }];
    
    // 箭头
    UIImageView *arrowIcon = [[UIImageView alloc] init];
    arrowIcon.image = [UIImage imageNamed:iconName];
    arrowIcon.contentMode = UIViewContentModeScaleAspectFit;
    [itemView addSubview:arrowIcon];
    [arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(itemView);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(12);
    }];
    
    // 分割线（最后一项不加）
    if (tag < 2) {
        UIView *separator = [[UIView alloc] init];
        separator.backgroundColor = RGB(238, 238, 238);
        [itemView addSubview:separator];
        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    
    // 点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuItemTapped:)];
    [itemView addGestureRecognizer:tap];
    
    return itemView;
}

#pragma mark - Actions
- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)menuItemTapped:(UITapGestureRecognizer *)gesture {
    NSInteger tag = gesture.view.tag;
    
    switch (tag) {
        case 0: {
            // 检测更新
            [self checkUpdate];
            break;
        }
        case 1: {
            // 用户协议
            [self openUserAgreement];
            break;
        }
        case 2: {
            // 隐私政策
            [self openPrivacyPolicy];
            break;
        }
        default:
            break;
    }
}

- (void)checkUpdate {
    // TODO: 检测更新逻辑
    [AlertWith showAlertWithMessageText:@"当前已是最新版本"];
}

- (void)openUserAgreement {
    // TODO: 打开用户协议页面
    NSLog(@"打开用户协议");
    WKWebViewController *navc = [[WKWebViewController alloc] init];
    navc.titleText = @"用户协议";
    navc.urlStr = @"http://47.121.183.217/ystk/";
    [self.navigationController pushViewController:navc animated:YES];
}

- (void)openPrivacyPolicy {
    // TODO: 打开隐私政策页面
    NSLog(@"打开隐私政策");
    WKWebViewController *navc = [[WKWebViewController alloc] init];
    navc.titleText = @"隐私政策";
    navc.urlStr = @"http://47.121.183.217/ystk/";
    [self.navigationController pushViewController:navc animated:YES];
}

#pragma mark - Navigation Bar
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
