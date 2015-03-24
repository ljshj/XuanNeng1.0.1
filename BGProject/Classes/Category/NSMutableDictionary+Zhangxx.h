//
//  NSMutableDictionary+Zhangxx.h
//  BGProject
//
//  Created by ssm on 14-9-4.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Zhangxx)

- (void)setInt:(int)aInt forKey:(id <NSCopying>)aKey;

- (void)setFloat:(float)aFloat forKey:(id <NSCopying>)aKey;

-(void)setDouble:(double)aDouble forkey:(id<NSCopying>)aKey;
@end
