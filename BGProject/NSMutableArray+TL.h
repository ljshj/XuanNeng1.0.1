//
//  NSMutableArray+TL.h
//  BGProject
//
//  Created by liao on 14-10-27.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (TL)
+(NSMutableArray *)arrayWithResourceArray:(NSArray *)resourceArray originalArray:(NSMutableArray *)memberArray selectIndex:(int)selectIndex;
@end
