//
//  FMDBTool.m
//  PixelCloud
//
//  Created by Qingyun Wei on 2025/2/25.
//

#import "FMDBTool.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"

@implementation FMDBTool

static FMDatabase *_db;
static FMDatabaseQueue *_dbQueue;

+ (void)initialize
{
    // 获取沙盒路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //NSLog(@"沙盒路径docPath == %@",docPath);
    // 设置数据库名称
    NSString *fileName = [docPath stringByAppendingPathComponent:@"PixelCoud.sqlite"];
    // 创建并获取数据库信息
    _db = [FMDatabase databaseWithPath:fileName];
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:[fileName copy]];
    
    if ([_db open]) {
       // NSLog(@"数据库打开成功！");
    }else{
       // NSLog(@"数据库打开失败！");
    }
}

#pragma mark - ---事务---

/// 启用事务
+ (BOOL)startUsingTransaction
{
   // NSLog(@"启用事务");
    return [_db beginTransaction];
}

/// 提交事务
+ (BOOL)commitTransaction
{
   // NSLog(@"提交事务");
    return [_db commit];
}

/// 回滚事务
+ (BOOL)backTransaction
{
    return [_db rollback];
}

#pragma mark - ---创建、新增---

/// 创建表
/// @param tabName 表名
+ (void)createTableWithTabName:(NSString *)tabName dataList:(NSArray *)list andHandle:(void (^ _Nullable)(BOOL isSuccess))handle
{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",tabName];
    BOOL isCompleteSql = NO;
    for (NSDictionary *userDict in list) {
        NSArray *allKeyArr = [userDict allKeys];
        if (isCompleteSql == NO) {
            for (int i=0; i<allKeyArr.count; i++) {
                NSString *keyStr = [NSString stringWithFormat:@"%@",allKeyArr[i]];
                NSString *appendStr = @"";
                if (i==allKeyArr.count-1) {
                    appendStr = [NSString stringWithFormat:@" %@ text);",keyStr];
                    isCompleteSql = YES;
                } else if (i==0) {
                    appendStr = [NSString stringWithFormat:@"%@ text,",keyStr];
                } else {
                    appendStr = [NSString stringWithFormat:@" %@ text,",keyStr];
                }
                sql = [NSString stringWithFormat:@"%@%@",sql,appendStr];
            }
        } else {
            break;
        }
    }
    //NSLog(@"SQL语句 == %@",sql);
    
    BOOL executeUpdate = [_db executeUpdate:sql];
    if (executeUpdate) {
       // NSLog(@"打开或创建表成功 == %@",tabName);
    } else {
       // NSLog(@"打开或创建表失败");
    }
    handle(executeUpdate);
}

/// 创建表
/// @param tabName 表名
+ (void)createTableWithTabName:(NSString *)tabName dataDict:(NSDictionary *)dict andHandle:(void (^ _Nullable)(BOOL isSuccess))handle
{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",tabName];
    NSArray *allKeyArr = [dict allKeys];
    for (int i=0; i<allKeyArr.count; i++) {
        NSString *keyStr = [NSString stringWithFormat:@"%@",allKeyArr[i]];
        NSString *appendStr = @"";
        if (i==allKeyArr.count-1) {
            appendStr = [NSString stringWithFormat:@" %@ text);",keyStr];
        }else if (i==0) {
            appendStr = [NSString stringWithFormat:@"%@ text,",keyStr];
        }else {
            appendStr = [NSString stringWithFormat:@" %@ text,",keyStr];
        }
        sql = [NSString stringWithFormat:@"%@%@",sql,appendStr];
    }
    //NSLog(@"SQL语句 == %@",sql);
    
    BOOL executeUpdate = [_db executeUpdate:sql];
    if (executeUpdate) {
       // NSLog(@"打开或创建表成功 == %@",tabName);
    }else {
       // NSLog(@"打开或创建表失败 == %@ == \n SQL ++ %@ ++",tabName, sql);
    }
    handle(executeUpdate);
}

