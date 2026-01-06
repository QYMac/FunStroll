//
//  AMapNavigationManager.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/8.
//

#import "AMapNavigationManager.h"

@interface AMapNavigationManager () <AMapNaviDriveManagerDelegate, AMapNaviWalkManagerDelegate, AMapNaviRideManagerDelegate, AMapSearchDelegate ,MAMapViewDelegate, AMapNaviDriveViewDelegate, AMapNaviWalkViewDelegate, AMapNaviRideViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, copy) AMapNaviDriveRouteCompletion driveCompletion;
@property (nonatomic, copy) AMapNaviSimpleCompletion walkCompletion;
@property (nonatomic, copy) AMapNaviSimpleCompletion rideCompletion;
@property (nonatomic, copy) AMapTransitCompletion transitCompletion;
@property (nonatomic, strong) AMapSearchAPI *searchAPI;

// 驾车导航相关
@property (nonatomic, assign) BOOL routeReady;
@property (nonatomic, strong) AMapNaviDriveManager *driveManager;
@property (nonatomic, strong) NSMutableArray<MAPolyline *> *driveRouteLines;
@property (nonatomic, strong) AMapNaviRoute *driveRoute;
@property (nonatomic, strong) NSMutableArray<MAPointAnnotation *> *driveAnnotations;

// 步行导航相关
@property (nonatomic, strong) NSMutableArray<MAPolyline *> *walkRouteLines;
@property (nonatomic, strong) AMapNaviRoute *walkRoute;
@property (nonatomic, strong) NSMutableArray *walkPassedCoords;
@property (nonatomic, assign) NSInteger walkCurrentSegmentIndex;
@property (nonatomic, assign) BOOL walkRouteReady;
@property (nonatomic, strong) AMapNaviWalkManager *walkManager;
@property (nonatomic, strong) NSMutableArray<MAPointAnnotation *> *walkAnnotations;


// 骑行导航相关
@property (nonatomic, strong) NSMutableArray<MAPolyline *> *rideRouteLines;
@property (nonatomic, strong) AMapNaviRoute *rideRoute;
@property (nonatomic, assign) BOOL rideRouteReady;
@property (nonatomic, assign) AMapNaviRideManager *rideManager;
@property (nonatomic, strong) NSMutableArray<MAPointAnnotation *> *rideAnnotations;


// 公交导航相关
@property (nonatomic, strong) NSMutableArray<MAPolyline *> *transitRouteLines;
// 步行段（绿色）
@property (nonatomic, strong) NSMutableArray<MAPolyline *> *transitWalkingLines;
// 公交段（蓝色）
@property (nonatomic, strong) NSMutableArray<MAPolyline *> *transitBusLines;
// 地铁段 (红色)
@property (nonatomic, strong) NSMutableArray<MAPolyline *> *transitSubways;
// 火车段（紫色）
@property (nonatomic, strong) NSMutableArray<MAPolyline *> *transitRailwayLines;
@property (nonatomic, strong) NSMutableArray<MAPointAnnotation *> *transitAnnotations; // 站点标注
@property (nonatomic, strong) AMapRouteSearchResponse *transitResponse;
@property (nonatomic, strong) AMapTransit *selectedTransit;
@property (nonatomic, assign) BOOL transitRouteReady;

// 公交导航状态
@property (nonatomic, assign) NSInteger currentTransitSegmentIndex; // 当前所在的segment索引
@property (nonatomic, assign) NSInteger currentTransitStopIndex;     // 当前所在的站点索引
@property (nonatomic, strong) CLLocationManager *locationManager;    // 用于位置跟踪
@property (nonatomic, assign) BOOL isTransitNavigating;               // 是否正在公交导航

@property (nonatomic, copy) AMapLocationAddressCompletion locationAddressCompletion; // 返回当前位置


@end

static AMapNavigationManager *_sharedManager;

@implementation AMapNavigationManager

+ (instancetype)shared {
    @synchronized(self) {
        if (!_sharedManager) {
            _sharedManager = [[self alloc] init];
        }
    }
    return _sharedManager;
}

+ (void)resetShared {
    @synchronized(self) {
        if (!_sharedManager) { return; }
        [_sharedManager teardown];
        _sharedManager = nil;
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self setupMapView];
    }
    return self;
}

- (void)setupMapView{
    self.driveRouteLines = [NSMutableArray array];
    self.driveAnnotations = [NSMutableArray array];
    self.walkRouteLines = [NSMutableArray array];
    self.walkPassedCoords = [NSMutableArray array];
    self.walkAnnotations = [NSMutableArray array];
    self.rideRouteLines = [NSMutableArray array];
    self.rideAnnotations = [NSMutableArray array];
    self.walkCurrentSegmentIndex = 0;
    // 公交导航初始化
    self.transitRouteLines = [NSMutableArray array];
    self.transitWalkingLines = [NSMutableArray array];
    self.transitBusLines = [NSMutableArray array];
    self.transitRailwayLines = [NSMutableArray array];
    self.transitSubways = [NSMutableArray array];
    self.transitAnnotations = [NSMutableArray array];
    // 公交导航初始化
    self.currentTransitSegmentIndex = 0;
    self.currentTransitStopIndex = 0;
    self.isTransitNavigating = NO;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10; // 每10米更新一次
    
    [[TabBarViewController takeCurrentVC].view insertSubview:self.mapView atIndex:0];
    
    /*
    // 驾车UI视图，用于多路线展示
    [[TabBarViewController takeCurrentVC].view insertSubview:self.driveView atIndex:1];
    // 步行UI视图，用于多路线展示
    [[TabBarViewController takeCurrentVC].view insertSubview:self.walkView atIndex:1];
    // 骑行UI视图，用于多路线展示
    [[TabBarViewController takeCurrentVC].view insertSubview:self.rideView atIndex:1];
     */
     
}

#pragma mark - Public

- (void)planDrivingFrom:(CLLocationCoordinate2D)start
                     to:(CLLocationCoordinate2D)end
               strategy:(AMapNaviDrivingStrategy)strategy
             completion:(AMapNaviDriveRouteCompletion)completion {
    self.driveCompletion = completion;
    AMapNaviPoint *from = [AMapNaviPoint locationWithLatitude:start.latitude longitude:start.longitude];
    AMapNaviPoint *toPoint = [AMapNaviPoint locationWithLatitude:end.latitude longitude:end.longitude];
    
    [self.driveManager calculateDriveRouteWithStartPoints:@[from]
                                           endPoints:@[toPoint]
                                           wayPoints:nil
                                       drivingStrategy:strategy];
}

- (void)planDrivingFastestFrom:(CLLocationCoordinate2D)start
                            to:(CLLocationCoordinate2D)end
                    completion:(AMapNaviDriveRouteCompletion)completion {
    [self planDrivingFrom:start to:end strategy:AMapNaviDrivingStrategyMultipleDefault completion:completion];
}

- (void)planDrivingNoHighwayFrom:(CLLocationCoordinate2D)start
                               to:(CLLocationCoordinate2D)end
                       completion:(AMapNaviDriveRouteCompletion)completion {
    [self planDrivingFrom:start to:end strategy:AMapNaviDrivingStrategyMultipleAvoidHighway completion:completion];
}

- (void)planWalkingFrom:(CLLocationCoordinate2D)start
                     to:(CLLocationCoordinate2D)end
             completion:(AMapNaviSimpleCompletion)completion {
    self.walkCompletion = completion;
    AMapNaviPoint *from = [AMapNaviPoint locationWithLatitude:start.latitude longitude:start.longitude];
    AMapNaviPoint *toPoint = [AMapNaviPoint locationWithLatitude:end.latitude longitude:end.longitude];
    [self.walkManager calculateWalkRouteWithStartPoints:@[from] endPoints:@[toPoint]];
}

- (void)planRidingFrom:(CLLocationCoordinate2D)start
                    to:(CLLocationCoordinate2D)end
            completion:(AMapNaviSimpleCompletion)completion {
    self.rideCompletion = completion;
    AMapNaviPoint *from = [AMapNaviPoint locationWithLatitude:start.latitude longitude:start.longitude];
    AMapNaviPoint *toPoint = [AMapNaviPoint locationWithLatitude:end.latitude longitude:end.longitude];
    AMapNaviRideManager *rideManager = [AMapNaviRideManager sharedInstance];
    rideManager.delegate = self;
    [rideManager calculateRideRouteWithStartPoint:from endPoint:toPoint];
}

- (void)planTransitFrom:(CLLocationCoordinate2D)start
                     to:(CLLocationCoordinate2D)end
                   city:(NSString *)city
                 policy:(AMapTransitStrategy)policy
             completion:(AMapTransitCompletion)completion {
    self.transitCompletion = completion;
    if (!self.searchAPI) {
        self.searchAPI = [[AMapSearchAPI alloc] init];
        self.searchAPI.delegate = self;
    }
    
    AMapTransitRouteSearchRequest *request = [[AMapTransitRouteSearchRequest alloc] init];
    request.city = city;
    request.destinationCity = city;
    request.strategy = policy;
    
    request.origin = [AMapGeoPoint locationWithLatitude:start.latitude longitude:start.longitude];
    request.destination = [AMapGeoPoint locationWithLatitude:end.latitude longitude:end.longitude];
    
    [self.searchAPI AMapTransitRouteSearch:request];
}


