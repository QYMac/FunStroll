//
//  LoginUserViewController.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/18.
//

#import "LoginUserViewController.h"
#import "AFNetworkingManage+Login.h"

@interface LoginUserViewController ()<UITextFieldDelegate>{
    NSString *phoneChangeToken;
    NSString *passwordChangeToken;
}

@property (nonatomic,strong) UIButton *backBut;
@property (nonatomic,strong) UILabel *loginTypeL;
@property (nonatomic,strong) UILabel *loginHinteL;
@property (strong,nonatomic) UIView *bgView;
@property (nonatomic,strong) UIButton *phoneTypeBut;
@property (strong,nonatomic) UIView *fgViewA;
@property (strong,nonatomic) UITextField *userName;
@property (strong,nonatomic) UIView *fgView1;
@property (nonatomic,strong) UIButton *passwordTypeBut;
@property (strong,nonatomic) UITextField *password;
@property (strong,nonatomic) UIView *fgViewB;
@property (strong,nonatomic) UIButton *isMYBut;
@property (strong,nonatomic) UIButton *removeBut;
@property (strong,nonatomic) UIButton *removePassBut;
@property (strong,nonatomic) UIView *fgView2;
@property (strong,nonatomic) UIButton *obtain;
@property (strong,nonatomic) UILabel *titmelabel;
@property (strong,nonatomic) UITextField *validation;
@property (strong,nonatomic) UIButton *loginBut;
@property (strong,nonatomic) UIButton *verifyBut;
@property (strong,nonatomic) NSTimer *timer;
@property (assign,nonatomic) int index;
@property (nonatomic,strong) UIButton *selectedBut;
@property (nonatomic,strong) UITextView *termsL;

@property (strong,nonatomic) UIButton *testBut;
@property (strong,nonatomic) UIButton *testBut1;
@property (strong,nonatomic) UIButton *testBut2;
@property (strong,nonatomic) UIButton *testBut3;

@end

