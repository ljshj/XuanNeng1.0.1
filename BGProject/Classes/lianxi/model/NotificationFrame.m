//
//  NotificationFrame.m
//  BGProject
//
//  Created by liao on 14-12-27.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "NotificationFrame.h"
#import "NSString+TL.h"

@implementation NotificationFrame

-(void)setModel:(NotificationModel *)model{
    
    _model = model;
    
    //头像
    CGFloat iconX = 10;
    CGFloat iconY = 10;
    CGFloat iconW = 40;
    CGFloat iconH = 40;
    _IconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    //昵称
    CGFloat nameX = CGRectGetMaxX(_IconFrame)+10;
    CGFloat nameY = 10;
    CGFloat nameW = 150;
    CGFloat nameH = 20;
    _nameFrame = CGRectMake(nameX, nameY, nameW, nameH);
    
    //消息
    CGSize messageSize = [NSString sizeWithText:model.message font:MessageFont maxSize:CGSizeMake(150, 20)];
    CGFloat messageX = CGRectGetMaxX(_IconFrame)+10;
    CGFloat messageY = CGRectGetMaxY(_nameFrame)+10;
    CGFloat messageW = messageSize.width;
    CGFloat messageH = messageSize.height;
    _messageFrame = CGRectMake(messageX, messageY, messageW, messageH);
    
    _cellHeight = CGRectGetMaxY(_IconFrame)+10;
    
}

-(instancetype)initWithNotificationModel:(NotificationModel *)model{
    if(self = [super init])
    {
        self.model = model;
    }
    return self;
}

@end
