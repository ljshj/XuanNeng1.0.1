//
//  MyAttentionCell.h
//  BGProject
//
//  Created by ssm on 14-9-27.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAttentionCellFrame.h"
#import "EGOImageView.h"

@class MyAttentionCell;

@protocol MyAttentionCellDelegate <NSObject>

@optional
/**
 *取消关注回调
 */
-(void)didUnfollowWithUserid:(NSString *)userid;
/**
 *头像被点击
 */
-(void)attentionPersontap:(NSString *)userid;

@end


@interface MyAttentionCell : UITableViewCell

@property(nonatomic,assign)id<MyAttentionCellDelegate> delegate;

@property(nonatomic,strong)MyAttentionCellFrame* cellFrame;

//头像
@property(nonatomic,strong)EGOImageView* imgImageView;
@property(nonatomic,strong)UILabel* nameLabel;
@property(nonatomic,strong)UIImageView* sexImageView;
@property(nonatomic,strong)UILabel* levelLabel;
@property(nonatomic,strong)UILabel* signatrueLabel;
@property(nonatomic,strong)UIButton* attentionButton;

-(void)updateButton;
@end