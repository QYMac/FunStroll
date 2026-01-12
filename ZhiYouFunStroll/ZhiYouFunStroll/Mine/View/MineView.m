//
//  MineView.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/11.
//

#import "MineView.h"
#import "MineHeaderView.h"
#import "MineTabBarView.h"
#import "MineNoteCell.h"
#import "MineDraftCell.h"

static NSString *const kMineNoteCellIdentifier = @"MineNoteCell";
static NSString *const kMineDraftCellIdentifier = @"MineDraftCell";
static NSString *const kMineHeaderIdentifier = @"MineHeader";

@interface MineView () <UICollectionViewDelegate, UICollectionViewDataSource, GeneralWaterfallFlowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MineHeaderView *headerView;
@property (nonatomic, strong) MineTabBarView *tabBarView;

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) NSInteger current;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) MineTabType currentTabType;
@property (nonatomic, assign) NSInteger draftCount;
@property (nonatomic, assign) NSInteger abnormalCount;
@property (nonatomic, assign) BOOL showDraft;  // 是否显示草稿Cell

@end

@implementation MineView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(244, 244, 244);
        self.current = 1;
        self.size = 20;
        self.currentTabType = MineTabTypeNotes;
        self.draftCount = 1;
        self.abnormalCount = 1;
        self.showDraft = YES;
        [self setupUI];
        [self setupRefresh];
    }
    return self;
}

#pragma mark - Setup UI
- (void)setupUI {
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)setupRefresh {
    // 下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    [header setTitle:@"正在请求数据 ..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    self.collectionView.mj_header = header;
}

- (void)setupFooterRefresh {
    if (self.collectionView.mj_footer) {
        return;
    }
    
    WeakSelf
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.current += 1;
        if (weakSelf.loadMoreDataBlock) {
            weakSelf.loadMoreDataBlock(weakSelf.current, weakSelf.size, weakSelf.currentTabType);
        }
    }];
    [footer setTitle:@"已经到底了" forState:MJRefreshStateNoMoreData];
    self.collectionView.mj_footer = footer;
}

#pragma mark - Data Loading
- (void)loadNewData {
    self.current = 1;
    [self.dataList removeAllObjects];
    [self.collectionView.mj_footer removeFromSuperview];
    
    if (self.loadMoreDataBlock) {
        self.loadMoreDataBlock(self.current, self.size, self.currentTabType);
    }
}

- (void)refreshData {
    [self loadNewData];
}

#pragma mark - Public Methods
- (void)updateUserInfoWithName:(NSString *)name
                        userId:(NSString *)userId
                           bio:(NSString *)bio
                     avatarUrl:(NSString *)avatarUrl {
    [self.headerView updateWithUserName:name userId:userId bio:bio avatarUrl:avatarUrl];
}

- (void)updateNotesWithDataList:(NSArray *)dataList hasMore:(BOOL)hasMore {
    [self.collectionView.mj_header endRefreshing];
    
    if (dataList.count > 0) {
        [self.dataList addObjectsFromArray:dataList];
        [self.collectionView reloadData];
        
        if (hasMore) {
            [self setupFooterRefresh];
            [self.collectionView.mj_footer endRefreshing];
        } else {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    } else {
        [self.collectionView reloadData];
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)setDraftCount:(NSInteger)count {
    _draftCount = count;
    self.showDraft = (count > 0);
    [self.collectionView reloadData];
}

- (void)setAbnormalNoteCount:(NSInteger)count {
    _abnormalCount = count;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 如果显示草稿，则第一个位置是草稿Cell
    NSInteger draftCellCount = self.showDraft ? 1 : 0;
    return self.dataList.count + draftCellCount;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MineHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                    withReuseIdentifier:kMineHeaderIdentifier
                                                                           forIndexPath:indexPath];
        self.headerView = header;
        
        // 设置警告信息
        if (self.abnormalCount > 0) {
            NSString *alertMsg = [NSString stringWithFormat:@"%ld条笔记发布异常", (long)self.abnormalCount];
            [header setAlertMessage:alertMsg hidden:NO];
        } else {
            [header setAlertMessage:@"" hidden:YES];
        }
        
        WeakSelf
        header.settingButtonClickBlock = ^{
            if (weakSelf.settingClickBlock) {
                weakSelf.settingClickBlock();
            }
        };
        
        header.avatarClickBlock = ^{
            if (weakSelf.avatarClickBlock) {
                weakSelf.avatarClickBlock();
            }
        };
        
        header.editBioClickBlock = ^{
            if (weakSelf.editBioClickBlock) {
                weakSelf.editBioClickBlock();
            }
        };
        
        header.tabChangedBlock = ^(MineTabType tabType) {
            weakSelf.currentTabType = tabType;
            weakSelf.current = 1;
            [weakSelf.dataList removeAllObjects];
            [weakSelf.collectionView.mj_footer removeFromSuperview];
            
            // 只在笔记Tab显示草稿
            weakSelf.showDraft = (tabType == MineTabTypeNotes && weakSelf.draftCount > 0);
            [weakSelf.collectionView reloadData];
            
            if (weakSelf.tabChangedBlock) {
                weakSelf.tabChangedBlock(tabType);
            }
            
            if (weakSelf.loadMoreDataBlock) {
                weakSelf.loadMoreDataBlock(weakSelf.current, weakSelf.size, tabType);
            }
        };
        
        header.alertBannerClickBlock = ^{
            if (weakSelf.alertBannerClickBlock) {
                weakSelf.alertBannerClickBlock();
            }
        };
        
        return header;
    }
    
    return [[UICollectionReusableView alloc] init];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 如果显示草稿且是第一个Cell
    if (self.showDraft && indexPath.item == 0) {
        MineDraftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMineDraftCellIdentifier forIndexPath:indexPath];
        // 使用第一条数据的封面作为草稿背景
        UIImage *bgImage = nil;
        if (self.dataList.count > 0) {
            NSDictionary *dict = [self.dataList objectAtIndexCheck:0];
            NSString *coverUrl = [CheckTool replaceNullValue:dict[@"coverImage"]];
            if (coverUrl.length > 0) {
                // 异步加载背景图
                [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:coverUrl] placeholderImage:nil];
            }
        }
        [cell configureDraftCount:self.draftCount backgroundImage:bgImage];
        return cell;
    }
    
    // 普通笔记Cell
    MineNoteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMineNoteCellIdentifier forIndexPath:indexPath];
    
    NSInteger dataIndex = self.showDraft ? indexPath.item - 1 : indexPath.item;
    if (dataIndex < self.dataList.count) {
        NSDictionary *dict = [self.dataList objectAtIndexCheck:dataIndex];
        
        NSString *coverUrl = [CheckTool replaceNullValue:dict[@"coverImage"]];
        NSString *title = [CheckTool replaceNullValue:dict[@"title"]];
        NSString *avatarUrl = [CheckTool replaceNullValue:dict[@"userAvatar"]];
        NSString *nickname = [CheckTool replaceNullValue:dict[@"userNickname"]];
        NSInteger likeCount = [dict[@"likeCount"] integerValue];
        BOOL isLiked = [dict[@"liked"] boolValue];
        
        [cell configureWithCoverUrl:coverUrl
                              title:title
                          avatarUrl:avatarUrl
                           nickname:nickname
                          likeCount:likeCount
                            isLiked:isLiked];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 点击草稿Cell
    if (self.showDraft && indexPath.item == 0) {
        if (self.draftClickBlock) {
            self.draftClickBlock();
        }
        return;
    }
    
    // 点击笔记Cell
    NSInteger dataIndex = self.showDraft ? indexPath.item - 1 : indexPath.item;
    if (self.noteClickBlock) {
        self.noteClickBlock(dataIndex);
    }
}

