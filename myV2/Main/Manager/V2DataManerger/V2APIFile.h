//
//  V2APIFile.h
//  myV2
//
//  Created by Mac on 16/9/6.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#ifndef V2APIFile_h
#define V2APIFile_h

#pragma mark- API

NSString * const V2Domain = @"https://www.v2ex.com";
NSString * const kTab = @"tab";

NSString * const agetMoreTopic = @"https://www.v2ex.com/recent";
//NSString * const agetHTopic&Replies = @"https://www.v2ex.com/t";

/**
 *   html解析数据的页码参数(recent和节点的数据才有页码参数     */
NSString * const kHPage = @"p";

NSString * const agetSiteInfo = @"https://www.v2ex.com/api/site/info.json";
NSString * const agetSiteState = @"https://www.v2ex.com/api/site/stats.json";
NSString * const agetAllNodes = @"https://www.v2ex.com/api/nodes/all.json";
NSString * const agetLatest = @"https://www.v2ex.com/api/topics/latest.json";
NSString * const agetHotest = @"https://www.v2ex.com/api/topics/hot.json";

NSString * const agetNode = @"https://www.v2ex.com/api/nodes/show.json";
NSString * const kNodeId = @"id";
NSString * const kNodeName = @"name";

NSString * const agetTopic = @"https://www.v2ex.com/api/topics/show.json";
NSString * const kTopicId = @"id";
NSString * const kTopicUsername = @"username";
NSString * const kTopicNodeId = @"node_id";
NSString * const kTopicNodeName = @"node_name";

NSString * const agetReplaies = @"https://www.v2ex.com/api/replies/show.json";
NSString * const kReplyTopicId = @"topic_id";
NSString * const kPage = @"page";
NSString * const kPageSize = @"page_size";

NSString * const agetMember = @"https://www.v2ex.com/api/members/show.json";
NSString * const kMemberId = @"id";
NSString * const kMemberName = @"username";


NSString * const kLogin = @"https://www.v2ex.com/signin";


#endif /* V2APIFile_h */
