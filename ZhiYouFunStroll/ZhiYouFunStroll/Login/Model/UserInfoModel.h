//
//  UserInfoModel.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/15.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoModel : NSObject <YYModel>

/// 用户名
@property (nonatomic, copy, nullable) NSString *username;

/// 昵称
@property (nonatomic, copy, nullable) NSString *nickname;

/// 头像URL
@property (nonatomic, copy, nullable) NSString *avatar;

/// 性别
@property (nonatomic, copy, nullable) NSString *gender;

/// 年龄
@property (nonatomic, assign) NSInteger age;

/// 个人简介
@property (nonatomic, copy, nullable) NSString *bio;

/// 背景图URL
@property (nonatomic, copy, nullable) NSString *bgUrl;

/// IP归属地
@property (nonatomic, copy, nullable) NSString *ipLocation;

/// 粉丝数
@property (nonatomic, copy, nullable) NSString *followerCount;

/// 关注数
@property (nonatomic, copy, nullable) NSString *attentionCount;

/// 获赞数
@property (nonatomic, copy, nullable) NSString *lickCount;

/// 私密帖子数
@property (nonatomic, copy, nullable) NSString *privatePostCount;

/// 关注状态 (0: 未关注, 1: 已关注, 2: 互相关注)
@property (nonatomic, assign) NSInteger followState;

/// 去过的国家数
@property (nonatomic, assign) NSInteger countryCount;

/// 去过的城市数
@property (nonatomic, assign) NSInteger cityCount;

/// 同行数
@property (nonatomic, assign) NSInteger togetherCount;

@end

#pragma mark - 用户信息响应模型

@interface UserInfoResponseModel : NSObject <YYModel>

/// 响应码
@property (nonatomic, assign) NSInteger code;

/// 响应消息
@property (nonatomic, copy, nullable) NSString *msg;

/// 用户数据
@property (nonatomic, strong, nullable) UserInfoModel *data;

/// 是否成功
@property (nonatomic, assign) BOOL ok;

@end

NS_ASSUME_NONNULL_END
