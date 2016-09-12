//
//  V2MemberModel.h
//  myV2
//
//  Created by Mac on 16/8/30.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface V2MemberModel : NSObject
/**
 *   成员 id     */
@property (nonatomic, copy) NSString *ID;
/**
 *   用户地址       */
@property (nonatomic, copy) NSString *url;
/**
 *   用户名     */
@property (nonatomic, copy) NSString *username;
/**
 *   主页     */
@property (nonatomic, copy) NSString *website;
/**
 *   tuite     */
@property (nonatomic, copy) NSString *twitter;
/**
 *   psn?     */
@property (nonatomic, copy) NSString *psn;
/**
github     */
@property (nonatomic, copy) NSString *github;
/**
 *   btc?     */
@property (nonatomic, copy) NSString *btc;
/**
 *   位置     */
@property (nonatomic, copy) NSString *location;
/**
 *   个人标签     */
@property (nonatomic, copy) NSString *tagline;
/**
 *   个人简介     */
@property (nonatomic, copy) NSString *bio;
/**
 *   小头像地址     */
@property (nonatomic, copy) NSString *avatar_mini;
/**
 *   中头像地址     */
@property (nonatomic, copy) NSString *avatar_normal;
/**
 *   大头像地址     */
@property (nonatomic, copy) NSString *avatar_large;
/**
 *   创建时间     */
@property (nonatomic, copy) NSString *created;
@end
