//
//  RecomProductModel.h
//  BGProject
//
//  Created by liao on 14-11-19.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecomProductModel : NSObject

@property(nonatomic,copy)NSString* date_time;
@property(nonatomic,copy)NSString* intro;
@property(nonatomic,copy)NSString* price;
@property(nonatomic,strong)NSNumber* product_id;
@property(nonatomic,copy)NSString* img;
@property(nonatomic,copy)NSString* img_thum;
@property(nonatomic,copy)NSString* product_name;
-(instancetype)initWithDict:(NSDictionary *)dic;

@end
