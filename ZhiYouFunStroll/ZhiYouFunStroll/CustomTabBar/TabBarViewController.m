//
//  TabBarViewController.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/24.
//

#import "TabBarViewController.h"
#import "CustomNavController.h"
#import "FunStrollTabBar.h"
#import "HomeViewController.h"
#import "ExploreViewController.h"
#import "ShoppingViewController.h"
#import "MineViewController.h"
#import "PublishListView.h"
#import "ItineraryViewController.h"
#import "PublishNoteViewController.h"

@interface TabBarViewController ()<UITabBarControllerDelegate>

@property (nonatomic,strong) PublishListView *publishListView;

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpChildVC];
    //创建tabbar中间的tabbarItem
    [self setUpMidelTabbarItem];
    
    /*
    // 在自定义 TabBar 或 TabBarController 中设置
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        [appearance setBackgroundColor:[UIColor whiteColor]]; // 设置你的背景色
        [appearance setBackgroundEffect:nil]; // 关键：移除模糊效果
        // 移除阴影和分割线
        appearance.shadowColor = [UIColor clearColor];
        appearance.shadowImage = [[UIImage alloc] init];
        
        self.tabBar.standardAppearance = appearance;
        if (@available(iOS 15.0, *)) {
            self.tabBar.scrollEdgeAppearance = appearance;
        }
    } else {
        self.tabBar.backgroundColor = [UIColor whiteColor];
        self.tabBar.backgroundImage = [[UIImage alloc] init];
    }
     */
    
    self.tabBar.tintColor = [UIColor blackColor];
    self.delegate = self;
}

#pragma mark - UITabBarControllerDelegate
// 在 UITabBarControllerDelegate 中拦截并手动切换
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [UIView performWithoutAnimation:^{
        tabBarController.selectedViewController = viewController;
    }];
    return NO; // 返回 NO 阻止系统默认的带动画切换
}

#pragma mark -初始化所有控制器
- (void)setUpChildVC {

    // 首页
    HomeViewController *HomeVc = [[HomeViewController alloc] init];
    [self setChildVC:HomeVc title:@"首页" image:@"home_on" selectedImage:@"home_off"];
    // 探索
    ExploreViewController *ExploreVc = [[ExploreViewController alloc] init];
    [self setChildVC:ExploreVc title:@"探索" image:@"tansuo_on" selectedImage:@"tansuo_off"];
    // 行程
    ItineraryViewController *ShoppingVc = [[ItineraryViewController alloc] init];
    [self setChildVC:ShoppingVc title:@"行程" image:@"xingCheng_on" selectedImage:@"xingCheng_off"];
    // 我的
    MineViewController *MineVc = [[MineViewController alloc] init];
    [self setChildVC:MineVc title:@"我的" image:@"my_on" selectedImage:@"my_off"];
    
}

#pragma mark -创建tabbar中间的tabbarItem
- (void)setUpMidelTabbarItem{
    
    self.publishListView.frame = CGRectMake(0, kHeight, kWidth, kHeight);
    [self.view addSubview:self.publishListView];

    FunStrollTabBar *tabBar = [[FunStrollTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];

    WeakSelf
    [tabBar setDidClickPublishBtn:^(BOOL isSelected) {
        // 这里可以跳转发布页面
        [weakSelf popViewAnimateIsSelected:isSelected];
    }];

}

// 弹出发布列表view动画
- (void)popViewAnimateIsSelected:(BOOL)isSelected{
    WeakSelf
    PublishNoteViewController *navc = [[PublishNoteViewController alloc] init];
    [[TabBarViewController takeCurrentVC].navigationController  pushViewController:navc withAnimationType:TransitionAnimationTypePresentFromBottom duration:0.3 completion:^{
        
    }];
    
    /*
    if (isSelected == NO) {
        self.publishListView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.publishListView.frame = CGRectMake(0, 0, kWidth, kHeight);
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.publishListView.frame = CGRectMake(0, kHeight, kWidth, kHeight);
        } completion:^(BOOL finished) {
            weakSelf.publishListView.hidden = YES;
        }];
    }
     */
}

- (void)pushDrawViewCurrentSize:(NSInteger)size{
    
    
}


- (void)setChildVC:(UIViewController *)childVC title:(NSString *) title image:(NSString *) image selectedImage:(NSString *) selectedImage {
    
    childVC.tabBarItem.title = title;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [childVC.tabBarItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    childVC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    CustomNavController *nav = [[CustomNavController alloc] initWithRootViewController:childVC];
    nav.navigationController.navigationBar.translucent = NO;//导航栏不透明
    [self addChildViewController:nav];
}

// 获取当前控制器
+ (UIViewController *)takeCurrentVC{
    UIViewController *result = nil;

    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *temp in windows) {
            if (temp.windowLevel == UIWindowLevelNormal) {
                window = temp;
                break;
            }
        }
    }
    //取当前展示的控制器
    result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    //如果为UITabBarController：取选中控制器
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    //如果为UINavigationController：取可视控制器
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result visibleViewController];
    }
    return result;
}

#pragma mark - 懒加载
- (PublishListView *)publishListView{
    if (!_publishListView) {
        _publishListView = [[PublishListView alloc] init];
        _publishListView.hidden = YES;
    }
    return _publishListView;
}

@end
