//
//  RouteViewController.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RouteViewController : UIViewController

/// 起点坐标（默认为当前位置）
@property (nonatomic, assign) CLLocationCoordinate2D startCoordinate;
/// 起点名称
@property (nonatomic, copy) NSString *startName;

/// 终点坐标
@property (nonatomic, assign) CLLocationCoordinate2D endCoordinate;
/// 终点名称
@property (nonatomic, copy) NSString *endName;

/// 途经点数组
@property (nonatomic, strong) NSMutableArray *waypoints;

@end

NS_ASSUME_NONNULL_END
