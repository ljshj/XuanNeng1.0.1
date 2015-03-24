//
//  ProductCellFrame.h
//  BGProject
//
//  Created by zhuozhong on 14-10-10.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductModel.h"



// 介绍字体
#define kIntroFont [UIFont systemFontOfSize:16]
//价格字体
#define kPriceFont [UIFont systemFontOfSize:14]



@interface ProductCellFrame : NSObject


@property(retain,nonatomic)ProductModel* model;

@property(assign,nonatomic)CGRect photoFrame;
@property(assign,nonatomic)CGRect introFrame;
@property(assign,nonatomic)CGRect priceFrame;

@property(assign,nonatomic)CGRect nameFrame;
@property(assign,nonatomic)CGFloat cellHight;


@end
