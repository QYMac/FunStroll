//
//  UploadImageModel.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/15.
//

#import "UploadImageModel.h"

@implementation UploadImageDataModel

- (NSString *)description {
    return [self yy_modelDescription];
}

@end

@implementation UploadImageBatchDataModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"failList": [UploadImageDataModel class],
        @"successList": [UploadImageDataModel class]
    };
}

- (NSString *)description {
    return [self yy_modelDescription];
}

@end

@implementation UploadImageModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"data": [UploadImageBatchDataModel class]
    };
}

- (NSString *)description {
    return [self yy_modelDescription];
}

@end
