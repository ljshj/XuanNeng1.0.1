//
//  weiQiangModel.h
//  BGProject
//
//  Created by zhuozhong on 14-7-24.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface weiQiangModel : NSObject

@property(nonatomic,retain)NSString* weiboid;//微博id
@property(nonatomic,retain)NSString* fromname;//被转发微墙用户名
@property(nonatomic,retain)NSString* fromuserid;//用户id
@property(nonatomic,retain)NSString* userid;//用户id
@property(nonatomic,retain)NSString* name;//用户名

@property(nonatomic,retain)NSString* photo;//头像or图片？？
@property(nonatomic,retain)NSNumber *distance;//距离
@property(nonatomic,retain)NSString* date_time;//发表时间
@property(nonatomic,retain)NSString* content;//内容

@property(nonatomic,retain)NSString* like_count;//点赞数
@property(nonatomic,retain)NSString* comment_count;//评论数
@property(nonatomic,retain)NSString* forward_count;//转发数
@property(nonatomic,retain)NSString* share_count;//分享数

@property(nonatomic,retain)NSString* comments;//转发评论

@property(nonatomic,retain) NSArray *imgs;

@property(nonatomic,assign) BOOL isSearchWeiQiang;


-(id)initWithDic:(NSDictionary*)dic;


@end
