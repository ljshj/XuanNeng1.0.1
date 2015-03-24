//
//  MemberCell.m
//  BGProject
//
//  Created by ssm on 14-10-8.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "MemberCell.h"
#import "FDSPublicManage.h"
#import "NSString+TL.h"

@implementation MemberCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        _distanceLabel = [[UILabel alloc]init];
        [_distanceLabel setFont:kFrinedInsarchSmallFont];
        [self.contentView addSubview:_distanceLabel];
        
        _distanceTag = [[UIImageView alloc]init];
        [self.contentView addSubview:_distanceTag];
        
        _icanLabel = [[UILabel alloc]init];
        [_icanLabel setFont:kFrinedInsarchSmallFont];
        [self.contentView addSubview:_icanLabel];
        
        _imgImageView = [[EGOImageView alloc]init];
        [self.contentView addSubview:_imgImageView];
        
        
        _ineedLabel = [[UILabel alloc]init];
        [_ineedLabel setFont:kFrinedInsarchSmallFont];
        [self.contentView addSubview:_ineedLabel];
        
        _levelLabel = [[UILabel alloc]init];
        [_levelLabel setFont:kFrinedInsarchSmallFont];
        [self.contentView addSubview:_levelLabel];
        
        _nameLabel = [[UILabel alloc]init];
        [_nameLabel setFont:kFriendInSearchBigFont];
        [self.contentView addSubview:_nameLabel];
        
        _sexImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_sexImageView];
        
        _signatrueLabel = [[UILabel alloc]init];
        [_signatrueLabel setFont:kFrinedInsarchSmallFont];
        [self.contentView addSubview:_signatrueLabel];
        
        //分割线
        _divider = [[UIView alloc] init];
        _divider.backgroundColor = DividerColor;
        [self.contentView addSubview:_divider];
        
    }
    return self;
}




-(void)setCellFrame:(MemberCellFrame *)cellFrame {
    _cellFrame = cellFrame;
    MemberModel* model = cellFrame.model;
    
    _imgImageView.placeholderImage = [UIImage imageNamed:@"headphoto_s@2x"];
    _imgImageView.imageURL = [NSURL URLWithString:[NSString setupSileServerAddressWithUrl:model.photo]];
    [_imgImageView setFrame:cellFrame.imgFrame];
    
    
    [_nameLabel setText:model.name];
    [_nameLabel setFrame:cellFrame.nameFrame];
    
    NSString* sexImageName = [FDSPublicManage getSexImageName:[model.sex stringValue]];
    [_sexImageView setFrame:cellFrame.sexImageFrame];
    if(sexImageName!=nil) {
        [_sexImageView setImage:[UIImage imageNamed:sexImageName]];
        
        
    }
    [_levelLabel setFrame:cellFrame.levelFrame];
    [_levelLabel setText:[model.level stringValue]];
    
    [_distanceTag setImage:[UIImage imageNamed:@"搜索结果-会员_12"]];
    CGRect distanceFrame = cellFrame.distanceTagFrame;
    distanceFrame.size.width = _distanceTag.image.size.width;
    distanceFrame.size.height = _distanceTag.image.size.height;
    cellFrame.distanceTagFrame = distanceFrame;
    [_distanceTag setFrame:cellFrame.distanceTagFrame];
    
    [_distanceLabel setFrame:cellFrame.distanceFrame];
    //卧槽，还可以转字符串
    [_distanceLabel setText:[self getIntWithNSNumber:model.distance]];
    //[_distanceLabel setText:[model.distance stringValue]];
    
    [_signatrueLabel setFrame:cellFrame.signatrueFrame];
    [_signatrueLabel setText:model.signature];
    
    [_ineedLabel setFrame:cellFrame.ineedFrame];
    [_ineedLabel setText:model.ineed];
    
    [_icanLabel setFrame:cellFrame.icanFrame];
    [_icanLabel setText:model.ican];
    
    _divider.frame = CGRectMake(0, cellFrame.cellHeight-0.5,kScreenWidth, 0.5);
    
}

//nsnumber转换成NSString
-(NSString *)getIntWithNSNumber:(NSNumber *)nsnumber{
    
    double x = [nsnumber doubleValue];
    int distance = 0;
    NSString *distanceStr = @"";
    
    if (x>1000) {
        
        x = x/1000.00000000;
        distance = (int)(x<0 ? x-0.5 : x+0.5);
        distanceStr = [NSString stringWithFormat:@"%dkm",distance];
        
    }else{
        
        distance = (int)(x<0 ? x-0.5 : x+0.5);
        distanceStr = [NSString stringWithFormat:@"%dm",distance];
    }
    
    return distanceStr;
    
}


@end
