//
//  V2DataManerger.h
//  myV2
//
//  Created by Mac on 16/8/31.
//  Copyright © 2016年 Lneayce. All rights reserved.
 

#import <Foundation/Foundation.h>
#import "siteInfoModel.h"
#import "V2NodeModel.h"
#import "V2TopicModel.h"
#import "V2MemberModel.h"
#import "V2ReplyModel.h"
#import "V2MemberReplyModel.h"
#import "V2TabModel.h"
#import "V2NodesGroup.h"


@interface V2DataManager : NSObject


#pragma mark- html 解析的数据 
/**
 *   对应标签 tab 的话题     */
+ (void)getTopicsWithTab:(V2TabModel *)tab success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure;
/**
 *   更新 Tab 下的 topic     */
+ (void)updateTopicsWithTab:(V2TabModel *)tab success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure;

/**
 *   获取某个节点的话题     */
+ (void)getTopicsWithNode:(V2NodeModel *)node success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure;
/**
 *   更新某个节点话题(from解析 html)     */
+ (void)updateTopicsWithNode:(V2NodeModel *)node page:(NSNumber *)page success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure;
/**
 *   解析 html 的话题和回复     */
+ (void)getTopicAndRepliesFromHtmlWithTopic:(V2TopicModel *)topic success:(void (^)(V2TopicModel *topic, NSArray<V2ReplyModel *> *replies))success failure:(void (^)(NSError *error))failure;

/**
 *   获取更多话题     */
+ (void)getMoreTpoics:(V2TabModel *)tab page:(NSNumber *)page success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure;
/**
 *   更新更多话题     */
+ (void)updateMoreTopicsWithPage:(NSNumber *)page success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure;

/**
 *   获取 tabs     */
+ (void)getTabsSuccess:(void (^)(NSArray<V2TabModel *> *tabs))success failure:(void (^)(NSError *error))failure;

/**
 *    更新 tabs     */
+ (void)updateTabsSuccess:(void (^)(NSArray<V2TabModel *> *tabs))success failure:(void (^)(NSError *error))failure;

/**
 *   获取节点导航     */
+ (void)nodesNavigateGroupsSuccess:(void (^)(NSArray<V2NodesGroup *> *siteInfo))success failure:(void (^)(NSError *error))failure;

/**
 *   更新节点导航     */
+ (void)updateNodesNavigateGroupsGroupsSuccess:(void (^)(NSArray<V2NodesGroup *> *siteInfo))success failure:(void (^)(NSError *error))failure;

#pragma mark- 获取用户主题和回复
/**
 *    获取用户发表主题     */
+ (void)getMemberTopics:(V2MemberModel *)member page:(NSNumber *)page success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure;

/**
 *   更新用户发表主题     */
+ (void)updateMemberTopics:(V2MemberModel *)member page:(NSNumber *)page success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure;

/**
 *    获取用户发表的回复     */
+ (void)getMemberReplies:(V2MemberModel *)member page:(NSNumber *)page success:(void (^)(NSArray<V2MemberReplyModel *> *replies))success failure:(void (^)(NSError *error))failure;

/**
 *   更新用户发表的回复    */
+ (void)updateMemberReplies:(V2MemberModel *)member page:(NSNumber *)page success:(void (^)(NSArray<V2MemberReplyModel *> *replies))success failure:(void (^)(NSError *error))failure;



#pragma mark- 公布的API 接口调用返回的数据
/**
 *   获取站点信息     */
+ (void)siteInfoSuccess:(void (^)(siteInfoModel *siteInfo, SiteStateModel *siteState))success failure:(void (^)(NSError *error))failure;
/**
 *   获取所有节点     */
+ (void)allNodesSuccess:(void (^)(NSArray<V2NodeModel *> *nodes))success failure:(void (^)(NSError *error))failure;
/**
 *   更新站点信息     */
+ (void)updateSiteInfoSuccess:(void (^)(siteInfoModel *siteInfo, SiteStateModel *siteState))success failure:(void (^)(NSError *error))failure;
/**
 *   获取最新十大     */
+ (void)getLatestTopicsSuccess:(void (^)(NSArray<V2TopicModel *> *latestTopics))success failure:(void (^)(NSError *error))failure;
/**
 *   获取十大最热     */
+ (void)getHotestTopicsSuccess:(void (^)(NSArray<V2TopicModel *> *hotestTopics))success failure:(void (^)(NSError *error))failure;
/**
 *   更新所有节点     */
+ (void)updateAllNodesSuccess:(void (^)(NSArray<V2NodeModel *> *allNodes))success failure:(void (^)(NSError *error))failure;

/**
 *   获取节点信息     */
+ (V2NodeModel *)getNodeWithId:(NSString *)id orName:(NSString *)nodeName success:(void (^)(V2NodeModel *node))success failure:(void (^)(NSError *error))failure;

/**
 *   获取某个主题     */
+ (V2TopicModel *)getTopicWithId:(NSString *)topicId success:(void (^)(V2TopicModel *topic))success failure:(void (^)(NSError *error))failure;

/**
 *  根据某个参数返回话题数组
 *
 *  @param userName 用户名
 *  @param nodeId   节点id
 *  @param nodeName 节点名
 *
 *  @return 对应话题数组
 */
+ (NSArray<V2TopicModel *> *)getTopicWithUserName:(NSString *)userName orNodeId:(NSString *)nodeId orNodeName:(NSString *)nodeName success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure;

/**
 *  获取某个话题的回复
 *
 *  @param topicId  必选!! 话题 id
 *  @param page     页码
 *  @param pageSize 每页的回复数
 *
 *  @return 回复数组
 */
+ (NSArray<V2ReplyModel *> *)getRepliesInTopic:(NSString *)topicId andPage:(NSNumber *)page pageSize:(NSNumber *)pageSize success:(void (^)(NSArray<V2ReplyModel *> *replies))success failure:(void (^)(NSError *error))failure;


/**
 *   获取成员信息     */
+ (V2MemberModel *)memberWithMemberId:(NSString *)memberId orName:(NSString *)userName success:(void (^)(V2MemberModel *member))success failure:(void (^)(NSError *error))failure;





#pragma mark- tabViewController的 data

/**
 *   获取当前/存档的选中的 tab     */
+ (int)getSelectedIndexInTabViewTable;

/**
 *   设置当前选中的 tab     */
+ (void)setSelectedIndexInTabViewTable:(int)index;



#pragma mark-  登录
/**
 *  登录操作,
 *
 *  @param userName 用户名
 *  @param password 密码
 */
+ (void)loginWithUserName:(NSString *)userName password:(NSString *)password success:(void (^)(V2MemberModel *user))success failure:(void (^)(NSError *error))failure;



#pragma mark- 获取登录数据


/**
 *   保存登录用户     */
+ (void)loginUser:(V2MemberModel *)user;

/**
 *   用户登出     */
+ (BOOL)usersignout;

/**
 *   获取登录的用户     */
+ (V2MemberModel *)getLoginUser;

/**
 *   获取是否登录中的状态     */
+ (NSString *)getLoginUserName;

/**
 *   保存登录用户名     */
+ (void)saveLogin:(V2MemberModel *)loginUser;

@end
