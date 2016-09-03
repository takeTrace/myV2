//
//  V2DataManerger.m
//  myV2
//
//  Created by Mac on 16/8/31.
//  Copyright © 2016年 Lneayce. All rights reserved.
//  封装网络请求

#import "V2DataManager.h"
#import "V2OperationTool.h"
#import <MJExtension.h>
#import "V2DataBaseTool.h"
#import <FMDB.h>
#import "YCGloble.h"





#pragma mark- API
#define agetSiteInfo @"https://www.v2ex.com/api/site/info.json"
#define agetSiteState @"https://www.v2ex.com/api/site/stats.json"
#define agetAllNodes @"https://www.v2ex.com/api/nodes/all.json"
#define agetLatest @"https://www.v2ex.com/api/topics/latest.json"
#define agetHotest @"https://www.v2ex.com/api/topics/hot.json"

#define agetNode @"https://www.v2ex.com/api/nodes/show.json"
#define kNodeId @"id"
#define kNodeName @"name"

#define agetTopic @"https://www.v2ex.com/api/topics/show.json"
#define kTopicId @"id"
#define kTopicUsername @"username"
#define kTopicNodeId @"node_id"
#define kTopicNodeName @"node_name"

#define agetReplaies @"https://www.v2ex.com/api/replies/show.json"
#define kReplyTopicId @"topic_id"
#define kPage @"page"
#define kPageSize @"page_size"

#define agetMember @"https://www.v2ex.com/api/members/show.json"
#define kMemberId @"id"
#define kMemberName @"username"





#define kSiteInfoFile @"siteInfo"
#define kSiteStateFile @"siteState"
#define kAllNodesFile @"allNodes"
/**
 *   document文件   */
#define kUserUserDefaults [NSUserDefaults standardUserDefaults]


/**
 *   站点信息     */
static siteInfoModel *_siteInfo;
/**
 *    网站状况     */
static SiteStateModel *_siteState;
/**
 *   所有节点     */
static NSArray<V2NodeModel *> *_allNodes;
/**
 *   最新主题     */
static NSArray *_latestTopics;
/**
 *   最热主题     */
static NSArray *_hotestTopics;

/**
 *    数据库     */
static const FMDatabase *V2DB;
#define V2DBName @"V2DB.sqlite"
#define dbIdStr @"idStr"
#define dbDictData @"DictData"
/**
 *   所有节点     */
#define dbAllNodesT @"t_allNodes"
//#define dbIdStr @"all_node_idstr"
//#define dbDictData @"all_node_dict"
/**
 *   最热数据     */
#define dbHotTopicT @"t_hotestTopic"
//#define dbIdStr @"hot_topic_idstr"
//#define dbDictData @"hot_topic_dict"
/**
 *   最新数据     */
#define dbLatestTopicT @"t_latestTopic"
//#define dbIdStr @"latest_topic_idstr"
//#define dbDictData @"latest_topic_dict"




@implementation V2DataManager

+ (void)initialize
{
    if (self == [V2DataManager class]) {
        /**
         *   初始化管理者类     */
        //  初始话数据库
        [self setupAllNodesDB];
    }
}

+ (void)setupAllNodesDB
{
    V2DB = [FMDatabase databaseWithPath:[YCDocumentPath stringByAppendingPathComponent:V2DBName]];
    if ([V2DB open]) {
        /**
         *   创建三个表     */
        [self createTableWithTableName:dbAllNodesT idStr:dbIdStr blobStr:dbDictData];
        
        [self createTableWithTableName:dbHotTopicT idStr:dbIdStr blobStr:dbDictData];
        
        [self createTableWithTableName:dbLatestTopicT idStr:dbIdStr blobStr:dbDictData];
        
    }
}



+ (void)userDefualtsSave:(id)obj forKey:(NSString *)key
{
    [kUserUserDefaults setObject:obj forKey:key];
    [kUserUserDefaults synchronize];
}





#pragma mark- 公布的API 接口调用返回的数据
/**
 *   对应标签 tab 的话题     */
+ (void)getTopicsWithTab:(V2TabModel *)tab page:(NSNumber *)page success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure
{
    
}

/**
 *   获取某个节点的话题     */
+ (void)getTopicsWithNode:(V2NodeModel *)node success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure
{
    
}

/**
 *   解析 html 的话题和回复     */
