//
//  myWeiQiangTableViewCell.h
//  BGProject
//
//  Created by zhuozhong on 14-8-4.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myWeiQiangMode.h"
#import "myPhotoView.h"

@interface myWeiQiangTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (strong,nonatomic) myPhotoView * photoView;
- (void)refreshModel:(myWeiQiangMode*)model;

@end
