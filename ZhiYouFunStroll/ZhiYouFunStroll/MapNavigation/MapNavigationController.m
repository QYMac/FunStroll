//
//  MapNavigationController.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/8.
//

#import "MapNavigationController.h"
#import "AMapNavigationManager.h"
#import "MapNavigationCollectionViewCell.h"


@interface MapNavigationController ()<SwitchPageViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UIView *topNavView;
@property (nonatomic,strong) UIButton *backBut;
@property (nonatomic,strong) UILabel *addressL;
@property (nonatomic,strong) SwitchPageView *pageView;

@property (nonatomic,strong) UIView *bottomTabView;
@property (nonatomic,strong) UIButton *startBut;
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,assign) NSInteger selectedIndex;// 默认选中的出行方式驾车（0）
@property (nonatomic,strong) NSArray *dataList;

@end

@implementation MapNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navigationItem.title = @"导航";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.topNavView.frame = CGRectMake(0, 0, kWidth, topHeight + 40);
    [self.view addSubview:self.topNavView];
    
    [self.topNavView addSubview:self.backBut];
    [self.backBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusBarHeight);
        make.left.mas_equalTo(11);
        make.height.width.mas_equalTo(navBarHeight+5);
    }];
    
    
    self.addressL.layer.cornerRadius = 10;
    self.addressL.layer.masksToBounds = YES;
    [self.topNavView addSubview:self.addressL];
    [self.addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.backBut);
        make.left.mas_equalTo(self.backBut.mas_right).offset(0);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(40);
    }];
    
    NSArray *titles = @[@"驾车",@"公共交通",@"骑行",@"步行"];
    NSArray *controllers = @[@"",@"",@"",@""];
    self.pageView = [[SwitchPageView alloc] initWithFrame:CGRectMake(0, topHeight + 5, kWidth,35) titles:titles controllers:controllers];
    self.pageView.titleViewHeight = 35;
    self.pageView.titleButtonWidth = kWidth/4;
    self.pageView.selectTitleFont = [UIFont boldSystemFontOfSize:16];
    self.pageView.defaultTitleFont = [UIFont boldSystemFontOfSize:16];
    self.pageView.defaultTitleColor = RGB(173, 173, 173);
    self.pageView.selectTitleColor = [UIColor blackColor];
    self.pageView.lineColor = RGB(255, 176, 79);
    self.pageView.lineHeight = 3;
    self.pageView.marginToLfet = 0;
    self.pageView.delegate = self;
    [self.topNavView addSubview:self.pageView];
    
    self.bottomTabView.frame = CGRectMake(0, kHeight-(tabBarHeight+90), kWidth, tabBarHeight+90);
    [self.view addSubview:self.bottomTabView];
    
    self.startBut.layer.cornerRadius = 6;
    self.startBut.layer.masksToBounds = YES;
    [self.bottomTabView addSubview:self.startBut];
    [self.startBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-bottomHeight + 10);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(40);
    }];
    
    self.collectionView.layer.cornerRadius = 6;
    self.collectionView.layer.masksToBounds = YES;
    [self.bottomTabView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.right .mas_equalTo(-10);
        make.bottom.mas_equalTo(self.startBut.mas_top).offset(-10);
    }];
    
    self.selectedIndex = 0;
    [self chooseTravelTypeIndex:self.selectedIndex];// 默认选择驾车出行，如果距离太近可选步行
    
    WeakSelf
    [AMapNavigationManager shared].exitNavigationBlcok = ^{
        [weakSelf stopButBtuClick];
    };
    
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(110,70);
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    MapNavigationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell collectionViewIndexPath:indexPath dataList:self.dataList selectedIndex:self.selectedIndex];
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - 按钮点击
- (void)startButBtuClick:(UIButton *)sender{
    if (self.selectedIndex == 0) {
        // 驾车导航
        if (DEBUG) {
            [self onEmulatorTap];
        } else {
            [self onGpsTap];
        }
    } else if (self.selectedIndex == 1) {
        // 公共交通导航
        if (DEBUG) {
            [self onTransitEmuTap];
        } else {
            [self onTransitGpsTap];
        }
    } else if (self.selectedIndex == 2) {
        // 骑行导航
        if (DEBUG) {
            [self onRideEmuTap];
        } else {
            [self onRideGpsTap];
        }
    } else if (self.selectedIndex == 3) {
        // 步行导航
        if (DEBUG) {
            [self onWalkEmuTap];
        } else {
            [self onWalkGpsTap];
        }
    }
    
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.topNavView.frame = CGRectMake(0, -(topHeight + 40), kWidth, topHeight + 40);
        weakSelf.bottomTabView.frame = CGRectMake(0, kHeight, kWidth, tabBarHeight+90);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)stopButBtuClick{
    [[AMapNavigationManager shared] stopNavi];
    [[AMapNavigationManager shared] stopWalkNavi];
    [[AMapNavigationManager shared] stopRideNavi];
    
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.topNavView.frame = CGRectMake(0, 0, kWidth, topHeight + 40);
        weakSelf.bottomTabView.frame = CGRectMake(0, kHeight-(tabBarHeight+90), kWidth, tabBarHeight+90);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)onEmulatorTap {
    [[AMapNavigationManager shared] onEmulatorTap];
}