#pragma mark - 驾车导航相关方法和代理

- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager {
    if (self.driveCompletion) {
        self.driveCompletion(driveManager.naviRoutes.allValues, nil);
    }
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error {
    if (self.driveCompletion) {
        self.driveCompletion(nil, error);
    }
}

// 开始导航回调
- (void)driveManager:(AMapNaviDriveManager *)driveManager didStartNavi:(AMapNaviMode)naviMode {
    NSLog(@"开始导航");
}

// 到达目的地回调
- (void)driveManagerOnArrivedDestination:(AMapNaviDriveManager *)driveManager {
    NSLog(@"到达目的地");
    if (self.exitNavigationBlcok) {
        self.exitNavigationBlcok();
    }
}

- (void)driveManagerDidEndEmulatorNavi:(AMapNaviDriveManager *)driveManager{
    NSLog(@"到达目的地");
    if (self.exitNavigationBlcok) {
        self.exitNavigationBlcok();
    }
}

// 导航播报信息回调
- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType {
    NSLog(@"播报信息: %@", soundString);
}

// 点击退出按钮回调
- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView{
    if (self.exitNavigationBlcok) {
        self.exitNavigationBlcok();
    }
}


// 选择一条驾车导航画线
- (void)selectNaviRouteWithRoutes:(NSArray<AMapNaviRoute *> *)routes{
    
    self.driveView.hidden = YES;
    self.walkView.hidden = YES;
    self.rideView.hidden = YES;
    [self.walkManager removeDataRepresentative:self.walkView];
    [self.rideManager removeDataRepresentative:self.rideView];
    [self.driveManager removeDataRepresentative:self.driveView];
    
    // 清理旧路线
    [self removeMapViewAnnotationsAndRoutes];
    
    // 绘制第一条路线
    if (routes.count > 0) {
        self.driveRoute = routes.firstObject;
        [self showDriveRouteOnMap:self.driveRoute];
    }
}

- (void)showDriveRouteOnMap:(AMapNaviRoute *)route {
    // 清理旧路线
    if (self.driveRouteLines.count) {
        [self.mapView removeOverlays:self.driveRouteLines];
        [self.driveRouteLines removeAllObjects];
    }
    // 清理其他导航路线
    if (self.walkRouteLines.count) {
        [self.mapView removeOverlays:self.walkRouteLines];
        [self.walkRouteLines removeAllObjects];
    }
    if (self.rideRouteLines.count) {
        [self.mapView removeOverlays:self.rideRouteLines];
        [self.rideRouteLines removeAllObjects];
    }
    
    
    // 选第一条做为当前导航路线
    NSNumber *firstRouteID = self.driveManager.naviRoutes.allKeys.firstObject;
    if (firstRouteID) {
        [self.driveManager selectNaviRouteWithRouteID:firstRouteID.integerValue];
    }
    self.routeReady = (self.driveManager.naviRoutes.count > 0);
    
    if (!route || !route.routeCoordinates || route.routeCoordinates.count <= 1) { return; }
    
    NSUInteger count = route.routeCoordinates.count;
    CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * count);
    for (NSUInteger i = 0; i < count; i++) {
        AMapNaviPoint *point = route.routeCoordinates[i];
        if (fabs(point.latitude) > 90 || fabs(point.longitude) > 180 || (point.latitude == 0 && point.longitude == 0)) {
            coords[i] = kCLLocationCoordinate2DInvalid;
        } else {
            coords[i] = CLLocationCoordinate2DMake(point.latitude, point.longitude);
        }
    }
    
    // 过滤有效坐标
    CLLocationCoordinate2D *validCoords = malloc(sizeof(CLLocationCoordinate2D) * count);
    NSMutableArray<NSNumber *> *validIndices = [NSMutableArray array];
    NSUInteger validCount = 0;
    for (NSUInteger i = 0; i < count; i++) {
        if (CLLocationCoordinate2DIsValid(coords[i])) {
            validCoords[validCount++] = coords[i];
            [validIndices addObject:@(i)];
        }
    }
    free(coords);
    
    if (validCount < 2) {
        free(validCoords);
        return;
    }
    
    // 创建完整的驾车路线
    MAPolyline *fullRoute = [MAPolyline polylineWithCoordinates:validCoords count:validCount];
    [self.driveRouteLines addObject:fullRoute];
    free(validCoords);
    
    // 添加起点、终点和途径点标注
    [self addAnnotationsForRoute:route withValidIndices:validIndices toAnnotations:self.driveAnnotations routeType:@"驾车"];
    
    [self.mapView addOverlays:self.driveRouteLines];
    [self.mapView addAnnotations:self.driveAnnotations];
    [self.mapView setVisibleMapRect:[fullRoute boundingMapRect] edgePadding:UIEdgeInsetsMake(60, 40, 80, 40) animated:YES];
}

- (void)onEmulatorTap {
    if (!self.routeReady) {
        NSLog(@"Route not ready, plan first.");
        return;
    }
    // 停止其他导航
    [self stopNavi];
    [self stopWalkNavi];
    [self stopRideNavi];
    
    self.driveView.hidden = NO;
    self.walkView.hidden = YES;
    self.rideView.hidden = YES;
    [self.walkManager removeDataRepresentative:self.walkView];
    [self.rideManager removeDataRepresentative:self.rideView];
    [self.driveManager addDataRepresentative:self.driveView];
    
    // 选第一条做为当前导航路线
    NSNumber *firstRouteID = self.driveManager.naviRoutes.allKeys.firstObject;
    if (firstRouteID) {
        [self.driveManager selectNaviRouteWithRouteID:firstRouteID.integerValue];
    }
    self.routeReady = (self.driveManager.naviRoutes.count > 0);
    
    [self.driveView setShowUIElements:YES];
    [self startEmulatorNaviWithSpeed:120]; // 模拟速度 60km/s
}

- (void)onGpsTap {
    if (!self.routeReady) {
        NSLog(@"Route not ready, plan first.");
        return;
    }
    
    // 停止其他导航
    [self stopNavi];
    [self stopWalkNavi];
    [self stopRideNavi];
    
    self.driveView.hidden = NO;
    self.walkView.hidden = YES;
    self.rideView.hidden = YES;
    [self.walkManager removeDataRepresentative:self.walkView];
    [self.rideManager removeDataRepresentative:self.rideView];
    [self.driveManager addDataRepresentative:self.driveView];
    
    [self.driveView setShowUIElements:YES];
    [self startGPSNavi];
}

- (void)startEmulatorNaviWithSpeed:(int)speed {
    if (self.driveManager.naviRoutes.count == 0) { return; }
    [self.driveManager setEmulatorNaviSpeed:speed > 0 ? speed : 60];
    [self.driveManager startEmulatorNavi];
}

- (void)startGPSNavi {
    if (self.driveManager.naviRoutes.count == 0) { return; }
    [self.driveManager startGPSNavi];
}

- (void)stopNavi {
    [self.driveManager stopNavi];
}

#pragma mark - 步行导航相关方法和代理
- (void)walkManagerOnCalculateRouteSuccess:(AMapNaviWalkManager *)walkManager {
    if (self.walkCompletion) {
        self.walkCompletion(walkManager.naviRoute, nil);
    }
}

- (void)walkManager:(AMapNaviWalkManager *)walkManager onCalculateRouteFailure:(NSError *)error {
    if (self.walkCompletion) {
        self.walkCompletion(nil, error);
    }
}

