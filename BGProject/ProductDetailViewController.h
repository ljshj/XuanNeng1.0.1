//
//  ProductDetailViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-10-14.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
#import "RecomProductModel.h"

// 定义评论类型
typedef enum {
    ProductTypeAll,
    ProductTypeRecomment,
}ProductType;

@interface ProductDetailViewController : UIViewController


@property(nonatomic,retain)ProductModel* model;
@property(nonatomic,retain) RecomProductModel* reModel;
/**
 *  产品类型
 */
@property (assign,nonatomic) ProductType productType;
/**
 *用户ID
 */
@property(nonatomic,copy) NSString *userid;
@end
