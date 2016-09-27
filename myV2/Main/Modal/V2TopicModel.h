//
//  V2TopicModel.h
//  myV2
//
//  Created by Mac on 16/8/30.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import <Foundation/Foundation.h>
@class V2NodeModel, V2MemberModel;
@interface V2TopicModel : NSObject
/**
 *   1.话题 ID     */
@property (nonatomic, copy) NSString *ID;
/**
 *   2.标题     */
@property (nonatomic, copy) NSString *title;
/**
 *   3.主题地址     */
@property (nonatomic, copy) NSString *url;
/**
 *   4.楼主     */
@property (nonatomic, strong) V2MemberModel *member;
/**
 *   5.所在节点     */
@property (nonatomic, strong) V2NodeModel *node;
/**
 *   6.内容     */
@property (nonatomic, copy) NSString *content;
/**
 *   7.html 渲染后的内容     */
@property (nonatomic, copy) NSString *content_rendered;
/**
 *   8.回复数     */
@property (nonatomic, strong) NSNumber *replies;
/**
 *   9.创建时间     */
@property (nonatomic, copy) NSString *created;
/**
 *   10,最后修改时间     */
@property (nonatomic, copy) NSString *last_modified;
/**
 *   11.最后查看时间     */
@property (nonatomic, copy) NSString *last_touched;

/**
 *    额外标记     */
@property (nonatomic, copy) NSString *tab;
@property (nonatomic, copy) NSString *hotest;
@property (nonatomic, copy) NSString *latest;

/**
 *    在本地的更新时间     */
@property (nonatomic, copy) NSString *getTime;
/**
 *   用户标识时间戳, 当获取用户话题的时候打上     */
@property (nonatomic, copy) NSString *userTopicGetTime;

@end
