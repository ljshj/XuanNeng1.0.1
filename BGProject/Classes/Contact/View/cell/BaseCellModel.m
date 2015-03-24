//
//  BaseCellData.m
//  BGProject
//
//  Created by ssm on 14-8-14.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "BaseCellModel.h"

@implementation BaseCellModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    
    self = [super init];
    if (self) {
        
        //名称
        self.name = dic[@"name"];
        
        //头像
        self.image = dic[@"photo"];
        
        //简介
        self.detail = dic[@"intro"];
        
        self.hxgroupid = dic[@"hxgroupid"];
        
        self.grouptype = dic[@"grouptype"];
        
        self.membercount = [dic[@"membercount"] intValue];
        
        self.roomid = dic[@"roomid"];
    }
    
    return self;
    
}

@end
