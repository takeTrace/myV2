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
#import "V2DataBaseTool.h"

#import <Foundation/Foundation.h>


#define V2Domain @"www.v2ex.com"

@implementation V2HtmlParser

#pragma mark- 检查元素节点是否存在
/**
 *   判断元素节点是否存在     */
+ (BOOL)isElementExist:(ONOXMLElement *)ele failure:(void (^)(NSError *error))failure
{
    if (ele) return YES;
    
    NSError *error = [NSError errorWithDomain:@"节点不存在, 请检查是否 DOM 结构有修改" code:0 userInfo:nil];
    failure(error);
    
    NSAssert(error, @"节点不存在, 请检查是否 DOM 结构有修改");
    
    return NO;
    
}



#pragma mark- 获取用户 话题 和 回复
/**
 *   获取某用户的话题     */
+ (void)parseTopicsWithDocument:(NSData *)docData fromMember:(V2MemberModel *)member Success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure
{
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:docData error:nil];
    ONOXMLElement *box = [doc firstChildWithCSS:@".box"];
    
    //  判断主题列表是否被隐藏
    ONOXMLElement *inner = [box firstChildWithCSS:@".inner"];
    ONOXMLElement *gray = [inner firstChildWithCSS:@".gray"];
    if (gray) {
        NSError *error = [NSError errorWithDomain:gray.stringValue code:1 userInfo:nil];
        failure(error);
        return;
    }
    
    //  没被隐藏,  遍历话题条目
    __block NSMutableArray<V2TopicModel *> *topics = [NSMutableArray array];
    
    [box enumerateElementsWithCSS:@"tr" usingBlock:^(ONOXMLElement *tr, NSUInteger idx, BOOL *stop) {
        
        if (![tr firstChildWithCSS:@".item_title"]) return;
        
        //  创建话题
        V2TopicModel *topic = [[V2TopicModel alloc] init];
        topic.node = [[V2NodeModel alloc] init];
        topic.member = member;
        //  节点
        [self getNodeInElement:tr toTopic:topic failure:failure];
        //  内容
        [self getTopicContentInElement:tr toTopic:topic failure:failure];
        //  存到数组, 这里应该进行用户标识时间戳, 避免加载正常话题时和使用同一个字段排序的话会混乱
        topic.getTime = @"0";
        topic.userTopicGetTime = [self localTimeMarkByIndex:idx];
        [topics addObject:topic];
        
    }];
    
    success(topics);
    
}


/**
 *   获取某用户的回复     */
+ (void)parseRepliesWithDocument:(NSData *)docData fromMember:(V2MemberModel *)member Success:(void (^)(NSArray<V2MemberReplyModel *> *replies))success failure:(void (^)(NSError *error))failure
{
//    YCLog(@"\n%@", [[NSString alloc] initWithData:docData encoding:NSUTF8StringEncoding]);
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:docData error:nil];
    ONOXMLElement *box = [doc firstChildWithCSS:@".box"];
    ONOXMLElement *header = [box firstChildWithCSS:@".header"];
    NSNumber *tatolReplyCount = [header firstChildWithCSS:@".gray"].numberValue;
    //*[@id="Wrapper"]/div/div/div[4]
    //*[@id="Wrapper"]/div/div/div[6]
    //  所以...还是不要用 xpath 解析了...
    
    
    //  没被隐藏,  遍历话题条目
    __block NSMutableArray<V2MemberReplyModel *> *replies = [NSMutableArray array];

    NSEnumerator *enu = (NSEnumerator *)[box CSS:@".inner"];
    NSArray<ONOXMLElement *> *inners = enu.allObjects;
    [box enumerateElementsWithCSS:@".dock_area" usingBlock:^(ONOXMLElement *dock, NSUInteger idx, BOOL *stop) {
        [self isElementExist:dock failure:failure];
        
        //  这里解析谁创建的什么主题, 还有时间
        V2MemberReplyModel *memberReply = [[V2MemberReplyModel alloc] init];
        
        
        memberReply.created = [dock firstChildWithCSS:@".fade"].stringValue;
        
        ONOXMLElement *title = [dock firstChildWithCSS:@"a"];
        [self isElementExist:title failure:failure];
        
        memberReply.topicTitle = title.stringValue;
        memberReply.topicUrlStr = title.attributes[@"href"];
        memberReply.topicId = memberReply.topicUrlStr.lastPathComponent;
        
        memberReply.replyHeader = [dock firstChildWithCSS:@".gray"].stringValue;
        
        //  每个dock_area后面那个节点就是 inner, 回复内容
        ONOXMLElement *inner = inners[idx];
        ONOXMLElement *reply_content = [inner firstChildWithCSS:@".reply_content"];
        [self isElementExist:reply_content failure:failure];

        //  如果得到的存在多余的东西, 等换成字符串再处理, 把不想干的字段替换为@"", 反正不相关的字段都是在每条都是一样的
        memberReply.content = reply_content.stringValue;
        memberReply.content_rendered = NSStringFromFormat(@"%@", reply_content);
        
        [replies addObject:memberReply];
    }];
    
    success(replies);
    
    
}