+ (void)getTopicAndRepliesFromHtmlWithTopic:(V2TopicModel *)topic success:(void (^)(V2TopicModel *topic, NSArray<V2ReplyModel *> *replies))success failure:(void (^)(NSError *error))failure
{
    
}

/**
 *   获取更多话题     */
+ (void)getMoreTpoicsUnderTab:(V2TabModel *)tab success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure
{
    
}

/**
 *   获取 tabs     */
+ (void)getTabsSuccess:(void (^)(NSArray<V2TabModel *> *tabs))success failure:(void (^)(NSError *error))failure
{
    
}

/**
 *    更新 tabs     */
+ (void)updateTabsSuccess:(void (^)(NSArray<V2TabModel *> *tabs))success failure:(void (^)(NSError *error))failure
{
    
}

/**
 *   获取节点导航     */
+ (void)nodesNavigateGroupsSuccess:(void (^)(NSArray<V2NodesGroup *> *siteInfo))success failure:(void (^)(NSError *error))failure
{
    
}

/**
 *   更新节点导航     */
+ (void)updateNodesNavigateGroupsGroupsSuccess:(void (^)(NSArray<V2NodesGroup *> *siteInfo))success failure:(void (^)(NSError *error))failure
{
    
}



#pragma mark 站点
/**
 *   获取站点信息     */
+ (void)siteInfoSuccess:(void (^)(siteInfoModel *siteInfo, SiteStateModel *siteState))success failure:(void (^)(NSError *))failure
{
    /**
     *   有值就直接返回, 没有在加载     */
    if (_siteInfo && _siteState) {
        success(_siteInfo, _siteState);
        return;
    } else {
        /**
         *   先从缓存, 没有在网络     */
        _siteInfo = [siteInfoModel mj_objectWithKeyValues:[kUserUserDefaults objectForKey:kSiteInfoFile]];
        _siteState = [SiteStateModel mj_objectWithKeyValues:[kUserUserDefaults objectForKey:kSiteStateFile]];
        
        if (!_siteState || !_siteInfo) {
            [self updateSiteInfoSuccess:success failure:failure];
        } else {
            success(_siteInfo, _siteState);
        }
    }
}
/**
 *   更新站点信息     */
+ (void)updateSiteInfoSuccess:(void (^)(siteInfoModel *siteInfo, SiteStateModel *siteState))success failure:(void (^)(NSError *))failure
{
    [V2OperationTool GET:agetSiteInfo
                dataType:V2DataTypeJSON parameters:nil success:^(NSDictionary *responseObject) {
                    
                    
                    YCPlog;
                    YCLog(@"siteInfo %@", responseObject);
                    
                    _siteInfo = [siteInfoModel mj_objectWithKeyValues:responseObject];
                    
                    [self userDefualtsSave:responseObject forKey:kSiteInfoFile];
                    
                    
                    [V2OperationTool GET:agetSiteState dataType:V2DataTypeJSON parameters:nil success:^(id siteState) {
                        
                        YCPlog;
                        YCLog(@"siteInfo %@", siteState);
                        
                        _siteState = [SiteStateModel mj_objectWithKeyValues:siteState];
                        
                        [self userDefualtsSave:siteState forKey:kSiteStateFile];
                        
                        success(_siteInfo, _siteState);
                        
                    } failure:^(NSError *error) {
                        NSLog(@"更新站点状态失败");
                        
                        failure(error);
                        
                    }];
                    
                    
                } failure:^(NSError *error) {
                    NSLog(@"更新失败");
                    failure(error);
                }];
    
    

}


#pragma mark 节点
/**
 *   获取所有节点     */
+ (void)allNodesSuccess:(void (^)(NSArray<V2NodeModel *> *))success failure:(void (^)(NSError *))failure
{
    if (_allNodes) {
        //  有值直接返回
        success(_allNodes);
        
        return;
    } else {
        //  本来没值,从数据库加载
        _allNodes = [V2NodeModel mj_objectArrayWithKeyValuesArray:[self allDataFromDataBaseFromTable:dbAllNodesT]];
        
        if (_allNodes.count > 0) {
            success(_allNodes);
        } else {
            [self updateAllNodesSuccess:success failure:failure];
        }
        
    }
    
}

/**
 *   更新所有节点     */
