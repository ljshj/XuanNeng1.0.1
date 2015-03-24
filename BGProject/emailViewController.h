//
//  emailViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-29.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSUserCenterMessageInterface.h"
@interface emailViewController : UIViewController<UITextViewDelegate,UserCenterMessageInterface>

-(void)upDateUserInfoCB:(int)returnCode;

@end
