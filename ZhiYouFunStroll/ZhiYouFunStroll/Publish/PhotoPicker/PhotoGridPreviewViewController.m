//
//  PhotoGridPreviewViewController.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import "PhotoGridPreviewViewController.h"
#import "SelectedPhotoBar.h"

@interface PhotoGridPreviewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PhotoGridPreviewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.clipsToBounds = YES;
        self.imageView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}

@end

#pragma mark - PhotoGridPreviewViewController

@interface PhotoGridPreviewViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UILabel *selectIndexLabel;
@property (nonatomic, strong) UICollectionView *collectionView;

// 底部区域
@property (nonatomic, strong) UIView *bottomContainer;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) SelectedPhotoBar *selectedBar;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation PhotoGridPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupUI];
    [self updateSelectButton];
    [self updateNextButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 滚动到当前位置
    if (self.currentIndex < self.allAssets.count) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:NO];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // 设置 bottomContainer 上部分圆角
    if (self.bottomContainer) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bottomContainer.bounds
                                                        byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                              cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bottomContainer.bounds;
        maskLayer.path = maskPath.CGPath;
        self.bottomContainer.layer.mask = maskLayer;
    }
}

- (void)setupUI {
    // 导航栏
    [self setupNavBar];
    
    // 图片滑动视图
    [self setupCollectionView];
    
    // 底部区域
    [self setupBottomArea];
}

#pragma mark - 导航栏
- (void)setupNavBar {
    self.navBar = [[UIView alloc] init];
    self.navBar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.navBar];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44 + statusBarHeight);
    }];
    
    // 返回按钮
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"back_picker"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-10);
        make.width.height.mas_equalTo(24);
    }];
    
    
    // 选择按钮
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.selectButton setTitle:@"选择" forState:UIControlStateNormal];
    [self.selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selectButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.selectButton addTarget:self action:@selector(selectButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:self.selectButton];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.backButton);
    }];
    
    // 选择序号标签（绿色圆圈）
    self.selectIndexLabel = [[UILabel alloc] init];
    self.selectIndexLabel.font = [UIFont boldSystemFontOfSize:12];
    self.selectIndexLabel.textColor = [UIColor whiteColor];
    self.selectIndexLabel.backgroundColor = RGB(145, 233, 80);
    self.selectIndexLabel.textAlignment = NSTextAlignmentCenter;
    self.selectIndexLabel.layer.cornerRadius = 10;
    self.selectIndexLabel.layer.masksToBounds = YES;
    self.selectIndexLabel.hidden = YES;
    [self.navBar addSubview:self.selectIndexLabel];
    [self.selectIndexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.selectButton.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.backButton);
        make.width.height.mas_equalTo(20);
    }];
}

#pragma mark - 底部区域
- (void)setupBottomArea {
    self.bottomContainer = [[UIView alloc] init];
    self.bottomContainer.backgroundColor = RGB(29, 29, 29);
    self.bottomContainer.hidden = YES; // 初始隐藏
    [self.view addSubview:self.bottomContainer];
    [self.bottomContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(150 + bottomHeight);
    }];
    /*
    // 黄色分隔线
    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.backgroundColor = RGB(255, 204, 0);
    [self.bottomContainer addSubview:self.separatorLine];
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(2);
    }];
     */
    
    // 已选图片预览条
    self.selectedBar = [[SelectedPhotoBar alloc] init];
    self.selectedBar.imageManager = self.imageManager;
    WeakSelf
    self.selectedBar.didDeleteBlock = ^(PHAsset *asset) {
        [weakSelf.selectedAssets removeObject:asset];
        [weakSelf updateSelectedBar];
        [weakSelf updateSelectButton];
        [weakSelf updateNextButton];
        if (weakSelf.didSelectBlock) {
            weakSelf.didSelectBlock(asset, NO);
        }
    };
    self.selectedBar.didReorderBlock = ^(NSArray<PHAsset *> *assets) {
        weakSelf.selectedAssets = [assets mutableCopy];
        [weakSelf updateSelectButton];
    };
    [self.bottomContainer addSubview:self.selectedBar];
    [self.selectedBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(70);
    }];
    
    // 提示标签
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.text = @"长按拖动素材可排序";
    self.tipLabel.font = [UIFont systemFontOfSize:12];
    self.tipLabel.textColor = RGB(153, 153, 153);
    [self.bottomContainer addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.selectedBar.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
    }];
    
    // 下一步按钮
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextButton setTitle:@"下一步(2)" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.nextButton.backgroundColor = RGB(145, 233, 80);
    self.nextButton.layer.cornerRadius = 22;
    [self.nextButton addTarget:self action:@selector(nextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomContainer addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.tipLabel);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(44);
    }];
    
    // 更新已选图片
    [self updateSelectedBar];
}

