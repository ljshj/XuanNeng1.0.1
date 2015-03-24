//
//  InviteMembersViewController.h
//  BGProject
//
//  Created by liao on 15-1-3.
//  Copyright (c) 2015年 zhuozhong. All rights reserved.
//  邀请好友

#import <UIKit/UIKit.h>

@interface InviteMembersViewController : UIViewController
/**
 *成员数组（用于过滤调那些已经加入群成员的模型）
 */
@property(nonatomic,strong) NSArray *members;
/**
 *环信ID（用于邀请群成员）
 */
@property(nonatomic,copy) NSString *hxgroupid;
/**
 *炫能ID
 */
@property(nonatomic,copy) NSString *roomid;
@end
