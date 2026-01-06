//
//  CommunityViewController.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/25.
//

#import "CommunityViewController.h"
#import "CommunityCollectionViewCell.h"
#import "HomeViewDetailsController.h"
#import "AddCommentController.h"
#import "AFNetworkingManage+Home.h"
#import "HomeModel.h"

@interface CommunityViewController ()<GeneralWaterfallFlowLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *communityCollectionView;
@property (nonatomic,strong) NSString *currentStr; // 分页
@property (nonatomic,strong) NSString *sizeStr; // 列数
@property (nonatomic,strong) NSString *keywordStr; // 关键字搜索
@property (nonatomic,strong) HomeModel *homeModel; // 列表数据

@end

@implementation CommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentStr = @"1";
    self.sizeStr = @"10";
    self.keywordStr = @"";
    
    [self AFNetworkingHomePage]; // 获取列表数据
    [self setupCollectioView];
}

// 获取首页列表数据
- (void)AFNetworkingHomePage{
    [AFNetworkingManage homeListCurrent:self.currentStr size:self.sizeStr keyword:self.keywordStr success:^(id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        [FMDBManager saveHomeList:[CheckTool replaceNullWithDictionary:responseObject] andHandle:^(BOOL isSuccess) {
            
        }];
        self.homeModel = [HomeModel yy_modelWithDictionary:responseObject];
        NSLog(@"pages===%@",self.homeModel.pages);
    } failureHandler:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)setupCollectioView
{
    [self.view addSubview:self.communityCollectionView];
    [self.communityCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(32+25); // 32 是搜索框的高度 + 25 是上间距
    }];
    
    // 刷新数据
    [self cartoonContentRefresh];
    //[self MJRefreshFooter];
}

#pragma mark 刷新控件
- (void)cartoonContentRefresh{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    [header setTitle:@"正在请求数据 ..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    // 设置颜色
    //header.stateLabel.textColor = YRGB;
    //header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    //马上进入刷新状态
    //[header beginRefreshing];
    // 设置刷新控件
    self.communityCollectionView.mj_header = header;
}

- (void)MJRefreshFooter{
    // 上拉刷新
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //停止下拉刷新
        [self.communityCollectionView.mj_header endRefreshing];
        [self.communityCollectionView.mj_footer endRefreshing];
    }];
    [footer setTitle:@"已经到底了" forState:MJRefreshStateNoMoreData];
    self.communityCollectionView.mj_footer = footer;

}

// 下拉加载更多数据
- (void)loadMoreData
{
    //停止下拉刷新
    [self.communityCollectionView.mj_header endRefreshing];
    [self.communityCollectionView.mj_footer endRefreshing];
}


#pragma mark - <UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommunityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        cell.homeImage.image = [UIImage imageNamed:@"home1"];
        cell.avatarImage.image = [UIImage imageNamed:@"homeTX1"];
        cell.titleText = @"高德地图测试";
    } else if (indexPath.row == 1) {
        cell.homeImage.image = [UIImage imageNamed:@"home2"];
        cell.avatarImage.image = [UIImage imageNamed:@"homeTX2"];
        cell.titleText = @"自定义选择照片测试";
    } else if (indexPath.row == 2) {
        cell.homeImage.image = [UIImage imageNamed:@"home3"];
        cell.avatarImage.image = [UIImage imageNamed:@"homeTX3"];
        cell.titleText = @"三文鱼牛油果双拼寿司，软糯鱼肉撞着绵密牛油果......";
    } else if (indexPath.row == 3) {
        cell.homeImage.image = [UIImage imageNamed:@"home4"];
        cell.avatarImage.image = [UIImage imageNamed:@"homeTX4"];
        cell.titleText = @"掰开温热的巧克力流心包，浓醇酱体顺着松软组织......";
    } else if (indexPath.row == 4) {
        cell.homeImage.image = [UIImage imageNamed:@"home5"];
        cell.avatarImage.image = [UIImage imageNamed:@"homeTX1"];
        cell.titleText = @"三文鱼牛油果双拼寿司，软糯鱼肉撞着绵密牛油果......";
    } else {
        cell.homeImage.image = [UIImage imageNamed:@"home5"];
        cell.avatarImage.image = [UIImage imageNamed:@"homeTX1"];
        cell.titleText = @"三文鱼牛油果双拼寿司，软糯鱼肉撞着绵密牛油果......";
    }
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    HomeViewDetailsController *navc = [[HomeViewDetailsController alloc]init];
    navc.titleText = @"社区详情";
    [self.navigationController pushViewController:navc animated:YES];
     */
    
    if (indexPath.row == 0) {
        MapNavigationController *vc = [[MapNavigationController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        AddCommentController *navc = [[AddCommentController alloc]init];
        [self.navigationController pushViewController:navc animated:YES];
    } else {
        HomeViewDetailsController *navc = [[HomeViewDetailsController alloc]init];
        navc.titleText = @"社区详情";
        [self.navigationController pushViewController:navc animated:YES];
    }
    
}

#pragma mark - <GeneralWaterfallFlowLayoutDelegate>
- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    if (indexPath.row == 1) {
        return 230;
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
    return UIEdgeInsetsMake(10, 10, tabBarHeight + 50, 10);
}


#pragma  mark - 懒加载
- (UICollectionView *)communityCollectionView {
    if (!_communityCollectionView) {
        GeneralWaterfallFlowLayout *layout = [[GeneralWaterfallFlowLayout alloc] init];
        _communityCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _communityCollectionView.delegate = self;
        _communityCollectionView.dataSource = self;
        //_communityCollectionView.scrollEnabled = NO;//禁止cell滑动
        _communityCollectionView.showsVerticalScrollIndicator = NO;
        _communityCollectionView.showsHorizontalScrollIndicator = NO;
        [_communityCollectionView registerClass:[CommunityCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _communityCollectionView.backgroundColor = RGB(231, 231, 231);
    }
    return _communityCollectionView;
}

@end
