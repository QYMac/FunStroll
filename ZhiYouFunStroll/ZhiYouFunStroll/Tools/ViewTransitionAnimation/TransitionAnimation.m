//
//  TransitionAnimation.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/18.
//

#import "TransitionAnimation.h"

@interface TransitionAnimation ()

@property (nonatomic,assign) BOOL isPresent;

@end

@implementation TransitionAnimation

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isPresent = NO;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    // 两个信息：
    // 1、我确实有自定义转场动画
    // 2、谁实现了自定义转场动画
    self.isPresent  = YES;
    
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 转场持续时间，不是动画持续时间，然而通常要等于动画持续时间
    return 0.68;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // transitionContext没有告诉我们任何关于这次转场是present还是dismiss的信息
    // 所以要另外找个地方获取这个信息
    // 动画发生的地方，视图容器
    UIView * containerView = [transitionContext containerView];
    // 从哪个controller
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    // 跳转到哪个controller
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    // present的时候，登录盖住首页，from是首页，to是登录
    // dismiss的时候，登录盖住首页，from是登录，to是首页
    CGFloat scale;
    CGFloat alpha;
    UIView * animateView;
    
    if (self.isPresent) {
        [containerView addSubview:fromVC.view];
        [containerView addSubview:toVC.view];
        
        // to是登录页面
        toVC.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
        toVC.view.alpha = 0;
        
        
        scale = 1.0;
        alpha = 1;
        animateView = toVC.view;
        
    } else {
        [containerView addSubview:toVC.view];
        
        // from是登录
        [containerView addSubview:fromVC.view];
        
        scale = 1.1;
        alpha = 0;
        animateView = fromVC.view;
    }
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        // 登录淡入，小小的缩放动画
        animateView.alpha = alpha;
        animateView.transform = CGAffineTransformMakeScale(scale, scale);
        
    } completion:^(BOOL finished) {
        // 动画结束，通知系统转场结束
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
