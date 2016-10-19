# v2ex-station
a v2ex client, i know there is some client exist and better, but, i can create one, it's funny~~~~ 
练练手, 完成一个基本功能的项目
- 目前就是 UI 还不够好
- 基本功能完成了
- 没有做的: 发帖和评论

**感谢之前做这个客户端的大神, 让我可以借鉴和参考很多**




 下面写的还有点乱, 之后再整理了, 

#myV2 制作笔记

*     将要:

                git 到 github
                发布主题和回复
                封装 MMDrawer
                将显示富文本的控件换成第三方
                尝试 ~gallop~ 或 ty 或 yytext, 但这可能需要自己解析出没一段再渲染出来
                在传回的 content 好像是 markdown 格式, 可以查查看看有没有解析显示 markdown 文本的控件, YYText 能显示, 之后先试试, 
                还有[MarkdownTextView](https://github.com/indragiek/MarkdownTextView)
                http://nightfade.github.io/2015/06/26/ios-markdown-rendering/
                这里有讲到怎么解析并显示 markdown 控件, 用的是解析转换工具转换成 HTML 格式, 再用 DTCoreText 配合 TTTAttributedLabel 来实现显示, 等下学习下, 有个疑问, 如果转换成功是列表或者其他形式的标签的话, 属性文本能正确展示出来吗? 

                 关于在回复中有评论出现图片的图片大小超出的处理: 目前是想遍历属性字符串, 把图片 attach 设定好 bounds

                  测试了下原生的, 对代码快的支持貌似也不太好

- gallop 可以自带有解析,可以试试看效果, gallop 对于其中没有匹配的标签, 解析无力, 需要自己设置好对应标签的 config 才会在对应的标签有所处理, 按照里面的代码, 应该没有对应标签时都当做文本处理, 但是试了发现有些情况处理不了,  显示 NSAttributedString 的话对于添加 UIImageView 进去但是 加载好图片后不能刷新....
- TYAttributedLabel 本身没有直接解析 HTML 文本的功能, 只能自己解析了对应到相应的属性去渲染出来, 试试显示 NSAttributedString. 
- 以上两种方法都需要自己解析出对应的标签, 但是 HTML 的标签有时候挺多的, 自己解析完比较繁杂. 就目前想先完成项目来说, 是下策, 在其他方法行不通的时候再去尝试了
- 还有几个显示 HTML 文本的第三方控件, 但是对于网络图片的显示不是很好, 改动代码可以加载网络图, 但是要异步加载那改的就比较繁琐了, 而且好像直接用的 [nsstring rangeOf:] 来判断和替换的, 感觉这样好像挺耗性能的, 加上长期没有维护了, 真是下下策...
- 

*     关于可翻页的数据进行上拉加载更多:
    -     应该在刷新后确定是这应用最....额, 因为服务端不能返回按照 id大小返回, 所以为了确保上拉时是跟着前面下拉不久的...不然从缓存的列表上拉的话...将会是比较新的数据但是排在后面(或者不修改本地记录时间机制,会排在前面, 这样也会排在第一页之前了...但是上啦刷新的时候就看不到新加载的了, 或者在改变上拉加载的本地时间记录小于最后一条的话, ),
    -     记录上一次刷新下拉刷新后最后一个主题的本地时间和索引, 
    -     当上拉刷新时, 
    -     if( 时间>30m) {是就应该是新数据, 排在前面,滚到顶}
    -     else {不是, 就拿记录的那个本地时间之前的时间来记录本地时间, 并滚到那个记录的索引}

    - 或者, 可以翻页的地方都直接加载最新的数据, 数据库的数据放到一个历史控制器里, 当没有网络时候就跳到历史

*     _显示详情页面, 测试下自带的 textKit 使用 html 格式直接显示富文本_ 嗯, 好像不太好用, 对于图片排版和点击, 决定还是用第三方, gallop 说是可以异步加载绘制的, 好像有图片点击, TYAttributeLabel 也可以点击, 等待尝试
*     
*          _完善数据库的存储信息结构
*     分为 三大表: 节点 .  tab.  topic. (以后看看要不要加浏览记录)
*     
*     topic 的字段: 自增 id, topic.id, nodeName, tabName, topic,
*      这样就可以根据节点/tab/topicid 搜索, 减小数据冗余
*     
*     拿某 tab 的话题时先从数据库取, 更新才从网络下载, 同时成功时保存,
*         保存时遍历获取的话题, 先删再曾, 免得重复
*     
*     对于更新节点话题, 是先查不是删, 没有再插入---因为节点话题不带有 tab 标签, 删了曾会删掉 tab 字段, 之后查 tab 的时候就没有这个话题了, 而如果有的话不插入, 反正原来有的话题带有其节点信息
*     对于新的节点话题----再更新 tab 时可能会有, 这时也是删了在曾, tab 下 down 下来的信息比较全面,
*     
*     对于点击进入详情或者从公开 API 获取的, 也是删再曾, 信息更全_
*     

*   这里, 将不作为参与项目的控制器, 而是列出项目逻辑的地方, 可以将这里作为阅读项目结构和对应逻辑的构思及实现方法说明的地方,也就是你不用一个个文件去看了......我是看别人代码的时候是挺头疼...新手嘛...在一堆代码里要想找出自己想学习的地方还是挺....  特别是没有注释的代码, 要弄清楚别人的逻辑结构也是够呛
    
*   首先, 这里会测试一下 V 站的数据, 拿到数据才好按照能拿到的数据看看怎么展现出来     */
    
*   V 站官方的接口是比较....少, 能拿到的数据都比较少, 搭建不了完整的结构, 阅读了下数据处理做的比较好的客户端:... 他是在能拿到 API 返回json的地方 用数据, 其他的都是通过解析加载的 html 数据来获取对应的信息, 再转换成需要的模型.  也是高手...我是目前对解析这方面比较弱, 故先借用来获取数据
    /**
     *   通过 AFN 对 NSURLSession 的封装来作为网络请求
     */
    *   关于 session 的了解: https:* objccn.io/issue-5-4/ 我是看这篇帖子的, 之前我学习用到的是 session 的前任: NSURLConnecting
    
    
    
    
#pragma mark- 因为 API 的信息少, 看看从网页源码能获得什么信息
*     NSError *error = nil;
*     NSString *str = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https:* www.v2ex.com/api/nodes/all.json" ] encoding:NSUTF8StringEncoding error:&error];
*     NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"1.html"];
*     NSLog(@"path = %@", file);
    /**
     *   经测试, 直接加载 string 可以加载 html 的源码到 String, 也可以用 AFN 来设置 sereration 为 http, 加载出来的数据就是 html , 转为 string 就能显示出来, 不然都是二进制数据     */
    
