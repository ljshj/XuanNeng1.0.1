//
//  Cell.h
//  UICollectionView
//
//  Created by qianfeng on 14-8-19.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendCellModel.h"
#import "GroupInfoViewController.h"
#define isDeleteKey @"isDelete"

@protocol MemberCellDelegate <NSObject>

@optional

/**
 *删除群成员按钮被点击
 */
-(void)didClickDeleteButtonWithUserid:(NSString *)userid;


@end

@interface Cell : UICollectionViewCell
/**
 *代理
 */
@property(strong,nonatomic) id<MemberCellDelegate>delegate;
/**
 *头像
 */
@property(nonatomic,weak) UIImageView *MyImageView;
/**
 *姓名
 */
@property(nonatomic,weak) UILabel *MyTitleLabel;
/**
 *删除按钮
 */
@property(nonatomic,weak) UIButton *badgeButton;
/**
 *是否是群成员
 */
@property(nonatomic,assign) BOOL isMember;
/**
 *群成员模型
 */
@property(nonatomic,strong) FriendCellModel *model;
/**
 *添加头像和名称（有时间再改过来）
 */
-(void)setImage:(NSString *)image title:(NSString *)title isMember:(BOOL)isMember;
@end
