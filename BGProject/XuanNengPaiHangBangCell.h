//
//  XuanNengPaiHangBangCell.h
//  BGProject
//
//  Created by ssm on 14-9-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XuanNengPaiHangBangCellFrame.h"
@class XuanNengPaiHangBangCell;

@protocol XuanNengPaiHangBangCellDelegate <NSObject>

@optional
-(void)XuanNengPaiHangBangCell:(XuanNengPaiHangBangCell*)cell
         didClickButtonAtIndex:(NSInteger)index;
-(void)SubmittedTopicCellDelete:(XuanNengPaiHangBangCell*) cell;
-(void)xuanNengPersontap:(NSString *)userid;
@end



@interface XuanNengPaiHangBangCell : UITableViewCell

@property(nonatomic,retain)XuanNengPaiHangBangCellFrame* cellFrame;
@property(weak, nonatomic)id<XuanNengPaiHangBangCellDelegate> delegate;
@property(nonatomic,assign)BOOL needHideDeleteButton; // 是否需要
/**
 *与我相关评论数据
 */
@property(nonatomic,strong) NSArray *commentlist;
@end
