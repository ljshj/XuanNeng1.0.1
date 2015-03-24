//
//  FriendCellModel.m
//  BGProject
//
//  Created by ssm on 14-8-19.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FriendCellModel.h"

@implementation FriendCellModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    
    self = [super init];
    if (self) {
    
        self.name = dic[@"name"];
        self.image = dic[@"photo"];
        
        //卧槽，回来的数据英文都写错了
        self.detail = dic[@"signature"];
        
        self.userid = [NSString stringWithFormat:@"%d",[dic[@"userid"] intValue]];
        
        //添加这个属性应该不会影响到好友那里吧
        self.type = [dic[@"type"] intValue];
        
        //0 女 1 男 2 保密
        int sex = [dic[@"sex"] intValue];
        if (sex==0) {
            
            self.isGirl = YES;
            
        }else{
            
            self.isGirl = NO;
            
        }
        
        
    }
    return self;
    
}

@end
