//
//  FriendCell.h
//  BGProject
//
//  Created by ssm on 14-8-19.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//  这个是显示已经添加的好友的单元格。显示的页面在 单击最下面的"联系"然后显示好友
//  


#import "BaseCell.h"
#import "FriendCellFrame.h"
#import "FriendCellModel.h"

@protocol FriendCellDelegate <NSObject>

@optional

/**
 *删除好友回调
 */
-(void)deleteGoodFriendWithUserid:(NSString *)userid;
/**
 *点击头像
 */
-(void)friendPersontap:(NSString *)userid;

@end

@interface FriendCell : BaseCell

@property(nonatomic,weak) id<FriendCellDelegate>delegate;

@end
