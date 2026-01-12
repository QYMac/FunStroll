//
//  EditNicknameViewController.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/12.
//

#import "EditNicknameViewController.h"

static const NSInteger kMaxNicknameLength = 20;
static const NSInteger kMinNicknameLength = 2;

@interface EditNicknameViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *inputCardView;
@property (nonatomic, strong) UITextField *nicknameTextField;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation EditNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(250, 250, 250);
    self.title = @"修改昵称";
    
    [self setupNavigationBar];
    [self setupUI];
    [self updateCountLabel];
}

- (void)setupNavigationBar {
    // 返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 30, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // 保存按钮
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:RGB(76, 175, 80) forState:UIControlStateNormal];
    [self.saveButton setTitleColor:RGB(180, 180, 180) forState:UIControlStateDisabled];
    self.saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.saveButton addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton.frame = CGRectMake(0, 0, 50, 30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
}

- (void)setupUI {
    // 输入卡片
    self.inputCardView = [[UIView alloc] init];
    self.inputCardView.backgroundColor = [UIColor whiteColor];
    self.inputCardView.layer.cornerRadius = 8;
    self.inputCardView.layer.masksToBounds = YES;
    [self.view addSubview:self.inputCardView];
    [self.inputCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(15);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(55);
    }];
    
    // 昵称输入框
    self.nicknameTextField = [[UITextField alloc] init];
    self.nicknameTextField.font = [UIFont systemFontOfSize:14];
    self.nicknameTextField.textColor = RGB(51, 51, 51);
    self.nicknameTextField.placeholder = @"请输入昵称";
    self.nicknameTextField.text = self.currentNickname;
    self.nicknameTextField.delegate = self;
    self.nicknameTextField.clearButtonMode = UITextFieldViewModeNever;
    self.nicknameTextField.returnKeyType = UIReturnKeyDone;
    [self.nicknameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.inputCardView addSubview:self.nicknameTextField];
    [self.nicknameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-60);
        make.centerY.mas_equalTo(self.inputCardView);
        make.height.mas_equalTo(40);
    }];
    
    // 字数统计标签
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.font = [UIFont systemFontOfSize:12];
    self.countLabel.textColor = RGB(187, 187, 187);
    self.countLabel.textAlignment = NSTextAlignmentRight;
    [self.inputCardView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.inputCardView);
        make.width.mas_equalTo(50);
    }];
    
    // 提示文字
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.text = [NSString stringWithFormat:@"请将昵称控制在%ld-%ld个字符", (long)kMinNicknameLength, (long)kMaxNicknameLength];
    self.tipLabel.font = [UIFont systemFontOfSize:12];
    self.tipLabel.textColor = RGB(153, 153, 153);
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inputCardView.mas_bottom).offset(12);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
}

#pragma mark - Actions
- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveButtonClicked {
    NSString *nickname = [self.nicknameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (nickname.length < kMinNicknameLength) {
        [AlertWith showAlertWithMessageText:[NSString stringWithFormat:@"昵称不能少于%ld个字符", (long)kMinNicknameLength]];
        return;
    }
    
    if (nickname.length > kMaxNicknameLength) {
        [AlertWith showAlertWithMessageText:[NSString stringWithFormat:@"昵称不能超过%ld个字符", (long)kMaxNicknameLength]];
        return;
    }
    
    // 保存昵称
    [UserModel saveObject:[CheckTool replaceNullValue:nickname] forKey:kUserName];
    
    if (self.saveBlock) {
        self.saveBlock(nickname);
    }
    
    [AlertWith showAlertWithMessageText:@"保存成功"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)textFieldDidChange:(UITextField *)textField {
    // 限制输入长度
    if (textField.text.length > kMaxNicknameLength) {
        textField.text = [textField.text substringToIndex:kMaxNicknameLength];
    }
    [self updateCountLabel];
}

- (void)updateCountLabel {
    NSInteger currentLength = self.nicknameTextField.text.length;
    self.countLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)currentLength, (long)kMaxNicknameLength];
    
    // 根据字数改变颜色
    if (currentLength < kMinNicknameLength || currentLength > kMaxNicknameLength) {
        self.countLabel.textColor = RGB(255, 100, 100);
    } else {
        self.countLabel.textColor = RGB(187, 187, 187);
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 计算替换后的字符串长度
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newText.length > kMaxNicknameLength) {
        return NO;
    }
    return YES;
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Navigation Bar
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.nicknameTextField becomeFirstResponder];
}

@end
