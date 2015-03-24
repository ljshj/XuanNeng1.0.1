//
//  MyAttentionCell.m
//  BGProject
//
//  Created by ssm on 14-9-27.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "MyAttentionCell.h"
#import "FDSPublicManage.h"
#import "NSString+TL.h"

#define kNormalTitle    @"取消关注"
#define kNormalColor [UIColor colorWithRed:25/256.0 green:193/256.0 blue:80/256.0  alpha:1]

@implementation MyAttentionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        // add subViews
        _imgImageView = [[EGOImageView alloc]init];
        _imgImageView.userInteractionEnabled  =YES;
        //设置头像圆角
        _imgImageView.layer.borderWidth = 2.0;
        _imgImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [_imgImageView.layer setCornerRadius:5];
        [_imgImageView.layer setMasksToBounds:YES];
        UITapGestureRecognizer *personalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalTap)];
        [_imgImageView addGestureRecognizer:personalTap];
        [self.contentView addSubview:_imgImageView];
        
        _levelLabel = [[UILabel alloc]init];
        [_levelLabel setFont:KSmallFont];
        [_levelLabel setBackgroundColor:[UIColor redColor]];
        [self.contentView addSubview:_levelLabel];
        
        _nameLabel = [[UILabel alloc]init];
        [_nameLabel setFont:kBigFont];
        [self.contentView addSubview:_nameLabel];
        
        _sexImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_sexImageView];
        
        _signatrueLabel = [[UILabel alloc]init];
        [_signatrueLabel setFont:KSmallFont];
        [self.contentView addSubview:_signatrueLabel];
        
        
        _attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentionButton.layer.borderWidth = 2.0;
        _attentionButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [_attentionButton.layer setCornerRadius:5];
        [_attentionButton.layer setMasksToBounds:YES];
        _attentionButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_attentionButton setTitle:kNormalTitle forState:UIControlStateNormal];
        [_attentionButton setBackgroundColor:kNormalColor];
        [_attentionButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_attentionButton];
        
        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamedForResizeAble:@"cell_bg_3side_03.png"]];

    }
    return self;
}

-(void)setCellFrame:(MyAttentionCellFrame *)cellFrame {
    
    _cellFrame = cellFrame;
    
    //取出模型
    FriendModel* myAttentionPerson = cellFrame.myAttentionPerson;
    
    //没有占位图片？
    _imgImageView.placeholderImage = [UIImage imageNamed:@"headphoto_s"];
    _imgImageView.imageURL = [NSURL URLWithString:[NSString setupSileServerAddressWithUrl:myAttentionPerson.img]];
    [_imgImageView setFrame:cellFrame.imgFrame];
    
    //昵称
    [_nameLabel setText:myAttentionPerson.name];
    [_nameLabel setFrame:cellFrame.nameFrame];
    NSString* sexImageName = [FDSPublicManage getSexImageName:myAttentionPerson.sex];
    [_sexImageView setFrame:cellFrame.sexImageFrame];
    if(sexImageName!=nil) {
            [_sexImageView setImage:[UIImage imageNamed:sexImageName]];
    }

    //等级，暂时不显示
//    [_levelLabel setFrame:cellFrame.levelFrame];
//    [_levelLabel setText:myAttentionPerson.level];
//    [_levelLabel setTextColor:[UIColor whiteColor]];
    
    //签名
    [_signatrueLabel setFrame:cellFrame.signatrueFrame];
    [_signatrueLabel setText:myAttentionPerson.signature];
    [_attentionButton setFrame:cellFrame.attentionFrame];
    
}


//点击按钮
-(void)onClick:(UIButton*)button {

    if ([self.delegate respondsToSelector:@selector(didUnfollowWithUserid:)]) {
        
        //取出模型
        FriendModel *model = self.cellFrame.myAttentionPerson;
        
        //取出被取消的userid
        NSString *userid = model.Userid;
        
        //回调
        [self.delegate didUnfollowWithUserid:userid];
        
    }
    
}

//头像被点击
-(void)personalTap{
    
    if ([self.delegate respondsToSelector:@selector(attentionPersontap:)]) {
        
        //取出模型
        FriendModel *model = self.cellFrame.myAttentionPerson;
        
        //取出被取消的userid
        NSString *userid = model.Userid;
        
        //回调
        [self.delegate attentionPersontap:userid];
        
    }
    
}

@end
