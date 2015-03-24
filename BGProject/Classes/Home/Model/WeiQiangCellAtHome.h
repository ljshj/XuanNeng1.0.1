//
//  WeiQiangCellAtHome.h
//  BGProject
//
//  Created by ssm on 14-10-8.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "WeiQiangCellAtHomeFrame.h"

@interface WeiQiangCellAtHome : UITableViewCell



@property(nonatomic,retain)WeiQiangCellAtHomeFrame* cellFrame;


//头像
@property(nonatomic,retain)EGOImageView* imgImageView;
@property(nonatomic,retain)UILabel* nameLabel;
@property(nonatomic,retain)UILabel* contentLabel;
@property(nonatomic,retain)UIView* dash;


@end
