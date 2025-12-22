//
//  CheckTool.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckTool : NSObject
/**id*/
+ (id)replaceNullData:(id)obj;
/**处理字典*/
+ (id)replaceNullWithDictionary:(NSMutableDictionary *)dic;
/**处理数组*/
+ (id)replaceNullWithArray:(NSMutableArray *)arr;
/**处理字符串*/
+ (NSString *)replaceNullValue: (NSString *)string;
/**处理字符串替换URL*/
+ (NSString *)replaceURLNullValue: (NSString *)string;

@end

NS_ASSUME_NONNULL_END
