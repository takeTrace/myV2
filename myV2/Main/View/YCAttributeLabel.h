//
//  YCStatusLabel.h
//  Weibo-图文混排
//
//  Created by Mac on 16/7/6.
//  Copyright (c) 2016年 Lneayce. All rights reserved.
//  用自定义控件来显示微博内容, 传入富文本就显示出来, 并对内容中的链接做处理, 拿到其中的所有链接.

#import <UIKit/UIKit.h>

/**
 *   通知     */
#define YCLinkDidSelectedNotification @"YCLinkDidSelected"
#define YCLinkBeSelectedInfoKey @"YCLinkBeSelectedInfoKey"

@interface YCLink : NSObject
/**
 *   链接文本     */
@property (nonatomic, copy) NSString *text;
/**
 *   文本 range     */
@property (nonatomic, assign) NSRange range;
/**
 *   链接文本对应的 rects(可能不止一个 rect)     */
@property (nonatomic, strong) NSArray *rects;

@end



@interface YCAttributeLabel : UIView
/**
 *   传入要显示的属性文本     */
@property (nonatomic, strong) NSMutableAttributedString *attributedString;
/**
 *   需要识别的链接(name)     */
@property (nonatomic, copy) NSString *recongnizeLinkName;

- (CGFloat)contentHeight;
@property (nonatomic, assign) CGFloat preferWidth;

/**
 *   html渲染的文本     */
@property (nonatomic, copy) NSString *htmlString;

@end