@implementation LoginUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupLoginUI];
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
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.loginHinteL.mas_bottom).offset(15);
    }];
    
    [self.bgView addSubview:self.phoneTypeBut];
    [self.phoneTypeBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(35);
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(50);
    }];
    
    [self.bgView addSubview:self.fgViewA];
    [self.fgViewA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(self.phoneTypeBut.mas_right).offset(0);
        make.centerY.mas_equalTo(self.phoneTypeBut);
    }];
    
    /*
    [self.bgView addSubview:self.removeBut];
    [self.removeBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.userName.mas_right).offset(0);
        make.centerY.mas_equalTo(self.userName);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
     */
    
    [self.bgView addSubview:self.userName];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(self.phoneTypeBut.mas_top).offset(0);
        make.left.mas_equalTo(self.phoneTypeBut.mas_right).offset(12.5);
        make.height.mas_equalTo(self.phoneTypeBut.mas_height);
    }];
    
    [self.bgView addSubview:self.fgView1];
    [self.fgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.userName.mas_right).offset(0);
        make.top.mas_equalTo(self.userName.mas_bottom).offset(1);
        make.left.mas_equalTo(self.phoneTypeBut.mas_left).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.bgView addSubview:self.passwordTypeBut];
    [self.passwordTypeBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(self.userName.mas_height);
        make.left.mas_equalTo(self.phoneTypeBut.mas_left).offset(0);
        make.top.mas_equalTo(self.fgView1.mas_bottom).offset(20);
    }];
    
    [self.bgView addSubview:self.fgViewB];
    [self.fgViewB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(self.passwordTypeBut.mas_right).offset(0);
        make.centerY.mas_equalTo(self.passwordTypeBut);
    }];
    
    [self.bgView addSubview:self.isMYBut];
    [self.isMYBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-25);
        make.centerY.mas_equalTo(self.passwordTypeBut);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [self.bgView addSubview:self.removePassBut];
    [self.removePassBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.isMYBut.mas_left).offset(5);
        make.centerY.mas_equalTo(self.passwordTypeBut);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    
    [self.bgView addSubview:self.password];
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.removePassBut.mas_left).offset(-5);
        make.top.mas_equalTo(self.fgView1.mas_bottom).offset(20);
        make.left.mas_equalTo(self.passwordTypeBut.mas_right).offset(12.5);
        make.height.mas_equalTo(self.userName.mas_height);
    }];
    
    [self.bgView addSubview:self.obtain];
    [self.obtain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.isMYBut.mas_right).offset(0);
        make.top.mas_equalTo(self.password.mas_top).offset(0);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
    }];
    
    [self.bgView addSubview:self.validation];
    [self.validation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.obtain.mas_left).offset(-15);
        make.top.mas_equalTo(self.password.mas_top).offset(0);
        make.left.mas_equalTo(self.password.mas_left).offset(0);
        make.height.mas_equalTo(self.password.mas_height);
    }];
    
    [self.bgView addSubview:self.titmelabel];
    [self.titmelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.obtain.mas_right).offset(0);
        make.top.mas_equalTo(self.obtain.mas_top).offset(0);
        make.width.mas_equalTo(self.obtain.mas_width);
        make.height.mas_equalTo(self.obtain.mas_height);
    }];
    
    [self.bgView insertSubview:self.fgView2 atIndex:999];
    [self.fgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.isMYBut.mas_right).offset(0);
        make.top.mas_equalTo(self.validation.mas_bottom).offset(1);
        make.left.mas_equalTo(self.passwordTypeBut.mas_left).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.bgView addSubview:self.verifyBut];
    [self.verifyBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.passwordTypeBut.mas_left).offset(0);
        make.top.mas_equalTo(self.fgView2.mas_bottom).offset(15);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(35);
    }];
    
    [self.bgView addSubview:self.loginBut];
    [self.loginBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(self.verifyBut.mas_bottom).offset(20);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(45);
    }];
    
    
    [self.bgView addSubview:self.selectedBut];
    [self.selectedBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginBut.mas_bottom).offset(15);
        make.left.mas_equalTo(self.loginBut.mas_left).offset(15*DDVerticalFlexibleRatio());
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(35);
    }];
    
    [self.bgView addSubview:self.termsL];
    [self.termsL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.selectedBut.mas_top).offset(3);
        make.left.mas_equalTo(self.selectedBut.mas_right).offset(-5);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-15);
    }];
    
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
    
    /*
    [self.bgView addSubview:self.testBut];
    [self.testBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(self.loginBut.mas_bottom).offset(30);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(44);
    }];
    
    [self.bgView addSubview:self.testBut1];
    [self.testBut1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(self.testBut.mas_bottom).offset(10);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(44);
    }];
    
    [self.bgView addSubview:self.testBut2];
    [self.testBut2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(self.testBut1.mas_bottom).offset(10);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(44);
    }];
    
    [self.bgView addSubview:self.testBut3];
    [self.testBut3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(self.testBut2.mas_bottom).offset(10);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(44);
    }];
    
     */
    
    if (self.isPasswordLogin == YES) {
        self.verifyBut.selected = YES;
        [self verifyButtonClick:self.verifyBut];
    }
}

#pragma mark - UITextFieldDelegate

//键盘回收
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    [self.validation resignFirstResponder];
}

