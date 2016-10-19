//
//  YCStatusLabel.m
//  Weibo-图文混排
//
//  Created by Mac on 16/7/6.
//  Copyright (c) 2016年 Lneayce. All rights reserved.

#import "YCAttributeLabel.h"
#import <ONOXMLDocument.h>
#import "YCGloble.h"
#import "YCTool.h"
#import <UIImageView+WebCache.h>
#import <TYAttributedLabel.h>




static const CGFloat padding = 10.0;

@interface YCAttributeLabel ()<TYAttributedLabelDelegate>
/**
 *   TYAttributedLabel     */
@property (nonatomic, weak) TYAttributedLabel *contentLabel;

/**
 *   图片 URLs     */
@property (nonatomic, strong) NSMutableArray *imgUrls;
@end

@implementation YCAttributeLabel

- (NSMutableArray *)imgUrls
{
    if (!_imgUrls) {
        _imgUrls = [NSMutableArray array];
    }
    return _imgUrls;
}

#pragma mark- 基本设置
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupTextView];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupTextView];
    }
    return self;
}

- (void)setupTextView
{
    /**
     *    创建 TYAttributedLabel     */
    TYAttributedLabel *contentLabel = [[TYAttributedLabel alloc] init];
    self.contentLabel = contentLabel;
    [self addSubview:contentLabel];
    contentLabel.delegate = self;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self contentHeightWithWidth:self.width];
    
}

- (CGFloat)contentHeightWithWidth:(CGFloat)width
{
    if (!self.attributedString) return 1;
    self.width = width;
    
    _contentLabel.x = padding;
    _contentLabel.y = padding;
    CGFloat contentWidth = width - 2 * padding;
    _contentLabel.width = contentWidth;
    _contentLabel.preferredMaxLayoutWidth = contentWidth;
    [_contentLabel sizeToFit];
    
    self.height = _contentLabel.maxY + padding;
    return _contentLabel.maxY;
    
}

- (void)setPreferWidth:(CGFloat)preferWidth
{
    _preferWidth = preferWidth;
    [self contentHeightWithWidth:_preferWidth];
}

- (CGFloat)contentHeight
{
    if (self.width > 0) {
        if (self.preferWidth) {
            return _contentLabel.maxY;
        } else
        {
            return [self contentHeightWithWidth:self.width];
        }
    } else {
        NSLog(@"textView 宽度不够");
        return 1;
    }
}


- (void)setAttributedString:(NSMutableAttributedString *)attributedString
{
    
    _attributedString = attributedString;
    
    //  append 的话会在复用的时候不断的拼接新的 attributedString 上去, 导致内容越来越长和计算的 高度越来越大
    //    [_contentLabel appendTextAttributedString:_attributedString];
    _contentLabel.attributedText = _attributedString;
    
    [_attributedString enumerateAttribute:NSLinkAttributeName inRange:NSMakeRange(0, _attributedString.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        
        if (!value) return;
//        YCLog(@"linkValue: %@, range: %@", value, NSStringFromRange(range));
        TYLinkTextStorage *link = [[TYLinkTextStorage alloc] init];
        link.range = range;
        link.text = [value absoluteString];
        
        //  可以在点击发送后由控制器判断, 不一定会点, 就不做多余的处理
//        NSRange memberRange = [link.text rangeOfString:@"/member"];
//        if (memberRange.length > 0) {
//            link.text = [link.text substringFromIndex:memberRange.location];
//        }
        
        link.linkData = link.text;
        [_contentLabel addTextStorage:link];
    }];
    
    __block int i =0;
    [_attributedString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, _attributedString.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (!value) return;
//        YCLog(@"imgValue: %@, range: %@, src = ", value, NSStringFromRange(range));
        
        [_attributedString removeAttribute:NSAttachmentAttributeName range:range];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        [imgView sd_setImageWithURL:_imgUrls[i++] placeholderImage:[UIImage imageNamed:@"icon"]];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.viewSize = CGSizeMake(YCScreenW, YCScreenW);
        [_contentLabel addView:imgView range:range alignment:TYDrawAlignmentCenter];
        
    }];
}

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point
{
    
    NSLog(@"textStorageClickedAtPoint");
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        
        NSString *linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        
        if ([linkStr hasPrefix:@"http:"]) {
            [ [ UIApplication sharedApplication] openURL:[ NSURL URLWithString:linkStr]];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"点击提示" message:linkStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
        
        
        /**
         *   给外界发送通知     */
        [[NSNotificationCenter defaultCenter] postNotificationName:YCLinkDidSelectedNotification object:self userInfo:@{YCLinkBeSelectedInfoKey: linkStr}];
    }
}

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageLongPressed:(id<TYTextStorageProtocol>)textStorage onState:(UIGestureRecognizerState)state atPoint:(CGPoint)point
{
    NSLog(@"textStorageLongPressed");
}



- (void)setHtmlString:(NSString *)htmlString
{
    
    /**
     *    清空之前的图片记录     */
    self.imgUrls = nil;
    _htmlString = htmlString;
    
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithString:htmlString encoding:NSUnicodeStringEncoding error:nil];
    ONOXMLElement *root = doc.rootElement;
    
    for (ONOXMLElement *ele in [root CSS:@"img"]) {
        NSURL *imgurl = [NSURL URLWithString:ele.attributes[@"src"]];
        [self.imgUrls addObject:imgurl];
    }
    
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithData:[_htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    
    self.attributedString = att;
    
}

@end
