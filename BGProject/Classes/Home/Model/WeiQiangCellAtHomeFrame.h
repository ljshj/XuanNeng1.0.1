//
//  WeiQiangModelAtHomeFrame.h
//  BGProject
//
//  Created by ssm on 14-10-8.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGOImageView.h"
#import "WeiQiangModelAtHome.h"
#import "weiQiangModel.h"

#define kContentFont [UIFont systemFontOfSize:14]
#define kNameFont [UIFont systemFontOfSize:11]

@interface WeiQiangCellAtHomeFrame : NSObject


@property(nonatomic,retain)weiQiangModel* model;

//用户头像
@property(nonatomic,assign)CGRect imgFrame;//头像
@property(nonatomic,assign)CGRect nameFrame;//名字
@property(nonatomic,assign)CGRect contentFrame;//正文
@property(nonatomic,assign)CGRect dashFrame;//正文
@property(nonatomic,assign)CGFloat cellHeight;

@end
