//
//  RouteViewController.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import "RouteViewController.h"
#import "RouteHeaderView.h"
#import "RouteWaypointView.h"
#import "RouteOptionCell.h"
#import "NearbyRecommendCell.h"
#import "AMapNavigationManager.h"
#import "MapAddressView.h"
#import "GeneralWaterfallFlowLayout.h"
#import "RouteCategorySearchView.h"
#import "RouteSearchResultView.h"
#import "MapLocationDetailView.h"
#import "RouteLocationCardView.h"

@interface RouteViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate, GeneralWaterfallFlowLayoutDelegate, RouteHeaderViewDelegate, RouteCategorySearchViewDelegate, RouteSearchResultViewDelegate, MapLocationDetailViewDelegate, RouteLocationCardViewDelegate>

// 顶部固定区域
@property (nonatomic, strong) UIView *topFixedView;
@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) RouteHeaderView *headerView;
@property (nonatomic, strong) UIView *travelModeView;
@property (nonatomic, strong) NSArray *travelModeButtons;
@property (nonatomic, assign) NSInteger selectedTravelMode;

// 地图区域
@property (nonatomic, strong) UIView *mapContainer;

// 可滑动区域（路线选项 + 终点附近）
@property (nonatomic, strong) UIScrollView *slidableScrollView;
@property (nonatomic, strong) UIView *slidableContentView;
@property (nonatomic, strong) UIView *routeOptionsView;
@property (nonatomic, strong) UICollectionView *routeOptionsCollectionView;
@property (nonatomic, strong) NSArray *routeOptions;
@property (nonatomic, assign) NSInteger selectedRouteIndex;

// 终点附近
@property (nonatomic, strong) UIView *nearbyView;
@property (nonatomic, strong) UIScrollView *nearbyTagScrollView;
@property (nonatomic, strong) NSArray *nearbyTags;
@property (nonatomic, assign) NSInteger selectedNearbyTag;
@property (nonatomic, strong) UICollectionView *nearbyCollectionView;
@property (nonatomic, strong) NSArray *nearbyRecommends;

// 途经点编辑视图
@property (nonatomic, strong) RouteWaypointView *waypointView;
@property (nonatomic, assign) BOOL isWaypointExpanded;

// 底部按钮
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIButton *addToTripButton;
@property (nonatomic, strong) UIButton *startNaviButton;

// 滑动相关
@property (nonatomic, assign) CGFloat topFixedHeight;    // 顶部固定区域高度
@property (nonatomic, assign) CGFloat mapHeight;         // 地图高度
@property (nonatomic, assign) CGFloat minSlidableTop;    // 可滑动区域最小 top（上滑最高位置）
@property (nonatomic, assign) CGFloat maxSlidableTop;    // 可滑动区域最大 top（初始位置）
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

/// 地图视图
@property (nonatomic, strong) MapAddressView *mapView;

/// 刷新按钮
@property (nonatomic, strong) UIButton *refreshButton;

/// 分类搜索视图
@property (nonatomic, strong) RouteCategorySearchView *categorySearchView;
/// 当前编辑的输入类型
@property (nonatomic, assign) RouteInputType currentEditingType;

/// 搜索结果视图
@property (nonatomic, strong) RouteSearchResultView *searchResultView;
/// 搜索结果视图初始位置（地图底部）
@property (nonatomic, assign) CGFloat searchResultInitialTop;
/// 搜索结果视图最小位置（topFixedView底部）
@property (nonatomic, assign) CGFloat searchResultMinTop;
/// 搜索结果拖拽手势
@property (nonatomic, strong) UIPanGestureRecognizer *searchResultPanGesture;

/// 地点详情视图
@property (nonatomic, strong) MapLocationDetailView *locationDetailView;
/// 当前选中的地点数据
@property (nonatomic, strong) NSDictionary *currentLocationData;

/// 搜索结果定位按钮
@property (nonatomic, strong) UIButton *searchLocationButton;

/// 简化地点卡片视图（用于 waypointView 模式）
@property (nonatomic, strong) RouteLocationCardView *locationCardView;

@end

@implementation RouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectedTravelMode = 0;
    self.selectedRouteIndex = 0;
    self.selectedNearbyTag = 0;
    self.isWaypointExpanded = NO;
    self.waypoints = [NSMutableArray array];
    
    // 计算高度
    self.topFixedHeight = statusBarHeight + 44 + 70 + 10 + 10; // navBar + header + spacing + travelMode + spacing
    self.mapHeight = 220;
    self.minSlidableTop = self.topFixedHeight;
    self.maxSlidableTop = self.topFixedHeight + self.mapHeight - 30; // 初始位置，路线选项卡片覆盖地图底部30
    
    // 模拟数据
    [self setupMockData];
    
    [self setupUI];
    [self loadRoutes];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.fd_prefersNavigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - 模拟数据
- (void)setupMockData {
    if (self.startName.length == 0) {
        self.startName = @"我的位置";
    }
    if (self.endName.length == 0) {
        self.endName = @"深圳大梅沙沙滩";
    }
    
    // 模拟路线选项
    self.routeOptions = @[
        @{@"tag": @"大众常选", @"time": @"31", @"distance": @"19"},
        @{@"tag": @"大众常选", @"time": @"33", @"distance": @"22"},
        @{@"tag": @"大众常选", @"time": @"36", @"distance": @"23"}
    ];
    
    // 终点附近标签
    self.nearbyTags = @[@"停车场", @"酒店", @"美食", @"景点"];
    
    // 模拟附近推荐
    self.nearbyRecommends = @[
        @{@"image": @"", @"title": @"青甘大环线7天极限攻坚路线保证完美", @"distance": @"200m", @"walkTime": @"步行约20分钟"},
        @{@"image": @"", @"title": @"青甘大环线7天极限攻坚路线保证完美", @"distance": @"200m", @"walkTime": @"步行约20分钟"}
    ];
}

