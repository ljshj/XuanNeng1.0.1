//
//  UserStoreMessageInterface.h
//  BGProject
//
//  Created by zhuozhongkeji on 14-9-16.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChuChuangModel.h"
#import "ProductModel.h"

@protocol UserStoreMessageInterface <NSObject>

@optional
//30003 830003 添加商品
-(void)addProductCB:(int)isSuccess;


//30008 830008 获取商品列表
-(void)requestProductListCB:(NSMutableArray*)productArr;


//30005 删除商品 的回调
-(void)requestDeleteProductCB:(int)returnCode;

//30004 修改商品
-(void)updateProductCB:(int)returnCode;

//请求橱窗信息
-(void)request30001CB:(ChuChuangModel*)model;

// 查找商品
-(void)request30006CB:(NSArray*)models;


// 商品详情
-(void)request30007CB:(NSDictionary *)data;

//评论商品回调
-(void)submitProductCommentCB:(int)returnCode;

//请求商品评论回调
-(void)requestProductCommentsCB:(NSArray *)data;

@end
