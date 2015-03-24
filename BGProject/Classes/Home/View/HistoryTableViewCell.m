//
//  HistoryTableViewCell.m
//  BGProject
//
//  Created by liao on 14-10-24.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell{
    
    __weak IBOutlet UIImageView *searchView;
    __weak IBOutlet UIImageView *arrowView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
