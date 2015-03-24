//
//  XuanNengMainMenueViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoudleMessageInterface.h"
#define TableViewBgColor [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0]

// 定义评论类型
typedef enum {
    jokeListTypeSequence,//默认是最新的列表
    jokeListTypeRandom,
    jokeListTypeRankList,
}JokeListType;

@interface XuanNengMainMenueViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MoudleMessageInterface>
/**
 *是否在弹出模态视图（是的话就出现的时候就不请求数据）
 */
@property(nonatomic,assign) BOOL isPresentModal;

-(void)requestChartsCB:(NSArray*)result;

// 点了下赞 的服务器响应
-(void)submitSupportAtXuanNengCB:(int)result;
@end
