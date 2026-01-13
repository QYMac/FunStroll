//
//  SelectedPhotoBar.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import "SelectedPhotoBar.h"

@interface SelectedPhotoBarCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, copy) void(^didDeleteBlock)(void);

@end

@implementation SelectedPhotoBarCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 图片
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 6;
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    // 序号
    self.indexLabel = [[UILabel alloc] init];
    self.indexLabel.font = [UIFont boldSystemFontOfSize:10];
    self.indexLabel.textColor = [UIColor whiteColor];
    self.indexLabel.backgroundColor = [UIColor colorWithRed:50/255.0 green:48/255.0 blue:48/255.0 alpha:0.6];
    self.indexLabel.textAlignment = NSTextAlignmentCenter;
    self.indexLabel.layer.cornerRadius = 6;
    self.indexLabel.layer.masksToBounds = YES;
    [self.imageView addSubview:self.indexLabel];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(-2.5);
        make.width.height.mas_equalTo(18);
    }];
    
    // 删除按钮 - 扩大点击区域到 44x44
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setImage:[UIImage imageNamed:@"shanchutp"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteClicked) forControlEvents:UIControlEventTouchUpInside];
    // 设置图片内边距，让图标保持在右上角的位置
    self.deleteButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.contentView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-15);
        make.right.mas_equalTo(15);
        make.width.height.mas_equalTo(30);
    }];
}

- (void)deleteClicked {
    if (self.didDeleteBlock) {
        self.didDeleteBlock();
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}

@end

#pragma mark - SelectedPhotoBar

@interface SelectedPhotoBar () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *assets;

@end

@implementation SelectedPhotoBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.assets = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(55, 55);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(5, 15, 5, 15);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[SelectedPhotoBarCell class] forCellWithReuseIdentifier:@"SelectedPhotoBarCell"];
    
    // 添加长按手势用于拖拽排序
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.3;
    [self.collectionView addGestureRecognizer:longPress];
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)updateWithAssets:(NSArray<PHAsset *> *)assets {
    self.assets = [assets mutableCopy];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectedPhotoBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectedPhotoBarCell" forIndexPath:indexPath];
    
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
    
    cell.indexLabel.text = [NSString stringWithFormat:@"%ld", (long)(indexPath.item + 1)];
    
    WeakSelf
    cell.didDeleteBlock = ^{
        if (weakSelf.didDeleteBlock) {
            weakSelf.didDeleteBlock(asset);
        }
    };
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = self.assets[indexPath.item];
    if (self.didSelectBlock) {
        self.didSelectBlock(asset, indexPath.item);
    }
}

#pragma mark - 拖拽排序
- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.collectionView];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
            if (indexPath) {
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self.collectionView updateInteractiveMovementTargetPosition:point];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self.collectionView endInteractiveMovement];
            if (self.didReorderBlock) {
                self.didReorderBlock(self.assets);
            }
            break;
        }
        default: {
            [self.collectionView cancelInteractiveMovement];
            break;
        }
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    PHAsset *asset = self.assets[sourceIndexPath.item];
    [self.assets removeObjectAtIndex:sourceIndexPath.item];
    [self.assets insertObject:asset atIndex:destinationIndexPath.item];
    
    // 刷新序号
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

@end
