//
//  V2ReplyModel.h
//  myV2
//
//  Created by Mac on 16/8/31.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import <UIKit/UIKit.h>
@class V2MemberModel;
@interface V2ReplyModel : NSObject
/**
 *   1.回复 ID     */
@property (nonatomic, copy) NSString *ID;
/**
 *   2.主题地址     */
@property (nonatomic, strong) NSNumber *thanks;
/**
 *   3.楼主     */
@property (nonatomic, strong) V2MemberModel *member;
/**
 *   4.内容     */
@property (nonatomic, copy) NSString *content;
/**
 *   5.html 渲染后的内容     */
@property (nonatomic, copy) NSString *content_rendered;

/**
 *   6.创建时间     */
@property (nonatomic, copy) NSString *created;
/**
 *   7,最后修改时间     */
@property (nonatomic, copy) NSString *last_modified;


/**
 *   在 replyCell中的高度     */
@property (nonatomic, assign) CGFloat heightInCell;

@end
