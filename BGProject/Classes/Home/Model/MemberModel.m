//
//  MemberModel.m
//  BGProject
//
//  Created by ssm on 14-9-9.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "MemberModel.h"

@implementation MemberModel


-(id)initWithDic:(NSDictionary*)dic {
    if (self = [self init]) {
        
        
        
    }
    return self;
}

-(NSString *)signature{
    
    return [NSString stringWithFormat:@"个性签名：%@",_signature];
    
}

-(NSString *)ineed{
    
    return [NSString stringWithFormat:@"我想：%@",_ineed];
    
}
-(NSString *)ican{
    
    return [NSString stringWithFormat:@"我能：%@",_ican];
    
}
@end
