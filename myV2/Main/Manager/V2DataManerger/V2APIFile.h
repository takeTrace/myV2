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

#define V2Domain    @"https://www.v2ex.com"
#define kTab @"tab"

#define agetMoreTopic @"https://www.v2ex.com/recent"
//#define agetHTopic&Replies @"https://www.v2ex.com/t"

/**
 *   html解析数据的页码参数(recent和节点的数据才有页码参数     */
#define kHPage @"p"

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





#endif /* V2APIFile_h */
