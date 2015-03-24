//
//  RecomProductCell.h
//  BGProject
//
//  Created by liao on 14-11-19.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecomProductFrame.h"


@interface RecomProductCell : UITableViewCell

@property(nonatomic,retain)RecomProductFrame *cellframe;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