#pragma mark - ---储存、更新---
/// 储存列表
/// @param tabName 表名
/// @param list list 列表数据
+ (void)saveDataListWithTabName:(NSString *)tabName dataList:(NSArray *)list andHandle:(void (^ _Nullable)(BOOL isSuccess))handle
{
    // 如果没数据则不执行下面的操作
    if (list.count == 0) {
        handle(NO);
        return;
    }
    
    // 检查表是否已创建
    [FMDBTool checkTableIsCreateWithTableName:tabName andHandle:^(BOOL isSuccess) {
        if (isSuccess == YES) {
            // 创建了直接插入数据
            handle([self saveInsertDataTabName:tabName dataList:list]);
        } else {
            // 未创建则先创建
            [FMDBTool createTableWithTabName:tabName dataDict:list.firstObject andHandle:^(BOOL isSuccess) {
                if (isSuccess == NO) {
                    // 创建失败直接返回失败
                    handle(isSuccess);
                } else {
                    handle([self saveInsertDataTabName:tabName dataList:list]);
                }
            }];
        }
    }];
}

//插入数据
+ (BOOL)saveInsertDataTabName:(NSString *)tabName dataList:(NSArray *)list{
    BOOL isSuccess = NO;
    for (NSDictionary *userDict in list) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (",tabName];
        NSString *valueSql = @" VALUES (";
        NSArray *allKeyArr = [userDict allKeys];
        NSMutableArray *valueList = [NSMutableArray arrayWithCapacity:allKeyArr.count];
        //NSLog(@"\n\n开始组装数据");
        for (int i=0; i<allKeyArr.count; i++) {
            NSString *keyStr = [NSString stringWithFormat:@"%@",allKeyArr[i]];
            NSString *valueStr = [NSString stringWithFormat:@"%@",[userDict objectForKey:keyStr]];
            //NSLog(@"打印的Key == %@  Value == %@",keyStr,valueStr);
            NSString *appendKeyStr = @"";
            NSString *appendValueStr = @"";
            if (i == allKeyArr.count-1) {
                appendKeyStr = [NSString stringWithFormat:@"%@)",keyStr];
                appendValueStr = @"?)";
            }else {
                appendKeyStr = [NSString stringWithFormat:@"%@, ",keyStr];
                appendValueStr = @"?,";
            }
            sql = [NSString stringWithFormat:@"%@%@",sql,appendKeyStr];
            valueSql = [NSString stringWithFormat:@"%@%@",valueSql,appendValueStr];
            [valueList insertObject:valueStr atIndex:i];
        }
        
        NSString *newSql = [NSString stringWithFormat:@"%@%@",sql,valueSql];
        //NSLog(@"储存表的SQL语句 == %@ \n\n 值 == %@",newSql,valueList);
        isSuccess = [_db executeUpdate:newSql withArgumentsInArray:[valueList copy]];
        if (isSuccess) {
            //NSLog(@"插入成功== %@ ==",tabName);
        }else {
            //NSLog(@"插入失败 -- %@ --",newSql);
            NSArray *allKeyList = [self takeTableAllKeysWithTable:tabName];
            NSMutableSet *allKeyArrSet = [NSMutableSet setWithArray:allKeyArr];
            NSMutableSet *allKeyListSet = [NSMutableSet setWithArray:allKeyList];
            [allKeyListSet minusSet:allKeyArrSet];
            NSArray *newAllKeyList = [allKeyArrSet allObjects];
            if (newAllKeyList.count > 0) {
                BOOL isAddNewKey = NO;
                for (NSString *newKeyStr in newAllKeyList) {
                    if (![_db columnExists:newKeyStr inTableWithName:tabName]) {
                        NSString *alterStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ text",tabName,newKeyStr];
                        BOOL isNewSuccess = [_db executeUpdate:alterStr];
                        if(isNewSuccess){
                            //ZFLog(@"新增字段成功");
                            isAddNewKey = YES;
                        }else{
                            isAddNewKey = NO;
                            break;
                            //ZFLog(@"新增字段失败");
                        }
                    }
                }
                if (isAddNewKey == YES) {
                    BOOL isNewSuccess = [_db executeUpdate:newSql withArgumentsInArray:[valueList copy]];
                    if (isNewSuccess) {
                       // NSLog(@"新增字段后插入成功");
                    }else {
                       // NSLog(@"新增字段后仍然失败");
                    }
                }
            }else {
               // NSLog(@"数据插入失败但不是缺少字段的原因");
            }
        }
    }
    return isSuccess;
}

