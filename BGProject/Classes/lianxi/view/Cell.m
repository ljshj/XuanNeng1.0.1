//
//  Cell.m
//  UICollectionView
//
//  Created by qianfeng on 14-8-19.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import "Cell.h"
#import "UIImageView+MJWebCache.h"
#import "NSString+TL.h"

@implementation Cell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //设置圆角
        CGFloat radius = 5;
        [self.layer setCornerRadius:radius];
        [self.layer setMasksToBounds:YES];
        
        //设置图片
        UIImageView *MyImageView = [[UIImageView alloc] init];
        MyImageView.userInteractionEnabled = YES;
        MyImageView.frame = CGRectMake(0, 0, self.frame.size.width, 52);
        [self.contentView addSubview:MyImageView];
        self.MyImageView = MyImageView;
        
        //设置文字
        UILabel *MyTitleLabel = [[UILabel alloc] init];
        MyTitleLabel.frame = CGRectMake(0, 32, self.frame.size.width, 20);
        MyTitleLabel.text = @"张天龙";
        MyTitleLabel.textColor = [UIColor whiteColor];
        MyTitleLabel.font = [UIFont systemFontOfSize:13];
        MyTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.MyImageView addSubview:MyTitleLabel];
        MyTitleLabel.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.5];
        self.MyTitleLabel = MyTitleLabel;
        
        UIButton *badgeButton = [[UIButton alloc] init];
        CGFloat badgeW = 20;
        CGFloat badgeX = self.frame.size.width-badgeW;
        CGFloat badgeY = 0;
        CGFloat badgeH = 20;
        badgeButton.frame = CGRectMake(badgeX, badgeY, badgeW, badgeH);
        [badgeButton setImage:[UIImage imageNamed:@"deleteMemberBadge"] forState:UIControlStateNormal];
        badgeButton.hidden = YES;
        [badgeButton addTarget:self action:@selector(badgeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.MyImageView addSubview:badgeButton];
        self.badgeButton = badgeButton;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(badgeButtonWithNotification:)
                                                     name:isDeleteKey object:nil];
        
        
    }
    return self;
}


-(void)badgeButtonWithNotification:(NSNotification *)notification{
    
    BOOL isDelete = [notification.object boolValue];
   
    if (isDelete) {
        
        //只有是成员才会显示删除按钮
        if (self.isMember) {
            
            self.badgeButton.hidden  = NO;
            
        }
        
    }else{
        
        self.badgeButton.hidden  = YES;
        
    }
}


-(void)badgeButtonClick{
    
    if ([self.delegate respondsToSelector:@selector(didClickDeleteButtonWithUserid:)]) {
       
        [self.delegate didClickDeleteButtonWithUserid:self.model.userid];
        
    }
    
}

-(void)setImage:(NSString *)image title:(NSString *)title isMember:(BOOL)isMember{
    
    self.isMember = isMember;
    
    self.badgeButton.hidden = YES;
    
    if (isMember) {
        
        [self.MyImageView setImageWithURL:[NSURL URLWithString:[NSString setupSileServerAddressWithUrl:image]] placeholderImage:[UIImage imageNamed:@"headphoto_s"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
        self.MyTitleLabel.hidden = NO;
        self.MyTitleLabel.text = title;
        
        
    }else{
        
        self.MyImageView.image = [UIImage imageNamed:image];
        self.MyTitleLabel.hidden = YES;
        
    }
    
}

-(void)dealloc{
    
    //删除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:isDeleteKey object:nil];
    
}

@end
