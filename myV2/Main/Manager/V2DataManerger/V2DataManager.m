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
#import "V2SettingManager.h"

NSString * const kSiteInfoFile = @"siteInfo";
NSString * const kSiteStateFile = @"siteState";


NSString * const kSelectedTabIndex = @"selectedTabIndex";

NSString * const kLoginOnce = @"once";
NSString * const kLoginNext = @"next";

NSString * const kLoginUserName = @"loginUserName";
NSString * const kLoginUser = @"loginUser";

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
//static NSArray *_latestTopics;
///**
// *   最热主题     */
//static NSArray *_hotestTopics;
/**
 *   tabs 里的话题     */
static NSMutableDictionary *_tabsTopics;

/**
 *  tabView 选中 tab     */
static NSNumber *_selectedIndex;

/**
 *   登录的用户     */
static V2MemberModel *_user;
/**
 *   登录用户名     */
static NSString *_loginUserName;


/**
 *   记录最后一次 tab 请求     */
static NSMutableDictionary *_lastTabPara;
//static id _lastTag;



@implementation V2DataManager

+ (void)initialize
{
    if (self == [V2DataManager class]) {
        /**
         *   初始化管理者类     */
        //  初始话数据库
        [self setupAllNodesDB];
        
        _tabsTopics = [NSMutableDictionary dictionary];
    }
}

+ (void)setupAllNodesDB
{
    
    if ([V2DataBaseTool openDataBase]) {
        /**
         *   创建三个表     */
        [V2DataBaseTool createTableWithTableName:dbAllNodesT idStr:dbIdStr blobStr:dbDictData];
        
        [V2DataBaseTool createTableWithTableName:dbTopicsT];
        
        [V2DataBaseTool createTableWithTableName:dbNodeNavT idStr:dbIdStr blobStr:dbDictData];
        
        
        
//        [V2DataBaseTool createTableWithTableName:dbAllTabs idStr:dbTabName blobStr:dbDictData];
        
        
//        [V2DataBaseTool createTableWithTableName:dbHotTopicT idStr:dbIdStr blobStr:dbDictData];
//        [V2DataBaseTool createTableWithTableName:dbLatestTopicT idStr:dbIdStr blobStr:dbDictData];
        
        
    }
}



+ (void)userDefualtsSave:(id)obj forKey:(NSString *)key
{
    [YCUserDefaults setObject:obj forKey:key];
    [YCUserDefaults synchronize];
}

#define tabsPlistFile [YCDocumentPath stringByAppendingPathComponent:@"tabs.plist"]
#define nodeNavPlistFile [YCDocumentPath stringByAppendingPathComponent:@"nodeNav.plist"]
/**
 *   保存 tabs 或 nodeNav     */
+ (void)saveTabs:(NSArray<NSDictionary *> *)tabs orNodeNav:(NSArray<NSDictionary *> *)nodeNav
{
    NSString *file;
    if (tabs) {
        file = tabsPlistFile;
    } else
    {
        file = nodeNavPlistFile;
    }
    if(![nodeNav writeToFile:file atomically:YES])
    {
        YCLog(@"保存到%@未成功", file);
    }
    
}

/**
 *    加载 tabs 或 nodeNav     */
+ (NSArray *)loadTabs:(BOOL)tabs orNodeNav:(BOOL)nodeNav
{
    if (tabs) {
        return [NSArray arrayWithContentsOfFile:tabsPlistFile];
    } else
    {
        return [NSArray arrayWithContentsOfFile:nodeNavPlistFile];
    }
}



#pragma mark- html 解析的数据
/**
 *   对应标签 tab 的话题     */
+ (void)getTopicsWithTab:(V2TabModel *)tab success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure
{
    //[V2OperationTool cancelAllOperations];
    if (!tab) {
        
        tab = [[V2TabModel alloc] init];
        tab.name = @"全部";
        tab.urlStr = @"/?tab=all";
    }
    
    /**
     *    先从自己字典数组里取     */
    NSArray *tabsTopic = _tabsTopics[tab.name];
    if (tabsTopic) {
        success(tabsTopic);
        
        return;
    }
    
    /**
     *   自己的字典里没存货, 从数据库中取     */
    NSArray *dbTabTopic = [V2DataBaseTool allDataFromDataBaseFromTable:dbTopicsT tabName:tab.name];
    if (dbTabTopic.count > 0) {
        /**
         *   字典转模型     */
        NSArray<V2TopicModel *> *tabTopics = [V2TopicModel mj_objectArrayWithKeyValuesArray:dbTabTopic];
        
        _tabsTopics[tab.name] = tabTopics;
        
        success(tabTopics);
        
        return;
    }
    
    /**
     *   再没有, 从网络拿      */
    [self updateTopicsWithTab:tab success:success failure:failure];
}

