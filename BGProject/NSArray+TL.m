//
//  NSArray+TL.m
//  BGProject
//
//  Created by liao on 14-10-27.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "NSArray+TL.h"

@implementation NSArray (TL)
+(NSArray *)arrayWithFileName:(NSString *)fileName{
    // 1.获得plist的全路径
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    // 2.加载数组
    NSArray *rawArr = [NSArray arrayWithContentsOfFile:path];
    return rawArr;
}
@end