#pragma mark - UI Setup
- (void)setupUI {
    // 顶部固定区域（先创建，因为地图依赖它的约束）
    [self setupTopFixedView];
    
    // 地图区域（放在最底层）
    [self setupMapContainer];
    [self.view sendSubviewToBack:self.mapContainer];
    
    // 可滑动区域（路线选项 + 终点附近）
    [self setupSlidableView];
    
    // 刷新按钮（需要在 slidableScrollView 之后创建）
    [self setupRefreshButton];
    
    // 底部按钮
    [self setupBottomBar];
    
    // 途经点编辑视图（初始隐藏）
    [self setupWaypointView];
}

- (void)setupRefreshButton {
    self.refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.refreshButton setImage:[UIImage imageNamed:@"route_refresh"] forState:UIControlStateNormal];
    [self.refreshButton addTarget:self action:@selector(refreshButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.refreshButton];
    // 固定在初始位置，不随滑动移动
    CGFloat fixedTop = self.maxSlidableTop - 5 - 44;
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(fixedTop);
        make.width.height.mas_equalTo(44);
    }];
}

- (void)setupTopFixedView {
    // 浅蓝色渐变背景
    self.topFixedView = [[UIView alloc] init];
    self.topFixedView.backgroundColor = [UIColor whiteColor];
    // 底部阴影
    self.topFixedView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.topFixedView.layer.shadowOffset = CGSizeMake(0, 2);
    self.topFixedView.layer.shadowOpacity = 0.1;
    self.topFixedView.layer.shadowRadius = 2;
    self.topFixedView.layer.masksToBounds = NO;
    [self.view addSubview:self.topFixedView];
    [self.topFixedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.topFixedHeight);
    }];
    
    // 导航栏
    self.navBar = [[UIView alloc] init];
    self.navBar.backgroundColor = [UIColor whiteColor];
    [self.topFixedView addSubview:self.navBar];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(statusBarHeight + 44);
    }];
    
    // 返回按钮 - 使用 < 样式
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-10);
        make.width.height.mas_equalTo(24);
    }];
    
    // 起点终点区域
    self.headerView = [[RouteHeaderView alloc] init];
    self.headerView.delegate = self;
    self.headerView.startName = self.startName;
    self.headerView.endName = self.endName;
    [self.topFixedView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backButton.mas_top);
        make.left.mas_equalTo(self.backButton.mas_right).offset(10);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(70); // 2 rows * 35 per row
    }];
    
    WeakSelf
    self.headerView.waypointButtonBlock = ^{
        [weakSelf toggleWaypointView];
    };
    
    self.headerView.routeEditButtonBlock = ^{
        [weakSelf toggleWaypointView];
    };
    
    // 高度变化回调
    self.headerView.heightDidChangeBlock = ^(CGFloat newHeight) {
        [weakSelf.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(newHeight);
        }];
        
        // 更新 topFixedView 高度
        CGFloat newTopFixedHeight = statusBarHeight + 44 + newHeight + 10 + 10;
        [weakSelf.topFixedView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(newTopFixedHeight);
        }];
        weakSelf.topFixedHeight = newTopFixedHeight;
        weakSelf.minSlidableTop = newTopFixedHeight;
        weakSelf.maxSlidableTop = newTopFixedHeight + weakSelf.mapHeight - 30;
        
        // 更新 slidableScrollView 位置
        [weakSelf.slidableScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.maxSlidableTop);
        }];
        
        // 更新 refreshButton 位置
        [weakSelf.refreshButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.maxSlidableTop - 5 - 44);
        }];
        
        [weakSelf.view layoutIfNeeded];
    };
    
    // 出行方式 Tab
    self.travelModeView = [[UIView alloc] init];
    self.travelModeView.backgroundColor = [UIColor clearColor];
    [self.topFixedView addSubview:self.travelModeView];
    [self.travelModeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(5);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(36);
    }];
    
    NSArray *modes = @[@"驾车", @"摩托", @"骑行", @"步行"];
    NSArray *icons = @[@"route_car", @"route_bike", @"route_moto", @"route_walk"];
    NSMutableArray *buttons = [NSMutableArray array];
    
    CGFloat buttonWidth = 70;
    CGFloat spacing = 20;
    
    for (NSInteger i = 0; i < modes.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:modes[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:icons[i]] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
        button.layer.cornerRadius = 25/2;
        [button addTarget:self action:@selector(travelModeClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            button.backgroundColor = RGB(145, 233, 80);
            [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        } else {
            button.backgroundColor = [UIColor clearColor];
            [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        }
        
        [self.travelModeView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i * (buttonWidth + spacing));
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(buttonWidth);
            make.height.mas_equalTo(25);
        }];
        
        [buttons addObject:button];
    }
    
    self.travelModeButtons = buttons;
}

