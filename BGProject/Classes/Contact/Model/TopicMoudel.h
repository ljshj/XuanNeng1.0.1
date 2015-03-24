//
//  TopicMoudel.h
//  BGProject
//
//  Created by ssm on 14-9-17.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TopicMoudel : NSObject


@property(nonatomic,assign)int jokeid;
@property(nonatomic,assign)int userid;
@property(nonatomic,copy)NSString* username;

@property(nonatomic,copy)NSString* photoURL;
@property(nonatomic,copy)NSString* distance;
@property(nonatomic,copy)NSString* dateTime;

@property(nonatomic,copy)NSString* content;
@property(nonatomic,copy)NSString* imgThumURL;
@property(nonatomic,copy)NSString* imgURL;

@property(nonatomic,assign)int likeCount;
@property(nonatomic,assign)int commentCount;
@property(nonatomic,assign)int forwardCount;

@property(nonatomic,assign)int shareCount;


-(id)initWithDic:(NSDictionary*)dic;


@end
