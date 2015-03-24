//
//  JokeDetailModel.h
//  BGProject
//
//  Created by zhuozhong on 14-10-15.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.

//  显示炫能详情的数据模型

#import <Foundation/Foundation.h>

@interface JokeDetailModel : NSObject

@property(nonatomic, retain)NSNumber* comment_count;
@property(nonatomic, retain)NSMutableArray* comments;//用户评论信息
@property(nonatomic, retain)NSString* content;

@property(nonatomic, retain)NSDate* date_time;
@property(nonatomic, retain)NSNumber* forward_count;

@property(nonatomic, retain)NSArray* imgs;
@property(nonatomic, retain)NSNumber* like_count;

@property(nonatomic, retain)NSNumber* share_count;
@property(nonatomic, retain)NSNumber* xnid;


-(id)initWithDic:(NSDictionary*)dic;
@end