- (void)setupMapContainer {
    self.mapContainer = [[UIView alloc] init];
    self.mapContainer.backgroundColor = RGB(230, 235, 240);
    [self.view addSubview:self.mapContainer];
    // mapContainer 底部延伸到 nearbyView 的 top + 20
    // nearbyView 相对于 slidableScrollView 的 top = routeOptionsView.height + 15 = 95
    // 计算：mapHeight + (95 + 20 - 30) = mapHeight + 85
    CGFloat mapExtendHeight = self.mapHeight + 85;
    [self.mapContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topFixedView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(mapExtendHeight);
    }];
    
    
    // 添加地图视图
    [self.mapContainer addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
}

- (void)setupSlidableView {
    // 可滑动的容器
    self.slidableScrollView = [[UIScrollView alloc] init];
    self.slidableScrollView.backgroundColor = [UIColor clearColor];
    self.slidableScrollView.showsVerticalScrollIndicator = NO;
    self.slidableScrollView.delegate = self;
    self.slidableScrollView.bounces = NO;
    [self.view addSubview:self.slidableScrollView];
    [self.slidableScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.maxSlidableTop);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-(60 + bottomHeight));
    }];
    
    // 添加拖拽手势
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panGesture.delegate = self;
    [self.slidableScrollView addGestureRecognizer:self.panGesture];
    
    // 内容容器
    self.slidableContentView = [[UIView alloc] init];
    self.slidableContentView.backgroundColor = [UIColor clearColor];
    [self.slidableScrollView addSubview:self.slidableContentView];
    [self.slidableContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(kWidth);
    }];
    
    // 路线选项卡片
    [self setupRouteOptionsView];
    
    // 终点附近
    [self setupNearbyView];
}

- (void)setupRouteOptionsView {
    self.routeOptionsView = [[UIView alloc] init];
    self.routeOptionsView.backgroundColor = [UIColor whiteColor];
    self.routeOptionsView.layer.cornerRadius = 12;
    self.routeOptionsView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.routeOptionsView.layer.shadowOffset = CGSizeMake(0, 2);
    self.routeOptionsView.layer.shadowOpacity = 0.1;
    self.routeOptionsView.layer.shadowRadius = 8;
    [self.slidableContentView addSubview:self.routeOptionsView];
    [self.routeOptionsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(80);
    }];
    
    // 路线选项 CollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    self.routeOptionsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.routeOptionsCollectionView.delegate = self;
    self.routeOptionsCollectionView.dataSource = self;
    self.routeOptionsCollectionView.backgroundColor = [UIColor clearColor];
    self.routeOptionsCollectionView.showsHorizontalScrollIndicator = NO;
    [self.routeOptionsCollectionView registerClass:[RouteOptionCell class] forCellWithReuseIdentifier:@"RouteOptionCell"];
    [self.routeOptionsView addSubview:self.routeOptionsCollectionView];
    [self.routeOptionsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setupNearbyView {
    self.nearbyView = [[UIView alloc] init];
    self.nearbyView.backgroundColor = [UIColor whiteColor];
    // 顶部圆角
    self.nearbyView.layer.cornerRadius = 10;
    self.nearbyView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    self.nearbyView.layer.masksToBounds = YES;
    [self.slidableContentView addSubview:self.nearbyView];
    [self.nearbyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.routeOptionsView.mas_bottom).offset(15);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        // 给一个最小高度确保内容可见
        make.height.mas_greaterThanOrEqualTo(400);
    }];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"终点附近";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor blackColor];
    [self.nearbyView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
    }];
    
    // 标签按钮
    self.nearbyTagScrollView = [[UIScrollView alloc] init];
    self.nearbyTagScrollView.showsHorizontalScrollIndicator = NO;
    [self.nearbyView addSubview:self.nearbyTagScrollView];
    [self.nearbyTagScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(32);
    }];
    
    CGFloat tagX = 0;
    for (NSInteger i = 0; i < self.nearbyTags.count; i++) {
        UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tagButton.tag = i;
        [tagButton setTitle:self.nearbyTags[i] forState:UIControlStateNormal];
        tagButton.titleLabel.font = [UIFont systemFontOfSize:11];
        tagButton.layer.cornerRadius = 25/2;
        [tagButton addTarget:self action:@selector(nearbyTagClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            tagButton.backgroundColor = RGB(228, 255, 209);
            [tagButton setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        } else {
            tagButton.backgroundColor = RGB(238, 238, 238);
            [tagButton setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
        }
        
        CGFloat width = [self.nearbyTags[i] sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}].width + 30;
        tagButton.frame = CGRectMake(tagX, 0, width, 25);
        [self.nearbyTagScrollView addSubview:tagButton];
        
        tagX += width + 10;
    }
    self.nearbyTagScrollView.contentSize = CGSizeMake(tagX, 25);
    
    // 附近推荐 CollectionView - 使用瀑布流布局
    GeneralWaterfallFlowLayout *nearbyLayout = [GeneralWaterfallFlowLayout flowLayoutWithDelegate:self];
    nearbyLayout.headerHeight = 0;
    nearbyLayout.searcHeight = 0;
    nearbyLayout.headerLabelHeight = 0;
    
    self.nearbyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:nearbyLayout];
    self.nearbyCollectionView.delegate = self;
    self.nearbyCollectionView.dataSource = self;
    self.nearbyCollectionView.backgroundColor = [UIColor clearColor];
    self.nearbyCollectionView.showsVerticalScrollIndicator = NO;
    self.nearbyCollectionView.alwaysBounceVertical = YES;
    self.nearbyCollectionView.scrollEnabled = NO; // 初始不可滑动，需要容器到顶部才能滑动
    self.nearbyCollectionView.tag = 200;
    [self.nearbyCollectionView registerClass:[NearbyRecommendCell class] forCellWithReuseIdentifier:@"NearbyRecommendCell"];
    [self.nearbyView addSubview:self.nearbyCollectionView];
    [self.nearbyCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nearbyTagScrollView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-15);
    }];
}

