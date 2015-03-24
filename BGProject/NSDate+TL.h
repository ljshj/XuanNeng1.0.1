//
//  NSDate+TL.h
//  BGProject
//
//  Created by liao on 14-11-3.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TL)
-(BOOL)isToday;
- (BOOL)isYesterday;
- (BOOL)isTheDayBeforeYesterday;
- (BOOL)isThisMonth;
- (BOOL)isThisYear;
+(NSDate*)zoneChange:(NSString*)second;

@end
