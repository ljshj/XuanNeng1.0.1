//
//  NotificationCell.h
//  BGProject
//
//  Created by liao on 14-12-27.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationFrame.h"
#define AgreeButtonBg [UIColor colorWithRed:88/255.0 green:178/255.0 blue:92/255.0 alpha:1.0]
#define RejectButtonBg [UIColor colorWithRed:235/255.0 green:81/255.0 blue:84/255.0 alpha:1.0]

@protocol NotificationCellDelegate <NSObject>

@optional

/**
 *接受按钮被点击(群请求)
 */
-(void)didClickAgreeButtonWithUserid:(NSString *)userid hxgroupid:(NSString *)hxgroupid;
/**
 *拒绝按钮被点击(群请求)
 */
-(void)didClickRejectButtonWithUserid:(NSString *)userid hxgroupid:(NSString *)hxgroupid;
/**
 *接受按钮被点击(好友请求)
 */
-(void)didClickAgreeButtonWithUserid:(NSString *)userid;
/**
 *拒绝按钮被点击
 */
-(void)didClickRejectButtonWithUserid:(NSString *)userid;

@end

@interface NotificationCell : UITableViewCell
/**
 *定义模型的类型(好友请求／群请求)
 */
@property(nonatomic,assign) NotificationFrameType notificationFrameType;
/**
 *NotificationFrame
 */
@property(nonatomic,assign) NotificationFrame *cellFrame;
/**
 *代理
 */
@property(weak,nonatomic) id<NotificationCellDelegate>delegate;

@end
