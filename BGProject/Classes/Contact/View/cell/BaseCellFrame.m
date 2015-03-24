//
//  BaseCellFrame.m
//  BGProject
//
//  Created by ssm on 14-8-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "BaseCellFrame.h"



@implementation BaseCellFrame

-(void)setModel:(BaseCellModel *)model {
    
    _model = model;
    
    //头像
    _iconFrame = (CGRect){kIconXY, kIconSize};
    
    //昵称
    CGFloat nameX = CGRectGetMaxX(_iconFrame)+ 5*kSpaceH;
    CGFloat nameY = _iconFrame.origin.y+5;
    CGFloat nameMaxH = kNameFont.lineHeight;//字体高度
    CGFloat nameMaxW = 120;//最长就是120了，应该可以更长
    CGSize nameSize = [model.name sizeWithFont:kNameFont constrainedToSize:CGSizeMake(nameMaxW, nameMaxH) lineBreakMode:NSLineBreakByTruncatingTail];
    _nameFrame = (CGRect){{nameX,nameY},nameSize};
    
    //文本
    CGFloat detailH = kDetailFont.lineHeight;
    CGFloat detailMaxW = 200;
    CGFloat detailX = nameX;
    CGFloat detailY = CGRectGetMaxY(_iconFrame) - detailH -10;
    _detailFrame = CGRectMake(detailX, detailY, detailMaxW, detailH);
    
    //cell的高度（图像的高度＋2*间距）
    _cellHeight = _iconFrame.origin.y*2 + _iconFrame.size.height;

}
@end
