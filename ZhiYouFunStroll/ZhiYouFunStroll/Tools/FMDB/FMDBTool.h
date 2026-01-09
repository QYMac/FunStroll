//
//  FMDBTool.h
//  PixelCloud
//
//  Created by Qingyun Wei on 2025/2/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMDBTool : NSObject

#pragma mark - ---事务---

/// 启用事务
+ (BOOL)startUsingTransaction;

/// 提交事务
+ (BOOL)commitTransaction;

/// 回滚事务
+ (BOOL)backTransaction;

#pragma mark - ---创建、新增---

/// 创建表
/// @param tabName 表名
+ (void)createTableWithTabName:(NSString *)tabName dataList:(NSArray *)list andHandle:(void (^ _Nullable)(BOOL isSuccess))handle;

/// 创建表
/// @param tabName 表名
+ (void)createTableWithTabName:(NSString *)tabName dataDict:(NSDictionary *)dict andHandle:(void (^ _Nullable)(BOOL isSuccess))handle;

#pragma mark - ---储存、更新---

/// 储存列表数据
/// @param tabName 表名
/// @param list list 列表数据
+ (void)saveDataListWithTabName:(NSString *)tabName dataList:(NSArray *)list andHandle:(void (^ _Nullable)(BOOL isSuccess))handle;

/// 储存对象（单个）
/// @param tabName tabName description
/// @param dict dict description
+ (void)saveDataListWithTabName:(NSString *)tabName dataDict:(NSDictionary *)dict andHandle:(void (^ _Nullable)(BOOL isSuccess))handle;

/// 根据条件更新某个字段的值
+ (BOOL)updateDataWithTable:(NSString *)tabName key:(NSString *)keyStr value:(NSString *)valueStr condition:(NSString *)condition;

/// 根据条件更新某个字段的值（2个值）
+ (BOOL)updateDataWithTable:(NSString *)tabName key:(NSString *)keyStr value:(NSString *)valueStr key2:(NSString *)keyStr2 value2:(NSString *)valueStr2 condition:(NSString *)condition;

#pragma mark - ---删除、清空---

/// 删除表
/// @param tabName 表名
+ (void)deleteTableWithTab:(NSString *)tabName;

/// 清空表(不删除)
/// @param tabName 表名
+ (void)clearTableWithTab:(NSString *)tabName andHandle:(void (^ _Nullable)(BOOL isSuccess))handle;

/// 删除数据
/// @param tabName ;
/// @param condition 自定义条件
+ (BOOL)deleteDataWithTab:(NSString *)tabName condition:(nullable NSString *)condition;

/// 删除指定数据
/// @param tabName tabName description
/// @param key key description
/// @param value value description
+ (void)deleteDataWithTab:(NSString *)tabName key:(NSString *)key value:(NSString *)value andHandle:(void (^ _Nullable)(BOOL isSuccess))handle;

/// 根据 key 批量删除数据
/// @param tabName tabName description
/// @param key key description
/// @param valueArr valueArr description
+ (void)deleteDataWithTab:(NSString *)tabName key:(NSString *)key valueArray:(NSArray *)valueArr andHandle:(void (^ _Nullable)(BOOL isSuccess))handle;

#pragma mark - ---查询、查找---

/// 查找一张表里的所有字段和数据
/// @param tabName 表名
+ (NSArray *)searchObjWithTable:(NSString *)tabName;

/// 查找一张表里的数据
/// @param tabName 表名
+ (void)searchObjWithTable:(NSString *)tabName andHandle:(void (^ _Nullable)(NSArray * _Nullable dataArray))handle;

/// 查找一张表里的数据
/// @param tabName 表名
/// @param condition 附加条件
+ (NSArray *)searchObjWithTable:(NSString *)tabName condition:(nullable NSString *)condition;

/// 查找一张表里的特定数据
/// @param tabName 表名
/// @param fieldStr 字段名
/// @param condition 附加条件
+ (NSArray *)searchObjWithTable:(NSString *)tabName fieldStr:(NSString *)fieldStr condition:(nullable NSString *)condition;

/// 查找一张表里的特定数据
/// @param tabName 表名
/// @param fieldStr 字段名 每个值都是唯一的，去重
+ (NSArray *)searchOnlyObjWithTable:(NSString *)tabName fieldStr:(NSString *)fieldStr;

