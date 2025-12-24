//
//  HomeModel.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/24.
//

#import "HomeModel.h"

@implementation HomeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"size": @"data.size",
        @"total": @"data.total",
        @"current": @"data.current",
        @"pages": @"data.pages",
        @"records": @"data.records"
    };
}

@end