/// 储存对象（单个）
/// @param tabName tabName description
/// @param dict dict description
+ (void)saveDataListWithTabName:(NSString *)tabName dataDict:(NSDictionary *)dict
{
    NSArray *arr = @[dict];
    [self saveDataListWithTabName:tabName dataList:arr andHandle:^(BOOL isSuccess) {
        
    }];
}

// 查找数据是否存在
+ (BOOL)searchDataWithTableName:(NSString *)tabName andCondition:(NSString *)condition
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ %@;",tabName,condition];
    FMResultSet *resultSet = [_db executeQuery:sql];
    NSDictionary *result = nil;
    while (resultSet.next) {
        result = [resultSet resultDictionary];
        //NSLog(@"查询到的数据 == %@\n\n == %@ ==",result,sql);
    }
    if (result != nil) {
        return YES;
    }
    return NO;
}

/// 根据条件更新某个字段的值
+ (BOOL)updateDataWithTable:(NSString *)tabName key:(NSString *)keyStr value:(NSString *)valueStr condition:(NSString *)condition
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@='%@' %@;",tabName,keyStr,valueStr,condition];
    BOOL isSuccess = [_db executeUpdate:sql];
    
    return isSuccess;
}

/// 根据条件更新某个字段的值（2个值）
+ (BOOL)updateDataWithTable:(NSString *)tabName key:(NSString *)keyStr value:(NSString *)valueStr key2:(NSString *)keyStr2 value2:(NSString *)valueStr2 condition:(NSString *)condition
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@='%@',%@='%@' %@;",tabName,keyStr,valueStr,keyStr2,valueStr2,condition];
    BOOL isSuccess = [_db executeUpdate:sql];
    
    return isSuccess;
}

#pragma mark - ---删除、清空---

/// 删除表
/// @param tabName 表名
+ (void)deleteTableWithTab:(NSString *)tabName
{
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@;",tabName];
    BOOL isSuccess = [_db executeUpdate:sql];
    if (isSuccess) {
        //NSLog(@"--- %@ ---表删除成功",tabName);
    }else {
        //NSLog(@"--- %@ ---表删除失败",tabName);
    }
}

/// 清空表(不删除)
/// @param tabName 表名
+ (void)clearTableWithTab:(NSString *)tabName andHandle:(void (^ _Nullable)(BOOL isSuccess))handle
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@;",tabName];
    BOOL isSuccess = [_db executeUpdate:sql];
    handle (isSuccess);
}
/// 删除数据
/// @param tabName <#tabName description#>
/// @param condition 自定义条件
+ (BOOL)deleteDataWithTab:(NSString *)tabName condition:(nullable NSString *)condition
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ %@;",tabName,condition];
    BOOL isSuccess = [_db executeUpdate:sql];
    
    return isSuccess;
}

/// 删除指定数据
/// @param tabName tabName description
/// @param key key description
/// @param value value description
+ (void)deleteDataWithTab:(NSString *)tabName key:(NSString *)key value:(NSString *)value andHandle:(void (^ _Nullable)(BOOL isSuccess))handle
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@';",tabName,key,value];
    BOOL isSuccess = [_db executeUpdate:sql];
    
    handle(isSuccess);
}

/// 根据 key 批量删除数据
/// @param tabName tabName description
/// @param key key description
/// @param valueArr valueArr description
+ (void)deleteDataWithTab:(NSString *)tabName key:(NSString *)key valueArray:(NSArray *)valueArr andHandle:(void (^ _Nullable)(BOOL isSuccess))handle
{
    NSString *valueArrStr = [valueArr componentsJoinedByString:@","];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ IN (%@);",tabName,key,valueArrStr];
   // NSLog(@"批量删除== %@ ==",sql);
    BOOL isSuccess = [_db executeUpdate:sql];
    
    handle(isSuccess);
}

#pragma mark - ---查询、查找---

/// 查找一张表里的数据
/// @param tabName 表名
+ (NSArray *)searchObjWithTable:(NSString *)tabName
{
    NSArray *resultArr = [self searchObjWithTable:tabName condition:@""];
    
    return resultArr;
}

/// 查找一张表里的数据
/// @param tabName 表名
+ (void)searchObjWithTable:(NSString *)tabName andHandle:(void (^ _Nullable)(NSArray * _Nullable dataArray))handle
{
    [self searchObjWithTable:tabName condition:@"" andHandle:handle];
}

