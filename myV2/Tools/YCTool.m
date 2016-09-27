//
//  YCTool.m
//  Weibo
//
//  Created by Mac on 16/6/2.
//  Copyright (c) 2016年 Lneayce. All rights reserved.
//

#define YCMargen 10
#import "YCGloble.h"
#import "YCTool.h"
#import <Accelerate/Accelerate.h>

@implementation YCTool

@end


#pragma mark- 字符串系列

@implementation NSString (YCTool)

//  ********************   文本的Size   ******************************   //
/**
 *  返回字符串的 size
 *
 *  @param font 字体大小
 *  @param size 限制的大小
 *
 *  @return 计算出的 Size
 */
- (CGSize)sizeWithFont:(UIFont *)font boundingSize:(CGSize)size
{
//    YCLog(@"text: %@", self);
//    YCLog(@"font: %@", font);
//    YCLog(@"size: %@", [NSValue valueWithCGSize:size]);
//    YCLog(@"selection: %d", [self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]);
    #warning Note: 当稳重有些 emoji 不能显示时,会有夹杂的情况, 导致在计算时不能正确使用

    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
}



/**
 *  返回一个 View 的子控件的结构
 *
 *  @param superView 需要挖掘的 View
 *  @param xml       传入一个可变字符串拼接
 *
 *  @return 返回拼接好的字符串
 */
+ (NSMutableString *)digAllSubViews:(UIView *)superView onXMLString:(NSMutableString *)xml
{
    [xml appendString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"];

    return [NSString takeSubViews:superView onXMLString:xml];

}
+ (NSMutableString *)takeSubViews:(UIView *)superView onXMLString:(NSMutableString *)xml
{
    NSString *class = NSStringFromClass([superView class]);
    class = [class stringByReplacingOccurrencesOfString:@"_" withString:@""];
    NSString *frame = NSStringFromCGRect(superView.frame);
    //    frame = [frame stringByReplacingOccurrencesOfString:@"{" withString:@""];
    //    frame = [frame stringByReplacingOccurrencesOfString:@"}" withString:@""];
    [xml appendString:[NSString stringWithFormat:@"<%@  frame=\"%@\" >\n", class, frame]];
    for (UIView *childView in superView.subviews) {
        [self takeSubViews:childView onXMLString:xml];
    }
    [xml appendString:[NSString stringWithFormat:@"</%@>\n", class]];
    
    return xml;
}



/**
 *  返回这个路径下的所有文件大小
 *
 *  @return 文件大小
 */
- (long long)fileSize
{
    // 1.文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 2.判断file是否存在
    BOOL isDirectory = NO;
    BOOL fileExists = [mgr fileExistsAtPath:self isDirectory:&isDirectory];
    // 文件\文件夹不存在
    if (fileExists == NO) return 0;
    
    // 3.判断file是否为文件夹
    if (isDirectory) { // 是文件夹
        NSArray *subpaths = [mgr contentsOfDirectoryAtPath:self error:nil];
        long long totalSize = 0;
        for (NSString *subpath in subpaths) {
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            totalSize += [fullSubpath fileSize];
        }
        return totalSize;
    } else { // 不是文件夹, 文件
        // 直接计算当前文件的尺寸
        NSDictionary *attr = [mgr attributesOfItemAtPath:self error:nil];
        return [attr[NSFileSize] longLongValue];
    }
}

@end



#pragma mark- UIImage 系列

@implementation UIImage (YCTool)
#pragma mark- 生成玻璃效果
/**
 *
 使用实例:
 UIImageView  *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 300, SCREENWIDTH, 100)];
 imageView.contentMode=UIViewContentModeScaleAspectFill;
 imageView.image=[UIImage boxblurImage:image withBlurNumber:0.5];
 imageView.clipsToBounds=YES;
 [self.view addSubview:imageView];
 *
 *  @param image 传入图片
 *  @param blur  透明效果
 *
 *  @return 完成图片
 */
+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}

