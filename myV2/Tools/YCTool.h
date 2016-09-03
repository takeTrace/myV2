//
//  YCTool.h
//  Weibo
//
//  Created by Mac on 16/6/2.
//  Copyright (c) 2016年 Lneayce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCTool : NSObject

@end


#pragma mark- 字符串系列

@interface NSString (YCTool)
/**
 *  返回根据字体个限制大小算出的 size
 *
 *  @param font 字体
 *  @param size 限制大小
 *
 *  @return Size
 */
- (CGSize)sizeWithFont:(UIFont *)font boundingSize:(CGSize)size;

/**
 *  返回一个 View 的子控件的结构
 *
 *  @param superView 需要挖掘的 View
 *  @param xml       传入一个可变字符串拼接
 *
 *  @return 返回拼接好的字符串
 */
+ (NSMutableString *)digAllSubViews:(UIView *)superView onXMLString:(NSMutableString *)xml;


/**
 *  返回这个路径下的所有文件大小
 *
 *  @return 文件大小
 */
- (long long)fileSize;

@end


#pragma mark- UIImage 系列

@interface UIImage (YCTool)


#pragma mark- 生成图片
/**  给一个 url 的字符串, 返回这个 URL 的图片  */
+ (UIImage *)imageWithURLString:(NSString *)urlStr;
/**
 * 返回一个设定渲染模式的 Image
 */
+ (UIImage *)imageNamed:(NSString *)name withRenderingMode:(UIImageRenderingMode)renderingMode;
/**
 * 返回一个不受渲染的 Image
 */
+ (UIImage *)originalImageName:(NSString *)name;
/**
 *   返回一张圆形剪裁的图片     */
+ (UIImage *)circleImageWithName:(NSString *)name;

/**
 * 返回适配 iOS版本的图片
 */
+ (UIImage *)imageWithName:(NSString *)name;
/**
 *   返回一张纯色图片     */
+ (UIImage *)imageWithColor:(UIColor *)color;

#pragma mark-重新设定尺寸
/**  将不可拉伸区域设定到传入的 imageName 返回  */
+ (UIImage *)imageWithName:(NSString *)imgName CapInset:(CGFloat)capInset;
/**
 *  返回一个中心拉伸的 image
 *
 *  @param name 图片名称
 *
 *  @return 由图片拉伸的 Image
 */
+ (UIImage *)centerStretchImageNamed:(NSString *)name;

#pragma mark- 图片加水印
/**  对象方法, 根据传入的水印图片和文字, 结合原有图片生成并返回一个image  */
- (UIImage *)addWaterImage:(NSString *)waterImage WaterString:(NSString *)waterShtring;

/**  类方法, 根据传入的底图, 水印图和文字合成一个家水印的image返回  */
+ (UIImage *)imageWithBottomImage:(NSString *)bottomImage WaterImage:(NSString *)waterImage WaterString:(NSString *)waterShtring;

/**  保存图片  */
+ (void)writeImage:(UIImage *)img withName:(NSString *)imgName;

@end


#pragma mark- UIView 的扩展

@interface UIView (set)
/**
 *  这里设置个分类, 让改变 view 的 frame 等结构的值时更方便
 */
/**
 *  直接将 frame 的四个参数暴露出来设置
 */

/**
 *  frame的 x值
 */
@property (nonatomic, assign) CGFloat x;
/**
 *  frame 的 y 值
 */
@property (nonatomic, assign) CGFloat y;
/**
 *  frame 的宽
 */
@property (nonatomic, assign) CGFloat width;
/**
 *  frame的高
 */
@property (nonatomic, assign) CGFloat height;
/**
 * view的 size
 */
@property (nonatomic, assign) CGSize viewSize;
/**
 *   view.center.x     */
@property (nonatomic, assign) CGFloat centerX;
/**
 *   view.center.y     */
@property (nonatomic, assign) CGFloat centerY;
/**
 *   MaxX     */
@property (nonatomic, assign) CGFloat maxX;
/**
 *   MaxY     */
@property (nonatomic, assign) CGFloat maxY;