/// 查找一张表里的数据
/// @param tabName 表名
/// @param condition 附加条件
+ (NSArray *)searchObjWithTable:(NSString *)tabName condition:(nullable NSString *)condition
{
    if (condition == nil) {
        condition = @"";
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ %@;",tabName,condition];
    FMResultSet *resultSet = [_db executeQuery:sql];
    NSMutableArray *resultList = [NSMutableArray array];
    while (resultSet.next) {
        NSDictionary *result = [resultSet resultDictionary];
        [resultList addObject:result];
    }
    return [resultList copy];
}

/// 查找一张表里的特定数据
/// @param tabName 表名
/// @param fieldStr 字段名
/// @param condition 附加条件
+ (NSArray *)searchObjWithTable:(NSString *)tabName fieldStr:(NSString *)fieldStr condition:(nullable NSString *)condition
{
    if (condition == nil) {
        condition = @"";
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ %@;",fieldStr,tabName,condition];
    FMResultSet *resultSet = [_db executeQuery:sql];
    NSMutableArray *resultList = [NSMutableArray array];
    while (resultSet.next) {
        NSDictionary *result = [resultSet resultDictionary];
        [resultList addObject:result];
    }
    return [resultList copy];
}

/// 查找一张表里的特定数据
/// @param tabName 表名
/// @param fieldStr 字段名 每个值都是唯一的，去重
+ (NSArray *)searchOnlyObjWithTable:(NSString *)tabName fieldStr:(NSString *)fieldStr
{
    NSArray *arr = [self searchOnlyObjWithTable:tabName fieldStr:fieldStr condition:@""];
    
    return arr;
}

/// 查找一张表里的特定数据
/// @param tabName 表名
/// @param fieldStr 字段名 每个值都是唯一的，去重
/// @param condition 附加条件
+ (NSArray *)searchOnlyObjWithTable:(NSString *)tabName fieldStr:(NSString *)fieldStr condition:(nullable NSString *)condition
{
    if (condition == nil) {
        condition = @"";
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT DISTINCT %@ FROM %@ %@;",fieldStr,tabName,condition];
    FMResultSet *resultSet = [_db executeQuery:sql];
    NSMutableArray *resultList = [NSMutableArray array];
    while (resultSet.next) {
        //NSDictionary *result = [resultSet resultDictionary];
        NSString *result = [resultSet stringForColumn:fieldStr];
        [resultList addObject:result];
    }
    return [resultList copy];
}

/// 查找一张表里的数据
/// @param tabName 表名
/// @param condition 附加条件
+ (void)searchObjWithTable:(NSString *)tabName condition:(nullable NSString *)condition andHandle:(void (^ _Nullable)(NSArray * _Nullable dataArray))handle
{
    if (condition == nil) {
        condition = @"";
    }
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __block NSMutableArray *resultList = [NSMutableArray array];
    
    dispatch_group_async(group, queue, ^{
        [_dbQueue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ %@;",tabName,condition];
            FMResultSet *resultSet = [db executeQuery:sql];
            while (resultSet.next) {
                NSDictionary *result = [resultSet resultDictionary];
                [resultList addObject:result];
            }
        }];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (handle) {
            handle([resultList copy]);
        }
    });
}

/// 查找一张表里有多少条数据
+ (NSInteger)searchObjCountWithTable:(NSString *)tabName
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(sku) FROM %@;",tabName];
    NSInteger count = (NSInteger)[_db intForQuery:sql];
    
    return count;
}

/// 根据字段查找数据（单个）
/// @param tab tab description
/// @param key key description
/// @param value value description
+ (NSDictionary *)searchObjWithTable:(NSString *)tab key:(NSString *)key value:(NSString *)value
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@';",tab,key,value];
    FMResultSet *resultSet = [_db executeQuery:sql];
    NSDictionary *result = nil;
    while (resultSet.next) {
        result = [resultSet resultDictionary];
    }
    return result;
}

/// 根据字段查找数据（单个）
/// @param tab tab description
/// @param key key description
/// @param value value description
+ (void)searchObjWithTable:(NSString *)tab key:(NSString *)key value:(NSString *)value andHandle:(void (^ _Nullable)(NSDictionary * _Nullable dataDict))handle
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __block NSDictionary *result = [NSDictionary dictionary];
    
    dispatch_group_async(group, queue, ^{
        [_dbQueue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@';",tab,key,value];
            FMResultSet *resultSet = [db executeQuery:sql];
            while (resultSet.next) {
                result = [resultSet resultDictionary];
            }
        }];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (handle) {
            handle([result copy]);
        }
    });
}

