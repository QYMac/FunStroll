//
//  MapAddressView.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/3.
//

#import "MapAddressView.h"
#import "MAPCustomPointAnnotation.h"

@interface MapAddressView ()<MAMapViewDelegate,AMapSearchDelegate,AMapNaviDriveManagerDelegate, AMapNaviDriveViewDelegate>

@property (nonatomic,strong) MAMapView *mapView;
@property (nonatomic,strong) AMapSearchAPI *searchAPI;
@property (nonatomic,strong) AMapNaviDriveManager *driveManager;
@property (nonatomic,strong) AMapNaviDriveView *driveView;

@end

@implementation MapAddressView

#pragma mark -- 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
        self.backgroundColor = [UIColor whiteColor];
        [self setupMapView];// 高德地图
        [self setupNotification];// 通知
    }
    
    return self;
}

- (void)setupNotification{
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToCurrentLocation) name:kCurrentLocation object:nil];
}

- (void)setupMapView{
    
    [self insertSubview:self.mapView atIndex:0];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
}

// 添加不同类型标注
- (void)addDifferentTypeAnnotations{
    // 保存当前地图区域
    MACoordinateRegion currentRegion = self.mapView.region;
    
    // 创建多个标注（以当前位置为中心）
    NSMutableArray *annotations =[NSMutableArray array];
    NSMutableArray *locations =[NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        NSDictionary *dict;
        if (i == 0) {
            dict = @{@"type": @"1", @"name": @"趣游景点01", @"lat": [NSString stringWithFormat:@"%f",currentRegion.center.latitude+0.001], @"lon": [NSString stringWithFormat:@"%f",currentRegion.center.longitude+0.001]};
        } else if (i == 1){
            dict = @{@"type": @"2", @"name": @"趣游美食01", @"lat": [NSString stringWithFormat:@"%f",currentRegion.center.latitude + 0.001], @"lon": [NSString stringWithFormat:@"%f",currentRegion.center.longitude + -0.001]};
        } else if (i == 2){
            dict = @{@"type": @"1", @"name": @"趣游景点02", @"lat": [NSString stringWithFormat:@"%f",currentRegion.center.latitude + -0.001], @"lon": [NSString stringWithFormat:@"%f",currentRegion.center.longitude + 0.001]};
        } else if (i == 3){
            dict = @{@"type": @"2", @"name": @"趣游美食02", @"lat": [NSString stringWithFormat:@"%f",currentRegion.center.latitude + -0.001], @"lon": [NSString stringWithFormat:@"%f",currentRegion.center.longitude + -0.001]};
        }
        [locations addObject:dict];
    }
    
    for (NSDictionary *location in locations) {
        if (![self isCustomAnnotationExist:[CheckTool replaceNullValue:location[@"type"]]]) {
            MAPCustomPointAnnotation *annotationView = [[MAPCustomPointAnnotation alloc] init];
            annotationView.coordinate = CLLocationCoordinate2DMake(
                [location[@"lat"] doubleValue],
                [location[@"lon"] doubleValue]
            );
            annotationView.title = [CheckTool replaceNullValue:location[@"name"]];
            //annotationView.subtitle = location[@"subtitle"];
            annotationView.annotationType = [location[@"type"] integerValue];
            annotationView.annotationId = [CheckTool replaceNullValue:location[@"type"]];
            if (self.mapAnnotationType == AnnotationTypeScenic &&[location[@"type"] integerValue] == 1) {
                [annotations addObject:annotationView];
            }else if(self.mapAnnotationType == AnnotationTypesDelicious &&[location[@"type"] integerValue] == 2){
                [annotations addObject:annotationView];
            } else if (self.mapAnnotationType == AnnotationTypeAll){
                [annotations addObject:annotationView];
            }
        } else {
            NSLog(@"标注已存在-%@",[CheckTool replaceNullValue:location[@"name"]]);
        }
    }
    
    // 批量添加标注
    [self.mapView addAnnotations:annotations];
    // 保持地图不移动
    [self.mapView setRegion:currentRegion animated:NO];
    //[self.mapView showAnnotations:annotations animated:YES]; // 自动调整地图显示所有标注
    
}

