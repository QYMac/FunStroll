//
//  LFPhotoPreViewColletion.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/16.
//

#import "LFPhotoPreViewColletion.h"
#import "LFPhotoPreViewColletionCell.h"

@interface LFPhotoPreViewColletion ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataList;

@end

@implementation LFPhotoPreViewColletion

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.bottom.mas_equalTo(0);
        }];
        
        [self setupSystemReorder];
        
    }
    
    return self;
}

// 更简单的方法，iOS 9及以上可用
- (void)setupSystemReorder {
    // 添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleLongPressForSystemReorder:)];
    [self.collectionView addGestureRecognizer:longPress];
}

- (void)handleLongPressForSystemReorder:(UILongPressGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            if (indexPath) {
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
                [self startWiggleAnimationForCellAtIndexPath:indexPath];
            }
            break;
            
        case UIGestureRecognizerStateChanged:
            [self.collectionView updateInteractiveMovementTargetPosition:location];
            break;
            
        case UIGestureRecognizerStateEnded:
            [self.collectionView endInteractiveMovement];
            [self stopWiggleAnimationForCellAtIndexPath:indexPath];
            break;
            
        default:
            [self.collectionView cancelInteractiveMovement];
            [self stopWiggleAnimationForCellAtIndexPath:indexPath];
            break;
    }
}

// 必须实现此方法才能移动
- (void)collectionView:(UICollectionView *)collectionView
   moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath
           toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    // 更新数据源
    NSString *item = self.dataList[sourceIndexPath.item];
    [self.dataList removeObjectAtIndex:sourceIndexPath.item];
    [self.dataList insertObject:item atIndex:destinationIndexPath.item];
}

- (void)setSelectedModels:(NSMutableArray<LFAsset *> *)selectedModels{
    self.dataList = [NSMutableArray arrayWithArray:selectedModels];
    [self.collectionView reloadData];
}

#pragma mark - 抖动动画方法
- (void)startWiggleAnimationForCellAtIndexPath:(NSIndexPath *)indexPath {
    LFPhotoPreViewColletionCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if (!cell) return;
    
    // 创建左右摇摆动画
    CAKeyframeAnimation *wiggle = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    wiggle.values = @[@(-0.05), @(0.05), @(-0.05)];
    wiggle.duration = 0.2;
    wiggle.repeatCount = HUGE_VALF; // 无限重复
    [cell.layer addAnimation:wiggle forKey:@"wiggle"];
    
    // 创建缩放动画
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.values = @[@0.98, @1.0, @0.98];
    scale.duration = 0.3;
    scale.repeatCount = HUGE_VALF;
    [cell.layer addAnimation:scale forKey:@"scale"];
}

- (void)stopWiggleAnimationForCellAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if (!cell) return;
    
    [cell.layer removeAnimationForKey:@"wiggle"];
    [cell.layer removeAnimationForKey:@"scale"];
}


#pragma mark - UICollectionViewDataSource/UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}
// 左右
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

// 上下
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //LFPhotoPreViewColletionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    // 数据量多时不要使用这个方法
    NSString *reuseIdentifier = [NSString stringWithFormat:@"LFPhotoPreViewColletionCell+%ld+%ld", (long)indexPath.section, (long)indexPath.row];
    [collectionView registerClass:[LFPhotoPreViewColletionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    LFPhotoPreViewColletionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell setSelectedModels:self.dataList indexPathdex:indexPath];
    
    return cell;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100,80);
    
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);//上左下右
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        //[_collectionView registerClass:[LFPhotoPreViewColletionCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

@end
