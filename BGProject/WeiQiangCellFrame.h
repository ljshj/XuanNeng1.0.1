//
//  WeiqiangCellFrame.h
//  BGProject
//
//  Created by ssm on 14-9-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "weiQiangModel.h"

#define kBigFont [UIFont boldSystemFontOfSize:16]
#define kMiddleFont [UIFont systemFontOfSize:14]
#define kSmallFont [UIFont systemFontOfSize:14]

// 定义cell类型
typedef enum {
    CellTypeWeiQiang,
    CellTypeRelated,
}CellType;

@interface WeiQiangCellFrame : NSObject
@property(nonatomic,retain)weiQiangModel* model;

@property(assign,nonatomic)CGRect photoFrame;
@property(assign,nonatomic)CGRect nameFrame;
@property(assign,nonatomic)CGRect distanceTagFrame;
@property(assign,nonatomic)CGRect distanceFrame;
@property(assign,nonatomic)CGRect dateFrame;
@property(assign,nonatomic)CGRect deleteFrame;  //删除按钮


@property(assign,nonatomic)CGRect contentFrame;
@property(assign,nonatomic)CGRect fromContentFrame;
@property(assign,nonatomic)CGRect fromBackViewFrame;
@property(assign,nonatomic)CGRect imageListViewFrame;
@property(assign,nonatomic)CGRect boomBarFrame;

@property(assign,nonatomic)CGRect likeuserViewFrame;
/**
 *评论列表（与我相关）
 */
@property(assign,nonatomic)CGRect commentViewFrame;
@property(nonatomic,assign) CellType cellType;


@property(assign,nonatomic)CGFloat cellHight;


-(id)initWithModel:(weiQiangModel*)model cellType:(CellType)cellType;

@end