+ (NSDictionary *)searchDictWithTable:(NSString *)tabName conditionStr:(nullable NSString *)condition
{
    if (condition == nil) {
        condition = @"";
    }
    NSDictionary *result = [NSDictionary dictionary];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ %@;",tabName,condition];
    FMResultSet *resultSet = [_db executeQuery:sql];
    while (resultSet.next) {
        result = [resultSet resultDictionary];
    }
    
    return result;
    
}

/// 查找一张表里的数据（单条）
/// @param tabName 表名
/// @param condition 附加条件
+ (void)searchDictWithTable:(NSString *)tabName conditionStr:(nullable NSString *)condition andHandle:(void (^ _Nullable)(NSDictionary * _Nullable dataDict))handle
{
    if (condition == nil) {
        condition = @"";
    }
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __block NSDictionary *result = [NSDictionary dictionary];
    
    dispatch_group_async(group, queue, ^{
        [_dbQueue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ %@;",tabName,condition];
            FMResultSet *resultSet = [db executeQuery:sql];
            while (resultSet.next) {
                result = [resultSet resultDictionary];
            }
        }];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (handle) {
            handle([result copy]);
        }
    });
}

/// 根据字段查找数据（多个）
/// @param tab tab description
/// @param key key description
/// @param value value description
+ (NSArray *)searchObjArrayWithTable:(NSString *)tab key:(NSString *)key value:(NSString *)value
{
    NSArray *arr = [self searchObjArrayWithTable:tab key:key value:value condition:@""];
    
    return arr;
    
}

/// 根据字段查找数据（多个）
/// @param tab tab description
/// @param key key description
/// @param value value description
+ (NSArray *)searchObjArrayWithTable:(NSString *)tab key:(NSString *)key value:(NSString *)value condition:(nullable NSString *)condition
{
    if (!condition) {
        condition = @"";
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' %@;",tab,key,value,condition];
    FMResultSet *resultSet = [_db executeQuery:sql];
    NSMutableArray *resultList = [NSMutableArray array];
    while (resultSet.next) {
        NSDictionary *result = [resultSet resultDictionary];
        [resultList addObject:result];
    }
    return [resultList copy];
}

/// 获取表里所有的字段
/// @param tabName 表名
+ (NSArray *)takeTableAllKeysWithTable:(NSString *)tabName
{
    NSString *sql = [NSString stringWithFormat:@"PRAGMA table_info(%@);",tabName];
    FMResultSet *resultSet = [_db executeQuery:sql];
    if (resultSet) {
        NSMutableArray *resultList = [NSMutableArray array];
        while (resultSet.next) {
            NSString *keyStr = [resultSet stringForColumn:@"name"];
            [resultList addObject:keyStr];
        }
        return [resultList copy];
    }
    return @[];
}


// 搜索某个表的某条数据的某个字段的值
+ (NSString *)searchValueWithTabName:(NSString *)tabName andKey:(NSString *)keyStr condition:(nullable NSString *)condition
{
    if (condition==nil) {
        condition = @"";
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ %@;",keyStr,tabName,condition];
    FMResultSet *resultSet = [_db executeQuery:sql];
    NSString *resultStr = @"";
    while (resultSet.next) {
        resultStr = [resultSet stringForColumn:keyStr];
    }
    return resultStr ? resultStr : @"";
}

/// 搜索某张表里的某个字段的全部数据
/// @param tabName tabName description
/// @param keyStr keyStr description
/// @param condition condition description
+ (NSArray *)searchValuesWithTabName:(NSString *)tabName andKey:(NSString *)keyStr condition:(nullable NSString *)condition
{
    if (condition==nil) {
        condition = @"";
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ %@;",keyStr,tabName,condition];
    FMResultSet *resultSet = [_db executeQuery:sql];
    NSMutableArray *resultArr = [NSMutableArray array];
    while (resultSet.next) {
        NSString *resultStr = [resultSet stringForColumn:keyStr];
        [resultArr addObject:resultStr];
    }
    
    return [resultArr copy];
}

/// 查询表是否已创建
+ (void)checkTableIsCreateWithTableName:(NSString *)tabName andHandle:(void (^ _Nullable)(BOOL isSuccess))handle
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM sqlite_master WHERE type = 'table' AND name = '%@';",tabName];
    FMResultSet *resultSet = [_db executeQuery:sql];
    NSMutableArray *resultList = [NSMutableArray array];
    while (resultSet.next) {
        NSDictionary *result = [resultSet resultDictionary];
        [resultList addObject:result];
    }
    BOOL isSuccess = NO;
    if (resultList.count > 0) {
        isSuccess = YES;
    }
    handle(isSuccess);
}

/// 检查某条数据是否存在数据库，附带自定义条件
+ (BOOL)checkDataExistWithTable:(NSString *)tabName key:(NSString *)keyStr value:(NSString *)valueStr condition:(nullable NSString *)condition
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(%@) AS countNum FROM %@ WHERE %@ = '%@' %@;",keyStr,tabName,keyStr,valueStr,condition];
    FMResultSet *resultSet = [_db executeQuery:sql];
    while (resultSet.next) {
        NSInteger count = [resultSet intForColumn:@"countNum"];
        if (count > 0) {
            return YES;
        }
    }
    return NO;
}

/// 检查某条数据是否存在数据库，附带自定义条件
+ (BOOL)checkDataExistWithTable:(NSString *)tabName key:(NSString *)keyStr condition:(nullable NSString *)condition
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(%@) AS countNum FROM %@ %@;",keyStr,tabName,condition];
    FMResultSet *resultSet = [_db executeQuery:sql];
    while (resultSet.next) {
        NSInteger count = [resultSet intForColumn:@"countNum"];
        if (count > 0) {
            return YES;
        }
    }
    return NO;
}

