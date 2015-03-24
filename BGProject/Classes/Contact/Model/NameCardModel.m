//
//  NameCardModel.m
//  BGProject
//
//  Created by ssm on 14-9-23.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "NameCardModel.h"

@implementation NameCardModel



-(id)initWithDic:(NSDictionary *)dic {
    if(self=[super init]) {
        int useridInt = [dic[@"Userid"] intValue];
        self.Userid = [NSString stringWithFormat:@"%d", useridInt];
        int distanceInt =[dic[@"distance"] intValue];
        self.distance = [NSString stringWithFormat:@"%dKM",distanceInt];
        
        self.ican = [NSString stringWithFormat:@"我能:%@",dic[@"ican"]];
        self.ineed =  [NSString stringWithFormat:@"我需:%@",dic[@"ineed"]];
        self.img = dic[@"img"];
        int levelInt = [dic[@"level"]intValue];
        
        self.level = [NSString stringWithFormat:@"VIP%d",levelInt];
        self.name = dic[@"name"];
        self.sex = dic[@"sex"];
        self.signatrue = [NSString stringWithFormat:@"个性签名:%@",dic[@"signatrue"]];
    }
    return self;
}


-(id)initWithFirend:(FriendModel*)model {
    
    if(self =[super init]) {
        self.Userid = model.Userid;
        self.distance = model.distance;
        self.img = model.img;
        self.ineed = model.ineed;
        self.ican = model.ican;
        self.level = model.level;
        self.name = model.name;
        self.sex = model.sex;//0:女 1: 男  else 保密
        self.signatrue = model.signature;
    }
    return self;
}
@end
