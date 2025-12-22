//
//  LoginUserViewController.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/18.
//

#import "LoginUserViewController.h"
#import "AFNetworkingManage+Login.h"

#define textFieldBo [UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1].CGColor /***输入前边框颜色***/
#define baColor [UIColor colorWithRed:248/255.0 green:141/255.0 blue:137/255.0 alpha:1] /***按钮颜色***/
#define tiColor [UIColor colorWithRed:255/255.0 green:254/255.0 blue:255/255.0 alpha:1] /***按钮文字颜色***/
#define isTextFieldBo [UIColor colorWithRed:249/255.0 green:134/255.0 blue:130/255.0 alpha:1].CGColor /***输入边框颜色***/

@interface LoginUserViewController ()<UITextFieldDelegate>{
    NSTimer *timer;
    int i;
}

@property (nonatomic,strong) UIButton *backBut;
@property (nonatomic,strong) UILabel *loginTypeL;
@property (nonatomic,strong) UILabel *loginHinteL;

@property (strong,nonatomic) UIView *bgView;
@property (strong,nonatomic) UITextField *userName;
@property (strong,nonatomic) UITextField *password;
@property (strong,nonatomic) UIButton *isMYBut;
@property (strong,nonatomic) UIButton *removeBut;
@property (strong,nonatomic) UIButton *loginBut;
@property (strong,nonatomic) UIButton *verifyBut;
@property (strong,nonatomic) UIButton *resetBut;
@property (strong,nonatomic) UIButton *obtain;
@property (strong,nonatomic) UITextField *validation;
@property (strong,nonatomic) UILabel *titmelabel;
@property (strong,nonatomic) UILabel *passLabel;
@property (strong,nonatomic) UILabel *phone;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UIButton *zcButton;

@end

@implementation LoginUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    [self setupLoginUI];
    [self addInitLoginView];
}

- (void)setupLoginUI{
    
    [self.view addSubview:self.backBut];
    [self.backBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.height.mas_equalTo(44);
        make.top.mas_equalTo(statusBarHeight);
    }];
    
    [self.view addSubview:self.loginTypeL];
    [self.loginTypeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(25);
        make.top.mas_equalTo(topHeight + 15);
    }];
    
    [self.view addSubview:self.loginHinteL];
    [self.loginHinteL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(self.loginTypeL.mas_bottom).offset(10);
    }];
    
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(450);
        make.top.mas_equalTo(self.loginHinteL.mas_bottom).offset(15);
    }];
    
}