- (void)setupBottomBar {
    self.bottomBar = [[UIView alloc] init];
    self.bottomBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomBar];
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(60 + bottomHeight);
    }];
    
    // 加入行程按钮
    self.addToTripButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addToTripButton setTitle:@"加入行程" forState:UIControlStateNormal];
    [self.addToTripButton setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    [self.addToTripButton setImage:[UIImage imageNamed:@"route_add_trip"] forState:UIControlStateNormal];
    self.addToTripButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.addToTripButton addTarget:self action:@selector(addToTripClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.addToTripButton setImagePositionWithType:SSImagePositionTypeTop spacing:5];
    [self.bottomBar addSubview:self.addToTripButton];
    [self.addToTripButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(5);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(50);
    }];
    
    // 立即导航按钮
    self.startNaviButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.startNaviButton setTitle:@"立即导航" forState:UIControlStateNormal];
    [self.startNaviButton setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    self.startNaviButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.startNaviButton.backgroundColor = RGB(145, 233, 80);
    self.startNaviButton.layer.cornerRadius = 22;
    [self.startNaviButton addTarget:self action:@selector(startNaviClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBar addSubview:self.startNaviButton];
    [self.startNaviButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.addToTripButton.mas_right).offset(10);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(8);
        make.height.mas_equalTo(44);
    }];
}

- (void)setupWaypointView {
    self.waypointView = [[RouteWaypointView alloc] init];
    self.waypointView.hidden = YES;
    self.waypointView.alpha = 0;
    [self.view addSubview:self.waypointView];
    [self.waypointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backButton.mas_top).offset(0);
        make.left.right.mas_equalTo(0);
    }];
    
    WeakSelf
    self.waypointView.closeBlock = ^{
        [weakSelf hideWaypointView];
    };
    
    self.waypointView.doneBlock = ^(NSArray *waypoints) {
        weakSelf.waypoints = [waypoints mutableCopy];
        // 更新 headerView 显示途径点数据
        [weakSelf.headerView updateWithWaypoints:waypoints];
        [weakSelf hideWaypointView];
        [weakSelf loadRoutes];
    };
    
    // 途经点输入框开始编辑时，显示分类页
    self.waypointView.inputDidBeginEditingBlock = ^{
        [weakSelf showCategorySearchView];
    };
    
    // 途经点输入框点击键盘返回时，显示搜索结果页
    self.waypointView.inputDidTapReturnBlock = ^(NSString *text) {
        [weakSelf showSearchResultViewWithText:text];
    };
}

#pragma mark - 拖拽手势处理
- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.view];
    CGPoint velocity = [gesture velocityInView:self.view];
    
    static CGFloat startTop = 0;
    
    // 计算当前的最小 top（上滑最高位置）
    CGFloat currentMinTop = self.minSlidableTop;
    if (self.isWaypointExpanded) {
        // 当 waypointView 显示时，最小 top 为 waypointView.bottom + 10
        currentMinTop = CGRectGetMaxY(self.waypointView.frame) + 10;
    }
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            startTop = self.slidableScrollView.frame.origin.y;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat newTop = startTop + translation.y;
            // 限制范围
            newTop = MAX(currentMinTop, MIN(self.maxSlidableTop, newTop));
            
            [self.slidableScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(newTop);
            }];
            [self.view layoutIfNeeded];
            
            // 上滑立刻隐藏刷新按钮
            if (newTop < self.maxSlidableTop) {
                self.refreshButton.hidden = YES;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            CGFloat currentTop = self.slidableScrollView.frame.origin.y;
            CGFloat middlePoint = (currentMinTop + self.maxSlidableTop) / 2;
            
            // 根据速度和位置决定最终位置
            CGFloat targetTop;
            if (velocity.y > 500) {
                // 快速下滑，回到底部
                targetTop = self.maxSlidableTop;
            } else if (velocity.y < -500) {
                // 快速上滑，到顶部
                targetTop = currentMinTop;
            } else {
                // 根据当前位置决定
                targetTop = (currentTop < middlePoint) ? currentMinTop : self.maxSlidableTop;
            }
            
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.slidableScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(targetTop);
                }];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                // 下滑完成后显示刷新按钮
                if (targetTop == self.maxSlidableTop) {
                    self.refreshButton.hidden = NO;
                    // 容器在底部，禁用 nearbyCollectionView 滚动
                    self.nearbyCollectionView.scrollEnabled = NO;
                } else {
                    // 容器在顶部，启用 nearbyCollectionView 滚动
                    self.nearbyCollectionView.scrollEnabled = YES;
                }
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - 路线加载
- (void)loadRoutes {
    // TODO: 调用高德地图 API 加载路线
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 200) {
        return self.nearbyRecommends.count;
    }
    return self.routeOptions.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 200) {
        NearbyRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NearbyRecommendCell" forIndexPath:indexPath];
        NSDictionary *data = self.nearbyRecommends[indexPath.item];
        [cell configWithData:data];
        return cell;
    }
    
    RouteOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RouteOptionCell" forIndexPath:indexPath];
    NSDictionary *data = self.routeOptions[indexPath.item];
    BOOL isSelected = (indexPath.item == self.selectedRouteIndex);
    [cell configWithData:data isSelected:isSelected];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 200) {
        // 瀑布流由代理方法控制大小
        return CGSizeZero;
    }
    return CGSizeMake((kWidth - 20) / 3, 80);
}

