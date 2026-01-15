//
//  PublishNoteViewController.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import "PublishNoteViewController.h"
#import "PhotoPickerViewController.h"
#import "PhotoPreviewViewController.h"
#import "UITextView+EmojiKeyboard.h"

static const NSInteger kMaxTitleLength = 20;
static const NSInteger kMaxContentLength = 1000;

@interface PublishNoteViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *backButton;

// 图片选择
@property (nonatomic, strong) UICollectionView *imageCollectionView;
@property (nonatomic, strong) NSMutableArray *selectedImages;

// 标题
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UILabel *titleCountLabel;

// 正文
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UILabel *contentPlaceholder;
@property (nonatomic, strong) UILabel *contentCountLabel;
@property (nonatomic, strong) UIView *keyboardToolbar; // 键盘工具栏
@property (nonatomic, strong) UIButton *emojiToolbarButton; // 工具栏表情按钮
@property (nonatomic, assign) BOOL isShowingEmojiKeyboard; // 是否显示表情键盘

// 话题
@property (nonatomic, strong) UIButton *topicButton;

// 可见性
@property (nonatomic, strong) UIView *visibilityView;
@property (nonatomic, strong) UILabel *visibilityLabel;
@property (nonatomic, assign) NSInteger visibilityType; // 0: 公开可见, 1: 仅自己可见

// 可见性选择弹窗
@property (nonatomic, strong) UIView *visibilityPickerBackground;
@property (nonatomic, strong) UIView *visibilityPickerView;

// 底部按钮
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *saveDraftButton;
@property (nonatomic, strong) UIButton *publishButton;

@end

@implementation PublishNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectedImages = [NSMutableArray array];
    self.visibilityType = 0; // 默认公开可见
    
    [self setupNavigationBar];
    [self setupUI];
    [self setupVisibilityPicker];
}

- (void)setupNavigationBar {
    // 返回按钮
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        make.width.height.mas_equalTo(24);
    }];
}

- (void)setupUI {
    // 底部按钮（最先创建，其他元素依赖它的位置）
    [self setupBottomButtons];
    
    // 可见性设置（在底部按钮上方）
    [self setupVisibilitySection];
    
    // 话题（在可见性上方）
    [self setupTopicSection];
    
    // 滚动视图（在话题上方）
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backButton.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.topicButton.mas_top).offset(-15);
    }];
    
    // 内容视图
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView);
    }];
    
    // 图片选择区域
    [self setupImageSection];
    
    // 标题输入
    [self setupTitleSection];
    
    // 正文输入
    [self setupContentSection];
}

#pragma mark - 图片选择区域
- (void)setupImageSection {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    self.imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.imageCollectionView.delegate = self;
    self.imageCollectionView.dataSource = self;
    self.imageCollectionView.backgroundColor = [UIColor clearColor];
    self.imageCollectionView.showsHorizontalScrollIndicator = NO;
    [self.imageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ImageCell"];
    [self.imageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"AddCell"];
    
    // 添加长按手势用于拖拽排序
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    longPress.minimumPressDuration = 0.3;
    [self.imageCollectionView addGestureRecognizer:longPress];
    
    [self.contentView addSubview:self.imageCollectionView];
    [self.imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(90);
    }];
}