#pragma mark - 图片滑动视图
- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[PhotoGridPreviewCell class] forCellWithReuseIdentifier:@"PhotoGridPreviewCell"];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navBar.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0); // 初始 bottom = 0，选择图片后动态调整
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allAssets.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoGridPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoGridPreviewCell" forIndexPath:indexPath];
    
    PHAsset *asset = self.allAssets[indexPath.item];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize targetSize = CGSizeMake(kWidth * scale, kHeight * scale);
    
    [self.imageManager requestImageForAsset:asset
                                 targetSize:targetSize
                                contentMode:PHImageContentModeAspectFit
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
        cell.imageView.image = result;
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kWidth, collectionView.bounds.size.height);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.currentIndex = page;
    [self updateSelectButton];
}

#pragma mark - 更新UI
- (void)updateSelectButton {
    if (self.currentIndex < self.allAssets.count) {
        PHAsset *currentAsset = self.allAssets[self.currentIndex];
        NSInteger selectedIndex = [self.selectedAssets indexOfObject:currentAsset];
        
        if (selectedIndex != NSNotFound) {
            // 已选中，显示序号
            self.selectIndexLabel.text = [NSString stringWithFormat:@"%ld", (long)(selectedIndex + 1)];
            self.selectIndexLabel.hidden = NO;
        } else {
            // 未选中
            self.selectIndexLabel.hidden = YES;
        }
    }
}

- (void)updateSelectedBar {
    [self.selectedBar updateWithAssets:self.selectedAssets];
    
    // 根据选中图片数量控制 bottomContainer 显示/隐藏，带动画
    BOOL hasSelection = (self.selectedAssets.count > 0);
    BOOL isCurrentlyHidden = self.bottomContainer.hidden;
    
    if (hasSelection && isCurrentlyHidden) {
        // 需要显示 bottomContainer
        self.bottomContainer.hidden = NO;
        self.bottomContainer.alpha = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomContainer.alpha = 1;
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-(150 + bottomHeight));
            }];
            [self.view layoutIfNeeded];
        }];
    } else if (!hasSelection && !isCurrentlyHidden) {
        // 需要隐藏 bottomContainer
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomContainer.alpha = 0;
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
            }];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.bottomContainer.hidden = YES;
        }];
    }
}

- (void)updateNextButton {
    /*
    NSInteger count = self.selectedAssets.count;
    [self.nextButton setTitle:[NSString stringWithFormat:@"下一步(%ld)", (long)count] forState:UIControlStateNormal];
    self.nextButton.enabled = count > 0;
    self.nextButton.alpha = count > 0 ? 1.0 : 0.5;
     */
}

#pragma mark - Actions
- (void)backButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectButtonClicked {
    if (self.currentIndex >= self.allAssets.count) return;
    
    PHAsset *currentAsset = self.allAssets[self.currentIndex];
    BOOL isCurrentlySelected = [self.selectedAssets containsObject:currentAsset];
    
    if (isCurrentlySelected) {
        // 取消选择
        [self.selectedAssets removeObject:currentAsset];
        if (self.didSelectBlock) {
            self.didSelectBlock(currentAsset, NO);
        }
    } else {
        // 选择
        if (self.selectedAssets.count >= self.maxSelectCount) {
            [AlertWith showAlertWithMessageText:[NSString stringWithFormat:@"最多只能选择%ld张图片", (long)self.maxSelectCount]];
            return;
        }
        [self.selectedAssets addObject:currentAsset];
        if (self.didSelectBlock) {
            self.didSelectBlock(currentAsset, YES);
        }
    }
    
    [self updateSelectButton];
    [self updateSelectedBar];
    [self updateNextButton];
}

- (void)nextButtonClicked {
    if (self.selectedAssets.count == 0) return;
    
    // 返回并触发完成
    if (self.didFinishBlock) {
        self.didFinishBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
