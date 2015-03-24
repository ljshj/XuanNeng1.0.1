//
//  scanViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-29.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//  

#import <UIKit/UIKit.h>
#import "NameCardModel.h"
#import "BGUser.h"
#import "NameCardModel.h"

@interface scanViewController : UIViewController

@property(nonatomic,retain)BGUser* user;

//@property(nonatomic,retain)NameCardModel* model;

// 是否是显示自己的名片
@property(nonatomic,assign)BOOL isMyself;
@end
