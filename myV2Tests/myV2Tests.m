//
//  myV2Tests.m
//  myV2Tests
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 Lneayce. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Ono.h>
@interface myV2Tests : XCTestCase

@end

@implementation myV2Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    NSString *text = @"46678878@qq.com,  13888228766,方案一： <a target=\"_blank\" href=\"https://github.com/joke2k/faker\" rel=\"nofollow\">https://github.com/joke2k/faker</a> <br />存在问题：英文的昵称，不合适 <br /> <br />方案二： <a target=\"_blank\" href=\"https://github.com/kulovecc/nickname_generator\" rel=\"nofollow\">https://github.com/kulovecc/nickname_generator</a> <br />存在问题：字典不够大 <br /> <br />方案三：抓取一些其他网站的用户昵称，如：新浪微博@<a target=\"_blank\" href=\"/member/Livid\">Livid</a> 从前段时间开始我只要点“关注”（同一排有“技术”，“创意”，等等）就会 500 ，然后 V2EX 会 ban 我的 ip 一段时间，麻烦有空时看下原因，谢谢\"雷亚 5 周年,旗下所有游戏 9/8-/9/9 冰点 1 元 <br /><img src=\"http://ww4.sinaimg.cn/large/7338c59fgw1f7n01f3yidj20gw09xta4.jpg\" class=\"embedded_image\" border=\"0\" /> 不知道有多少人有午睡或者晚上睡觉前听点播客什么的，很多播客软件或者喜马拉雅之类的都只支持定时关闭，声音好像都没怎么变化。 <br /> 花城农夫周五活动之——买月饼送阳澄湖大闸蟹啦！ <br /> <br />榴莲月饼，软糯爆棚，榴莲控最爱，淘宝价 238 起，我们只要 209 ，联系我还有折扣哦～～～～～ <br /> <br />阳澄湖大闸蟹，名声在外不多说，现在只要买月饼就送 6 只大闸蟹，配送到手保证所有都是活蹦乱爬在喘气的，如有死蟹统统负责！ <br /> <br />大闸蟹也可以单买哦！！！！ <br /> <br /><img src=\"http://ww2.sinaimg.cn/large/9f38d1dbgw1f7n6h6exp1j20f00m8gn1.jpg\" class=\"embedded_image\" border=\"0\" /> <br /><img src=\"http://ww2.sinaimg.cn/large/9f38d1dbgw1f7n6h4sc3tj20ku0l2gnf.jpg\" class=\"embedded_image\" border=\"0\" /> <br /><img src=\"http://ww2.sinaimg.cn/large/9f38d1dbgw1f7n6hbe6bhj20m80gotai.jpg\" class=\"embedded_image\" border=\"0\" /> <br /><img src=\"http://ww2.sinaimg.cn/large/9f38d1dbgw1f7n6hctc78j20ch0m8aav.jpg\" class=\"embedded_image\" border=\"0\" /> <br />——————————————大闸蟹—————————————— <br /><img src=\"http://ww2.sinaimg.cn/large/9f38d1dbgw1f7n6hf3h9vj20m80dwdh7.jpg\" class=\"embedded_image\" border=\"0\" /> <br /><img src=\"http://ww2.sinaimg.cn/large/9f38d1dbgw1f7n6h8g4dxj20m80tmq57.jpg\" class=\"embedded_image\" border=\"0\" /> <br /><img src=\"http://ww2.sinaimg.cn/large/9f38d1dbgw1f7n6hgxe06j20m80tmq5p.jpg\" class=\"embedded_image\" border=\"0\" /> <br /> <br />～～～～～～扫码购买～～～～～～ <br /> <br /><img src=\"http://ww2.sinaimg.cn/large/9f38d1dbgw1f7n6o9b9vgj20ap0aodh8.jpg\" class=\"embedded_image\" border=\"0\" /> ";
    
    
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithString:text encoding:NSUnicodeStringEncoding error:nil];
    
    for (ONOXMLElement *ele in [doc.rootElement childrenWithTag:@"img"]) {
        NSLog(@"ele = %@", ele);
    }
    //    [atr addAttribute:NSLinkAttributeName value:@"https://www.v2ex.com" range:NSMakeRange(0, 10)];
    
    //    DetailHeaderView *de = [DetailHeaderView headerView];
    //    de.sd_layout
    //    .leftEqualToView(self.view)
    //    .topEqualToView(self.view)
    //    .bottomSpaceToView(de.co, 10);
    //
    //    de.co.userInteractionEnabled = YES;
    //
    //    //    de.co.text = text;
    //    de.co.attributedText = atr;
    //    de.co.backgroundColor = [UIColor redColor];
    //    [self.view addSubview:de];
    
    
    
    
    //    NSLog(@"lable.rect %f", CGRectGetMaxY(de.co.frame));
    
    //    NSLog(@"--------\n %@", atr );
    //    NSString *string = atr.string;
    //    NSLog(@"isEqual? %@", string);
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
