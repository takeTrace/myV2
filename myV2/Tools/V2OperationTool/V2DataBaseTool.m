//
//  V2DataBaseTool.m
//  myV2
//
//  Created by Mac on 16/8/31.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2DataBaseTool.h"
#import "YCGloble.h"

@implementation V2DataBaseTool
/**
 *    数据库     */
static const FMDatabase *V2DB;

/**
 *   创建数据库
 */
+ (void)initialize
{
    if (self == [V2DataBaseTool class]) {
        V2DB = [FMDatabase databaseWithPath:[YCDocumentPath stringByAppendingPathComponent:V2DBName]];
    }
}

#pragma mark- 数据库存取方法

/**
 *   数据库是否发开     */
+ (BOOL)openDataBase
{
    return [V2DB open];
}
/**
 *   创建表     */
+ (BOOL)createTableWithTableName:(NSString *)tableName idStr:(NSString *)idStr blobStr:(NSString *)blobStr
{
    /**
     *   创建表(id, access_token, statuse_idstr, statues_dict     */
    NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@\
                           (id INTEGER PRIMARY KEY AUTOINCREMENT,\
                           %@ TEXT NOT NULL,\
                           %@ BLOB NOT NULL);", tableName, idStr, blobStr];
    
    if ([V2DB executeUpdate:createSql]) {
        NSLog(@"创建%@成功", tableName);
        return YES;
    } else
    {
        NSLog(@"创建%@失败", tableName);
        return NO;
    }
}

/**
 *   保存数组到表xxx     */
+ (BOOL)saveDataArray:(NSArray<NSDictionary *> *)dataArray toTable:(NSString *)tableName
{
    /**
     *   更新了就清空原来的表     */
    [self clearTable:tableName];
    
    [dataArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [self insertDict:dict ToTable:tableName];
    }];
    
    return YES;
}

/**
 *   从表获取所有数据     */
+ (NSArray<NSDictionary *> *)allDataFromDataBaseFromTable:(NSString *)tableName
{
    return [self queryDataFromTable:tableName withId:nil];
}


/**
 *   清除整个表的内容     */
+ (BOOL)clearTable:(NSString *)tableName
{
    return [self deleteDict:nil fromTable:tableName];
}

/**
 *   根据 id 查表     */
+ (NSArray<NSDictionary *> *)queryDataFromTable:(NSString *)tableName withId:(NSString *)idStr
{
    NSString *query = nil;
    if (idStr) {
        query = [NSString stringWithFormat:@"SELECT %@, %@ FROM %@ DESC WHERE %@ = %@", dbIdStr, dbDictData, tableName, dbIdStr, idStr];
    } else
    {
        query = [NSString stringWithFormat:@"SELECT %@, %@ FROM %@;", dbIdStr, dbDictData, tableName];
    }
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    FMResultSet *resultset = [V2DB executeQuery:query];
    
    while ([resultset next]) {
        
        NSData *data = [resultset dataForColumn:dbDictData];
        
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        //        [arrayM addObject:[V2NodeModel mj_objectWithKeyValues:dict]];
        [arrayM addObject:dict];
    }
    
    return [arrayM copy];
}

/**
 *   将一个字典存到某个表     */
+ (BOOL)insertDict:(NSDictionary *)dict ToTable:(NSString *)tableName
{
    NSString *insert = [NSString stringWithFormat:@"INSERT INTO %@(%@, %@) VALUES(?, ?);", tableName, dbIdStr, dbDictData];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    
    return [V2DB executeUpdate:insert, dict[@"id"], data];
}

/**
 *   删除表中某个 id 的值     */
+ (BOOL)deleteDict:(NSDictionary *)dict fromTable:(NSString *)tableName
{
    NSString *delete = nil;
    if (dict) {
        delete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = %@;", tableName, dbIdStr, dict[@"id"]];
    } else
    {
        delete = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    }
    
    return [V2DB executeUpdate:delete];
}
@end
