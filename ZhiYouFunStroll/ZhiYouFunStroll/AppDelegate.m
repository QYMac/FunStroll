//
//  AppDelegate.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/24.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if ([UserModel getObjectForKey:kUserId] != nil) {
        [UserModel sharedUserModel].isAutoLogin = YES;
    } else {
        [UserModel sharedUserModel].isAutoLogin = NO;
    }
    
    TabBarViewController *tabVc = [[TabBarViewController alloc] init];
    [self.window setRootViewController:tabVc];
    
    [AMapServices sharedServices].apiKey = AMapKey;
    
    //更新App是否显示隐私弹窗的状态，隐私弹窗是否包含高德SDK隐私协议内容的状态. since 8.1.0
    [MAMapView updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
    [MAMapView updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
    
    //关闭暗黑模式
    if(@available(iOS 13.0,*)){
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }

    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