+ (void)updateAllNodesSuccess:(void (^)(NSArray<V2NodeModel *> *))success failure:(void (^)(NSError *))failure
{
    [V2OperationTool GET:agetAllNodes
                dataType:V2DataTypeJSON parameters:nil success:^(NSArray<NSDictionary *> *responseObject) {
                    _allNodes = [V2NodeModel mj_objectArrayWithKeyValuesArray:responseObject];
                    
                    YCPlog;
                    /**
                     *   将所有节点的数据保存到...还是存到数据库吧....     */
                    [self saveDataArray:responseObject toTable:dbAllNodesT];
                    
                    
                    
                    success(_allNodes);
                    
                    
                } failure:^(NSError *error) {
                    NSLog(@"更新allnodes失败");
                    failure(error);
                }];
}

/**
 *   获取节点信息     */
+ (V2NodeModel *)getNodeWithId:(NSString *)idStr orName:(NSString *)nodeName success:(void (^)(V2NodeModel *))success failure:(void (^)(NSError *))failure
{
    if (!idStr && !nodeName) {
        NSLog(@"信息不全, 查询不了");
        return nil;
    }
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (idStr) {
        para[kNodeId] = idStr;
    } else {
        para[kNodeName] = nodeName;
    }
    
    [V2OperationTool GET:agetNode dataType:V2DataTypeJSON parameters:para success:^(id responseObject) {
        YCPlog;
        YCLog(@"node: %@", responseObject);
        
        V2NodeModel *node = [V2NodeModel mj_objectWithKeyValues:responseObject];
        
        success(node);
        
        /**
         *   更新数据库中对应节点的信息     */
        if ([self deleteDict:responseObject fromTable:dbAllNodesT]) {
            [self insertDict:responseObject ToTable:dbAllNodesT];
        } else
        {
            
            YCLog(@"更新节点到数据库失败");
        }
        
    } failure:^(NSError *error) {
        YCLog(@"获取失败");
        YCPlog;
        
        /**
         *   失败了从数据库取     */
        if (idStr) {
            NSDictionary *nodeDict = [[self queryDataFromTable:dbAllNodesT withId:idStr] firstObject];
            YCLog(@"nodeDict = %@", nodeDict);
            if (nodeDict) {
                V2NodeModel *node = [V2NodeModel mj_objectWithKeyValues:nodeDict];
                success(node);
            } else
            {
                failure(error);
            }
        }
    }];
    
    
    return nil;
}


#pragma mark 话题

/**
 *   获取某个主题     */
+ (V2TopicModel *)getTopicWithId:(NSString *)topicId success:(void (^)(V2TopicModel *))success failure:(void (^)(NSError *))failure
{
    //  有网就从网络, 没有就从缓存
    
    [V2OperationTool GET:agetTopic dataType:V2DataTypeJSON parameters:@{kTopicId:topicId} success:^(NSArray * responseObject) {
        
        YCPlog;
        YCLog(@"topic = %@", responseObject);
        
        /**
         *   更新数据     */
        //
        
        V2TopicModel *topic = [V2TopicModel mj_objectWithKeyValues:[responseObject firstObject]];
        
        success(topic);
        
    } failure:failure];
    
    return nil;
    
}



/**
 *   获取最新十大     */
+ (void)getLatestTopicsSuccess:(void (^)(NSArray<V2TopicModel *> *))success failure:(void (^)(NSError *))failure
{
    [V2OperationTool GET:agetLatest dataType:V2DataTypeJSON parameters:nil success:^(id responseObject) {
        if (success) {
            
            YCPlog;
            YCLog(@"10Latest: %@", responseObject);
            
            /**
             *    保存到数据库     */
            [self saveDataArray:responseObject toTable:dbLatestTopicT];
            
            /**
             *   转换成模型数组返回     */
            NSArray *arr = [V2TopicModel mj_objectArrayWithKeyValuesArray:responseObject];
            success(arr);
            
        }
    } failure:^(NSError *error) {
        /**
         *   获取失败, 先从数据库中拿来用先     */
        NSArray *topicsDictArray = [self allDataFromDataBaseFromTable:dbLatestTopicT];
        if (topicsDictArray.count > 0) {
            NSArray<V2TopicModel *> *topics = [V2TopicModel mj_objectArrayWithKeyValuesArray:topicsDictArray];
            
            success(topics);
        } else {
            YCLog(@"最新十大获取失败");
            
            failure(error);
        }
    }];
}


