//
//  InfoCellFrame.m
//  BGProject
//
//  Created by ssm on 14-8-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "InfoCellFrame.h"

@implementation InfoCellFrame

//-(void)setInfoCellModel:(InfoCellModel *)infoCellModel {
-(void)setModel:(InfoCellModel *)model
{
    
    //算好父类的（头像／昵称／文本）
    [super setModel:model];
    
    //时间
    CGFloat dateH = kDateFont.lineHeight;
    CGFloat dateMaxW = 200;
    CGSize dateSize = [model.dateString sizeWithFont:kDateFont
                                 constrainedToSize:CGSizeMake(dateMaxW, dateH) lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGFloat dateX = 320 - 10 - dateSize.width;
    CGFloat dateY = self.nameFrame.origin.y;
    
    _dateFrame = (CGRect){{dateX,dateY},dateSize};
    
}
@end