#pragma mark - 标题输入区域
- (void)setupTitleSection {
    // 标题输入框
    self.titleTextField = [[UITextField alloc] init];
    self.titleTextField.placeholder = @"添加标题";
    self.titleTextField.font = [UIFont systemFontOfSize:16];
    self.titleTextField.textColor = RGB(51, 51, 51);
    self.titleTextField.delegate = self;
    [self.titleTextField addTarget:self action:@selector(titleTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:self.titleTextField];
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageCollectionView.mas_bottom).offset(20);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(40);
    }];
    
    // 字数限制
    self.titleCountLabel = [[UILabel alloc] init];
    self.titleCountLabel.text = [NSString stringWithFormat:@"%ld", (long)kMaxTitleLength];
    self.titleCountLabel.font = [UIFont systemFontOfSize:14];
    self.titleCountLabel.textColor = RGB(187, 187, 187);
    self.titleCountLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.titleCountLabel];
    [self.titleCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.titleTextField);
        make.width.mas_equalTo(30);
    }];
    
    // 分割线
    UIView *titleSeparator = [[UIView alloc] init];
    titleSeparator.backgroundColor = RGB(238, 238, 238);
    [self.contentView addSubview:titleSeparator];
    [titleSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleTextField.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - 正文输入区域
- (void)setupContentSection {
    // 正文输入框
    self.contentTextView = [[UITextView alloc] init];
    self.contentTextView.font = [UIFont systemFontOfSize:14];
    self.contentTextView.textColor = RGB(51, 51, 51);
    self.contentTextView.delegate = self;
    self.contentTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.contentTextView.textContainer.lineFragmentPadding = 0;
    
    // 设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    self.contentTextView.typingAttributes = @{
        NSFontAttributeName: [UIFont systemFontOfSize:14],
        NSForegroundColorAttributeName: RGB(51, 51, 51),
        NSParagraphStyleAttributeName: paragraphStyle
    };
    
    // 设置键盘工具栏
    self.contentTextView.inputAccessoryView = [self createKeyboardToolbar];
    
    [self.contentView addSubview:self.contentTextView];
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(14);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(self.topicButton.mas_top).offset(-50);
    }];
    
    // 占位文字
    self.contentPlaceholder = [[UILabel alloc] init];
    self.contentPlaceholder.text = @"添加正文";
    self.contentPlaceholder.font = [UIFont systemFontOfSize:14];
    self.contentPlaceholder.textColor = RGB(187, 187, 187);
    [self.contentView addSubview:self.contentPlaceholder];
    [self.contentPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentTextView).offset(0);
        make.left.mas_equalTo(15);
    }];
    
    // 字数统计
    self.contentCountLabel = [[UILabel alloc] init];
    self.contentCountLabel.text = [NSString stringWithFormat:@"-%ld", (long)kMaxContentLength];
    self.contentCountLabel.font = [UIFont systemFontOfSize:12];
    self.contentCountLabel.textColor = RGB(187, 187, 187);
    self.contentCountLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.contentCountLabel];
    [self.contentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentTextView.mas_bottom).offset(10);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-10);
    }];
}