#pragma mark- 生成图片
/**  给一个 url 的字符串, 返回这个 URL 的图片  */
+ (UIImage *)imageWithURLString:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [UIImage imageWithData:data];
}

+ (UIImage *)imageNamed:(NSString *)name withRenderingMode:(UIImageRenderingMode)renderingMode
{
    return [[UIImage imageNamed:name] imageWithRenderingMode:renderingMode];
}
+ (UIImage *)originalImageName:(NSString *)name
{
    return [UIImage imageNamed:name withRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)circleImageWithName:(NSString *)name
{
//    UIImage *img = [UIImage originalImageName:name];
    UIImage *img = [UIImage imageNamed:name];
    UIGraphicsBeginImageContextWithOptions(img.size, NO, 0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    NSLog(@"rect = %@", NSStringFromCGRect(rect));
    CGContextAddEllipseInRect(ctx, rect);

    
    CGContextClip(ctx);
    
    [img drawInRect: rect];
    
    
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    /**
     *   结束上下文     */
    UIGraphicsEndImageContext();
    return img;
}



+ (UIImage *)imageWithName:(NSString *)name
{
    UIImage *img = nil;
    if (YCiOS7) { // 处理 iOS 版本的情况, 判断条件封装成了一个宏
        NSString *newName = [name stringByAppendingString:@"_iOS7"];
        img = [UIImage imageNamed:newName];
    }
    
    if (!img) {
        img = [UIImage imageNamed:name];
    }
    
    return img;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [color set];
    CGContextFillRect(ctx, CGRectMake(0, 0, 1, 1));
    
    return UIGraphicsGetImageFromCurrentImageContext();
}



#pragma mark-重新设定尺寸
/**  将不可拉伸区域设定到传入的 imageName 返回  */
+ (UIImage *)imageWithName:(NSString *)imgName CapInset:(CGFloat)capInset
{
    UIImage *img = [UIImage imageNamed:imgName];
    return [img resizableImageWithCapInsets:UIEdgeInsetsMake(2*capInset, 2*capInset, 2*capInset, 2*capInset) resizingMode:UIImageResizingModeStretch];
    
}
/**
 *  返回一个中心拉伸的 image
 *
 *  @param name 图片名称
 *
 *  @return 由图片拉伸的 Image
 */
+ (UIImage *)centerStretchImageNamed:(NSString *)name
{
    UIImage *img = [UIImage imageNamed:name];
    return [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height * 0.5, img.size.width * 0.5, img.size.height * 0.5, img.size.width * 0.5) resizingMode:UIImageResizingModeStretch];
}


#pragma mark- 图片加水印
/**  对象方法, 根据传入的水印图片和文字, 结合原有图片生成并返回一个image  */
- (UIImage *)addWaterImage:(NSString *)waterImage WaterString:(NSString *)waterShtring
{
    //    图片水印
#warning Note: 其实就是在一个bitmapContext图纸上绘制一个底Image, 再在上面绘制一个水印(图片/文字/等), 生成的Image就合成了这两个
#warning Note: 一般来说, 给图片加水印是在原有图片上加一个图片或文字, 所以创建的bitmap上下文图纸应该和底图一样大
    /**  加载底图  */
    //    UIImage *bottomImage = [UIImage imageNamed:@"psb"];
    //  这里底图就是self
    /**  创建一个bitmap上下文  */
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    
    /**  获取上下文,   */
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    /**  添加水印图片  */
    UIImage *waterImg = [UIImage imageNamed:waterImage];
    
    /**  绘制底图  */
    [self drawAtPoint:CGPointMake(0, 0)];
    
    /**  绘制水印  */
    //    [waterImg drawAtPoint:CGPointMake(20, 10)];   //  太大了
    [waterImg drawInRect:CGRectMake(self.size.width - YCMargen - 70, YCMargen, 70, 40)];
    
    
#warning Note: 还可以添加文字水印
    /**  直接在底图上添加文字  */
    //    NSString *text = @"这是文字水印";
    NSString *text = waterShtring;
    [text drawAtPoint:CGPointMake(self.size.width * 0.5f, self.size.height * 0.5f) withAttributes:nil];
    
    /**  从上下文中获取渲染好的image  */
    UIImage *doneImage = UIGraphicsGetImageFromCurrentImageContext();
    
    /**  写入到文件看看  */
    /**  获取路径  */
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"watr1.png"];
    
    /**  转成二进制数据文件  */
    NSData *data = UIImagePNGRepresentation(doneImage);
    
    /**  写入到文件  */
    [data writeToFile:file atomically:YES];
    
    NSLog(@"%@", file);
    
    /**  展示在imageView上  */
    //    UIImageView *iv = [[UIImageView alloc] initWithImage:doneImage];
    //    iv.center = self.view.center;
    //    iv.transform = CGAffineTransformMakeScale(0.7, 0.7);
    //    [self.view addSubview:iv];
    
    
    return doneImage;
    
}

