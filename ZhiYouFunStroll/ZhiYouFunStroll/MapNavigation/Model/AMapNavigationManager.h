//
//  AMapNavigationManager.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AMapNaviDriveRouteCompletion)(NSArray<AMapNaviRoute *> * _Nullable routes, NSError * _Nullable error);
typedef void(^AMapNaviSimpleCompletion)(AMapNaviRoute * _Nullable route, NSError * _Nullable error);
typedef void(^AMapTransitCompletion)(AMapRouteSearchResponse * _Nullable response, NSError * _Nullable error);
typedef void(^AMapLocationAddressCompletion)(AMapReGeocode * _Nullable regeocode, CLLocationCoordinate2D coordinate, NSError * _Nullable error);


typedef void(^ExitNavigationBlcok)(void); // 退出导航

/// 集中封装驾车、步行、骑行、公交的路径规划
@interface AMapNavigationManager : NSObject

+ (instancetype)shared;
+ (void)resetShared;

/// 驾车多路线规划，策略可选（如不走高速、时间最短等）
- (void)planDrivingFrom:(CLLocationCoordinate2D)start
                     to:(CLLocationCoordinate2D)end
               strategy:(AMapNaviDrivingStrategy)strategy
             completion:(AMapNaviDriveRouteCompletion)completion;

/// 常用驾车便捷方法：多路线-时间最短
- (void)planDrivingFastestFrom:(CLLocationCoordinate2D)start
                            to:(CLLocationCoordinate2D)end
                    completion:(AMapNaviDriveRouteCompletion)completion;

/// 常用驾车便捷方法：不走高速
- (void)planDrivingNoHighwayFrom:(CLLocationCoordinate2D)start
                              to:(CLLocationCoordinate2D)end
                      completion:(AMapNaviDriveRouteCompletion)completion;

/// 步行路线
- (void)planWalkingFrom:(CLLocationCoordinate2D)start
                     to:(CLLocationCoordinate2D)end
             completion:(AMapNaviSimpleCompletion)completion;

/// 骑行路线
- (void)planRidingFrom:(CLLocationCoordinate2D)start
                    to:(CLLocationCoordinate2D)end
            completion:(AMapNaviSimpleCompletion)completion;

/// 公交路线（需传入城市名与策略）
- (void)planTransitFrom:(CLLocationCoordinate2D)start
                     to:(CLLocationCoordinate2D)end
                   city:(NSString *)city
                 policy:(AMapTransitStrategy)policy
             completion:(AMapTransitCompletion)completion;

/// 选择一条驾车导航画线
- (void)selectNaviRouteWithRoutes:(NSArray<AMapNaviRoute *> *)routes;

/// 开始模拟导航（需先规划路线），speed 为仿真速度（km/h）
- (void)startEmulatorNaviWithSpeed:(int)speed;

/// 开始实时导航（需已授权定位并规划路线）
- (void)startGPSNavi;
- (void)onEmulatorTap;

/// 结束导航
- (void)stopNavi;
- (void)onGpsTap;

/// 步行导航画线
- (void)showWalkRouteOnMap:(AMapNaviRoute *)route isNavigation:(BOOL)isNavigation;

/// 开始步行模拟导航（需先规划步行路线），speed 为仿真速度（km/h）
- (void)startWalkEmulatorNaviWithSpeed:(int)speed;

/// 开始步行实时导航（需授权定位并已规划步行路线）
- (void)onWalkEmuTap;

/// 结束步行导航
- (void)onWalkGpsTap;
- (void)stopWalkNavi;

/// 开始骑行模拟导航（需先规划骑行路线），speed 为仿真速度（km/h）
- (void)startRideEmulatorNaviWithSpeed:(int)speed;

/// 开始骑行实时导航（需授权定位并已规划骑行路线）
- (void)startRideGPSNavi;
- (void)onRideEmuTap;

/// 结束骑行导航
- (void)stopRideNavi;
- (void)onRideGpsTap;

/// 骑行导航画线
- (void)showRideRouteOnMap:(AMapNaviRoute *)route;

/// 公交导航在地图上画线
- (void)showTransitRouteOnMapResponse:(AMapRouteSearchResponse *)response;

/// 模拟公交导航
- (void)onTransitEmuTap;

/// 实时公交导航
- (void)onTransitGpsTap;


/// 获取当前位置地址（需要定位权限）
/// @param completion 完成回调，返回反地理编码结果和坐标
- (void)getCurrentLocationAddressWithCompletion:(AMapLocationAddressCompletion)completion;

/// 根据坐标获取地址信息（反地理编码）
/// @param coordinate 坐标
/// @param completion 完成回调，返回反地理编码结果
- (void)getAddressForCoordinate:(CLLocationCoordinate2D)coordinate
                      completion:(AMapLocationAddressCompletion)completion;



@property (nonatomic, strong) MAMapView *mapView; //高德地图图层
@property (nonatomic, strong) AMapNaviDriveView *driveView;
@property (nonatomic, strong) AMapNaviWalkView *walkView;
@property (nonatomic, strong) AMapNaviRideView *rideView;

@property(nonatomic,strong) ExitNavigationBlcok exitNavigationBlcok;

@end

NS_ASSUME_NONNULL_END
