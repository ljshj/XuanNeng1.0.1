//
//  NameCardModel.h
//  BGProject
//
//  Created by ssm on 14-9-23.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendModel.h"

@interface NameCardModel : NSObject

@property(nonatomic,copy)NSString* Userid;
@property(nonatomic,copy)NSString* distance;
@property(nonatomic,copy)NSString* img;
@property(nonatomic,copy)NSString* ineed;
@property(nonatomic,copy)NSString* ican;
@property(nonatomic,copy)NSString* level;
@property(nonatomic,copy)NSString* name;
@property(nonatomic,copy)NSString* sex;
@property(nonatomic,copy)NSString* signatrue;

-(id)initWithDic:(NSDictionary*) dic;

-(id)initWithFirend:(FriendModel*)model;
@end
