//
//  V2DataBaseTool.h
//  myV2
//
//  Created by Mac on 16/8/31.
//  Copyright © 2016年 Lneayce. All rights reserved.
//  封装 FMDB 的操作

#import <Foundation/Foundation.h>
#import <FMDB.h>



#define V2DBName @"V2DB.sqlite"
#define dbIdStr @"idStr"
#define dbDictData @"DictData"
#define dbLatest @"isLatest"
#define dbHotest @"isHotest"
#define dbTabName @"TabName"
#define dbNodeName @"nodeName"
#define dbMemberId @"memberId"
#define dbMemberName @"memberName"
#define dbGetTime @"getTime"
#define dbUserGetTime @"userGetTime"
/**
 *   所有节点     */
#define dbAllNodesT @"t_allNodes"
#define dbNodeNavT @"t_nodeNav"
//#define dbIdStr @"all_node_idstr"
//#define dbDictData @"all_node_dict"
/**
 *   所有 tab     */
#define dbAllTabs @"t_allTabs"
/**
 *   最热数据     */
//#define dbHotTopicT @"t_hotestTopic"
//#define dbIdStr @"hot_topic_idstr"
//#define dbDictData @"hot_topic_dict"
/**
 *   最新数据     */
//#define dbLatestTopicT @"t_latestTopic"
//#define dbIdStr @"latest_topic_idstr"
//#define dbDictData @"latest_topic_dict"

/**
 *   话题集合     */
#define dbTopicsT @"t_topics"


@interface V2DataBaseTool : NSObject
#pragma mark- 数据库存取方法
/**
 *   数据库是否发开     */
+ (BOOL)openDataBase;
/**
 *   创建表     */
+ (BOOL)createTableWithTableName:(NSString *)tableName idStr:(NSString *)idStr blobStr:(NSString *)blobStr;
/**
 *   创建 V2话题表     */
+ (BOOL)createTableWithTableName:(NSString *)tableName;

/**
 *   保存数组到表xxx     */
+ (BOOL)saveDataArray:(NSArray<NSDictionary *> *)dataArray toTable:(NSString *)tableName withClear:(BOOL)isClearAll needSearch:(BOOL)needSearch;

/**
 *   从表获取所有数据     */
+ (NSArray<NSDictionary *> *)allDataFromDataBaseFromTable:(NSString *)tableName;

/**
 *   从表中取某 tab 的数据     */
+ (NSArray<NSDictionary *> *)allDataFromDataBaseFromTable:(NSString *)tableName tabName:(NSString *)tabName;

/**
 *   从表中取某 node 的数据     */
+ (NSArray<NSDictionary *> *)allDataFromDataBaseFromTable:(NSString *)tableName nodeName:(NSString *)nodeName;

/**
 *   从表中取某 member 的数据     */
+ (NSArray<NSDictionary *> *)allDataFromDataBaseFromTable:(NSString *)tableName memberId:(NSString *)memberId orMemberName:(NSString *)memberName;

/**
 *   取最热     */
+ (NSArray<NSDictionary *> *)allHotestDataFromDataBaseFromTable:(NSString *)tableName;

/**
 *   取最新     */
+ (NSArray<NSDictionary *> *)allLatestDataFromDataBaseFromTable:(NSString *)tableName;

/**
 *   清除整个表的内容     */
+ (BOOL)clearTable:(NSString *)tableName;

/**
 *   根据 id 查表     */
+ (NSArray<NSDictionary *> *)queryDataFromTable:(NSString *)tableName withId:(NSString *)idStr;


/**
 *   将一个字典存到某个表     */
+ (BOOL)insertDict:(NSDictionary *)dict ToTable:(NSString *)tableName;


/**
 *   删除表中某个 id 的记录     */
+ (BOOL)deleteDict:(NSDictionary *)dict fromTable:(NSString *)tableName outDate:(NSString *)outDate;
/**
 *   删除过期数据     */
+ (BOOL)clearOutDateTopicInTable:(NSString *)tableName outDate:(NSString *)outDate;
@end