/**  类方法, 根据传入的底图, 水印图和文字合成一个家水印的image返回  */
+ (UIImage *)imageWithBottomImage:(NSString *)bottomImage WaterImage:(NSString *)waterImage WaterString:(NSString *)waterShtring
{
    UIImage *bottomImg = [UIImage imageNamed:bottomImage];
    
    return [bottomImg addWaterImage:waterImage WaterString:waterShtring];
}

/**  保存图片  */
+ (void)writeImage:(UIImage *)img withName:(NSString *)imgName
{
    /**  设置路径  */
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSLog(@"%@", path);
    
    NSString *file = [path stringByAppendingPathComponent:imgName];
    
    
    /**  先将图片转换为二进制数据, 然后再将图片写入到文件中  */
    //    NSData *d = UIImageJPEGRepresentation(img, 1);
    NSData *d = UIImagePNGRepresentation(img);  // png(or其他)表示的文件, 返回nsdata
    
#warning Note: 在oc的类中, 只有某些有writeToFile的方法, UIImage没有, 所以要保存图片的话可以用NSData, 它是用来专门保存二进制文件的, 将UIImage放到NSData中, 在将data保存到文件
    
    
    [d writeToFile:file  atomically:YES];
    
}
@end




#pragma mark- UIView 的扩展

@implementation UIView (set)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setViewSize:(CGSize)viewSize
{
    self.width = viewSize.width;
    self.height = viewSize.height;
}
- (CGSize)viewSize
{
    return self.frame.size;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setMaxX:(CGFloat)maxX
{
    self.x = maxX - self.width;
}

- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}

- (void)setMaxY:(CGFloat)maxY
{
    self.y = maxY - self.height;
}

- (CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}

/**
 *   动画时取消应用的所有交互     */
+ (void)animateNotInteractableWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion
{
    __block UIWindow *kw = [UIApplication sharedApplication].keyWindow;
    kw.userInteractionEnabled = NO;
    
    [self animateWithDuration:duration animations:animations completion:^(BOOL finished) {

        kw.userInteractionEnabled = YES;
        kw = nil;
        completion(finished);
    }];
}
@end



#pragma mark- 字典和数组的本地化 的扩展
@implementation NSDictionary(Log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [str appendFormat:@"\t%@ = %@,\n", key, obj];
    }];
    
    [str appendString:@"\n}"];
    
    /**  去除最后一个逗号  */
    NSRange rang = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (rang.length > 0) {
        
        [str deleteCharactersInRange:rang];
    }
    
    return str;
}

@end

@implementation NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"[\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [str appendFormat:@"\t%@,\n",obj];
    }];
    
    /**  去除最后一个逗号  */
//    NSRange rang = [str rangeOfString:@"," options:NSBackwardsSearch];
//    
//    if (rang.length > 0) {
//        
//        [str deleteCharactersInRange:rang];
//    }
    [str appendString:@"\n]"];
    
    
    return str;
}

@end



#pragma mark- UIBarButtonItm 的扩展