#pragma mark - 键盘工具栏
- (UIView *)createKeyboardToolbar {
    self.keyboardToolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44)];
    self.keyboardToolbar.backgroundColor = RGB(247, 247, 247);
    
    // 顶部分割线
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.5)];
    topLine.backgroundColor = RGB(229, 229, 229);
    [self.keyboardToolbar addSubview:topLine];
    
    // 表情按钮
    self.emojiToolbarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.emojiToolbarButton.frame = CGRectMake(15, 10, 24, 24);
    // 使用图片，如果没有则使用文字
    UIImage *emojiImage = [UIImage imageNamed:@"keyboard_emoji"];
    UIImage *textImage = [UIImage imageNamed:@"keyboard_text"];
    if (emojiImage) {
        [self.emojiToolbarButton setImage:emojiImage forState:UIControlStateNormal];
        [self.emojiToolbarButton setImage:textImage ?: emojiImage forState:UIControlStateSelected];
    } else {
        // 备用方案：使用文字
        [self.emojiToolbarButton setTitle:@"😊" forState:UIControlStateNormal];
        [self.emojiToolbarButton setTitle:@"⌨️" forState:UIControlStateSelected];
        self.emojiToolbarButton.titleLabel.font = [UIFont systemFontOfSize:20];
    }
    [self.emojiToolbarButton addTarget:self action:@selector(emojiButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.keyboardToolbar addSubview:self.emojiToolbarButton];
    
    // #话题按钮
    UIButton *topicTagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    topicTagButton.frame = CGRectMake(CGRectGetMaxX(self.emojiToolbarButton.frame) + 20, 10, 24, 24);
    UIImage *topicImage = [UIImage imageNamed:@"keyboard_topic"];
    if (topicImage) {
        [topicTagButton setImage:topicImage forState:UIControlStateNormal];
    } else {
        // 备用方案：使用文字
        [topicTagButton setTitle:@"#" forState:UIControlStateNormal];
        [topicTagButton setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        topicTagButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    [topicTagButton addTarget:self action:@selector(topicTagButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.keyboardToolbar addSubview:topicTagButton];
    
    // 完成按钮
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(kWidth - 15 - 40, 10, 40, 24);
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [doneButton addTarget:self action:@selector(keyboardDoneButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.keyboardToolbar addSubview:doneButton];
    
    return self.keyboardToolbar;
}

#pragma mark - 键盘工具栏按钮事件
- (void)emojiButtonTapped {
    self.isShowingEmojiKeyboard = !self.isShowingEmojiKeyboard;
    self.emojiToolbarButton.selected = self.isShowingEmojiKeyboard;
    
    if (self.isShowingEmojiKeyboard) {
        // 显示表情键盘
        [self.contentTextView showEmojiKeyboard];
    } else {
        // 恢复系统键盘
        [self.contentTextView hideEmojiKeyboard];
    }
}

- (void)topicTagButtonTapped {
    // 在当前光标位置插入 #
    [self.contentTextView insertText:@"#"];
    // TODO: 可以跳转到话题选择页面
}

- (void)keyboardDoneButtonTapped {
    // 收起键盘时重置状态
    self.isShowingEmojiKeyboard = NO;
    self.emojiToolbarButton.selected = NO;
    [self.contentTextView resignFirstResponder];
}

#pragma mark - 话题区域
- (void)setupTopicSection {
    self.topicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.topicButton setTitle:@"#话题" forState:UIControlStateNormal];
    [self.topicButton setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    self.topicButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.topicButton.layer.cornerRadius = 15;
    self.topicButton.layer.borderWidth = 1;
    self.topicButton.layer.borderColor = RGB(220, 220, 220).CGColor;
    self.topicButton.contentEdgeInsets = UIEdgeInsetsMake(8, 15, 8, 15);
    [self.topicButton addTarget:self action:@selector(topicButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.topicButton];
    [self.topicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.visibilityView.mas_top).offset(-15);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - 可见性设置
- (void)setupVisibilitySection {
    self.visibilityView = [[UIView alloc] init];
    self.visibilityView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.visibilityView];
    [self.visibilityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomView.mas_top);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    // 顶部分割线
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = RGB(238, 238, 238);
    [self.visibilityView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    // 图标
    UIImageView *visibilityIcon = [[UIImageView alloc] init];
    visibilityIcon.image = [UIImage imageNamed:@"visibility_icon"];
    visibilityIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.visibilityView addSubview:visibilityIcon];
    [visibilityIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.visibilityView);
        make.width.height.mas_equalTo(18);
    }];
    
    // 标签
    self.visibilityLabel = [[UILabel alloc] init];
    self.visibilityLabel.text = @"公开可见";
    self.visibilityLabel.font = [UIFont systemFontOfSize:14];
    self.visibilityLabel.textColor = RGB(51, 51, 51);
    [self.visibilityView addSubview:self.visibilityLabel];
    [self.visibilityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(visibilityIcon.mas_right).offset(10);
        make.centerY.mas_equalTo(self.visibilityView);
    }];
    
    // 箭头
    UIImageView *arrowIcon = [[UIImageView alloc] init];
    arrowIcon.image = [UIImage imageNamed:@"user_next"];
    arrowIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.visibilityView addSubview:arrowIcon];
    [arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.visibilityView);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(12);
    }];
    
    // 点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(visibilityTapped)];
    [self.visibilityView addGestureRecognizer:tap];
}

