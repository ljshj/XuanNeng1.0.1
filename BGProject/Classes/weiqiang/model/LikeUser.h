//
//  likeUser.h
//  BGProject
//
//  Created by liao on 14-12-5.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

@interface LikeUser : NSObject

@property(nonatomic,retain)NSString* nicename;//昵称
@property(nonatomic,retain)NSString* userid;//用户id

//将字典转化成模型
+(instancetype)likeUserWithDic:(NSDictionary *)dic;

@end
