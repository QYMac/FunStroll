//
//  UserModel.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/18.
//

#import "UserModel.h"
#import "AFNetworkingManage+Login.h"
#import "LoginViewController.h"
#import "TabBarViewController.h"

#define szp_uesrDefault [NSUserDefaults standardUserDefaults]

static UserModel * instance = nil;

@interface UserModel ()

@end

@implementation UserModel

+ (instancetype)sharedUserModel
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (!instance) {
        instance = [super allocWithZone:zone];
    }
    return instance;
}


// 更新用户token
+ (void)updateUserLoginToken{
    
    // 未登录退回登录页面
    if ([UserModel sharedUserModel].isAutoLogin == NO) {
        return;
    }
    
    // 更新 token 需要未登录状态去查寻更新，API这样写，我不是很理解 ？？？
    // Authorization = Basic YXBwOmFwcA== （固定）
    NSString *refresh_token = [UserModel getObjectForKey:kRefreshToken];
    if ([CheckTool replaceNullValue:refresh_token].length == 0) {
        return;
    }
    [AFNetworkingManage LoginRefresh_token:[CheckTool replaceNullValue:refresh_token] grant_type:@"refresh_token" scope:@"app-server" success:^(id  _Nonnull responseObject) {
        NSLog(@"更新 token 成功！");
        NSDictionary *dict = [CheckTool replaceNullWithDictionary:responseObject];
        NSString *code = [CheckTool replaceNullValue:dict[@"code"]];
        if ([code intValue] == 1) {
            [self loginAccount];
        } else {
            // 储存用户信息
            NSString *refresh_token = [CheckTool replaceNullValue:dict[@"refresh_token"]];
            NSString *access_token = [CheckTool replaceNullValue:dict[@"access_token"]];
            NSString *token_type = [CheckTool replaceNullValue:dict[@"token_type"]];
            [UserModel saveObject:refresh_token forKey:kRefreshToken];
            [UserModel saveObject:access_token forKey:kAccessToken];
            [UserModel saveObject:token_type forKey:kTokenType];
        }
        
    } failureHandler:^(NSError * _Nonnull error) {
        NSLog(@"更新 token 失败！");
        //NSLog(@"%@",error);
    }];
    
}

+ (void)loginAccount{
    
    NSString *refresh_token = [UserModel getObjectForKey:kRefreshToken];
    if ([CheckTool replaceNullValue:refresh_token].length == 0) {
        return;
    }
    [AFNetworkingManage LoginRefresh_token:[CheckTool replaceNullValue:refresh_token] grant_type:@"refresh_token" scope:@"app-server" success:^(id  _Nonnull responseObject) {
        // 储存用户信息
        NSDictionary *dict = [CheckTool replaceNullWithDictionary:responseObject];
        NSString *refresh_token = [CheckTool replaceNullValue:dict[@"refresh_token"]];
        NSString *access_token = [CheckTool replaceNullValue:dict[@"access_token"]];
        NSString *token_type = [CheckTool replaceNullValue:dict[@"token_type"]];
        [UserModel saveObject:refresh_token forKey:kRefreshToken];
        [UserModel saveObject:access_token forKey:kAccessToken];
        [UserModel saveObject:token_type forKey:kTokenType];
        
    } failureHandler:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    /*
    // 先获取位置再去登录
    [[LocationAddressHelper shared] getCurrentAddressWithCompletion:^(AMapReGeocode * _Nullable regeocode, CLLocationCoordinate2D coordinate, NSError * _Nullable error) {
        NSString *loginLocationStr = [CheckTool replaceNullValue:regeocode.addressComponent.province];
        NSString *deviceInfoStr = [DeviceInfoHelper getDeviceModelName];
        // 执行登录
        NSString *phoneNumberText =[UserModel getObjectForKey:kPhoneNumber];
        NSString *phoneNumber = [NSString stringWithFormat:@"APP-OneClick@%@",phoneNumberText];
        [AFNetworkingManage LoginMobile:phoneNumber grant_type:@"mobile" scope:@"app-server" loginLocation:loginLocationStr deviceInfo:deviceInfoStr success:^(id  _Nonnull responseObject) {
            
            // 储存用户信息
            NSDictionary *dict = [CheckTool replaceNullWithDictionary:responseObject];
            NSString *refresh_token = [CheckTool replaceNullValue:dict[@"refresh_token"]];
            NSString *access_token = [CheckTool replaceNullValue:dict[@"access_token"]];
            NSString *username = [CheckTool replaceNullValue:dict[@"username"]];
            NSString *user_id = [CheckTool replaceNullValue:dict[@"user_id"]];
            NSString *token_type = [CheckTool replaceNullValue:dict[@"token_type"]];
            [UserModel saveObject:refresh_token forKey:kRefreshToken];
            [UserModel saveObject:access_token forKey:kAccessToken];
            [UserModel saveObject:username forKey:kUserName];
            [UserModel saveObject:user_id forKey:kUserId];
            [UserModel saveObject:token_type forKey:kTokenType];
            [UserModel saveObject:phoneNumberText forKey:kPhoneNumber];
            [UserModel sharedUserModel].isAutoLogin = YES;
            
        } failureHandler:^(NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }];
     */
}

/// 退回登录页面
+ (void)logoutView{
    // 未登录退回登录页面
    if ([UserModel sharedUserModel].isAutoLogin == NO) {
        /*
        TransitionAnimation *transition = [[TransitionAnimation alloc] init];
        LoginViewController *navc = [[LoginViewController alloc] init];
        navc.transitioningDelegate = transition;
        navc.modalPresentationStyle = 0;
        [[TabBarViewController takeCurrentVC].navigationController pushViewController:navc animated:YES];
         */
        
        
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        if (window) {
            // 创建新的根视图控制器
            LoginViewController *newRootVC = [[LoginViewController alloc] init];
            // 使用淡入淡出动画切换根视图
            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:newRootVC];
            [window setRootViewController:navVC
                        withAnimationType:TransitionAnimationTypeFade
                                 duration:0.0
                               completion:^{
                NSLog(@"根视图切换完成（淡入淡出）");
            }];
        }
    }
}

