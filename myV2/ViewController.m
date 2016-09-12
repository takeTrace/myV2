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
#import "V2TopicModel.h"
#import "V2NodesGroup.h"


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
 
    //  UI 的完善, 坑: tableView 未找到使背景完全透明, cell, tableView.backgroudView, tableView.backgroudColor 都设置为透明后, 还是会有半透明黑色渲染
    
    //  学习了 iOS8之后的自动布局, 不用手动计算每个控件的位置了, 但是性能可能有所牺牲, 但是代码量少了很多
    //  通过自定义 cell 来使用 xib 进行约束设置, 好使用 iOS 的autoSizingCell 设置
    
    //  使用 MMDrawer 来策划菜单, 设置了三个控制器
    
    //  通过通知来传递事件信息, 减小代码的复杂性
    
    //  简单使用了下 Masonry 和 SDAutolayout, 后者感觉更易用点, 而且国人开发, 文档阅读比较好
    //  另一个自动布局模板没使用, 其貌似做了优化, 单其下评论有说是在主线程来计算的, 其用之方法为 iOS8之前, 大多数人用的先给个不显示的 cell 来放数据后在拿到高, 这也是要求 cell 有自动布局, 而且要设置成preferMaxWidth 等参数, 计算前最好还布局下子控件, 拿到的才准, 这个也是没次拿到计算, 不过作者说他做了缓存处理, 这个还没使用
    
    //
    

    
    
//    将要:
//         完善数据库的存储信息结构
//    分为 三大表: 节点 .  tab.  topic. (以后看看要不要加浏览记录)
//    
//    topic 的字段: 自增 id, topic.id, nodeName, tabName, topic,
//     这样就可以根据节点/tab/topicid 搜索, 减小数据冗余
//    
//    拿某 tab 的话题时先从数据库取, 更新才从网络下载, 同时成功时保存,
//        保存时遍历获取的话题, 先删再曾, 免得重复
//    
//    对于更新节点话题, 是先查不是删, 没有再插入, 因为节点话题不带有 tab 标签, 删了曾会删掉 tab 字段, 之后查 tab 的时候就没有这个话题了, 而如果有的话不插入, 反正原来有的话题带有其节点信息
//    对于新的节点话题, 再更新 tab 时可能会有, 这时也是删了在曾, tab 下 down 下来的信息比较全面,
//    
//    对于点击进入详情或者从公开 API 获取的, 也是删再曾, 信息更全
//    
//    
//    
//    显示详情页面, 测试下自带的 textKit 使用 html 格式直接显示富文本
//    
    


    
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
    
    
//    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [AFOnoResponseSerializer HTMLResponseSerializer];//
    [mgr GET:@"https://www.v2ex.com/" parameters:nil success:^(AFHTTPRequestOperation *operation, id doc) {
        
        [self onoUseWithData:doc];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"shibai %@", error);
    }];
    

    
}

#pragma mark OnoUse
- (void)onoUseWithData:(NSData *)data
{
    [V2HtmlParser parseTopicsWithDocument:data Success:^(NSArray<V2TopicModel *> *topics) {
        [topics enumerateObjectsUsingBlock:^(V2TopicModel * _Nonnull topic, NSUInteger idx, BOOL * _Nonnull stop) {
            YCLog(@" topic.title = %@, --- 回复数:%@ ---- topic.url = %@, topic.id = %@, \n member.name = %@, ----- member.url = %@, ---- member.avatar = %@", topic.title, topic.replies, topic.url, topic.ID, topic.member.username, topic.member.url, topic.member.avatar_normal);
        }];
        YCLog(@"topic.count = %d", topics.count);
    } failure:^(NSError *error) {
        YCLog(@"失败");
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
//    [self htmlParser];
    
}

@end
