//
//  ViewControllerTransitionHelper.m
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import "ViewControllerTransitionHelper.h"
#import <objc/runtime.h>

/// 转场动画实现类
@interface TransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) TransitionAnimationType animationType;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) BOOL isPresenting; // YES: Present, NO: Dismiss

- (instancetype)initWithAnimationType:(TransitionAnimationType)animationType
                             duration:(NSTimeInterval)duration
                           isPresenting:(BOOL)isPresenting;

@end

@implementation TransitionAnimator

- (instancetype)initWithAnimationType:(TransitionAnimationType)animationType
                             duration:(NSTimeInterval)duration
                          isPresenting:(BOOL)isPresenting {
    self = [super init];
    if (self) {
        _animationType = animationType;
        _duration = duration;
        _isPresenting = isPresenting;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    if (!fromVC || !toVC || !containerView) {
        [transitionContext completeTransition:NO];
        return;
    }
    
    switch (self.animationType) {
        case TransitionAnimationTypeFade:
            [self animateFadeTransition:transitionContext fromVC:fromVC toVC:toVC containerView:containerView];
            break;
        case TransitionAnimationTypePresentFromBottom:
            [self animatePresentFromBottomTransition:transitionContext fromVC:fromVC toVC:toVC containerView:containerView];
            break;
        case TransitionAnimationTypePresentFromTop:
            [self animatePresentFromTopTransition:transitionContext fromVC:fromVC toVC:toVC containerView:containerView];
            break;
        case TransitionAnimationTypePushFromLeft:
            [self animatePushFromLeftTransition:transitionContext fromVC:fromVC toVC:toVC containerView:containerView];
            break;
        case TransitionAnimationTypePushFromRight:
            [self animatePushFromRightTransition:transitionContext fromVC:fromVC toVC:toVC containerView:containerView];
            break;
        case TransitionAnimationTypeScale:
            [self animateScaleTransition:transitionContext fromVC:fromVC toVC:toVC containerView:containerView];
            break;
        case TransitionAnimationTypeFlipHorizontal:
            [self animateFlipHorizontalTransition:transitionContext fromVC:fromVC toVC:toVC containerView:containerView];
            break;
        case TransitionAnimationTypeFlipVertical:
            [self animateFlipVerticalTransition:transitionContext fromVC:fromVC toVC:toVC containerView:containerView];
            break;
    }
}

#pragma mark - 淡入淡出动画
- (void)animateFadeTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                       fromVC:(UIViewController *)fromVC
                         toVC:(UIViewController *)toVC
                 containerView:(UIView *)containerView {
    if (self.isPresenting) {
        toVC.view.alpha = 0.0;
        [containerView addSubview:toVC.view];
        
        [UIView animateWithDuration:self.duration animations:^{
            toVC.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:finished];
        }];
    } else {
        [UIView animateWithDuration:self.duration animations:^{
            fromVC.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [fromVC.view removeFromSuperview];
            [transitionContext completeTransition:finished];
        }];
    }
}

#pragma mark - 从下往上动画
- (void)animatePresentFromBottomTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                                     fromVC:(UIViewController *)fromVC
                                       toVC:(UIViewController *)toVC
                               containerView:(UIView *)containerView {
    if (self.isPresenting) {
        CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
        toVC.view.frame = CGRectOffset(finalFrame, 0, finalFrame.size.height);
        [containerView addSubview:toVC.view];
        
        [UIView animateWithDuration:self.duration
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            toVC.view.frame = finalFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:finished];
        }];
    } else {
        CGRect finalFrame = fromVC.view.frame;
        [UIView animateWithDuration:self.duration animations:^{
            fromVC.view.frame = CGRectOffset(finalFrame, 0, finalFrame.size.height);
        } completion:^(BOOL finished) {
            [fromVC.view removeFromSuperview];
            [transitionContext completeTransition:finished];
        }];
    }
}

