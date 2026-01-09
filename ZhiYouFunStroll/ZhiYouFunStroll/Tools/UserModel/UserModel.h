//
//  UserModel.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject

+ (instancetype)sharedUserModel;

/// 保存数据
+(void)saveObject:(id)obj forKey:(NSString *)key;
/// 清除数据
+(void)clearObjectForKey:(NSString *)key;
///  获取数据
+(id)getObjectForKey:(NSString *)key;
/// 更新用户token
+ (void)updateUserLoginToken;
/// 退回登录页面
+ (void)logoutView;
/// 切换根视图到首页
+ (void)newRootHomeVC;

/// 是否已经登录
@property (nonatomic,assign) BOOL isAutoLogin;
/// 是否有网络
@property (nonatomic,assign) BOOL isNetworkStatus;
/// App 版本号
@property (nonatomic,strong) NSString *app_Version;

@end

NS_ASSUME_NONNULL_END
