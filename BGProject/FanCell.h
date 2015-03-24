//
//  FanCell.h
//  BGProject
//
//  Created by ssm on 14-9-27.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FanCellFrame.h"
#import "EGOImageView.h"

#define SetupButtonStausKey @"SetupButtonStaus"

@class FanCell;

@protocol FanCellDelegate <NSObject>
@optional

/**
 *点击按钮回调(selected:NO-关注按钮，YES－相互关注按钮)
 */
-(void)didClickButtonWithUserid:(NSString *)userid buttonStaus:(BOOL)selected;
/**
 *头像被点击
 */
-(void)fansPersontap:(NSString *)userid;

@end

@interface FanCell : UITableViewCell

@property(nonatomic,assign)id<FanCellDelegate> delegate;

@property(nonatomic,retain)FanCellFrame* cellFrame;

//头像
@property(nonatomic,retain)EGOImageView* imgImageView;
@property(nonatomic,retain)UILabel* nameLabel;
@property(nonatomic,retain)UIImageView* sexImageView;
@property(nonatomic,retain)UILabel* levelLabel;
@property(nonatomic,retain)UILabel* signatrueLabel;
@property(nonatomic,retain)UIButton* attentionButton;


-(void)updateButton;
@end
