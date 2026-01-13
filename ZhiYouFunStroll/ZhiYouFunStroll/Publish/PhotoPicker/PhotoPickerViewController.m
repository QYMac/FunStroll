//
//  PhotoPickerViewController.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import "PhotoPickerViewController.h"
#import "PhotoPickerCell.h"
#import "SelectedPhotoBar.h"
#import "PhotoPreviewViewController.h"
#import "PhotoGridPreviewViewController.h"
#import "AlbumListView.h"

@interface PhotoPickerViewController () <UICollectionViewDelegate, UICollectionViewDataSource, PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowIcon;

@property (nonatomic, strong) UIView *tabBar;
@property (nonatomic, strong) NSArray<UIButton *> *tabButtons;
@property (nonatomic, strong) UIView *tabIndicator;
@property (nonatomic, assign) NSInteger selectedTabIndex;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *bottomContainer;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) SelectedPhotoBar *selectedBar;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) NSMutableArray<PHAsset *> *allAssets;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *photoAssets;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *livePhotoAssets;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *currentAssets;

@property (nonatomic, strong) NSMutableArray<PHAsset *> *selectedAssets;
@property (nonatomic, strong) PHCachingImageManager *imageManager;

// 相册列表
@property (nonatomic, strong) AlbumListView *albumListView;
@property (nonatomic, strong) NSMutableArray<AlbumModel *> *albums;
@property (nonatomic, strong) PHAssetCollection *currentCollection;

// 记录每个 tab 的滚动位置
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSValue *> *tabScrollOffsets;

// 图片请求优化
@property (nonatomic, assign) CGSize thumbnailSize;
@property (nonatomic, strong) PHImageRequestOptions *imageRequestOptions;

@end

@implementation PhotoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.maxSelectCount = self.maxSelectCount > 0 ? self.maxSelectCount : 9;
    self.selectedAssets = [NSMutableArray array];
    self.imageManager = [[PHCachingImageManager alloc] init];
    self.imageManager.allowsCachingHighQualityImages = NO;  // 不缓存高质量图片，提升性能
    self.tabScrollOffsets = [NSMutableDictionary dictionary];
    
    // 计算缩略图尺寸
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat cellWidth = (kWidth - 5) / 4;
    self.thumbnailSize = CGSizeMake(cellWidth * scale, cellWidth * scale);
    
    // 配置图片请求选项
    self.imageRequestOptions = [[PHImageRequestOptions alloc] init];
    self.imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    self.imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    self.imageRequestOptions.networkAccessAllowed = NO;  // 不从 iCloud 下载
    
    [self setupUI];
    [self requestPhotoLibraryAccess];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    [self.imageManager stopCachingImagesForAllAssets];
}

- (void)setupUI {
    // 导航栏
    [self setupNavBar];
    
    // 分类标签
    [self setupTabBar];
    
    // 图片网格
    [self setupCollectionView];
    
    // 底部区域
    [self setupBottomArea];
    
    // 相册选择
    [self setupAlbumListView];
}

#pragma mark - 导航栏
- (void)setupNavBar {
    self.navBar = [[UIView alloc] init];
    self.navBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navBar];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44 + statusBarHeight);
    }];
    
    // 关闭按钮
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setImage:[UIImage imageNamed:@"tuichu_picker"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-10);
        make.width.height.mas_equalTo(24);
    }];
    
    // 标题按钮（可点击切换相册）
    self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.titleButton addTarget:self action:@selector(titleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:self.titleButton];
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.navBar).centerOffset(CGPointMake(0, statusBarHeight / 2));
        make.height.mas_equalTo(44);
    }];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"最近项目";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.textColor = RGB(51, 51, 51);
    [self.titleButton addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self.titleButton);
    }];
    
    // 箭头
    self.arrowIcon = [[UIImageView alloc] init];
    self.arrowIcon.image = [UIImage imageNamed:@"duo_picker"];
    [self.titleButton addSubview:self.arrowIcon];
    [self.arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(5);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.titleLabel);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(8);
    }];
}

