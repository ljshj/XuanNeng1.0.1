//
//  AD_ATHumorModel.h
//  BGProject
//
//  Created by ssm on 14-9-16.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//
// 幽默界面的广告实体类
#import <Foundation/Foundation.h>



@interface AD_ATHumorModel : NSObject

@property(nonatomic,assign)int adid;
@property(nonatomic,assign)int adType;

@property(nonatomic,copy)NSString* adContent;
@property(nonatomic,copy)NSString* imageURL;
@property(nonatomic, copy)NSString* imageThumURL;
-(id)initWithDic:(NSDictionary*)dic;
@end
