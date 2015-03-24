//
//  FriendCellFrame.m
//  BGProject
//
//  Created by ssm on 14-8-19.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FriendCellFrame.h"
#import "FriendCellModel.h"

@implementation FriendCellFrame

-(void)setModel:(FriendCellModel *)model {
    
    //将模型传到父类里面算好（头像／昵称／文本／cell高度）
    [super setModel:model];
    
    //性别图标（继承过来的，这个时候nameFrame已经算好，可以用）
    CGFloat sexX = CGRectGetMaxX(self.nameFrame) + kSpaceH;
    CGFloat sexY = self.nameFrame.origin.y-5;
    _sexFrame = (CGRect){{sexX,sexY},kSexSize };
    
}

@end