#pragma mark - 分类标签
- (void)setupTabBar {
    self.tabBar = [[UIView alloc] init];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tabBar];
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navBar.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    NSArray *titles = @[@"全部", @"图片", @"实况"];
    NSMutableArray *buttons = [NSMutableArray array];
    CGFloat buttonWidth = kWidth / 3;
    
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
        [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = i;
        [button addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i * buttonWidth);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(buttonWidth);
        }];
        [buttons addObject:button];
        
        if (i == 0) {
            button.selected = YES;
        }
    }
    self.tabButtons = buttons;
    self.selectedTabIndex = 0;
    
    // 指示器
    self.tabIndicator = [[UIView alloc] init];
    self.tabIndicator.backgroundColor = RGB(145, 233, 80);
    self.tabIndicator.layer.cornerRadius = 1.5;
    [self.tabBar addSubview:self.tabIndicator];
    [self.tabIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-2);
        make.centerX.mas_equalTo(self.tabButtons[0]);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(3);
    }];
}

#pragma mark - 图片网格
- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWidth = (kWidth - 4) / 3;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[PhotoPickerCell class] forCellWithReuseIdentifier:@"PhotoPickerCell"];
    
    // 添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.5;
    [self.collectionView addGestureRecognizer:longPress];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tabBar.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0); // 初始 bottom = 0，选择图片后动态调整
    }];
}

#pragma mark - 底部区域
- (void)setupBottomArea {
    // 底部容器
    self.bottomContainer = [[UIView alloc] init];
    self.bottomContainer.backgroundColor = [UIColor clearColor];
    self.bottomContainer.hidden = YES; // 初始隐藏
    [self.view addSubview:self.bottomContainer];
    [self.bottomContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(180 + bottomHeight);
    }];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = RGB(244, 244, 244);
    [self.bottomContainer addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(80);
    }];
    
    // 计数标签
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.text = [NSString stringWithFormat:@"已选0张，最多支持%ld张", (long)self.maxSelectCount];
    self.countLabel.font = [UIFont systemFontOfSize:12];
    self.countLabel.textColor = RGB(153, 153, 153);
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    [self.bottomContainer addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    UIView *selectedBarBgView = [[UIView alloc] init];
    selectedBarBgView.backgroundColor = [UIColor whiteColor];
    selectedBarBgView.layer.cornerRadius = 20;
    selectedBarBgView.layer.masksToBounds = YES;
    [self.bottomContainer addSubview:selectedBarBgView];
    [selectedBarBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.countLabel.mas_bottom).offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
    
    // 已选图片预览条
    self.selectedBar = [[SelectedPhotoBar alloc] init];
    self.selectedBar.imageManager = self.imageManager;
    WeakSelf
    self.selectedBar.didDeleteBlock = ^(PHAsset *asset) {
        [weakSelf deselectAsset:asset];
    };
    self.selectedBar.didReorderBlock = ^(NSArray<PHAsset *> *assets) {
        weakSelf.selectedAssets = [assets mutableCopy];
        [weakSelf updateSelectedUI];
    };
    self.selectedBar.didSelectBlock = ^(PHAsset *asset, NSInteger index) {
        [weakSelf showPreviewAtIndex:index];
    };
    [selectedBarBgView addSubview:self.selectedBar];
    [self.selectedBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(70);
    }];
    
    // 提示标签
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"长按拖动素材可排序";
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = RGB(153, 153, 153);
    [self.bottomContainer addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(selectedBarBgView.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
    }];
    
    // 下一步按钮
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextButton setTitle:@"下一步(2)" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.nextButton.backgroundColor = RGB(145, 233, 80);
    self.nextButton.layer.cornerRadius = 34/2;
    [self.nextButton addTarget:self action:@selector(nextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomContainer addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(tipLabel);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(34);
    }];
    
    [self updateNextButton];
}

#pragma mark - 请求相册权限
- (void)requestPhotoLibraryAccess {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        [self loadAlbums];
        [self loadPhotos];
    } else if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    [self loadAlbums];
                    [self loadPhotos];
                }
            });
        }];
    }
}