- (void)showWalkRouteOnMap:(AMapNaviRoute *)route isNavigation:(BOOL)isNavigation{
    
    if (isNavigation == NO) {
        self.driveView.hidden = YES;
        self.walkView.hidden = YES;
        self.rideView.hidden = YES;
        [self.walkManager removeDataRepresentative:self.walkView];
        [self.rideManager removeDataRepresentative:self.rideView];
        [self.driveManager removeDataRepresentative:self.driveView];
    }
    
    // 清理旧路线
    [self removeMapViewAnnotationsAndRoutes];
    
    self.mapView.hidden = NO;
    self.walkRoute = route;
    self.walkRouteReady = YES;
    
    [self.walkPassedCoords removeAllObjects];
    self.walkCurrentSegmentIndex = 0;
    
    if (!route || !route.routeCoordinates || route.routeCoordinates.count <= 1) { return; }
    
    NSUInteger count = route.routeCoordinates.count;
    CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * count);
    for (NSUInteger i = 0; i < count; i++) {
        AMapNaviPoint *point = route.routeCoordinates[i];
        if (fabs(point.latitude) > 90 || fabs(point.longitude) > 180 || (point.latitude == 0 && point.longitude == 0)) {
            coords[i] = kCLLocationCoordinate2DInvalid;
        } else {
            coords[i] = CLLocationCoordinate2DMake(point.latitude, point.longitude);
        }
    }
    
    // 过滤有效坐标
    CLLocationCoordinate2D *validCoords = malloc(sizeof(CLLocationCoordinate2D) * count);
    NSMutableArray<NSNumber *> *validIndices = [NSMutableArray array];
    NSUInteger validCount = 0;
    for (NSUInteger i = 0; i < count; i++) {
        if (CLLocationCoordinate2DIsValid(coords[i])) {
            validCoords[validCount++] = coords[i];
            [validIndices addObject:@(i)];
        }
    }
    free(coords);
    
    if (validCount < 2) {
        free(validCoords);
        return;
    }
    
    // 创建完整的步行路线
    MAPolyline *fullRoute = [MAPolyline polylineWithCoordinates:validCoords count:validCount];
    [self.walkRouteLines addObject:fullRoute];
    free(validCoords);
    
    // 添加起点、终点和途径点标注
    [self addAnnotationsForRoute:route withValidIndices:validIndices toAnnotations:self.walkAnnotations routeType:@"步行"];
    
    [self.mapView addOverlays:self.walkRouteLines];
    [self.mapView addAnnotations:self.walkAnnotations];
    [self.mapView setVisibleMapRect:[fullRoute boundingMapRect] edgePadding:UIEdgeInsetsMake(60, 40, 80, 40) animated:YES];
}

- (void)updateWalkRouteWithPassedSegment:(NSInteger)segmentIndex {
    if (!self.walkRoute || !self.walkRoute.routeCoordinates || segmentIndex < 0) { return; }
    
    // 移除旧路线
    if (self.walkRouteLines.count) {
        [self.mapView removeOverlays:self.walkRouteLines];
        [self.walkRouteLines removeAllObjects];
    }
    
    NSUInteger totalCount = self.walkRoute.routeCoordinates.count;
    if (segmentIndex >= totalCount - 1) {
        // 已走完，移除所有路线
        return;
    }
    
    // 计算剩余路径的起点（从当前段的下一个点开始）
    NSInteger startIndex = segmentIndex + 1;
    NSInteger remainingCount = totalCount - startIndex;
    
    if (remainingCount < 2) { return; }
    
    CLLocationCoordinate2D *remainingCoords = malloc(sizeof(CLLocationCoordinate2D) * remainingCount);
    for (NSInteger i = 0; i < remainingCount; i++) {
        AMapNaviPoint *point = self.walkRoute.routeCoordinates[startIndex + i];
        remainingCoords[i] = CLLocationCoordinate2DMake(point.latitude, point.longitude);
    }
    
    MAPolyline *remainingRoute = [MAPolyline polylineWithCoordinates:remainingCoords count:remainingCount];
    [self.walkRouteLines addObject:remainingRoute];
    free(remainingCoords);
    
    [self.mapView addOverlays:self.walkRouteLines];
}

- (void)walkManager:(AMapNaviWalkManager *)walkManager updateNaviInfo:(AMapNaviInfo *)naviInfo {
    if (!naviInfo || !self.walkRoute) { return; }
    
    // 根据导航信息中的路段索引更新已走过的路径
    // 使用 currentSegmentIndex 或 currentLinkIndex 来判断当前位置
    NSInteger currentSegment = naviInfo.currentSegmentIndex;
    NSInteger currentLink = naviInfo.currentLinkIndex;
    
    // 优先使用 linkIndex，因为它更精确（link 是 segment 的子单位）
    // 如果 linkIndex 有效，使用它；否则使用 segmentIndex
    NSInteger indexToUse = (currentLink >= 0) ? currentLink : currentSegment;
    
    if (indexToUse != self.walkCurrentSegmentIndex && indexToUse >= 0) {
        self.walkCurrentSegmentIndex = indexToUse;
        [self updateWalkRouteWithPassedSegment:indexToUse];
    }
}

- (void)walkManagerOnArrivedDestination:(AMapNaviWalkManager *)walkManager {
    
    // 到达目的地，移除所有路线
    if (self.walkRouteLines.count) {
        [self.mapView removeOverlays:self.walkRouteLines];
        [self.walkRouteLines removeAllObjects];
    }
    
    // 如果是公交导航中的步行段完成，继续下一个segment
    if (self.isTransitNavigating) {
        [self transitSegmentCompleted];
    }
}

// 模拟步行导航结束回调
- (void)walkManagerDidEndEmulatorNavi:(AMapNaviWalkManager *)walkManager{
    
    // 到达目的地，移除所有路线
    if (self.walkRouteLines.count) {
        [self.mapView removeOverlays:self.walkRouteLines];
        [self.walkRouteLines removeAllObjects];
    }
    
    // 如果是公交导航中的步行段完成，继续下一个segment
    if (self.isTransitNavigating) {
        [self transitSegmentCompleted];
    }
}

// 步行导航界面关闭按钮点击时的回调函数
- (void)walkViewCloseButtonClicked:(AMapNaviWalkView *)walkView{
    if (self.exitNavigationBlcok) {
        self.exitNavigationBlcok();
    }
}

- (void)walkManager:(AMapNaviWalkManager *)walkManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType{
    NSLog(@"播报信息: %@", soundString);
}

- (void)onWalkEmuTap {
    if (!self.walkRouteReady || !self.walkRoute) {
        NSLog(@"Walk route not ready, plan first.");
        return;
    }
    
    // 停止其他导航
    [self stopNavi];
    [self stopWalkNavi];
    [self stopRideNavi];
    
    self.driveView.hidden = YES;
    self.walkView.hidden = NO;
    self.rideView.hidden = YES;
    [self.walkManager addDataRepresentative:self.walkView];
    [self.rideManager removeDataRepresentative:self.rideView];
    [self.driveManager removeDataRepresentative:self.driveView];
    
    self.walkView.showUIElements = YES;
    
    // 重置当前路段索引，从起点开始
    self.walkCurrentSegmentIndex = -1;
    // 重新显示完整路线（导航开始时会根据当前位置更新）
    [self showWalkRouteOnMap:self.walkRoute isNavigation:YES];
    
    NSLog(@"Starting walk emulator navigation...");
    [self startWalkEmulatorNaviWithSpeed:120];

}



- (void)onWalkGpsTap {
    if (!self.walkRouteReady || !self.walkRoute) {
        NSLog(@"Walk route not ready, plan first.");
        return;
    }
    // 停止其他导航
    [self stopNavi];
    [self stopWalkNavi];
    [self stopRideNavi];
    
    self.driveView.hidden = YES;
    self.walkView.hidden = NO;
    self.rideView.hidden = YES;
    [self.walkManager addDataRepresentative:self.walkView];
    [self.rideManager removeDataRepresentative:self.rideView];
    [self.driveManager removeDataRepresentative:self.driveView];
    
    self.walkView.showUIElements = YES;
    // 重置当前路段索引，从起点开始
    self.walkCurrentSegmentIndex = -1;
    // 重新显示完整路线（导航开始时会根据当前位置更新）
    [self showWalkRouteOnMap:self.walkRoute isNavigation:YES];
    [self startWalkGPSNavi];
}

- (void)startWalkEmulatorNaviWithSpeed:(int)speed {
    if (!self.walkManager.naviRoute) { return; }
    [self.walkManager setEmulatorNaviSpeed:speed > 0 ? speed : 4]; // 步行默认 4km/h
    [self.walkManager startEmulatorNavi];
}

- (void)startWalkGPSNavi {
    if (!self.walkManager.naviRoute) { return; }
    [self.walkManager startGPSNavi];
}

- (void)stopWalkNavi {
    [self.walkManager stopNavi];
}

#pragma mark - 骑行导航相关
- (void)showRideRouteOnMap:(AMapNaviRoute *)route {
    
    self.driveView.hidden = YES;
    self.walkView.hidden = YES;
    self.rideView.hidden = YES;
    
    [self.walkManager removeDataRepresentative:self.walkView];
    [self.rideManager removeDataRepresentative:self.rideView];
    [self.driveManager removeDataRepresentative:self.driveView];

    
    // 清理旧路线
    [self removeMapViewAnnotationsAndRoutes];
    
    self.rideRoute = route;
    self.rideRouteReady = YES;
    
    
    if (!route || !route.routeCoordinates || route.routeCoordinates.count <= 1) { return; }
    
    NSUInteger count = route.routeCoordinates.count;
    CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * count);
    NSMutableArray<NSNumber *> *validIndices = [NSMutableArray array];
    for (NSUInteger i = 0; i < count; i++) {
        AMapNaviPoint *point = route.routeCoordinates[i];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(point.latitude, point.longitude);
        coords[i] = coord;
        if (CLLocationCoordinate2DIsValid(coord)) {
            [validIndices addObject:@(i)];
        }
    }
    
    MAPolyline *line = [MAPolyline polylineWithCoordinates:coords count:count];
    free(coords);
    
    // 添加起点、终点和途径点标注
    [self addAnnotationsForRoute:route withValidIndices:validIndices toAnnotations:self.rideAnnotations routeType:@"骑行"];
    
    [self.rideRouteLines addObject:line];
    [self.mapView addOverlays:self.rideRouteLines];
    [self.mapView addAnnotations:self.rideAnnotations];
    [self.mapView setVisibleMapRect:[line boundingMapRect] edgePadding:UIEdgeInsetsMake(60, 40, 80, 40) animated:YES];
}

