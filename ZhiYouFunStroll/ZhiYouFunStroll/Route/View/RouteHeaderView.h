//
//  RouteHeaderView.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RouteHeaderView;
@class RouteWaypointModel;

typedef NS_ENUM(NSInteger, RouteInputType) {
    RouteInputTypeStart = 0,  // 起点
    RouteInputTypeEnd,        // 终点
    RouteInputTypeWaypoint    // 途经点
};

@protocol RouteHeaderViewDelegate <NSObject>

@optional
/// 输入框开始编辑
- (void)headerView:(RouteHeaderView *)headerView didBeginEditingWithType:(RouteInputType)type atIndex:(NSInteger)index;
/// 输入框结束编辑
- (void)headerView:(RouteHeaderView *)headerView didEndEditingWithType:(RouteInputType)type atIndex:(NSInteger)index;
/// 输入框文本变化
- (void)headerView:(RouteHeaderView *)headerView didChangeText:(NSString *)text withType:(RouteInputType)type atIndex:(NSInteger)index;
/// 点击键盘完成/搜索按钮
- (void)headerView:(RouteHeaderView *)headerView didTapReturnWithType:(RouteInputType)type atIndex:(NSInteger)index;

@end

@interface RouteHeaderView : UIView

@property (nonatomic, weak) id<RouteHeaderViewDelegate> delegate;

/// 起点输入框
@property (nonatomic, strong, readonly) UITextField *startTextField;
/// 终点输入框
@property (nonatomic, strong, readonly) UITextField *endTextField;

/// 起点名称
@property (nonatomic, copy) NSString *startName;
/// 终点名称
@property (nonatomic, copy) NSString *endName;

/// 途经点按钮点击回调
@property (nonatomic, copy) void(^waypointButtonBlock)(void);

/// 路线修改按钮点击回调
@property (nonatomic, copy) void(^routeEditButtonBlock)(void);

/// 高度变化回调
@property (nonatomic, copy) void(^heightDidChangeBlock)(CGFloat newHeight);

/// 更新途径点数据
- (void)updateWithWaypoints:(NSArray<RouteWaypointModel *> *)waypoints;

/// 获取当前计算的高度
- (CGFloat)calculatedHeight;

/// 结束编辑
- (void)endEditing;

@end

NS_ASSUME_NONNULL_END
