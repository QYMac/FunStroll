//
//  CommentListModel.m
//  test
//
//  Created on 2025/12/9.
//

#import "CommentListModel.h"
#import <YYModel/YYModel.h>

@implementation CommentItem

@end

@implementation CommentListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"records" : [CommentItem class]
    };
}

+ (instancetype)yy_modelWithJSON:(id)json {
    if (!json) {
        return nil;
    }
    
    NSDictionary *dict = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dict = (NSDictionary *)json;
    } else if ([json isKindOfClass:[NSString class]]) {
        NSData *jsonData = [(NSString *)json dataUsingEncoding:NSUTF8StringEncoding];
        dict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    } else if ([json isKindOfClass:[NSData class]]) {
        dict = [NSJSONSerialization JSONObjectWithData:(NSData *)json options:kNilOptions error:nil];
    }
    
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    // 创建模型实例
    CommentListModel *model = [[CommentListModel alloc] init];
    
    // 映射顶层字段
    model.code = [dict[@"code"] integerValue];
    model.msg = dict[@"msg"];
    
    // 提取 data 部分
    NSDictionary *dataDict = dict[@"data"];
    if ([dataDict isKindOfClass:[NSDictionary class]]) {
        // 映射分页字段
        model.total = [dataDict[@"total"] integerValue];
        model.size = [dataDict[@"size"] integerValue];
        model.current = [dataDict[@"current"] integerValue];
        model.pages = [dataDict[@"pages"] integerValue];
        
        // 映射 records 数组
        id records = dataDict[@"records"];
        if (records) {
            model.records = [NSArray yy_modelArrayWithClass:[CommentItem class] json:records];
        }
    }
    
    return model;
}

@end