//键盘监听事件
-(void)userNameTextChange:(UITextField *)textField{
    if (textField.text.length != 0) {
        self.removeBut.hidden = NO;
    }else if (textField.text.length == 0){
        self.removeBut.hidden = YES;
    }
    
    if (self.userName.text.length != 0 && self.password.text.length != 0) {
        self.loginBut.backgroundColor = RGB(145, 233, 80);
        [self.loginBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        self.loginBut.backgroundColor = RGB(238, 238, 238);;
        [self.loginBut setTitleColor:RGB(187, 187, 187) forState:UIControlStateNormal];
    }
}

-(void)passwordTextChange:(UITextField *)textField{
    
    if (self.userName.text.length != 0 && self.password.text.length != 0) {
        self.loginBut.backgroundColor = RGB(145, 233, 80);
        [self.loginBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        self.loginBut.backgroundColor = RGB(238, 238, 238);;
        [self.loginBut setTitleColor:RGB(187, 187, 187) forState:UIControlStateNormal];
    }
}

-(void)validationTextChange:(UITextField *)textField{
    
    if (self.userName.text.length != 0 && self.validation.text.length != 0) {
        self.loginBut.backgroundColor = RGB(145, 233, 80);
        [self.loginBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        self.loginBut.backgroundColor = RGB(238, 238, 238);;
        [self.loginBut setTitleColor:RGB(187, 187, 187) forState:UIControlStateNormal];
    }
}

#pragma mark - 按钮点击
- (void)backButClick:(UIButton *)sender{
    
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    [self.validation resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)phoneTypeButClick{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    [self.validation resignFirstResponder];
}


// 是否显示密码
- (void)isMYBtnClick:(UIButton *)sender{
    
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    [self.validation resignFirstResponder];
    
    NSString *tempPwdStr = [CheckTool replaceNullValue:self.password.text];
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"icon_OF"] forState:UIControlStateNormal];
        self.password.text = @""; //防止切换的时候光标偏移
        self.password.secureTextEntry = NO;
        self.password.text = tempPwdStr;
    }else{
        [sender setImage:[UIImage imageNamed:@"icon_OFF"] forState:UIControlStateNormal];
        self.password.text = @"";
        self.password.secureTextEntry = YES;
        self.password.text = tempPwdStr;
    }
}

// 删除手机或账号
- (void)removeButtonClick:(UIButton *)sender{
    if (sender.tag == 1) {
        self.userName.text = @"";
        self.removeBut.hidden = YES;
    } else {
        self.password.text = @"";
        self.removePassBut.hidden = YES;
    }
    
    self.loginBut.backgroundColor = RGB(238, 238, 238);;
    [self.loginBut setTitleColor:RGB(187, 187, 187) forState:UIControlStateNormal];
}

// 登录
- (void)loginButtonClick:(UIButton *)sender{

    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    [self.validation resignFirstResponder];
    
    if (self.selectedBut.selected == NO) {
        [AlertWith showAlertWithMessageText:@"请先同意《用户条款》和《隐私政策》"];
        return;
    }
    
    NSString *grant_type = @"mobile";// 登录类型
    
    // 检测字符串是否是纯数字
    NSString *number = @"0123456789";
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:number] invertedSet];
    NSString *filtered = [[self.userName.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [self.userName.text isEqualToString:filtered];
    
    if (self.verifyBut.selected == NO) {
        if (self.userName.text.length >11 || self.userName.text.length <11 || basic == NO) {
            [AlertWith showAlertWithMessageText:@"请输入11位手机号码（不能包含空格、字母、下划线）"];
            return;
        }
        
        if (self.validation.text.length == 0) {
            [AlertWith showAlertWithMessageText:@"请输验证码"];
            return;
        }
        grant_type = @"mobile";// 登录类型
    }else{
        //判断输入格式是否正确
        if ([self hasChinese:self.userName.text] == YES) {
            [AlertWith showAlertWithMessageText:@"账号不能包含中文或特殊字符"];
            return;
        }
        if (_password.text.length <6) {
            [AlertWith showAlertWithMessageText:@"请输入6位以上正确密码"];
            return;
        }
        
        grant_type = @"password";// 登录类型
    }
    
    [ZSProgressHUD showHUDShowText:@"登录中..."];
    WeakSelf
    // 先获取位置再去登录
    [[LocationAddressHelper shared] getCurrentAddressWithCompletion:^(AMapReGeocode * _Nullable regeocode, CLLocationCoordinate2D coordinate, NSError * _Nullable error) {
        NSString *loginLocationStr = [CheckTool replaceNullValue:regeocode.addressComponent.province];
        NSString *deviceInfoStr = [DeviceInfoHelper getDeviceModelName];
        [weakSelf loginGrant_type:grant_type username:weakSelf.userName.text password:weakSelf.password.text verification_code:weakSelf.validation.text loginLocation:loginLocationStr deviceInfo:deviceInfoStr];
    }];
}

- (void)loginGrant_type:(NSString *)grant_type username:(NSString *)username password:(NSString *)password verification_code:(NSString *)verification_code loginLocation:(NSString *)loginLocation deviceInfo:(NSString *)deviceInfo{
    
    WeakSelf
    if ([grant_type isEqualToString:@"mobile"]) {
        NSString *iphoneNumber = [NSString stringWithFormat:@"APP-SMS@%@",username];
        [AFNetworkingManage LoginMobile:iphoneNumber code:verification_code grant_type:grant_type scope:@"app-server" loginLocation:loginLocation deviceInfo:deviceInfo success:^(id  _Nonnull responseObject) {
            // 储存用户信息
            NSDictionary *dict = [CheckTool replaceNullWithDictionary:responseObject];
            [weakSelf saveUserInfoData:dict grant_type:grant_type];
        } failureHandler:^(NSError * _Nonnull error) {
            [AlertWith showAlertWithMessageText:[AFNetworkingErrorHelper getFriendlyErrorMessage:error]];
            [ZSProgressHUD hideAllHUDAnimated:YES];
        }];
    } else {
        [AFNetworkingManage LoginUsername:username password:password grant_type:grant_type scope:@"app-server" mobile:@"" loginLocation:loginLocation deviceInfo:deviceInfo success:^(id  _Nonnull responseObject) {
            // 储存用户信息
            NSDictionary *dict = [CheckTool replaceNullWithDictionary:responseObject];
            [weakSelf saveUserInfoData:dict grant_type:grant_type];
        } failureHandler:^(NSError * _Nonnull error) {
            [AlertWith showAlertWithMessageText:[AFNetworkingErrorHelper getFriendlyErrorMessage:error]];
            [ZSProgressHUD hideAllHUDAnimated:YES];
        }];
    }
    
}

- (void)saveUserInfoData:(NSDictionary *)dict grant_type:(NSString *)grant_type{
    
    // 储存用户信息
    NSString *refresh_token = [CheckTool replaceNullValue:dict[@"refresh_token"]];
    NSString *access_token = [CheckTool replaceNullValue:dict[@"access_token"]];
    NSString *user_id = [CheckTool replaceNullValue:dict[@"user_id"]];
    NSString *token_type = [CheckTool replaceNullValue:dict[@"token_type"]];
    NSString *iphoneNumber = [CheckTool replaceNullValue:self.userName.text];
    [UserModel saveObject:refresh_token forKey:kRefreshToken];
    [UserModel saveObject:access_token forKey:kAccessToken];
    [UserModel saveObject:user_id forKey:kUserId];
    [UserModel saveObject:token_type forKey:kTokenType];
    [UserModel saveObject:iphoneNumber forKey:kPhoneNumber];
    
    [AFNetworkingManage LoginSearchUserId:user_id success:^(id  _Nonnull responseObject) {
        
        UserInfoModel *model = [UserInfoModel yy_modelWithJSON:responseObject];
        NSString *username = [CheckTool replaceNullValue:model.username];
        NSString *nickname = [CheckTool replaceNullValue:model.nickname];
        NSString *avatar = [CheckTool replaceNullValue:model.avatar];
        NSString *gender = [CheckTool replaceNullValue:model.gender];
        NSString *age = [NSString stringWithFormat:@"%ld",model.age];
        NSString *bio = [CheckTool replaceNullValue:model.bio];
        NSString *bgUrl = [CheckTool replaceNullValue:model.bgUrl];
        NSString *ipLocation = [CheckTool replaceNullValue:model.ipLocation];
        [UserModel saveObject:username forKey:kUserName];
        [UserModel saveObject:nickname forKey:kUserName];
        [UserModel saveObject:avatar forKey:kUserName];
        [UserModel saveObject:gender forKey:kUserName];
        [UserModel saveObject:age forKey:kUserName];
        [UserModel saveObject:bio forKey:kUserName];
        [UserModel saveObject:bgUrl forKey:kUserName];
        [UserModel saveObject:ipLocation forKey:kUserName];
        [UserModel sharedUserModel].isAutoLogin = YES;
        [UserModel newRootHomeVC];
        [ZSProgressHUD hideAllHUDAnimated:YES];
    } failureHandler:^(NSError * _Nonnull error) {
        [UserModel sharedUserModel].isAutoLogin = YES;
        [UserModel newRootHomeVC];
        [ZSProgressHUD hideAllHUDAnimated:YES];
        [ZSProgressHUD hideAllHUDAnimated:YES];
    }];
    
    
    /*
    if ([grant_type isEqualToString:@"mobile"]) {
        [UserModel saveObject:iphoneNumber forKey:kPhoneNumber];
    } else {
        [UserModel saveObject:iphoneNumber forKey:kAccount];
    }
     */
}

// 切换验证或密码登录
- (void)verifyButtonClick:(UIButton *)sender{
    
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    [self.validation resignFirstResponder];
    
    self.loginBut.backgroundColor = RGB(238, 238, 238);;
    [self.loginBut setTitleColor:RGB(187, 187, 187) forState:UIControlStateNormal];
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.validation.text = @"";
        //self.userName.text = @"";
        self.password.hidden = NO;
        self.isMYBut.hidden = NO;
        self.removePassBut.hidden = NO;
        self.titmelabel.hidden = YES;
        self.obtain.hidden = YES;
        self.validation.hidden = YES;
        [self.verifyBut setTitle:@"验证码登录" forState:UIControlStateNormal];
        self.userName.placeholder = @"请输入手机号/账户ID";
    }else{
        self.password.text = @"";
        self.password.hidden = YES;
        self.titmelabel.hidden = NO;
        self.obtain.hidden = NO;
        self.validation.hidden = NO;
        self.isMYBut.hidden = YES;
        self.removePassBut.hidden = YES;
        [self.verifyBut setTitle:@"密码登录" forState:UIControlStateNormal];
        self.userName.placeholder = @"请输入手机号";
    }
}