- (void)onGpsTap {
    [[AMapNavigationManager shared] onGpsTap];
}

- (void)onWalkEmuTap {

    [[AMapNavigationManager shared] onWalkEmuTap];
}

- (void)onWalkGpsTap {
    [[AMapNavigationManager shared] onWalkGpsTap];
}

- (void)onRideEmuTap{
    [[AMapNavigationManager shared] onRideEmuTap];
}

- (void)onRideGpsTap {
    [[AMapNavigationManager shared] onRideGpsTap];
}

- (void)onTransitEmuTap{
    [[AMapNavigationManager shared] onTransitEmuTap];
}

- (void)onTransitGpsTap {
    [[AMapNavigationManager shared] onTransitGpsTap];
}

// 切换试图的回调 index 选择的视图
- (void)SwitchPageView:(SwitchPageView *)MCPageView didSelectIndex:(NSInteger)index{
    
    [self chooseTravelTypeIndex:index];
}

// 选择出行方式
- (void)chooseTravelTypeIndex:(NSInteger)index{
    
    self.selectedIndex = index;
    
    id temp = nil;
    
    CLLocationCoordinate2D start = CLLocationCoordinate2DMake(39.908722, 116.397499); // 天安门
    CLLocationCoordinate2D end = CLLocationCoordinate2DMake(39.984121, 116.307484);   // 中关村
    WeakSelf
    if (index == 0) { // 驾车
        [[AMapNavigationManager shared] planDrivingFastestFrom:start to:end completion:^(NSArray<AMapNaviRoute *> * _Nullable routes, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Drive route error: %@", error.localizedDescription);
                return;
            }
            NSLog(@"Got %lu driving routes (fastest).", (unsigned long)routes.count);
        
            weakSelf.dataList = [routes copy];
            [weakSelf.collectionView reloadData];

            
            [[AMapNavigationManager shared].rideView removeFromSuperview];
            [[AMapNavigationManager shared].walkView removeFromSuperview];
            [AMapNavigationManager shared].rideView = temp;
            [AMapNavigationManager shared].walkView = temp;
            [self.view insertSubview:[AMapNavigationManager shared].driveView atIndex:1];
            // 选第一条做为当前导航路线
            [[AMapNavigationManager shared] selectNaviRouteWithIndex:0];
            
        }];
    } else if (index == 1) { // 公共交通
        // 使用城市代码（北京：010）或城市名称（beijing）
        [[AMapNavigationManager shared] planTransitFrom:start to:end city:@"010" policy:AMapTransitStrategyFastest completion:^(AMapRouteSearchResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Transit error: %@", error.localizedDescription);
                return;
            }
            NSLog(@"Transit result count: %lu", (unsigned long)response.route.transits.count);
            
            if (response && response.route.transits.count > 0) {
                weakSelf.dataList = [response.route.transits copy];
                [weakSelf.collectionView reloadData];
                
                [[AMapNavigationManager shared].driveView removeFromSuperview];
                [[AMapNavigationManager shared].rideView removeFromSuperview];
                [AMapNavigationManager shared].driveView = temp;
                [AMapNavigationManager shared].rideView = temp;
                [self.view insertSubview:[AMapNavigationManager shared].walkView atIndex:1];
                [[AMapNavigationManager shared] showTransitRouteOnMapResponse:response];
            }
        }];
    } else if (index == 2) { // 骑行
        [[AMapNavigationManager shared] planRidingFrom:start to:end completion:^(AMapNaviRoute * _Nullable route, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Ride route error: %@", error.localizedDescription);
                return;
            }
            NSLog(@"Ride route length: %ld m", (long)route.routeLength);
            
            if (route) {
                weakSelf.dataList = [route.routeCoordinates copy];
                [weakSelf.collectionView reloadData];
                
                [[AMapNavigationManager shared].driveView removeFromSuperview];
                [[AMapNavigationManager shared].walkView removeFromSuperview];
                [AMapNavigationManager shared].driveView = temp;
                [AMapNavigationManager shared].walkView = temp;
                [self.view insertSubview:[AMapNavigationManager shared].rideView atIndex:1];
                [[AMapNavigationManager shared] showRideRouteOnMap:route];
            }
        }];
    } else if (index == 3) { // 步行
        [[AMapNavigationManager shared] planWalkingFrom:start to:end completion:^(AMapNaviRoute * _Nullable route, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Walk route error: %@", error.localizedDescription);
                return;
            }
            NSLog(@"Walk route length: %ld m", (long)route.routeLength);
            
            if (route) {
                weakSelf.dataList = [route.routeCoordinates copy];
                [weakSelf.collectionView reloadData];
                
                [[AMapNavigationManager shared].driveView removeFromSuperview];
                [[AMapNavigationManager shared].rideView removeFromSuperview];
                [AMapNavigationManager shared].driveView = temp;
                [AMapNavigationManager shared].rideView = temp;
                [self.view insertSubview:[AMapNavigationManager shared].walkView atIndex:1];
                [[AMapNavigationManager shared] showWalkRouteOnMap:route isNavigation:NO];
            }
        }];
    }
}

