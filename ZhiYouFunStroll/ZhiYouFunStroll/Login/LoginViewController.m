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
@property (nonatomic,strong) UIButton *selectedBut;
@property (nonatomic,strong) UITextView *termsL;
@property (nonatomic,strong) UILabel *numberL;
@property (nonatomic,strong) UIButton *replaceBut;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupLoginUI];
    
}

- (void)setupLoginUI{
    
    /*
    [self.view addSubview:self.backBut];
    [self.backBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.height.mas_equalTo(44);
        make.top.mas_equalTo(statusBarHeight);
    }];
     */
    
    /*
    [self.view addSubview:self.logoL];
    [self.logoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoImg.mas_bottom).offset(15);
        make.left.mas_equalTo(50);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-50);
    }];
     */
    
    self.iphonLoginBut.layer.cornerRadius = 45/2;
    self.iphonLoginBut.layer.masksToBounds = YES;
    [self.view addSubview:self.iphonLoginBut];
    [self.iphonLoginBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(- bottomHeight - 250*DDVerticalFlexibleRatio());
        make.left.mas_equalTo(45);
        make.height.mas_equalTo(45);
        make.right.mas_equalTo(-45);
    }];
    
    self.passwordLoginBut.layer.cornerRadius = 45/2;
    self.passwordLoginBut.layer.masksToBounds = YES;
    self.passwordLoginBut.layer.borderWidth = 1;
    self.passwordLoginBut.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:self.passwordLoginBut];
    [self.passwordLoginBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iphonLoginBut.mas_bottom).offset(15);
        make.left.mas_equalTo(45);
        make.height.mas_equalTo(45);
        make.right.mas_equalTo(-45);
    }];
    
    [self.view addSubview:self.logoImg];
    [self.logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        //make.bottom.mas_equalTo(self.iphonLoginBut.mas_bottom).offset(0);
        make.right.mas_equalTo(0);
    }];
    
    [self.view addSubview:self.selectedBut];
    [self.selectedBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordLoginBut.mas_bottom).offset(15);
        make.left.mas_equalTo(self.passwordLoginBut.mas_left).offset(15*DDVerticalFlexibleRatio());
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(35);
    }];
    
    [self.view addSubview:self.termsL];
    [self.termsL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.selectedBut.mas_top).offset(3);
        make.left.mas_equalTo(self.selectedBut.mas_right).offset(-5);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-15);
    }];
    
    if ([UserModel getObjectForKey:kPhoneNumber] != nil) {
        self.passwordLoginBut.hidden = YES;
        [self.iphonLoginBut setTitle:@"一键登录" forState:UIControlStateNormal];
        [self.iphonLoginBut mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(- bottomHeight - 190*DDVerticalFlexibleRatio());
        }];
        [self.passwordLoginBut mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        
        [self.selectedBut mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iphonLoginBut.mas_bottom).offset(15);
        }];
        
        NSString *resultText = [CheckTool replaceNullValue:[UserModel getObjectForKey:kPhoneNumber]];
        if (resultText.length >= 11) {
            resultText =  [resultText stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        self.numberL.text = resultText;
        [self.view addSubview:self.numberL];
        [self.numberL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.iphonLoginBut.mas_top).offset(-20);
            make.centerX.mas_equalTo(self.iphonLoginBut).offset(-30*DDVerticalFlexibleRatio());
            make.height.mas_equalTo(20);
        }];
        
        self.replaceBut.layer.masksToBounds = YES;
        self.replaceBut.layer.cornerRadius = 23/2;
        [self.view addSubview:self.replaceBut];
        [self.replaceBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.numberL);
            make.left.mas_equalTo(self.numberL.mas_right).offset(10);
            make.height.mas_equalTo(23);
            make.width.mas_equalTo(48);
        }];
    }
    
    NSString *fullText = self.termsL.text;
    // 创建富文本
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:fullText];
    
    // 设置整体样式
    [attributedString addAttributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:10],
        NSForegroundColorAttributeName: [UIColor blackColor]
    } range:NSMakeRange(0, fullText.length)];
    
    // 找到变色文字的范围
    NSRange protocolRange = [fullText rangeOfString:@"《用户协议》"];
    NSRange privacyRange = [fullText rangeOfString:@"《隐私政策》"];
    
    // 设置变色文字样式
    [attributedString addAttributes:@{
        NSForegroundColorAttributeName: RGB(58, 175, 6),
        NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)
    } range:protocolRange];
    
    [attributedString addAttributes:@{
        NSForegroundColorAttributeName: RGB(58, 175, 6),
        NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)
    } range:privacyRange];
    
    // 应用到 TextView
    self.termsL.attributedText = attributedString;
    
    // 添加点击手势
    self.termsL.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewTapped:)];
    [self.termsL addGestureRecognizer:tapGesture];
    
}

