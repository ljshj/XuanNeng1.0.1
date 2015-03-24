//
//  detailViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "weiQiangModel.h"
#import "MoudleMessageManager.h"

//定义控制器请求详情类型（评论／刷新）
typedef enum {
    RequestWQDetailTypeNormal,
    RequestWQDetailTypeComment,
    RequestWQDetailTypeRefresh,
}RequestWQDetailType;

@interface detailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MoudleMessageInterface>

@property(nonatomic,strong) weiQiangModel *model;
@property(nonatomic,strong) NSMutableArray *commentsArray;
/**
 *请求类型(评论／刷新)
 */
@property(nonatomic,assign) RequestWQDetailType requestWQDetailType;
@end
