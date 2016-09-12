//
//  V2HtmlParser.m
//  myV2
//
//  Created by Mac on 16/9/3.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2HtmlParser.h"
#import <Ono.h>
#import "YCGloble.h"
#import "V2NodesGroup.h"
#import <Foundation/Foundation.h>


#define V2Domain @"www.v2ex.com"

@implementation V2HtmlParser

/**
 *   判断元素节点是否存在     */
+ (void)isElementExist:(ONOXMLElement *)ele failure:(void (^)(NSError *error))failure
{
    if (ele) return;
    
    NSError *error = [NSError errorWithDomain:@"节点不存在, 请检查是否 DOM 结构有修改" code:0 userInfo:nil];
    failure(error);
    
    NSAssert(error, @"节点不存在, 请检查是否 DOM 结构有修改");
    
}
/**
 *    获取话题     */
+ (void)parseTopicsWithDocument:(NSData *)docData Success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure
{
    //  1. 转换成 Document
    NSError *error = nil;
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:docData error:&error];
    
    ONOXMLElement *topBox = [doc firstChildWithCSS:@".box"];

    //  判断节点是否存在
    [self isElementExist:topBox failure:failure];
    
    
    /**
     *   保存解析到的话题的数组     */
    NSMutableArray *topics = [NSMutableArray array];
    
    //  3. 其子元素就是所需的 tabs, 遍历获得对应数据给模型
    for (ONOXMLElement *topicRow in [topBox CSS:@"tr"]) {
        [self isElementExist:topBox failure:failure];
        
        /**
         *   创建话题     */
        V2TopicModel *topic = [[V2TopicModel alloc] init];
        V2MemberModel *member = [[V2MemberModel alloc] init];
        topic.member = member;
        V2NodeModel *node = [[V2NodeModel alloc] init];
        topic.node = node;
        
        
        /**
         *   用户头像     */
        ONOXMLElement *norImage = [topicRow firstChildWithCSS:@".avatar"];
        [self isElementExist:norImage failure:failure];
        member.avatar_normal = norImage.attributes[@"src"];
        
        /**
         *   用户地址及名     */
        ONOXMLElement *memb = [norImage parent];
        member.url = [V2Domain stringByAppendingString:memb.attributes[@"href"]];
        member.username = [member.url lastPathComponent];
        
        /**
         *   话题所在节点     */
        ONOXMLElement *nodeE = [topicRow firstChildWithCSS:@".node"];
        [self isElementExist:nodeE failure:failure];
        node.title = nodeE.stringValue;
        node.url = [V2Domain stringByAppendingString:nodeE.attributes[@"href"]];
        node.name = node.url.lastPathComponent;
        
        
        
        /**
         *   话题     */
        ONOXMLElement *topicE = [topicRow firstChildWithCSS:@".item_title"];
        [self isElementExist:topicE failure:failure];
        
        ONOXMLElement *topicTitleE = [topicE firstChildWithCSS:@"a"];
        //  title
        topic.title = topicTitleE.stringValue;
        //  话题 URL
        NSString *padding = topicTitleE.attributes[@"href"];
        NSString *urlPadding = [padding substringToIndex:[padding rangeOfString:@"#"].location];
        topic.url = [V2Domain stringByAppendingString:urlPadding];
        /**
         *   话题 id     */
        topic.ID = topic.url.lastPathComponent;
        
        /**
         *   回复数     */
        topic.replies = [topicRow firstChildWithCSS:@".count_livid"].numberValue;
        
        
        /**
         *   添加到话题数组     */
        [topics addObject:topic];
    }
    
    
    //  4. 判断返回
    success(topics);
    
}

/**
 *   解析 html 的话题和回复     */
+ (void)parseTopicAndRepliesFromHtmlDocument:(NSData *)docData success:(void (^)(V2TopicModel *topic, NSArray<V2ReplyModel *> *replies))success failure:(void (^)(NSError *error))failure
{
    NSError *error = nil;
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:docData error:&error];
    
    
    
    
}


/**
 *   获取 tabs     */
