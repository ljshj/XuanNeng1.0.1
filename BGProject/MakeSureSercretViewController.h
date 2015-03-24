//
//  MakeSureSercretViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSUserCenterMessageManager.h"

@interface MakeSureSercretViewController : UIViewController<UITextFieldDelegate,UserCenterMessageInterface>
// 用户选中的id，用上个页面传入
@property(nonatomic,copy)NSString* phoneNum;

@end
