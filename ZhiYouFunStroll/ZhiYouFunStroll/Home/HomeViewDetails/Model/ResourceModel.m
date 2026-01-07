//
//  ResourceModel.m
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import "ResourceModel.h"
#import <YYModel/YYModel.h>

@implementation ResourceModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"desc" : @"description"
    };
}

@end

