//
//  BGWQCommentModel.h
//  BGProject
//
//  Created by liao on 14-11-4.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGWQCommentModel : NSObject

@property(nonatomic,copy)NSString* content;//评论内容
@property(nonatomic,copy)NSString* name;//用户名
@property(nonatomic,copy)NSString* userid;//用户id
@property(nonatomic,copy)NSString* commenttime;//用户名
@property(nonatomic,copy)NSString* photo;//用户头像
@property(nonatomic,copy)NSString* weiboid;//微博ID
@property(nonatomic,copy)NSString* commentid;//微博ID
//将字典转化成模型
+(instancetype)commentWithDic:(NSDictionary *)dic;

@end
