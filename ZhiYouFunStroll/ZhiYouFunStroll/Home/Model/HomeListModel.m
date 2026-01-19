//
//  HomeListModel.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2026/01/16.
//

#import "HomeListModel.h"
#import <YYModel/YYModel.h>

#pragma mark - HomeListRecordModel
@implementation HomeListRecordModel

@end

#pragma mark - HomeListDataModel
@implementation HomeListDataModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"records": [HomeListRecordModel class]
    };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"recordsArray": @"records"  // recordsArray 也映射到 records 字段
    };
}

@end

#pragma mark - HomeListModel
@implementation HomeListModel

@end