/**
 *   解析 html 的话题和回复     */
+ (void)parseTopicAndRepliesFromHtmlDocument:(NSData *)docData success:(void (^)(V2TopicModel *topic, NSArray<V2ReplyModel *> *replies))success failure:(void (^)(NSError *error))failure
{
    NSError *error = nil;
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:docData error:&error];
    
    
    
    
}


#pragma mark- 获取 tabs
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


#pragma mark- 获取节点导航
/**
 *   获取节点导航     */
+ (void)parseNodesNavigateGroupsWithDocument:(NSData *)docData success:(void (^)(NSArray<V2NodesGroup *> *groups))success failure:(void (^)(NSError *error))failure
{
    NSError *error = nil;
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:docData error:&error];

    NSEnumerator *boxs = (NSEnumerator *)[doc CSS:@".box"];
    ONOXMLElement *bottomBox = boxs.allObjects[1];
    
    if (!bottomBox) {
        failure([NSError errorWithDomain:@"页面 Dom 结构可能改变, 请检查" code:0 userInfo:nil]);
    }
    
    
    NSMutableArray *groups = [NSMutableArray array];
    //  3. 其子元素就是所需的 tabs, 遍历获得对应数据给模型
    for (ONOXMLElement *nodeGroup in [bottomBox CSS:@"tr"]) {
        
        V2NodesGroup *group = [[V2NodesGroup alloc] init];
        
        ONOXMLElement *groupTitle = [nodeGroup firstChildWithCSS:@".fade"];
        group.groupTitle = groupTitle.stringValue;
        
        NSMutableArray *nodes = [NSMutableArray array];
        for (ONOXMLElement *node in [nodeGroup CSS:@"a"]) {
            
            V2NodeModel *nodeM = [[V2NodeModel alloc] init];
            nodeM.title = node.stringValue;
            nodeM.url = [@"https://www.v2ex.com" stringByAppendingString:node.attributes[@"href"]];
            nodeM.name = [node.attributes[@"href"] lastPathComponent];
            
            [nodes addObject:nodeM];
        }
        
        group.nodes = nodes;
        [groups addObject:group];
    }
    
    
    //  4. 判断返回
    success(groups);
}


#pragma mark-  解析登录相关

/**
 *   获取登录参数     */
