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

#pragma mark- *   创建表     */
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

+ (BOOL)createTableWithTableName:(NSString *)tableName
{
    /**
     *   创建表(id, access_token, statuse_idstr, statues_dict     */
    NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@\
                           (id INTEGER PRIMARY KEY AUTOINCREMENT,\
                           %@ TEXT NOT NULL,\
                           %@ TEXT NOT NULL,\
                           %@ TEXT,\
                           %@ TEXT,\
                           %@ TEXT,\
                           %@ Text,\
                           %@ TEXT,\
                           %@ TEXT,\
                           %@ TEXT,\
                           %@ BLOB NOT NULL);", tableName, dbIdStr, dbGetTime, dbUserGetTime, dbMemberId, dbMemberName, dbLatest, dbHotest, dbNodeName, dbTabName, dbDictData];
    
    if ([V2DB executeUpdate:createSql]) {
        NSLog(@"创建%@成功", tableName);
        return YES;
    } else
    {
        NSLog(@"创建%@失败", tableName);
        return NO;
    }
}



#pragma mark- 取数据

/**
 *   从表获取所有数据     */
+ (NSArray<NSDictionary *> *)allDataFromDataBaseFromTable:(NSString *)tableName
{
    return [self queryDataFromTable:tableName withId:nil];
}

/**
 *   取数据     */
+ (NSArray<NSDictionary *> *)getDataWithQuery:(NSString *)query
{
    NSMutableArray *arrayM = [NSMutableArray array];
    
    FMResultSet *resultset = [V2DB executeQuery:query];
    
    while ([resultset next]) {
        
        NSData *data = [resultset dataForColumn:dbDictData];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [arrayM addObject:dict];
    }
    
    return [arrayM copy];
}


/**
 *   从表中取某 tab 的数据     */
+ (NSArray<NSDictionary *> *)allDataFromDataBaseFromTable:(NSString *)tableName tabName:(NSString *)tabName
{
    NSString *query = nil;

    query = [NSString stringWithFormat:@"SELECT %@, %@ FROM %@ WHERE %@ = '%@' ORDER BY %@ DESC ", dbIdStr, dbDictData, tableName, dbTabName, tabName, dbGetTime];
    YCLog(@"query: %@", query);
    return [self getDataWithQuery:query];
    
}

/**
 *   从表中取某 node 的数据     */
+ (NSArray<NSDictionary *> *)allDataFromDataBaseFromTable:(NSString *)tableName nodeName:(NSString *)nodeName
{
    NSString *query = nil;
    
    query = [NSString stringWithFormat:@"SELECT %@, %@ FROM %@ WHERE %@ = '%@' ORDER BY %@ DESC ", dbIdStr, dbDictData, tableName, dbNodeName, nodeName, dbGetTime];
    
    return [self getDataWithQuery:query];
}

/**
 *   从表中取某 member 的数据     */
+ (NSArray<NSDictionary *> *)allDataFromDataBaseFromTable:(NSString *)tableName memberId:(NSString *)memberId orMemberName:(NSString *)memberName
{
    NSString *query = nil;
    if (memberId)
    {
        query = [NSString stringWithFormat:@"SELECT %@, %@ FROM %@ WHERE %@ = '%@' ORDER BY %@ DESC ", dbIdStr, dbDictData, tableName, dbMemberId, memberId, dbGetTime];
    } else {
        query = [NSString stringWithFormat:@"SELECT %@, %@ FROM %@ WHERE %@ = '%@' ORDER BY %@ DESC ", dbIdStr, dbDictData, tableName, dbMemberName, memberName, dbUserGetTime];
    }
    
    return [self getDataWithQuery:query];
}

/**
 *   取最热     */
+ (NSArray<NSDictionary *> *)allHotestDataFromDataBaseFromTable:(NSString *)tableName
{
    NSString *query = nil;
    
    query = [NSString stringWithFormat:@"SELECT %@, %@ FROM %@ WHERE %@ = '%@' ORDER BY %@ DESC ", dbIdStr, dbDictData, tableName, dbHotest, @"1", dbGetTime];
    
    return [self getDataWithQuery:query];
}

/**
 *   取最新     */
+ (NSArray<NSDictionary *> *)allLatestDataFromDataBaseFromTable:(NSString *)tableName
{
    NSString *query = nil;
    
    query = [NSString stringWithFormat:@"SELECT %@, %@ FROM %@ WHERE %@ = '%@' ORDER BY %@ DESC ", dbIdStr, dbDictData, tableName, dbLatest, @"1", dbGetTime];
    
    return [self getDataWithQuery:query];
}

