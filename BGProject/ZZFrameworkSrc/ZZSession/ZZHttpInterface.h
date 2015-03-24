//
//  ZZHttpInterface.h
//  GIFT
//
//  Created by zhuozhong on 14-3-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZZHttpInterface <NSObject>

@optional

- (void)receiveHttpMessage:(NSData*)data;

// bg 项目的扩展
-(void)receiveHttpMessage:(NSData *)data :(UInt16)messageClass;


-(void)receiveHttpMessage:(NSData *)data
                         :(UInt16)messageClass
                         :(UInt32)messageType;
@end
