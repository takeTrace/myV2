//
//  V2HtmlParser.h
//  myV2
//
//  Created by Mac on 16/9/3.
//  Copyright © 2016年 Lneayce. All rights reserved.
//  解析 v2的 MobileHtml, 使用 Ono

#import <Foundation/Foundation.h>
#import "siteInfoModel.h"
#import "V2NodeModel.h"
#import "V2TopicModel.h"
#import "V2MemberModel.h"
#import "V2ReplyModel.h"
#import "V2TabModel.h"
#import "V2NodesGroup.h"
#import "V2MemberReplyModel.h"


@interface V2HtmlParser : NSObject


/**
 *    获取node 下的话题     */
+ (void)parseTopicsWithDocument:(NSData *)docData fromNode:(V2NodeModel *)fromNode Success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure;

/**
 *    获取话题     */
+ (void)parseTopicsWithDocument:(NSData *)docData Success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure;

/**
 *   解析 html 的话题和回复     */
+ (void)parseTopicAndRepliesFromHtmlDocument:(NSData *)docData success:(void (^)(V2TopicModel *topic, NSArray<V2ReplyModel *> *replies))success failure:(void (^)(NSError *error))failure;


/**
 *   获取 tabs     */
+ (void)parseTabsWithDocument:(NSData *)docData success:(void (^)(NSArray<V2TabModel *> *tabs))success failure:(void (^)(NSError *error))failure;


/**
 *   获取节点导航     */
+ (void)parseNodesNavigateGroupsWithDocument:(NSData *)docData success:(void (^)(NSArray<V2NodesGroup *> *groups))success failure:(void (^)(NSError *error))failure;


#pragma mark-  解析登录相关

/**
 *   获取登录参数     */
+ (void)parseLoginParaWithData:(id)data success:(void (^)(NSString *once, NSString *nameText, NSString *pwdText))success failure:(void (^)(NSError *error))failure;

/**
 *   获取登录成功的用户     */
+ (void)parseLoginUserWithData:(id)data success:(void (^)(NSString *user))success failure:(void (^)(NSError *error))failure;



#pragma mark-  解析某 Member 的回复和主题
/**
 *   获取某用户的话题     */
+ (void)parseTopicsWithDocument:(NSData *)docData fromMember:(V2MemberModel *)member Success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure;

/**
 *   获取某用户的回复     */
+ (void)parseRepliesWithDocument:(NSData *)docData fromMember:(V2MemberModel *)member Success:(void (^)(NSArray<V2MemberReplyModel *> *replies))success failure:(void (^)(NSError *error))failure;

@end
