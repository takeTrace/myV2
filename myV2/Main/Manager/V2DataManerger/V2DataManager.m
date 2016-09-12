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
#import "V2APIFile.h"
#import "YCGloble.h"
#import "V2HtmlParser.h"


#define kSiteInfoFile @"siteInfo"
#define kSiteStateFile @"siteState"



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
 *   tabs 里的话题     */
static NSMutableDictionary *_tabsTopics;






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
    
    if ([V2DataBaseTool openDataBase]) {
        /**
         *   创建三个表     */
        [V2DataBaseTool createTableWithTableName:dbAllNodesT idStr:dbIdStr blobStr:dbDictData];
        
        [V2DataBaseTool createTableWithTableName:dbHotTopicT idStr:dbIdStr blobStr:dbDictData];
        
        [V2DataBaseTool createTableWithTableName:dbLatestTopicT idStr:dbIdStr blobStr:dbDictData];
        
        [V2DataBaseTool createTableWithTableName:dbTopicsT idStr:dbIdStr blobStr:dbDictData];
        
    }
}



+ (void)userDefualtsSave:(id)obj forKey:(NSString *)key
{
    [kUserUserDefaults setObject:obj forKey:key];
    [kUserUserDefaults synchronize];
}





#pragma mark- html 解析的数据
/**
 *   对应标签 tab 的话题     */
+ (void)getTopicsWithTab:(NSString *)tab success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[kTab] = tab;
    [V2OperationTool GET:V2Domain dataType:V2DataTypeHTTP parameters:para success:^(id responseObject) {
        [V2HtmlParser parseTopicsWithDocument:responseObject Success:^(NSArray<V2TopicModel *> *topics) {
            /**
             *   保存到字典     */
            _tabsTopics[tab] = topics;
            
            success(topics);
            
            //  失败就不返回
        } failure:failure];
    } failure:^(NSError *error) {
        /**
         *   网络获取失败返回缓存的     */
        success(_tabsTopics[tab]);
        
        failure(error);
    }];
}

/**
 *   获取某个节点的话题     */
+ (void)getTopicsWithNode:(V2NodeModel *)node page:(NSNumber *)page success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[kHPage] = page;
    [V2OperationTool GET:node.url dataType:V2DataTypeHTTP parameters:para success:^(id responseObject) {
        [V2HtmlParser parseTopicsWithDocument:responseObject Success:^(NSArray<V2TopicModel *> *topics) {
            /**
             *   保存到缓存     */
            _tabsTopics[node.name] = topics;
            
            success(topics);
        } failure:failure];
    } failure:^(NSError *error) {
        /**
         *   网络获取失败返回缓存的     */
        success(_tabsTopics[node.name]);
        
        failure(error);
    }];
}

/**
 *   解析 html 的话题和回复     */
+ (void)getTopicAndRepliesFromHtmlWithTopic:(V2TopicModel *)topic success:(void (^)(V2TopicModel *topic, NSArray<V2ReplyModel *> *replies))success failure:(void (^)(NSError *error))failure
{
    
    [V2OperationTool GET:topic.url dataType:V2DataTypeHTTP parameters:nil success:^(id responseObject) {
        //  解析网页
//        [V2HtmlParser parseTopicAndRepliesFromHtmlDocument:<#(NSData *)#> success:<#^(V2TopicModel *topic, NSArray<V2ReplyModel *> *replies)success#> failure:<#^(NSError *error)failure#>
        
    } failure:^(NSError *error) {
        YCLog(@"网络请求 topic 失败");
    }];
}

/**
 *   获取更多话题     */
+ (void)getMoreTpoics:(V2TabModel *)tab page:(NSNumber *)page success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[kHPage] = page;
    [V2OperationTool GET:agetMoreTopic dataType:V2DataTypeHTTP parameters:para success:^(id responseObject) {
        [V2HtmlParser parseTopicsWithDocument:responseObject Success:^(NSArray<V2TopicModel *> *topics) {
            
            _tabsTopics[@"more"] = topics;
            
            success(topics);
            
        } failure:failure];
    } failure:^(NSError *error) {
        /**
         *   网络获取失败返回缓存的     */
        success(_tabsTopics[@"more"]);
        
        failure(error);
    }];
}