// 获取验证码
- (void)obtainButtonClick:(UIButton *)sender{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    [self.validation resignFirstResponder];
    
    //检测字符串是否是纯数字
    NSString *number = @"0123456789";
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:number] invertedSet];
    NSString *filtered = [[self.userName.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [self.userName.text isEqualToString:filtered];
    
    if (self.userName.text.length > 11 || self.userName.text.length < 11 || basic == NO) {
        [AlertWith showAlertWithMessageText:@"请输入11位手机号码（不能包含空格、字母、下划线）"];
        return;
    }
    self.obtain.userInteractionEnabled = NO;
    
    WeakSelf
    [ZSProgressHUD showHUDShowText:@"请稍等..."];
    [AFNetworkingManage LoginMobile:_userName.text success:^(id  _Nonnull responseObject) {
        [ZSProgressHUD hideAllHUDAnimated:YES];
        weakSelf.index = 60;
        weakSelf.timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerValida) userInfo:nil repeats:YES];
    } failureHandler:^(NSError * _Nonnull error) {
        [ZSProgressHUD hideAllHUDAnimated:YES];
        weakSelf.obtain.userInteractionEnabled = YES;
    }];
    
}
//按钮计时
- (void)timerValida{
    self.index --;
    [self.obtain setTitle:@"" forState:UIControlStateNormal];
    NSString *time = [NSString stringWithFormat:@"%d秒重发",self.index];
    self.titmelabel.text = time;
    if (self.index == 0) {
        self.titmelabel.text = nil;
        //关闭定时器
        [self.timer setFireDate:[NSDate distantFuture]];
        self.obtain.userInteractionEnabled = YES;
        [self.obtain setTitle:@"重发验证码" forState:UIControlStateNormal];
    }
}

