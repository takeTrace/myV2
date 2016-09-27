//
//  YCGloble.h
//  03- 汽车展示-高级
//
//  Created by Mac on 15/12/27.
//  Copyright (c) 2015年 Lneayce. All rights reserved.
//

#ifndef _3__________YCGloble_h
#define _3__________YCGloble_h
/**  这里可以集中定义一些宏定义. 以后可以再代码中引用这个头文件就可以随时使用这些宏  */
/**  宏定义中, 需要用到回车的用反斜杠\ , 可以再(xxx), 替换xxx##  , ##:连接变量和语句  */

/**
 *  对都用到的设定的宏
 *
 *  @param  宏
 *
 *  @return
 */

//  ********************   通用值   ******************************   //
#define YCPadding 10

//  ********************   花名s    ******************************   //
#ifdef __BLOCKS__
typedef void (^voidBlock)(void);
#endif


//  ********************   发送通知   ******************************   //
#define YCSendNotification(note, userinfoDictionary) [[NSNotificationCenter defaultCenter] postNotificationName:note object:self userInfo:userinfoDictionary];
//  ********************   添加观察者监听通知   ******************************   //
#define YCAddObserver(someSelector, note) [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(someSelector) name:note object:nil];
//  ********************   通知中心   ******************************   //
#define YCNotification [NSNotificationCenter defaultCenter]

//  ********************   标记   ******************************   //
#define YCMark #pragma mark-

//  ********************   stringFormating   ******************************   //
#define NSStringFromFormat(...) [NSString stringWithFormat:__VA_ARGS__]
//  ********************   标题和按钮字体   ******************************   //


#define YCTitleFontSize [UIFont systemFontOfSize:20]
#define YCBarButtonFontSize [UIFont systemFontOfSize:15]




//  ********************   颜色   ******************************   //

#define YCCColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
/**
 *   随机色     */
#define YCRandomColor YCCColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255), 1)


//  ********************  屏幕宽度   ******************************   //
#define YCScreenW [UIScreen mainScreen].bounds.size.width
#define YCScreenH [UIScreen mainScreen].bounds.size.height

/**  字典转模型的声明  */
#define YCInitH(name) \
- (instancetype)initWithDict:(NSDictionary *)dict; \
+ (instancetype)name##WithDict:(NSDictionary *)dict;
/**  字典转模型的实现  */
#define YCInitM(name) \
/**  由于这两个实现也是大同小异, 应该也放到一个宏去定义  */ \
- (instancetype)initWithDict:(NSDictionary *)dict \
{ \
    if (self = [super init]) { \
        /**  字典转模型  */ \
        /**  如果这里转出来的模型中的数组里面还是字典, 应该还要予以转换,方法另外自己实现  */ \
        [self setValuesForKeysWithDictionary:dict]; \
    } \
    return self; \
} \
+ (instancetype)name##WithDict:(NSDictionary *)dict \
{ \
    return [[self alloc] initWithDict:dict]; \
}



/**  我是华丽的分割线..................................................................................  */


//#ifdef __OBJC__

/**  ...代表多个参数, 这里的宏定义会将代码中的 YCLog 替换成 NSLog, 然后会将...中的参数传递到__VA_ARGS__的位置, 这样在需要注释掉代码的时候在这里替换注释掉的就可以了  */
//#define YCLog(...) NSLog(__VA_ARGS__)
/**  在项目的调试过程中还未发布到ituns 上时, 每个文件中会有一个 DEBUG 宏, 发布的时候系统会自动去掉这个宏, 所以根据这个判断可以设定什么时候需要定义成什么样的 log  */
#ifdef DEBUG
#define YCLog(...) NSLog(__VA_ARGS__)
#else
#define YCLog(...)
#endif


#define YCPlog YCLog(@"\nfunction: %s, \nline:%d", __PRETTY_FUNCTION__ , __LINE__)

/**  获取Caches沙盒路径  */
#define YCCacheDirectry [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

//  ********************   获取当前沙盒   ******************************   //
#define YCDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]


/**
 *   document文件   */
#define YCUserDefaults [NSUserDefaults standardUserDefaults]


//  判断 iOS 版本 ````````````````````````````````````````````````
#define YCiOS7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)

//  判断是不是 ARC
#define YCArc __has_feature(objc_arc)



//  ********************   设计单例模式   ******************************   //

/**  设计某个类为单例模式  */
/**  单例模式的声明  */
#define singleton_h(name) \
+ (instancetype)share##name;

#if __has_feature(objc_arc) //  ARC

#define singleton_m(name)   \
static id _instance;    \
\
+ (id)allocWithZone:(struct _NSZone *)zone  \
{   \
static dispatch_once_t onceToken;   \
dispatch_once(&onceToken, ^{    \
_instance = [super allocWithZone:zone]; \
}); \
return _instance;   \
}   \
+ (instancetype)share##name  \
{   \
static dispatch_once_t onceToken;   \
dispatch_once(&onceToken, ^{    \
_instance = [[self alloc] init];    \
}); \
return _instance;   \
}   \
\
\
+ (id)copyWithZone:(struct _NSZone *)zone {    return _instance;   }


#else       //  非 ARC

#define singleton_m(name)   \
static id _instance;    \
\
+ (id)allocWithZone:(struct _NSZone *)zone  \
{   \
static dispatch_once_t onceToken;   \
dispatch_once(&onceToken, ^{    \
_instance = [super allocWithZone:zone]; \
}); \
return _instance;   \
}   \
+ (instancetype)share##name  \
{   \
static dispatch_once_t onceToken;   \
dispatch_once(&onceToken, ^{    \
_instance = [[self alloc] init];    \
}); \
return _instance;   \
}   \
\
+ (id)copyWithZone:(struct _NSZone *)zone {    return _instance;   }   \
\
\
\
\
- (oneway void)release { }  \
\
- (id)autorelease {    return _instance;  } \
\
- (id)retain {    return _instance;     }   \
\
- (NSUInteger)retainCount {    return 1;  }

#endif

#endif
