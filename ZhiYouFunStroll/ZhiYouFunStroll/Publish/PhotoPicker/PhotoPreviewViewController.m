//
//  PhotoPreviewViewController.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import "PhotoPreviewViewController.h"
#import "PhotoPickerViewController.h"

@interface PreviewPhotoCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PreviewPhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.clipsToBounds = YES;
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

#pragma mark - 底部预览Cell

@interface PreviewBottomCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, assign) BOOL isCurrent;

@property (nonatomic, copy) void(^didDeleteBlock)(void);

@end

@implementation PreviewBottomCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 6;
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.indexLabel = [[UILabel alloc] init];
    self.indexLabel.font = [UIFont boldSystemFontOfSize:10];
    self.indexLabel.textColor = [UIColor whiteColor];
    self.indexLabel.backgroundColor = RGB(145, 233, 80);
    self.indexLabel.textAlignment = NSTextAlignmentCenter;
    self.indexLabel.layer.cornerRadius = 7;
    self.indexLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:self.indexLabel];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(2);
        make.width.height.mas_equalTo(14);
    }];
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setImage:[UIImage imageNamed:@"photo_delete"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-5);
        make.right.mas_equalTo(5);
        make.width.height.mas_equalTo(20);
    }];
}

- (void)setIsCurrent:(BOOL)isCurrent {
    _isCurrent = isCurrent;
    self.imageView.layer.borderWidth = isCurrent ? 2 : 0;
    self.imageView.layer.borderColor = RGB(145, 233, 80).CGColor;
}

- (void)deleteClicked {
    if (self.didDeleteBlock) {
        self.didDeleteBlock();
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.isCurrent = NO;
}

@end

#pragma mark - PhotoPreviewViewController

@interface PhotoPreviewViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) UICollectionView *bottomCollectionView;

@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIButton *replaceButton;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation PhotoPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupUI];
    [self updatePageLabel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 滚动到当前位置
    if (self.currentIndex < [self itemCount]) {
        [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                animated:NO];
    }
}

- (void)setupUI {
    // 导航栏
    [self setupNavBar];
    
    // 主图预览
    [self setupMainCollectionView];
    
    // 底部工具栏
    [self setupBottomBar];
    
    // 底部预览条
    //[self setupBottomCollectionView];
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
    
    // 页码
    self.pageLabel = [[UILabel alloc] init];
    self.pageLabel.font = [UIFont boldSystemFontOfSize:16];
    self.pageLabel.textColor = [UIColor whiteColor];
    [self.navBar addSubview:self.pageLabel];
    [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.navBar).offset(statusBarHeight / 2);
    }];
    
    // 选择按钮
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.selectButton setTitle:@"选择" forState:UIControlStateNormal];
    [self.selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"select_circle"] forState:UIControlStateNormal];
    self.selectButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    [self.navBar addSubview:self.selectButton];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.backButton);
    }];
}

#pragma mark - 主图预览
- (void)setupMainCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    self.mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.backgroundColor = [UIColor blackColor];
    self.mainCollectionView.pagingEnabled = YES;
    self.mainCollectionView.showsHorizontalScrollIndicator = NO;
    self.mainCollectionView.tag = 100;
    [self.mainCollectionView registerClass:[PreviewPhotoCell class] forCellWithReuseIdentifier:@"PreviewPhotoCell"];
    [self.view addSubview:self.mainCollectionView];
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navBar.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - 底部工具栏
- (void)setupBottomBar {
    self.bottomBar = [[UIView alloc] init];
    self.bottomBar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bottomBar];
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(60 + bottomHeight);
    }];
    
    // 删除按钮
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setTitle:@" 删除" forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.deleteButton setImage:[UIImage imageNamed:@"delete_white"] forState:UIControlStateNormal];
    self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.deleteButton.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    self.deleteButton.layer.cornerRadius = 18;
    [self.deleteButton addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBar addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(36);
    }];
    
    // 替换图片按钮
    self.replaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.replaceButton setTitle:@" 替换图片" forState:UIControlStateNormal];
    [self.replaceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.replaceButton setImage:[UIImage imageNamed:@"replace_icon"] forState:UIControlStateNormal];
    self.replaceButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.replaceButton.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    self.replaceButton.layer.cornerRadius = 18;
    [self.replaceButton addTarget:self action:@selector(replaceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBar addSubview:self.replaceButton];
    [self.replaceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.deleteButton.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.deleteButton);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(36);
    }];
    
    
}

#pragma mark - 底部预览条
- (void)setupBottomCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(55, 55);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    self.bottomCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.bottomCollectionView.delegate = self;
    self.bottomCollectionView.dataSource = self;
    self.bottomCollectionView.backgroundColor = [UIColor blackColor];
    self.bottomCollectionView.showsHorizontalScrollIndicator = NO;
    self.bottomCollectionView.tag = 200;
    [self.bottomCollectionView registerClass:[PreviewBottomCell class] forCellWithReuseIdentifier:@"PreviewBottomCell"];
    [self.view addSubview:self.bottomCollectionView];
    [self.bottomCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.bottomBar.mas_top).offset(-10);
        make.height.mas_equalTo(70);
    }];
}