+ (void)parseLoginParaWithData:(id)data success:(void (^)(NSString *, NSString *, NSString *))success failure:(void (^)(NSError *))failure
{
    NSString *nameText;
    NSString *pwdText;
    NSString *onceString;
    
    NSError *error = nil;
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:data error:&error];
    
    
    ONOXMLElement *box1 = [doc firstChildWithCSS:@".box"];
    
    if (!box1) {
        failure([NSError errorWithDomain:@"页面 Dom 结构可能改变, 请检查" code:0 userInfo:nil]);
    }
    
    //  取出里面输入框的 key 对应的内容 和 Once
    for (ONOXMLElement *sl in [box1 CSS:@".sl"]) {
        NSString *type = sl.attributes[@"type"];
        if ([type isEqualToString:@"text"]) {
            //  用户名输入框
            nameText = sl.attributes[@"name"];
            
        } else if ([type isEqualToString:@"password"])
        {
            //  密码输入框
            pwdText = sl.attributes[@"name"];
            
            //  从密码狂的上一个节点取出 once
            ONOXMLElement *onceOnde = sl.previousSibling;
            if ([onceOnde.attributes[@"name"] isEqualToString:@"once"]) {
                
                onceString = onceOnde.attributes[@"value"];
            }
            
        } else
        {
            NSError *error = [NSError errorWithDomain:@"结构可能改变, 解析不到输入框数据" code:0 userInfo:nil];
            failure(error);
            return;
        }
    }
    
    if (nameText && pwdText && onceString) {
        
        success(onceString, nameText, pwdText);
        
    } else
    {
        NSError *error = [NSError errorWithDomain:@"解析失败" code:0 userInfo:nil];
        failure(error);
    }
    
}

/**
 *   获取登录成功的用户     */
+ (void)parseLoginUserWithData:(id)data success:(void (^)(NSString *user))success failure:(void (^)(NSError *error))failure
{
    NSError *error = nil;
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:data error:&error];
    YCLog(@"doc: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    ONOXMLElement *top = [doc firstChildWithCSS:@"#Top"];
//    NSEnumerator *tops = (NSEnumerator *)[top CSS:@".top"];
    ONOXMLElement *userEle = [top firstChildWithCSS:@".top"];
    NSString *userUrl = userEle.attributes[@"href"];
    //  检查
    if ([userUrl rangeOfString:@"member"].length == 0) {
        NSError *error = [NSError errorWithDomain:@"解析用户失败, 结构可能有变, 也可能是未登录成功" code:0 userInfo:nil];
        failure(error);
        
        return;
    }
    
    success(userUrl.lastPathComponent);
}


#pragma mark- 解析每个信息的方法
/**
 *   获取 box 节点*/
+ (ONOXMLElement *)getBoxElementWithData:(id)docData failure:(void (^)(NSError *error))failure
{
    //  1. 转换成 Document
    NSError *error = nil;
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:docData error:&error];
    
    __block ONOXMLElement *topBox;
    [doc enumerateElementsWithCSS:@".box" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        if ([element firstChildWithCSS:@".item_title"]) {
            topBox = element;
        }
    }];
    
    
    //  判断节点是否存在
    [self isElementExist:topBox failure:failure];

    return topBox;
}

/**
 *    获取话题用户头像     */
+ (ONOXMLElement *)getIconInElement:(ONOXMLElement *)ele toTopic:(V2TopicModel *)topic failure:(void (^)(NSError *error))failure {
    
    ONOXMLElement *norImage = [ele firstChildWithCSS:@".avatar"];
    [self isElementExist:norImage failure:failure];
    topic.member.avatar_normal = norImage.attributes[@"src"];
    
    return norImage;
}

/**
 *    话题的用户名及地址     */
+ (ONOXMLElement *)getMemberNameAndAddressInElement:(ONOXMLElement *)ele toTopic:(V2TopicModel *)topic failure:(void (^)(NSError *error))failure {

    topic.member.url = [V2Domain stringByAppendingString:ele.attributes[@"href"]];
    topic.member.username = [topic.member.url lastPathComponent];
    
    return ele;
}

/**
 *   获取话题所在节点     */
+ (ONOXMLElement *)getNodeInElement:(ONOXMLElement *)ele toTopic:(V2TopicModel *)topic failure:(void (^)(NSError *error))failure
{
    ONOXMLElement *nodeE = [ele firstChildWithCSS:@".node"];
    [self isElementExist:nodeE failure:failure];
    topic.node.title = nodeE.stringValue;
    topic.node.url = [V2Domain stringByAppendingString:nodeE.attributes[@"href"]];
    topic.node.name = topic.node.url.lastPathComponent;
    
    YCLog(@"eleContent: %@", nodeE);
    return nodeE;
}

/**
 *   话题内容     */