- (void)onRideEmuTap {
    if (!self.rideRouteReady || !self.rideRoute) {
        NSLog(@"Ride route not ready, plan first.");
        return;
    }
    
    // 停止其他导航
    [self stopNavi];
    [self stopWalkNavi];
    [self stopRideNavi];
    
    self.driveView.hidden = YES;
    self.walkView.hidden = YES;
    self.rideView.hidden = NO;
    self.rideView.showUIElements = YES;
    [self.walkManager removeDataRepresentative:self.walkView];
    [self.rideManager addDataRepresentative:self.rideView];
    [self.driveManager removeDataRepresentative:self.driveView];
    
    [self startRideEmulatorNaviWithSpeed:120];
}

- (void)onRideGpsTap {
    if (!self.rideRouteReady || !self.rideRoute) {
        NSLog(@"Ride route not ready, plan first.");
        return;
    }
    
    // 停止其他导航
    [self stopNavi];
    [self stopWalkNavi];
    [self stopRideNavi];
    
    self.driveView.hidden = YES;
    self.walkView.hidden = YES;
    self.rideView.hidden = NO;
    self.rideView.showUIElements = YES;
    [self.walkManager removeDataRepresentative:self.walkView];
    [self.rideManager addDataRepresentative:self.rideView];
    [self.driveManager removeDataRepresentative:self.driveView];
    
    [self startRideGPSNavi];
}

- (void)startRideEmulatorNaviWithSpeed:(int)speed {
    if (!self.rideManager.naviRoute) {
        NSLog(@"Error: rideManager.naviRoute is nil, cannot start ride emulator navigation.");
        return;
    }
    int v = speed > 0 ? speed : 15; // 默认 15 km/h
    NSLog(@"Starting ride emulator navi with speed: %ld km/h, route length: %ld m",
          (long)v, (long)self.rideManager.naviRoute.routeLength);
    [self.rideManager setEmulatorNaviSpeed:v];
    BOOL started = [self.rideManager startEmulatorNavi];
    if (!started) {
        NSLog(@"Error: Failed to start ride emulator navigation.");
    } else {
        NSLog(@"Ride emulator navigation started successfully.");
    }
}

- (void)startRideGPSNavi {
    if (!self.rideManager.naviRoute) { return; }
    [self.rideManager startGPSNavi];
}

- (void)stopRideNavi {
    [self.rideManager stopNavi];
}


// 骑行导航界面关闭按钮点击时的回调函数
- (void)rideViewCloseButtonClicked:(AMapNaviRideView *)rideView{
    if (self.exitNavigationBlcok) {
        self.exitNavigationBlcok();
    }
}



#pragma mark - 公交导航相关
- (void)showTransitRouteOnMapResponse:(AMapRouteSearchResponse *)response {
    
    self.driveView.hidden = YES;
    self.walkView.hidden = YES;
    self.rideView.hidden = YES;
    [self.walkManager removeDataRepresentative:self.walkView];
    [self.rideManager removeDataRepresentative:self.rideView];
    [self.driveManager removeDataRepresentative:self.driveView];
    // 清理旧路线
    [self removeMapViewAnnotationsAndRoutes];
    
    self.transitResponse = response;
    // 选择第一条公交路线进行显示
    self.selectedTransit = response.route.transits.firstObject;
    AMapTransit *transit = self.selectedTransit;
    self.transitRouteReady = YES;

    
    if (!transit || !transit.segments || transit.segments.count == 0) {
        NSLog(@"Transit route is empty or invalid");
        return;
    }
    
    NSLog(@"Processing transit route with %lu segments", (unsigned long)transit.segments.count);
    
    // 用于计算地图显示范围
    NSMutableArray<NSValue *> *allCoords = [NSMutableArray array];
    
    // 遍历所有segment，分别处理不同类型的路段
    for (NSInteger i = 0; i < transit.segments.count; i++) {
        AMapSegment *segment = transit.segments[i];
        
        // 处理步行段（绿色）
        if (segment.walking) {
            NSArray<NSValue *> *walkingCoords = [self extractCoordinatesFromWalking:segment.walking];
            if (walkingCoords.count >= 2) {
                MAPolyline *walkingLine = [self createPolylineFromCoordinates:walkingCoords];
                [self.transitWalkingLines addObject:walkingLine];
                [allCoords addObjectsFromArray:walkingCoords];
                
                //步行起点和终点暂时不用添加标注
                /*
                // 添加步行段的起点和终点标注
                if (segment.walking.origin) {
                    MAPointAnnotation *originAnno = [[MAPointAnnotation alloc] init];
                    originAnno.coordinate = CLLocationCoordinate2DMake(segment.walking.origin.latitude, segment.walking.origin.longitude);
                    originAnno.title = @"步行起点";
                    [self.transitAnnotations addObject:originAnno];
                }
                if (segment.walking.destination) {
                    MAPointAnnotation *destAnno = [[MAPointAnnotation alloc] init];
                    destAnno.coordinate = CLLocationCoordinate2DMake(segment.walking.destination.latitude, segment.walking.destination.longitude);
                    destAnno.title = @"步行终点";
                    [self.transitAnnotations addObject:destAnno];
                }
                 */
            }
        }
        
        // 处理公交段（蓝色）、地铁（红色）
        if (segment.buslines && segment.buslines.count > 0) {
            for (AMapBusLine *busLine in segment.buslines) {
                NSArray<NSValue *> *busCoords = [self extractCoordinatesFromBusLine:busLine];
                if (busCoords.count >= 2) {
                    MAPolyline *busLinePolyline = [self createPolylineFromCoordinates:busCoords];
                    NSString *typeStr = [CheckTool replaceNullValue:busLine.type];
                    if ([typeStr containsString:@"地铁"]) {
                        [self.transitSubways addObject:busLinePolyline];
                    } else {
                        [self.transitBusLines addObject:busLinePolyline];
                    }
                    [allCoords addObjectsFromArray:busCoords];
                }
                
                // 添加公交站点标注
                if (busLine.departureStop) {
                    MAPointAnnotation *depAnno = [[MAPointAnnotation alloc] init];
                    depAnno.coordinate = CLLocationCoordinate2DMake(busLine.departureStop.location.latitude, busLine.departureStop.location.longitude);
                    depAnno.title = busLine.departureStop.name ?: @"公交站";
                    depAnno.subtitle = [NSString stringWithFormat:@"%@ 起点", busLine.name ?: @""];
                    [self.transitAnnotations addObject:depAnno];
                }
                if (busLine.arrivalStop) {
                    MAPointAnnotation *arrAnno = [[MAPointAnnotation alloc] init];
                    arrAnno.coordinate = CLLocationCoordinate2DMake(busLine.arrivalStop.location.latitude, busLine.arrivalStop.location.longitude);
                    arrAnno.title = busLine.arrivalStop.name ?: @"公交站";
                    arrAnno.subtitle = [NSString stringWithFormat:@"%@ 终点", busLine.name ?: @""];
                    [self.transitAnnotations addObject:arrAnno];
                }
                
                // 添加中间站点
                if (busLine.viaBusStops && busLine.viaBusStops.count > 0) {
                    for (AMapBusStop *stop in busLine.viaBusStops) {
                        MAPointAnnotation *stopAnno = [[MAPointAnnotation alloc] init];
                        stopAnno.coordinate = CLLocationCoordinate2DMake(stop.location.latitude, stop.location.longitude);
                        stopAnno.title = stop.name ?: @"公交站";
                        stopAnno.subtitle = busLine.name ?: @"";
                        [self.transitAnnotations addObject:stopAnno];
                    }
                }
            }
        }
        
        // 处理火车段（紫色）
        if (segment.railway) {
            NSArray<NSValue *> *railwayCoords = [self extractCoordinatesFromRailway:segment.railway];
            if (railwayCoords.count >= 2) {
                MAPolyline *railwayLine = [self createPolylineFromCoordinates:railwayCoords];
                [self.transitRailwayLines addObject:railwayLine];
                [allCoords addObjectsFromArray:railwayCoords];
            }
            
            // 添加火车站点标注
            if (segment.railway.departureStation) {
                MAPointAnnotation *depAnno = [[MAPointAnnotation alloc] init];
                depAnno.coordinate = CLLocationCoordinate2DMake(segment.railway.departureStation.location.latitude, segment.railway.departureStation.location.longitude);
                depAnno.title = segment.railway.departureStation.name ?: @"火车站";
                depAnno.subtitle = [NSString stringWithFormat:@"%@ 起点", segment.railway.name ?: @""];
                [self.transitAnnotations addObject:depAnno];
            }
            if (segment.railway.arrivalStation) {
                MAPointAnnotation *arrAnno = [[MAPointAnnotation alloc] init];
                arrAnno.coordinate = CLLocationCoordinate2DMake(segment.railway.arrivalStation.location.latitude, segment.railway.arrivalStation.location.longitude);
                arrAnno.title = segment.railway.arrivalStation.name ?: @"火车站";
                arrAnno.subtitle = [NSString stringWithFormat:@"%@ 终点", segment.railway.name ?: @""];
                [self.transitAnnotations addObject:arrAnno];
            }
            
            // 添加中间站点（如果存在 viaStops 属性）
            if ([segment.railway respondsToSelector:@selector(viaStops)] && segment.railway.viaStops && segment.railway.viaStops.count > 0) {
                for (id stop in segment.railway.viaStops) {
                    if ([stop respondsToSelector:@selector(location)] && [stop respondsToSelector:@selector(name)]) {
                        AMapGeoPoint *location = [stop valueForKey:@"location"];
                        NSString *name = [stop name];
                        MAPointAnnotation *stopAnno = [[MAPointAnnotation alloc] init];
                        stopAnno.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude);
                        stopAnno.title = name ?: @"火车站";
                        stopAnno.subtitle = segment.railway.name ?: @"";
                        [self.transitAnnotations addObject:stopAnno];
                    }
                }
            }
        }
    }
    
    // 将所有路线添加到地图
    NSMutableArray *allOverlays = [NSMutableArray array];
    [allOverlays addObjectsFromArray:self.transitWalkingLines];
    [allOverlays addObjectsFromArray:self.transitBusLines];
    [allOverlays addObjectsFromArray:self.transitSubways];
    [allOverlays addObjectsFromArray:self.transitRailwayLines];
    [self.transitRouteLines addObjectsFromArray:allOverlays];
    
    [self.mapView addOverlays:allOverlays];
    [self.mapView addAnnotations:self.transitAnnotations];
    
    // 计算并设置地图显示范围
    if (allCoords.count > 0) {
        CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * allCoords.count);
        for (NSUInteger i = 0; i < allCoords.count; i++) {
            CLLocationCoordinate2D coord;
            [allCoords[i] getValue:&coord];
            coords[i] = coord;
        }
        MAPolyline *tempLine = [MAPolyline polylineWithCoordinates:coords count:allCoords.count];
        [self.mapView setVisibleMapRect:[tempLine boundingMapRect] edgePadding:UIEdgeInsetsMake(60, 40, 80, 40) animated:YES];
        free(coords);
    }
    
    
    NSLog(@"Adding overlays to map: %lu walking, %lu bus, %lu subway,  %lu railway, total: %lu",
          (unsigned long)self.transitWalkingLines.count,
          (unsigned long)self.transitBusLines.count,
          (unsigned long)self.transitSubways.count,
          (unsigned long)self.transitRailwayLines.count,
          (unsigned long)allOverlays.count);
}

