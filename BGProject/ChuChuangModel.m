//
//  ChuChuangModel.m
//  BGProject
//
//  Created by zhuozhong on 14-10-10.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ChuChuangModel.h"
#import "RecomProductModel.h"

@implementation ChuChuangModel


//kvo
-(id)initWithDic:(NSDictionary*)dic
{
    if(self = [super init])
    {
        
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self setValue:obj forKey:key];
        }];
    }
    return self;
}



-(void)setRecommend_list:(NSArray *)recommend_list
{
    
    //先初始化产品推荐数组
    _recommend_list = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *dic in recommend_list) {
        
        //字典转换成模型
        RecomProductModel *model = [[RecomProductModel alloc] initWithDict:dic];
        
        //将模型加进数组里面去
        [_recommend_list addObject:model];
        
    }
    
    NSLog(@"初始化 list.以后补上.");
}


// for debug
-(NSString *)description
{
    NSString* str = [NSString stringWithFormat:@"userid-%@  shop_name:%@",_userid,_shop_name];
    return str;
}

-(void)setShop_name:(NSString *)shop_name
{
    if([shop_name length] == 0)
    {
        _shop_name = @"商店名称";
    }
}
@end
