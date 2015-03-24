//
//  FriendInSearchCell.m
//  BGProject
//
//  Created by ssm on 14-9-22.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FriendInSearchCell.h"
#import "FDSPublicManage.h"
#import "NSString+TL.h"

#define AddButtonBg [UIColor colorWithRed:88/255.0 green:178/255.0 blue:92/255.0 alpha:1.0]


@implementation FriendInSearchCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        //距离
        _distanceLabel = [[UILabel alloc]init];
        [_distanceLabel setFont:kFrinedInsarchSmallFont];
        [self.contentView addSubview:_distanceLabel];
        
        //距离图标
        _distanceTag = [[UIImageView alloc]init];
        [self.contentView addSubview:_distanceTag];
        
        //我能
        _icanLabel = [[UILabel alloc]init];
        [_icanLabel setFont:kFrinedInsarchSmallFont];
        [self.contentView addSubview:_icanLabel];
        
        //头像
        _imgImageView = [[EGOImageView alloc]init];
        [self.contentView addSubview:_imgImageView];
        
        //我想
        _ineedLabel = [[UILabel alloc]init];
        [_ineedLabel setFont:kFrinedInsarchSmallFont];
        [self.contentView addSubview:_ineedLabel];
        
        //等级
        _levelLabel = [[UILabel alloc]init];
        [_levelLabel setFont:kFrinedInsarchSmallFont];
        [self.contentView addSubview:_levelLabel];
        
        //昵称
        _nameLabel = [[UILabel alloc]init];
        [_nameLabel setFont:kFriendInSearchBigFont];
        [self.contentView addSubview:_nameLabel];
        
        //性别
        _sexImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_sexImageView];
        
        //个性签名
        _signatrueLabel = [[UILabel alloc]init];
        [_signatrueLabel setFont:kFrinedInsarchSmallFont];
        [self.contentView addSubview:_signatrueLabel];
        
        //添加按钮
        _addButton = [[UIButton alloc] init];
        _addButton.backgroundColor = AddButtonBg;
        [_addButton setTitle:@"添加" forState:UIControlStateNormal];
        _addButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _addButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
        [_addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addButton];
        
    }
    return self;
}

//添加按钮点击
-(void)addButtonClick{
    
    //取出用户模型
    FriendModel *model=_cellFrame.friendModel;
    
    //拼接用户名
    NSString *username = [NSString stringWithFormat:@"bg%@",model.Userid];
    
    //回调
    if ([self.delegate respondsToSelector:@selector(didClickAddButtonWithUsername:)]) {
        
        [self.delegate didClickAddButtonWithUsername:username];
        
    }
    
}

-(void)setCellFrame:(FriendInSearchCellFrame *)cellFrame {
    
    _cellFrame = cellFrame;
    
    //取出模型
    FriendModel* friend = cellFrame.friendModel;
    
    //头像
    _imgImageView.placeholderImage = [UIImage imageNamed:@"headphoto_s"];
    _imgImageView.imageURL = [NSURL URLWithString:[NSString setupSileServerAddressWithUrl:friend.img]];
    [_imgImageView setFrame:cellFrame.imgFrame];
    
    //昵称
    [_nameLabel setText:friend.name];
    [_nameLabel setFrame:cellFrame.nameFrame];
    
    //性别
    NSString* sexImageName = [FDSPublicManage getSexImageName:friend.sex];
    [_sexImageView setFrame:cellFrame.sexImageFrame];
    if(sexImageName!=nil) {
        
        [_sexImageView setImage:[UIImage imageNamed:sexImageName]];
        
    }
    
    //添加按钮
    _addButton.frame = cellFrame.addButtonFrame;
    
    //等级
    [_levelLabel setFrame:cellFrame.levelFrame];
    [_levelLabel setText:friend.level];
    
    //距离图标
    [_distanceTag setFrame:cellFrame.distanceTagFrame];
    [_distanceTag setImage:[UIImage imageNamed:@"名片_29.png"]];
    
    //距离标签
    [_distanceLabel setFrame:cellFrame.distanceFrame];
    [_distanceLabel setText:friend.distance];
    
    //个性签名
    [_signatrueLabel setFrame:cellFrame.signatrueFrame];
    [_signatrueLabel setText:friend.signature];
    
    //我想
    [_ineedLabel setFrame:cellFrame.ineedFrame];
    [_ineedLabel setText:friend.ineed];
    
    //我能
    [_icanLabel setFrame:cellFrame.icanFrame];
    [_icanLabel setText:friend.ican];
    
    
    
}
@end
