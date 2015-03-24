//
//  NotificationModel.h
//  BGProject
//
//  Created by liao on 14-12-27.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationModel : NSObject
/**
 *用户ID
 */
@property(nonatomic,copy)NSString *userid;
/**
 *用户名
 */
@property(nonatomic,copy)NSString *name;
/**
 *用户头像
 */
@property(nonatomic,copy)NSString *image;
/**
 *邀请信息
 */
@property(nonatomic,copy)NSString *message;
/**
 *签名
 */
@property(nonatomic,copy)NSString *detail;

//################群申请模型才赋值以下属性##################
/**
 *群名
 */
@property(nonatomic,copy) NSString *groupname;
/**
 *环信群ID
 */
@property(nonatomic,copy) NSString *hxgroupid;

//将字典转化成模型
+(instancetype)NotificationWithDic:(NSDictionary *)dic;

@end