#pragma mark - 从上往下动画
- (void)animatePresentFromTopTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                                  fromVC:(UIViewController *)fromVC
                                    toVC:(UIViewController *)toVC
                            containerView:(UIView *)containerView {
    if (self.isPresenting) {
        CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
        toVC.view.frame = CGRectOffset(finalFrame, 0, -finalFrame.size.height);
        [containerView addSubview:toVC.view];
        
        [UIView animateWithDuration:self.duration
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            toVC.view.frame = finalFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:finished];
        }];
    } else {
        CGRect finalFrame = fromVC.view.frame;
        [UIView animateWithDuration:self.duration animations:^{
            fromVC.view.frame = CGRectOffset(finalFrame, 0, -finalFrame.size.height);
        } completion:^(BOOL finished) {
            [fromVC.view removeFromSuperview];
            [transitionContext completeTransition:finished];
        }];
    }
}

#pragma mark - 从左往右动画
- (void)animatePushFromLeftTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                                fromVC:(UIViewController *)fromVC
                                  toVC:(UIViewController *)toVC
                          containerView:(UIView *)containerView {
    if (self.isPresenting) {
        CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
        toVC.view.frame = CGRectOffset(finalFrame, -finalFrame.size.width, 0);
        [containerView addSubview:toVC.view];
        
        [UIView animateWithDuration:self.duration animations:^{
            toVC.view.frame = finalFrame;
            fromVC.view.frame = CGRectOffset(fromVC.view.frame, finalFrame.size.width * 0.3, 0);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:finished];
        }];
    } else {
        CGRect finalFrame = fromVC.view.frame;
        [UIView animateWithDuration:self.duration animations:^{
            fromVC.view.frame = CGRectOffset(finalFrame, finalFrame.size.width, 0);
        } completion:^(BOOL finished) {
            [fromVC.view removeFromSuperview];
            [transitionContext completeTransition:finished];
        }];
    }
}

#pragma mark - 从右往左动画
- (void)animatePushFromRightTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                                 fromVC:(UIViewController *)fromVC
                                   toVC:(UIViewController *)toVC
                           containerView:(UIView *)containerView {
    if (self.isPresenting) {
        CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
        toVC.view.frame = CGRectOffset(finalFrame, finalFrame.size.width, 0);
        [containerView addSubview:toVC.view];
        
        [UIView animateWithDuration:self.duration animations:^{
            toVC.view.frame = finalFrame;
            fromVC.view.frame = CGRectOffset(fromVC.view.frame, -finalFrame.size.width * 0.3, 0);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:finished];
        }];
    } else {
        CGRect finalFrame = fromVC.view.frame;
        [UIView animateWithDuration:self.duration animations:^{
            fromVC.view.frame = CGRectOffset(finalFrame, -finalFrame.size.width, 0);
        } completion:^(BOOL finished) {
            [fromVC.view removeFromSuperview];
            [transitionContext completeTransition:finished];
        }];
    }
}

#pragma mark - 缩放动画
- (void)animateScaleTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                        fromVC:(UIViewController *)fromVC
                          toVC:(UIViewController *)toVC
                  containerView:(UIView *)containerView {
    if (self.isPresenting) {
        toVC.view.alpha = 0.0;
        toVC.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [containerView addSubview:toVC.view];
        
        [UIView animateWithDuration:self.duration
                              delay:0
             usingSpringWithDamping:0.6
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            toVC.view.alpha = 1.0;
            toVC.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:finished];
        }];
    } else {
        [UIView animateWithDuration:self.duration animations:^{
            fromVC.view.alpha = 0.0;
            fromVC.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
            [fromVC.view removeFromSuperview];
            [transitionContext completeTransition:finished];
        }];
    }
}

#pragma mark - 水平翻转动画
- (void)animateFlipHorizontalTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                                 fromVC:(UIViewController *)fromVC
                                   toVC:(UIViewController *)toVC
                           containerView:(UIView *)containerView {
    if (self.isPresenting) {
        toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
        toVC.view.layer.transform = CATransform3DMakeRotation(M_PI / 2, 0, 1, 0);
        [containerView addSubview:toVC.view];
        
        [UIView animateWithDuration:self.duration animations:^{
            toVC.view.layer.transform = CATransform3DIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:finished];
        }];
    } else {
        [UIView animateWithDuration:self.duration animations:^{
            fromVC.view.layer.transform = CATransform3DMakeRotation(-M_PI / 2, 0, 1, 0);
        } completion:^(BOOL finished) {
            [fromVC.view removeFromSuperview];
            [transitionContext completeTransition:finished];
        }];
    }
}

