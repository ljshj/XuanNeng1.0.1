//
//  MemberModel.h
//  BGProject
//
//  Created by ssm on 14-9-9.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
// 首页 搜索接到的member 字段
@interface MemberModel : NSObject

/*
 <member>
 <userid/>
 <img/>// 头像
 <name/>//昵称
 <sex/>//性别
 <level/>//会员级别
 <distance/>//距离
 <signatrue/>//签名
 <ican/>//我能
 <ineed/>//我需
 </member>
 */
@property(nonatomic,copy)NSNumber* userid;
@property(nonatomic,copy)NSNumber* status;
@property(nonatomic,copy)NSNumber* banggunum;
@property(nonatomic,copy)NSString* photo;
@property(nonatomic,copy)NSString* name;
@property(nonatomic,copy)NSNumber* sex;
@property(nonatomic,copy)NSNumber* level;
@property(nonatomic,copy)NSNumber* distance;
@property(nonatomic,copy)NSString* signature;
@property(nonatomic,copy)NSString* ican;
@property(nonatomic,copy)NSString* ineed;
@property(nonatomic,copy)NSNumber* searchtype;
@property(nonatomic,copy)NSNumber* guanzhutype;
@property(nonatomic,copy)NSNumber* phonenum;
-(id)initWithDic:(NSDictionary*)dic;

@end
