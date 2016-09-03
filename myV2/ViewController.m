//
//  ViewController.m
//  myV2
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <AFOnoResponseSerializer.h>
#import <Ono.h>
#import <MJExtension.h>
#import "siteInfoModel.h"
#import "V2NodeModel.h"
#import "V2OperationTool.h"
#import "V2DataManager.h"
#import "YCGloble.h"
#import "OCGumbo+Query.h"
#import "V2HtmlParser.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    NSLog(@"document: \n %@", YCDocumentPath);
    /**
     *   这里, 将不作为参与项目的控制器, 而是列出项目逻辑的地方, 可以将这里作为阅读
        项目结构和对应逻辑的构思及实现方法说明的地方, 
            也就是你不用一个个文件去看了......我是看别人代码的时候是挺头疼...新手嘛...
            在一堆代码里要想找出自己想学习的地方还是挺....  特别是没有注释的代码, 要弄清楚别人的
        逻辑结构也是够呛
     */
    
    /**
     *   首先, 这里会测试一下 V 站的数据, 拿到数据才好按照能拿到的数据看看怎么展现出来     */
    
    /**
     *   V 站官方的接口是比较....少, 能拿到的数据都比较少, 搭建不了完整的结构, 阅读了下数据处理做的比较好的客户端:... 
            他是在能拿到 API 返回json的地方 用数据, 其他的都是通过解析加载的 html 数据来获取
        对应的信息, 再转换成需要的模型.  也是高手...我是目前对解析这方面比较弱, 故先借用来获取数据
     */
    /**
     *   通过 AFN 对 NSURLSession 的封装来作为网络请求
     */
    //  关于 session 的了解: https://objccn.io/issue-5-4/ 我是看这篇帖子的, 之前我学习用到的是 session 的前任: NSURLConnecting
    
    
    
    
#pragma mark- 因为 API 的信息少, 看看从网页源码能获得什么信息
//    NSError *error = nil;
//    NSString *str = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://www.v2ex.com/api/nodes/all.json" ] encoding:NSUTF8StringEncoding error:&error];
//    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"1.html"];
//    NSLog(@"path = %@", file);
    /**
     *   经测试, 直接加载 string 可以加载 html 的源码到 String, 也可以用 AFN 来设置 sereration 为 http, 加载出来的数据就是 html , 转为 string 就能显示出来, 不然都是二进制数据     */
    
//
//    
//    [str writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:&error];
//    NSLog(@"/n%@", str);
    
    
    
    //  创建会话管理者,
    //    查看 API 返回的数据是怎么样, 做出 API 能返回的模型, 至于其他的, 看看能不能抓包到对应的数据
    
    /**
     *   根据接口来定义模型和获取的方法, 不常变化的设置为数组保存起来, 并设置更新方法, 调用这个方法菜更新这些比较固定的数据,
     需要传参数的方法定义方法获取, 因单个数据可能会有变化, 保存起来, 这些比较有变动的数据在返回的时候通过网络获取数据, 如果没有网络就返回保存的数据并在 keywindow 提示,
     
     */
    
    /**
     *   因传递的参数较少, 暂时直接用宏, 没用模型, 而且返回的结果直接就是话题模型或者是 member 模型, 也不做 result 模型的制作     */
    /**
     *   用 V2DataManager 来管理数据的调用, 是缓存是请求由其决定     */

//  设计模型
    [self designModel];
    
    //  封装网络层
    [self wrapperNetTool];
    
    //  测试封装的 API 工具
    [self testAPITool_V2DataManager];
    
    //  简单搭建 UI 结构
    
    
    //  实现细节
    
    
    //  参考其他客户端源码
    
    
    //  封装解析 html 网页的内容, 丰富客户端的内容
//    [self htmlParser];
    
    //  完善客户端
 
    
    


    
}


#pragma mark- 设计模型
- (void)designModel
{
    //    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //    //    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    [mgr GET:@"https://www.v2ex.com/api/members/show.json?id=122" parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
    //        //        NSLog(@"responseObj: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    //        NSLog(@"%@", responseObject.allKeys);
    ////        NSLog(@"\n%@", responseObject[0]);
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        NSLog(@"error: %@", error);
    //    }];
}


