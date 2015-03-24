//
//  AppModel.h
//  BGProject
//
//  Created by ssm on 14-9-16.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
//首页搜索 接受到的apps 字段
@interface AppModel : NSObject
@property(nonatomic,assign)NSInteger appID;
@property(nonatomic, copy)NSString* title;
@property(nonatomic,copy)NSString* size;
@property(nonatomic,copy)NSString* intro;
@end