// 判断是否有中文
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


- (void)selectedButClick:(UIButton *)sender{
    if (sender.selected == NO) {
        self.selectedBut.selected = YES;
        [self.selectedBut setImage:[UIImage imageNamed:@"loginBut_off"] forState:UIControlStateNormal];
    } else {
        self.selectedBut.selected = NO;
        [self.selectedBut setImage:[UIImage imageNamed:@"loginBut_on"] forState:UIControlStateNormal];
    }
    
    if (self.selectedButClickBlcok) {
        self.selectedButClickBlcok(self.selectedBut.selected);
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


- (void)testButClick{
    
    if (self.validation.text.length == 0) {
        [AlertWith showAlertWithMessageText:@"请输入正确验证码"];
        return;
    }
    
    
    [AFNetworkingManage LoginVerificationPhoneCode:self.validation.text success:^(id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dict = [CheckTool replaceNullWithDictionary:responseObject];
        self->phoneChangeToken = [CheckTool replaceNullValue:dict[@"data"][@"phoneChangeToken"]];
        [AlertWith showAlertWithMessageText:@"验证成功，请填写新手机号码获取验证码"];
    } failureHandler:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


- (void)testBut1Click{
    
    if (self.validation.text.length == 0) {
        [AlertWith showAlertWithMessageText:@"请输入正确验证码"];
        return;
    }
    
    [AFNetworkingManage LoginRefreshPhoneChangeToken:phoneChangeToken newPhone:@"15678833047" code:self.validation.text success:^(id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msgText = [CheckTool replaceNullValue:responseObject[@"msg"]];
        [AlertWith showAlertWithMessageText:[NSString stringWithFormat:@"请求成功，%@",msgText]];
        [UserModel saveObject:@"15678833047" forKey:kPhoneNumber];
    } failureHandler:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)testBut2Click{
    if (self.password.text.length == 0) {
        [AFNetworkingManage LoginIsSetPasswordSuccess:^(id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
            NSString *msgText = [CheckTool replaceNullValue:responseObject[@"data"][@"hint"]];
            [AlertWith showAlertWithMessageText:[NSString stringWithFormat:@"请求成功，%@",msgText]];
        } failureHandler:^(NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    } else {
        [AFNetworkingManage LoginOldPassword:self.password.text success:^(id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
            self->passwordChangeToken = [CheckTool replaceNullValue:responseObject[@"data"][@"passwordChangeToken"]];
            NSString *msgText = [CheckTool replaceNullValue:responseObject[@"msg"]];
            [AlertWith showAlertWithMessageText:[NSString stringWithFormat:@"请求成功，%@",msgText]];
        } failureHandler:^(NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
    
}

- (void)testBut3Click{
    [AFNetworkingManage LoginPasswordChangeToken:[CheckTool replaceNullValue:passwordChangeToken] newPassword:self.password.text confirmPassword:self.password.text success:^(id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msgText = [CheckTool replaceNullValue:responseObject[@"msg"]];
        [AlertWith showAlertWithMessageText:[NSString stringWithFormat:@"请求成功，%@",msgText]];
    } failureHandler:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)passwordTypeButClick{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    [self.validation resignFirstResponder];
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

- (UIButton *)phoneTypeBut{
    if (!_phoneTypeBut) {
        _phoneTypeBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneTypeBut setTitleColor:RGB(173, 173, 173) forState:UIControlStateNormal];
        [_phoneTypeBut setTitle:@"+86" forState:UIControlStateNormal];
        [_phoneTypeBut addTarget:self action:@selector(phoneTypeButClick) forControlEvents:UIControlEventTouchUpInside];
        _phoneTypeBut.titleLabel.font = [UIFont systemFontOfSize:15];
        
    }
    return _phoneTypeBut;
}

- (UITextField *)userName{
    if (!_userName) {
        _userName = [[UITextField alloc]init];
        _userName.delegate = self;
        _userName.leftViewMode = UITextFieldViewModeAlways;
        _userName.placeholder = @"请输入手机号";
        _userName.font = [UIFont systemFontOfSize:14];
        _userName.textColor = [UIColor blackColor];
        [_userName addTarget:self action:@selector(userNameTextChange:) forControlEvents:UIControlEventEditingChanged];
        if ([UserModel getObjectForKey:kPhoneNumber] != nil) {
            _userName.text = [UserModel getObjectForKey:kPhoneNumber];
        }
    }
    return _userName;
}

- (UIView *)fgView1{
    if (!_fgView1) {
        _fgView1 = [[UIView alloc]init];
        _fgView1.backgroundColor = RGB(229, 229, 229);
    }
    return _fgView1;
}

- (UITextField *)password{
    if (!_password) {
        _password = [[UITextField alloc]init];
        _password.delegate = self;
        _password.leftViewMode = UITextFieldViewModeAlways;
        _password.placeholder = @"请输入您的密码";
        _password.font = [UIFont systemFontOfSize:14];
        _password.textColor = [UIColor blackColor];
        _password.secureTextEntry = YES;
        [_password addTarget:self action:@selector(passwordTextChange:) forControlEvents:UIControlEventEditingChanged];
        _password.hidden = YES;
    }
    return _password;
}

- (UIButton *)isMYBut{
    if (!_isMYBut) {
        _isMYBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_isMYBut setImage:[UIImage imageNamed:@"icon_OFF"] forState:UIControlStateNormal];
        [_isMYBut addTarget:self action:@selector(isMYBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _isMYBut.hidden = YES;
    }
    return _isMYBut;
}

- (UIButton *)removeBut{
    if (!_removeBut) {
        _removeBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_removeBut setImage:[UIImage imageNamed:@"icon_Canceltyping"] forState:UIControlStateNormal];
        _removeBut.hidden = YES;
        _removeBut.tag = 2;
        [_removeBut addTarget:self action:@selector(removeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeBut;
}

- (UIButton *)removePassBut{
    if (!_removePassBut) {
        _removePassBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_removePassBut setImage:[UIImage imageNamed:@"icon_Canceltyping"] forState:UIControlStateNormal];
        _removePassBut.hidden = YES;
        _removePassBut.tag = 2;
        [_removePassBut addTarget:self action:@selector(removeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removePassBut;
}

- (UIView *)fgView2{
    if (!_fgView2) {
        _fgView2 = [[UIView alloc]init];
        _fgView2.backgroundColor = RGB(229, 229, 229);
    }
    return _fgView2;
}

- (UITextField *)validation{
    if (!_validation) {
        _validation = [[UITextField alloc]init];
        _validation.delegate = self;
        _validation.leftViewMode = UITextFieldViewModeAlways;
        _validation.placeholder = @"请输入验证码";
        _validation.font = [UIFont systemFontOfSize:15];
        _validation.layer.cornerRadius = 3;
        _validation.layer.masksToBounds = YES;
        _validation.textColor = [UIColor blackColor];
        [_validation addTarget:self action:@selector(validationTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _validation;
}

- (UIButton *)obtain{
    if (!_obtain) {
        _obtain = [UIButton buttonWithType:UIButtonTypeCustom];
        [_obtain setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_obtain setTitleColor:RGB(58, 175, 6) forState:UIControlStateNormal];
        _obtain.layer.cornerRadius = 3;
        _obtain.layer.masksToBounds = YES;
        _obtain.titleLabel.font = [UIFont systemFontOfSize:12];
        _obtain.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_obtain addTarget:self action:@selector(obtainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _obtain;
}

- (UILabel *)titmelabel{
    if (!_titmelabel) {
        _titmelabel = [[UILabel alloc]init];
        _titmelabel.layer.cornerRadius = 3;
        _titmelabel.layer.masksToBounds = YES;
        _titmelabel.textColor = RGB(173, 173, 173);
        _titmelabel.textAlignment = NSTextAlignmentCenter;
        _titmelabel.font = [UIFont systemFontOfSize:12];
    }
    return _titmelabel;
}

- (UIButton *)verifyBut{
    if (!_verifyBut) {
        _verifyBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_verifyBut setTitle:@"密码登录" forState:UIControlStateNormal];
        [_verifyBut setImage:[UIImage imageNamed:@"genghuanp"] forState:UIControlStateNormal];
        [_verifyBut setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        _verifyBut.titleLabel.font = [UIFont systemFontOfSize:12];
        [_verifyBut addTarget:self action:@selector(verifyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _verifyBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_verifyBut setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
    }
    return _verifyBut;
}

- (UIButton *)loginBut{
    if (!_loginBut) {
        _loginBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBut setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBut setTitleColor:RGB(187, 187, 187) forState:UIControlStateNormal];
        _loginBut.layer.cornerRadius = 45/2;
        _loginBut.layer.masksToBounds = YES;
        _loginBut.titleLabel.font = [UIFont systemFontOfSize:15];
        _loginBut.backgroundColor = RGB(238, 238, 238);
        [_loginBut addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBut;
}

- (UIButton *)testBut{
    if (!_testBut) {
        _testBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_testBut setTitle:@"测试验证手机号码" forState:UIControlStateNormal];
        [_testBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _testBut.layer.cornerRadius = 22;
        _testBut.layer.masksToBounds = YES;
        _testBut.titleLabel.font = [UIFont systemFontOfSize:15];
        _testBut.backgroundColor = RGB(215, 215, 215);
        [_testBut addTarget:self action:@selector(testButClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testBut;
}

- (UIButton *)testBut1{
    if (!_testBut1) {
        _testBut1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_testBut1 setTitle:@"测试更换手机号码" forState:UIControlStateNormal];
        [_testBut1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _testBut1.layer.cornerRadius = 22;
        _testBut1.layer.masksToBounds = YES;
        _testBut1.titleLabel.font = [UIFont systemFontOfSize:15];
        _testBut1.backgroundColor = RGB(215, 215, 215);
        [_testBut1 addTarget:self action:@selector(testBut1Click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testBut1;
}

- (UIButton *)testBut2{
    if (!_testBut2) {
        _testBut2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_testBut2 setTitle:@"测试验证原密码" forState:UIControlStateNormal];
        [_testBut2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _testBut2.layer.cornerRadius = 22;
        _testBut2.layer.masksToBounds = YES;
        _testBut2.titleLabel.font = [UIFont systemFontOfSize:15];
        _testBut2.backgroundColor = RGB(215, 215, 215);
        [_testBut2 addTarget:self action:@selector(testBut2Click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testBut2;
}

- (UIButton *)testBut3{
    if (!_testBut3) {
        _testBut3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_testBut3 setTitle:@"测试更换新密码" forState:UIControlStateNormal];
        [_testBut3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _testBut3.layer.cornerRadius = 22;
        _testBut3.layer.masksToBounds = YES;
        _testBut3.titleLabel.font = [UIFont systemFontOfSize:15];
        _testBut3.backgroundColor = RGB(215, 215, 215);
        [_testBut3 addTarget:self action:@selector(testBut3Click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testBut3;
}

- (UIView *)fgViewA{
    if (!_fgViewA) {
        _fgViewA = [[UIView alloc] init];
        _fgViewA.backgroundColor = RGB(238, 238, 238);
    }
    return _fgViewA;
}
- (UIView *)fgViewB{
    if (!_fgViewB) {
        _fgViewB = [[UIView alloc] init];
        _fgViewB.backgroundColor = RGB(238, 238, 238);
    }
    return _fgViewB;
}

- (UIButton *)passwordTypeBut{
    if (!_passwordTypeBut) {
        _passwordTypeBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_passwordTypeBut setImage:[UIImage imageNamed:@"passwordType"] forState:UIControlStateNormal];
        [_passwordTypeBut addTarget:self action:@selector(passwordTypeButClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passwordTypeBut;
}

- (UIButton *)selectedBut{
    if (!_selectedBut) {
        _selectedBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedBut.selected = _isSelected;
        if (_isSelected == YES) {
            [_selectedBut setImage:[UIImage imageNamed:@"loginBut_off"] forState:UIControlStateNormal];
        } else {
            [_selectedBut setImage:[UIImage imageNamed:@"loginBut_on"] forState:UIControlStateNormal];
        }
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
