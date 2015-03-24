//
//  moreModel.h
//  BGProject
//
//  Created by liao on 14-11-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface moreModel : NSObject

@property(nonatomic,copy) NSString *icon;
@property(nonatomic,copy) NSString *title;
-(instancetype)initWithDict:(NSDictionary *)dic;
@end
