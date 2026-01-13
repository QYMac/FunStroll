//
//  HomeView.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/29.
//

#import "HomeView.h"
#import "CommunityCollectionViewCell.h"
#import "HomeHeadView.h"
#import "HomeViewDetailsController.h"
#import "AddCommentController.h"

@interface HomeView ()<GeneralWaterfallFlowLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) HomeHeadView *headerView;// 头部视图

@property (nonatomic,assign) NSInteger current; // 分页
@property (nonatomic,assign) NSInteger size; // 列数
@property (nonatomic,strong) NSString *keywordStr; // 关键字搜索
@property (nonatomic,strong) NSMutableArray *dataList; // 数据源

@end

@implementation HomeView

#pragma mark -- 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
        self.backgroundColor = RGB(244, 244, 244);
        
        self.current = 1;
        self.size = 20;
        self.keywordStr = @"";
        [self setupHomeControllerView];
    }
    
    return self;
}


- (void)setHomeModel:(HomeModel *)homeModel{
    
    if (homeModel.records.count > 0) {
        //停止刷新 并刷新数据
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [self.dataList addObjectsFromArray:homeModel.records];
        [self.collectionView reloadData];
        if (homeModel.records.count >= self.size) {
            [self MJRefreshFooter];
        }
    } else {
        //停止刷新
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)updataHomeDataListIsUpdtataTop:(BOOL)isUpdtataTop{
    if (self.updateHomeDataListBlcok) {
        self.keywordStr = [CheckTool replaceNullValue:self.headerView.homeSearcTextField.text];
        self.updateHomeDataListBlcok(self.current, self.size, self.keywordStr,isUpdtataTop);
    }
}

- (void)setupHomeControllerView{
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.bottom.mas_equalTo(0);
    }];
    [self cartoonContentRefresh];
    
}

#pragma mark 刷新控件
- (void)cartoonContentRefresh{
    
    if (self.collectionView.mj_header) {
        return;
    }
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    [header setTitle:@"正在请求数据 ..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    // 设置颜色
    //header.stateLabel.textColor = RGB;
    //header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    //马上进入刷新状态
    //[header beginRefreshing];
    // 设置刷新控件
    self.collectionView.mj_header = header;
}

- (void)MJRefreshFooter{
    
    if (self.collectionView.mj_footer) {
        return;
    }
    
    // 上拉刷新
    WeakSelf
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.current += 1;
        [weakSelf updataHomeDataListIsUpdtataTop:NO];
    }];
    [footer setTitle:@"已经到底了" forState:MJRefreshStateNoMoreData];
    self.collectionView.mj_footer = footer;

}

// 下拉重新加载数据
- (void)loadMoreData
{
    self.current = 1;
    [self.dataList removeAllObjects];
    [self.collectionView.mj_footer removeFromSuperview];
    [self updataHomeDataListIsUpdtataTop:YES];
}

#pragma mark - <UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
        WeakSelf
        [self.headerView setSearcDataListBlcok:^(NSString * _Nonnull keywordStr, BOOL isSearcDome) {
            if (isSearcDome == YES) {
                weakSelf.current = 1;
                [weakSelf.dataList removeAllObjects];
                [weakSelf.collectionView.mj_footer removeFromSuperview];
                [weakSelf updataHomeDataListIsUpdtataTop:YES];
            }
        }];
        return self.headerView;
    }
    
    return nil;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommunityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dict = [self.dataList objectAtIndexCheck:indexPath.row];
    HomeModel *model = [HomeModel yy_modelWithDictionary:dict];
    cell.model = model;
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        AddCommentController *navc = [[AddCommentController alloc]init];
        [[TabBarViewController takeCurrentVC].navigationController pushViewController:navc animated:YES];
        return;
    }
    
    NSDictionary *dict = [self.dataList objectAtIndexCheck:indexPath.row];
    HomeModel *model = [HomeModel yy_modelWithDictionary:dict];
    HomeViewDetailsController *navc = [[HomeViewDetailsController alloc]init];
    navc.imageURL = [CheckTool replaceNullValue:model.userAvatar];
    navc.userNameText = [CheckTool replaceNullValue:model.userNickname];
    navc.postId = [CheckTool replaceNullValue:model.postId];
    [[TabBarViewController takeCurrentVC].navigationController pushViewController:navc animated:YES];
    
}

#pragma mark - <GeneralWaterfallFlowLayoutDelegate>
- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    NSDictionary *dict = [self.dataList objectAtIndexCheck:indexPath.row];
    HomeModel *model = [HomeModel yy_modelWithDictionary:dict];
    NSString *titleText = [CheckTool replaceNullValue:model.title];
    NSInteger num = [LabelSpacing needLinesWithWidth:itemWidth textStr:titleText font:14];
    if (num >= 2) {
        num = 2;
    }
    
    CGFloat imageHeight = itemWidth * 1.2;
    
    return imageHeight + 55 + num * 15;
}

/**
 *  需要显示的列数, 默认3
 */
- (NSInteger)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout columnsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
/**
 *  列间距, 默认10
 */
- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout columnsMarginInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}
/**
 *  行间距, 默认10
 */
- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return 5;
}

/**
 *  距离collectionView四周的间距, 默认{20, 10, 10, 10}
 */
- (UIEdgeInsets)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(0, 5, 10, 5);
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset_Y = scrollView.contentOffset.y;
    CGFloat searcHeight = 270 - statusBarHeight - 44;
    if ([DeviceInfoHelper isDynamicIsland] == YES) {
        searcHeight = 270 - (statusBarHeight + 10 + 44);
    }
    CGFloat alpha = 1 - MAX(0, offset_Y/searcHeight);
    self.headerView.bgImg.alpha = alpha;
    /*
    if (offset_Y > scrollView.contentSize.height - (kHeight - navBarHeight)) {
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-tabBarHeight);
        }];
    } else {
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
    }
    */
}


#pragma mark - 懒加载
- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        GeneralWaterfallFlowLayout *layout = [[GeneralWaterfallFlowLayout alloc] init];
        layout.headerHeight = 270; //  headerHeight
        layout.searcHeight = statusBarHeight;
        if ([DeviceInfoHelper isDynamicIsland] == YES) {
            layout.searcHeight = statusBarHeight + 10;
        }
        layout.headerLabelHeight = 44; // 社区广场标签的高度
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        // 禁用垂直方向回弹
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.alwaysBounceHorizontal = NO;
        [_collectionView registerClass:[CommunityCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[HomeHeadView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"Header"];
        _collectionView.backgroundColor = RGB(244, 244, 244);
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _collectionView;
}

@end