#pragma mark - 垂直翻转动画
- (void)animateFlipVerticalTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                                fromVC:(UIViewController *)fromVC
                                  toVC:(UIViewController *)toVC
                          containerView:(UIView *)containerView {
    if (self.isPresenting) {
        toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
        toVC.view.layer.transform = CATransform3DMakeRotation(M_PI / 2, 1, 0, 0);
        [containerView addSubview:toVC.view];
        
        [UIView animateWithDuration:self.duration animations:^{
            toVC.view.layer.transform = CATransform3DIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:finished];
        }];
    } else {
        [UIView animateWithDuration:self.duration animations:^{
            fromVC.view.layer.transform = CATransform3DMakeRotation(-M_PI / 2, 1, 0, 0);
        } completion:^(BOOL finished) {
            [fromVC.view removeFromSuperview];
            [transitionContext completeTransition:finished];
        }];
    }
}

@end

#pragma mark - ViewControllerTransitionHelper Implementation

@implementation ViewControllerTransitionHelper

- (instancetype)init {
    return [self initWithAnimationType:TransitionAnimationTypeFade duration:0.3];
}

- (instancetype)initWithAnimationType:(TransitionAnimationType)animationType duration:(NSTimeInterval)duration {
    self = [super init];
    if (self) {
        _animationType = animationType;
        _animationDuration = duration;
    }
    return self;
}

+ (instancetype)fadeTransitionWithDuration:(NSTimeInterval)duration {
    return [[self alloc] initWithAnimationType:TransitionAnimationTypeFade duration:duration];
}

+ (instancetype)presentFromBottomTransitionWithDuration:(NSTimeInterval)duration {
    return [[self alloc] initWithAnimationType:TransitionAnimationTypePresentFromBottom duration:duration];
}

+ (instancetype)scaleTransitionWithDuration:(NSTimeInterval)duration {
    return [[self alloc] initWithAnimationType:TransitionAnimationTypeScale duration:duration];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    return [[TransitionAnimator alloc] initWithAnimationType:self.animationType
                                                    duration:self.animationDuration
                                                 isPresenting:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[TransitionAnimator alloc] initWithAnimationType:self.animationType
                                                    duration:self.animationDuration
                                                 isPresenting:NO];
}

@end

#pragma mark - UIViewController Extension

@implementation UIViewController (TransitionHelper)

- (void)presentViewController:(UIViewController *)viewController
            withAnimationType:(TransitionAnimationType)animationType
                     duration:(NSTimeInterval)duration
                   completion:(void (^)(void))completion {
    ViewControllerTransitionHelper *transitionHelper = [[ViewControllerTransitionHelper alloc] initWithAnimationType:animationType duration:duration];
    viewController.transitioningDelegate = transitionHelper;
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    // 保持 transitionHelper 的引用，避免被释放
    objc_setAssociatedObject(viewController, @"transitionHelper", transitionHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self presentViewController:viewController animated:YES completion:completion];
}

- (void)dismissViewControllerWithAnimationType:(TransitionAnimationType)animationType
                                      duration:(NSTimeInterval)duration
                                    completion:(void (^)(void))completion {
    ViewControllerTransitionHelper *transitionHelper = [[ViewControllerTransitionHelper alloc] initWithAnimationType:animationType duration:duration];
    self.transitioningDelegate = transitionHelper;
    
    // 保持 transitionHelper 的引用
    objc_setAssociatedObject(self, @"transitionHelper", transitionHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self dismissViewControllerAnimated:YES completion:completion];
}

@end

#pragma mark - NavigationController Transition Helper

/// NavigationController 转场动画代理
@interface NavigationTransitionHelper : NSObject <UINavigationControllerDelegate>

@property (nonatomic, assign) TransitionAnimationType animationType;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, copy, nullable) void (^completionBlock)(void);

- (instancetype)initWithAnimationType:(TransitionAnimationType)animationType duration:(NSTimeInterval)duration completion:(void (^_Nullable)(void))completion;

@end

@implementation NavigationTransitionHelper