#pragma mark- 封装网络层
- (void)wrapperNetTool
{
    /**
     *   设定了封装网络层的 api , 使用 afn.httpRequestOperationManager 封装到 dataTool     */
    //    [V2OperationTool GET:@"https://www.v2ex.com/api/members/show.json?id=122" dataType:V2DataTypeJSON parameters:nil success:^(NSDictionary * responseObject) {
    //
    ////        NSLog(@"responseObj: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    //        NSLog(@"%@", responseObject.allKeys);
    ////        NSLog(@"\n%@", responseObject[0]);
    //    } failure:^(NSError *error) {
    //        NSLog(@"error: %@", error);
    //    }];

}


#pragma mark-  测试 V2DataManager 是否正确
- (void)testAPITool_V2DataManager
{
    
    //  ********************   站点   ******************************   //
    
    //    [V2DataManager siteInfoSuccess:^(siteInfoModel *siteInfo, SiteStateModel *siteState) {
    //        NSLog(@"site: %@, state: %@", siteInfo, siteState);
    //    } failure:^(NSError *error) {
    //        NSLog(@"失败");
    //    }];
    
    //    [V2DataManager updateSiteInfoSuccess:^(siteInfoModel *siteInfo, SiteStateModel *siteState) {
    //        NSLog(@"site: %@, state: %@", siteInfo, siteState);
    //    } failure:^(NSError *error) {
    //        NSLog(@"失败");
    //    }];
    //
    
    //  ********************   节点   ******************************   //
    
    
    //    [V2DataManager allNodesSuccess:^(NSArray<V2NodeModel *> *nodes) {
    //        NSLog(@"count: %d", nodes.count);
    //        [nodes enumerateObjectsUsingBlock:^(V2NodeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            YCLog(@"topic: %@", obj.name);
    //        }];
    //    } failure:^(NSError *error) {
    //        NSLog(@"失败");
    //    }];
    
    
    //    [V2DataManager updateAllNodesSuccess:^(NSArray<V2NodeModel *> *allNodes) {
    //        NSLog(@"count: %d", allNodes.count);
    //        [allNodes enumerateObjectsUsingBlock:^(V2NodeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            YCLog(@"topic: %@", obj.name);
    //        }];
    //    } failure:^(NSError *error) {
    //        NSLog(@"失败");
    //    }];
    
    
    //    [V2DataManager getNodeWithId:@"1" orName:nil success:^(V2NodeModel *node) {
    //        YCLog(@"node: %@", node);
    //    } failure:^(NSError *error) {
    //        YCLog(@"失败");
    //    }];
    
    
    //  ********************   话题   ******************************   //
    
    //    [V2DataManager getHotestTopicsSuccess:^(NSArray<V2TopicModel *> *hotestTopics) {
    //        NSLog(@"count: %d, hots: %@", hotestTopics.count, hotestTopics);
    //    } failure:^(NSError *error) {
    //        NSLog(@"失败");
    //    }];
    
    //    [V2DataManager getLatestTopicsSuccess:^(NSArray<V2TopicModel *> *latestTopics) {
    //        NSLog(@"count: %d", latestTopics.count);
    //        [latestTopics enumerateObjectsUsingBlock:^(V2TopicModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            YCLog(@"topic: %@", obj.title);
    //        }];
    //    } failure:^(NSError *error) {
    //        NSLog(@"失败");
    //    }];
    
    //    [V2DataManager getTopicWithId:@"123" success:^(V2TopicModel *topic) {
    //        YCLog(@"topic; %@", topic);
    //    } failure:^(NSError *error) {
    //        YCLog(@"失败");
    //    }];
    //
    
    //    [V2DataManager getTopicWithUserName:nil orNodeId:@"1" orNodeName:nil success:^(NSArray<V2TopicModel *> *topics) {
    //        YCLog(@"topicsCount : %d", topics.count);
    //    } failure:^(NSError *error) {
    //        YCLog(@"失败");
    //    }];
    
    //  ********************   回复   ******************************   //
    //    [V2DataManager getRepliesInTopic:@"123" andPage:nil pageSize:nil success:^(NSArray<V2ReplyModel *> *replies) {
    //        YCLog(@"replys  count = %d", replies.count);
    //    } failure:^(NSError *error) {
    //        YCLog(@"失败");
    //    }];
    //
    //  ********************   成员   ******************************   //
    
//    [V2DataManager memberWithMemberId:@"1" orName:nil success:^(V2MemberModel *member) {
//        YCLog(@"member = %@", member);
//    } failure:^(NSError *error) {
//        YCLog(@"失败%@", error);
//    }];
//    
    
    
    
}