#pragma mark - 底部按钮
- (void)setupBottomButtons {
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
    
    // 存草稿按钮
    self.saveDraftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveDraftButton setTitle:@" 存草稿" forState:UIControlStateNormal];
    [self.saveDraftButton setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    [self.saveDraftButton setImage:[UIImage imageNamed:@"save_draft_icon"] forState:UIControlStateNormal];
    self.saveDraftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.saveDraftButton.layer.cornerRadius = 22;
    self.saveDraftButton.layer.borderWidth = 1;
    self.saveDraftButton.layer.borderColor = RGB(220, 220, 220).CGColor;
    [self.saveDraftButton addTarget:self action:@selector(saveDraftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.saveDraftButton];
    [self.saveDraftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(44);
    }];
    
    // 立即发布按钮
    self.publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.publishButton setTitle:@"立即发布" forState:UIControlStateNormal];
    [self.publishButton setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    self.publishButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.publishButton.backgroundColor = RGB(145, 233, 80);
    self.publishButton.layer.cornerRadius = 22;
    [self.publishButton addTarget:self action:@selector(publishButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.publishButton];
    [self.publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.saveDraftButton.mas_right).offset(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - 可见性选择弹窗
- (void)setupVisibilityPicker {
    // 背景遮罩
    self.visibilityPickerBackground = [[UIView alloc] init];
    self.visibilityPickerBackground.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.visibilityPickerBackground.hidden = YES;
    [self.view addSubview:self.visibilityPickerBackground];
    [self.visibilityPickerBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideVisibilityPicker)];
    [self.visibilityPickerBackground addGestureRecognizer:backgroundTap];
    
    // 选择视图
    self.visibilityPickerView = [[UIView alloc] init];
    self.visibilityPickerView.backgroundColor = RGB(250, 250, 250);
    self.visibilityPickerView.hidden = YES;
    [self.view addSubview:self.visibilityPickerView];
    [self.visibilityPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(200);
    }];
    
    // 公开可见选项
    UIButton *publicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [publicButton setTitle:@"  公开可见" forState:UIControlStateNormal];
    [publicButton setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    publicButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [publicButton setImage:[UIImage imageNamed:@"suo_p"] forState:UIControlStateNormal];
    publicButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    publicButton.backgroundColor = [UIColor whiteColor];
    publicButton.layer.cornerRadius = 8;
    publicButton.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    publicButton.layer.masksToBounds = YES;
    publicButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [publicButton addTarget:self action:@selector(selectPublicVisibility) forControlEvents:UIControlEventTouchUpInside];
    [self.visibilityPickerView addSubview:publicButton];
    [publicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(50);
    }];
    
    // 公开可见的勾选标记
    UIImageView *publicCheckmark = [[UIImageView alloc] init];
    publicCheckmark.image = [UIImage imageNamed:@"dui_p"];
    publicCheckmark.contentMode = UIViewContentModeScaleAspectFit;
    publicCheckmark.tag = 100; // 用于标识
    [self.visibilityPickerView addSubview:publicCheckmark];
    [publicCheckmark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(publicButton);
        make.width.height.mas_equalTo(16);
    }];
    
    // 仅自己可见选项
    UIButton *privateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [privateButton setTitle:@"  仅自己可见" forState:UIControlStateNormal];
    [privateButton setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    [privateButton setImage:[UIImage imageNamed:@"suo_p"] forState:UIControlStateNormal];
    privateButton.titleLabel.font = [UIFont systemFontOfSize:14];
    privateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    privateButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    privateButton.backgroundColor = [UIColor whiteColor];
    privateButton.layer.cornerRadius = 8;
    privateButton.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    privateButton.layer.masksToBounds = YES;
    [privateButton addTarget:self action:@selector(selectPrivateVisibility) forControlEvents:UIControlEventTouchUpInside];
    [self.visibilityPickerView addSubview:privateButton];
    [privateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(publicButton.mas_bottom).offset(0.5);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(50);
    }];
    
    // 分割线
    UIView *separator1 = [[UIView alloc] init];
    separator1.backgroundColor = RGB(238, 238, 238);
    [self.visibilityPickerView addSubview:separator1];
    [separator1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(privateButton.mas_top);
        make.left.mas_equalTo(publicButton.mas_left).offset(15);
        make.right.mas_equalTo(publicButton.mas_left).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    // 仅自己可见的勾选标记
    UIImageView *privateCheckmark = [[UIImageView alloc] init];
    privateCheckmark.image = [UIImage imageNamed:@"dui_p"];
    privateCheckmark.contentMode = UIViewContentModeScaleAspectFit;
    privateCheckmark.tag = 101; // 用于标识
    privateCheckmark.hidden = YES;
    [self.visibilityPickerView addSubview:privateCheckmark];
    [privateCheckmark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(privateButton);
        make.width.height.mas_equalTo(16);
    }];
    
    // 取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton addTarget:self action:@selector(hideVisibilityPicker) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.layer.cornerRadius = 8;
    cancelButton.layer.masksToBounds = YES;
    cancelButton.backgroundColor = [UIColor whiteColor];
    [self.visibilityPickerView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(privateButton.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(50);
    }];
    
    // 更新初始状态
    [self updateVisibilityCheckmarks];
}

