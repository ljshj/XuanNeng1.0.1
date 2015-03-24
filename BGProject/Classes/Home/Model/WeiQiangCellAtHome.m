//
//  WeiQiangCellAtHome.m
//  BGProject
//
//  Created by ssm on 14-10-8.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "WeiQiangCellAtHome.h"
#import "WeiQiangModelAtHome.h"
#import "NSString+TL.h"

@implementation WeiQiangCellAtHome

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        

        _imgImageView = [[EGOImageView alloc]init];
        [self.contentView addSubview:_imgImageView];
        
        
        _nameLabel = [[UILabel alloc]init];
        [_nameLabel setFont:kNameFont];
        [_nameLabel setNumberOfLines:1];
        [self.contentView addSubview:_nameLabel];
        
        _contentLabel = [[UILabel alloc]init];
        [_contentLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_contentLabel setNumberOfLines:0];
        [self.contentView addSubview:_contentLabel];
        
        _dash = [[UIView alloc] init];
        _dash.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_dash];
        
    }
    return self;
}





-(void)setCellFrame:(WeiQiangCellAtHomeFrame *)cellFrame {
    _cellFrame = cellFrame;
    weiQiangModel* model = cellFrame.model;
    
    //头像
    _imgImageView.placeholderImage = [UIImage imageNamed:@"headphoto_s@2x"];
    _imgImageView.imageURL = [NSURL URLWithString:[NSString setupSileServerAddressWithUrl:model.photo]];
    [_imgImageView setFrame:cellFrame.imgFrame];
    
    //名字
    [_nameLabel setText:model.name];
    //_nameLabel.backgroundColor = [UIColor redColor];
    [_nameLabel setFrame:cellFrame.nameFrame];
    
    //破折号
    [_dash setFrame:cellFrame.dashFrame];
    
    //正文
    [_contentLabel setText:model.content];
    [_contentLabel setFrame:cellFrame.contentFrame];
    
}




@end
