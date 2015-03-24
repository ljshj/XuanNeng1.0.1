//
//  myWeiQiangTableViewCell.m
//  BGProject
//
//  Created by zhuozhong on 14-8-4.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "myWeiQiangTableViewCell.h"

@implementation myWeiQiangTableViewCell


- (void)refreshModel:(myWeiQiangMode *)model
{
    self.nameLabel.text = model.name;
    self.contentView.clipsToBounds = YES;
    self.topImageView.image = [UIImage imageNamed:@"9"];
    
    self.contentLabel.text = model.contentStr;
    CGPoint point2 = _contentLabel.frame.origin;
    _contentLabel.numberOfLines = 0;
    _contentLabel.frame = CGRectMake(point2.x, _dateLabel.frame.origin.y+_dateLabel.frame.size.height+10, model.contentSize.width, model.contentSize.height);
    
    
    _photoView.numOfPage = model.imgArr.count;
    _photoView.frame = CGRectMake(5, _contentLabel.frame.origin.y+_contentLabel.frame.size.height, 300, model.imgHeight);
    
    
}
//xib与手写代码混用
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _photoView = [[myPhotoView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
        [self.contentView addSubview:_photoView];
    }
    return self;
}


- (IBAction)deleteBtn:(id)sender {
    NSLog(@"删除自己");
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