#pragma mark - 初始化注册界面
- (void)addInitLoginView{
     
    _phone = [[UILabel alloc]init];
    _phone.text = @"手机号";
    [_phone setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16*DDVerticalFlexibleRatio()]];
     [_bgView addSubview:_phone];
     [_phone mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(30*DDVerticalFlexibleRatio());
         make.right.mas_equalTo(-15*DDVerticalFlexibleRatio());
         make.left.mas_equalTo(15*DDVerticalFlexibleRatio());
         make.height.mas_equalTo(20*DDVerticalFlexibleRatio());
     }];
    
    _userName = [[UITextField alloc]init];
    _userName.delegate = self;
    _userName.leftViewMode = UITextFieldViewModeAlways;
    _userName.placeholder = @"请输入您的手机号码";
    _userName.font = [UIFont systemFontOfSize:14*DDVerticalFlexibleRatio()];
    _userName.textColor = [UIColor blackColor];
    [_userName addTarget:self action:@selector(userNameTextChange:) forControlEvents:UIControlEventEditingChanged];
    [_bgView addSubview:_userName];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if (userName != nil) {
        _userName.text = userName;
    }
    
    _passLabel = [[UILabel alloc]init];
    _passLabel.text = @"验证码";
    [_passLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16*DDVerticalFlexibleRatio()]];
    [_bgView addSubview:_passLabel];
    [_passLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(115*DDVerticalFlexibleRatio());
        make.right.mas_equalTo(-15*DDVerticalFlexibleRatio());
        make.left.mas_equalTo(15*DDVerticalFlexibleRatio());
        make.height.mas_equalTo(20*DDVerticalFlexibleRatio());
    }];
    
    _password = [[UITextField alloc]init];
    _password.delegate = self;
    _password.leftViewMode = UITextFieldViewModeAlways;
    _password.placeholder = @"请输入您的密码";
    _password.font = [UIFont systemFontOfSize:14*DDVerticalFlexibleRatio()];
    _password.textColor = [UIColor blackColor];
    _password.secureTextEntry = YES;
    [_password addTarget:self action:@selector(passwordTextChange:) forControlEvents:UIControlEventEditingChanged];
    [_bgView addSubview:_password];
    
    _isMYBut = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * image = [[UIImage imageNamed:@"icon_OFF"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_isMYBut setImage:image forState:UIControlStateNormal];
    [self.view addSubview:_isMYBut];
    
    _removeBut = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * images = [[UIImage imageNamed:@"icon_Canceltyping"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_removeBut setImage:images forState:UIControlStateNormal];
    [self.view addSubview:_removeBut];
    _removeBut.hidden = YES;//一开始先隐藏
    
    _loginBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _loginBut.backgroundColor = baColor;
    [_loginBut setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBut setTitleColor:tiColor forState:UIControlStateNormal];
    _loginBut.layer.cornerRadius = 22*DDVerticalFlexibleRatio();
    _loginBut.titleLabel.font = [UIFont systemFontOfSize:14*DDVerticalFlexibleRatio()];
    _loginBut.layer.masksToBounds = YES;
    [_bgView addSubview:_loginBut];
    
    _zcButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _zcButton.backgroundColor = RGB(240, 240, 240);
    [_zcButton setTitle:@"注册" forState:UIControlStateNormal];
    [_zcButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _zcButton.layer.cornerRadius = 22*DDVerticalFlexibleRatio();
    _zcButton.titleLabel.font = [UIFont systemFontOfSize:14*DDVerticalFlexibleRatio()];
    _zcButton.layer.masksToBounds = YES;
    [_bgView addSubview:_zcButton];
    
    _verifyBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _verifyBut.backgroundColor = [UIColor clearColor];
    [_verifyBut setTitle:@"密码登录" forState:UIControlStateNormal];
    [_verifyBut setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    _verifyBut.titleLabel.font = [UIFont systemFontOfSize:12*DDVerticalFlexibleRatio()];
    _verifyBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_bgView addSubview:_verifyBut];
    
    _resetBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _resetBut.backgroundColor = [UIColor clearColor];
    [_resetBut setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_resetBut setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    _resetBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _resetBut.titleLabel.font = [UIFont systemFontOfSize:12*DDVerticalFlexibleRatio()];
    [_bgView addSubview:_resetBut];
    
    /**********验证码登录*************/
    _validation = [[UITextField alloc]init];
    _validation.delegate = self;
    _validation.leftViewMode = UITextFieldViewModeAlways;
    _validation.placeholder = @"请输入短信验证码";
    _validation.font = [UIFont systemFontOfSize:14*DDVerticalFlexibleRatio()];
    _validation.layer.cornerRadius = 3*DDVerticalFlexibleRatio();
    _validation.textColor = [UIColor blackColor];
    [_validation addTarget:self action:@selector(validationTextChange:) forControlEvents:UIControlEventEditingChanged];
    [_bgView addSubview:_validation];
    
    _obtain = [UIButton buttonWithType:UIButtonTypeSystem];
    _obtain.backgroundColor = [UIColor redColor];
    [_obtain setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_obtain setTitleColor:tiColor forState:UIControlStateNormal];
    _obtain.layer.cornerRadius = 3*DDVerticalFlexibleRatio();
    _obtain.titleLabel.font = [UIFont systemFontOfSize:12*DDVerticalFlexibleRatio()];
    _obtain.layer.masksToBounds = YES;
    [_bgView addSubview:_obtain];
    
    _titmelabel = [[UILabel alloc]init];
    _titmelabel.layer.cornerRadius = 3*DDVerticalFlexibleRatio();
    _titmelabel.layer.masksToBounds = YES;
    _titmelabel.textColor = [UIColor whiteColor];
    _titmelabel.textAlignment = NSTextAlignmentCenter;
    _titmelabel.font = [UIFont systemFontOfSize:12*DDVerticalFlexibleRatio()];
    [_bgView addSubview:_titmelabel];
    
    /************界面布局****************/
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15*DDVerticalFlexibleRatio());
        make.top.mas_equalTo(50*DDVerticalFlexibleRatio());
        make.left.mas_equalTo(15*DDVerticalFlexibleRatio());
        make.height.mas_equalTo(35*DDVerticalFlexibleRatio());
    }];
    
    UIView *fgView1 = [[UIView alloc]init];
    fgView1.backgroundColor = RGB(220, 220, 220);
    [_bgView addSubview:fgView1];
    [fgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15*DDVerticalFlexibleRatio());
        make.top.mas_equalTo(self.userName.mas_bottom).offset(1*DDVerticalFlexibleRatio());
        make.left.mas_equalTo(15*DDVerticalFlexibleRatio());
        make.height.mas_equalTo(0.5);
    }];
    
    [self.removeBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15*DDVerticalFlexibleRatio());
        make.centerY.mas_equalTo(self.userName);
        make.width.mas_equalTo(30*DDVerticalFlexibleRatio());
        make.height.mas_equalTo(30*DDVerticalFlexibleRatio());
    }];
    
    [self.validation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-115*DDVerticalFlexibleRatio());
        make.top.mas_equalTo(self.passLabel).offset(20*DDVerticalFlexibleRatio());
        make.left.mas_equalTo(15*DDVerticalFlexibleRatio());
        make.height.mas_equalTo(35*DDVerticalFlexibleRatio());
    }];
    
    [self.obtain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15*DDVerticalFlexibleRatio());
        make.top.mas_equalTo(self.passLabel).offset(15*DDVerticalFlexibleRatio());
        make.width.mas_equalTo(90*DDVerticalFlexibleRatio());
        make.height.mas_equalTo(30*DDVerticalFlexibleRatio());
    }];
    
    [self.titmelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15*DDVerticalFlexibleRatio());
        make.top.mas_equalTo(self.passLabel).offset(15*DDVerticalFlexibleRatio());
        make.width.mas_equalTo(90*DDVerticalFlexibleRatio());
        make.height.mas_equalTo(30*DDVerticalFlexibleRatio());
    }];
    
    UIView *fgView2 = [[UIView alloc]init];
    fgView2.backgroundColor = RGB(220, 220, 220);
    [_bgView addSubview:fgView2];
    [fgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15*DDVerticalFlexibleRatio());
        make.top.mas_equalTo(self.validation.mas_bottom).offset(1*DDVerticalFlexibleRatio());
        make.left.mas_equalTo(15*DDVerticalFlexibleRatio());
        make.height.mas_equalTo(0.5);
    }];
    
    [self.loginBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25*DDVerticalFlexibleRatio());
        make.top.mas_equalTo(self.validation).offset(120*DDVerticalFlexibleRatio());
        make.right.mas_equalTo(-25*DDVerticalFlexibleRatio());
        make.height.mas_equalTo(44*DDVerticalFlexibleRatio());
    }];
    
    [self.zcButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25*DDVerticalFlexibleRatio());
        make.top.mas_equalTo(self.loginBut.mas_bottom).offset(15*DDVerticalFlexibleRatio());
        make.right.mas_equalTo(-25*DDVerticalFlexibleRatio());
        make.height.mas_equalTo(44*DDVerticalFlexibleRatio());
    }];
    
    [self.verifyBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15*DDVerticalFlexibleRatio());
        make.top.mas_equalTo(self.validation).offset(40*DDVerticalFlexibleRatio());
        make.width.mas_equalTo(100*DDVerticalFlexibleRatio());
        make.height.mas_equalTo(30*DDVerticalFlexibleRatio());
    }];
    
    [self.resetBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15*DDVerticalFlexibleRatio());
        make.top.mas_equalTo(self.validation).offset(40*DDVerticalFlexibleRatio());
        make.width.mas_equalTo(100*DDVerticalFlexibleRatio());
        make.height.mas_equalTo(30*DDVerticalFlexibleRatio());
    }];

    
    [_loginBut addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_verifyBut addTarget:self action:@selector(verifyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_resetBut addTarget:self action:@selector(resetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_obtain addTarget:self action:@selector(obtainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_removeBut addTarget:self action:@selector(removeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_isMYBut addTarget:self action:@selector(isMYBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_zcButton addTarget:self action:@selector(rightButBuutonClick) forControlEvents:UIControlEventTouchUpInside];
    
    /*
    NSArray *arr = @[@"wx",@"QQ",@"wb"];
    if ([AppId isNeedUpdateVersionaAppId] == NO) {
        
    }else{
        for (int i = 0; i < arr.count; i++) {
            _button = [UIButton buttonWithType:UIButtonTypeSystem];
            UIImage * images1 = [[UIImage imageNamed:[NSString stringWithFormat:@"%@",arr[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [_button setImage:images1 forState:UIControlStateNormal];
            _button.tag = 100+i;
            [_button addTarget:self action:@selector(thirdPartyButClick:) forControlEvents:UIControlEventTouchUpInside];
            [_bgView addSubview:_button];
            [_button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-30*DDVerticalFlexibleRatio());
                make.width.mas_equalTo(50*DDVerticalFlexibleRatio());
                make.height.mas_equalTo(50*DDVerticalFlexibleRatio());
                make.left.mas_equalTo((115*DDVerticalFlexibleRatio() + 60*DDVerticalFlexibleRatio()*i));
            }];
        }
    }
     */
}

- (void)thirdPartyButClick:(UIButton *)sender{
//    [_userName resignFirstResponder];
//    [_password resignFirstResponder];
//    [_validation resignFirstResponder];
//    [AlertWith _showAlertWithMessage:@"暂不支持第三方登录，请使用手机号码或账号登录"];
}

//键盘回收
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_userName resignFirstResponder];
    [_password resignFirstResponder];
    [_validation resignFirstResponder];
}
//键盘监听事件
-(void)userNameTextChange:(UITextField *)textField{
    if (textField.text.length != 0) {
        textField.layer.borderColor = isTextFieldBo;
        _removeBut.hidden = NO;
    }else if (textField.text.length == 0){
        textField.layer.borderColor = textFieldBo;
        _removeBut.hidden = YES;
    }
    if (_userName.text.length != 0&&_password.text.length != 0) {
        _loginBut.backgroundColor = [UIColor colorWithRed:234/255.0 green:0/255.0 blue:0/255.0 alpha:1];
        [_loginBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        _loginBut.backgroundColor = baColor;
        [_loginBut setTitleColor:tiColor forState:UIControlStateNormal];
    }
}

-(void)passwordTextChange:(UITextField *)textField{
    if (textField.text.length != 0) {
        textField.layer.borderColor = isTextFieldBo;
    }else if (textField.text.length == 0){
        textField.layer.borderColor = textFieldBo;
    }
    if (_userName.text.length != 0&&_password.text.length != 0) {
        _loginBut.backgroundColor = [UIColor colorWithRed:234/255.0 green:0/255.0 blue:0/255.0 alpha:1];
        [_loginBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        _loginBut.backgroundColor = baColor;
        [_loginBut setTitleColor:tiColor forState:UIControlStateNormal];
    }
}

-(void)validationTextChange:(UITextField *)textField{
    if (textField.text.length != 0) {
        textField.layer.borderColor = isTextFieldBo;
    }else if (textField.text.length == 0){
        textField.layer.borderColor = textFieldBo;
    }
    if (_userName.text.length != 0&&_validation.text.length != 0) {
        _loginBut.backgroundColor = [UIColor colorWithRed:234/255.0 green:0/255.0 blue:0/255.0 alpha:1];
        [_loginBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        _loginBut.backgroundColor = baColor;
        [_loginBut setTitleColor:tiColor forState:UIControlStateNormal];
    }
}


//按钮点击
- (void)rightButBuutonClick{//注册
    [_userName resignFirstResponder];
    [_password resignFirstResponder];
    [_validation resignFirstResponder];
    
}

/***忘记密码***/
- (void)resetButtonClick:(UIButton *)sender{
    [_userName resignFirstResponder];
    [_password resignFirstResponder];
    [_validation resignFirstResponder];
    
}

#pragma mark - 按钮点击事件
- (void)isMYBtnClick:(UIButton *)sender{
    [_userName resignFirstResponder];
    [_password resignFirstResponder];
    [_validation resignFirstResponder];
    sender.selected = !sender.selected;
    if (sender.selected) {
        UIImage * image = [[UIImage imageNamed:@"icon_OF"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [sender setImage:image forState:UIControlStateNormal];
        //明文
        NSString *tempPwdStr = self.password.text;
        self.password.text = @""; //这句代码可以防止切换的时候光标偏移
        self.password.secureTextEntry = NO;
        self.password.text = tempPwdStr;
    }else{
        UIImage * image = [[UIImage imageNamed:@"icon_OFF"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [sender setImage:image forState:UIControlStateNormal];
        //暗文
        NSString *tempPwdStr = self.password.text;
        self.password.text = @"";
        self.password.secureTextEntry = YES;
        self.password.text = tempPwdStr;
    }
}
/***删除账号***/
- (void)removeButtonClick:(UIButton *)sender{
    _userName.text = @"";
    _userName.layer.borderColor = textFieldBo;
    _removeBut.hidden = YES;
    _loginBut.backgroundColor = baColor;
    [_loginBut setTitleColor:tiColor forState:UIControlStateNormal];
}
/***登录***/
- (void)loginButtonClick:(UIButton *)sender{
    
    [_userName resignFirstResponder];
    [_password resignFirstResponder];
    [_validation resignFirstResponder];
    //检测字符串是否是纯数字
    NSString *number = @"0123456789";
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:number] invertedSet];
    NSString *filtered = [[_userName.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [_userName.text isEqualToString:filtered];
    //判断是否验证/密码登录决斗按钮不能点击的条件
    if (_verifyBut.selected == NO) {
        //判断输入格式是否正确
        if (_userName.text.length >11 || _userName.text.length <11 || basic == NO) {
            [self _showAlertWithMessage:@"请输入11位正确手机号码（不能包含空格、字母、下划线）"];
            return;
        }
        if (_validation.text.length == 0) {
            [self _showAlertWithMessage:@"请输入正确验证码"];
            return;
        }
        [self login_type:@"verification_code" password:@"" verification_code:_validation.text Mobile:_userName.text username:@""];
    }else{
        //判断输入格式是否正确
        if ([self hasChinese:self.userName.text] == YES) {
            [self _showAlertWithMessage:@"账号不能包含中文或特殊字符"];
            return;
        }
        if (_password.text.length <6) {
            [self _showAlertWithMessage:@"请输入6位以上正确密码"];
            return;
        }
        [self login_type:@"password" password:_password.text verification_code:@"" Mobile:@"" username:_userName.text];
    }
    
}

- (void)login_type:(NSString *)login_type password:(NSString *)password verification_code:(NSString *)verification_code Mobile:(NSString *)Mobile username:(NSString *)username{
    
    [ZSProgressHUD showHUDShowText:@"登录中..."];
    NSString *iphoneNumber = [NSString stringWithFormat:@"APP-SMS@%@",_userName.text];
    [AFNetworkingManage LoginMobile:iphoneNumber code:verification_code grant_type:@"mobile" scope:@"app-server" uccess:^(id  _Nonnull responseObject) {
        [ZSProgressHUD hideAllHUDAnimated:YES];
        
        // 储存用户信息
        NSDictionary *dict = [CheckTool replaceNullWithDictionary:responseObject];
        NSString *refresh_token = [CheckTool replaceNullValue:dict[@"refresh_token"]];
        NSString *access_token = [CheckTool replaceNullValue:dict[@"access_token"]];
        NSString *username = [CheckTool replaceNullValue:dict[@"username"]];
        NSString *user_id = [CheckTool replaceNullValue:dict[@"user_id"]];
        NSString *token_type = [CheckTool replaceNullValue:dict[@"token_type"]];
        [UserModel saveObject:refresh_token forKey:kRefreshToken];
        [UserModel saveObject:access_token forKey:kAccessToken];
        [UserModel saveObject:username forKey:kUserName];
        [UserModel saveObject:user_id forKey:kUserId];
        [UserModel saveObject:token_type forKey:kTokenType];
        
    } failureHandler:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [ZSProgressHUD hideAllHUDAnimated:YES];
    }];
    
    
}

/***验证码登录***/
- (void)verifyButtonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        _loginBut.backgroundColor = baColor;
        [_loginBut setTitleColor:tiColor forState:UIControlStateNormal];
        self.validation.text = @"";//切换密码登录置为空
        //_userName.text = @"";
        self.password.hidden = NO;
        self.isMYBut.hidden = NO;
        self.titmelabel.hidden = YES;
        self.obtain.hidden = YES;
        self.validation.hidden = YES;
        [_verifyBut setTitle:@"验证码登录" forState:UIControlStateNormal];
        _userName.placeholder = @"请输入您的账号";
        _phone.text = @"账号";
        _passLabel.text = @"密码";
        [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15*DDVerticalFlexibleRatio());
            make.top.mas_equalTo(self.passLabel).offset(20*DDVerticalFlexibleRatio());
            make.left.mas_equalTo(15*DDVerticalFlexibleRatio());
            make.height.mas_equalTo(35*DDVerticalFlexibleRatio());
        }];
        [self.isMYBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15*DDVerticalFlexibleRatio());
            make.centerY.mas_equalTo(self.password);
            make.width.mas_equalTo(30*DDVerticalFlexibleRatio());
            make.height.mas_equalTo(30*DDVerticalFlexibleRatio());
        }];
    }else{
        _loginBut.backgroundColor = baColor;
        [_loginBut setTitleColor:tiColor forState:UIControlStateNormal];
        self.password.text = @"";//切换验证码登录置为空
        self.password.hidden = YES;
        self.titmelabel.hidden = NO;
        self.obtain.hidden = NO;
        self.validation.hidden = NO;
        self.isMYBut.hidden = YES;
        [_verifyBut setTitle:@"密码登录" forState:UIControlStateNormal];
        _userName.placeholder = @"请输入您的手机号";
        _phone.text = @"手机号";
        _passLabel.text = @"验证码";
    }
}

/***获取验证码**/
- (void)obtainButtonClick:(UIButton *)sender{
    [_userName resignFirstResponder];
    [_validation resignFirstResponder];
    [_password resignFirstResponder];
    //检测字符串是否是纯数字
    NSString *number = @"0123456789";
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:number] invertedSet];
    NSString *filtered = [[_userName.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [_userName.text isEqualToString:filtered];
    
    if (_userName.text.length >11 || _userName.text.length <11 || basic == NO) {
        [self _showAlertWithMessage:@"请输入11位正确手机号码（不能包含空格、字母、下划线）"];
        return;
    }
    _obtain.userInteractionEnabled = NO;
    [ZSProgressHUD showHUDShowText:@"请稍等..."];
    
    [AFNetworkingManage LoginMobile:_userName.text uccess:^(id  _Nonnull responseObject) {
        [ZSProgressHUD hideAllHUDAnimated:YES];
        self->i= 60;
        self->timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerValida) userInfo:nil repeats:YES];
    } failureHandler:^(NSError * _Nonnull error) {
        [ZSProgressHUD hideAllHUDAnimated:YES];
        self.obtain.userInteractionEnabled = YES;
    }];
    
}
//按钮计时
- (void)timerValida{
    
    i --;
    [_obtain setTitle:nil forState:UIControlStateNormal];
    _obtain.backgroundColor = baColor;
    NSString *time = [NSString stringWithFormat:@"%d秒重发",i];
    _titmelabel.text = time;
    if (i == 0) {
        _titmelabel.text = nil;
        //关闭定时器
        [timer setFireDate:[NSDate distantFuture]];
        _obtain.userInteractionEnabled = YES;
        _obtain.backgroundColor = [UIColor redColor];
        [_obtain setTitle:@"重发验证码" forState:UIControlStateNormal];
    }
}


//判断是否有中文
-(BOOL)hasChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 按钮点击
- (void)backButClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
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

- (UILabel *)loginTypeL{
    if (!_loginTypeL) {
        _loginTypeL = [[UILabel alloc]init];
        _loginTypeL.text = @"手机号登录";
        _loginTypeL.textColor = [UIColor blackColor];
        _loginTypeL.font = [UIFont systemFontOfSize:24];
        _loginTypeL.textAlignment = NSTextAlignmentCenter;
    }
    return _loginTypeL;
}

- (UILabel *)loginHinteL{
    if (!_loginHinteL) {
        _loginHinteL = [[UILabel alloc]init];
        _loginHinteL.text = @"未注册的手机号登录成功后将自动注册";
        _loginHinteL.textColor = RGB(173, 173, 173);
        _loginHinteL.font = [UIFont systemFontOfSize:15];
        _loginHinteL.textAlignment = NSTextAlignmentCenter;
    }
    return _loginHinteL;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

#pragma mark - 弹出框样式
- (void)_showAlertWithMessage:(NSString *)message{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 隐藏导航栏
    self.fd_prefersNavigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}


@end
