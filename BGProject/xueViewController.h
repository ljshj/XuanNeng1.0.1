//
//  xueViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-29.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xueViewController : UIViewController<UserCenterMessageInterface>

-(void)upDateUserInfoCB:(int)returnCode;

@end
