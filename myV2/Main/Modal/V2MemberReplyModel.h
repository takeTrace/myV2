//
//  V2MemberReplyModel.h
//  myV2
//
//  Created by Mac on 16/9/25.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "V2ReplyModel.h"

@interface V2MemberReplyModel : V2ReplyModel
@property (nonatomic, copy) NSString *topicId;
@property (nonatomic, copy) NSString *topicTitle;
@property (nonatomic, copy) NSString *topicUrlStr;
@property (nonatomic, copy) NSString *replyHeader;
@end
