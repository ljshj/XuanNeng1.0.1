//
//  ChuChuangModel.h
//  BGProject
//
//  Created by zhuozhong on 14-10-10.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChuChuangModel : NSObject


@property(nonatomic,retain)NSNumber* credit;
@property(nonatomic,retain)NSString* good_comments;

@property(nonatomic,retain)NSString* logo;
@property(nonatomic,retain)NSNumber* product_count;
@property(nonatomic,retain)NSMutableArray* recommend_list;

@property(nonatomic,retain)NSString* shop_name;
@property(nonatomic,retain)NSNumber* userid;

-(id)initWithDic:(NSDictionary*)dic;


//credit = 0;
//"good_comments" = 0;
//logo = "http://114.215.189.189:80/Files/9/userinfo/89d535e4-4016-4579-85eb-aca80db390c3.png";
//"product_count" = 0;
//"recommend_list" =     (
//);
//"shop_name" = "";
//userid = 9;
@end
