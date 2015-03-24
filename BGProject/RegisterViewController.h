//
//  RegisterViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
// 需要发送消息后执行cb函数
#import "FDSUserCenterMessageInterface.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate,UserCenterMessageInterface>
/**
 *是否重复注册手机号码
 */
@property(nonatomic,assign) BOOL isPhoneNumRegisterAgain;

- (void)userRequestVerifyCodeCB:(NSString*)result :(NSString*)authCode :(NSString*)timeout;
@end
