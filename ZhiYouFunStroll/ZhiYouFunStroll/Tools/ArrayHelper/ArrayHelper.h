//
//  ArrayHelper.h
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 数组管理辅助类
/// 支持 NSObject 子类（包括 YYModel 创建的 model 对象）
@interface ArrayHelper : NSObject

/// 向可变数组添加数据，根据指定字段去重（新数据覆盖旧数据），并按更新时间排序（最新的在前面）
/// @param mutableArray 可变数组（NSMutableArray），数组中存储的是 model 对象（NSObject 子类）
/// @param newItems 要添加的新数据数组，元素为 model 对象
/// @param uniqueKey 用于去重的字段名（如 @"postId"），通过 KVC (valueForKey:) 获取字段值
///                   支持 NSString、NSNumber 等类型的属性值
/// @param sortKey 用于排序的字段名（如 @"updateTime"），通过 KVC (valueForKey:) 获取字段值
///                支持日期字符串（格式 @"yyyy-MM-dd HH:mm:ss"）或数字类型
/// @return 是否成功添加数据
/// @note 适用于 YYModel 创建的 model 对象，通过 KVC 访问属性
+ (BOOL)addItemsToMutableArray:(NSMutableArray *)mutableArray
                       newItems:(NSArray *)newItems
                      uniqueKey:(NSString *)uniqueKey
                        sortKey:(NSString *)sortKey;

/// 向可变数组添加单个数据，根据指定字段去重（新数据覆盖旧数据），并按更新时间排序（最新的在前面）
/// @param mutableArray 可变数组（NSMutableArray），数组中存储的是 model 对象（NSObject 子类）
/// @param newItem 要添加的新数据对象（model 对象）
/// @param uniqueKey 用于去重的字段名（如 @"postId"），通过 KVC (valueForKey:) 获取字段值
///                   支持 NSString、NSNumber 等类型的属性值
/// @param sortKey 用于排序的字段名（如 @"updateTime"），通过 KVC (valueForKey:) 获取字段值
///                支持日期字符串（格式 @"yyyy-MM-dd HH:mm:ss"）或数字类型
/// @return 是否成功添加数据
/// @note 适用于 YYModel 创建的 model 对象，通过 KVC 访问属性
+ (BOOL)addItemToMutableArray:(NSMutableArray *)mutableArray
                       newItem:(id)newItem
                     uniqueKey:(NSString *)uniqueKey
                       sortKey:(NSString *)sortKey;

@end

NS_ASSUME_NONNULL_END

