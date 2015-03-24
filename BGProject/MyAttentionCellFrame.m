//
//  MyAttentionCellFrame.m
//  BGProject
//
//  Created by ssm on 14-9-27.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "MyAttentionCellFrame.h"

@implementation MyAttentionCellFrame


-(void)setMyAttentionPerson:(FriendModel *)myAttentionPerson
{
    
    _myAttentionPerson = myAttentionPerson;
    
    //屏幕距离
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    
    //icon 的位置
    CGFloat imgX = 20;
    CGFloat imgY = 10;
    self.imgFrame = CGRectMake(imgX, imgY, kIconHeight, kIconHeight);
    
    //用户名字的frame
    CGFloat nameX = CGRectGetMaxX(_imgFrame) + 10;
    CGFloat nameY = imgY;
    CGSize nameSize = [myAttentionPerson.name sizeWithFont:kBigFont
                                                  forWidth:150
                                             lineBreakMode:NSLineBreakByTruncatingTail];
    self.nameFrame = (CGRect){{nameX, nameY},nameSize};
    
    
    //用户性别的frame  lineHeight
    CGFloat sexX = CGRectGetMaxX(_nameFrame)+kSpace;
    CGFloat sexY = imgY+3;
    //CGFloat sexH = kBigFont.lineHeight;//和名字的控件等高
    CGFloat sexH = 35*0.5*0.8;
    CGFloat sexW = sexH;
    //暂时没有显示 保密性别的图片
    self.sexImageFrame = (CGRect){{sexX,sexY},{sexW,sexH}};
    
    
    //用户等级
    CGSize levelSize = [myAttentionPerson.level
                        sizeWithFont:KSmallFont
                        forWidth:44 lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGFloat levelX =  CGRectGetMaxX(_sexImageFrame)+kSpace;
    CGFloat levelY = imgY+3;

    self.levelFrame =(CGRect){{levelX,levelY},levelSize};
    
    //计算个性签名 我能 我需 最大的显示长度
    CGFloat lineMaxLength = screenSize.width;
    lineMaxLength -=  nameX;
    lineMaxLength -=  80 ;// 防止和后面的按钮重叠
    
    // 个性签名
    CGSize signatrueSize = [myAttentionPerson.signature sizeWithFont:KSmallFont
                                              forWidth:lineMaxLength
                                         lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGFloat signatrueX = nameX;
    CGFloat signatrueY = CGRectGetMaxY(_imgFrame)-signatrueSize.height;
    self.signatrueFrame = (CGRect){{signatrueX,signatrueY},signatrueSize};
    
    //计算总高度
    self.cellHeight = CGRectGetMaxY(_imgFrame)+ _imgFrame.origin.y;
    
    //关注按钮frame
    CGFloat attentionH = 30;
    CGFloat attentionW = 70;
    CGFloat attentionY = (_cellHeight - attentionH)*0.5;
    CGFloat attentionX = screenSize.width - attentionW - 10;
    self.attentionFrame = CGRectMake(attentionX, attentionY, attentionW, attentionH);
    
}



@end
