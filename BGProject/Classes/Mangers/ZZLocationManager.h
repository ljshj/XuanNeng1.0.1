//
//  ZZLocationManager.h
//  BGProject
//
//  Created by ssm on 14-9-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZZLocationManager : NSObject

/* 返回的值 NString:NSNumber
 @{
    @"longitude":longitude,//经度
    @"latitude":latitude   //纬度
  };
 */
+(NSDictionary*)location;
@end