/**
 *   获取十大最热     */
+ (void)getHotestTopicsSuccess:(void (^)(NSArray<V2TopicModel *> *))success failure:(void (^)(NSError *))failure
{
    [V2OperationTool GET:agetHotest dataType:V2DataTypeJSON parameters:nil success:^(id responseObject) {
        if (success) {
            
            YCPlog;
            YCLog(@"10Hotest: %@", responseObject);
            
            /**
             *   保存到数据库     */
            [self saveDataArray:responseObject toTable:dbHotTopicT];
            
            NSArray *arr = [V2TopicModel mj_objectArrayWithKeyValuesArray:responseObject];
            
            success(arr);
            
        }
    } failure:^(NSError *error) {
        /**
         *   网络加载失败, 就从数据库取     */
        NSArray *hotDicts = [self allDataFromDataBaseFromTable:dbHotTopicT];
        if (hotDicts.count > 0) {
            //  转模型返回
            NSArray<V2TopicModel *> *hots = [V2TopicModel mj_objectArrayWithKeyValuesArray:hotDicts];
            success(hots);
        } else {
            YCLog(@"加载最热失败");
            
            failure(error);
        }
    }];
}




/**
 *  根据某个参数返回话题数组
 *
 *  @param userName 用户名
 *  @param nodeId   节点id
 *  @param nodeName 节点名
 *
 *  @return 对应话题数组
 */
+ (NSArray<V2TopicModel *> *)getTopicWithUserName:(NSString *)userName orNodeId:(NSString *)nodeId orNodeName:(NSString *)nodeName success:(void (^)(NSArray<V2TopicModel *> *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (userName) {
        para[kTopicUsername] = userName;
    } else if (nodeId)
    {
        para[kTopicNodeId] = nodeId;
    } else if (nodeName)
    {
        para[kTopicNodeName] = nodeName;
    }
    
    [V2OperationTool GET:agetTopic dataType:V2DataTypeJSON parameters:para success:^(id responseObject) {
        NSArray *arr = [V2TopicModel mj_objectArrayWithKeyValuesArray:responseObject];
        success(arr);
        
        YCPlog;
        YCLog(@"Topicsssss \n %@", responseObject);
        
    } failure:failure];
    return nil;
}



#pragma mark 回复
/**
 *  获取某个话题的回复
 *
 *  @param topicId  必选!! 话题 id
 *  @param page     页码
 *  @param pageSize 每页的回复数
 *
 *  @return 回复数组
 */
+ (NSArray<V2ReplyModel *> *)getRepliesInTopic:(NSString *)topicId andPage:(NSNumber *)page pageSize:(NSNumber *)pageSize success:(void (^)(NSArray<V2ReplyModel *> *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[kReplyTopicId] = topicId;
    if (para) {
        para[kPage] = page;
    }
    if (pageSize) {
        para[kPageSize] = pageSize;
    }
    
    [V2OperationTool GET:agetReplaies dataType:V2DataTypeJSON parameters:para success:^(id responseObject) {
        
        YCPlog;
        YCLog(@"replies; %@", responseObject);
        
        NSArray *arr = [V2ReplyModel mj_objectArrayWithKeyValuesArray:responseObject];
        success(arr);
        
    } failure:failure];
    
    
    return nil;
}


#pragma mark 成员信息
/**
 *   获取成员信息     */
+ (V2MemberModel *)memberWithMemberId:(NSString *)memberId orName:(NSString *)userName success:(void (^)(V2MemberModel *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (memberId) {
        para[kMemberId] = memberId;
    } else if (userName) {
        para[kMemberName] = userName;
    }
    
    [V2OperationTool GET:agetMember dataType:V2DataTypeJSON parameters:para success:^(id responseObject) {
        
        YCPlog;
        YCLog(@"member: %@", responseObject);
        
        if ([responseObject[@"status"] isEqualToString:@"notfound"]) {
            NSError *err = [NSError errorWithDomain:@"member Not Found" code:0 userInfo:nil];
            failure(err);
        } else {
            
            V2MemberModel *member = [V2MemberModel mj_objectWithKeyValues:responseObject];
            success(member);
            
        }
    } failure:failure];

    return nil;
}




#pragma mark- 数据库存取方法
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
