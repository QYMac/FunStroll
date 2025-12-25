//
//  DeliciousFoodViewController.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/25.
//

#import "DeliciousFoodViewController.h"
#import "CommunityCollectionViewCell.h"
#import "HomeViewDetailsController.h"


@interface DeliciousFoodViewController ()<GeneralWaterfallFlowLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource,AMapSearchDelegate>

@property (nonatomic,strong) UICollectionView *deliciousFoodCollectionView;

@property (nonatomic, strong) NSMutableArray *allPOIs; // 存储所有POI
@property (nonatomic, assign) NSInteger currentPage;    // 当前页码
@property (nonatomic, assign) NSInteger totalCount;     // 总结果数
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) AMapPOIAroundSearchRequest *request;

@end

@implementation DeliciousFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupCollectioView];
    //[self searchPoiByCenterCoordinate];
}

- (void)setupCollectioView
{
    [self.view addSubview:self.deliciousFoodCollectionView];
    [self.deliciousFoodCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(32+25);
    }];
    // 刷新数据
    [self cartoonContentRefresh];
    [self MJRefreshFooter];
}

#pragma mark 刷新控件
- (void)cartoonContentRefresh{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    [header setTitle:@"正在请求数据 ..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    // 设置颜色
    //header.stateLabel.textColor = YRGB;
    //header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    // 马上进入刷新状态
    [header beginRefreshing];
    // 设置刷新控件
    self.deliciousFoodCollectionView.mj_header = header;
}

- (void)MJRefreshFooter{
    // 上拉刷新
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //停止下拉刷新
        //[self.communityCollectionView.mj_header endRefreshing];
        //[self.communityCollectionView.mj_footer endRefreshing];
        self.currentPage++;
        [self searchPOIWithRequest:self.request];
    }];
    [footer setTitle:@"已经到底了" forState:MJRefreshStateNoMoreData];
    self.deliciousFoodCollectionView.mj_footer = footer;
}

// 下拉加载更多数据
- (void)loadMoreData
{
    self.allPOIs = [NSMutableArray array];
    [self searchPoiByCenterCoordinate];
    //停止刷新
    //[self.deliciousFoodCollectionView.mj_header endRefreshing];
    //[self.deliciousFoodCollectionView.mj_footer endRefreshing];
}

#pragma mark - Utility

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiByCenterCoordinate
{
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    self.request = [[AMapPOIAroundSearchRequest alloc] init];
    
    self.request.location            = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
    self.request.keywords            = @"景区";
    /* 按照距离排序. */
    self.request.sortrule            = 0;
    //self.request.offset = 25;
    self.request.showFieldsType      = AMapPOISearchShowFieldsTypeAll;
    self.request.radius = 50000;
    //self.request.city = @"441900";
    [self searchAllPOIsWithRequest:self.request];
}

- (void)searchAllPOIsWithRequest:(AMapPOIAroundSearchRequest *)request {
    self.currentPage = 1;
    // 先搜索第一页
    request.page = 1;
    [self searchPOIWithRequest:request];
}

- (void)searchPOIWithRequest:(AMapPOIAroundSearchRequest *)request {
    request.page = self.currentPage;
    request.offset = 25; // 每页最大25条
    
    [self.search AMapPOIAroundSearch:request];
}