/**
 *   动画时取消应用的所有交互     */
+ (void)animateNotInteractableWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion;
@end



#pragma mark- UIBarButtonItem 的扩展

@interface UIBarButtonItem (create)
/**
 *  返回一个封装按钮到 bar 按钮的 bar 按钮
 *
 *  @param imgName            一般情况下的图片
 *  @param highlightedImgName 高亮图片
 *  @param target             监听对象
 *  @param selector           监听方法
 *
 *  @return 封装好的 barButtonItem
 */
+ (UIBarButtonItem *)barButtonWithImageName:(NSString *)imgName highlightedName:(NSString *)highlightedImgName target:(id)target action:(SEL)selector;
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
+ (UIBarButtonItem *)barButtonWithImageName:(NSString *)imgName highlightedName:(NSString *)highlightedImgName title:(NSString *)title target:(id)target action:(SEL)selector;
@end



#pragma mark- NSMutableDictionary 系列
@interface NSMutableDictionary (YCTool)
/**
 *  返回设定好相应属性的字典
 *
 *  @param color  文字颜色
 *  @param font   字体
 *  @param offset 阴影偏移
 *
 *  @return 设定好的字典
 */
+ (NSMutableDictionary *)attributeWithColor:(UIColor *)color font:(UIFont *)font shadowOffset:(UIOffset)offset;
@end




#pragma mark- UIImagePickerController 系列

@interface UIImagePickerController (YCTool)

/**
 *  创建一个设定好代理和类型的imagePickerController
 *
 *  @param sourceType 类型
 *  @param delegate   代理对象
 *
 *  @return picker
 */
+ (UIImagePickerController *)imagePickerWithType:(UIImagePickerControllerSourceType)sourceType delegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate;
@end


#pragma mark- NSDate 处理系列

@interface NSDate (YCTool)
/**
 *  是否为今天
 */
- (BOOL)isToday;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  是否为今年
 */
- (BOOL)isThisYear;

/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)dateWithYMD;

/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;
@end


#pragma mark- NSArray处理系列
@interface NSArray (YCTool)

 /**
 *  将数组中的元素按照九宫格排列
 *
 *  @param inset  四周边距
 *  @param width  元素宽
 *  @param height 元素高
 *  @param padding view 之间的间距
 *  @param maxCols 最大列数
 *  @param maxRows 最大行数
 *
 *  @return 成功返回 yes
 */
- (BOOL)arrayToLayoutLikeCollectionWithInset:(UIEdgeInsets)inset width:(CGFloat)width height:(CGFloat)height padding:(CGFloat)padding maxCols:(int)maxCols maxRows:(CGFloat)maxRows;

@end

#pragma mark- UIButton系列
@interface UIButton (YCTool)

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
+ (UIButton *)buttonWithTitle:(NSString *)title Image:(UIImage *)image HighlightImage:(UIImage *)highlightImage Target:(id)target action:(SEL)action btnType:(int)buttonType;
/**
 *  快速设置 Normal 和 highlight 状态下的图片
 *
 *  @param image   Normal 图片
 *  @param hlImage Highlight 图片
 */
- (void)setImage:(UIImage *)image highlightImage:(UIImage *)hlImage;
/**
 *  设置某个状态的图片和高亮图片
 *
 *  @param image   Normal 图片
 *  @param hlImage Highlight 图片
 *  @param state   状态
 */
- (void)setImage:(UIImage *)image highlightImage:(UIImage *)hlImage forState:(UIControlState)state;

/**
 *  设置某个状态的背景图片和背景高亮图片
 *
 *  @param image   Normal 图片
 *  @param hlImage Highlight 图片
 *  @param state   状态
 */
- (void)setBackgroundImage:(UIImage *)image highlightImage:(UIImage *)hlImage forState:(UIControlState)state;

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *backgroundNormalImage;
@property (nonatomic, strong) UIImage *highlightImage;
@property (nonatomic, strong) UIImage *backgroundHighlightImage;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *backgroundSelectedImage;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *normalTitleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;
@property (nonatomic, strong) UIColor *highlightTitleColor;
@end