#pragma mark - GeneralWaterfallFlowLayoutDelegate
- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth {
    // 图片高度 + 标题区域 + 距离区域
    // 封面图比例约为 1:0.8
    CGFloat imageHeight = itemWidth * 1.2;
    CGFloat titleHeight = 40; // 两行标题
    CGFloat distanceHeight = 25; // 距离信息
    return imageHeight + 10 + titleHeight + 8 + distanceHeight;
}

- (NSInteger)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout columnsInCollectionView:(UICollectionView *)collectionView {
    return 2; // 2列
}

- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout columnsMarginInCollectionView:(UICollectionView *)collectionView {
    return 5; // 列间距
}

- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 5; // 行间距
}

- (UIEdgeInsets)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView {
    return UIEdgeInsetsMake(0, 5, 10, 5);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 200) {
        // 点击附近推荐
        return;
    }
    
    self.selectedRouteIndex = indexPath.item;
    [collectionView reloadData];
}

#pragma mark - Actions
- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)travelModeClicked:(UIButton *)sender {
    if (sender.tag == self.selectedTravelMode) return;
    
    // 重置所有按钮样式
    for (UIButton *button in self.travelModeButtons) {
        button.backgroundColor = [UIColor clearColor];
        [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    }
    
    // 设置选中样式
    sender.backgroundColor = RGB(145, 233, 80);
    //[sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.selectedTravelMode = sender.tag;
    [self loadRoutes];
}

- (void)nearbyTagClicked:(UIButton *)sender {
    if (sender.tag == self.selectedNearbyTag) return;
    
    // 重置所有标签样式
    for (UIView *subview in self.nearbyTagScrollView.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.backgroundColor = RGB(238, 238, 238);
            [button setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
        }
    }

    // 设置选中样式
    sender.backgroundColor = RGB(228, 255, 209);
    [sender setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    
    self.selectedNearbyTag = sender.tag;
    // TODO: 加载对应分类的推荐
}

- (void)toggleWaypointView {
    if (self.isWaypointExpanded) {
        [self hideWaypointView];
    } else {
        [self showWaypointView];
    }
}

- (void)showWaypointView {
    self.isWaypointExpanded = YES;
    self.waypointView.hidden = NO;
    
    // 隐藏搜索定位按钮，避免遮挡
    self.searchLocationButton.hidden = YES;
    
    // 设置数据
    [self.waypointView setStartName:self.startName endName:self.endName waypoints:self.waypoints];
    
    // 调整视图层级：waypointView 在地图上面，slidableScrollView 和 refreshButton 在 waypointView 上面
    [self.view bringSubviewToFront:self.waypointView];
    [self.view bringSubviewToFront:self.slidableScrollView];
    [self.view bringSubviewToFront:self.refreshButton];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.waypointView.alpha = 1;
    }];
}

- (void)hideWaypointView {
    self.isWaypointExpanded = NO;
    
    // 隐藏分类页、搜索结果页和地点卡片
    self.categorySearchView.hidden = YES;
    self.searchResultView.hidden = YES;
    self.locationCardView.hidden = YES;
    
    // 显示地图和其他视图
    self.mapContainer.hidden = NO;
    self.slidableScrollView.hidden = NO;
    self.bottomBar.hidden = NO;
    self.refreshButton.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.waypointView.alpha = 0;
    } completion:^(BOOL finished) {
        self.waypointView.hidden = YES;
    }];
}

- (void)addToTripClicked {
    // TODO: 加入行程
    [AlertWith showAlertWithMessageText:@"已加入行程"];
}

- (void)startNaviClicked {
    // TODO: 开始导航
}

- (void)refreshButtonClicked {
    // 刷新路线
    [self loadRoutes];
}

#pragma mark - RouteHeaderViewDelegate
- (void)headerView:(RouteHeaderView *)headerView didBeginEditingWithType:(RouteInputType)type atIndex:(NSInteger)index {
    self.currentEditingType = type;
    
    // 点击输入框时始终显示分类页
    [self showCategorySearchView];
}

- (void)headerView:(RouteHeaderView *)headerView didEndEditingWithType:(RouteInputType)type atIndex:(NSInteger)index {
    // 可以在这里处理结束编辑的逻辑
}

- (void)headerView:(RouteHeaderView *)headerView didChangeText:(NSString *)text withType:(RouteInputType)type atIndex:(NSInteger)index {
    // 更新数据
    if (type == RouteInputTypeStart) {
        self.startName = text;
    } else if (type == RouteInputTypeEnd) {
        self.endName = text;
    }
    // 途经点的文字变化在 headerView 内部已经处理
    
    // 文字变化时不自动切换视图，保持当前显示的页面
}

- (void)headerView:(RouteHeaderView *)headerView didTapReturnWithType:(RouteInputType)type atIndex:(NSInteger)index {
    // 点击键盘完成/搜索按钮时显示搜索结果页
    NSString *text = @"";
    if (type == RouteInputTypeStart) {
        text = headerView.startTextField.text;
    } else if (type == RouteInputTypeEnd) {
        text = headerView.endTextField.text;
    }
    
    if (text.length > 0) {
        [self showSearchResultViewWithText:text];
    }
}