* 
*     
*     [str writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:&error];
*     NSLog(@"/n%@", str);
    
    
    
    *   创建会话管理者,
    *     查看 API 返回的数据是怎么样, 做出 API 能返回的模型, 至于其他的, 看看能不能抓包到对应的数据
    
    /**
     *   根据接口来定义模型和获取的方法, 不常变化的设置为数组保存起来, 并设置更新方法, 调用这个方法菜更新这些比较固定的数据,
     需要传参数的方法定义方法获取, 因单个数据可能会有变化, 保存起来, 这些比较有变动的数据在返回的时候通过网络获取数据, 如果没有网络就返回保存的数据并在 keywindow 提示,
     
     */
    
    /**
     *   因传递的参数较少, 暂时直接用宏, 没用模型, 而且返回的结果直接就是话题模型或者是 member 模型, 也不做 result 模型的制作     */
    /**
     *   用 V2DataManager 来管理数据的调用, 是缓存是请求由其决定     */

*   设计模型
    [self designModel];
    
    *   封装网络层
    [self wrapperNetTool];
    
    *   测试封装的 API 工具
    [self testAPITool_V2DataManager];
    
    *   简单搭建 UI 结构
    
    
    *   实现细节
    
    
    *   参考其他客户端源码
    
    
    *   封装解析 html 网页的内容, 丰富客户端的内容
*     [self htmlParser];
    
    *   完善客户端
 
    *   UI 的完善, 坑: tableView 未找到使背景完全透明, cell, tableView.backgroudView, tableView.backgroudColor 都设置为透明后, 还是会有半透明黑色渲染
    
    *   学习了 iOS8之后的自动布局, 不用手动计算每个控件的位置了, 但是性能可能有所牺牲, 但是代码量少了很多
    *   通过自定义 cell 来使用 xib 进行约束设置, 好使用 iOS 的autoSizingCell 设置
    
    *   使用 MMDrawer 来策划菜单, 设置了三个控制器
    
    *   通过通知来传递事件信息, 减小代码的复杂性
    
    *   简单使用了下 Masonry 和 SDAutolayout, 后者感觉更易用点, 而且国人开发, 文档阅读比较好
    *   另一个自动布局模板没使用, 其貌似做了优化, 单其下评论有说是在主线程来计算的, 其用之方法为 iOS8之前, 大多数人用的先给个不显示的 cell 来放数据后在拿到高, 这也是要求 cell 有自动布局, 而且要设置成preferMaxWidth 等参数, 计算前最好还布局下子控件, 拿到的才准, 这个也是没次拿到计算, 不过作者说他做了缓存处理, 这个还没使用
    

# 对于登录:
    - 登录的话需要拿到保存网站的 cookie, post 参数:once, next(/), 

    

    
    

    



