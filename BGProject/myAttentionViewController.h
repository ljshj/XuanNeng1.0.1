//
//  myAttentionViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"
#import "FDSUserCenterMessageInterface.h"
#import "MyAttentionCell.h"

#define UpdateFocusNumberKey @"UpdateFocusNumber"

@interface myAttentionViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate,UserCenterMessageInterface,MyAttentionCellDelegate>

@property(nonatomic,retain)NSMutableArray* myAttendList;

/**
 *判断是否需要刷新，只要点击了头像回来都要刷新页面
 */
@property(nonatomic,assign) BOOL isClickPhoto;

-(void)attentionPersonCB:(int)returnCode;

-(void)myAttentionCell:(MyAttentionCell *)cell
         onClickButton:(UIButton *)button;

@end
