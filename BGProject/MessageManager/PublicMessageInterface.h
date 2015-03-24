//
//  PublicMessageInterface.h
//  BGProject
//
//  Created by zhuozhongkeji on 14-9-16.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PublicMessageInterface <NSObject>


@optional

// 检测版本更新的版本号
-(void)checkLastVersionCB:(NSDictionary*)dic;

@end