#pragma mark - 加载相册列表
- (void)loadAlbums {
    self.albums = [NSMutableArray array];
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    // 相机胶卷（最近项目）
    PHFetchResult *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                          subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                          options:nil];
    [cameraRoll enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
        [self addAlbumWithCollection:collection options:options];
    }];
    
    // 用户创建的相册
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                          subtype:PHAssetCollectionSubtypeAny
                                                                          options:nil];
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
        [self addAlbumWithCollection:collection options:options];
    }];
    
    // 智能相册（人像、截屏、自拍等）
    NSArray *smartAlbumSubtypes = @[
        @(PHAssetCollectionSubtypeSmartAlbumFavorites),      // 收藏
        @(PHAssetCollectionSubtypeSmartAlbumRecentlyAdded),  // 最近添加
        @(PHAssetCollectionSubtypeSmartAlbumScreenshots),    // 截屏
        @(PHAssetCollectionSubtypeSmartAlbumSelfPortraits),  // 自拍
        @(PHAssetCollectionSubtypeSmartAlbumPanoramas),      // 全景照片
        @(PHAssetCollectionSubtypeSmartAlbumLivePhotos),     // 实况照片
        @(PHAssetCollectionSubtypeSmartAlbumDepthEffect),    // 人像
    ];
    
    for (NSNumber *subtype in smartAlbumSubtypes) {
        PHFetchResult *smartAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                              subtype:[subtype integerValue]
                                                                              options:nil];
        [smartAlbum enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
            [self addAlbumWithCollection:collection options:options];
        }];
    }
}

- (void)addAlbumWithCollection:(PHAssetCollection *)collection options:(PHFetchOptions *)options {
    PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    if (assets.count > 0) {
        AlbumModel *album = [[AlbumModel alloc] init];
        album.collection = collection;
        album.name = collection.localizedTitle;
        album.count = assets.count;
        album.coverAsset = assets.firstObject;
        [self.albums addObject:album];
    }
}

#pragma mark - 加载照片
- (void)loadPhotos {
    [self loadPhotosFromCollection:self.currentCollection];
}

- (void)loadPhotosFromCollection:(PHAssetCollection *)collection {
    self.allAssets = [NSMutableArray array];
    self.photoAssets = [NSMutableArray array];
    self.livePhotoAssets = [NSMutableArray array];
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    // 按创建时间降序排序（最新的在前）
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    PHFetchResult *result;
    if (collection) {
        result = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    } else {
        result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
    }
    
    [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        // 按时间顺序添加到全部列表
        [self.allAssets addObject:asset];
        
        // 按时间顺序分类到对应列表
        if (asset.mediaSubtypes & PHAssetMediaSubtypePhotoLive) {
            [self.livePhotoAssets addObject:asset];
        } else {
            [self.photoAssets addObject:asset];
        }
    }];
    
    // 根据当前选中的标签更新显示
    [self switchToTab:self.selectedTabIndex];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.currentAssets.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoPickerCell" forIndexPath:indexPath];
    
    PHAsset *asset = self.currentAssets[indexPath.item];
    
    // 取消之前的请求（如果有）
    if (cell.imageRequestID != PHInvalidImageRequestID) {
        [self.imageManager cancelImageRequest:cell.imageRequestID];
    }
    
    // 记录当前 asset 标识符，用于防止 cell 复用时图片错乱
    NSString *assetIdentifier = asset.localIdentifier;
    cell.representedAssetIdentifier = assetIdentifier;
    
    // 加载图片
    cell.imageRequestID = [self.imageManager requestImageForAsset:asset
                                 targetSize:self.thumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:self.imageRequestOptions
                              resultHandler:^(UIImage *result, NSDictionary *info) {
        // 检查 cell 是否还显示同一个 asset
        if ([cell.representedAssetIdentifier isEqualToString:assetIdentifier] && result) {
            cell.imageView.image = result;
        }
    }];
    
    // 选中状态
    NSInteger selectedIndex = [self.selectedAssets indexOfObject:asset];
    if (selectedIndex != NSNotFound) {
        cell.selectIndex = selectedIndex + 1;
        cell.isSelected = YES;
    } else {
        cell.selectIndex = 0;
        cell.isSelected = NO;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = self.currentAssets[indexPath.item];
    
    if ([self.selectedAssets containsObject:asset]) {
        // 取消选中
        [self.selectedAssets removeObject:asset];
    } else {
        // 选中
        if (self.selectedAssets.count >= self.maxSelectCount) {
            [AlertWith showAlertWithMessageText:[NSString stringWithFormat:@"最多只能选择%ld张图片", (long)self.maxSelectCount]];
            return;
        }
        [self.selectedAssets addObject:asset];
    }
    
    // 只刷新当前 cell
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    // 更新底部 UI
    [self.selectedBar updateWithAssets:self.selectedAssets];
    [self updateNextButton];
    [self updateCountLabel];
    
    // 控制 bottomContainer 显示/隐藏
    [self updateBottomContainerVisibility];
}

