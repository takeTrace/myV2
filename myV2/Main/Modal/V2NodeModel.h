//
//  V2NodeModel.h
//  myV2
//
//  Created by Mac on 16/8/30.
//  Copyright © 2016年 Lneayce. All rights reserved.
//  节点模型

#import <Foundation/Foundation.h>

@interface V2NodeModel : NSObject
/**
 *   节点名称     */
@property (nonatomic, copy) NSString *title;
/**
 *   备选节点名     */
@property (nonatomic, copy) NSString *title_alternative;
/**
 *   节点主题总数     */
@property (nonatomic, strong) NSNumber *topics;
/**
 *   节点 id     */
@property (nonatomic, copy) NSString *ID;
/**
 *   节点缩略名     */
@property (nonatomic, copy) NSString *name;
/**
 *   节点头部信息     */
@property (nonatomic, copy) NSString *header;
/**
 *   节点脚部信息     */
@property (nonatomic, copy) NSString *footer;
/**
 *   节点创建时间     */
@property (nonatomic, copy) NSString *created;
/**
 *   节点地址     */
@property (nonatomic, copy) NSString *url;
/**
 *   节点小图     */
@property (nonatomic, copy) NSString *avatar_mini;
/**
 *   节点普通图     */
@property (nonatomic, copy) NSString *avatar_normal;
/**
 *   节点大图     */
@property (nonatomic, copy) NSString *avatar_large;
/**
 *   收藏数?     */
@property (nonatomic, strong) NSNumber *stars;

@end
