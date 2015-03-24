//
//  ZZUserDefaults.m
//  FDS
//
//  Created by zhuozhong on 14-1-22.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//
#import "ZZUserDefaults.h"

@implementation ZZUserDefaults

+(NSString*)getUserDefault:(NSString*)key{
    if(nil == key)
        return nil;
    NSUserDefaults *defalult = [NSUserDefaults standardUserDefaults];
    NSString *result = nil;
    result = [defalult objectForKey:key];
    return result;

}

+(void)setUserDefault:(NSString*)key : (NSString*)value
{
    NSUserDefaults *defalult = [NSUserDefaults standardUserDefaults];
    [defalult setValue:value forKey:key];
    [defalult synchronize];
}

+(void)setDefaultWithObject:(id)object forkey:(NSString *)key{
    
    //取出NSUserDefaults对象
    NSUserDefaults *defalult = [NSUserDefaults standardUserDefaults];
    
    //存储对象
    [defalult setObject:object forKey:key];
    
    //同步？不知道啥玩意？
    [defalult synchronize];
}

+(id)getDefault:(NSString*)key{
    
    //如果为空，啥也不返回
    if(key == nil){
        
        return nil;
        
    }
    
    //取出NSUserDefaults
    NSUserDefaults *defalult = [NSUserDefaults standardUserDefaults];
    //返回
    return [defalult objectForKey:key];
;
    
}

@end
