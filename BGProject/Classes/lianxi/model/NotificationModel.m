//
//  NotificationModel.m
//  BGProject
//
//  Created by liao on 14-12-27.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "NotificationModel.h"

@implementation NotificationModel

+(instancetype)NotificationWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithDict:dic];
}

-(instancetype)initWithDict:(NSDictionary *)dic{
    if (self = [super init]) {
        //KVC
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

@end