#pragma mark - UIScrollViewDelegate (预缓存优化)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.collectionView) return;
    
    [self updateCachedAssets];
}

- (void)updateCachedAssets {
    // 只缓存可见区域上下两行的图片
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x,
                                     self.collectionView.contentOffset.y,
                                     self.collectionView.bounds.size.width,
                                     self.collectionView.bounds.size.height);
    
    // 扩展预加载区域（上下各扩展半屏）
    CGRect preheatRect = CGRectInset(visibleRect, 0, -visibleRect.size.height / 2);
    
    // 获取需要预加载的 indexPaths
    NSArray *visibleIndexPaths = [self.collectionView indexPathsForVisibleItems];
    NSMutableArray *assetsToStartCaching = [NSMutableArray array];
    
    // 计算预加载范围内的 assets
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat itemHeight = layout.itemSize.height + layout.minimumLineSpacing;
    
    NSInteger startRow = MAX(0, (NSInteger)(preheatRect.origin.y / itemHeight) * 4);
    NSInteger endRow = MIN(self.currentAssets.count, (NSInteger)((preheatRect.origin.y + preheatRect.size.height) / itemHeight + 1) * 4);
    
    for (NSInteger i = startRow; i < endRow; i++) {
        [assetsToStartCaching addObject:self.currentAssets[i]];
    }
    
    // 开始预缓存
    if (assetsToStartCaching.count > 0) {
        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:self.thumbnailSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:self.imageRequestOptions];
    }
}

#pragma mark - PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadPhotos];
    });
}

#pragma mark - 选中/取消选中
- (void)deselectAsset:(PHAsset *)asset {
    [self.selectedAssets removeObject:asset];
    [self updateSelectedUI];
}

- (void)updateSelectedUI {
    [self.collectionView reloadData];
    [self.selectedBar updateWithAssets:self.selectedAssets];
    [self updateNextButton];
    [self updateCountLabel];
    [self updateBottomContainerVisibility];
}

- (void)updateBottomContainerVisibility {
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
                make.bottom.mas_equalTo(-(180 + bottomHeight));
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

- (void)updateCountLabel {
    self.countLabel.text = [NSString stringWithFormat:@"已选%ld张，最多支持%ld张", (long)self.selectedAssets.count, (long)self.maxSelectCount];
}

#pragma mark - 预览
- (void)showPreviewAtIndex:(NSInteger)index {
    PhotoGridPreviewViewController *gridVC = [[PhotoGridPreviewViewController alloc] init];
    // 使用副本作为 allAssets，避免取消选择时影响预览列表
    gridVC.allAssets = [self.selectedAssets copy];
    gridVC.selectedAssets = self.selectedAssets;
    gridVC.currentIndex = index;
    gridVC.maxSelectCount = self.maxSelectCount;
    gridVC.imageManager = self.imageManager;
    gridVC.modalPresentationStyle = UIModalPresentationFullScreen;
    
    WeakSelf
    gridVC.didSelectBlock = ^(PHAsset *asset, BOOL isSelected) {
        [weakSelf updateSelectedUI];
    };
    gridVC.didFinishBlock = ^{
        [weakSelf nextButtonClicked];
    };
    
    [self presentViewController:gridVC animated:YES completion:nil];
}

#pragma mark - 长按预览
- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gesture locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
        
        if (indexPath && indexPath.item < self.currentAssets.count) {
            [self showGridPreviewAtIndex:indexPath.item];
        }
    }
}

- (void)showGridPreviewAtIndex:(NSInteger)index {
    PhotoGridPreviewViewController *gridVC = [[PhotoGridPreviewViewController alloc] init];
    gridVC.allAssets = self.currentAssets;
    gridVC.selectedAssets = self.selectedAssets;
    gridVC.currentIndex = index;
    gridVC.maxSelectCount = self.maxSelectCount;
    gridVC.imageManager = self.imageManager;
    gridVC.modalPresentationStyle = UIModalPresentationFullScreen;
    
    WeakSelf
    gridVC.didSelectBlock = ^(PHAsset *asset, BOOL isSelected) {
        [weakSelf updateSelectedUI];
    };
    gridVC.didFinishBlock = ^{
        [weakSelf nextButtonClicked];
    };
    
    [self presentViewController:gridVC animated:YES completion:nil];
}

