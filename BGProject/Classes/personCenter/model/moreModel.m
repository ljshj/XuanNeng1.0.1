//
//  moreModel.m
//  BGProject
//
//  Created by liao on 14-11-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "moreModel.h"

@implementation moreModel
-(instancetype)initWithDict:(NSDictionary *)dic{
    if (self = [super init]) {
        //KVC
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
@end