- (void)updateVisibilityCheckmarks {
    UIImageView *publicCheckmark = [self.visibilityPickerView viewWithTag:100];
    UIImageView *privateCheckmark = [self.visibilityPickerView viewWithTag:101];
    
    publicCheckmark.hidden = (self.visibilityType != 0);
    privateCheckmark.hidden = (self.visibilityType != 1);
}

- (void)showVisibilityPicker {
    // 更新勾选标记状态
    [self updateVisibilityCheckmarks];
    
    self.visibilityPickerBackground.hidden = NO;
    self.visibilityPickerView.hidden = NO;
    
    // 动画：从底部滑入
    CGRect frame = self.visibilityPickerView.frame;
    frame.origin.y = self.view.bounds.size.height;
    self.visibilityPickerView.frame = frame;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect finalFrame = self.visibilityPickerView.frame;
        finalFrame.origin.y = self.view.bounds.size.height - 200;
        self.visibilityPickerView.frame = finalFrame;
        self.visibilityPickerBackground.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self.view layoutIfNeeded];
    }];
}

- (void)hideVisibilityPicker {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.visibilityPickerView.frame;
        frame.origin.y = self.view.bounds.size.height;
        self.visibilityPickerView.frame = frame;
        self.visibilityPickerBackground.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.visibilityPickerBackground.hidden = YES;
        self.visibilityPickerView.hidden = YES;
        [self.view layoutIfNeeded];
    }];
}

- (void)selectPublicVisibility {
    self.visibilityType = 0;
    self.visibilityLabel.text = @"公开可见";
    [self updateVisibilityCheckmarks];
    [self hideVisibilityPicker];
}

- (void)selectPrivateVisibility {
    self.visibilityType = 1;
    self.visibilityLabel.text = @"仅自己可见";
    [self updateVisibilityCheckmarks];
    [self hideVisibilityPicker];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedImages.count + 1;  // +1 为添加按钮
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.selectedImages.count) {
        // 已选择的图片
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
        
        // 清除旧的子视图
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
        
        // 图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imageView.image = self.selectedImages[indexPath.item];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = 4;
        imageView.layer.masksToBounds = YES;
        [cell.contentView addSubview:imageView];
        
        // 序号标签
        UILabel *indexLabel = [[UILabel alloc] init];
        indexLabel.text = [NSString stringWithFormat:@"%ld", (long)(indexPath.item + 1)];
        indexLabel.font = [UIFont boldSystemFontOfSize:10];
        indexLabel.textColor = [UIColor whiteColor];
        indexLabel.backgroundColor = [UIColor colorWithRed:50/255.0 green:48/255.0 blue:48/255.0 alpha:0.6];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.layer.cornerRadius = 6;
        indexLabel.layer.masksToBounds = YES;
        [imageView addSubview:indexLabel];
        [indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(-2.5);
            make.width.height.mas_equalTo(18);
        }];
        
        return cell;
    } else {
        // 添加按钮
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddCell" forIndexPath:indexPath];
        
        // 清除旧的子视图
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
        
        // 添加图片
        UIImageView *addImageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        addImageView.image = [UIImage imageNamed:@"addImage_p"];
        addImageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:addImageView];
        
        return cell;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 80);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item >= self.selectedImages.count) {
        // 点击添加按钮
        [self selectImages];
    } else {
        // 点击已选择的图片，跳转到预览页面
        [self showPreviewAtIndex:indexPath.item];
    }
}

- (void)showPreviewAtIndex:(NSInteger)index {
    PhotoPreviewViewController *previewVC = [[PhotoPreviewViewController alloc] init];
    previewVC.images = [self.selectedImages mutableCopy];
    previewVC.currentIndex = index;
    previewVC.modalPresentationStyle = UIModalPresentationFullScreen;
    
    WeakSelf
    previewVC.didDeleteImageBlock = ^(NSInteger deletedIndex) {
        [weakSelf.selectedImages removeObjectAtIndex:deletedIndex];
        [weakSelf.imageCollectionView reloadData];
    };
    
    previewVC.didUpdateImagesBlock = ^(NSArray<UIImage *> *images) {
        weakSelf.selectedImages = [images mutableCopy];
        [weakSelf.imageCollectionView reloadData];
    };
    
    [self presentViewController:previewVC animated:YES completion:nil];
}