#pragma mark - 相册列表
- (void)setupAlbumListView {
    self.albumListView = [[AlbumListView alloc] init];
    self.albumListView.imageManager = self.imageManager;
    [self.view addSubview:self.albumListView];
    [self.albumListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    WeakSelf
    self.albumListView.didSelectAlbumBlock = ^(AlbumModel *album) {
        weakSelf.currentCollection = album.collection;
        weakSelf.titleLabel.text = album.name;
        
        // 清空所有 tab 的滚动位置记录
        [weakSelf.tabScrollOffsets removeAllObjects];
        
        [weakSelf loadPhotosFromCollection:album.collection];
        [weakSelf rotateArrow:NO];
        
        // 滚动到顶部
        [weakSelf.collectionView setContentOffset:CGPointZero animated:NO];
    };
}

- (void)titleButtonClicked {
    if (self.albumListView == nil) {
        [self setupAlbumListView];
    }
    
    if (self.albumListView.hidden) {
        [self rotateArrow:YES];
        [self.albumListView showWithAlbums:self.albums];
    } else {
        [self rotateArrow:NO];
        [self.albumListView hide];
    }
}

- (void)rotateArrow:(BOOL)up {
    [UIView animateWithDuration:0.25 animations:^{
        if (up) {
            self.arrowIcon.transform = CGAffineTransformMakeRotation(M_PI);
        } else {
            self.arrowIcon.transform = CGAffineTransformIdentity;
        }
    }];
}

- (void)switchToTab:(NSInteger)index {
    switch (index) {
        case 0:
            self.currentAssets = self.allAssets;
            break;
        case 1:
            self.currentAssets = self.photoAssets;
            break;
        case 2:
            self.currentAssets = self.livePhotoAssets;
            break;
    }
    [self.collectionView reloadData];
}

#pragma mark - Actions
- (void)closeButtonClicked {
    if (self.didCancelBlock) {
        self.didCancelBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tabButtonClicked:(UIButton *)button {
    if (button.tag == self.selectedTabIndex) return;
    
    // 保存当前 tab 的滚动位置
    CGPoint currentOffset = self.collectionView.contentOffset;
    self.tabScrollOffsets[@(self.selectedTabIndex)] = [NSValue valueWithCGPoint:currentOffset];
    
    // 更新按钮状态
    for (UIButton *btn in self.tabButtons) {
        btn.selected = (btn.tag == button.tag);
    }
    self.selectedTabIndex = button.tag;
    
    // 移动指示器
    [UIView animateWithDuration:0.25 animations:^{
        [self.tabIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-2);
            make.centerX.mas_equalTo(self.tabButtons[button.tag]);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(3);
        }];
        [self.tabBar layoutIfNeeded];
    }];
    
    // 切换数据源
    switch (button.tag) {
        case 0:
            self.currentAssets = self.allAssets;
            break;
        case 1:
            self.currentAssets = self.photoAssets;
            break;
        case 2:
            self.currentAssets = self.livePhotoAssets;
            break;
    }
    [self.collectionView reloadData];
    
    // 恢复新 tab 的滚动位置（如果有记录则恢复，否则滚动到顶部）
    NSValue *savedOffset = self.tabScrollOffsets[@(button.tag)];
    if (savedOffset) {
        [self.collectionView setContentOffset:[savedOffset CGPointValue] animated:NO];
    } else {
        [self.collectionView setContentOffset:CGPointZero animated:NO];
    }
}

- (void)nextButtonClicked {
    if (self.selectedAssets.count == 0) return;
    
    NSMutableArray *images = [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    for (PHAsset *asset in self.selectedAssets) {
        dispatch_group_enter(group);
        [self.imageManager requestImageForAsset:asset
                                     targetSize:PHImageManagerMaximumSize
                                    contentMode:PHImageContentModeAspectFit
                                        options:options
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
            if (result) {
                [images addObject:result];
            }
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (self.didFinishPickingBlock) {
            self.didFinishPickingBlock(images, self.selectedAssets);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
