//
//  WeiQiangModelAtHome.m
//  BGProject
//
//  Created by ssm on 14-10-7.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.


// 首页搜索的 微墙, 因为会和其他模块的微墙产生混淆，所以有了个后缀

#import "WeiQiangModelAtHome.h"

@implementation WeiQiangModelAtHome



-(void)setIdWithNumber:(NSNumber*)num {
    NSString* idstr = [NSString stringWithFormat:@"%d", [num intValue]];
    _id_ = idstr;
}

-(void)setContent:(NSString *)content {
    _content = [self trimBegints:content];
}


-(NSString*)trimBegints:(NSString*) str {
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return str;
}


-(void)setName:(NSString *)name {
    _name = [NSString stringWithFormat:@"%@",name];
}
@end
