//
//  BaseCellFrame.h
//  BGProject
//
//  Created by ssm on 14-8-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCellModel.h"




#define kIconSize     CGSizeMake(60, 60)
#define kIconXY       CGPointMake(20,10)
#define kIconHolderName @"6"


#define kNameFont   [UIFont systemFontOfSize:16]
#define kDetailFont [UIFont systemFontOfSize:12]

// 水平标准间距
#define kSpaceH 2
// 垂直标准间距
#define kSpaceV 4

// 定义评论类型
typedef enum {
    CellFrameTypeCommon,
    CellFrameTypeNotification,
    CellFrameTypeJoinJTempGroup,//不让那个加入按钮显示出来，这里不是加入交流厅列表
    CellFrameTypeGroup
}CellFrameType;

@interface BaseCellFrame : NSObject

/**
 *CellFrame类型（普通／申请与通知/加入交流厅／群）
 */
@property (assign,nonatomic) CellFrameType cellFrameType;

//头像
@property(nonatomic,assign) CGRect iconFrame;

//昵称
@property(nonatomic,assign) CGRect nameFrame;

//文本
@property(nonatomic,assign) CGRect detailFrame;


@property(nonatomic,assign) CGFloat cellHeight;
// 通过model的数据来计算上面各个frame的值
@property(nonatomic,retain) BaseCellModel* model;

@end