#pragma mark - RouteCategorySearchViewDelegate
- (void)categorySearchView:(RouteCategorySearchView *)view didSelectCategory:(NSDictionary *)category {
    // 隐藏键盘
    [self.headerView endEditing];
    [self.waypointView endEditing:YES];
    
    NSString *title = category[@"title"];
    
    // 判断是在编辑 waypointView 的输入框还是 headerView 的输入框
    if (self.isWaypointExpanded) {
        // 更新 waypointView 的输入框
        [self.waypointView updateCurrentEditingText:title];
    } else {
        // 更新 headerView 的输入框
        if (self.currentEditingType == RouteInputTypeStart) {
            self.headerView.startTextField.text = title;
            self.startName = title;
        } else {
            self.headerView.endTextField.text = title;
            self.endName = title;
        }
    }
    
    // 显示搜索结果视图
    [self showSearchResultViewWithText:title];
}

- (void)categorySearchView:(RouteCategorySearchView *)view didSelectHistoryItem:(NSString *)historyItem {
    // 隐藏键盘
    [self.headerView endEditing];
    [self.waypointView endEditing:YES];
    
    // 判断是在编辑 waypointView 的输入框还是 headerView 的输入框
    if (self.isWaypointExpanded) {
        // 更新 waypointView 的输入框
        [self.waypointView updateCurrentEditingText:historyItem];
    } else {
        // 更新 headerView 的输入框
        if (self.currentEditingType == RouteInputTypeStart) {
            self.headerView.startTextField.text = historyItem;
            self.startName = historyItem;
        } else {
            self.headerView.endTextField.text = historyItem;
            self.endName = historyItem;
        }
    }
    
    // 显示搜索结果视图
    [self showSearchResultViewWithText:historyItem];
}

- (void)categorySearchViewDidClearHistory:(RouteCategorySearchView *)view {
    // 历史记录已清除
}

#pragma mark - RouteSearchResultViewDelegate
- (void)searchResultView:(RouteSearchResultView *)view didSelectResult:(NSDictionary *)result {
    // 隐藏键盘
    [self.headerView endEditing];
    [self.waypointView endEditing:YES];
    
    // 判断是在 waypointView 模式还是普通模式
    if (self.isWaypointExpanded) {
        // waypointView 模式：显示简化地点卡片
        [self showLocationCardViewWithData:result];
    } else {
        // 普通模式：显示地点详情视图
        [self showLocationDetailViewWithData:result];
    }
}

- (void)searchResultViewDidTapNearby:(RouteSearchResultView *)view {
    // 切换到附近搜索
    NSLog(@"切换到附近搜索");
}

#pragma mark - 简化地点卡片视图（waypointView 模式）
- (void)showLocationCardViewWithData:(NSDictionary *)data {
    // 存储当前数据
    self.currentLocationData = data;
    
    // 隐藏搜索结果视图和分类视图
    self.searchResultView.hidden = YES;
    self.categorySearchView.hidden = YES;
    
    if (!self.locationCardView) {
        self.locationCardView = [[RouteLocationCardView alloc] init];
        self.locationCardView.delegate = self;
        self.locationCardView.hidden = YES;
        [self.view addSubview:self.locationCardView];
    }
    
    // 设置约束：底部固定
    [self.view insertSubview:self.locationCardView belowSubview:self.waypointView];
    [self.locationCardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(120 + bottomHeight);
    }];
    
    // 配置数据
    NSString *imageUrl = data[@"image"] ?: @"";
    NSString *title = data[@"title"] ?: @"深圳大梅沙阳光沙滩";
    NSString *address = data[@"address"] ?: @"广东省深圳市";
    NSString *distance = data[@"distance"] ?: @"距离200m";
    
    [self.locationCardView configureWithImageUrl:imageUrl
                                           title:title
                                         address:address
                                        distance:distance];
    
    // 显示卡片
    self.locationCardView.hidden = NO;
    
    // 显示地图、路线选项卡和刷新按钮
    self.mapContainer.hidden = NO;
    self.slidableScrollView.hidden = NO;
    self.refreshButton.hidden = NO;
    
    // 调整地图底部约束到 locationCardView 的 top + 10
    [self.mapContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topFixedView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.locationCardView.mas_top).offset(20);
    }];
    
    // 调整 slidableScrollView 约束
    [self.slidableScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.locationCardView.mas_top).offset(-90);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
    
    // 调整刷新按钮约束
    [self.refreshButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(self.slidableScrollView.mas_top).offset(-10);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    [self.view layoutIfNeeded];
}

- (void)hideLocationCardView {
    self.locationCardView.hidden = YES;
    // 重新显示搜索结果视图
    self.searchResultView.hidden = NO;
    
    // 恢复地图约束
    [self.mapContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topFixedView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.mapHeight + 85);
    }];
    
    // 恢复 slidableScrollView 约束
    [self.slidableScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.maxSlidableTop);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    // 恢复刷新按钮约束
    [self.refreshButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.maxSlidableTop - 45);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    [self.view layoutIfNeeded];
}

#pragma mark - RouteLocationCardViewDelegate
- (void)locationCardViewDidTapClose:(RouteLocationCardView *)cardView {
    [self hideLocationCardView];
}

