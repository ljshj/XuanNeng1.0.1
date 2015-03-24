//
//  FriendCell.m
//  BGProject
//
//  Created by ssm on 14-8-19.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FriendCell.h"


@interface FriendCell()<UIAlertViewDelegate>

@property(nonatomic,retain)UIImageView* sexView;

@end


@implementation FriendCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(friendPersontap)];
        [self.iconView addGestureRecognizer:tap];
        self.iconView.userInteractionEnabled = YES;
        
        _sexView = [[UIImageView alloc]init];
        [self.contentView addSubview:_sexView];
        
        //添加删除好友的长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(friendCellLongPress:)];
        [self addGestureRecognizer:longPress];
        
    }
    return  self;
}

//头像点击
-(void)friendPersontap{
    
    if([self.delegate respondsToSelector:@selector(friendPersontap:)])
    {
        //取出cellframe
        FriendCellModel *model = (FriendCellModel *)self.cellFrame.model;
        
        [self.delegate friendPersontap:model.userid];
    }
    
}

//长按手势触发
-(void)friendCellLongPress:(UILongPressGestureRecognizer *)lp{
    
    //取出模型
    FriendCellModel *model = (FriendCellModel *)self.cellFrame.model;
    
    //拼接标题
    NSString *message = [NSString stringWithFormat:@"确认删除好友%@",model.name];
    
    if (lp.state == UIGestureRecognizerStateBegan) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温性提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alert show];
        
    }
    
    
}

#pragma mark-UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        
        //取出模型
        FriendCellModel *model = (FriendCellModel *)self.cellFrame.model;
        
        //回调
        if ([self.delegate respondsToSelector:@selector(deleteGoodFriendWithUserid:)]) {
            
            [self.delegate deleteGoodFriendWithUserid:model.userid];
            
        }
        
    }
    
}

-(void)setCellFrame:(FriendCellFrame *)cellFrame {
    
    //设置父类的各个子控件位置 和内容
    [super setCellFrame:cellFrame];
    
    //设置显示性别的控件的位置
    FriendCellModel* model = (FriendCellModel*)cellFrame.model;
    
    NSString* imageName = nil;
    if(model.isGirl == YES ) {
        imageName = @"iconGirl.png";
    } else {
        imageName = @"iconBoy.png";
    }
    _sexView.image = [UIImage imageNamed:imageName];
    [_sexView setFrame:cellFrame.sexFrame];
    
}

@end