// 检查标注是否已存在
- (BOOL)isCustomAnnotationExist:(NSString *)annotationId {
    for (id<MAAnnotation> annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[MAPCustomPointAnnotation class]]) {
            MAPCustomPointAnnotation *customAnnotation = (MAPCustomPointAnnotation *)annotation;
            if ([customAnnotation.annotationId isEqualToString:annotationId] && ![[CheckTool replaceNullValue:annotationId] isEqualToString:@""]) {
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark - MAMapViewDelegate
// 地图初始化完成回调（地图视图加载完成）
- (void)mapViewDidFinishLoadingMap:(MAMapView *)mapView {
    //[self addDifferentTypeAnnotations];
}

// 地图渲染完成回调（地图样式渲染完成）
- (void)mapViewDidFinishRenderingMap:(MAMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    if (fullyRendered) {
        // 地图完全渲染完成，可以执行相关操作
        
    }
}

// 实现代理方法设置标注样式
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    // 用户位置标注 - 返回nil使用系统默认样式
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil; // 返回nil，系统会使用默认的用户位置样式
    }
    
    // 自定义点标注
    if ([annotation isKindOfClass:[MAPCustomPointAnnotation class]]) {
        MAPCustomPointAnnotation *customAnnotation = (MAPCustomPointAnnotation *)annotation;
        static NSString *pointReuseIndentifier = @"customPointAnnotation";
        // 使用MAAnnotationView而不是MAPinAnnotationView，避免与系统样式冲突
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
            
            // 基础配置
            annotationView.canShowCallout = NO;    // 允许显示气泡
            annotationView.draggable = NO;          // 是否可拖动
            // 根据类型设置不同图片
            switch (customAnnotation.annotationType) {
                case 0:
                    annotationView.image = [UIImage imageNamed:@"addressJD"];
                    break;
                case 1:
                    annotationView.image = [UIImage imageNamed:@"addressJD"];
                    break;
                case 2:
                    annotationView.image = [UIImage imageNamed:@"addressMS"];
                    break;
            }
            // 调整标注位置
            annotationView.centerOffset = CGPointMake(annotationView.image.size.width / 2, -annotationView.image.size.height / 2);
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    
    return nil;
}

// 点击标注事件
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    MAPCustomPointAnnotation *customAnnotation = (MAPCustomPointAnnotation *)view.annotation;
    NSLog(@"选中标注: %@", customAnnotation.title);
//    if (self.didSelectAnnotationViewBlcok) {
//        self.didSelectAnnotationViewBlcok(customAnnotation.annotationId);
//    }
    
    // 遍历所有选中的标注并取消选中
    NSArray *selectedAnnotations = [self.mapView.selectedAnnotations copy];
    for (id<MAAnnotation> annotation in selectedAnnotations) {
        [self.mapView deselectAnnotation:annotation animated:YES];
    }
}

// 处理气泡按钮点击事件
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    MAPointAnnotation *annotation = (MAPointAnnotation *)view.annotation;
    NSLog(@"点击了标注详情: %@", annotation.title);
    
    // 跳转到详情页面或其他操作
    
}

#pragma mark - 通知方法

// 定位到当前位置
- (void)moveToCurrentLocation{
    // 显示用户位置
    self.mapView.showsUserLocation = YES;
    // 设置跟踪模式
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    // 可选：设置缩放级别
    self.mapView.zoomLevel = 16.0;
}

- (void)removeAllCustomAnnotations{
    if (self.mapAnnotationType == AnnotationTypeAll) {
        // 全部添加回来
        [self addDifferentTypeAnnotations];
    } else {
        for (id<MAAnnotation> annotation in self.mapView.annotations) {
            if ([annotation isKindOfClass:[MAPCustomPointAnnotation class]]) {
                MAPCustomPointAnnotation *customAnnotation = (MAPCustomPointAnnotation *)annotation;
                
                if (self.mapAnnotationType == AnnotationTypeScenic && customAnnotation.annotationType == 2){
                    // 只显示景点
                    [self.mapView removeAnnotation:customAnnotation];
                    [self addDifferentTypeAnnotations];
                } else if (self.mapAnnotationType == AnnotationTypesDelicious && customAnnotation.annotationType == 1){
                    // 只显示美食
                    [self.mapView removeAnnotation:customAnnotation];
                    [self addDifferentTypeAnnotations];
                }
            }
        }
    }
}

