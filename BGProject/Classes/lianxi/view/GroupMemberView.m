//
//  GroupMemberView.m
//  BGProject
//
//  Created by liao on 14-12-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "GroupMemberView.h"
#import "FriendCellModel.h"
#import "UIImageView+MJWebCache.h"

@interface GroupMemberView()
/**
 *成员数组
 */
@property(nonatomic,strong) NSArray *members;
/**
 *记录下前一个添加的头像横坐标
 */
@property(nonatomic,assign) int preIconMaxX;

@end

@implementation GroupMemberView

- (instancetype)initWithMembers:(NSArray *)members
{
    self = [super init];
    if (self) {
        
        //取得数组
        self.members = members;
        
        //构建子控件
        [self setupSubviews];
        
    }
    return self;
}

//构建子控件
-(void)setupSubviews{
    
    int count = 5;
    
    //最多显示五个头像
    if (self.members.count<5) {
        
        count = self.members.count;
        
    }
    
    //需要显示头像的数组
    NSMutableArray *showMembers = [[NSMutableArray alloc] init];
    for (int j = 0; j<count; j++) {
        
        //倒序显示
        int reverseIndex = self.members.count-(j+1);
        FriendCellModel *model = self.members[reverseIndex];
        [showMembers addObject:model];
        
    }
    
    for (int i=0; i<count; i++) {
    
        UIImageView *iconView = [[UIImageView alloc] init];
        
        CGFloat iconX = 0;
        if (i==0) {
            
            iconX = 10;
            
        }else{
            
            iconX = self.preIconMaxX+10;
            
        }
        
        CGFloat iconY = 10;
        CGFloat iconW = IconViewHW;
        CGFloat iconH = IconViewHW;
        iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
        
        [self setupRoundBorderWithIconView:iconView];
        [self addSubview:iconView];
        
        //取出模型
        FriendCellModel *model = showMembers[i];
        
        [iconView setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"headphoto_s"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
        
        
        //记录下横坐标
        self.preIconMaxX = CGRectGetMaxX(iconView.frame);
        
    }
    
}

//设置圆角
-(UIImageView *)setupRoundBorderWithIconView:(UIImageView *)iconView{
    
    //设置圆角
    CGFloat radius = 5;
    [iconView.layer setCornerRadius:radius];
    [iconView.layer setMasksToBounds:YES];
    
    return iconView;
    
}

@end
