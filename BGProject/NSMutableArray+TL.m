//
//  NSMutableArray+TL.m
//  BGProject
//
//  Created by liao on 14-10-27.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "NSMutableArray+TL.h"
#import "MemberModel.h"
#import "WeiQiangModelAtHome.h"
#import "TLProductModel.h"

@implementation NSMutableArray (TL)
+(NSMutableArray *)arrayWithResourceArray:(NSArray *)resourceArray originalArray:(NSMutableArray *)originalArray selectIndex:(int)selectIndex{
    
    
    [resourceArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (selectIndex == 0) {
            MemberModel  *model = [[MemberModel alloc]init];
            [obj enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [model  setValue:obj forKey:key];
            }];
            [originalArray addObject:model];
        }else if(selectIndex == 2){
            WeiQiangModelAtHome *model = [[WeiQiangModelAtHome alloc]init];
            [obj enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [model  setValue:obj forKey:key];
            }];
            [originalArray addObject:model];
        }else if(selectIndex == 3){
            TLProductModel *model = [[TLProductModel alloc]init];
            [obj enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [model  setValue:obj forKey:key];
            }];
            [originalArray addObject:model];
        }
        
    }];
    return originalArray;
}
@end
