//
//  WQComentCell.h
//  BGProject
//
//  Created by liao on 14-11-4.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGWQCommentCellFrame.h"

@interface WQComentCell : UITableViewCell
@property (nonatomic, strong) BGWQCommentCellFrame *commentFrame;
@property (nonatomic,copy) NSString *writeBackUserid;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