/**
 *   更新 Tab 下的 topic     */
+ (void)updateTopicsWithTab:(V2TabModel *)tab success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure
{
    //[V2OperationTool cancelAllOperations];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
//    para[@""] = @"";
    
    _lastTabPara = para;
    
    [V2OperationTool GET:tab.urlStr dataType:V2DataTypeHTTP parameters:para tag:nil success:^(id responseObject) {
        
        if (_lastTabPara != para) {
            return ;
        }
        
//        YCLog(@"htmlData: \n%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        [V2HtmlParser parseTopicsWithDocument:responseObject Success:^(NSArray<V2TopicModel *> *topics) {

            if (topics.count == 0) return;
            if ([self saveTopics:topics withClear:NO needSearch:NO withTab:tab.name latest:nil hotest:nil]) {
                
                //  拿到数据库中唯一的数据
                NSArray *dbTabTopic = [V2DataBaseTool allDataFromDataBaseFromTable:dbTopicsT tabName:tab.name];
                if (dbTabTopic.count > 0) {
                    /**
                     *   字典转模型     */
                    NSArray<V2TopicModel *> *tabTopics = [V2TopicModel mj_objectArrayWithKeyValuesArray:dbTabTopic];
                    
                    _tabsTopics[tab.name] = tabTopics;
                    
                    success(tabTopics);
                    
                    [self clearOutDateData];
                    
                }
                
                
            }
            
            //  失败就不返回
        } failure:failure];
        
    } failure:^(NSError *error) {
       
        failure(error);
    }];
}

/**
 *   获取某个节点的话题     */
+ (void)getTopicsWithNode:(V2NodeModel *)node success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure
{
    //[V2OperationTool cancelAllOperations];
    /**
     *    先从自己字典数组里取     */
    NSArray *tabsTopic = _tabsTopics[node.name];
    if (tabsTopic) {
        success(tabsTopic);
        
        return;
    }
    
    /**
     *   自己的字典里没存货, 从数据库中取     */
    NSArray *dbTabTopic = [V2DataBaseTool allDataFromDataBaseFromTable:dbTopicsT nodeName:node.name];
    if (dbTabTopic.count > 0) {
        /**
         *   字典转模型     */
        NSArray<V2TopicModel *> *nodeTopics = [V2TopicModel mj_objectArrayWithKeyValuesArray:dbTabTopic];
        
        _tabsTopics[node.name] = nodeTopics;
        
        success(nodeTopics);
        
        return;
    }
    
    /**
     *   再没有, 从网络拿      */
//    [self updateTopicsWithNode:node page:nil success:success failure:failure];
}