#pragma mark - 拖拽排序
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.imageCollectionView];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *indexPath = [self.imageCollectionView indexPathForItemAtPoint:point];
            // 只允许拖拽已选择的图片，不能拖拽添加按钮
            if (indexPath && indexPath.item < self.selectedImages.count) {
                [self.imageCollectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self.imageCollectionView updateInteractiveMovementTargetPosition:point];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self.imageCollectionView endInteractiveMovement];
            break;
        }
        default: {
            [self.imageCollectionView cancelInteractiveMovement];
            break;
        }
    }
}

// 允许移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    // 只允许移动已选择的图片，添加按钮不能移动
    return indexPath.item < self.selectedImages.count;
}

// 执行移动
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 不允许移动到添加按钮的位置
    if (destinationIndexPath.item >= self.selectedImages.count) {
        return;
    }
    
    // 更新数据源
    UIImage *image = self.selectedImages[sourceIndexPath.item];
    [self.selectedImages removeObjectAtIndex:sourceIndexPath.item];
    [self.selectedImages insertObject:image atIndex:destinationIndexPath.item];
    
    // 延迟刷新以更新序号标签
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.imageCollectionView reloadData];
    });
}

// 限制目标位置
- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath {
    // 不允许移动到添加按钮的位置
    if (proposedIndexPath.item >= self.selectedImages.count) {
        return [NSIndexPath indexPathForItem:self.selectedImages.count - 1 inSection:0];
    }
    return proposedIndexPath;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return newText.length <= kMaxTitleLength;
}

- (void)titleTextFieldChanged:(UITextField *)textField {
    NSInteger remaining = kMaxTitleLength - textField.text.length;
    self.titleCountLabel.text = [NSString stringWithFormat:@"%ld", (long)remaining];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.contentPlaceholder.hidden = textView.text.length > 0;
    
    NSInteger remaining = kMaxContentLength - textView.text.length;
    self.contentCountLabel.text = [NSString stringWithFormat:@"%ld", (long)remaining];
    
    if (remaining < 0) {
        self.contentCountLabel.textColor = RGB(255, 100, 100);
    } else {
        self.contentCountLabel.textColor = RGB(187, 187, 187);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;  // 允许输入，通过字数统计显示超出
}

#pragma mark - Actions
- (void)backButtonClicked {
    [self.navigationController popViewControllerWithAnimationType:TransitionAnimationTypePresentFromBottom duration:0.3 completion:^{
        
    }];
}

- (void)selectImages {
    NSInteger maxCount = 9 - self.selectedImages.count;
    if (maxCount <= 0) {
        [AlertWith showAlertWithMessageText:@"最多只能选择9张图片"];
        return;
    }
    
    // 使用自定义图片选择器
    PhotoPickerViewController *picker = [[PhotoPickerViewController alloc] init];
    picker.maxSelectCount = maxCount;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    WeakSelf
    picker.didFinishPickingBlock = ^(NSArray<UIImage *> *images, NSArray<PHAsset *> *assets) {
        [weakSelf.selectedImages addObjectsFromArray:images];
        [weakSelf.imageCollectionView reloadData];
    };
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)topicButtonClicked {
    NSLog(@"选择话题");
    // TODO: 打开话题选择页面
}

- (void)visibilityTapped {
    [self showVisibilityPicker];
}

- (void)saveDraftButtonClicked {
    NSLog(@"保存草稿");
    // TODO: 保存到本地草稿
    [AlertWith showAlertWithMessageText:@"已保存到草稿"];
}

- (void)publishButtonClicked {
    // 验证
    if (self.selectedImages.count == 0) {
        [AlertWith showAlertWithMessageText:@"请选择至少一张图片"];
        return;
    }
    
    if (self.titleTextField.text.length == 0) {
        [AlertWith showAlertWithMessageText:@"请输入标题"];
        return;
    }
    
    NSLog(@"发布帖子");
    // TODO: 调用发布接口
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Navigation Bar
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
