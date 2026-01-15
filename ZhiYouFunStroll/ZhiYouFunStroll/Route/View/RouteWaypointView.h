//
//  RouteWaypointView.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RouteWaypointModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isStart;
@property (nonatomic, assign) BOOL isEnd;
@property (nonatomic, assign) NSInteger index; // 途经点序号（1,2,3...）

@end

@interface RouteWaypointView : UIView

/// 关闭回调
@property (nonatomic, copy) void(^closeBlock)(void);

/// 完成回调，返回途经点数组
@property (nonatomic, copy) void(^doneBlock)(NSArray *waypoints);

/// 输入框开始编辑回调（用于显示分类页）
@property (nonatomic, copy) void(^inputDidBeginEditingBlock)(void);

/// 点击键盘返回回调（用于显示搜索结果页）
@property (nonatomic, copy) void(^inputDidTapReturnBlock)(NSString *text);

/// 设置起点、终点和途经点数据
- (void)setStartName:(NSString *)startName endName:(NSString *)endName waypoints:(NSArray *)waypoints;

/// 更新当前编辑的输入框文本（从外部搜索结果选中时调用）
- (void)updateCurrentEditingText:(NSString *)text;

/// 隐藏搜索相关视图（关闭分类/搜索结果页时调用）
- (void)hideSearchViews;

@end

NS_ASSUME_NONNULL_END
