//
//  AlicomFusionAuthTokenManager.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^loginOutBlcok)(void);

@interface AlicomFusionAuthTokenManager : NSObject

+ (instancetype)shareInstance;

- (void)oneClickLogin;

// 阿里云手机登录
@property (nonatomic,nullable, strong) AlicomFusionAuthHandler *handler;
@property (nonatomic, strong) AlicomFusionNumberAuthModel *authmodel;

@property(nonatomic,strong) loginOutBlcok loginOutclickBlcok;

@end

NS_ASSUME_NONNULL_END
