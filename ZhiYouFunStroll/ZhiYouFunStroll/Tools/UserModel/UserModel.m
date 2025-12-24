//
//  UserModel.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/18.
//

#import "UserModel.h"

#define szp_uesrDefault [NSUserDefaults standardUserDefaults]

static UserModel * instance = nil;

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

@end