/**
 *   获取 tabs     */
+ (void)getTabsSuccess:(void (^)(NSArray<V2TabModel *> *tabs))success failure:(void (^)(NSError *error))failure
{
    [V2OperationTool GET:V2Domain dataType:V2DataTypeHTTP parameters:nil success:^(id responseObject) {
        [V2HtmlParser parseTabsWithDocument:responseObject success:success failure:failure];
        
    } failure:failure];
}

/**
 *    更新 tabs     */
+ (void)updateTabsSuccess:(void (^)(NSArray<V2TabModel *> *tabs))success failure:(void (^)(NSError *error))failure
{
    [V2OperationTool GET:V2Domain dataType:V2DataTypeHTTP parameters:nil success:^(id responseObject) {
        [V2HtmlParser parseTabsWithDocument:responseObject success:success failure:failure];
        
    } failure:failure];
}

/**
 *   获取节点导航     */
+ (void)nodesNavigateGroupsSuccess:(void (^)(NSArray<V2NodesGroup *> *siteInfo))success failure:(void (^)(NSError *error))failure
{
    [V2OperationTool GET:V2Domain dataType:V2DataTypeHTTP parameters:nil success:^(id responseObject) {
        [V2HtmlParser parseNodesNavigateGroupsWithDocument:responseObject success:success failure:failure];
        
    } failure:failure];
}

/**
 *   更新节点导航     */
+ (void)updateNodesNavigateGroupsGroupsSuccess:(void (^)(NSArray<V2NodesGroup *> *siteInfo))success failure:(void (^)(NSError *error))failure
{
    [V2OperationTool GET:V2Domain dataType:V2DataTypeHTTP parameters:nil success:^(id responseObject) {
        [V2HtmlParser parseNodesNavigateGroupsWithDocument:responseObject success:success failure:failure];
        
    } failure:failure];
}



#pragma mark- 公布的API 接口调用返回的数据
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
        _allNodes = [V2NodeModel mj_objectArrayWithKeyValuesArray:[V2DataBaseTool allDataFromDataBaseFromTable:dbAllNodesT]];
        
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
                    [V2DataBaseTool saveDataArray:responseObject toTable:dbAllNodesT];
                    
                    
                    
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
        if ([V2DataBaseTool deleteDict:responseObject fromTable:dbAllNodesT]) {
            [V2DataBaseTool insertDict:responseObject ToTable:dbAllNodesT];
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
            NSDictionary *nodeDict = [[V2DataBaseTool queryDataFromTable:dbAllNodesT withId:idStr] firstObject];
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
//        YCLog(@"topic = %@", responseObject);
        
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
            [V2DataBaseTool saveDataArray:responseObject toTable:dbLatestTopicT];
            
            /**
             *   转换成模型数组返回     */
            NSArray *arr = [V2TopicModel mj_objectArrayWithKeyValuesArray:responseObject];
            success(arr);
            
        }
    } failure:^(NSError *error) {
        /**
         *   获取失败, 先从数据库中拿来用先     */
        NSArray *topicsDictArray = [V2DataBaseTool allDataFromDataBaseFromTable:dbLatestTopicT];
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
            [V2DataBaseTool saveDataArray:responseObject toTable:dbHotTopicT];
            
            NSArray *arr = [V2TopicModel mj_objectArrayWithKeyValuesArray:responseObject];
            
            success(arr);
            
        }
    } failure:^(NSError *error) {
        /**
         *   网络加载失败, 就从数据库取     */
        NSArray *hotDicts = [V2DataBaseTool allDataFromDataBaseFromTable:dbHotTopicT];
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






@end
