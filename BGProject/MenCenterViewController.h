//
//  MenCenterViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-23.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGUser.h"
#import "MoudleMessageInterface.h"

@interface MenCenterViewController : UIViewController<MoudleMessageInterface>

@property(nonatomic,copy)NSString *phoneNum;
@property(nonatomic,assign)BOOL needUpdate;//是否需

-(void)showUserInfo:(BGUser*)user;

// 请求我的微墙
-(void)weiQiangListCB:(NSArray *)result;

@end
