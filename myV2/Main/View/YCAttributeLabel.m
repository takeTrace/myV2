//
//  YCStatusLabel.m
//  Weibo-图文混排
//
//  Created by Mac on 16/7/6.
//  Copyright (c) 2016年 Lneayce. All rights reserved.
//  使用 textView 来显示可以用其中的方法拿到某个 range 中的 rect

#import "YCAttributeLabel.h"
#import <ONOXMLDocument.h>
#import "YCGloble.h"
#import "YCTool.h"
#import <UIImageView+WebCache.h>

#define YCLinkAttributedName @"YCLinkAttributedName"
#define YCLinkBackColor 100000
#define YCImageNew @"(0o0)<img "
#define YCImageTag @"(0o0)"
#define YCImageOld @"<img "

@interface YCAttributeLabel ()
/**
 *   保存所有链接     */
@property (nonatomic, strong) NSMutableArray *links;
/**
 *   保存的图片链接     */
@property (nonatomic, strong) NSMutableArray *images;
/**
 *   显示富文本的控件属性     */
@property (nonatomic, weak) UITextView *textLabel;
@end

@implementation YCAttributeLabel
/**
 *   拿到本 label 里所有的链接     */
- (NSMutableArray *)links
{
    if (!_links) {
        _links = [NSMutableArray array];
        /**
         *   遍历属性文本中的所有属性, 将链接提取出来存到数组     */
        [self.attributedString enumerateAttribute:self.recongnizeLinkName inRange:NSMakeRange(0, self.attributedString.length) options:0 usingBlock:^(NSString *string, NSRange range, BOOL *stop) {
            if (string) {
                NSLog(@"statuscCell!!=====--- %@", string);
                /**
                 *   添加链接属性     */
                YCLink *link = [[YCLink alloc] init];
                link.text = string;
                link.range = range;
                
                /**
                 *   拿到 textRange */
                self.textLabel.selectedRange = range;
                /**
                 *   有时候选择到的范围有分行, 这样就会有2个 rect     */
                NSArray *selectedRects = [self.textLabel selectionRectsForRange:self.textLabel.selectedTextRange];
                
                NSMutableArray *arrayM = [NSMutableArray array];
                [selectedRects enumerateObjectsUsingBlock:^(UITextSelectionRect *textRect, NSUInteger idx, BOOL *stop) {
                    NSLog(@"textRect: %@",NSStringFromCGRect(textRect.rect));
                    if (textRect.rect.size.width != 0 && textRect.rect.size.height != 0) {
                        [arrayM addObject:textRect];
                    }
                }];
                link.rects = [arrayM copy];
                
                /**
                 *   将链接添加到数组     */
                [self.links addObject:link];
            }
        }];
        
    }
    return _links;
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
     *   初始化 textView     */
    UITextView *textView = [[UITextView alloc] init];
    [self addSubview:textView];
    self.textLabel = textView;
    //        self.textLabel.contentInset = UIEdgeInsetsMake(-10, -5, 0, -5);
//    self.textLabel.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5); //  并不是上面那个!!!!
//    self.backgroundColor = [UIColor clearColor];
//    self.textLabel.backgroundColor = [UIColor clearColor];
    /**
     *   不要交互     */
    self.textLabel.scrollEnabled = NO;
    self.textLabel.editable = NO;
    self.textLabel.userInteractionEnabled = NO;
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /**
     *   设置 textView 的 frame, 填充 self     */
    self.textLabel.frame = self.bounds;
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    /**
     *   先清空之前的 links     */
    self.links = nil;
    
    _attributedString = attributedString;
    
    self.textLabel.attributedText = attributedString;
}

#pragma mark- 实现触摸方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    
    NSLog(@"开始触摸-----%@", NSStringFromCGPoint(point));
    
    YCLink *link = [self isInterractWithPoint:point];
    if (link) {
        //  有点到链接, 给链接上背景色
        [self setBackgroundColorOnLink:link];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.225 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
    NSLog(@"取消触摸-----%@", NSStringFromCGPoint(point));
    [self removeAllBackColor];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    
    NSLog(@"结束触摸-----%@", NSStringFromCGPoint(point));
    YCLink *link = [self isInterractWithPoint:point];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.225 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeAllBackColor];
        
        if (link) {
            /**
             *   发送通知, 告诉链接被点击     */
            [self linkDidSeleced:link];
        } else
        {
            /**
             *   调用父类的这个方法传递点击事件     */
            [self.superview touchesEnded:touches withEvent:event];
        }
    });
}

/**
 *    判断 当前点中哪个链接     */
