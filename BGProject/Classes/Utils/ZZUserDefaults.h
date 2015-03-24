//
//  ZZUserDefaults.h
//  FDS
//
//  Created by zhuozhong on 14-1-22.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//  这是存储用户账号密码的类

#import <Foundation/Foundation.h>

#define JokeidKey @"jokeid"
#define LatitudeKey @"latitude"
#define LongitudeKey @"longitude"


@interface ZZUserDefaults : NSObject

+(NSString*)getUserDefault:(NSString*)key;
+(void)setUserDefault:(NSString*)key : (NSString*)value;

//###############集成环信后写的接口###################

//存储
+(void)setDefaultWithObject:(id)object forkey:(NSString *)key;

//获取
+(id)getDefault:(NSString*)key;

@end
