//
//  ForgotEndViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>



#import "FDSUserCenterMessageInterface.h"
#import "FDSUserCenterMessageManager.h"

@interface ForgotEndViewController : UIViewController<UITextFieldDelegate
,UserCenterMessageInterface>


@property(nonatomic,copy)NSString* phoneNum;

// 用户忘记密码后，重置密码的回调
-(void)userResetPwdForForgetPwdCB:(NSDictionary*)dic;

-(void)userLoginCB:(NSDictionary*)dic;

@end