#pragma mark- 存数据
/**
 *   保存数组到表xxx/用     */
+ (BOOL)saveDataArray:(NSArray<NSDictionary *> *)dataArray toTable:(NSString *)tableName withClear:(BOOL)isClearAll needSearch:(BOOL)needSearch
{
    if (isClearAll) {
        /**
         *   更新了就清空原来的表     */
        [self clearTable:tableName];
        [self insertDictArray:dataArray ToTable:tableName];
        
    } else {    //  不需要清空
        //  是否查了, 没有再插入
        if (needSearch) {
            [dataArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([self queryDataFromTable:tableName withId:dict[@"id"]].count <= 0) {
                    [self insertDict:dict ToTable:tableName];
                }
            }];
            
        } else
        {   //  直接删掉原来的再插入
            [self deleteDictArray:dataArray fromTable:tableName];
            [self insertDictArray:dataArray ToTable:tableName];
        }
    }
    
    
    return YES;
}

/**
 *   将一个字典存到某个表     */
+ (BOOL)insertDict:(NSDictionary *)dict ToTable:(NSString *)tableName
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    
    if ([tableName isEqualToString:dbTopicsT]) {
        
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO %@(%@, %@, %@, %@, %@, %@, %@, %@) VALUES(?, ?, ?, ?, ?, ?, ?, ?);", tableName, dbIdStr, dbGetTime, dbMemberId, dbLatest, dbHotest, dbNodeName, dbTabName, dbDictData];
        
        
        return [V2DB executeUpdate:insert, dict[@"id"], dict[@"getTime"], dict[@"member"][@"username"], dict[@"lastest"], dict[@"hotest"], dict[@"node"][@"name"], dict[@"tab"], data];
        
    } else if ([tableName isEqualToString:dbAllNodesT]) {
        
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO %@(%@, %@) VALUES(?, ?);", tableName, dbIdStr, dbDictData];
        
        return [V2DB executeUpdate:insert, dict[@"id"], data];
        
    } else if ([tableName isEqualToString:dbNodeNavT]) {
        
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO %@(%@, %@) VALUES(?, ?);", tableName, dbIdStr, dbDictData];
        
        return [V2DB executeUpdate:insert, dict[@"groupTitle"], data];
    }
    
    else
    {
        return NO;
    }
}

/**
 *   将一个字典数组存到某个表     */
+ (BOOL)insertDictArray:(NSArray<NSDictionary *> *)dictArray ToTable:(NSString *)tableName
{
    __block int i = 0;
    [dictArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self insertDict:dict ToTable:tableName]) {
            i++;
        }
    }];
    
    return i == dictArray.count;
}

#pragma mark- 查

/**
 *   根据 id 查表     */
+ (NSArray<NSDictionary *> *)queryDataFromTable:(NSString *)tableName withId:(NSString *)idStr
{
    NSString *query = nil;
    if (idStr) {
        query = [NSString stringWithFormat:@"SELECT %@, %@ FROM %@ WHERE %@ = '%@' ORDER BY %@ DESC ", dbIdStr, dbDictData, tableName, dbIdStr, idStr, dbGetTime];
    } else
    {
        query = [NSString stringWithFormat:@"SELECT %@, %@ FROM %@;", dbIdStr, dbDictData, tableName];
    }
    
    return [self getDataWithQuery:query];
}



 #pragma mark- 删

/**
 *   删除表中某个 id 的值     */
+ (BOOL)deleteDict:(NSDictionary *)dict fromTable:(NSString *)tableName outDate:(NSString *)date
{
    NSString *delete = nil;
    if (dict) {
        delete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@';", tableName, dbIdStr, dict[@"id"]];
    } else if (date)
    {
        
        delete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ < '%@';", tableName, dbGetTime, date];
    }
    else
    {
        delete = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    }
    
    return [V2DB executeUpdate:delete];
}

+ (BOOL)deleteDictArray:(NSArray<NSDictionary *> *)dictArray fromTable:(NSString *)tableName
{
    __block int i = 0;
    [dictArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self deleteDict:dict fromTable:tableName outDate:nil]) {
            i++;
        }
    }];
    return i == dictArray.count;
}
/**
 *   清除整个表的内容     */
+ (BOOL)clearTable:(NSString *)tableName
{
    return [self deleteDict:nil fromTable:tableName outDate:nil];
}

/**
 *   清除过期内容     */
+ (BOOL)clearOutDateTopicInTable:(NSString *)tableName outDate:(NSString *)outDate
{
    return [self deleteDict:nil fromTable:tableName outDate:outDate];
}

@end