/// 查找一张表里的特定数据
/// @param tabName 表名
/// @param fieldStr 字段名 每个值都是唯一的，去重
/// @param condition 附加条件
+ (NSArray *)searchOnlyObjWithTable:(NSString *)tabName fieldStr:(NSString *)fieldStr condition:(nullable NSString *)condition;

/// 查找一张表里的数据
/// @param tabName 表名
/// @param condition 附加条件
+ (void)searchObjWithTable:(NSString *)tabName condition:(nullable NSString *)condition andHandle:(void (^ _Nullable)(NSArray * _Nullable dataArray))handle;

/// 查找一张表里有多少条数据
+ (NSInteger)searchObjCountWithTable:(NSString *)tabName;

/// 根据字段查找数据（单个）
/// @param tab tab description
/// @param key key description
/// @param value value description
+ (NSDictionary *)searchObjWithTable:(NSString *)tab key:(NSString *)key value:(NSString *)value;

/// 根据字段查找数据（单个）
/// @param tab tab description
/// @param key key description
/// @param value value description
+ (void)searchObjWithTable:(NSString *)tab key:(NSString *)key value:(NSString *)value andHandle:(void (^ _Nullable)(NSDictionary * _Nullable dataDict))handle;

/// 查找一张表里的数据（单条）
/// @param tabName 表名
/// @param condition 附加条件
+ (NSDictionary *)searchDictWithTable:(NSString *)tabName conditionStr:(nullable NSString *)condition;

/// 查找一张表里的数据（单条）
/// @param tabName 表名
/// @param condition 附加条件
+ (void)searchDictWithTable:(NSString *)tabName conditionStr:(nullable NSString *)condition andHandle:(void (^ _Nullable)(NSDictionary * _Nullable dataDict))handle;

/// 根据字段查找数据（多个）
/// @param tab tab description
/// @param key key description
/// @param value value description
+ (NSArray *)searchObjArrayWithTable:(NSString *)tab key:(NSString *)key value:(NSString *)value;

/// 根据字段查找数据（多个）
/// @param tab tab description
/// @param key key description
/// @param value value description
+ (NSArray *)searchObjArrayWithTable:(NSString *)tab key:(NSString *)key value:(NSString *)value condition:(nullable NSString *)condition;

/// 搜索某个表的某条数据的某个字段的值
+ (NSString *)searchValueWithTabName:(NSString *)tabName andKey:(NSString *)keyStr condition:(nullable NSString *)condition;

/// 搜索某张表里的某个字段的全部数据
/// @param tabName tabName description
/// @param keyStr keyStr description
/// @param condition condition description
+ (NSArray *)searchValuesWithTabName:(NSString *)tabName andKey:(NSString *)keyStr condition:(nullable NSString *)condition;

/// 查询表是否已创建
+ (void)checkTableIsCreateWithTableName:(NSString *)tabName andHandle:(void (^ _Nullable)(BOOL isSuccess))handle;

/// 检查某条数据是否存在数据库，附带自定义条件
+ (BOOL)checkDataExistWithTable:(NSString *)tabName key:(NSString *)keyStr value:(NSString *)valueStr condition:(nullable NSString *)condition;

/// 检查某条数据是否存在数据库，附带自定义条件
+ (BOOL)checkDataExistWithTable:(NSString *)tabName key:(NSString *)keyStr condition:(nullable NSString *)condition;

/// 查询某张表里的某类数据的数量
+ (NSInteger)searchDataCountWithTable:(NSString *)tabName key:(NSString *)keyStr value:(NSString *)valueStr;

/// 查询某张表里的某类数据的数量，附带自定义条件
+ (NSInteger)searchDataCountWithTable:(NSString *)tabName key:(NSString *)keyStr condition:(nullable NSString *)condition;

/// 查询统计某张表里的某个字段的数量总和，附带自定义条件
+ (NSInteger)searchDataSumCountWithTable:(NSString *)tabName key:(NSString *)keyStr condition:(nullable NSString *)condition;

/// 批量查询指定组数据
+ (NSArray *)searchDataWithTable:(NSString *)tabName keyStr:(NSString *)keyStr valuse:(NSArray *)valueArr;

@end

NS_ASSUME_NONNULL_END