@implementation UIBarButtonItem (create)
/**
 *  返回由按钮封装好的 Bar 按钮
 *
 *  @param imgName            一般状态的图片
 *  @param highlightedImgName 高亮状态的图片
 *  @param target             监听对象
 *  @param selector           调用方法
 *
 *  @return 封装好的 bar 按钮
 */
+ (UIBarButtonItem *)barButtonWithImageName:(NSString *)imgName highlightedName:(NSString *)highlightedImgName target:(id)target action:(SEL)selector
{
    return [UIBarButtonItem barButtonWithImageName:imgName highlightedName:highlightedImgName title:nil target:target action:selector];
}

/**
 *  返回一个封装按钮到 bar 按钮的 bar 按钮
 *
 *  @param imgName            一般情况下的图片
 *  @param highlightedImgName 高亮图片
 *  @param target             监听对象
 *  @param selector           监听方法
 *  @param title              标题
 *  @return 带标题,图片, 高亮图片的 barButtonItem
 */
+ (UIBarButtonItem *)barButtonWithImageName:(NSString *)imgName highlightedName:(NSString *)highlightedImgName title:(NSString *)title target:(id)target action:(SEL)selector
{
    //  按钮会被渲染, 要想保持原样, 还需要做一点处理
    UIImage *img = [UIImage imageNamed:imgName withRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:img forState:UIControlStateNormal];
    btn.imageView.contentMode = UIViewContentModeCenter;
    if (highlightedImgName) {
        [btn setImage:[UIImage imageNamed:highlightedImgName] forState:UIControlStateHighlighted];
    }
    
    btn.viewSize = img.size;
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    /**
     * 添加返回到根控制器的按钮
     */
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end



#pragma mark- NSMutableDictionary 系列
@implementation NSMutableDictionary (YCTool)
/**
 *  返回设定好相应控件文本属性的字典
 *
 *  @param color  文字颜色
 *  @param font   字体
 *  @param offset 阴影偏移
 *
 *  @return 设定好的字典
 */
+ (NSMutableDictionary *)attributeWithColor:(UIColor *)color font:(UIFont *)font shadowOffset:(UIOffset)offset
{
    NSMutableDictionary *dictM = [[self alloc] init];
    dictM[NSForegroundColorAttributeName] = color;
    if (font) {
        dictM[NSFontAttributeName] = font;
    }
        dictM[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:offset];
    
    return dictM;
}

@end




#pragma mark- UIImagePickerController 系列

@implementation UIImagePickerController (YCTool)

/**
 *  创建一个设定好代理和类型的imagePickerController
 *
 *  @param sourceType 类型
 *  @param delegate   代理对象
 *
 *  @return picker
 */
+ (UIImagePickerController *)imagePickerWithType:(UIImagePickerControllerSourceType)sourceType delegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate
{
    /**
     *   创建图片选择器     */
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = delegate;
    
    return imagePicker;
}



@end



#pragma mark- NSDate处理系列
@implementation NSDate (YCTool)
/**
 *  是否为今天
 */
- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

/**
 *  是否为昨天
 */
- (BOOL)isYesterday
{
    // 2014-05-01
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    
    // 2014-04-30
    NSDate *selfDate = [self dateWithYMD];
    
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

/**
 *  是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}

- (NSDateComponents *)deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}
@end



#pragma mark- NSArray系列
@implementation NSArray (YCTool)
/**
 *  将数组中的元素按照九宫格排列
 *
 *  @param inset  四周边距
 *  @param width  元素宽
 *  @param height 元素高
 *
 *  @return 成功则返回
 */
- (BOOL)arrayToLayoutLikeCollectionWithInset:(UIEdgeInsets)inset width:(CGFloat)width height:(CGFloat)height padding:(CGFloat)padding maxCols:(int)maxCols maxRows:(CGFloat)maxRows
{
    [self enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        CGFloat x = (idx % maxCols) * (width + padding)+ inset.left;
        CGFloat y = (idx / maxCols) * (height + padding) + inset.top;
        view.frame = CGRectMake(x, y, width, height);
        
        
    }];
    
    
    return YES;
}
@end


#pragma mark- UIButton系列
@implementation UIButton (YCTool)
/**
 *  快速设置一个按钮
 *
 *  @param title          标题
 *  @param image          普通状态图片
 *  @param highlightImage 高亮状态图片
 *  @param target         tagert
 *  @param action         点击调用的方法
 *  @param buttonType     按钮类型(将传给tag)
 *
 *  @return 设置好的按钮
 */
+ (instancetype)buttonWithTitle:(NSString *)title Image:(UIImage * _Nullable)image HighlightImage:(UIImage * _Nullable)highlightImage Target:(id _Nullable)target action:(SEL _Nullable)action btnType:(int)buttonType
{
    if (!target) target = target;
    if (!action) action = action;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = buttonType;
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highlightImage forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    return btn;
}

/**
 *  快速设置 Normal 和 highlight 状态下的图片
 *
 *  @param image   Normal 图片
 *  @param hlImage Highlight 图片
 */
- (void)setImage:(UIImage *)image highlightImage:(UIImage *)hlImage{
    [self setImage:image highlightImage:hlImage forState:UIControlStateNormal];
}

/**
 *  设置某个状态的图片和高亮图片
 *
 *  @param image   Normal 图片
 *  @param hlImage Highlight 图片
 *  @param state   状态
 */
- (void)setImage:(UIImage *)image highlightImage:(UIImage *)hlImage forState:(UIControlState)state
{
    [self setImage:image forState:state];
    [self setImage:hlImage forState:UIControlStateHighlighted];
}



/**
 *  设置某个状态的背景图片和背景高亮图片
 *
 *  @param image   Normal 图片
 *  @param hlImage Highlight 图片
 *  @param state   状态
 */
- (void)setBackgroundImage:(UIImage *)image highlightImage:(UIImage *)hlImage forState:(UIControlState)state
{
    [self setBackgroundImage:image forState:state];
    [self setBackgroundImage:hlImage forState:UIControlStateHighlighted];
}

/**
 *  添加 touchUpInside 点击监听
 *
 *  @param target 监听对象
 *  @param action 监听方法
 */
- (void)addTapTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setNormalImage:(UIImage *)normalImage
{
    [self setImage:normalImage forState:UIControlStateNormal];
}
- (void)setHighlightImage:(UIImage *)highlightImage
{
    [self setImage:highlightImage forState:UIControlStateHighlighted];
}
- (void)setSelectedImage:(UIImage *)selectedImage
{
    [self setImage:selectedImage forState:UIControlStateSelected];
}
- (void)setBackgroundSelectedImage:(UIImage *)backgroundSelectedImage
{
    [self setBackgroundImage:backgroundSelectedImage forState:UIControlStateSelected];
}
- (void)setBackgroundNormalImage:(UIImage *)backgroundNormalImage
{
    [self setBackgroundImage:backgroundNormalImage forState:UIControlStateNormal];
}
- (void)setBackgroundHighlightImage:(UIImage *)backgroundHighlightImage
{
    [self setBackgroundImage:backgroundHighlightImage forState:UIControlStateHighlighted];
}
- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}
- (void)setNormalTitleColor:(UIColor *)normalTitleColor
{
    [self setTitleColor:normalTitleColor forState:UIControlStateNormal];
}
- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    [self setTitleColor:selectedTitleColor forState:UIControlStateSelected];
}
- (void)setHighlightTitleColor:(UIColor *)highlightTitleColor
{
    [self setTitleColor:highlightTitleColor forState:UIControlStateHighlighted];
}
@end



#pragma mark- NSError
//  ********************   NSError   ******************************   //

@implementation NSError (YCTool)

/**
 *  快速创建一个空 info 的 error
 *
 *  @param errorString 错误信息
 *
 *  @return error
 */
+ ( NSError * _Nonnull )errorMessage:(NSString * _Nonnull)errorString
{
    return [NSError errorWithDomain:errorString code:0 userInfo:nil];
}

@end