- (YCLink *)isInterractWithPoint:(CGPoint)point
{
    __block YCLink *selectedlink = nil;
    /**
     *   遍历 links, 看哪个和触摸点相交     */
    [self.links enumerateObjectsUsingBlock:^(YCLink *link, NSUInteger idx, BOOL *outStop) {
        [link.rects enumerateObjectsUsingBlock:^(UITextSelectionRect *textRect, NSUInteger idx, BOOL *inStop) {
            if (CGRectContainsPoint(textRect.rect, point)) {
                NSLog(@"相交");
                selectedlink = link;
                *inStop = YES;
                *outStop = YES;
            } else
            {
                NSLog(@"不相交");
            }
        }];
    }];
    
    return selectedlink;
}

/**
 *   给连接上背景色     */
- (void)setBackgroundColorOnLink:(YCLink *)link
{
    /**
     *   充当背景色的 view     */
    [link.rects enumerateObjectsUsingBlock:^(UITextSelectionRect *textRect, NSUInteger idx, BOOL *stop) {
        UIView *backgroudColor = [[UIView alloc] init];
        backgroudColor.backgroundColor = YCCColor(20, 222, 40, 0.5);
        [self.textLabel insertSubview:backgroudColor atIndex:0];
        backgroudColor.frame = textRect.rect;
        backgroudColor.width += 5;
        backgroudColor.x -= 2.5;
        backgroudColor.tag = YCLinkBackColor;
        /**
         *   设置圆角     */
        backgroudColor.layer.cornerRadius = 5;
        backgroudColor.clipsToBounds = YES;
    }];
    
}

/**
 *   移除所有背景色     */
- (void)removeAllBackColor
{
    [self.textLabel.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        /**
         *   遍历到背景色 view 就把它移除     */
        if (view.tag == YCLinkBackColor) {
            [view removeFromSuperview];
        }
    }];
}


/**
 *   连接被点击     */
- (void)linkDidSeleced:(YCLink *)link
{
    /**
     *   给外界发送通知     */
    [[NSNotificationCenter defaultCenter] postNotificationName:YCLinkDidSelectedNotification object:self userInfo:@{YCLinkBeSelectedInfoKey: link.text}];
}

- (void)setPreferWidth:(CGFloat)preferWidth
{
    _preferWidth = preferWidth-10; // 因为没有 inset 了, 所以显示文字区域宽度小了, 这里也要跟着小
    
    CGRect rec = self.frame;
    rec.size.width = preferWidth;
    rec.size.height = [self contentHeightWithWidth:preferWidth];
    self.frame = rec;
}
- (CGFloat)contentHeightWithWidth:(CGFloat)width
{
    if (!self.attributedString) {
        return 1;
    }
    
    CGSize size = [self.textLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    NSLog(@"systemLayoutSize: %@", NSStringFromCGSize(size));
    
    return size.height+20;
    
}

- (CGFloat)contentHeight
{
    if (self.frame.size.width > 0) {
        return [self contentHeightWithWidth:self.frame.size.width];
    } else {
        
        NSLog(@"textView 宽度不够");
        
        return 1;
        
    }
}

- (void)setHtmlString:(NSString *)htmlString
{
    //    添加标记
    _htmlString = [htmlString stringByReplacingOccurrencesOfString:YCImageOld withString:YCImageNew];
    
    _htmlString = [_htmlString stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
    /**
     *   转换为富文本
     */
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithData:[_htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    //  初始化图片数组
    NSError *error = nil;
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithString:htmlString encoding:NSUnicodeStringEncoding error:&error];
    if (error) {
        NSLog(@":errir = %@", error);
    }
    
    //  将图片插入到富文本
    for (ONOXMLElement *ele in [doc CSS:@"img"]) {
        
        UIImageView *img = [[UIImageView alloc] init];
        NSString *urlStr = ele.attributes[@"src"];

        img.image = [UIImage imageWithURLString:urlStr];
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = img.image;
        attach.bounds = CGRectMake(0, 0, 100, 100);
        NSAttributedString *imageString = [NSAttributedString attributedStringWithAttachment:attach];

        NSRange rang = [atr.string rangeOfString:YCImageTag];
        YCLog(@"range - %@", NSStringFromRange(rang));
        [atr insertAttributedString:imageString atIndex:NSMaxRange(rang)];
        
        
        /**
         *   移除标记     */
        [atr replaceCharactersInRange:rang withString:@".图片"];
        
        
    }
    
    self.attributedString = atr;
    
}

@end



@implementation YCLink

@end

