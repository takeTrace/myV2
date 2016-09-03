//
//  siteInfoModel.h
//  myV2
//
//  Created by Mac on 16/8/30.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface siteInfoModel : NSObject
/**
 *   站名     */
@property (nonatomic, copy) NSString *title;
/**
 *   标语     */
@property (nonatomic, copy) NSString *slogan;
/**
 *   站点描述     */
@property (nonatomic, copy) NSString *desc;
/**
 *   域名     */
@property (nonatomic, copy) NSString *domain;

@end


@interface SiteStateModel : NSObject
/**
 *   当前社区话题数量     */
@property (nonatomic, strong) NSNumber *topic_max;
/**
 *   当前社区用户数量     */
@property (nonatomic, strong) NSNumber *member_max;


@end