//
//  V2HtmlParser.h
//  myV2
//
//  Created by Mac on 16/9/3.
//  Copyright © 2016年 Lneayce. All rights reserved.
//  解析 v2的 MobileHtml

#import <Foundation/Foundation.h>
#import "siteInfoModel.h"
#import "V2NodeModel.h"
#import "V2TopicModel.h"
#import "V2MemberModel.h"
#import "V2ReplyModel.h"
#import "V2TabModel.h"
#import "V2NodesGroup.h"


@interface V2HtmlParser : NSObject

/**
 *    获取话题     */
+ (void)getTopicsWithDocument:(NSData *)docData Success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure;

/**
 *   解析 html 的话题和回复     */
+ (void)getTopicAndRepliesFromHtmlDocument:(NSData *)docData success:(void (^)(V2TopicModel *topic, NSArray<V2ReplyModel *> *replies))success failure:(void (^)(NSError *error))failure;


/**
 *   获取 tabs     */
+ (void)getTabsWithDocument:(NSData *)docData success:(void (^)(NSArray<V2TabModel *> *tabs))success failure:(void (^)(NSError *error))failure;


/**
 *   获取节点导航     */
+ (void)nodesNavigateGroupsSuccess:(void (^)(NSArray<V2NodesGroup *> *siteInfo))success failure:(void (^)(NSError *error))failure;


@end
