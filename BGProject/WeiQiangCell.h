//
//  WeiQiangCell.h
//  BGProject
//
//  Created by ssm on 14-9-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiQiangCellFrame.h"

@class WeiQiangCell;

// 删除微博的协议
@protocol WeiQiangCellDelegate <NSObject>

-(void)WeiQiangCellDelete:(WeiQiangCell*)cell;
-(void)WeiQiangCell:(WeiQiangCell *)cell didSelectedButtonIndex:(NSInteger)index;
/**
 *头像被点击
 */
-(void)persontap:(NSString *)userid;

@end

@interface WeiQiangCell : UITableViewCell

@property(nonatomic,assign)BOOL needHideDeleteButton; // 是否需要
@property(nonatomic,weak) id<WeiQiangCellDelegate> delegate;
@property(nonatomic,retain)WeiQiangCellFrame* cellFrame;
@property(nonatomic,strong) NSArray *commentlist;

@end
