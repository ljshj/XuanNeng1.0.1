//
//  weiQiangMainMenueCell.m
//  BGProject
//
//  Created by zhuozhong on 14-7-24.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "weiQiangMainMenueCell.h"

@implementation weiQiangMainMenueCell


- (void)refreshModel:(weiQiangModel *)model
{
//    self.nameLabel.text = model.name;
//    
//    self.contentView.clipsToBounds = YES;
//    self.faceImageView.image = [UIImage imageNamed:@"9"];
//    
//    self.timeLabel.text = model.date;
//    CGPoint point1 = _timeLabel.frame.origin;
//    _timeLabel.frame = CGRectMake(point1.x, point1.y, model.desSize.width, model.desSize.height);
//    
//    self.contentLabel.text = model.contentStr;
//    CGPoint point2 = _contentLabel.frame.origin;
//    _contentLabel.numberOfLines = 0;
//    _contentLabel.frame = CGRectMake(point2.x, _timeLabel.frame.origin.y+_timeLabel.frame.size.height+20, model.contentSize.width, model.contentSize.height);
//
//    
//    _photoView.numOfPage = model.imgArr.count;
//    _photoView.frame = CGRectMake(5, _contentLabel.frame.origin.y+_contentLabel.frame.size.height, 300, model.imgHeight);


}
//xib与手写代码混用
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _photoView = [[PhotoView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
        [self.contentView addSubview:_photoView];
            }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
