//
//  CustomNavController.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/24.
//

#import "CustomNavController.h"

@interface CustomNavController ()

@end

@implementation CustomNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        //设置导航栏颜色
        if (@available(iOS 13.0, *)) {
            UINavigationBarAppearance *navBarAppearance = [[UINavigationBarAppearance alloc]init];
            [navBarAppearance configureWithOpaqueBackground];
            navBarAppearance.backgroundColor = [UIColor whiteColor];
            [navBarAppearance setTitleTextAttributes:
             @{NSForegroundColorAttributeName:[UIColor blackColor]}];
            UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[CustomNavController class]]];
            navBar.standardAppearance = navBarAppearance;
            navBar.scrollEdgeAppearance = navBarAppearance;
        } else {
            UINavigationBar *bar = [UINavigationBar appearance];
            bar.barTintColor = [UIColor blackColor];
        }
    }


    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        appearance.backgroundColor = [UIColor whiteColor];
        // 导航栏下划线隐藏
        [appearance setShadowColor:nil];
        self.navigationBar.standardAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = appearance;
    }else{
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
    
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];

    self.navigationBar.translucent = NO;

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

// 统一设置导航栏返回按钮
- (void)setupNavigationBarBackButton {
    if (@available(iOS 13.0, *)) {
        // iOS 13+ 使用UINavigationBarAppearance
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        
        // 设置返回按钮图片和文字
        UIImage *backImage = [[UIImage imageNamed:@"back_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        appearance.backButtonAppearance.normal.titlePositionAdjustment = UIOffsetMake(-100, 0); // 隐藏文字
        [appearance setBackIndicatorImage:backImage transitionMaskImage:backImage];
        
        // 应用到所有导航栏
        [UINavigationBar appearance].standardAppearance = appearance;
        [UINavigationBar appearance].scrollEdgeAppearance = appearance;
        [UINavigationBar appearance].compactAppearance = appearance;
        
    } else {
        // iOS 13以下版本
        UIImage *backImage = [[UIImage imageNamed:@"back_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [[UINavigationBar appearance] setBackIndicatorImage:backImage];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backImage];
        
        // 隐藏返回按钮文字
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, 0) forBarMetrics:UIBarMetricsDefault];
    }
    
    // 设置返回按钮颜色
    [[UINavigationBar appearance] setTintColor:[UIColor systemBlueColor]];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [super popViewControllerAnimated:animated];
}


@end
