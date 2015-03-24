//
//  MemberCell.h
//  BGProject
//
//  Created by ssm on 14-10-8.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "EGOImageView.h"
#import "MemberCellFrame.h"

#define DividerColor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]

#import <UIKit/UIKit.h>

@interface MemberCell : UITableViewCell


@property(nonatomic,retain)MemberCellFrame* cellFrame;

@property(nonatomic,retain)UIImageView* distanceTag;
@property(nonatomic,retain)UILabel* distanceLabel;
@property(nonatomic,retain)UILabel* icanLabel;
//头像
@property(nonatomic,retain)EGOImageView* imgImageView;
@property(nonatomic,retain)UILabel* ineedLabel;
@property(nonatomic,retain)UILabel* levelLabel;

@property(nonatomic,retain)UILabel* nameLabel;
@property(nonatomic,retain)UIImageView* sexImageView;
@property(nonatomic,retain)UILabel* signatrueLabel;
@property(nonatomic,retain)UIView* divider;
@end
