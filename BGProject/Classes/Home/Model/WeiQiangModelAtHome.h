//
//  WeiQiangModelAtHome.h
//  BGProject
//
//  Created by ssm on 14-10-7.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
// 首页搜索的 微墙, 因为会和其他模块的微墙产生混淆，所以有了个后缀


#import <Foundation/Foundation.h>

@interface WeiQiangModelAtHome : NSObject

@property(nonatomic,copy)NSString* id_;
@property(nonatomic,copy)NSString* name;
@property(nonatomic,copy)NSString* img;
@property(nonatomic,copy)NSString* img_thum;
@property(nonatomic,copy)NSString* content;
@property(nonatomic,copy)NSString* comments;

-(void)setIdWithNumber:(NSNumber*)num;
@end
