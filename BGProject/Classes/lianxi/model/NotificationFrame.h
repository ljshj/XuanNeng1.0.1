//
//  NotificationFrame.h
//  BGProject
//
//  Created by liao on 14-12-27.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationModel.h"

#define NameFont [UIFont systemFontOfSize:14.0]
#define MessageFont [UIFont systemFontOfSize:13.0]

//定义模型的类型(好友请求／群请求)
typedef enum {
    NotificationFrameTypeNomal,//这个是默认的，没啥用
    NotificationFrameTypeFriend,
    NotificationFrameTypeGroup
}NotificationFrameType;

@interface NotificationFrame : NSObject
/**
 *定义模型的类型(好友请求／群请求)
 */
@property(nonatomic,assign) NotificationFrameType notificationFrameType;
/**
 *通知模型
 */
@property(strong,nonatomic) NotificationModel *model;
/**
 *头像
 */
@property(nonatomic,assign) CGRect IconFrame;
/**
 *昵称
 */
@property(nonatomic,assign) CGRect nameFrame;
/**
 *消息
 */
@property(nonatomic,assign) CGRect messageFrame;
/**
 *cell高度
 */
@property(nonatomic,assign) CGFloat cellHeight;

-(instancetype)initWithNotificationModel:(NotificationModel *)model;

@end