#pragma mark - 按钮点击
- (void)iphonLoginButClick:(UIButton *)sender{
    
    if ([DeviceInfoHelper hasSIMCard] == NO) {
        LoginUserViewController *navc = [[LoginUserViewController alloc] init];
        [self.navigationController pushViewController:navc animated:YES];
        return;
    }
    
    if (self.selectedBut.selected == NO) {
        [AlertWith showAlertWithMessageText:@"请先同意《用户条款》和《隐私政策》"];
        return;
    }
    
    // 阿里云一键登录
    [[AlicomFusionAuthTokenManager shareInstance].handler stopSceneWithTemplateId:LOGIN_TEMPLATEID];
    [[AlicomFusionAuthTokenManager shareInstance].handler destroy];
    [AlicomFusionAuthTokenManager shareInstance].handler = nil;
    [AlicomFusionAuthTokenManager shareInstance].loginOutclickBlcok = ^{
        [UserModel newRootHomeVC];
    };
    
    // 先获取位置再去登录
    [[LocationAddressHelper shared] getCurrentAddressWithCompletion:^(AMapReGeocode * _Nullable regeocode, CLLocationCoordinate2D coordinate, NSError * _Nullable error) {
        [AlicomFusionAuthTokenManager shareInstance].loginLocationStr = [CheckTool replaceNullValue:regeocode.addressComponent.province];
        [AlicomFusionAuthTokenManager shareInstance].deviceInfoStr = [DeviceInfoHelper getDeviceModelName];
        [[AlicomFusionAuthTokenManager shareInstance] oneClickLogin];
    }];
}

- (void)passwordLoginButClick:(UIButton *)sender{
    LoginUserViewController *navc = [[LoginUserViewController alloc] init];
    [self.navigationController pushViewController:navc animated:YES];
}

- (void)backButClick:(UIButton *)sender{
    
}

- (void)selectedButClick:(UIButton *)sender{
    if (sender.selected == NO) {
        self.selectedBut.selected = YES;
        [self.selectedBut setImage:[UIImage imageNamed:@"loginBut_off"] forState:UIControlStateNormal];
    } else {
        self.selectedBut.selected = NO;
        [self.selectedBut setImage:[UIImage imageNamed:@"loginBut_on"] forState:UIControlStateNormal];
    }
}

- (void)textViewTapped:(UITapGestureRecognizer *)gesture {
    UITextView *textView = (UITextView *)gesture.view;
    // 获取点击位置
    CGPoint location = [gesture locationInView:textView];
    
    // 找到点击的字符位置
    UITextPosition *tapPosition = [textView closestPositionToPoint:location];
    UITextRange *textRange = [textView.tokenizer rangeEnclosingPosition:tapPosition
                                                          withGranularity:UITextGranularityWord
                                                              inDirection:UITextLayoutDirectionRight];
    
    if (textRange) {
        //NSString *tappedWord = [textView textInRange:textRange];
        NSInteger startIndex = [textView offsetFromPosition:textView.beginningOfDocument toPosition:textRange.start];
        
        NSString *fullText = textView.attributedText.string;
        
        // 判断点击了哪个部分
        NSRange protocolRange = [fullText rangeOfString:@"《用户协议》"];
        NSRange privacyRange = [fullText rangeOfString:@"《隐私政策》"];
        
        if (NSLocationInRange(startIndex, protocolRange)) {
            NSLog(@"点击了用户协议");
            WKWebViewController *navc = [[WKWebViewController alloc] init];
            navc.titleText = @"用户协议";
            navc.urlStr = @"";
            [self.navigationController pushViewController:navc animated:YES];
        } else if (NSLocationInRange(startIndex, privacyRange)) {
            NSLog(@"点击了隐私政策");
            WKWebViewController *navc = [[WKWebViewController alloc] init];
            navc.titleText = @"隐私政策";
            navc.urlStr = @"";
            [self.navigationController pushViewController:navc animated:YES];
        }
    }
}


- (void)replaceButClick:(UIButton *)sender{
    [self passwordLoginButClick:sender];
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
        _logoImg.image = [UIImage imageNamed:@"loginBg"];
        //_logoImg.contentMode = UIViewContentModeScaleAspectFit;
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
        _iphonLoginBut.backgroundColor = RGB(145, 233, 80);
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
        _passwordLoginBut.backgroundColor = [UIColor whiteColor];
        [_passwordLoginBut addTarget:self action:@selector(passwordLoginButClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _passwordLoginBut;
}

- (UIButton *)selectedBut{
    if (!_selectedBut) {
        _selectedBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedBut setImage:[UIImage imageNamed:@"loginBut_on"] forState:UIControlStateNormal];
        [_selectedBut addTarget:self action:@selector(selectedButClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _selectedBut;
}

- (UITextView *)termsL{
    if (!_termsL) {
        _termsL = [[UITextView alloc] init];
        _termsL.text = @"我已阅读并同意趣逛《用户协议》和《隐私政策》";
        _termsL.editable = NO;          // 禁止编辑
        _termsL.scrollEnabled = NO;     // 禁止滚动
        _termsL.textContainerInset = UIEdgeInsetsZero; // 移除内边距
        _termsL.font = [UIFont systemFontOfSize:10];
        _termsL.backgroundColor = [UIColor clearColor];
    }
    return _termsL;
}


- (UILabel *)numberL{
    if (!_numberL) {
        _numberL = [[UILabel alloc]init];
        _numberL.text = @"+86 100****0000";
        _numberL.font = [UIFont systemFontOfSize:17];
        _numberL.textColor = [UIColor blackColor];
        _numberL.textAlignment = NSTextAlignmentCenter;
    }
    return _numberL;
}

- (UIButton *)replaceBut{
    if (!_replaceBut) {
        _replaceBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_replaceBut setTitle:@"更换" forState:UIControlStateNormal];
        _replaceBut.titleLabel.font = [UIFont systemFontOfSize:12];
        [_replaceBut setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        _replaceBut.backgroundColor = RGB(238, 238, 238);
        [_replaceBut addTarget:self action:@selector(replaceButClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _replaceBut;
}

// 在 viewWillAppear: 方法中隐藏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.fd_prefersNavigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

@end