- (instancetype)initWithAnimationType:(TransitionAnimationType)animationType duration:(NSTimeInterval)duration completion:(void (^)(void))completion {
    self = [super init];
    if (self) {
        _animationType = animationType;
        _duration = duration;
        _completionBlock = completion;
    }
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    BOOL isPresenting = (operation == UINavigationControllerOperationPush);
    return [[TransitionAnimator alloc] initWithAnimationType:self.animationType
                                                    duration:self.duration
                                                 isPresenting:isPresenting];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    if (self.completionBlock) {
        self.completionBlock();
        self.completionBlock = nil;
    }
}

@end

#pragma mark - UINavigationController Extension

@implementation UINavigationController (TransitionHelper)

- (void)pushViewController:(UIViewController *)viewController
          withAnimationType:(TransitionAnimationType)animationType
                   duration:(NSTimeInterval)duration
                 completion:(void (^)(void))completion {
    // 默认隐藏底部导航栏（与系统默认行为一致）
    [self pushViewController:viewController
           withAnimationType:animationType
                    duration:duration
             hidesBottomBar:YES
                  completion:completion];
}

- (void)pushViewController:(UIViewController *)viewController
          withAnimationType:(TransitionAnimationType)animationType
                   duration:(NSTimeInterval)duration
            hidesBottomBar:(BOOL)hidesBottomBar
                 completion:(void (^)(void))completion {
    // 设置是否隐藏底部导航栏
    viewController.hidesBottomBarWhenPushed = hidesBottomBar;
    
    NavigationTransitionHelper *transitionHelper = [[NavigationTransitionHelper alloc] initWithAnimationType:animationType duration:duration completion:completion];
    
    // 保存原来的 delegate
    id<UINavigationControllerDelegate> originalDelegate = self.delegate;
    
    // 设置新的 delegate
    self.delegate = transitionHelper;
    
    // 保持 transitionHelper 的引用，避免被释放
    objc_setAssociatedObject(self, @"navigationTransitionHelper", transitionHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 保存原始 delegate 的引用，以便恢复
    if (originalDelegate && originalDelegate != transitionHelper) {
        objc_setAssociatedObject(self, @"originalNavigationDelegate", originalDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [self pushViewController:viewController animated:YES];
    
    // 延迟恢复 delegate（在动画完成后）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        id<UINavigationControllerDelegate> savedDelegate = objc_getAssociatedObject(self, @"originalNavigationDelegate");
        if (savedDelegate) {
            self.delegate = savedDelegate;
            objc_setAssociatedObject(self, @"originalNavigationDelegate", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        } else {
            self.delegate = nil;
        }
        objc_setAssociatedObject(self, @"navigationTransitionHelper", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
}

- (UIViewController *)popViewControllerWithAnimationType:(TransitionAnimationType)animationType
                                                 duration:(NSTimeInterval)duration
                                               completion:(void (^)(void))completion {
    NavigationTransitionHelper *transitionHelper = [[NavigationTransitionHelper alloc] initWithAnimationType:animationType duration:duration completion:completion];
    
    // 保存原来的 delegate
    id<UINavigationControllerDelegate> originalDelegate = self.delegate;
    
    // 设置新的 delegate
    self.delegate = transitionHelper;
    
    // 保持 transitionHelper 的引用
    objc_setAssociatedObject(self, @"navigationTransitionHelper", transitionHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 保存原始 delegate 的引用
    if (originalDelegate && originalDelegate != transitionHelper) {
        objc_setAssociatedObject(self, @"originalNavigationDelegate", originalDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    UIViewController *poppedVC = [self popViewControllerAnimated:YES];
    
    // 延迟恢复 delegate
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        id<UINavigationControllerDelegate> savedDelegate = objc_getAssociatedObject(self, @"originalNavigationDelegate");
        if (savedDelegate) {
            self.delegate = savedDelegate;
            objc_setAssociatedObject(self, @"originalNavigationDelegate", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        } else {
            self.delegate = nil;
        }
        objc_setAssociatedObject(self, @"navigationTransitionHelper", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
    
    return poppedVC;
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController
                                     withAnimationType:(TransitionAnimationType)animationType
                                              duration:(NSTimeInterval)duration
                                            completion:(void (^)(void))completion {
    NavigationTransitionHelper *transitionHelper = [[NavigationTransitionHelper alloc] initWithAnimationType:animationType duration:duration completion:completion];
    
    // 保存原来的 delegate
    id<UINavigationControllerDelegate> originalDelegate = self.delegate;
    
    // 设置新的 delegate
    self.delegate = transitionHelper;
    
    // 保持 transitionHelper 的引用
    objc_setAssociatedObject(self, @"navigationTransitionHelper", transitionHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 保存原始 delegate 的引用
    if (originalDelegate && originalDelegate != transitionHelper) {
        objc_setAssociatedObject(self, @"originalNavigationDelegate", originalDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSArray<UIViewController *> *poppedVCs = [self popToViewController:viewController animated:YES];
    
    // 延迟恢复 delegate
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        id<UINavigationControllerDelegate> savedDelegate = objc_getAssociatedObject(self, @"originalNavigationDelegate");
        if (savedDelegate) {
            self.delegate = savedDelegate;
            objc_setAssociatedObject(self, @"originalNavigationDelegate", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        } else {
            self.delegate = nil;
        }
        objc_setAssociatedObject(self, @"navigationTransitionHelper", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
    
    return poppedVCs;
}

- (NSArray<UIViewController *> *)popToRootViewControllerWithAnimationType:(TransitionAnimationType)animationType
                                                                   duration:(NSTimeInterval)duration
                                                                 completion:(void (^)(void))completion {
    NavigationTransitionHelper *transitionHelper = [[NavigationTransitionHelper alloc] initWithAnimationType:animationType duration:duration completion:completion];
    
    // 保存原来的 delegate
    id<UINavigationControllerDelegate> originalDelegate = self.delegate;
    
    // 设置新的 delegate
    self.delegate = transitionHelper;
    
    // 保持 transitionHelper 的引用
    objc_setAssociatedObject(self, @"navigationTransitionHelper", transitionHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 保存原始 delegate 的引用
    if (originalDelegate && originalDelegate != transitionHelper) {
        objc_setAssociatedObject(self, @"originalNavigationDelegate", originalDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSArray<UIViewController *> *poppedVCs = [self popToRootViewControllerAnimated:YES];
    
    // 延迟恢复 delegate
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        id<UINavigationControllerDelegate> savedDelegate = objc_getAssociatedObject(self, @"originalNavigationDelegate");
        if (savedDelegate) {
            self.delegate = savedDelegate;
            objc_setAssociatedObject(self, @"originalNavigationDelegate", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        } else {
            self.delegate = nil;
        }
        objc_setAssociatedObject(self, @"navigationTransitionHelper", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
    
    return poppedVCs;
}

@end

#pragma mark - UIWindow 扩展实现

@implementation UIWindow (TransitionHelper)

- (void)setRootViewController:(UIViewController *)rootViewController
            withAnimationType:(TransitionAnimationType)animationType
                     duration:(NSTimeInterval)duration
                   completion:(void (^_Nullable)(void))completion {
    if (!rootViewController) {
        if (completion) {
            completion();
        }
        return;
    }
    
    UIViewController *oldRootVC = self.rootViewController;
    if (oldRootVC == rootViewController) {
        if (completion) {
            completion();
        }
        return;
    }
    
    // 确保新视图控制器的视图已经加载
    [rootViewController view];
    
    UIView *oldView = oldRootVC ? oldRootVC.view : nil;
    UIView *newView = rootViewController.view;
    
    // 保存旧视图的 frame，以便动画使用
    CGRect oldFrame = oldView ? oldView.frame : self.bounds;
    
    // 先设置新的根视图控制器（这会自动添加新视图到 window）
    self.rootViewController = rootViewController;
    
    // 确保新视图的 frame 正确，并且可以响应交互
    newView.frame = self.bounds;
    newView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    newView.userInteractionEnabled = YES;
    
    // 将旧视图重新添加到 window 上（在新视图之上），以便执行动画
    if (oldView && oldView.superview != self) {
        [self addSubview:oldView];
    }
    if (oldView) {
        oldView.frame = oldFrame;
    }
    
    // 根据动画类型执行不同的动画
    switch (animationType) {
        case TransitionAnimationTypeFade: {
            // 淡入淡出
            newView.alpha = 0.0;
            [UIView animateWithDuration:duration animations:^{
                newView.alpha = 1.0;
                oldView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [oldView removeFromSuperview];
                if (completion) {
                    completion();
                }
            }];
            break;
        }
            
        case TransitionAnimationTypePresentFromBottom: {
            // 从下往上
            CGRect finalFrame = newView.frame;
            newView.frame = CGRectOffset(finalFrame, 0, finalFrame.size.height);
            [UIView animateWithDuration:duration
                                  delay:0
                 usingSpringWithDamping:0.8
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                newView.frame = finalFrame;
                oldView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [oldView removeFromSuperview];
                if (completion) {
                    completion();
                }
            }];
            break;
        }
            
        case TransitionAnimationTypePresentFromTop: {
            // 从上往下
            CGRect finalFrame = newView.frame;
            newView.frame = CGRectOffset(finalFrame, 0, -finalFrame.size.height);
            [UIView animateWithDuration:duration
                                  delay:0
                 usingSpringWithDamping:0.8
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                newView.frame = finalFrame;
                oldView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [oldView removeFromSuperview];
                if (completion) {
                    completion();
                }
            }];
            break;
        }
            
        case TransitionAnimationTypePushFromLeft: {
            // 从左往右
            CGRect finalFrame = newView.frame;
            newView.frame = CGRectOffset(finalFrame, -finalFrame.size.width, 0);
            [UIView animateWithDuration:duration animations:^{
                newView.frame = finalFrame;
                oldView.frame = CGRectOffset(oldView.frame, finalFrame.size.width * 0.3, 0);
                oldView.alpha = 0.5;
            } completion:^(BOOL finished) {
                [oldView removeFromSuperview];
                if (completion) {
                    completion();
                }
            }];
            break;
        }
            
        case TransitionAnimationTypePushFromRight: {
            // 从右往左
            CGRect finalFrame = newView.frame;
            newView.frame = CGRectOffset(finalFrame, finalFrame.size.width, 0);
            [UIView animateWithDuration:duration animations:^{
                newView.frame = finalFrame;
                oldView.frame = CGRectOffset(oldView.frame, -finalFrame.size.width * 0.3, 0);
                oldView.alpha = 0.5;
            } completion:^(BOOL finished) {
                [oldView removeFromSuperview];
                if (completion) {
                    completion();
                }
            }];
            break;
        }
            
        case TransitionAnimationTypeScale: {
            // 缩放
            newView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            newView.alpha = 0.0;
            [UIView animateWithDuration:duration
                                  delay:0
                 usingSpringWithDamping:0.7
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                newView.transform = CGAffineTransformIdentity;
                newView.alpha = 1.0;
                oldView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                oldView.alpha = 0.0;
            } completion:^(BOOL finished) {
                oldView.transform = CGAffineTransformIdentity;
                [oldView removeFromSuperview];
                if (completion) {
                    completion();
                }
            }];
            break;
        }
            
        case TransitionAnimationTypeFlipHorizontal: {
            // 水平翻转
            newView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
            [UIView animateWithDuration:duration animations:^{
                newView.layer.transform = CATransform3DIdentity;
                oldView.layer.transform = CATransform3DMakeRotation(-M_PI, 0, 1, 0);
                oldView.alpha = 0.0;
            } completion:^(BOOL finished) {
                oldView.layer.transform = CATransform3DIdentity;
                [oldView removeFromSuperview];
                if (completion) {
                    completion();
                }
            }];
            break;
        }
            
        case TransitionAnimationTypeFlipVertical: {
            // 垂直翻转
            newView.layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
            [UIView animateWithDuration:duration animations:^{
                newView.layer.transform = CATransform3DIdentity;
                oldView.layer.transform = CATransform3DMakeRotation(-M_PI, 1, 0, 0);
                oldView.alpha = 0.0;
            } completion:^(BOOL finished) {
                oldView.layer.transform = CATransform3DIdentity;
                [oldView removeFromSuperview];
                if (completion) {
                    completion();
                }
            }];
            break;
        }
            
        default: {
            // 默认淡入淡出
            newView.alpha = 0.0;
            [UIView animateWithDuration:duration animations:^{
                newView.alpha = 1.0;
                oldView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [oldView removeFromSuperview];
                if (completion) {
                    completion();
                }
            }];
            break;
        }
    }
}

@end


