//
//  weiQiangMainMenueCell.h
//  BGProject
//
//  Created by zhuozhong on 14-7-24.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoView.h"
#import "weiQiangModel.h"
@interface weiQiangMainMenueCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;




@property (strong,nonatomic) PhotoView * photoView;

- (void)refreshModel:(weiQiangModel *)model;

@end
