//
//  ViewControllerTransitionHelper.h
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 转场动画类型
typedef NS_ENUM(NSInteger, TransitionAnimationType) {
    TransitionAnimationTypeFade = 0,           // 淡入淡出
    TransitionAnimationTypePresentFromBottom, // 从下往上
    TransitionAnimationTypePresentFromTop,     // 从上往下
    TransitionAnimationTypePushFromLeft,      // 从左往右
    TransitionAnimationTypePushFromRight,     // 从右往左
    TransitionAnimationTypeScale,              // 缩放
    TransitionAnimationTypeFlipHorizontal,     // 水平翻转
    TransitionAnimationTypeFlipVertical        // 垂直翻转
};

/// ViewController 转场动画辅助类
@interface ViewControllerTransitionHelper : NSObject <UIViewControllerTransitioningDelegate>

/// 动画持续时间（默认 0.3 秒）
@property (nonatomic, assign) NSTimeInterval animationDuration;

/// 动画类型
@property (nonatomic, assign) TransitionAnimationType animationType;

/// 初始化方法
/// @param animationType 动画类型
/// @param duration 动画持续时间
- (instancetype)initWithAnimationType:(TransitionAnimationType)animationType duration:(NSTimeInterval)duration;

/// 便捷方法：创建淡入淡出动画
+ (instancetype)fadeTransitionWithDuration:(NSTimeInterval)duration;

/// 便捷方法：创建从下往上动画
+ (instancetype)presentFromBottomTransitionWithDuration:(NSTimeInterval)duration;

/// 便捷方法：创建缩放动画
+ (instancetype)scaleTransitionWithDuration:(NSTimeInterval)duration;

@end

/// ViewController 转场动画扩展方法
@interface UIViewController (TransitionHelper)

/// 使用自定义转场动画 Present 一个 ViewController
/// @param viewController 要 Present 的 ViewController
/// @param animationType 动画类型
/// @param duration 动画持续时间
/// @param completion 完成回调
- (void)presentViewController:(UIViewController *)viewController
            withAnimationType:(TransitionAnimationType)animationType
                     duration:(NSTimeInterval)duration
                   completion:(void (^_Nullable)(void))completion;

/// 使用自定义转场动画 Dismiss
/// @param animationType 动画类型
/// @param duration 动画持续时间
/// @param completion 完成回调
- (void)dismissViewControllerWithAnimationType:(TransitionAnimationType)animationType
                                      duration:(NSTimeInterval)duration
                                    completion:(void (^_Nullable)(void))completion;

@end

/// NavigationController 转场动画扩展方法
@interface UINavigationController (TransitionHelper)

/// 使用自定义转场动画 Push 一个 ViewController
/// @param viewController 要 Push 的 ViewController
/// @param animationType 动画类型
/// @param duration 动画持续时间
/// @param completion 完成回调
- (void)pushViewController:(UIViewController *)viewController
          withAnimationType:(TransitionAnimationType)animationType
                   duration:(NSTimeInterval)duration
                 completion:(void (^_Nullable)(void))completion;

/// 使用自定义转场动画 Push 一个 ViewController（可控制是否隐藏底部导航栏）
/// @param viewController 要 Push 的 ViewController
/// @param animationType 动画类型
/// @param duration 动画持续时间
/// @param hidesBottomBar 是否隐藏底部导航栏（TabBar），YES 表示隐藏，NO 表示显示
/// @param completion 完成回调
- (void)pushViewController:(UIViewController *)viewController
          withAnimationType:(TransitionAnimationType)animationType
                   duration:(NSTimeInterval)duration
            hidesBottomBar:(BOOL)hidesBottomBar
                 completion:(void (^_Nullable)(void))completion;

/// 使用自定义转场动画 Pop 到上一个 ViewController
/// @param animationType 动画类型
/// @param duration 动画持续时间
/// @param completion 完成回调
/// @return Pop 出的 ViewController
- (nullable UIViewController *)popViewControllerWithAnimationType:(TransitionAnimationType)animationType
                                                          duration:(NSTimeInterval)duration
                                                        completion:(void (^_Nullable)(void))completion;

/// 使用自定义转场动画 Pop 到指定的 ViewController
/// @param viewController 目标 ViewController
/// @param animationType 动画类型
/// @param duration 动画持续时间
/// @param completion 完成回调
/// @return Pop 出的 ViewController 数组
- (nullable NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController
                                             withAnimationType:(TransitionAnimationType)animationType
                                                      duration:(NSTimeInterval)duration
                                                    completion:(void (^_Nullable)(void))completion;

/// 使用自定义转场动画 Pop 到根 ViewController
/// @param animationType 动画类型
/// @param duration 动画持续时间
/// @param completion 完成回调
/// @return Pop 出的 ViewController 数组
- (nullable NSArray<UIViewController *> *)popToRootViewControllerWithAnimationType:(TransitionAnimationType)animationType
                                                                          duration:(NSTimeInterval)duration
                                                                        completion:(void (^_Nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END