// 从步行段提取坐标
- (NSArray<NSValue *> *)extractCoordinatesFromWalking:(AMapWalking *)walking {
    NSMutableArray<NSValue *> *coords = [NSMutableArray array];
    
    // 从 steps 中提取 polyline
    if (walking.steps && walking.steps.count > 0) {
        for (AMapStep *step in walking.steps) {
            if (step.polyline && step.polyline.length > 0) {
                NSArray<NSValue *> *stepCoords = [self parsePolylineString:step.polyline];
                [coords addObjectsFromArray:stepCoords];
            }
        }
    }
    
    // 如果没有从 steps 中获取到坐标，使用起点和终点
    if (coords.count == 0 && walking.origin && walking.destination) {
        CLLocationCoordinate2D origin = CLLocationCoordinate2DMake(walking.origin.latitude, walking.origin.longitude);
        CLLocationCoordinate2D dest = CLLocationCoordinate2DMake(walking.destination.latitude, walking.destination.longitude);
        [coords addObject:[NSValue valueWithBytes:&origin objCType:@encode(CLLocationCoordinate2D)]];
        [coords addObject:[NSValue valueWithBytes:&dest objCType:@encode(CLLocationCoordinate2D)]];
    }
    
    return coords;
}

// 从公交线路提取坐标
- (NSArray<NSValue *> *)extractCoordinatesFromBusLine:(AMapBusLine *)busLine {
    NSMutableArray<NSValue *> *coords = [NSMutableArray array];
    
    // 优先使用 polyline
    if (busLine.polyline && busLine.polyline.length > 0) {
        NSArray<NSValue *> *polylineCoords = [self parsePolylineString:busLine.polyline];
        [coords addObjectsFromArray:polylineCoords];
    }
    
    // 如果没有 polyline，使用站点坐标构建路线
    if (coords.count == 0) {
        if (busLine.departureStop) {
            CLLocationCoordinate2D dep = CLLocationCoordinate2DMake(busLine.departureStop.location.latitude, busLine.departureStop.location.longitude);
            [coords addObject:[NSValue valueWithBytes:&dep objCType:@encode(CLLocationCoordinate2D)]];
        }
        
        if (busLine.viaBusStops && busLine.viaBusStops.count > 0) {
            for (AMapBusStop *stop in busLine.viaBusStops) {
                CLLocationCoordinate2D stopCoord = CLLocationCoordinate2DMake(stop.location.latitude, stop.location.longitude);
                [coords addObject:[NSValue valueWithBytes:&stopCoord objCType:@encode(CLLocationCoordinate2D)]];
            }
        }
        
        if (busLine.arrivalStop) {
            CLLocationCoordinate2D arr = CLLocationCoordinate2DMake(busLine.arrivalStop.location.latitude, busLine.arrivalStop.location.longitude);
            [coords addObject:[NSValue valueWithBytes:&arr objCType:@encode(CLLocationCoordinate2D)]];
        }
    }
    
    return coords;
}

// 从地铁线路提取坐标
- (NSArray<NSValue *> *)extractCoordinatesFromRailway:(AMapRailway *)railway {
    NSMutableArray<NSValue *> *coords = [NSMutableArray array];
    
    // 地铁线路通常没有直接的 polyline，使用站点坐标
    if (railway.departureStation) {
        CLLocationCoordinate2D dep = CLLocationCoordinate2DMake(railway.departureStation.location.latitude, railway.departureStation.location.longitude);
        [coords addObject:[NSValue valueWithBytes:&dep objCType:@encode(CLLocationCoordinate2D)]];
    }
    
    // 尝试获取中间站点（使用运行时检查，因为类名可能不同）
    if ([railway respondsToSelector:@selector(viaStops)] && railway.viaStops && railway.viaStops.count > 0) {
        for (id stop in railway.viaStops) {
            if ([stop respondsToSelector:@selector(location)]) {
                AMapGeoPoint *location = [stop valueForKey:@"location"];
                CLLocationCoordinate2D stopCoord = CLLocationCoordinate2DMake(location.latitude, location.longitude);
                [coords addObject:[NSValue valueWithBytes:&stopCoord objCType:@encode(CLLocationCoordinate2D)]];
            }
        }
    }
    
    if (railway.arrivalStation) {
        CLLocationCoordinate2D arr = CLLocationCoordinate2DMake(railway.arrivalStation.location.latitude, railway.arrivalStation.location.longitude);
        [coords addObject:[NSValue valueWithBytes:&arr objCType:@encode(CLLocationCoordinate2D)]];
    }
    
    return coords;
}

// 从坐标数组创建 polyline
- (MAPolyline *)createPolylineFromCoordinates:(NSArray<NSValue *> *)coords {
    if (coords.count < 2) {
        return nil;
    }
    
    CLLocationCoordinate2D *coordsArray = malloc(sizeof(CLLocationCoordinate2D) * coords.count);
    for (NSUInteger i = 0; i < coords.count; i++) {
        CLLocationCoordinate2D coord;
        [coords[i] getValue:&coord];
        coordsArray[i] = coord;
    }
    
    MAPolyline *line = [MAPolyline polylineWithCoordinates:coordsArray count:coords.count];
    free(coordsArray);
    
    return line;
}

