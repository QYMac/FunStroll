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
#import "RouteViewController.h"

@interface HomeView ()<GeneralWaterfallFlowLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) HomeHeadView *headerView;// 头部视图

@property (nonatomic,assign) NSInteger current; // 分页
@property (nonatomic,assign) NSInteger size; // 列数
@property (nonatomic,strong) NSString *keywordStr; // 关键字搜索
@property (nonatomic,strong) NSMutableArray *dataList; // 数据源

// 搜索框（放在 collectionView 上层，避免 reloadData 影响）
@property (nonatomic,strong) UITextField *homeSearcTextField;
@property (nonatomic,strong) UIButton *searchBut;
@property (nonatomic,assign) CGFloat searchFieldInitialTop; // 搜索框初始 top 值

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


- (void)setModel:(HomeListModel *)model{
    
    if (model.data.records.count > 0) {
        //停止刷新 并刷新数据
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [self.dataList addObjectsFromArray:model.data.records];
        [self.collectionView reloadData];
        if (model.data.records.count >= self.size) {
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
        self.keywordStr = [CheckTool replaceNullValue:self.homeSearcTextField.text];
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
    
    // 搜索框放在 collectionView 上层，避免 reloadData 影响
    [self setupSearchField];
}

#pragma mark - 搜索框设置
- (void)setupSearchField {
    // 搜索框
    self.homeSearcTextField.layer.cornerRadius = 35/2;
    self.homeSearcTextField.layer.masksToBounds = YES;
    self.homeSearcTextField.layer.borderColor = RGB(51, 51, 51).CGColor;
    self.homeSearcTextField.layer.borderWidth = 1;
    [self addSubview:self.homeSearcTextField];
    
    CGFloat topFloat = statusBarHeight;
    if ([DeviceInfoHelper isDynamicIsland] == YES) {
        topFloat = statusBarHeight + 10;
    }
    self.searchFieldInitialTop = topFloat; // 保存初始 top 值
    
    [self.homeSearcTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topFloat);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(35);
    }];
    
    // 搜索按钮
    [self addSubview:self.searchBut];
    [self.searchBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.homeSearcTextField);
        make.right.mas_equalTo(self.homeSearcTextField.mas_right).offset(-3);
        make.width.mas_equalTo(38);
        make.height.mas_equalTo(29);
    }];
}

#pragma mark - 搜索按钮点击
- (void)searchButClick {
    [self performSearch];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField {
    [self performSearch];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.homeSearcTextField resignFirstResponder];
    [self performSearch];
    return YES;
}

- (void)performSearch {
    self.current = 1;
    [self.dataList removeAllObjects];
    [self.collectionView.mj_footer removeFromSuperview];
    self.collectionView.mj_footer = nil;
    [self updataHomeDataListIsUpdtataTop:YES];
}

// 键盘回收
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    // 只有当点击的不是 textField 区域时才回收键盘
    if (!CGRectContainsPoint(self.homeSearcTextField.frame, point)) {
        [self.homeSearcTextField resignFirstResponder];
    }
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
    self.collectionView.mj_footer = nil;
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
        return self.headerView;
    }
    
    return nil;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommunityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    HomeListRecordModel *model = [self.dataList objectAtIndexCheck:indexPath.row];
    cell.model = model;
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if (indexPath.row == 0) {
        RouteViewController *routeVC = [[RouteViewController alloc] init];
        routeVC.startName = @"我的位置";
        routeVC.endName = @"深圳大梅沙沙滩";
        // TODO: 设置实际坐标
        // routeVC.startCoordinate = self.mapView.userLocation.coordinate;
        // routeVC.endCoordinate = CLLocationCoordinate2DMake(lat, lng);
        [[TabBarViewController takeCurrentVC].navigationController pushViewController:routeVC animated:YES];
        return;
    } else if (indexPath.row == 1) {
        MapNavigationController *vc = [[MapNavigationController alloc]init];
        [[TabBarViewController takeCurrentVC].navigationController pushViewController:vc animated:YES];
        return;
    }
     */
    
    HomeListRecordModel *model = [self.dataList objectAtIndexCheck:indexPath.row];
    HomeViewDetailsController *navc = [[HomeViewDetailsController alloc]init];
    navc.imageURL = [CheckTool replaceNullValue:model.userAvatar];
    navc.userNameText = [CheckTool replaceNullValue:model.userNickname];
    navc.postId = [CheckTool replaceNullValue:model.postId];
    [[TabBarViewController takeCurrentVC].navigationController pushViewController:navc animated:YES];
    
    WeakSelf
    // 刷新cell 详情更改收藏，首页也刷新
    navc.updateLike = ^(NSInteger likeCount, NSInteger liked) {
        model.likeCount = likeCount;
        model.liked = liked;
        CommunityCollectionViewCell *cell = [weakSelf.collectionView cellForItemAtIndexPath:indexPath];
        cell.model = model;
    };
    
}

#pragma mark - <GeneralWaterfallFlowLayoutDelegate>
- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    HomeListRecordModel *model = [self.dataList objectAtIndexCheck:indexPath.row];
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
    
    // 搜索框跟随 collectionView 滚动（使用 transform 更平滑）
    // 下拉时减速跟随（系数0.3），上滑时正常跟随
    CGFloat translateY = 0;
    if (offset_Y < 0) {
        // 下拉时，搜索框以较慢速度跟随，避免弹跳感
        translateY = -offset_Y * 0.3;
    } else {
        // 上滑时，搜索框正常跟随
        translateY = -offset_Y;
    }
    self.homeSearcTextField.transform = CGAffineTransformMakeTranslation(0, translateY);
    self.searchBut.transform = CGAffineTransformMakeTranslation(0, translateY);
    
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

- (UITextField *)homeSearcTextField {
    if (!_homeSearcTextField) {
        _homeSearcTextField = [[UITextField alloc] init];
        _homeSearcTextField.backgroundColor = [UIColor whiteColor];
        _homeSearcTextField.delegate = self;
        _homeSearcTextField.font = [UIFont systemFontOfSize:14];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入关键字" attributes:@{NSForegroundColorAttributeName:RGB(187, 187, 187),NSFontAttributeName:_homeSearcTextField.font}];
        _homeSearcTextField.attributedPlaceholder = attrString;
        _homeSearcTextField.returnKeyType = UIReturnKeySearch;
        _homeSearcTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
        _homeSearcTextField.leftViewMode = UITextFieldViewModeAlways;
        _homeSearcTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 0)];
        _homeSearcTextField.rightViewMode = UITextFieldViewModeAlways;
        [_homeSearcTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _homeSearcTextField;
}

- (UIButton *)searchBut {
    if (!_searchBut) {
        _searchBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBut setBackgroundImage:[UIImage imageNamed:@"home_search"] forState:UIControlStateNormal];
        [_searchBut addTarget:self action:@selector(searchButClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBut;
}

@end
