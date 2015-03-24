//
//  XuanNengPaiHangBangCellFrame.h
//  BGProject
//
//  Created by ssm on 14-9-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JokeModel.h"

#define kBigFont [UIFont systemFontOfSize:16]
#define kMiddleFont [UIFont systemFontOfSize:14]
#define kSmallFont [UIFont systemFontOfSize:14]
#define CellMargin 8

// 定义cell类型
typedef enum {
    CellTypeXuanNeng,
    CellTypeRelated,
}CellType;

@interface XuanNengPaiHangBangCellFrame : NSObject

@property(retain,nonatomic)JokeModel* model;

@property(assign,nonatomic)CGRect photoFrame;//图片

@property(assign,nonatomic)CGRect rankDateFrame;//获奖日期

@property(assign,nonatomic)CGRect nameFrame;//昵称

@property(assign,nonatomic)CGRect distanceTagFrame;//距离图标

@property(assign,nonatomic)CGRect distanceFrame;//距离

@property(assign,nonatomic)CGRect dateFrame;//创建日期

@property(assign,nonatomic)CGRect contentFrame;//内容

@property(assign,nonatomic)CGRect imageListViewFrame;//图片列表

@property(assign,nonatomic)CGRect boomBarFrame;//工具条

@property(assign,nonatomic)CGFloat cellHight;//cell的高度

@property(nonatomic,assign)BOOL needHideBottomBar;//如果是未审核的就需要隐藏操作条
/**
 *点赞frame
 */
@property(assign,nonatomic)CGRect likeuserViewFrame;
/**
 *评论列表（与我相关）
 */
@property(assign,nonatomic)CGRect commentViewFrame;
/**
 *cell的类型
 */
@property(nonatomic,assign) CellType cellType;
/**
 *转换成frame
 */
-(id)initWithModel:(JokeModel *)model cellType:(CellType)cellType;

@end
