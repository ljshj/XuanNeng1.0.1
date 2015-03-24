//
//  TLProductModel.m
//  BGProject
//
//  Created by liao on 14-10-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "TLProductModel.h"

@implementation TLProductModel
-(void)setPrice:(NSString *)price{
    _price = [NSString stringWithFormat:@"¥%@",price];
}
@end