- (NSInteger)itemCount {
    return self.images.count > 0 ? self.images.count : self.assets.count;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self itemCount];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 100) {
        // 主图
        PreviewPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PreviewPhotoCell" forIndexPath:indexPath];
        
        if (self.images.count > 0) {
            // UIImage 模式
            cell.imageView.image = self.images[indexPath.item];
        } else {
            // PHAsset 模式
            PHAsset *asset = self.assets[indexPath.item];
            CGFloat scale = [UIScreen mainScreen].scale;
            CGSize targetSize = CGSizeMake(kWidth * scale, kWidth * scale);
            
            [self.imageManager requestImageForAsset:asset
                                         targetSize:targetSize
                                        contentMode:PHImageContentModeAspectFit
                                            options:nil
                                      resultHandler:^(UIImage *result, NSDictionary *info) {
                cell.imageView.image = result;
            }];
        }
        
        return cell;
    } else {
        // 底部预览
        PreviewBottomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PreviewBottomCell" forIndexPath:indexPath];
        
        if (self.images.count > 0) {
            // UIImage 模式
            cell.imageView.image = self.images[indexPath.item];
        } else {
            // PHAsset 模式
            PHAsset *asset = self.assets[indexPath.item];
            CGFloat scale = [UIScreen mainScreen].scale;
            CGSize targetSize = CGSizeMake(55 * scale, 55 * scale);
            
            [self.imageManager requestImageForAsset:asset
                                         targetSize:targetSize
                                        contentMode:PHImageContentModeAspectFill
                                            options:nil
                                      resultHandler:^(UIImage *result, NSDictionary *info) {
                cell.imageView.image = result;
            }];
        }
        
        cell.indexLabel.text = [NSString stringWithFormat:@"%ld", (long)(indexPath.item + 1)];
        cell.isCurrent = (indexPath.item == self.currentIndex);
        
        WeakSelf
        cell.didDeleteBlock = ^{
            [weakSelf deleteItemAtIndex:indexPath.item];
        };
        
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 100) {
        return CGSizeMake(kWidth, collectionView.bounds.size.height);
    }
    return CGSizeMake(55, 55);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 200) {
        // 点击底部预览，滚动到对应位置
        self.currentIndex = indexPath.item;
        [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                animated:YES];
        [self updatePageLabel];
        [self.bottomCollectionView reloadData];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.mainCollectionView) {
        NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
        self.currentIndex = page;
        [self updatePageLabel];
        [self.bottomCollectionView reloadData];
    }
}

#pragma mark - Actions
- (void)backButtonClicked {
    if (self.images.count > 0) {
        if (self.didUpdateImagesBlock) {
            self.didUpdateImagesBlock(self.images);
        }
    } else {
        if (self.didUpdateBlock) {
            self.didUpdateBlock(self.assets);
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)replaceButtonClicked {
    PhotoPickerViewController *picker = [[PhotoPickerViewController alloc] init];
    picker.maxSelectCount = 1;  // 只能选择一张
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    WeakSelf
    picker.didFinishPickingBlock = ^(NSArray<UIImage *> *images, NSArray<PHAsset *> *assets) {
        if (images.count > 0) {
            if (weakSelf.images.count > 0) {
                // UIImage 模式：替换当前图片
                [weakSelf.images replaceObjectAtIndex:weakSelf.currentIndex withObject:images.firstObject];
                [weakSelf.mainCollectionView reloadData];
            } else if (assets.count > 0) {
                // PHAsset 模式：替换当前图片
                [weakSelf.assets replaceObjectAtIndex:weakSelf.currentIndex withObject:assets.firstObject];
                [weakSelf.mainCollectionView reloadData];
            }
        }
    };
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)deleteButtonClicked {
    [self deleteItemAtIndex:self.currentIndex];
}

- (void)deleteItemAtIndex:(NSInteger)index {
    if (self.images.count > 0) {
        // UIImage 模式
        if (index >= self.images.count) return;
        
        [self.images removeObjectAtIndex:index];
        
        if (self.images.count == 0) {
            if (self.didDeleteImageBlock) {
                self.didDeleteImageBlock(index);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        // 调整当前索引
        if (self.currentIndex >= self.images.count) {
            self.currentIndex = self.images.count - 1;
        }
        
        [self.mainCollectionView reloadData];
        [self.bottomCollectionView reloadData];
        [self updatePageLabel];
        
        if (self.didDeleteImageBlock) {
            self.didDeleteImageBlock(index);
        }
    } else {
        // PHAsset 模式
        if (index >= self.assets.count) return;
        
        PHAsset *asset = self.assets[index];
        [self.assets removeObjectAtIndex:index];
        
        if (self.assets.count == 0) {
            if (self.didDeleteBlock) {
                self.didDeleteBlock(asset);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        // 调整当前索引
        if (self.currentIndex >= self.assets.count) {
            self.currentIndex = self.assets.count - 1;
        }
        
        [self.mainCollectionView reloadData];
        [self.bottomCollectionView reloadData];
        [self updatePageLabel];
        
        if (self.didDeleteBlock) {
            self.didDeleteBlock(asset);
        }
    }
}

- (void)updatePageLabel {
    NSInteger count = [self itemCount];
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)(self.currentIndex + 1), (long)count];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
