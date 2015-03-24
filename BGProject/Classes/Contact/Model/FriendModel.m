//
//  FriendModel.m
//  BGProject
//
//  Created by ssm on 14-9-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//
// 用户搜索好友，获取的实体类
#import "FriendModel.h"

@implementation FriendModel

-(id)initWithDic:(NSDictionary *)dic {
    if(self=[super init]) {
        int useridInt = [dic[@"userid"] intValue];
        self.Userid = [NSString stringWithFormat:@"%d", useridInt];
        int distanceInt =[dic[@"distance"] intValue];
        self.distance = [NSString stringWithFormat:@"%dKM",distanceInt];
        
        self.ican = [NSString stringWithFormat:@"我能:%@",dic[@"ican"]];
        self.ineed =  [NSString stringWithFormat:@"我需:%@",dic[@"ineed"]];
        self.img = dic[@"photo"];
        int levelInt = [dic[@"level"]intValue];
        
        self.level = [NSString stringWithFormat:@"VIP%d",levelInt];
        self.name = dic[@"name"];
        self.sex = dic[@"sex"];
        self.signature = [NSString stringWithFormat:@"个性签名:%@",dic[@"signature"]];
        self.guanzhutype = [dic[@"guanzhutype"] integerValue];
        
      //  self.isAttentionToEach = [dic[@"searchtype"] integerValue];
        self.searchtype = [dic[@"searchtype"] integerValue];
        
        
    }
    return self;
}
@end