+ (void)updateTopicsWithNode:(V2NodeModel *)node page:(NSNumber *)page success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure
{
    //[V2OperationTool cancelAllOperations];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[kHPage] = page;
    
    
    [V2OperationTool GET:node.url dataType:V2DataTypeHTTP parameters:para tag:nil success:^(id responseObject) {
        

        [V2HtmlParser parseTopicsWithDocument:responseObject fromNode:node Success:^(NSArray<V2TopicModel *> *topics) {
            
            if ([self saveTopics:topics withClear:NO needSearch:YES withTab:nil latest:nil hotest:nil]) {
                
                //  拿到数据库中唯一的数据
                NSArray *dbTabTopic = [V2DataBaseTool allDataFromDataBaseFromTable:dbTopicsT nodeName:node.name];
                if (dbTabTopic.count > 0) {
                    /**
                     *   字典转模型     */
                    NSArray<V2TopicModel *> *nodeTopics = [V2TopicModel mj_objectArrayWithKeyValuesArray:dbTabTopic];
                    
                    _tabsTopics[node.name] = nodeTopics;
                    
                    success(topics);
                    
                    [self clearOutDateData];
                    
                }
            }
            
            //  失败就不返回
        } failure:failure];
        
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}


/**
 *   解析 html 的话题和回复     */
//+ (void)getTopicAndRepliesFromHtmlWithTopic:(V2TopicModel *)topic success:(void (^)(V2TopicModel *topic, NSArray<V2ReplyModel *> *replies))success failure:(void (^)(NSError *error))failure
//{
//    
//    [V2OperationTool GET:topic.url dataType:V2DataTypeHTTP parameters:nil success:^(id responseObject) {
//        //  解析网页
////        [V2HtmlParser parseTopicAndRepliesFromHtmlDocument:<#(NSData *)#> success:<#^(V2TopicModel *topic, NSArray<V2ReplyModel *> *replies)success#> failure:<#^(NSError *error)failure#>
//        
//    } failure:^(NSError *error) {
//        YCLog(@"网络请求 topic 失败");
//    }];
//}

/**
 *   获取更多话题     */
+ (void)getMoreTpoics:(V2TabModel *)tab page:(NSNumber *)page success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure
{
    //[V2OperationTool cancelAllOperations];
    
    /**
     *    先从自己字典数组里取     */
    NSArray *tabsTopic = _tabsTopics[@"more"];
    if (tabsTopic) {
        success(tabsTopic);
        
        return;
    }
    
    /**
     *   自己的字典里没存货, 从数据库中取     */
    NSArray *dbTabTopic = [V2DataBaseTool allDataFromDataBaseFromTable:dbTopicsT];
    if (dbTabTopic.count > 0) {
        /**
         *   字典转模型     */
        NSArray<V2TopicModel *> *moreTopics = [V2TopicModel mj_objectArrayWithKeyValuesArray:dbTabTopic];
        
        _tabsTopics[@"more"] = moreTopics;
        
        success(moreTopics);
        
        return;
    }
    
    /**
     *   再没有, 从网络拿      */
//    [self updateMoreTopicsWithPage:page success:success failure:failure];

    

}

+ (void)updateMoreTopicsWithPage:(NSNumber *)page success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure
{
    //[V2OperationTool cancelAllOperations];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[kHPage] = page;
    
    [V2OperationTool GET:agetMoreTopic dataType:V2DataTypeHTTP parameters:para tag:nil success:^(id responseObject) {
        [V2HtmlParser parseTopicsWithDocument:responseObject Success:^(NSArray<V2TopicModel *> *topics) {
            
            if ([self saveTopics:topics withClear:NO needSearch:YES withTab:nil latest:nil hotest:nil]) {
                
                
                //  拿到数据库中唯一的数据
                NSArray *dbTabTopic = [V2DataBaseTool allDataFromDataBaseFromTable:dbTopicsT];
                if (dbTabTopic.count > 0) {
                    /**
                     *   字典转模型     */
                    NSArray<V2TopicModel *> *moreTopics = [V2TopicModel mj_objectArrayWithKeyValuesArray:dbTabTopic];
                    
                    _tabsTopics[@"more"] = moreTopics;
                    
                    success(topics);
                    
                    [self clearOutDateData];
                    
                }
            }
            
            //  失败就不返回
        } failure:failure];
        
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

/**
 *   获取 tabs     */
+ (void)getTabsSuccess:(void (^)(NSArray<V2TabModel *> *tabs))success failure:(void (^)(NSError *error))failure
{
    /**
     *    先从自己字典数组里取     */
    NSArray *tabsTopic = _tabsTopics[@"tabs"];
    if (tabsTopic) {
        success(tabsTopic);
        
        return;
    }
    
    /**
     *   自己的字典里没存货, 从plist中取     */
    NSArray<V2TabModel *> *tabs = [V2TabModel mj_objectArrayWithFile:tabsPlistFile];
    if (tabs.count > 0) {
        
        
        success(tabs);
        
        return;
    }
    
    /**
     *   再没有, 从网络拿      */
    [self updateTabsSuccess:success failure:failure];
    
}

/**
 *    更新 tabs     */
+ (void)updateTabsSuccess:(void (^)(NSArray<V2TabModel *> *tabs))success failure:(void (^)(NSError *error))failure
{
    //[V2OperationTool cancelAllOperations];
    
    [V2OperationTool GET:V2Domain dataType:V2DataTypeHTTP parameters:nil tag:nil success:^(id responseObject) {
        [V2HtmlParser parseTabsWithDocument:responseObject success:^(NSArray<V2TabModel *> *tabs) {

            _tabsTopics[@"tabs"] = tabs;
            
            success(tabs);
            
            /**
             *   转字典保存     */
            NSMutableArray<NSDictionary *> *tabsDictArray = [NSMutableArray arrayWithCapacity:tabs.count];
            [tabs enumerateObjectsUsingBlock:^(V2TabModel * _Nonnull tab, NSUInteger idx, BOOL * _Nonnull stop) {
                /**
                 *   转成字典     */
                NSDictionary *tabDict = [tab mj_keyValues];
                
                [tabsDictArray addObject:tabDict];
            }];
            
            [self saveTabs:tabsDictArray orNodeNav:nil];
            
        } failure:^(NSError *error) {
            failure(error);
        }];
    } failure:failure];
}

/**
 *   获取节点导航     */
+ (void)nodesNavigateGroupsSuccess:(void (^)(NSArray<V2NodesGroup *> *siteInfo))success failure:(void (^)(NSError *error))failure
{

    /**
     *    先从自己字典数组里取     */
    NSArray *tabsTopic = _tabsTopics[@"nodeNav"];
    if (tabsTopic) {
        success(tabsTopic);
        
        return;
    }
    
    /**
     *   自己的字典里没存货, 从plist中取     */
    NSArray<V2NodesGroup *> *nodeNav = [V2NodesGroup mj_objectArrayWithKeyValuesArray:[V2DataBaseTool allDataFromDataBaseFromTable:dbNodeNavT]];
    ;
    if (nodeNav.count > 0) {
        success(nodeNav);
        _tabsTopics[@"nodeNav"] = nodeNav;
        
        return;
    }
    
    /**
     *   再没有, 从网络拿      */
    [self updateNodesNavigateGroupsGroupsSuccess:success failure:failure];
}

/**
 *   更新节点导航     */
+ (void)updateNodesNavigateGroupsGroupsSuccess:(void (^)(NSArray<V2NodesGroup *> *siteInfo))success failure:(void (^)(NSError *error))failure
{
    //[V2OperationTool cancelAllOperations];
    
    [V2OperationTool GET:V2Domain dataType:V2DataTypeHTTP parameters:nil tag:nil success:^(id responseObject) {
        [V2HtmlParser parseNodesNavigateGroupsWithDocument:responseObject success:^(NSArray<V2NodesGroup *> *groups) {
            
            success(groups);
            
            /**
             *   存档     */
            NSMutableArray<NSDictionary *> *goupsDictArray = [NSMutableArray arrayWithCapacity:groups.count];
            [groups enumerateObjectsUsingBlock:^(V2NodesGroup * _Nonnull group, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dict = [group mj_keyValues];
                [goupsDictArray addObject:dict];
            }];
            
            [V2DataBaseTool saveDataArray:goupsDictArray toTable:dbNodeNavT withClear:YES needSearch:NO];
//            [self saveTabs:nil orNodeNav:goupsDictArray];
            
            _tabsTopics[@"nodeNav"] = groups;
        } failure:failure];
        
    } failure:failure];
}

#pragma mark- 获取用户主题和回复
/**
 *    获取用户发表主题     */
+ (void)getMemberTopics:(V2MemberModel *)member page:(NSNumber *)page success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure
{
    
    //  这里就不在内存中存着了, 这么多人的数据, 看一个存一个的话会消耗内存, 直接放sql 好了
    
    
    
    /**
     *   自己的字典里没存货, 从数据库中取     */
    NSArray *dbTabTopic = [V2DataBaseTool allDataFromDataBaseFromTable:dbTopicsT memberId:nil orMemberName:member.username];
    if (dbTabTopic.count > 0) {
        /**
         *   字典转模型     */
        NSArray<V2TopicModel *> *tabTopics = [V2TopicModel mj_objectArrayWithKeyValuesArray:dbTabTopic];
        
        success(tabTopics);
        
        return;
    }
    
    /**
     *   再没有, 从网络拿      */
    [self updateMemberTopics:member page:page success:success failure:failure];
    
}

/**
 *   更新用户发表主题     */
+ (void)updateMemberTopics:(V2MemberModel *)member page:(NSNumber *)page success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (page) {
        para[kPage] = page;
    }
    
    NSString *url = [member.url stringByAppendingPathComponent:@"topics"];
    
    [V2OperationTool GET:url dataType:V2DataTypeHTTP parameters:para tag:nil success:^(id responseObject) {
        
        [V2HtmlParser parseTopicsWithDocument:responseObject fromMember:member Success:^(NSArray<V2TopicModel *> *topics) {
            
            success(topics);
        } failure:failure];
    } failure:failure];
}

/**
 *    获取用户发表的回复     */
+ (void)getMemberReplies:(V2MemberModel *)member page:(NSNumber *)page success:(void (^)(NSArray<V2MemberReplyModel *> *replies))success failure:(void (^)(NSError *error))failure
{
    //  额, 这个就更不用持久化了吧, 没几个人会想保存有看过的回复, 没有价值的回复会被大脑自动过滤, 有价值的另记他处了
    [self updateMemberReplies:member page:page success:success failure:failure];
}

/**
 *   更新用户发表的回复    */
+ (void)updateMemberReplies:(V2MemberModel *)member page:(NSNumber *)page success:(void (^)(NSArray<V2MemberReplyModel *> *replies))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (page) {
        para[kPage] = page;
    }

    NSString *url = [member.url stringByAppendingPathComponent:@"replies"];

    [V2OperationTool GET:url dataType:V2DataTypeHTTP parameters:para tag:nil success:^(id responseObject) {
        [V2HtmlParser parseRepliesWithDocument:responseObject fromMember:member Success:^(NSArray<V2MemberReplyModel *> *replies) {
            
            success(replies);
            
        } failure:failure];
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
        _siteInfo = [siteInfoModel mj_objectWithKeyValues:[YCUserDefaults objectForKey:kSiteInfoFile]];
        _siteState = [SiteStateModel mj_objectWithKeyValues:[YCUserDefaults objectForKey:kSiteStateFile]];
        
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
    //[V2OperationTool cancelAllOperations];
    
    [V2OperationTool GET:agetSiteInfo
                dataType:V2DataTypeJSON parameters:nil tag:nil success:^(NSDictionary *responseObject) {
                    
                    
                    YCPlog;
                    YCLog(@"siteInfo %@", responseObject);
                    
                    _siteInfo = [siteInfoModel mj_objectWithKeyValues:responseObject];
                    
                    [self userDefualtsSave:responseObject forKey:kSiteInfoFile];
                    
                    
                    [V2OperationTool GET:agetSiteState dataType:V2DataTypeJSON parameters:nil tag:nil success:^(id siteState) {
                        
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
    //[V2OperationTool cancelAllOperations];
    
    [V2OperationTool GET:agetAllNodes
                dataType:V2DataTypeJSON parameters:nil tag:nil success:^(NSArray<NSDictionary *> *responseObject) {
                    
                    _allNodes = [V2NodeModel mj_objectArrayWithKeyValuesArray:responseObject];
                    
                    YCPlog;
                    /**
                     *   将所有节点的数据保存到...还是存到数据库吧....     */
                    [V2DataBaseTool saveDataArray:responseObject toTable:dbAllNodesT withClear:YES needSearch:NO];
                    
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
    
    if (idStr) {
        NSDictionary *nodeDict = [[V2DataBaseTool queryDataFromTable:dbAllNodesT withId:idStr] firstObject];
        YCLog(@"nodeDict = %@", nodeDict);
        if (nodeDict) {
            V2NodeModel *node = [V2NodeModel mj_objectWithKeyValues:nodeDict];
            success(node);
        } else
        {
            [self updateNodeInfoWithId:nil orName:nodeName success:success failure:failure];
        }
    } else
    {
        [self updateNodeInfoWithId:nil orName:nodeName success:success failure:failure];
    }
    
    
    return nil;
}

   /**
   *   更新节点信息     */
+ (void)updateNodeInfoWithId:(NSString *)idStr orName:(NSString *)nodeName success:(void (^)(V2NodeModel *))success failure:(void (^)(NSError *))failure
{
    //[V2OperationTool cancelAllOperations];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (idStr) {
        para[kNodeId] = idStr;
    } else {
        para[kNodeName] = nodeName;
    }
    [V2OperationTool GET:agetNode dataType:V2DataTypeJSON parameters:para tag:nil success:^(id responseObject) {
        YCPlog;
        YCLog(@"node: %@", responseObject);
        
        V2NodeModel *node = [V2NodeModel mj_objectWithKeyValues:responseObject];
        
        success(node);
        
        /**
         *   更新数据库中对应节点的信息     */
        if ([V2DataBaseTool deleteDict:responseObject fromTable:dbAllNodesT outDate:nil]) {
            
            [V2DataBaseTool insertDict:responseObject ToTable:dbAllNodesT];
            
        } else
        {
            
            YCLog(@"更新节点到数据库失败");
        }
        
    } failure:^(NSError *error) {
        YCLog(@"获取失败节点信息失败");
    }];
}


#pragma mark 话题

/**
 *   获取某个主题     */
+ (V2TopicModel *)getTopicWithId:(NSString *)topicId success:(void (^)(V2TopicModel *))success failure:(void (^)(NSError *))failure
{
    //[V2OperationTool cancelAllOperations];
    
    //  先从数据库
    NSDictionary *topicDict = [[V2DataBaseTool queryDataFromTable:dbTopicsT withId:topicId] firstObject];
    if (topicDict && topicDict[@"content"]) {// 没有内容的话, 就不是详细数据
        
        V2TopicModel *topic = [V2TopicModel mj_objectWithKeyValues:topicDict];
        
        success(topic);
        
        return topic;
    }
    

    
    [V2OperationTool GET:agetTopic dataType:V2DataTypeJSON parameters:@{kTopicId:topicId} tag:nil success:^(id responseObject) {
        
        YCPlog;
//        YCLog(@"topic = %@", responseObject);
        YCLog(@"responseClass: %@", [responseObject class]);
        YCLog(@"responseSerializer: %d", [V2OperationTool isJsonResponseSerializer]);

        if (![responseObject isKindOfClass:[NSArray class]]){
            YCLog(@"未更新成功新主题");
            return;
            
        }
        
        if ([responseObject count] == 0) {
            YCLog(@"更新无数据");
            
            return;
        }
        /**
         *   更新数据     */
        [V2DataBaseTool deleteDict:[responseObject firstObject] fromTable:dbTopicsT outDate:nil];
        [V2DataBaseTool insertDict:[responseObject firstObject] ToTable:dbTopicsT];
         
        V2TopicModel *topic = [V2TopicModel mj_objectWithKeyValues:[responseObject firstObject]];
        
        success(topic);
        
    } failure:failure];
    
    return nil;
    
}




#pragma mark- 这里下面的没有针对数据库优化
/**
 *   获取最新十大     */
+ (void)getLatestTopicsSuccess:(void (^)(NSArray<V2TopicModel *> *))success failure:(void (^)(NSError *))failure
{
//    [V2OperationTool GET:agetLatest dataType:V2DataTypeJSON parameters:nil success:^(id responseObject) {
//        if (success) {
//            
//            YCPlog;
//            YCLog(@"10Latest: %@", responseObject);
//            
//            /**
//             *    保存到数据库     */
//            [V2DataBaseTool saveDataArray:responseObject toTable:dbLatestTopicT];
//            
//            /**
//             *   转换成模型数组返回     */
//            NSArray *arr = [V2TopicModel mj_objectArrayWithKeyValuesArray:responseObject];
//            success(arr);
//            
//        }
//    } failure:^(NSError *error) {
//        /**
//         *   获取失败, 先从数据库中拿来用先     */
//        NSArray *topicsDictArray = [V2DataBaseTool allDataFromDataBaseFromTable:dbLatestTopicT];
//        if (topicsDictArray.count > 0) {
//            NSArray<V2TopicModel *> *topics = [V2TopicModel mj_objectArrayWithKeyValuesArray:topicsDictArray];
//            
//            success(topics);
//        } else {
//            YCLog(@"最新十大获取失败");
//            
//            failure(error);
//        }
//    }];
}


/**
 *   获取十大最热     */
+ (void)getHotestTopicsSuccess:(void (^)(NSArray<V2TopicModel *> *))success failure:(void (^)(NSError *))failure
{
//    [V2OperationTool GET:agetHotest dataType:V2DataTypeJSON parameters:nil success:^(id responseObject) {
//        if (success) {
//            
//            YCPlog;
//            YCLog(@"10Hotest: %@", responseObject);
//            
//            /**
//             *   保存到数据库     */
//            [V2DataBaseTool saveDataArray:responseObject toTable:dbHotTopicT];
//            
//            NSArray *arr = [V2TopicModel mj_objectArrayWithKeyValuesArray:responseObject];
//            
//            success(arr);
//            
//        }
//    } failure:^(NSError *error) {
//        /**
//         *   网络加载失败, 就从数据库取     */
//        NSArray *hotDicts = [V2DataBaseTool allHotestDataFromDataBaseFromTable:dbTopicsT];
//        if (hotDicts.count > 0) {
//            //  转模型返回
//            NSArray<V2TopicModel *> *hots = [V2TopicModel mj_objectArrayWithKeyValuesArray:hotDicts];
//            success(hots);
//        } else {
//            YCLog(@"加载最热失败");
//            
//            failure(error);
//        }
//    }];
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
    //[V2OperationTool cancelAllOperations];
    
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
    
    [V2OperationTool GET:agetTopic dataType:V2DataTypeJSON parameters:para tag:nil success:^(id responseObject) {
        NSArray<V2TopicModel *> *arr = [V2TopicModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        int now = [[NSDate date] timeIntervalSince1970];
        [arr enumerateObjectsUsingBlock:^(V2TopicModel * _Nonnull topic, NSUInteger idx, BOOL * _Nonnull stop) {
            double timeOffset = 1 - arr.count/100.0;
            
            topic.getTime = NSStringFromFormat(@"%g", now + timeOffset);
        }];
        
        success(arr);
        
        YCPlog;
        YCLog(@"Topicsssss \n %@", responseObject);
        
        [self saveTopics:arr withClear:NO needSearch:NO withTab:nil latest:nil hotest:nil];
        
        [self clearOutDateData];
        
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
    //[V2OperationTool cancelAllOperations];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[kReplyTopicId] = topicId;
    if (para) {
        para[kPage] = page;
    }
    if (pageSize) {
        para[kPageSize] = pageSize;
    }
    
    [V2OperationTool GET:agetReplaies dataType:V2DataTypeJSON parameters:para tag:nil success:^(id responseObject) {
        
//        YCPlog;
//        YCLog(@"replies; %@", responseObject);
        
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
    //[V2OperationTool cancelAllOperations];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (memberId) {
        para[kMemberId] = memberId;
    } else if (userName) {
        para[kMemberName] = userName;
    }
    
    [V2OperationTool GET:agetMember dataType:V2DataTypeJSON parameters:para tag:nil success:^(id responseObject) {
        
        YCPlog;
        YCLog(@"member: %@", responseObject);
        if (![responseObject isKindOfClass:[NSDictionary class]]) return;
        
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


+ (BOOL)saveTopics:(NSArray<V2TopicModel *> *)topics withClear:(BOOL)clear needSearch:(BOOL)needSearch withTab:(NSString *)tab latest:(NSString *)latest hotest:(NSString *)hotest
{
    NSMutableArray *dictArray = [NSMutableArray arrayWithCapacity:topics.count];
    [topics enumerateObjectsUsingBlock:^(V2TopicModel * _Nonnull topicM, NSUInteger idx, BOOL * _Nonnull stop) {
        topicM.tab = tab;
        topicM.latest = latest;
        topicM.hotest = hotest;

        NSDictionary *topicD = [topicM mj_keyValues];
        [dictArray addObject:topicD];
    }];
    
    return [V2DataBaseTool saveDataArray:dictArray toTable:dbTopicsT withClear:clear needSearch:needSearch];
}


#pragma mark- tabViewController的 data

/**
 *   获取当前/存档的选中的 tab     */
+ (int)getSelectedIndexInTabViewTable
{
    if (!_selectedIndex) {
        _selectedIndex = [YCUserDefaults objectForKey:kSelectedTabIndex];
    }
    
    return _selectedIndex.intValue;
}

/**
 *   设置当前选中的 tab     */
+ (void)setSelectedIndexInTabViewTable:(int)index
{
    _selectedIndex = @(index);
    
    [self userDefualtsSave:_selectedIndex forKey:kSelectedTabIndex];
}



/**
 *   删除过期数据     */
+ (void)clearOutDateData
{
    /**
     *   异步删除过期数据     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [V2DataBaseTool clearOutDateTopicInTable:dbTopicsT outDate:[V2SettingManager shareSettingManager].outDate];
    });
}


#pragma mark-  登录
/**
 *  登录操作,
 *
 *  @param userName 用户名
 *  @param password 密码
 */
+ (void)loginWithUserName:(NSString *)userName password:(NSString *)password success:(void (^)(V2MemberModel *user))success failure:(void (^)(NSError *error))failure
{
    //  清除 cookies
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [storage.cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull cookie, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [storage deleteCookie:cookie];
    }];
    
    //  加载登录页
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    _lastTabPara = para;
    
    [V2OperationTool GET:kLogin dataType:V2DataTypeHTTP parameters:para tag:nil success:^(id responseObject) {
        
        if (!success) return;
        
        if (para != _lastTabPara) return ;
        
        //  从加载到的网页解析出对应参数
        [V2HtmlParser parseLoginParaWithData:responseObject success:^(NSString *once, NSString *nameText, NSString *pwdText) {
            
            //  拼接参数, 发出 POST 请求登录
            para[kLoginOnce] = once;
            para[kLoginNext] = @"/";
            para[nameText] = userName;
            para[pwdText] = password;
            
            //  发出登录请求
            [self loginWithPara:para Success:^(V2MemberModel *user) {
                success(user);
            } failure:^(NSError *error) {
                YCLog(@"登录失败");
            }];
            

        } failure:^(NSError *error) {
            YCLog(@"解析登录参数失败");
        }];
    } failure:^(NSError *error) {
        YCLog(@"登录网页加载失败: error: %@", error);
    }];
}

/**
 *   获取登录用户     */
+ (void)loginWithPara:(NSMutableDictionary *)para Success:(void (^)(V2MemberModel *user))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *dict = @{@"Referer" : @"https://v2ex.com/signin"};
    [V2OperationTool POST:kLogin dataType:V2DataTypeHTTP parameters:para otherSeeting:dict success:^(id responseObject) {
        if (para != _lastTabPara) return;
        
        //  解析 data 中的 User
        [V2HtmlParser parseLoginUserWithData:responseObject success:^(NSString *user) {
            
            [self memberWithMemberId:nil orName:user success:^(V2MemberModel *member) {
                success(member);
                
                
            } failure:failure];
        } failure:failure];
    } failure:failure];
}


#pragma mark- 获取登录数据

+ (void)loginUser:(V2MemberModel *)user
{
    _user = user;
    _loginUserName = user.username;
    [self saveLogin:_user];
}
+ (BOOL)usersignout
{
    _user = nil;
    _loginUserName = nil;
    [self saveLogin:_user];
    [self clearCookies];
    return !_user && !_loginUserName;
}




+ (void)clearCookies
{
    NSHTTPCookieStorage *store = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [store.cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [store deleteCookie:obj];
    }];
}


+ (void)saveLogin:(V2MemberModel *)loginUser
{
    [YCUserDefaults setObject:loginUser.username forKey:kLoginUserName];
    
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:loginUser];
    [YCUserDefaults setObject:userData forKey:kLoginUser];
    
    [YCUserDefaults synchronize];
}


+ (NSString *)getLoginUserName
{
    if (!_loginUserName) {
        _loginUserName = [YCUserDefaults objectForKey:kLoginUserName];
    }
    return _loginUserName;
}


+ (V2MemberModel *)getLoginUser
{
    if (!_user) {
        NSData *userData = [YCUserDefaults objectForKey:kLoginUser];
        _user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        
    }
    return _user;
}
@end