#pragma mark - AMapSearchDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count > 0) {
        [self.allPOIs addObjectsFromArray:response.pois];
        [self.deliciousFoodCollectionView reloadData];
        // 停止刷新
        [self.deliciousFoodCollectionView.mj_header endRefreshing];
        [self.deliciousFoodCollectionView.mj_footer endRefreshing];
        //self.currentPage++;
        //[self searchPOIWithRequest:(AMapPOIAroundSearchRequest *)request];
    } else {
        // 所有结果获取完成
        NSLog(@"获取到全部 %ld 个POI", (long)self.allPOIs.count);
        //  停止刷新
        [self.deliciousFoodCollectionView.mj_header endRefreshing];
        [self.deliciousFoodCollectionView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - <UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allPOIs.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommunityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    /*
    if (indexPath.row == 1) {
        cell.homeImage.image = [UIImage imageNamed:@"home1"];
        cell.avatarImage.image = [UIImage imageNamed:@"homeTX1"];
        cell.titleText = @"体验老北京的大街小巷，感受北京的人文风情......";
    } else if (indexPath.row == 0) {
        cell.homeImage.image = [UIImage imageNamed:@"home2"];
        cell.avatarImage.image = [UIImage imageNamed:@"homeTX2"];
        cell.titleText = @"东莞两日游行程规划";
    } else if (indexPath.row == 4) {
        cell.homeImage.image = [UIImage imageNamed:@"home3"];
        cell.avatarImage.image = [UIImage imageNamed:@"homeTX3"];
        cell.titleText = @"三文鱼牛油果双拼寿司，软糯鱼肉撞着绵密牛油果......";
    } else if (indexPath.row == 2) {
        cell.homeImage.image = [UIImage imageNamed:@"home4"];
        cell.avatarImage.image = [UIImage imageNamed:@"homeTX4"];
        cell.titleText = @"掰开温热的巧克力流心包，浓醇酱体顺着松软组织......";
    } else if (indexPath.row == 3) {
        cell.homeImage.image = [UIImage imageNamed:@"home5"];
        cell.avatarImage.image = [UIImage imageNamed:@"homeTX1"];
        cell.titleText = @"三文鱼牛油果双拼寿司，软糯鱼肉撞着绵密牛油果......";
    } else {
        cell.homeImage.image = [UIImage imageNamed:@"home5"];
        cell.avatarImage.image = [UIImage imageNamed:@"homeTX1"];
        cell.titleText = @"三文鱼牛油果双拼寿司，软糯鱼肉撞着绵密牛油果......";
    }
     */
    
    AMapPOI *model = [self.allPOIs objectAtIndexCheck:indexPath.row];
    cell.titleText = [CheckTool replaceNullValue:model.name];
    AMapImage *imageModel = [model.images objectAtIndexCheck:0];
    [cell.homeImage sd_setImageWithURL:[NSURL URLWithString:[CheckTool replaceNullValue:imageModel.url]] placeholderImage:[UIImage imageNamed:@""]];
    cell.nameL.text = [CheckTool replaceNullValue:model.address];
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeViewDetailsController *navc = [[HomeViewDetailsController alloc]init];
    navc.titleText = @"美食详情";
    [self.navigationController pushViewController:navc animated:YES];
}

#pragma mark - <GeneralWaterfallFlowLayoutDelegate>
- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    if (indexPath.row == 1) {
        return 300;
    } else {
        return 300;
    }
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
    return 10;
}
/**
 *  行间距, 默认10
 */
- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}

/**
 *  距离collectionView四周的间距, 默认{20, 10, 10, 10}
 */
- (UIEdgeInsets)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView
{
    
    return UIEdgeInsetsMake(10, 10, tabBarHeight + 10, 10);
}


#pragma  mark - 懒加载
- (UICollectionView *)deliciousFoodCollectionView {
    if (!_deliciousFoodCollectionView) {
        GeneralWaterfallFlowLayout *layout = [[GeneralWaterfallFlowLayout alloc] init];
        _deliciousFoodCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _deliciousFoodCollectionView.delegate = self;
        _deliciousFoodCollectionView.dataSource = self;
        //_deliciousFoodCollectionView.scrollEnabled = NO;//禁止cell滑动
        _deliciousFoodCollectionView.showsVerticalScrollIndicator = NO;
        _deliciousFoodCollectionView.showsHorizontalScrollIndicator = NO;
        [_deliciousFoodCollectionView registerClass:[CommunityCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _deliciousFoodCollectionView.backgroundColor = RGB(231, 231, 231);
    }
    return _deliciousFoodCollectionView;
}

@end