- (void)locationCardViewDidTap:(RouteLocationCardView *)cardView {
    // 点击卡片，选择该地点
    NSString *title = self.currentLocationData[@"title"] ?: @"";
    
    // 更新 waypointView 的输入框
    [self.waypointView updateCurrentEditingText:title];
    
    /*
    // 隐藏卡片并恢复约束
    [self hideLocationCardView];
    
    // 隐藏搜索视图
    self.searchResultView.hidden = YES;
    self.categorySearchView.hidden = YES;
     */
}

#pragma mark - MapLocationDetailViewDelegate
- (void)mapLocationDetailViewDidTapClose:(MapLocationDetailView *)detailView {
    [self hideLocationDetailView];
}

- (void)mapLocationDetailViewDidTapShare:(MapLocationDetailView *)detailView {
    // 分享
    [AlertWith showAlertWithMessageText:@"分享功能开发中"];
}

- (void)mapLocationDetailViewDidTapFavorite:(MapLocationDetailView *)detailView {
    // 收藏
    [AlertWith showAlertWithMessageText:@"已收藏"];
}

- (void)mapLocationDetailViewDidTapRoute:(MapLocationDetailView *)detailView {
    // 查看路线 - 填充到输入框并关闭详情
    NSString *title = self.currentLocationData[@"title"] ?: @"深圳大梅沙阳光沙滩";
    
    if (self.currentEditingType == RouteInputTypeStart) {
        self.headerView.startTextField.text = title;
        self.startName = title;
    } else {
        self.headerView.endTextField.text = title;
        self.endName = title;
    }
    
    [self hideLocationDetailView];
    [self hideSearchResultView];
    [self hideCategorySearchView];
}

- (void)mapLocationDetailViewDidTapNavigate:(MapLocationDetailView *)detailView {
    // 立即导航
    [AlertWith showAlertWithMessageText:@"即将开始导航"];
}

#pragma mark - 分类搜索视图
- (void)showCategorySearchView {
    // 隐藏搜索结果视图和定位按钮
    self.searchResultView.hidden = YES;
    self.searchLocationButton.hidden = YES;
    
    if (!self.categorySearchView) {
        self.categorySearchView = [[RouteCategorySearchView alloc] init];
        self.categorySearchView.delegate = self;
        self.categorySearchView.hidden = YES;
    }
    
    // 根据 waypointView 是否显示来设置层级和约束
    if (self.isWaypointExpanded) {
        // waypointView 模式：分类页在 waypointView 下面（不遮挡阴影）
        [self.view insertSubview:self.categorySearchView belowSubview:self.waypointView];
        [self.categorySearchView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.waypointView.mas_bottom);
            make.left.right.bottom.mas_equalTo(0);
        }];
    } else {
        // 普通模式：分类页在最底层
        [self.view insertSubview:self.categorySearchView atIndex:0];
        [self.categorySearchView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topFixedView.mas_bottom);
            make.left.right.bottom.mas_equalTo(0);
        }];
    }
    
    self.categorySearchView.hidden = NO;
    [self.categorySearchView show];
    
    // 隐藏其他视图
    self.mapContainer.hidden = YES;
    self.slidableScrollView.hidden = YES;
    self.bottomBar.hidden = YES;
    self.refreshButton.hidden = YES;
}

- (void)hideCategorySearchView {
    [self.categorySearchView hide];
    [self.headerView endEditing];
    
    // 如果搜索结果视图没有显示，才显示其他视图
    if (self.searchResultView.hidden || !self.searchResultView) {
        self.mapContainer.hidden = NO;
        self.slidableScrollView.hidden = NO;
        self.bottomBar.hidden = NO;
        self.refreshButton.hidden = NO;
    }
}

#pragma mark - 搜索结果视图
- (void)showSearchResultViewWithText:(NSString *)text {
    // 隐藏分类搜索视图
    self.categorySearchView.hidden = YES;
    
    if (!self.searchResultView) {
        self.searchResultView = [[RouteSearchResultView alloc] init];
        self.searchResultView.delegate = self;
        
        // 添加拖拽手势
        self.searchResultPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSearchResultPan:)];
        [self.searchResultView addGestureRecognizer:self.searchResultPanGesture];
        
        // 添加顶部圆角
        self.searchResultView.layer.cornerRadius = 10;
        self.searchResultView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
        self.searchResultView.layer.masksToBounds = YES;
    }
    
    // 根据 waypointView 是否显示来设置层级和约束
    if (self.isWaypointExpanded) {
        // waypointView 模式：搜索结果在 waypointView 下面（不遮挡阴影）
        [self.view insertSubview:self.searchResultView belowSubview:self.waypointView];
        [self.searchResultView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.waypointView.mas_bottom);
            make.left.right.bottom.mas_equalTo(0);
        }];
        // 禁用拖拽手势
        self.searchResultPanGesture.enabled = NO;
        // 隐藏搜索定位按钮
        self.searchLocationButton.hidden = YES;
    } else {
        // 普通模式：可拖拽的搜索结果页
        self.searchResultMinTop = self.topFixedHeight;
        self.searchResultInitialTop = self.topFixedHeight + self.mapHeight;
        
        [self.view insertSubview:self.searchResultView belowSubview:self.topFixedView];
        [self.searchResultView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.searchResultInitialTop);
            make.left.right.bottom.mas_equalTo(0);
        }];
        // 启用拖拽手势
        self.searchResultPanGesture.enabled = YES;
        // 创建并显示搜索定位按钮
        [self setupSearchLocationButton];
        self.searchLocationButton.hidden = NO;
    }
    
    self.searchResultView.hidden = NO;
    [self.searchResultView searchWithText:text];
    
    // 显示地图，隐藏其他
    self.mapContainer.hidden = NO;
    self.slidableScrollView.hidden = YES;
    self.bottomBar.hidden = YES;
    self.refreshButton.hidden = YES;
    
    [self.view layoutIfNeeded];
}

