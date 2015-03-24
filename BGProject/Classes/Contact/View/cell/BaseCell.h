//
//  BaseCell.h
//  BGProject
//
//  Created by ssm on 14-8-14.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

// //  该cell 是联系页面的基础cell。只显示头像 名称， 名称下面的文本

#import <UIKit/UIKit.h>
#import "BaseCellFrame.h"
#import "BGBadgeButton.h"

// 定义是否事通知cell类型
typedef enum {
    CellTypeCommon,
    CellTypeNotification
}CellType;

@protocol TempGroupCellDelegate <NSObject>

@optional

/**
 *加入交流厅按钮被点击
 */
-(void)didClickJoinButtonWithRoomid:(NSString *)roomid userid:(NSString *)userid;

@end

@interface BaseCell : UITableViewCell
//头像
@property(nonatomic,strong)UIImageView *iconView;
/**
 *坐标
 */
@property(nonatomic,strong)BaseCellFrame* cellFrame;
/**
 *Cell类型（普通／申请与通知）
 */
@property (assign,nonatomic) CellType cellType;
/**
 *代理
 */
@property(nonatomic,weak) id<TempGroupCellDelegate>delegate;
/**
 *设置badgeCount
 */
-(void)setupBadgeButtonStausWithBadgeCount:(int)badgeCount;


@end

