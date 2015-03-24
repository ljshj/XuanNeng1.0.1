//
//  TableViewCell.m
//  BGProject
//
//  Created by zhuozhong on 14-7-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _faceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
        [self.contentView addSubview:_faceImageView];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_faceImageView.frame.origin.x+_faceImageView.frame.size.width+5, _faceImageView.frame.origin.y, 100, 20)];
        [self.contentView addSubview:_nameLabel];
        
        _qianMingLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y+_nameLabel.frame.size.height, 200, 20)];
        [self.contentView addSubview:_qianMingLabel];
        
        _myCanLabel = [[UILabel alloc]initWithFrame:CGRectMake(_qianMingLabel.frame.origin.x, _qianMingLabel.frame.origin.y+_qianMingLabel.frame.size.height, 200, 20)];
        [self.contentView addSubview:_myCanLabel];
        
        _myNecLabel = [[UILabel alloc]initWithFrame:CGRectMake(_myCanLabel.frame.origin.x, _myCanLabel.frame.origin.y+_myCanLabel.frame.size.height, 200, 20)];
        [self.contentView addSubview:_myNecLabel];

        
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