/// 切换根视图到首页
+ (void)newRootHomeVC{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (window) {
        // 创建新的根视图控制器
        TabBarViewController *newRootVC = [[TabBarViewController alloc] init];
        // 使用淡入淡出动画切换根视图
        [window setRootViewController:newRootVC
                    withAnimationType:TransitionAnimationTypeFade
                             duration:0.1
                           completion:^{
            NSLog(@"根视图切换完成（淡入淡出）");
        }];
    }
    
    /*
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (window) {
        // 创建新的根视图控制器
        TabBarViewController *newRootVC = [[TabBarViewController alloc] init];
        // 使用淡入淡出动画切换根视图
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:newRootVC];
        [window setRootViewController:navVC
                    withAnimationType:TransitionAnimationTypeFade
                             duration:0.5
                           completion:^{
            NSLog(@"根视图切换完成（淡入淡出）");
        }];
    }
     */
}

// 删除用户信息
+ (void)deleteUserInfo{
    [UserModel clearObjectForKey:kRefreshToken];
    [UserModel clearObjectForKey:kAccessToken];
    [UserModel clearObjectForKey:kUserId];
    [UserModel clearObjectForKey:kTokenType];
    [UserModel clearObjectForKey:kUserName];
    [UserModel clearObjectForKey:kNickname];
    [UserModel clearObjectForKey:kAvatar];
    [UserModel clearObjectForKey:kGender];
    [UserModel clearObjectForKey:kAge];
    [UserModel clearObjectForKey:kBio];
    [UserModel clearObjectForKey:kBgUrl];
    [UserModel clearObjectForKey:kIpLocation];
    [UserModel sharedUserModel].isAutoLogin = NO;
}

#pragma mark - 数组本地储存
+(void)saveObject:(id)obj forKey:(NSString *)key {
    if (!key || !obj) {
        return ;
    }
    [szp_uesrDefault setObject:obj forKey:key];
    [szp_uesrDefault synchronize];
}

+(void)clearObjectForKey:(NSString *)key {
    if (!key) {;
        return ;
    }
    [szp_uesrDefault removeObjectForKey:key];
    [szp_uesrDefault synchronize];
}

+(id)getObjectForKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    return [szp_uesrDefault objectForKey:key];
}

#pragma mark - 懒加载

// 是否已经登录
- (BOOL)isAutoLogin{
    if (!_isAutoLogin) {
        _isAutoLogin = NO;
    }
    return _isAutoLogin;
}

// 是否有网络
- (BOOL)isNetworkStatus{
    if (!_isNetworkStatus) {
        _isNetworkStatus = YES;
    }
    return _isNetworkStatus;
}

//app版本号
- (NSString *)app_Version{
    if (!_app_Version) {
        //获取版本号
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        _app_Version = [CheckTool replaceNullValue:appVersion];
    }
    return _app_Version;
}

@end