+ (ONOXMLElement *)getTopicContentInElement:(ONOXMLElement *)ele toTopic:(V2TopicModel *)topic failure:(void (^)(NSError *error))failure
{
    ONOXMLElement *topicE = [ele firstChildWithCSS:@".item_title"];
    [self isElementExist:topicE failure:failure];
    
    //  title
    ONOXMLElement *topicTitleE = [topicE firstChildWithCSS:@"a"];
    topic.title = topicTitleE.stringValue;
    //  话题 URL
    NSString *padding = topicTitleE.attributes[@"href"];
    NSString *urlPadding = [padding substringToIndex:[padding rangeOfString:@"#"].location];
    topic.url = [V2Domain stringByAppendingString:urlPadding];
    //  话题 id
    topic.ID = topic.url.lastPathComponent;
    
    /**
     *   回复数     */
    topic.replies = [ele firstChildWithCSS:@".count_livid"].numberValue;
    
    /**
     *   时间     */
    NSEnumerator *spans = (NSEnumerator *)[ele CSS:@"span"];
    ONOXMLElement *time = (ONOXMLElement *)[spans.allObjects lastObject];
    topic.created = time.stringValue;
    
    return topicE;
}

/**
 *    时间戳     */
+ (NSString *)localTimeMarkByIndex:(NSUInteger)index
{
    double timeOffset = 1.0 - (index/100.0);
    return NSStringFromFormat(@"%g", [[NSDate date] timeIntervalSince1970] + timeOffset);
}


#pragma mark- 获取主页上/node 上的话题
/**
 *    获取node 下的话题     */
+ (void)parseTopicsWithDocument:(NSData *)docData fromNode:(V2NodeModel *)fromNode Success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure
{
    
//    YCLog(@"\n%@", [[NSString alloc] initWithData:docData encoding:NSUTF8StringEncoding]);
    ONOXMLElement *topBox = [self getBoxElementWithData:docData failure:failure];
  
    /**
     *   保存解析到的话题的数组     */
    NSMutableArray *topics = [NSMutableArray array];
    
    //  3. 其子元素就是所需的 topic, 遍历获得对应数据给模型
    for (ONOXMLElement *topicRow in [topBox CSS:@"tr"]) {

//  ********************   确定节点   ******************************   //
        
        [self isElementExist:topBox failure:failure];
        //  不是话题节点
        if ([topicRow firstChildWithCSS:@".balance_area"])
        {
            YCLog(@"未读消息: %@", [topicRow firstChildWithCSS:@".gray"].stringValue);
            continue;
        }
        
        /**
         *   创建话题     */
        V2TopicModel *topic = [[V2TopicModel alloc] init];
        topic.member = [[V2MemberModel alloc] init];
        topic.node = fromNode ? fromNode : [[V2NodeModel alloc] init];
        

        
//  ********************   解析数据   ******************************   //
        /**
         *   用户头像     */
//        if (fromNode) {
            if (![topicRow firstChildWithCSS:@".avatar"]) continue;
//        }
        ONOXMLElement *norImage = [self getIconInElement:topicRow toTopic:topic failure:failure];
        
        /**
         *   用户地址及名     */
        ONOXMLElement *mem = [norImage parent];
        [self getMemberNameAndAddressInElement:mem toTopic:topic failure:failure];
        
        
        /**
         *   话题所在节点     */
        if (!fromNode) {
            [self getNodeInElement:topicRow toTopic:topic failure:failure];
        }
        
        /**
         *   话题     */
        [self getTopicContentInElement:topicRow toTopic:topic failure:failure];
        
        /**
         *   将更新时间也按照获得的顺序, 在最前面的是最新更新的, 时间应该更大     */
        topic.getTime = [self localTimeMarkByIndex:topics.count];
        
        /**
         *   添加到话题数组     */
        [topics addObject:topic];
    }
    
    
    //  4. 判断返回
    success(topics);
    
}


/**
 *    获取话题     */
+ (void)parseTopicsWithDocument:(NSData *)docData Success:(void (^)(NSArray<V2TopicModel *> *topics))success failure:(void (^)(NSError *error))failure
{
    [self parseTopicsWithDocument:docData fromNode:nil Success:success failure:failure];
}

@end