// 解析 polyline 字符串
- (NSArray<NSValue *> *)parsePolylineString:(NSString *)polylineString {
    NSMutableArray<NSValue *> *coords = [NSMutableArray array];
    
    if (!polylineString || polylineString.length == 0) {
        return coords;
    }
    
    // 高德地图的 polyline 格式通常是 "lng1,lat1;lng2,lat2;..."
    NSArray<NSString *> *points = [polylineString componentsSeparatedByString:@";"];
    
    if (points.count > 1) {
        for (NSString *pointStr in points) {
            NSString *trimmedPoint = [pointStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (trimmedPoint.length == 0) continue;
            
            NSArray<NSString *> *latLng = [trimmedPoint componentsSeparatedByString:@","];
            if (latLng.count == 2) {
                double lng = [latLng[0] doubleValue];
                double lat = [latLng[1] doubleValue];
                if (fabs(lat) <= 90 && fabs(lng) <= 180 && (lat != 0 || lng != 0)) {
                    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lng);
                    [coords addObject:[NSValue valueWithBytes:&coord objCType:@encode(CLLocationCoordinate2D)]];
                }
            }
        }
    } else {
        // 尝试空格分隔
        points = [polylineString componentsSeparatedByString:@" "];
        for (NSString *pointStr in points) {
            NSString *trimmedPoint = [pointStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (trimmedPoint.length == 0) continue;
            
            NSArray<NSString *> *latLng = [trimmedPoint componentsSeparatedByString:@","];
            if (latLng.count == 2) {
                double lng = [latLng[0] doubleValue];
                double lat = [latLng[1] doubleValue];
                if (fabs(lat) <= 90 && fabs(lng) <= 180 && (lat != 0 || lng != 0)) {
                    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lng);
                    [coords addObject:[NSValue valueWithBytes:&coord objCType:@encode(CLLocationCoordinate2D)]];
                }
            }
        }
    }
    
    return coords;
}

- (void)onTransitEmuTap {
    if (!self.transitRouteReady || !self.selectedTransit) {
        NSLog(@"Transit route not ready, plan first.");
        return;
    }
    // 停止其他导航
    [self stopNavi];
    [self stopWalkNavi];
    [self stopRideNavi];
    
    // 开始公交导航
    self.isTransitNavigating = YES;
    self.currentTransitSegmentIndex = 0;
    self.currentTransitStopIndex = 0;
    
    // 显示地图视图
    self.mapView.hidden = NO;
    self.driveView.hidden = YES;
    self.walkView.hidden = YES;
    self.rideView.hidden = YES;
    
    // 开始导航第一个segment
    [self startTransitSegmentNavigation:0 isEmulator:YES];
}

- (void)onTransitGpsTap {
    if (!self.transitRouteReady || !self.selectedTransit) {
        NSLog(@"Transit route not ready, plan first.");
        return;
    }
    
    // 请求定位权限
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    // 停止其他导航
    [self stopNavi];
    [self stopWalkNavi];
    [self stopRideNavi];
    
    // 开始公交导航
    self.isTransitNavigating = YES;
    self.currentTransitSegmentIndex = 0;
    self.currentTransitStopIndex = 0;
    
    // 显示地图视图
    self.mapView.hidden = NO;
    self.driveView.hidden = YES;
    self.walkView.hidden = YES;
    self.rideView.hidden = YES;
    
    // 开始位置跟踪
    [self.locationManager startUpdatingLocation];
    
    // 开始导航第一个segment
    [self startTransitSegmentNavigation:0 isEmulator:NO];
}

// 开始导航指定的segment
- (void)startTransitSegmentNavigation:(NSInteger)segmentIndex isEmulator:(BOOL)isEmulator {
    if (!self.selectedTransit || segmentIndex >= self.selectedTransit.segments.count) {
        NSLog(@"Transit navigation completed!");
        [self transitNavigationCompleted];
        return;
    }
    
    self.currentTransitSegmentIndex = segmentIndex;
    AMapSegment *segment = self.selectedTransit.segments[segmentIndex];
    
    // 如果是步行段，使用步行导航
    if (segment.walking) {
        NSLog(@"Starting walking segment %ld", (long)segmentIndex);
        CLLocationCoordinate2D start = CLLocationCoordinate2DMake(segment.walking.origin.latitude, segment.walking.origin.longitude);
        CLLocationCoordinate2D end = CLLocationCoordinate2DMake(segment.walking.destination.latitude, segment.walking.destination.longitude);
        
        [[AMapNavigationManager shared] planWalkingFrom:start to:end completion:^(AMapNaviRoute * _Nullable route, NSError * _Nullable error) {
            if (error || !route) {
                NSLog(@"Failed to plan walking segment: %@", error.localizedDescription);
                [self transitSegmentCompleted]; // 跳过这个segment
                return;
            }
            
            self.walkView.hidden = NO;
            self.driveView.hidden = YES;
            self.rideView.hidden = YES;
            
            self.walkView.showUIElements = YES;
            [self.walkManager addDataRepresentative:self.walkView];
            [self.driveManager removeDataRepresentative:self.driveView];
            [self.rideManager removeDataRepresentative:self.rideView];
            
            if (isEmulator) {
                [self startWalkEmulatorNaviWithSpeed:120];
            } else {
                [self startWalkGPSNavi];
            }
        }];
    } else if (segment.buslines && segment.buslines.count > 0) {
        // 公交段，显示提示信息
        NSLog(@"Starting bus segment %ld", (long)segmentIndex);
        AMapBusLine *busLine = segment.buslines.firstObject;
        [self showTransitNavigationInfo:[NSString stringWithFormat:@"请乘坐 %@", busLine.name ?: @"公交车"]
                            detail:[NSString stringWithFormat:@"从 %@ 到 %@",
                                    busLine.departureStop.name ?: @"起点",
                                    busLine.arrivalStop.name ?: @"终点"]];
        
        // 开始跟踪位置，检测是否到达站点
        self.currentTransitStopIndex = 0;
        // 对于公交段，使用位置跟踪来判断是否到达站点
    } else if (segment.railway) {
        // 地铁段，显示提示信息
        NSLog(@"Starting railway segment %ld", (long)segmentIndex);
        [self showTransitNavigationInfo:[NSString stringWithFormat:@"请乘坐 %@", segment.railway.name ?: @"火车"]
                            detail:[NSString stringWithFormat:@"从 %@ 到 %@",
                                    segment.railway.departureStation.name ?: @"起点",
                                    segment.railway.arrivalStation.name ?: @"终点"]];
        
        // 开始跟踪位置，检测是否到达站点
        self.currentTransitStopIndex = 0;
    }
}

// Segment完成，继续下一个
- (void)transitSegmentCompleted {
    NSInteger nextSegmentIndex = self.currentTransitSegmentIndex + 1;
    
    // 停止当前导航
    [[AMapNavigationManager shared] stopWalkNavi];
    self.mapView.hidden = NO;
    self.walkView.hidden = YES;
    
    // 继续下一个segment
    if (nextSegmentIndex < self.selectedTransit.segments.count) {
        // 判断下一个segment的类型，如果是公交/地铁段，需要等待用户到达站点
        AMapSegment *nextSegment = self.selectedTransit.segments[nextSegmentIndex];
        if (nextSegment.walking) {
            // 下一个是步行段，直接开始导航
            [self startTransitSegmentNavigation:nextSegmentIndex isEmulator:self.isTransitNavigating];
        } else {
            // 下一个是公交/地铁段，显示提示信息
            [self showTransitNavigationInfo:@"请前往站点" detail:@"准备乘坐下一段交通工具"];
        }
    } else {
        // 所有segment完成
        [self transitNavigationCompleted];
    }
}

// 公交导航完成
- (void)transitNavigationCompleted {
    self.isTransitNavigating = NO;
    [self.locationManager stopUpdatingLocation];
    [self showTransitNavigationInfo:@"导航完成" detail:@"已到达目的地"];
    
    // 3秒后隐藏提示
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideTransitNavigationInfo];
    });
}

// 显示导航提示信息（可以用Alert或自定义View）
- (void)showTransitNavigationInfo:(NSString *)title detail:(NSString *)detail {
    NSLog(@"Transit Navigation: %@ - %@", title, detail);
    // 这里可以显示一个自定义的提示视图，或者使用Alert
    // 为了简单，这里只打印日志，你可以根据需要添加UI
}

