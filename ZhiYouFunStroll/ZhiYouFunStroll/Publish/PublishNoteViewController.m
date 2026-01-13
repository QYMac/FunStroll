//
//  PublishNoteViewController.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import "PublishNoteViewController.h"

static const NSInteger kMaxTitleLength = 20;
static const NSInteger kMaxContentLength = 120;

@interface PublishNoteViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UITextViewDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

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

// 话题
@property (nonatomic, strong) UIButton *topicButton;

// 可见性
@property (nonatomic, strong) UIView *visibilityView;
@property (nonatomic, strong) UILabel *visibilityLabel;

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
    // 滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-100);
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
    
    // 话题
    [self setupTopicSection];
    
    // 可见性设置
    [self setupVisibilitySection];
    
    // 底部按钮
    [self setupBottomButtons];
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
    
    [self.contentView addSubview:self.imageCollectionView];
    [self.imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
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
    [self.contentView addSubview:self.contentTextView];
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(200);
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
    }];
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
    [self.contentView addSubview:self.topicButton];
    [self.topicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentCountLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - 可见性设置
- (void)setupVisibilitySection {
    self.visibilityView = [[UIView alloc] init];
    self.visibilityView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.visibilityView];
    [self.visibilityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topicButton.mas_bottom).offset(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(0);
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
    [self.saveDraftButton setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    [self.saveDraftButton setImage:[UIImage imageNamed:@"save_draft_icon"] forState:UIControlStateNormal];
    self.saveDraftButton.titleLabel.font = [UIFont systemFontOfSize:14];
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
    [self.publishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.publishButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.publishButton.backgroundColor = RGB(139, 195, 74);
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
        indexLabel.backgroundColor = RGB(76, 175, 80);
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.layer.cornerRadius = 8;
        indexLabel.layer.masksToBounds = YES;
        [cell.contentView addSubview:indexLabel];
        [indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(5);
            make.width.height.mas_equalTo(16);
        }];
        
        return cell;
    } else {
        // 添加按钮
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddCell" forIndexPath:indexPath];
        
        // 清除旧的子视图
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
        
        // 虚线边框容器
        UIView *addView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
        addView.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:addView];
        
        // 添加虚线边框
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.strokeColor = RGB(200, 200, 200).CGColor;
        borderLayer.fillColor = nil;
        borderLayer.lineDashPattern = @[@4, @2];
        borderLayer.lineWidth = 1;
        borderLayer.frame = addView.bounds;
        borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:addView.bounds cornerRadius:4].CGPath;
        [addView.layer addSublayer:borderLayer];
        
        // 加号
        UILabel *plusLabel = [[UILabel alloc] init];
        plusLabel.text = @"+";
        plusLabel.font = [UIFont systemFontOfSize:30];
        plusLabel.textColor = RGB(180, 180, 180);
        plusLabel.textAlignment = NSTextAlignmentCenter;
        [addView addSubview:plusLabel];
        [plusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(addView);
        }];
        
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
    }
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
    return YES;  // 允许超出，但显示负数
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self.selectedImages addObjectsFromArray:photos];
    [self.imageCollectionView reloadData];
}

#pragma mark - Actions
- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectImages {
    NSInteger maxCount = 9 - self.selectedImages.count;
    if (maxCount <= 0) {
        [AlertWith showAlertWithMessageText:@"最多只能选择9张图片"];
        return;
    }
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowTakePicture = YES;
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)topicButtonClicked {
    NSLog(@"选择话题");
    // TODO: 打开话题选择页面
}

- (void)visibilityTapped {
    NSLog(@"设置可见性");
    // TODO: 打开可见性设置
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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
