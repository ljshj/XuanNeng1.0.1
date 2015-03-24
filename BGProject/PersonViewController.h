//
//  PersonViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSUserCenterMessageInterface.h"

#define PopLogoffControllerKey @"PopLogoffController"

@interface PersonViewController : UIViewController<UITextFieldDelegate,UserCenterMessageInterface>
/**
 *是否隐藏返回按钮
 */
@property(nonatomic,assign) BOOL isAppearBackBtn;
@end