- (void)hideTransitNavigationInfo {
    // 隐藏提示信息
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (!self.isTransitNavigating || !self.selectedTransit) {
        return;
    }
    
    CLLocation *currentLocation = locations.lastObject;
    if (!currentLocation) {
        return;
    }
    
    // 检查当前segment
    if (self.currentTransitSegmentIndex >= self.selectedTransit.segments.count) {
        return;
    }
    
    AMapSegment *currentSegment = self.selectedTransit.segments[self.currentTransitSegmentIndex];
    
    // 如果是公交段，检测是否到达站点
    if (currentSegment.buslines && currentSegment.buslines.count > 0) {
        AMapBusLine *busLine = currentSegment.buslines.firstObject;
        [self checkIfArrivedAtStop:currentLocation forBusLine:busLine];
    }
    
    // 如果是地铁段，检测是否到达站点
    if (currentSegment.railway) {
        [self checkIfArrivedAtStop:currentLocation forRailway:currentSegment.railway];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location update failed: %@", error.localizedDescription);
}

// 检测是否到达公交站点
- (void)checkIfArrivedAtStop:(CLLocation *)location forBusLine:(AMapBusLine *)busLine {
    // 检查是否到达终点站
    if (busLine.arrivalStop && busLine.arrivalStop.location) {
        CLLocation *arrivalLocation = [[CLLocation alloc] initWithLatitude:busLine.arrivalStop.location.latitude
                                                                 longitude:busLine.arrivalStop.location.longitude];
        CLLocationDistance distance = [location distanceFromLocation:arrivalLocation];
        
        if (distance < 100) { // 100米内认为到达
            NSLog(@"Arrived at bus stop: %@", busLine.arrivalStop.name);
            [self showTransitNavigationInfo:@"已到达站点" detail:[NSString stringWithFormat:@"%@", busLine.arrivalStop.name]];
            // 完成当前公交段
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self transitSegmentCompleted];
            });
            return;
        }
    }
    
    // 检查是否到达中间站点（可选，用于提示）
    if (busLine.viaBusStops && busLine.viaBusStops.count > 0 && self.currentTransitStopIndex < busLine.viaBusStops.count) {
        AMapBusStop *nextStop = busLine.viaBusStops[self.currentTransitStopIndex];
        if (nextStop && nextStop.location) {
            CLLocation *stopLocation = [[CLLocation alloc] initWithLatitude:nextStop.location.latitude
                                                                  longitude:nextStop.location.longitude];
            CLLocationDistance distance = [location distanceFromLocation:stopLocation];
            
            if (distance < 100) {
                NSLog(@"Arrived at via stop: %@", nextStop.name);
                self.currentTransitStopIndex++;
                [self showTransitNavigationInfo:@"到达站点" detail:[NSString stringWithFormat:@"%@", nextStop.name]];
            }
        }
    }
}

// 检测是否到达地铁站点
- (void)checkIfArrivedAtStop:(CLLocation *)location forRailway:(AMapRailway *)railway {
    // 检查是否到达终点站
    if (railway.arrivalStation && railway.arrivalStation.location) {
        CLLocation *arrivalLocation = [[CLLocation alloc] initWithLatitude:railway.arrivalStation.location.latitude
                                                                 longitude:railway.arrivalStation.location.longitude];
        CLLocationDistance distance = [location distanceFromLocation:arrivalLocation];
        
        if (distance < 100) { // 100米内认为到达
            NSLog(@"Arrived at railway stop: %@", railway.arrivalStation.name);
            [self showTransitNavigationInfo:@"已到达站点" detail:[NSString stringWithFormat:@"%@", railway.arrivalStation.name]];
            // 完成当前地铁段
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self transitSegmentCompleted];
            });
            return;
        }
    }
    
    // 检查是否到达中间站点（可选）
    if ([railway respondsToSelector:@selector(viaStops)] && railway.viaStops && railway.viaStops.count > 0) {
        if (self.currentTransitStopIndex < railway.viaStops.count) {
            id nextStop = railway.viaStops[self.currentTransitStopIndex];
            if ([nextStop respondsToSelector:@selector(valueForKey:)]) {
                AMapGeoPoint *stopLocation = [nextStop valueForKey:@"location"];
                if (stopLocation && [stopLocation isKindOfClass:[AMapGeoPoint class]]) {
                    CLLocation *locationObj = [[CLLocation alloc] initWithLatitude:stopLocation.latitude
                                                                        longitude:stopLocation.longitude];
                    CLLocationDistance distance = [location distanceFromLocation:locationObj];
                    
                    if (distance < 100) {
                        NSString *stopName = [nextStop valueForKey:@"name"];
                        NSLog(@"Arrived at via stop: %@", stopName);
                        self.currentTransitStopIndex++;
                        [self showTransitNavigationInfo:@"到达站点" detail:stopName ?: @"地铁站"];
                    }
                }
            }
        }
    }
}

#pragma mark - Map Overlay Renderer

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineRenderer *renderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        renderer.lineWidth = 6.f;
        // 步行路线蓝色，骑行路线绿色
        // 公交路线：步行段绿色，公交段蓝色，地铁段紫色
        if ([self.driveRouteLines containsObject:(MAPolyline *)overlay]) {
            renderer.strokeColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:0.9]; // 橙色 - 驾车路线
        } else if ([self.walkRouteLines containsObject:(MAPolyline *)overlay]) {
            renderer.strokeColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:0.9]; // 蓝色
        } else if ([self.rideRouteLines containsObject:(MAPolyline *)overlay]) {
            renderer.strokeColor = [UIColor colorWithRed:0.1 green:0.8 blue:0.4 alpha:0.9]; // 绿色
        } else if ([self.transitWalkingLines containsObject:(MAPolyline *)overlay]) {
            renderer.strokeColor = [UIColor colorWithRed:0.1 green:0.8 blue:0.4 alpha:0.9]; // 绿色 - 公交路线中的步行段
        } else if ([self.transitBusLines containsObject:(MAPolyline *)overlay]) {
            renderer.strokeColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:0.9]; // 蓝色 - 公交段
        }else if ([self.transitSubways containsObject:(MAPolyline *)overlay]) {
            renderer.strokeColor = [UIColor redColor]; // 红色 - 地铁段
        } else if ([self.transitRailwayLines containsObject:(MAPolyline *)overlay]) {
            renderer.strokeColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.8 alpha:1.0]; // 紫色 - 火车段
        } else {
            renderer.strokeColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:0.9]; // 默认蓝色
        }
        renderer.lineJoinType = kMALineJoinRound;
        renderer.lineCapType = kMALineCapRound;
        return renderer;
    }
    return nil;
}

#pragma mark - Map Annotation View

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        //static NSString *reuseIdentifier = @"TransitAnnotation";
        static NSString *reuseIdentifier = @"NavigationAnnotation";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
        if (!annotationView) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
            annotationView.canShowCallout = YES;
            annotationView.animatesDrop = YES;
        }
        
        // 根据标注类型设置不同的颜色
        MAPointAnnotation *pointAnno = (MAPointAnnotation *)annotation;
        NSString *title = pointAnno.title ?: @"";
        NSString *subtitle = pointAnno.subtitle ?: @"";
        if ([title containsString:@"地铁"] || [subtitle containsString:@"地铁"]) {
            annotationView.pinColor = MAPinAnnotationColorRed; // 红色 - 地铁站
        } else if ([title containsString:@"公交"] || [subtitle containsString:@"公交"]) {
            annotationView.pinColor = MAPinAnnotationColorPurple; // 紫色 - 公交站
        } else if ([title containsString:@"步行"] || [subtitle containsString:@"步行"]) {
            annotationView.pinColor = MAPinAnnotationColorGreen; // 绿色 - 步行
            // 从下面开始是驾车、步行、骑行三个导航的标注
        } else if ([title containsString:@"步行起点"]) {
            annotationView.pinColor = MAPinAnnotationColorGreen; // 绿色 - 步行起点
        } else if ([title containsString:@"步行终点"]) {
            annotationView.pinColor = MAPinAnnotationColorGreen; // 绿色 - 步行终点
        } else if ([title containsString:@"步行途径点"]) {
            annotationView.pinColor = MAPinAnnotationColorGreen; // 绿色 - 步行途径点
        } else if ([title containsString:@"驾车起点"]) {
            annotationView.pinColor = MAPinAnnotationColorRed; // 红色 - 驾车起点
        } else if ([title containsString:@"驾车终点"]) {
            annotationView.pinColor = MAPinAnnotationColorRed; // 红色 - 驾车终点
        } else if ([title containsString:@"驾车途径点"]) {
            annotationView.pinColor = MAPinAnnotationColorRed; // 红色 - 驾车途径点
        } else if ([title containsString:@"骑行起点"]) {
            annotationView.pinColor = MAPinAnnotationColorGreen; // 绿色 - 骑行起点
        } else if ([title containsString:@"骑行终点"]) {
            annotationView.pinColor = MAPinAnnotationColorGreen; // 绿色 - 骑行终点
        } else if ([title containsString:@"骑行途径点"]) {
            annotationView.pinColor = MAPinAnnotationColorGreen; // 绿色 - 骑行途径点
        } else {
            annotationView.pinColor = MAPinAnnotationColorRed; // 默认红色
        }
        
        return annotationView;
    }
    return nil;
}


