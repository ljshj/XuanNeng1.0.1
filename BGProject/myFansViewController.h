//
//  myFansViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSUserCenterMessageInterface.h"
@interface myFansViewController : UIViewController<UITableViewDelegate,
UITableViewDataSource,UserCenterMessageInterface>

@property(nonatomic,retain)NSMutableArray* fans;
/**
 *判断是否需要刷新，只要点击了头像回来都要刷新页面
 */
@property(nonatomic,assign) BOOL isClickPhoto;

-(void)attentionPersonCB:(int)returnCode;
@end
