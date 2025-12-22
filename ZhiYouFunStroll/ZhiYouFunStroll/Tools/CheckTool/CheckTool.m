//
//  CheckTool.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/24.
//

#import "CheckTool.h"

@implementation CheckTool

///主要调用该方法
+ (id)replaceNullData:(id)obj {
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return [self replaceNullWithDictionary:obj];
    }
    else if ([obj isKindOfClass:[NSArray class]]) {
        return [self replaceNullWithArray:obj];
    }
    else if ([obj isKindOfClass:[NSNumber class]]) {
        if ([obj isKindOfClass:[NSNull class]] || obj == nil) {
            obj = @(0);
        }
        return obj;
    }
    else if ([obj isKindOfClass:[NSString class]]) {
        return [self replaceNullValue:obj];
    }
    return obj;
}

///处理字典
+ (id)replaceNullWithDictionary:(NSMutableDictionary *)dic {
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSArray *allKey = [dic allKeys];
    for (NSString *key in allKey) {
        [tempDic setObject:[self replaceNullData:dic[key]] forKey:key];
    }
    return tempDic;
}

///处理数组
+ (id)replaceNullWithArray:(NSMutableArray *)arr {
    __block NSMutableArray *tempArr = [NSMutableArray array];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempArr addObject:[self replaceNullData:obj]];
    }];
    return tempArr;
}

///处理字符串
+ (NSString *)replaceNullValue: (NSString *)string {
    NSString * newStr = [NSString stringWithFormat:@"%@",string];
    if ([newStr isKindOfClass:[NSNull class]] ||
        newStr == nil ||
        [newStr isEqualToString:@"(null)"]||
        [newStr isEqualToString:@""] ||
        [newStr isEqualToString:@"null"] ||
        [newStr isEqualToString:@"<null>"]) {
        newStr = @"";
    }
    return newStr;
}

+ (NSString *)replaceURLNullValue: (NSString *)string{
    NSString *headImgURL = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];

    NSString *urlString = [[NSString stringWithFormat:@"%@",headImgURL] stringByReplacingOccurrencesOfString:@"https://static-dev.wanhewenhua.cn/" withString:@"http://cdn-dev.wanhewenhua.cn/"];
    NSString * newStr = [NSString stringWithFormat:@"%@",urlString];
    if ([newStr isKindOfClass:[NSNull class]] ||
        newStr == nil ||
        [newStr isEqualToString:@"(null)"]||
        [newStr isEqualToString:@""] ||
        [newStr isEqualToString:@"null"] ||
        [newStr isEqualToString:@"<null>"]) {
        newStr = @"";
    }
    return newStr;
}

@end
