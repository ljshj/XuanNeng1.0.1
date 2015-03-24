//
//  FriendModel.h
//  BGProject
//
//  Created by ssm on 14-9-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//
// 用户搜索好友，获取的实体类
#import <Foundation/Foundation.h>


@interface FriendModel : NSObject
@property(nonatomic,copy)NSString* Userid;
@property(nonatomic,copy)NSString* distance;
@property(nonatomic,copy)NSString* img;
@property(nonatomic,copy)NSString* ineed;
@property(nonatomic,copy)NSString* ican;
@property(nonatomic,copy)NSString* level;
@property(nonatomic,copy)NSString* name;
@property(nonatomic,copy)NSString* sex;
@property(nonatomic,copy)NSString* signature;

//1 表示 相关关注
//@property(nonatomic,assign)int isAttentionToEach;
//1 表示 相关关注
@property(nonatomic,assign)int  guanzhutype;
@property(nonatomic,assign)int  searchtype;
@property(nonatomic,assign)bool isSelected; // 我的粉丝页面中 记录关注按钮的状态。

-(id)initWithDic:(NSDictionary*) dic;


@end