// 更换地图图层
- (void)changeMapLayerClickIndex:(NSInteger)index{
    
    self.mapView.customMapStyleEnabled = NO;
    
    if (index == 101) { // 标准地图
        [self.mapView setMapType:MAMapTypeStandard];
    } else if (index == 102) { // 卫星地图
        [self.mapView setMapType:MAMapTypeSatellite];
    } else if (index == 103) { // 公交地图
        [self.mapView setMapType:MAMapTypeBus];
        //self.mapView.showTraffic = YES;
        /*
        // 创建搜索请求
        AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
        // 设置当前位置为中心
        request.location = [AMapGeoPoint locationWithLatitude:self.mapView.userLocation.coordinate.latitude
                                                    longitude:self.mapView.userLocation.coordinate.longitude];
        // 搜索公交站点
        request.types = @"公交车站|地铁站"; // 公交相关类型
        request.sortrule = 0; // 按距离排序
        //request.requireExtension = YES;
        request.radius = 1000; // 搜索半径1000米
        // 创建搜索
        [self.searchAPI AMapPOIAroundSearch:request];
         */
    }
}

// POI搜索回调
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count == 0) {
        NSLog(@"未搜索到公交站");
        return;
    }
    
    NSLog(@"找到 %ld 个公交站点", (long)response.pois.count);
    
    // 添加标注到地图
    for (AMapPOI *poi in response.pois) {
        //[self addBusAnnotationWithPOI:poi];
    }
    
}

// 更换地图背景
- (void)changeBgClickIndex:(NSInteger)index{
    
    self.mapView.customMapStyleEnabled = NO;
    
    if (index == 106) { // 标准地图
        [self.mapView setMapType:MAMapTypeStandard];
    } else if (index == 107) { // 夜景地图
        [self.mapView setMapType:MAMapTypeStandardNight];
    } else if (index == 108) { // 跟随系统地图
        UITraitCollection *trait = [UIScreen mainScreen].traitCollection;
        if (trait.userInterfaceStyle == UIUserInterfaceStyleDark) {
            [self.mapView setMapType:MAMapTypeStandardNight];// 黑夜模式
        } else if (trait.userInterfaceStyle == UIUserInterfaceStyleLight) {
            [self.mapView setMapType:MAMapTypeStandard]; // 白天模式
        }
    }
}

/// 更换地图图层
- (void)changeSkinClickIndex:(NSInteger)index{
    
    MAMapCustomStyleOptions *options = [[MAMapCustomStyleOptions alloc] init];
    
    if (index == 104) {
        options.styleId = @"a75890ba4133623ae50342b69d7b819a";
        [self.mapView setCustomMapStyleOptions:options];
    } else if (index == 105) {
        options.styleId = @"ac6c66a898c59cdab7ce6133345732df";
        [self.mapView setCustomMapStyleOptions:options];
    }
    
    self.mapView.customMapStyleEnabled = YES;
}

#pragma mark - 懒加载
- (MAMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] init];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        _mapView.zoomLevel = 16;
        _mapView.showTraffic = YES;
        _mapView.showsCompass = NO;      
        _mapView.compassOrigin = CGPointMake(-50, statusBarHeight + 40 + 60);
        
        MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
        r.image = [UIImage imageNamed:@"userImg"];
        [_mapView updateUserLocationRepresentation:r];
    }
    return _mapView;
}

- (AMapSearchAPI *)searchAPI{
    if (!_searchAPI) {
        _searchAPI = [[AMapSearchAPI alloc] init];
        _searchAPI.delegate = self;
    }
    return _searchAPI;
}


@end