#pragma mark - 懒加载

- (UIView *)topNavView{
    if (!_topNavView) {
        _topNavView = [[UIView alloc] init];
        _topNavView.backgroundColor = [UIColor whiteColor];
    }
    return _topNavView;
}

- (UIButton *)backBut{
    if (!_backBut) {
        _backBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBut setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backBut addTarget:self action:@selector(dismissaBtu) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBut;
}

- (UILabel *)addressL{
    if (!_addressL) {
        _addressL = [[UILabel alloc]init];
        _addressL.textColor = RGB(130, 130, 130);
        _addressL.text = @"    当前位置\n    北京中关村科技园";
        _addressL.font = [UIFont systemFontOfSize:12];
        _addressL.numberOfLines = 0;
        _addressL.backgroundColor = RGB(240, 240, 240);
        //_addressL.textAlignment = NSTextAlignmentCenter;
    }
    return _addressL;
}


- (UIView *)bottomTabView{
    if (!_bottomTabView) {
        _bottomTabView = [[UIView alloc] init];
        _bottomTabView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomTabView;
}

- (UIButton *)startBut{
    if (!_startBut) {
        _startBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBut setTitle:@"开始导航" forState:UIControlStateNormal];
        [_startBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _startBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [_startBut addTarget:self action:@selector(startButBtuClick:) forControlEvents:UIControlEventTouchUpInside];
        _startBut.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:0.9];
    }
    return _startBut;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.sectionInset = UIEdgeInsetsMake(10, 10,10, 10);//上左下右
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = RGB(240, 240, 240);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[MapNavigationCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

#pragma mark - 生命周期

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    /*
    UIImage * image = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(dismissaBtu)];
    self.navigationItem.leftBarButtonItem = backButton;
     */

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
    //[[AMapNavigationManager shared] clearDealloc];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 销毁封装的单例，下次进入重新初始化
    [AMapNavigationManager resetShared];
}


- (void)dismissaBtu{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
