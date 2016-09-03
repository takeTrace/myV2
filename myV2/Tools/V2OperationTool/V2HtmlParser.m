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

@implementation V2HtmlParser
/**
 *    获取话题     */
+ (void)getTopicsWithDocument:(NSData *)docData Success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure
{
    //  1. 转换成 Document
    NSError *error = nil;
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:docData error:&error];
    
   
    
}

/**
 *   解析 html 的话题和回复     */
+ (void)getTopicAndRepliesFromHtmlDocument:(NSData *)docData success:(void (^)(V2TopicModel *topic, NSArray<V2ReplyModel *> *replies))success failure:(void (^)(NSError *error))failure
{
    NSError *error = nil;
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:docData error:&error];
    
    
}


/**
 *   获取 tabs     */
+ (void)getTabsWithDocument:(NSData *)docData success:(void (^)(NSArray<V2TabModel *> *tabs))success failure:(void (^)(NSError *error))failure
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
+ (void)nodesNavigateGroupsWithDocument:(NSData *)docData success:(void (^)(NSArray<V2NodesGroup *> *siteInfo))success failure:(void (^)(NSError *error))failure
{
    NSError *error = nil;
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:docData error:&error];
    
    
}
@end
