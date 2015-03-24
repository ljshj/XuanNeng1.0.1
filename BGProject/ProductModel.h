//
//  ProductModel.h
//  BGProject
//
//  Created by zhuozhong on 14-10-10.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject

@property(nonatomic,retain)NSString* date_time;
@property(nonatomic,copy)NSString* img;
@property(nonatomic,copy)NSString* img_thum;
@property(nonatomic,copy)NSString* intro;
@property(nonatomic,retain)NSNumber* price;
@property(nonatomic, assign)NSNumber* product_id;
@property(nonatomic,copy)NSString* product_name;
@property(nonatomic,copy)NSString* userid;
//推荐
@property(nonatomic,retain)NSNumber* brecom;

@property(nonatomic,copy)NSString* date_timeStr;
@property(nonatomic,copy)NSString* priceStr;

@property(nonatomic,assign)int product_id_int;
-(id)initWithDic:(NSDictionary*)dic;
@end
