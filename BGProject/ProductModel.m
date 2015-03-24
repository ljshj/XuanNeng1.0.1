//
//  ProductModel.m
//  BGProject
//
//  Created by zhuozhong on 14-10-10.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ProductModel.h"
#import "FDSPublicManage.h"

@implementation ProductModel

-(id)initWithDic:(NSDictionary*)dic
{
    if(self = [super init])
    {
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self setValue:obj forKey:key];
        }];
        

        _date_timeStr = [[FDSPublicManage sharePublicManager]transformDate:_date_time];
        
        _priceStr = [NSString stringWithFormat: @"￥%@", [_price stringValue]];
        
        _product_id_int = [_product_id intValue];
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"productModel  id:%@",self.product_id];
}


-(void)setPrice:(NSNumber *)price
{
    _price = price;
     _priceStr = [NSString stringWithFormat: @"￥%@", [_price stringValue]];
    
}

@end