// 辅助方法：为路线添加起点、终点和途径点标注
- (void)addAnnotationsForRoute:(AMapNaviRoute *)route
               withValidIndices:(NSArray<NSNumber *> *)validIndices
                  toAnnotations:(NSMutableArray<MAPointAnnotation *> *)annotations
                      routeType:(NSString *)routeType {
    if (!route || !route.routeCoordinates || validIndices.count == 0) { return; }
    
    // 获取第一个有效点作为起点
    NSInteger firstIndex = validIndices.firstObject.integerValue;
    if (firstIndex < route.routeCoordinates.count) {
        AMapNaviPoint *startPoint = route.routeCoordinates[firstIndex];
        MAPointAnnotation *startAnno = [[MAPointAnnotation alloc] init];
        startAnno.coordinate = CLLocationCoordinate2DMake(startPoint.latitude, startPoint.longitude);
        startAnno.title = [NSString stringWithFormat:@"%@起点", routeType];
        [annotations addObject:startAnno];
    }
    
    // 获取最后一个有效点作为终点
    NSInteger lastIndex = validIndices.lastObject.integerValue;
    if (lastIndex < route.routeCoordinates.count && lastIndex != firstIndex) {
        AMapNaviPoint *endPoint = route.routeCoordinates[lastIndex];
        MAPointAnnotation *endAnno = [[MAPointAnnotation alloc] init];
        endAnno.coordinate = CLLocationCoordinate2DMake(endPoint.latitude, endPoint.longitude);
        endAnno.title = [NSString stringWithFormat:@"%@终点", routeType];
        [annotations addObject:endAnno];
    }
    
    // 检查是否有途径点（wayPoints）
    // 尝试通过KVC或其他方式获取途径点
    id wayPoints = nil;
    if ([route respondsToSelector:@selector(wayPoints)]) {
        wayPoints = [route valueForKey:@"wayPoints"];
    } else if ([route respondsToSelector:@selector(waypoints)]) {
        wayPoints = [route valueForKey:@"waypoints"];
    }
    
    if (wayPoints && [wayPoints isKindOfClass:[NSArray class]] && [wayPoints count] > 0) {
        for (id wayPoint in (NSArray *)wayPoints) {
            if ([wayPoint isKindOfClass:[AMapNaviPoint class]]) {
                AMapNaviPoint *point = (AMapNaviPoint *)wayPoint;
                MAPointAnnotation *wayAnno = [[MAPointAnnotation alloc] init];
                wayAnno.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude);
                wayAnno.title = [NSString stringWithFormat:@"%@途径点", routeType];
                [annotations addObject:wayAnno];
            }
        }
    }
}

#pragma mark - Ride Delegate

- (void)rideManagerOnCalculateRouteSuccess:(AMapNaviRideManager *)rideManager {
    if (self.rideCompletion) {
        self.rideCompletion(rideManager.naviRoute, nil);
    }
}

- (void)rideManager:(AMapNaviRideManager *)rideManager onCalculateRouteFailure:(NSError *)error {
    if (self.rideCompletion) {
        self.rideCompletion(nil, error);
    }
}

#pragma mark - Transit Delegate

- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    if (self.transitCompletion) {
        self.transitCompletion(response, nil);
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    if ([request isKindOfClass:[AMapTransitRouteSearchRequest class]]) {
        if (self.transitCompletion) {
            self.transitCompletion(nil, error);
        }
    } else if ([request isKindOfClass:[AMapReGeocodeSearchRequest class]]) {
        if (self.locationAddressCompletion) {
            self.locationAddressCompletion(nil, kCLLocationCoordinate2DInvalid, error);
            self.locationAddressCompletion = nil;
        }
    }
}

#pragma mark - 方法

- (void)removeMapViewAnnotationsAndRoutes{
    // 清理旧路线和标注
    if (self.transitRouteLines.count) {
        [self.mapView removeOverlays:self.transitRouteLines];
        [self.transitRouteLines removeAllObjects];
    }
    if (self.transitWalkingLines.count) {
        [self.mapView removeOverlays:self.transitWalkingLines];
        [self.transitWalkingLines removeAllObjects];
    }
    if (self.transitBusLines.count) {
        [self.mapView removeOverlays:self.transitBusLines];
        [self.transitBusLines removeAllObjects];
    }
    if (self.transitSubways.count) {
        [self.mapView removeOverlays:self.transitSubways];
        [self.transitSubways removeAllObjects];
    }
    if (self.transitRailwayLines.count) {
        [self.mapView removeOverlays:self.transitRailwayLines];
        [self.transitRailwayLines removeAllObjects];
    }
    if (self.transitAnnotations.count) {
        [self.mapView removeAnnotations:self.transitAnnotations];
        [self.transitAnnotations removeAllObjects];
    }
    
    if (self.driveAnnotations.count) {
        [self.mapView removeAnnotations:self.driveAnnotations];
        [self.driveAnnotations removeAllObjects];
    }
    if (self.walkAnnotations.count) {
        [self.mapView removeAnnotations:self.walkAnnotations];
        [self.walkAnnotations removeAllObjects];
    }
    if (self.rideAnnotations.count) {
        [self.mapView removeAnnotations:self.rideAnnotations];
        [self.rideAnnotations removeAllObjects];
    }
    
    // 清理驾车路线（如果存在）
    if (self.driveRouteLines.count) {
        [self.mapView removeOverlays:self.driveRouteLines];
        [self.driveRouteLines removeAllObjects];
    }
    
    // 清理步行路线（如果存在）
    if (self.walkRouteLines.count) {
        [self.mapView removeOverlays:self.walkRouteLines];
        [self.walkRouteLines removeAllObjects];
    }
    // 清理骑行路线（如果存在）
    if (self.rideRouteLines.count) {
        [self.mapView removeOverlays:self.rideRouteLines];
        [self.rideRouteLines removeAllObjects];
    }
}

#pragma mark - 懒加载

- (MAMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:[TabBarViewController takeCurrentVC].view.bounds];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        _mapView.zoomLevel = 16;
        _mapView.showTraffic = YES;
        _mapView.compassOrigin = CGPointMake(-55, navBarHeight+15);
    }
    return _mapView;
}

- (AMapNaviDriveView*)driveView{
    if (!_driveView) {
        _driveView = [[AMapNaviDriveView alloc] initWithFrame:[TabBarViewController takeCurrentVC].view.bounds];
        _driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _driveView.showVectorline = NO;
        _driveView.delegate = self;
        _driveView.showCar = YES;        // 是否显示小车车标
        _driveView.showBackupRoute = YES; // 是否显示多路线
        _driveView.showUIElements = NO;
        _driveView.showGreyAfterPass = YES;
        _driveView.autoZoomMapLevel = YES;
        _driveView.showMoreButton = NO;
        _driveView.hidden = YES;
    }
    return _driveView;
}

- (AMapNaviDriveManager *)driveManager {
    if (!_driveManager) {
        _driveManager = [AMapNaviDriveManager sharedInstance];
        _driveManager.detectedMode = AMapNaviDetectedModeCameraAndSpecialRoad;
        [_driveManager setDelegate:self];
        [_driveManager setMultipleRouteNaviMode:YES];
        [_driveManager setPausesLocationUpdatesAutomatically:NO];
        [_driveManager setAllowsBackgroundLocationUpdates:YES];
    }
    return _driveManager;
}

- (AMapNaviWalkManager *)walkManager {
    if (!_walkManager) {
        _walkManager = [AMapNaviWalkManager sharedInstance];
        _walkManager.delegate = self;
    }
    return _walkManager;
}

- (AMapNaviWalkView *)walkView{
    if (!_walkView) {
        _walkView = [[AMapNaviWalkView alloc] initWithFrame:[TabBarViewController takeCurrentVC].view.bounds];
        _walkView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _walkView.delegate = self;
        _walkView.showUIElements = NO;
        _walkView.showGreyAfterPass = YES;
        _walkView.showMoreButton = NO;
        //_walkView.cameraDegree = 0;
        //_walkView.screenAnchor = CGPointMake(0.5, 0.5);
        _walkView.hidden = YES;
    }
    return _walkView;
}

- (AMapNaviRideView *)rideView{
    if (!_rideView) {
        _rideView = [[AMapNaviRideView alloc] initWithFrame:[TabBarViewController takeCurrentVC].view.bounds];
        _rideView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _rideView.delegate = self;
        _rideView.showUIElements = NO;
        _rideView.showGreyAfterPass = YES;
        //_rideView.cameraDegree = 0;
        //_rideView.screenAnchor = CGPointMake(0.5, 0.5);
        _rideView.hidden = YES;
    }
    return _rideView;
}

- (AMapNaviRideManager *)rideManager {
    if (!_rideManager) {
        _rideManager = [AMapNaviRideManager sharedInstance];
        _rideManager.delegate = self;
    }
    return _rideManager;
}

- (void)teardown {
    
    // 停止所有导航并释放委托
    [self stopNavi];
    self.driveManager.delegate = nil;
    self.driveView.delegate = nil;
    
    [self stopWalkNavi];
    self.walkView.delegate = nil;
    self.driveManager.delegate = nil;
    
    [self onRideGpsTap];
    self.rideManager.delegate = nil;
    self.rideView.delegate = nil;
    
    self.searchAPI.delegate = nil;
    self.searchAPI = nil;
    
    self.driveCompletion = nil;
    self.walkCompletion = nil;
    self.rideCompletion = nil;
    self.transitCompletion = nil;
    
    [self.driveView removeFromSuperview];
    [self.walkView removeFromSuperview];
    [self.rideView removeFromSuperview];
    
    // 停止公交导航
    if (self.isTransitNavigating) {
        [self.locationManager stopUpdatingLocation];
        self.isTransitNavigating = NO;
    }

}

@end
