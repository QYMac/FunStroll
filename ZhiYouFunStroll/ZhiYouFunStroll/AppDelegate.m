//
//  AppDelegate.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/24.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "AFNetworking.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //[UserModel clearObjectForKey:kUserId];
    if ([UserModel getObjectForKey:kUserId] != nil) {
        [UserModel sharedUserModel].isAutoLogin = YES;
    } else {
        [UserModel sharedUserModel].isAutoLogin = NO;
    }
    
    /// 项目催的太紧了，两个星期50个界面，现在项目有些界面和功能只能说能用，建议后续优化项目 - 纯牛马，懒得写那么好了
    
    TabBarViewController *tabVc = [[TabBarViewController alloc] init];
    [self.window setRootViewController:tabVc];
    
    [AMapServices sharedServices].apiKey = AMapKey;
    
    //更新App是否显示隐私弹窗的状态，隐私弹窗是否包含高德SDK隐私协议内容的状态. since 8.1.0
    [MAMapView updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
    [MAMapView updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
    
    [self detectionNetworkingStatus]; // 检测网络状况
    
    //关闭暗黑模式
    if(@available(iOS 13.0,*)){
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }

    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)detectionNetworkingStatus{
    // 获取共享的网络可达性管理器
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];

    // 设置网络状态变化时的回调
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 根据状态进行相应处理
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                [UserModel sharedUserModel].isNetworkStatus = NO;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                [UserModel sharedUserModel].isNetworkStatus = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝网络");
                [UserModel sharedUserModel].isNetworkStatus = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi");
                [UserModel sharedUserModel].isNetworkStatus = YES;
                break;
            default:
                break;
        }
    }];

    // 开始监控
    [manager startMonitoring];
}

@end
