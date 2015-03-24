//
//  RegistrSubpageViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSUserCenterMessageInterface.h"

@interface RegistrSubpageViewController : UIViewController<UITextFieldDelegate,
UserCenterMessageInterface>

@property(nonatomic,copy)NSString *phoneNum;  // 上个页面传入的手机号

@property(nonatomic,copy)NSString *verfyCode;  // 上个页面传入的验证码
@end
