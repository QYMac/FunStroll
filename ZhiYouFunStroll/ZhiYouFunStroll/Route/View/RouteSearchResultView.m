//
//  RouteSearchResultView.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/14.
//

#import "RouteSearchResultView.h"
#import "GeneralWaterfallFlowLayout.h"
#import "NearbyRecommendCell.h"

@interface RouteSearchResultView () <UICollectionViewDelegate, UICollectionViewDataSource, GeneralWaterfallFlowLayoutDelegate>

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *currentSearchText;

@end

@implementation RouteSearchResultView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setupMockData];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = RGB(250, 250, 250);
    
    // 提示标签
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    self.tipLabel.textColor = RGB(153, 153, 153);
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    // 设置富文本
    [self updateTipLabel];
    
    // 搜索结果 CollectionView - 瀑布流
    GeneralWaterfallFlowLayout *layout = [GeneralWaterfallFlowLayout flowLayoutWithDelegate:self];
    layout.headerHeight = 0;
    layout.searcHeight = 0;
    layout.headerLabelHeight = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = RGB(250, 250, 250);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[NearbyRecommendCell class] forCellWithReuseIdentifier:@"SearchResultCell"];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)updateTipLabel {
    NSString *fullText = @"以下为当前屏幕结果，可切换到您的附近查找~";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:fullText];
    
    // 设置整体颜色
    [attrStr addAttribute:NSForegroundColorAttributeName value:RGB(153, 153, 153) range:NSMakeRange(0, fullText.length)];
    
    // 设置"您的附近"为绿色并添加下划线
    NSRange greenRange = [fullText rangeOfString:@"您的附近"];
    if (greenRange.location != NSNotFound) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:RGB(58, 175, 6) range:greenRange];
        [attrStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:greenRange];
        [attrStr addAttribute:NSUnderlineColorAttributeName value:RGB(58, 175, 6) range:greenRange];
    }
    
    self.tipLabel.attributedText = attrStr;
    
    // 添加点击手势
    self.tipLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nearbyTipTapped)];
    [self.tipLabel addGestureRecognizer:tap];
}

- (void)setupMockData {
    // 模拟搜索结果数据
    self.searchResultList = @[
        @{@"image": @"", @"title": @"青甘大环线7天极限攻坚路线保证完美", @"distance": @"200m", @"walkTime": @"步行约20分钟"},
        @{@"image": @"", @"title": @"青甘大环线7天极限攻坚路线保证完美", @"distance": @"200m", @"walkTime": @"步行约20分钟"},
        @{@"image": @"", @"title": @"青甘大环线7天极限攻坚路线保证完美", @"distance": @"200m", @"walkTime": @"步行约20分钟"},
        @{@"image": @"", @"title": @"青甘大环线7天极限攻坚路线保证完美", @"distance": @"200m", @"walkTime": @"步行约20分钟"}
    ];
}

#pragma mark - Public Methods
- (void)searchWithText:(NSString *)text {
    self.currentSearchText = text;
    // TODO: 根据 text 进行搜索并更新 searchResultList
    [self.collectionView reloadData];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - Actions
- (void)nearbyTipTapped {
    if ([self.delegate respondsToSelector:@selector(searchResultViewDidTapNearby:)]) {
        [self.delegate searchResultViewDidTapNearby:self];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.searchResultList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NearbyRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    NSDictionary *data = self.searchResultList[indexPath.item];
    [cell configWithData:data];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.searchResultList.count) {
        NSDictionary *data = self.searchResultList[indexPath.item];
        if ([self.delegate respondsToSelector:@selector(searchResultView:didSelectResult:)]) {
            [self.delegate searchResultView:self didSelectResult:data];
        }
    }
}

#pragma mark - GeneralWaterfallFlowLayoutDelegate
- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth {
    // 图片高度 + 标题区域 + 距离区域
    CGFloat imageHeight = itemWidth * 1.2;
    CGFloat titleHeight = 40;
    CGFloat distanceHeight = 25;
    return imageHeight + 10 + titleHeight + 8 + distanceHeight;
}

- (NSInteger)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout columnsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout columnsMarginInCollectionView:(UICollectionView *)collectionView {
    return 5;
}

- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 5;
}

- (UIEdgeInsets)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView {
    return UIEdgeInsetsMake(0, 5, bottomHeight, 5);
}

@end
