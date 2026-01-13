//
//  EditBioViewController.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/12.
//

#import "EditBioViewController.h"

static const NSInteger kMaxBioLength = 50;

@interface EditBioViewController () <UITextViewDelegate>

@property (nonatomic, strong) UIView *inputCardView;
@property (nonatomic, strong) UITextView *bioTextView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation EditBioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(250, 250, 250);
    self.title = @"设置个人简介";
    
    [self setupNavigationBar];
    [self setupUI];
    [self updateUI];
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
    self.saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.saveButton addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton.frame = CGRectMake(0, 0, 50, 30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
}

- (void)setupUI {
    // 输入卡片
    self.inputCardView = [[UIView alloc] init];
    self.inputCardView.layer.cornerRadius = 8;
    self.inputView.layer.masksToBounds = YES;
    self.inputCardView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.inputCardView];
    [self.inputCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(150);
    }];
    
    // 简介输入框
    self.bioTextView = [[UITextView alloc] init];
    self.bioTextView.font = [UIFont systemFontOfSize:14];
    self.bioTextView.textColor = RGB(51, 51, 51);
    self.bioTextView.text = self.currentBio;
    self.bioTextView.delegate = self;
    self.bioTextView.backgroundColor = [UIColor clearColor];
    self.bioTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.bioTextView.textContainer.lineFragmentPadding = 0;
    [self.inputCardView addSubview:self.bioTextView];
    [self.bioTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-35);
    }];
    
    // 占位文字
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.text = @"介绍一下自己吧";
    self.placeholderLabel.font = [UIFont systemFontOfSize:14];
    self.placeholderLabel.textColor = RGB(187, 187, 187);
    [self.inputCardView addSubview:self.placeholderLabel];
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
    }];
    
    // 字数统计标签
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.font = [UIFont systemFontOfSize:12];
    self.countLabel.textColor = RGB(187, 187, 187);
    self.countLabel.textAlignment = NSTextAlignmentRight;
    [self.inputCardView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-10);
    }];
    
    /*
    // 底部分割线
    UIView *separatorLine = [[UIView alloc] init];
    separatorLine.backgroundColor = RGB(238, 238, 238);
    [self.inputCardView addSubview:separatorLine];
    [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
     */
    
    // 提示文字
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.text = [NSString stringWithFormat:@"请将内容控制在%ld个字符以内", (long)kMaxBioLength];
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
    NSString *bio = [self.bioTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (bio.length > kMaxBioLength) {
        [AlertWith showAlertWithMessageText:[NSString stringWithFormat:@"简介不能超过%ld个字符", (long)kMaxBioLength]];
        return;
    }
    
    // 保存简介
    //[UserModel saveObject:[CheckTool replaceNullValue:bio] forKey:kUserBio];
    
    if (self.saveBlock) {
        self.saveBlock(bio);
    }
    
    [AlertWith showAlertWithMessageText:@"保存成功"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)updateUI {
    NSInteger currentLength = self.bioTextView.text.length;
    self.countLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)currentLength, (long)kMaxBioLength];
    
    // 显示/隐藏占位文字
    self.placeholderLabel.hidden = (currentLength > 0);
    
    // 判断是否满足条件
    BOOL isValid = (currentLength > 0 && currentLength <= kMaxBioLength);
    
    // 根据字数改变颜色
    if (currentLength > kMaxBioLength) {
        self.countLabel.textColor = RGB(255, 100, 100);
    } else {
        self.countLabel.textColor = RGB(187, 187, 187);
    }
    
    // 更新保存按钮状态
    self.saveButton.enabled = isValid;
    if (isValid) {
        [self.saveButton setTitleColor:RGB(76, 175, 80) forState:UIControlStateNormal];
    } else {
        [self.saveButton setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    // 限制输入长度
    if (textView.text.length > kMaxBioLength) {
        textView.text = [textView.text substringToIndex:kMaxBioLength];
    }
    [self updateUI];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // 计算替换后的字符串长度
    NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (newText.length > kMaxBioLength) {
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
    [self.bioTextView becomeFirstResponder];
}

@end
