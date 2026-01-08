//
//  ArrayHelper.m
//  test
//
//  Created on 2025/12/9.
//

#import "ArrayHelper.h"
#import <objc/runtime.h>

@implementation ArrayHelper

/// 安全地获取对象的属性值，如果属性不存在返回 nil
+ (nullable id)safeValueForKey:(NSString *)key fromObject:(id)object {
    if (!object || !key || key.length == 0) {
        return nil;
    }
    
    // 使用异常处理来安全地获取值
    @try {
        // 先检查是否是字典类型
        if ([object isKindOfClass:[NSDictionary class]]) {
            return [(NSDictionary *)object objectForKey:key];
        }
        
        // 对于普通对象，使用 valueForKey:
        // 注意：valueForKey: 如果属性不存在会抛出 NSUnknownKeyException
        return [object valueForKey:key];
    } @catch (NSException *exception) {
        // 捕获所有异常，包括 NSUnknownKeyException
        // 如果属性不存在，返回 nil
        return nil;
    }
}

+ (BOOL)addItemsToMutableArray:(NSMutableArray *)mutableArray
                       newItems:(NSArray *)newItems
                      uniqueKey:(NSString *)uniqueKey
                        sortKey:(NSString *)sortKey {
    if (!mutableArray || !newItems || !uniqueKey || !sortKey) {
        return NO;
    }
    
    // 确保 mutableArray 是可变数组
    if (![mutableArray isKindOfClass:[NSMutableArray class]]) {
        return NO;
    }
    
    // 遍历新数据
    for (id newItem in newItems) {
        if (!newItem) {
            continue;
        }
        
        // 获取新数据的唯一标识值（支持 model 对象，通过 KVC 访问属性）
        id newUniqueValue = [self safeValueForKey:uniqueKey fromObject:newItem];
        
        // 如果值是 NSNumber，转换为字符串以便比较
        if ([newUniqueValue isKindOfClass:[NSNumber class]]) {
            newUniqueValue = [(NSNumber *)newUniqueValue stringValue];
        }
        
        // 如果没有唯一标识，直接添加
        if (!newUniqueValue || ([newUniqueValue isKindOfClass:[NSString class]] && ((NSString *)newUniqueValue).length == 0)) {
            [mutableArray addObject:newItem];
            continue;
        }
        
        if (!newUniqueValue || ([newUniqueValue isKindOfClass:[NSString class]] && ((NSString *)newUniqueValue).length == 0)) {
            // 如果没有唯一标识，直接添加
            [mutableArray addObject:newItem];
            continue;
        }
        
        // 查找数组中是否已存在相同唯一标识的数据（支持 model 对象）
        NSInteger existingIndex = -1;
        for (NSInteger i = 0; i < mutableArray.count; i++) {
            id existingItem = mutableArray[i];
            id existingUniqueValue = [self safeValueForKey:uniqueKey fromObject:existingItem];
            
            // 如果值是 NSNumber，转换为字符串以便比较
            if ([existingUniqueValue isKindOfClass:[NSNumber class]]) {
                existingUniqueValue = [(NSNumber *)existingUniqueValue stringValue];
            }
            
            if (existingUniqueValue && [existingUniqueValue isEqual:newUniqueValue]) {
                existingIndex = i;
                break;
            }
        }
        
        if (existingIndex >= 0) {
            // 如果存在，用新数据替换旧数据
            [mutableArray replaceObjectAtIndex:existingIndex withObject:newItem];
        } else {
            // 如果不存在，直接添加
            [mutableArray addObject:newItem];
        }
    }
    
    // 根据 sortKey 排序（最新的在前面）
    [self sortMutableArray:mutableArray byKey:sortKey ascending:NO];
    
    return YES;
}

+ (BOOL)addItemToMutableArray:(NSMutableArray *)mutableArray
                       newItem:(id)newItem
                     uniqueKey:(NSString *)uniqueKey
                       sortKey:(NSString *)sortKey {
    if (!newItem) {
        return NO;
    }
    
    return [self addItemsToMutableArray:mutableArray
                                newItems:@[newItem]
                               uniqueKey:uniqueKey
                                 sortKey:sortKey];
}

+ (void)sortMutableArray:(NSMutableArray *)mutableArray byKey:(NSString *)sortKey ascending:(BOOL)ascending {
    if (!mutableArray || mutableArray.count == 0 || !sortKey) {
        return;
    }
    
    // 日期格式化器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    
    // 排序（支持 model 对象，通过 KVC 访问属性）
    [mutableArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        @try {
            // 获取两个对象的排序字段值（支持 model 对象）
            id value1 = nil;
            id value2 = nil;
            
            // 安全地获取属性值，避免 KVC 访问不存在的属性导致崩溃
            value1 = [self safeValueForKey:sortKey fromObject:obj1];
            value2 = [self safeValueForKey:sortKey fromObject:obj2];
            
            // 如果值为 nil，放在后面
            if (!value1 && !value2) {
                return NSOrderedSame;
            }
            if (!value1) {
                return ascending ? NSOrderedAscending : NSOrderedDescending;
            }
            if (!value2) {
                return ascending ? NSOrderedDescending : NSOrderedAscending;
            }
            
            // 如果值是 NSNumber，转换为字符串
            NSString *strValue1 = nil;
            NSString *strValue2 = nil;
            
            if ([value1 isKindOfClass:[NSNumber class]]) {
                strValue1 = [(NSNumber *)value1 stringValue];
            } else if ([value1 isKindOfClass:[NSString class]]) {
                strValue1 = (NSString *)value1;
            }
            
            if ([value2 isKindOfClass:[NSNumber class]]) {
                strValue2 = [(NSNumber *)value2 stringValue];
            } else if ([value2 isKindOfClass:[NSString class]]) {
                strValue2 = (NSString *)value2;
            }
            
            if (!strValue1 || !strValue2) {
                return NSOrderedSame;
            }
            
            // 尝试解析为日期
            NSDate *date1 = [dateFormatter dateFromString:strValue1];
            NSDate *date2 = [dateFormatter dateFromString:strValue2];
            
            if (date1 && date2) {
                // 如果都能解析为日期，按日期比较
                NSComparisonResult result = [date1 compare:date2];
                return ascending ? result : -result;
            } else {
                // 如果不能解析为日期，按字符串比较
                NSComparisonResult result = [strValue1 compare:strValue2];
                return ascending ? result : -result;
            }
        } @catch (NSException *exception) {
            NSLog(@"ArrayHelper: 排序时发生异常: %@", exception.reason);
            return NSOrderedSame;
        }
    }];
}

@end