- (void)setupSearchLocationButton {
    if (!self.searchLocationButton) {
        self.searchLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.searchLocationButton setImage:[UIImage imageNamed:@"dingWei"] forState:UIControlStateNormal];
        [self.searchLocationButton addTarget:self action:@selector(searchLocationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        self.searchLocationButton.hidden = YES;
        [self.view addSubview:self.searchLocationButton];
        [self.searchLocationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(self.searchResultView.mas_top).offset(-10);
            make.width.height.mas_equalTo(44);
        }];
    }
}

- (void)searchLocationButtonClicked {
    // 定位到当前位置
    NSLog(@"定位到当前位置");
}

- (void)hideSearchResultView {
    self.searchResultView.hidden = YES;
    self.searchLocationButton.hidden = YES;
    
    // 显示其他视图
    self.mapContainer.hidden = NO;
    self.slidableScrollView.hidden = NO;
    self.bottomBar.hidden = NO;
    self.refreshButton.hidden = NO;
}

#pragma mark - 地点详情视图
- (void)showLocationDetailViewWithData:(NSDictionary *)data {
    // 存储当前数据
    self.currentLocationData = data;
    
    if (!self.locationDetailView) {
        self.locationDetailView = [[MapLocationDetailView alloc] init];
        self.locationDetailView.delegate = self;
        self.locationDetailView.layer.cornerRadius = 12;
        self.locationDetailView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
        self.locationDetailView.layer.masksToBounds = YES;
        [self.view addSubview:self.locationDetailView];
    }
    
    // 配置数据
    NSString *title = data[@"title"] ?: @"深圳大梅沙阳光沙滩";
    NSString *operatingHours = @"周一至周五 09:00 - 24:00";
    CGFloat distance = 120;
    NSInteger driveTime = 80; // 分钟
    NSString *address = @"广东省深圳市小梅沙2号停车场";
    NSArray *imageUrls = @[@"", @"", @""];
    
    [self.locationDetailView configureWithName:title
                               operatingHours:operatingHours
                                     distance:distance
                                    driveTime:driveTime
                                      address:address
                                    imageUrls:imageUrls];
    
    // 计算高度
    CGFloat detailHeight = [self.locationDetailView navigateButtonBottomHeight] + 20 + bottomHeight;
    
    // 初始位置在屏幕外
    [self.locationDetailView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(detailHeight);
        make.top.mas_equalTo(kHeight);
    }];
    [self.view layoutIfNeeded];
    
    // 隐藏搜索结果列表和定位按钮
    self.searchResultView.hidden = YES;
    self.searchLocationButton.hidden = YES;
    
    // 动画显示
    self.locationDetailView.hidden = NO;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.locationDetailView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kHeight - detailHeight);
        }];
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)hideLocationDetailView {
    [UIView animateWithDuration:0.25 animations:^{
        [self.locationDetailView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kHeight);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.locationDetailView.hidden = YES;
        // 重新显示搜索结果列表和定位按钮
        self.searchResultView.hidden = NO;
        self.searchLocationButton.hidden = NO;
    }];
}

- (void)handleSearchResultPan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.view];
    CGPoint velocity = [gesture velocityInView:self.view];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateChanged: {
            CGFloat currentTop = self.searchResultView.frame.origin.y;
            CGFloat newTop = currentTop + translation.y;
            
            // 限制范围
            newTop = MAX(self.searchResultMinTop, MIN(self.searchResultInitialTop, newTop));
            
            // 上滑时隐藏定位按钮
            if (translation.y < 0) {
                self.searchLocationButton.hidden = YES;
            }
            
            [self.searchResultView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(newTop);
            }];
            [self.view layoutIfNeeded];
            
            [gesture setTranslation:CGPointZero inView:self.view];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            CGFloat currentTop = self.searchResultView.frame.origin.y;
            CGFloat middlePoint = (self.searchResultMinTop + self.searchResultInitialTop) / 2;
            
            CGFloat targetTop;
            if (velocity.y > 500) {
                // 快速下滑，回到底部
                targetTop = self.searchResultInitialTop;
            } else if (velocity.y < -500) {
                // 快速上滑，到顶部
                targetTop = self.searchResultMinTop;
            } else {
                // 根据当前位置决定
                targetTop = (currentTop < middlePoint) ? self.searchResultMinTop : self.searchResultInitialTop;
            }
            
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.searchResultView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(targetTop);
                }];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                // 下滑到底部时显示定位按钮
                if (targetTop == self.searchResultInitialTop) {
                    self.searchLocationButton.hidden = NO;
                }
            }];
            break;
        }
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    // 如果点击的不是 headerView 区域，隐藏分类搜索视图
    if (self.categorySearchView && !self.categorySearchView.hidden) {
        CGRect headerFrame = [self.headerView convertRect:self.headerView.bounds toView:self.view];
        if (!CGRectContainsPoint(headerFrame, point)) {
            [self hideCategorySearchView];
        }
    }
}

#pragma mark - 懒加载

- (MapAddressView *)mapView{
    if (!_mapView) {
        _mapView = [[MapAddressView alloc] init];
        _mapView.mapAnnotationType = 0;
    }
    return _mapView;
}

@end