+ (void)parseTabsWithDocument:(NSData *)docData success:(void (^)(NSArray<V2TabModel *> *tabs))success failure:(void (^)(NSError *error))failure
{
    NSError *error = nil;
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:docData error:&error];
    
    //  2. 拿第一个 box, 第一个 cell 就是顶部 tabs
    ONOXMLElement *topBox = [doc firstChildWithCSS:@".box"];
    ONOXMLElement *topTabsCell = [topBox firstChildWithCSS:@".cell"];
    
    if (!topTabsCell) {
        failure([NSError errorWithDomain:@"页面 Dom 结构可能改变, 请检查" code:0 userInfo:nil]);
    }
    
    NSMutableArray<V2TabModel *> *tabs = [NSMutableArray arrayWithCapacity:topTabsCell.children.count];
    
    //  3. 其子元素就是所需的 tabs, 遍历获得对应数据给模型
    for (ONOXMLElement *tab in [topTabsCell CSS:@"a"]) {
        YCLog(@"tab.tag = %@, %@ = %@", tab.tag, tab.stringValue, tab.attributes[@"href"]);
        
        V2TabModel *tabModel = [[V2TabModel alloc] init];
        tabModel.name = tab.stringValue;
        tabModel.urlStr = tab.attributes[@"href"];
        
        [tabs addObject:tabModel];
    }
    
    
    //  4. 判断返回
    if (tabs.count != topTabsCell.children.count) {
        failure(error);
    } else
    {
        success([tabs copy]);
    }
}


/**
 *   获取节点导航     */
+ (void)parseNodesNavigateGroupsWithDocument:(NSData *)docData success:(void (^)(NSArray<V2NodesGroup *> *groups))success failure:(void (^)(NSError *error))failure
{
    NSError *error = nil;
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:docData error:&error];
    
    
    //  2. 拿第二个 box, 第一个 cell 就是顶部
//    ONOXMLElement *bottomBox = nil;
//    int i = 0;
//    for (ONOXMLElement *box in [doc CSS:@".box"]) {
//        if (1 == i) {
//            bottomBox = box;
//            break;
//        }
//        i++;
//    }
    
    NSEnumerator *boxs = (NSEnumerator *)[doc CSS:@".box"];
    ONOXMLElement *bottomBox = boxs.allObjects[1];
    YCLog(@"doc css() 的结果是什么类型? ==== %@", (NSEnumerator *)[doc CSS:@".box"]);
    
    if (!bottomBox) {
        failure([NSError errorWithDomain:@"页面 Dom 结构可能改变, 请检查" code:0 userInfo:nil]);
    }
    
    
    NSMutableArray *groups = [NSMutableArray array];
    //  3. 其子元素就是所需的 tabs, 遍历获得对应数据给模型
    for (ONOXMLElement *nodeGroup in [bottomBox CSS:@"tr"]) {
        
        V2NodesGroup *group = [[V2NodesGroup alloc] init];
        
        ONOXMLElement *groupTitle = [nodeGroup firstChildWithCSS:@".fade"];
        group.groupTitle = groupTitle.stringValue;
        
//        YCLog(@"title: %@", groupTitle.stringValue);
        
        NSMutableArray *nodes = [NSMutableArray array];
        for (ONOXMLElement *node in [nodeGroup CSS:@"a"]) {
//            YCLog(@"nodeName %@ ---- nodeLink: %@", node.stringValue, node.attributes[@"href"]);
            
            V2NodeModel *nodeM = [[V2NodeModel alloc] init];
            nodeM.title = node.stringValue;
            nodeM.url = [NSURL URLWithString:[@"https://www.v2ex.com" stringByAppendingString:node.attributes[@"href"]]];
            nodeM.name = [node.attributes[@"href"] lastPathComponent];
            
            [nodes addObject:nodeM];
        }
        
        group.nodes = nodes;
        [groups addObject:group];
        
//        YCLog(@" ----------------\n-------------------");
//        V2TabModel *tabModel = [[V2TabModel alloc] init];
//        tabModel.name = tab.stringValue;
//        tabModel.urlStr = tab.attributes[@"href"];
//        
//        [tabs addObject:tabModel];
    }
    
    
    //  4. 判断返回
    success(groups);
}
@end
