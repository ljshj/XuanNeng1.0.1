//
//  SexViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSUserCenterMessageInterface.h"
@interface SexViewController : UIViewController<UserCenterMessageInterface>

-(void)upDateUserInfoCB:(int)returnCode;

@end
