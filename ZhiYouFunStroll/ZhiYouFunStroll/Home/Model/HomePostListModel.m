//
//  HomePostListModel.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2026/01/16.
//

#import "HomePostListModel.h"
#import <YYModel/YYModel.h>

#pragma mark - HomePostRecordModel
@implementation HomePostRecordModel

@end

#pragma mark - HomePostsModel
@implementation HomePostsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"records": [HomePostRecordModel class]
    };
}

@end

#pragma mark - HomePostListDataModel
@implementation HomePostListDataModel


@end

#pragma mark - HomePostListModel
@implementation HomePostListModel

@end
