//
//  likeUser.m
//  BGProject
//
//  Created by liao on 14-12-5.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "LikeUser.h"

@implementation LikeUser

+(instancetype)likeUserWithDic:(NSDictionary *)dic{
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
