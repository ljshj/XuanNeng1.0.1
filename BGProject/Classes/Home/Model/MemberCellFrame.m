//
//  MemberCellFrame.m
//  BGProject
//
//  Created by ssm on 14-10-8.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "MemberCellFrame.h"
#define kIconHeight 70
#define kIconWidth kIconHeight

#define kBigSpace 20
#define kSpace    5 //控件之间的标准距离

#define kNameMaxLength 100


@implementation MemberCellFrame


-(void)setModel:(MemberModel *)model
{
    _model = model;
    
    //icon 的位置
    CGFloat imgX = 10;
    CGFloat imgY = 5;
    self.imgFrame = CGRectMake(10, 5, kIconHeight, kIconHeight);
    
    //用户名字的frame
    CGFloat nameX = CGRectGetMaxX(_imgFrame) + kBigSpace;
    CGFloat nameY = imgY;
    CGSize nameSize = [model.name sizeWithFont:kFriendInSearchBigFont forWidth:kNameMaxLength lineBreakMode:NSLineBreakByTruncatingTail];
    self.nameFrame = (CGRect){{nameX, nameY},nameSize};
    
    //用户性别的frame  lineHeight
    CGFloat sexX = CGRectGetMaxX(_nameFrame)+kSpace;
    CGFloat sexY = imgY;
    CGFloat sexH = kFriendInSearchBigFont.lineHeight;//和名字的控件等高
    CGFloat sexW = sexH;
    self.sexImageFrame = (CGRect){{sexX,sexY},{sexW,sexH}};
    
    
    //用户等级
    CGFloat levelX = 0;
    if ([[model.sex stringValue] isEqualToString:@"2"]) {
        
        levelX= CGRectGetMaxX(_nameFrame)+kSpace;
        
    }else{
        
        levelX= CGRectGetMaxX(_sexImageFrame)+kSpace;
        
    }
    
    CGFloat levelY = imgY;
    CGSize levelSize = [[model.level stringValue] sizeWithFont:kFrinedInsarchSmallFont forWidth:44 lineBreakMode:NSLineBreakByTruncatingTail];
    //暂时隐藏 等级
    self.levelFrame =(CGRect){{levelX,levelY},CGSizeZero};
    
    
    //用户距离图标
    CGFloat distanceTagX = CGRectGetMaxX(_levelFrame)+kSpace;
    CGFloat distanceTagY = imgY+2;
    CGFloat distanceTagH = kFriendInSearchBigFont.lineHeight;//和名字的控件等高
    CGFloat distanceTagW = sexH;
    self.distanceTagFrame = (CGRect){{distanceTagX,distanceTagY},
        {distanceTagW,distanceTagH}};
    
    //距离 label
    CGSize distanceSize = [[model.distance stringValue] sizeWithFont:kFrinedInsarchSmallFont forWidth:100 lineBreakMode:NSLineBreakByTruncatingTail];
    CGFloat distanceX = CGRectGetMaxX(self.distanceTagFrame)-kSpace;
    CGFloat distanceY = imgY+2;
    self.distanceFrame = (CGRect){{distanceX,distanceY},distanceSize};
    
    
    //计算个性签名 我能 我需 最大的显示长度
    CGFloat lineMaxLength = [UIScreen mainScreen].bounds.size.width;
    lineMaxLength -=  nameX;
    lineMaxLength -=  20;
    
    // 个性签名
    CGFloat signatrueX = nameX;
    CGFloat signatrueY = CGRectGetMaxY(_nameFrame)+kSpace;
    CGSize signatrueSize = [model.signature sizeWithFont:kFrinedInsarchSmallFont forWidth:lineMaxLength lineBreakMode:NSLineBreakByTruncatingTail];
    self.signatrueFrame = (CGRect){{signatrueX,signatrueY},signatrueSize};
    
    
    // 我能
    CGFloat icanX = nameX;
    CGFloat icanY = CGRectGetMaxY(_signatrueFrame)+kSpace;
    CGSize icanSize = [model.ican sizeWithFont:kFrinedInsarchSmallFont forWidth:lineMaxLength lineBreakMode:NSLineBreakByTruncatingTail];
    self.icanFrame = (CGRect){{icanX ,icanY},icanSize};
    
    //我需
    CGFloat ineedX = nameX;
    CGFloat ineedY = CGRectGetMaxY(_icanFrame)+kSpace;
    CGSize ineedSize = [model.ineed sizeWithFont:kFrinedInsarchSmallFont forWidth:lineMaxLength lineBreakMode:NSLineBreakByTruncatingTail];
    self.ineedFrame = (CGRect){{ineedX ,ineedY},ineedSize};
    
    
    //计算总高度
    self.cellHeight = CGRectGetMaxY(_ineedFrame) + 5;
}
@end
