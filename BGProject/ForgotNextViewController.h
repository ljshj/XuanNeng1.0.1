//
//  ForgotNextViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "FDSUserCenterMessageInterface.h"
//#import "FDSUserCenterMessageManager.h"


@interface ForgotNextViewController : UIViewController<UITextFieldDelegate>


@property(nonatomic,copy)NSString *recStr;

// 接受服务器发送的验证码
@property(nonatomic,copy)NSString* verfy;


@end
