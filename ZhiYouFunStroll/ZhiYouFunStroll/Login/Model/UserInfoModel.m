//
//  UserInfoModel.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/15.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"bgUrl": @"bgUrl",
        @"ipLocation": @"ipLocation",
        @"followerCount": @"followerCount",
        @"attentionCount": @"attentionCount",
        @"lickCount": @"lickCount",
        @"privatePostCount": @"privatePostCount",
        @"followState": @"followState",
        @"countryCount": @"countryCount",
        @"cityCount": @"cityCount",
        @"togetherCount": @"togetherCount"
    };
}

- (NSString *)description {
    return [self yy_modelDescription];
}

@end

@implementation UserInfoResponseModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"data": [UserInfoModel class]
    };
}

- (NSString *)description {
    return [self yy_modelDescription];
}

@end
