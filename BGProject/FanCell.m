//
//  FanCell.m
//  BGProject
//
//  Created by ssm on 14-9-27.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FanCell.h"
#import "FDSPublicManage.h"
#import "NSString+TL.h"

#define kNormalTitle    @"关注"
#define kSelectedTitle  @"相互关注"

#define kSelectedColor [UIColor colorWithRed:209/256.0 green:209/256.0 blue:209/256.0  alpha:1]
#define kNormalColor [UIColor colorWithRed:25/256.0 green:193/256.0 blue:80/256.0  alpha:1]

@implementation FanCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // add subViews
        _imgImageView = [[EGOImageView alloc]init];
        _imgImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *fansTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fansTap)];
        [_imgImageView addGestureRecognizer:fansTap];
        _imgImageView.layer.borderWidth = 2.0;
        _imgImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [_imgImageView.layer setCornerRadius:5];
        [_imgImageView.layer setMasksToBounds:YES];
        
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
        
        //没选中状态是“关注”，选中状态是“相互关注”
        [_attentionButton setTitle:kNormalTitle forState:UIControlStateNormal];
        [_attentionButton setTitle:kSelectedTitle forState:UIControlStateSelected];
        
        [_attentionButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_attentionButton];
        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamedForResizeAble:@"cell_bg_3side_03.png"]];
        
        //注册通知(修改按钮的状态)
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(setupButtonStaus:)
                                                     name:SetupButtonStausKey object:nil];
        
    }
    
    
    return self;
}

//数据回来后，修改对应的按钮的状态
-(void)setupButtonStaus:(NSNotification *)noti{
    
    //取出刚刚发出的userid
    NSString *userid = (NSString *)noti.object;
    
    //取出模型
    FriendModel *model = self.cellFrame.fan;
    
    if ([model.Userid isEqualToString:userid]) {
        
        //改变按钮状态
        _attentionButton.selected = !_attentionButton.selected;
        
        //根据变后的状态修改颜色(状态改了，文本已经跟着状态改了)
        if (_attentionButton.selected) {
            
            _attentionButton.backgroundColor = kSelectedColor;
            
        }else{
            
            _attentionButton.backgroundColor = kNormalColor;
            
        }
        
    }
    
}


-(void)setCellFrame:(FanCellFrame *)cellFrame {
    _cellFrame = cellFrame;
    FriendModel* fan = cellFrame.fan;
    
    _imgImageView.placeholderImage = [UIImage imageNamed:@"headphoto_s"];
    _imgImageView.imageURL = [NSURL URLWithString:[NSString setupSileServerAddressWithUrl:fan.img]];
    [_imgImageView setFrame:cellFrame.imgFrame];
    
    
    [_nameLabel setText:fan.name];
    [_nameLabel setFrame:cellFrame.nameFrame];
    
    NSString* sexImageName = [FDSPublicManage getSexImageName:fan.sex];
    [_sexImageView setFrame:cellFrame.sexImageFrame];
    [_sexImageView setImage:[UIImage imageNamed:sexImageName]];
    
//    [_levelLabel setFrame:cellFrame.levelFrame];
//    [_levelLabel setText:fan.level];
//    [_levelLabel setTextColor:[UIColor whiteColor]];
    
    [_signatrueLabel setFrame:cellFrame.signatrueFrame];
    [_signatrueLabel setText:fan.signature];
    
    [_attentionButton setFrame:cellFrame.attentionFrame];
    
    //0表示我没有关注的，1表示已经相互关注
    if (fan.guanzhutype == 0) {
        
        _attentionButton.selected = NO;
        [_attentionButton setBackgroundColor:kNormalColor];
    }else{
        
        _attentionButton.selected = YES;
        _attentionButton.backgroundColor = kSelectedColor;
        
    }

}


-(void)onClick:(UIButton*)button {
    
    if ([self.delegate respondsToSelector:@selector(didClickButtonWithUserid:buttonStaus:)]) {
        
        //取出userid
        NSString *userid = self.cellFrame.fan.Userid;
        
        //回调
        [self.delegate didClickButtonWithUserid:userid buttonStaus:button.selected];
        
    }

}

-(void)fansTap{
    
    if ([self.delegate respondsToSelector:@selector(fansPersontap:)]) {
        
        //取出userid
        NSString *userid = self.cellFrame.fan.Userid;
        
        //回调
        [self.delegate fansPersontap:userid];
        
    }
    
}


-(void)updateButton{
    
    //拿到关注按钮
    UIButton* button = _attentionButton;
    
    //按钮重新可以点击
    button.enabled = YES;
    
    //根据按钮的状态来调整按钮
    if(button.selected) {
        
        [button setTitle:kSelectedTitle forState:UIControlStateNormal];
        [button setBackgroundColor:kSelectedColor];
        CGRect btnF = button.frame;
        btnF.size.width = 90;
        btnF.origin.x = self.frame.size.width-10-btnF.size.width;
        button.frame = btnF;
        
    }else {
        
        [button setTitle:kNormalTitle forState:UIControlStateNormal];
        [button setBackgroundColor:kNormalColor];
        CGRect btnF = button.frame;
        btnF.size.width = 60;
        btnF.origin.x = self.frame.size.width-10-btnF.size.width;
        button.frame = btnF;
       
        
    }
}


@end