#pragma mark - GeneralWaterfallFlowLayoutDelegate
- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout
            collectionView:(UICollectionView *)collectionView
  heightForItemAtIndexPath:(NSIndexPath *)indexPath
                 itemWidth:(CGFloat)itemWidth {
    
    // 草稿Cell
    if (self.showDraft && indexPath.item == 0) {
        return 90;  // 草稿Cell高度
    }
    
    // 普通笔记Cell
    NSInteger dataIndex = self.showDraft ? indexPath.item - 1 : indexPath.item;
    if (dataIndex < self.dataList.count) {
        NSDictionary *dict = [self.dataList objectAtIndexCheck:dataIndex];
        NSString *titleText = [CheckTool replaceNullValue:dict[@"title"]];
        NSInteger num = [LabelSpacing needLinesWithWidth:itemWidth - 20 textStr:titleText font:14];
        if (num >= 2) {
            num = 2;
        }
        // 图片高度 + 标题 + 用户信息区域
        return itemWidth + 50 + num * 18;
    }
    
    return itemWidth + 70;
}

- (NSInteger)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout
      columnsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout
columnsMarginInCollectionView:(UICollectionView *)collectionView {
    return 5;
}

- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout
            collectionView:(UICollectionView *)collectionView
linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 5;
}

- (UIEdgeInsets)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout
       edgeInsetsInCollectionView:(UICollectionView *)collectionView {
    return UIEdgeInsetsMake(0, 5, 10, 5);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset_Y = scrollView.contentOffset.y;
    CGFloat headerHeight = 290;  // 背景高度320 + 一些偏移
    CGFloat alpha = MAX(0, offset_Y / headerHeight);
    self.headerView.bgView.alpha = alpha;
}

#pragma mark - Lazy Loading
- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        GeneralWaterfallFlowLayout *layout = [[GeneralWaterfallFlowLayout alloc] init];
        
        // 计算header高度: 背景(320) + TabBar(49) + AlertBanner(55)
        CGFloat headerHeight = 290 + 49 + 45;
        layout.headerHeight = headerHeight;
        layout.searcHeight = statusBarHeight +  49 + 45;
        if ([DeviceInfoHelper isDynamicIsland] == YES) {
            layout.searcHeight = statusBarHeight +  49 + 45 + 10;
        }
        layout.headerLabelHeight = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = RGB(250, 250, 250);
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
        // 注册Cell和Header
        [_collectionView registerClass:[MineNoteCell class] forCellWithReuseIdentifier:kMineNoteCellIdentifier];
        [_collectionView registerClass:[MineDraftCell class] forCellWithReuseIdentifier:kMineDraftCellIdentifier];
        [_collectionView registerClass:[MineHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:kMineHeaderIdentifier];
    }
    return _collectionView;
}

- (MineTabBarView *)tabBarView {
    if (!_tabBarView) {
        _tabBarView = [[MineTabBarView alloc] init];
        WeakSelf
        _tabBarView.tabChangedBlock = ^(MineTabType tabType) {
            weakSelf.currentTabType = tabType;
            weakSelf.current = 1;
            [weakSelf.dataList removeAllObjects];
            [weakSelf.collectionView.mj_footer removeFromSuperview];
            
            // 只在笔记Tab显示草稿
            weakSelf.showDraft = (tabType == MineTabTypeNotes && weakSelf.draftCount > 0);
            
            if (weakSelf.tabChangedBlock) {
                weakSelf.tabChangedBlock(tabType);
            }
            
            if (weakSelf.loadMoreDataBlock) {
                weakSelf.loadMoreDataBlock(weakSelf.current, weakSelf.size, tabType);
            }
        };
    }
    return _tabBarView;
}



@end
