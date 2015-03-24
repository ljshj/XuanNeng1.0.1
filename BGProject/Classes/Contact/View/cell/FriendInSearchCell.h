//
//  FriendInSearchCell.h
//  BGProject
//
//  Created by ssm on 14-9-22.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
// 该页面的cell
// 这个地址只能在我(qq:125960373)电脑上打开。
//

#import <Foundation/Foundation.h>
#import "EGOImageView.h"
#import "FriendInSearchCellFrame.h"

@protocol FriendInSearchCellDelegate <NSObject>

@optional
/**
 *添加按钮回调
 */
-(void)didClickAddButtonWithUsername:(NSString *)username;


@end

@interface FriendInSearchCell : UITableViewCell

@property(weak,nonatomic) id<FriendInSearchCellDelegate>delegate;

@property(nonatomic,retain)FriendInSearchCellFrame* cellFrame;

//距离图标
@property(nonatomic,retain)UIImageView* distanceTag;

//距离标签
@property(nonatomic,retain)UILabel* distanceLabel;

//我能
@property(nonatomic,retain)UILabel* icanLabel;

//头像（这个以后要改，不知道这个类干了啥）
@property(nonatomic,retain)EGOImageView* imgImageView;

//我想
@property(nonatomic,retain)UILabel* ineedLabel;

//等级
@property(nonatomic,retain)UILabel* levelLabel;

//昵称
@property(nonatomic,retain)UILabel* nameLabel;

//性别图标
@property(nonatomic,retain)UIImageView* sexImageView;

//个性签名
@property(nonatomic,retain)UILabel* signatrueLabel;

//添加按钮
@property(nonatomic,strong) UIButton *addButton;

@end
