//
//  NSMutableDictionary+Zhangxx.m
//  BGProject
//
//  Created by ssm on 14-9-4.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "NSMutableDictionary+Zhangxx.h"

@implementation NSMutableDictionary (Zhangxx)

- (void)setInt:(int)aInt forKey:(id <NSCopying>)aKey {
    NSNumber* aValue = [NSNumber numberWithInt:aInt];
    [self setObject:aValue forKey:aKey];
}


- (void)setFloat:(float)aFloat forKey:(id <NSCopying>)aKey {
    NSNumber* aValue = [NSNumber numberWithFloat:aFloat];
    [self setObject:aValue forKey:aKey];
}

-(void)setDouble:(double)aDouble forkey:(id<NSCopying>)aKey
{
    NSNumber* aValue = [NSNumber numberWithDouble:aDouble];
    [self setObject:aValue forKey:aKey];
}

@end
