//
//  ForgotSecretViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//
typedef void(^myBlock)(UIViewController *);

#import <UIKit/UIKit.h>
#import "FDSUserCenterMessageManager.h"
#import "FDSUserCenterMessageInterface.h"
@interface ForgotSecretViewController : UIViewController<UITextFieldDelegate,
UserCenterMessageInterface>
{
    myBlock passValueBlock;
}


//用户发送手机号后的返回
-(void)userRequestVerifyCodeForForgetPWDCB:(NSDictionary*)dic;

-(void)pushController:(myBlock )block;
-(void)setPassValueBlock:(myBlock)newBlock;
@end

