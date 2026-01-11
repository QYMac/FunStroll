//
//  RelatedPhotosViewController.m
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import "RelatedPhotosViewController.h"
#import "RelatedPhotosCell.h"

@interface RelatedPhotosViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

/// 图片集合视图
@property (nonatomic, strong) UICollectionView *collectionView;

/// 图片URL数组
@property (nonatomic, strong) NSArray<NSString *> *imageUrls;

@end

@implementation RelatedPhotosViewController

- (instancetype)initWithImageUrls:(NSArray<NSString *> *)imageUrls {
    self = [super init];
    if (self) {
        _imageUrls = imageUrls ?: @[];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(242, 242, 242);
    self.navigationItem.title = @"相关照片";
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    UIImage *image = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(backButtonTapped)];
    self.navigationItem.leftBarButtonItem = backButton;
}

#pragma mark - UI Setup

- (void)setupUI {
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - 懒加载

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 6;
        layout.minimumInteritemSpacing = 6;
        layout.sectionInset = UIEdgeInsetsMake(6, 6, 6, 6);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = RGB(242, 242, 242);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[RelatedPhotosCell class] forCellWithReuseIdentifier:@"RelatedPhotosCell"];
    }
    return _collectionView;
}

#pragma mark - Actions

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RelatedPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RelatedPhotosCell" forIndexPath:indexPath];
    if (indexPath.item < self.imageUrls.count) {
        NSString *imageUrl = self.imageUrls[indexPath.item];
        [cell configureWithImageUrl:imageUrl];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 计算每个cell的大小，3列布局，左右各6，中间2个6的间距
    CGFloat screenWidth = kWidth;
    CGFloat totalPadding = 6 * 2; // 左右边距
    CGFloat totalSpacing = 6 * 2; // 中间2个间距
    CGFloat itemWidth = (screenWidth - totalPadding - totalSpacing) / 3.0;
    return CGSizeMake(itemWidth, itemWidth);
}

@end
