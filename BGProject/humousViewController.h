//
//  humousViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoudleMessageInterface.h"
//定义幽默秀类型
typedef enum {
    HumousTypeMy,
    HumousTypeOther,
}HumousType;

@interface humousViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MoudleMessageInterface>
@property(assign,nonatomic) HumousType humousType;
@property(nonatomic,copy) NSString *userid;

// 请求完 @"我的投稿  or 审核中  的数据
-(void)requestSubmittedTopicListCB:(NSArray*)result;

@end
