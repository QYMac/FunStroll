//
//  PostDataModel.m
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import "PostDataModel.h"
#import <YYModel/YYModel.h>

@implementation PostDataModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"resources" : [ResourceModel class]
    };
}

@end