/// 查询某张表里的某类数据的数量
+ (NSInteger)searchDataCountWithTable:(NSString *)tabName key:(NSString *)keyStr value:(NSString *)valueStr
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(%@) AS countNum FROM %@ WHERE %@ = '%@';",keyStr,tabName,keyStr,valueStr];
    NSInteger count = 0;
    FMResultSet *resultSet = [_db executeQuery:sql];
    while (resultSet.next) {
        count = [resultSet intForColumn:@"countNum"];
    }
    return count;
}

/// 查询某张表里的某类数据的数量，附带自定义条件
+ (NSInteger)searchDataCountWithTable:(NSString *)tabName key:(NSString *)keyStr condition:(nullable NSString *)condition
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(%@) AS countNum FROM %@ %@;",keyStr,tabName,condition];
    NSInteger count = 0;
    FMResultSet *resultSet = [_db executeQuery:sql];
    while (resultSet.next) {
        count = [resultSet intForColumn:@"countNum"];
    }
    return count;
}

/// 查询统计某张表里的某个字段的数量总和，附带自定义条件
+ (NSInteger)searchDataSumCountWithTable:(NSString *)tabName key:(NSString *)keyStr condition:(nullable NSString *)condition
{
    NSString *sql = [NSString stringWithFormat:@"SELECT sum(%@) AS countNum FROM %@ %@;",keyStr,tabName,condition];
    NSInteger count = 0;
    FMResultSet *resultSet = [_db executeQuery:sql];
    while (resultSet.next) {
        count = [resultSet intForColumn:@"countNum"];
    }
    return count;
}

/// 批量查询指定组数据
+ (NSArray *)searchDataWithTable:(NSString *)tabName keyStr:(NSString *)keyStr valuse:(NSArray *)valueArr
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ IN (",tabName,keyStr];
    for (int i=0; i<valueArr.count; i++) {
        NSString *appendValueStr = @"";
        if (i == valueArr.count-1) {
            appendValueStr = @"?)";
        }else {
            appendValueStr = @"?,";
        }
        sql = [NSString stringWithFormat:@"%@%@",sql,appendValueStr];
    }
    
    FMResultSet *resultSet = [_db executeQuery:sql withArgumentsInArray:valueArr];
    NSMutableArray *resultList = [NSMutableArray array];
    while (resultSet.next) {
        NSDictionary *result = [resultSet resultDictionary];
        [resultList addObject:result];
    }
    
    return [resultList copy];
}

@end