#pragma mark- 封装解析 html 网页的内容, 丰富客户端的内容
- (void)htmlParser
{
    
    
    
    
    
#warning Note:  使用AFOnoResponseSerializer用 xpath 的话要 xml 网页才行, 其 CSS 搜法不太好, 只能搜一级的节点, 也没懂怎么用 CSS 来搜, 使用http://www.jianshu.com/p/4e6e42945f05的方法, 直接用 ono 来加载 data 再通过 xpath 解析, .... 额, 这个好像也是只通过 XPath 来加载的, 比较死, 还是用 hpple 或者 OCGumbo 吧....., 好像 ObjectiveGumbo 更 OC 点...
#warning Note: 注意:!!! 通过 afn 加载的话会自动拼接 head 信息, 使得网页加载的是适配手机的网页, dom 结构不一样!!!!!
    /**
     *   所以....我又用会 ono 了....   又钻了次牛角尖....  不过也弄明白了之前怎么都搜不到的原因,....     */
    
    
//    [self OOCGumboUse];
    
    
    
    
//    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFOnoResponseSerializer HTMLResponseSerializer];//[AFHTTPResponseSerializer serializer];
    
    [mgr GET:@"https://www.v2ex.com/" parameters:nil success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *doc) {
//        NSLog(@"%@", doc );
        
        /**
         *   当前获取的是tab=全部     */
        
        [doc.rootElement.children enumerateObjectsUsingBlock:^(ONOXMLElement *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"chil = %@", obj.attributes);
        }];

        ONOXMLElement *topBox = [doc firstChildWithCSS:@".box"];
        ONOXMLElement *topTabsCell = [topBox firstChildWithCSS:@".cell"];
        for (ONOXMLElement *tab in [topTabsCell CSS:@"a"]) {
            YCLog(@"tab.tag = %@, %@ = %@", tab.tag, tab.stringValue, tab.attributes[@"href"]);
        }
//        ONOXMLElement *test = [tabsnode firstChildWithCSS:@".box"];
        int cou = 0;
//        for (ONOXMLElement *ele in [doc CSS:@".avatar"]) {
//            NSLog(@"aaaaaa-----%@", ele.tag);
//            cou++;
//        }
        
        YCLog(@"cccccccc===%d", cou);
//        ONOXMLElement *content = [test firstChildWithCSS:@".cell item"];
//        ONOXMLElement *main = [content firstChildWithCSS:@"a"];
//        ONOXMLElement *box = [main firstChildWithCSS:@"a"];
//        NSLog(@"%@-----------", main.stringValue);
//        NSMutableArray *arr = [inner CSS:@"a.tab"];
//        [arr enumerateObjectsUsingBlock:^(ONOXMLElement *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSLog(@"%@", obj.attributes
//                  );
//
//        }];
    
////
        
//        ONOXMLElement *postsParentElement= [doc firstChildWithXPath:@"//*[@id=\"Tabs\"]"]; //寻找该 XPath 代表的 HTML 节点,
//        //遍历其子节点,
//        [postsParentElement.children enumerateObjectsUsingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSLog(@"%@",element);
//        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"shibai %@", error);
    }];
    

    
}
#pragma mark OCGumbo
- (void)OOCGumboUse
{
    NSString *ur = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://www.v2ex.com/"] encoding:NSUTF8StringEncoding error:nil];
    OCGumboDocument *doc = [[OCGumboDocument alloc] initWithHTMLString:ur];
    
    NSString *path = YCDocumentPath;
    NSString *file = [path stringByAppendingPathComponent:@"v2.html"];
//
    [ur writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    YCLog(@"%@", doc.Query(@"#Tabs").find(@".tab"));
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    [mgr GET:@"https://www.v2ex.com/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *data = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"respon ----%d", );
        NSString *file2 = [path stringByAppendingPathComponent:@"v22.html"];
        [data writeToFile:file2 atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败-----%@", error);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self htmlParser];
    
//    NSMutableArray *array=[NSMutableArray array];
//    NSData *data= [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://www.v2ex.com/"]]; //下载网页数据
//    
//    NSError *error;
//    ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:&error];
//    ONOXMLElement *postsParentElement= [doc firstChildWithXPath:@"//*[@id=\"Tabs\"]"]; //寻找该 XPath 代表的 HTML 节点,
//    //遍历其子节点,
//    [postsParentElement.children enumerateObjectsUsingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"%@",element);
//    }];
}

@end
