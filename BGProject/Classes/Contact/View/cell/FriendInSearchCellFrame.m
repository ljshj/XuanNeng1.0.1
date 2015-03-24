//
//  FriendInSearchCellFrame.m
//  BGProject
//
//  Created by ssm on 14-9-22.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//  控制 FriendInSearchCell 的各个子控件的位置

#import "FriendInSearchCellFrame.h"
#define kIconHeight 70
#define kIconWidth kIconHeight

#define kBigSpace 20
#define kSpace    5 //控件之间的标准距离


#define kNameMaxLength 100
@implementation FriendInSearchCellFrame

// 计算控件的位置
-(void)setFriendModel:(FriendModel *)friendModel {
    
    _friendModel = friendModel;
    
    //头像
    CGFloat imgX = 10;
    CGFloat imgY = 10;
    self.imgFrame = CGRectMake(imgX, imgY, kIconHeight, kIconHeight);
    
    //昵称
    CGFloat nameX = CGRectGetMaxX(_imgFrame) + kBigSpace;
    CGFloat nameY = imgY;
    CGSize nameSize = [friendModel.name sizeWithFont:kFriendInSearchBigFont forWidth:kNameMaxLength lineBreakMode:NSLineBreakByTruncatingTail];
    
    self.nameFrame = (CGRect){{nameX, nameY},nameSize};
    
    //用户性别
    CGFloat sexX = CGRectGetMaxX(_nameFrame)+kSpace;
    CGFloat sexY = imgY+2;
    CGFloat sexH = 13;//和名字的控件等高
    CGFloat sexW = sexH;
    self.sexImageFrame = (CGRect){{sexX,sexY},{sexW,sexH}};
    
    //添加按钮
    CGFloat addButtonW = 50;
    CGFloat addButtonX = kScreenWidth-addButtonW-6*kSpace;
    CGFloat addButtonY = 5;
    CGFloat addButtonH = 25;
    self.addButtonFrame = CGRectMake(addButtonX, addButtonY, addButtonW, addButtonH);
    
    
    //用户等级
    CGFloat levelX =  CGRectGetMaxX(_sexImageFrame)+kSpace;
    CGFloat levelY = imgY;
    CGSize levelSize = [friendModel.level sizeWithFont:kFrinedInsarchSmallFont forWidth:44 lineBreakMode:NSLineBreakByTruncatingTail];
    //暂时隐藏 等级
    self.levelFrame =(CGRect){{levelX,levelY},CGSizeZero};
    
    //用户距离图标
    CGFloat distanceTagX = CGRectGetMaxX(_levelFrame)+kSpace;
    CGFloat distanceTagY = imgY;
    CGFloat distanceTagH = kFriendInSearchBigFont.lineHeight;//和名字的控件等高
    CGFloat distanceTagW = sexH;
    //暂时隐藏距离图标
    self.distanceTagFrame = (CGRect){{distanceTagX,distanceTagY},
                                     CGSizeZero};

    //距离 label
    CGSize distanceSize = [friendModel.distance sizeWithFont:kFrinedInsarchSmallFont forWidth:100 lineBreakMode:NSLineBreakByTruncatingTail];
    CGFloat distanceX = CGRectGetMaxX(self.distanceTagFrame)+kSpace;
    CGFloat distanceY = imgY;
    //暂时隐藏距离
    self.distanceFrame = (CGRect){{distanceX,distanceY},CGSizeZero};
    
    
    //计算个性签名／我能／我需最大的显示长度
    CGFloat lineMaxLength = [UIScreen mainScreen].bounds.size.width;
    lineMaxLength -=  nameX;
    lineMaxLength -=  20;
    
    // 个性签名
    CGFloat signatrueX = nameX;
    CGFloat signatrueY = CGRectGetMaxY(_nameFrame)+kSpace;
    CGSize signatrueSize = [friendModel.signature sizeWithFont:kFrinedInsarchSmallFont forWidth:lineMaxLength lineBreakMode:NSLineBreakByTruncatingTail];
    self.signatrueFrame = (CGRect){{signatrueX,signatrueY},signatrueSize};
    

    // 我能
    CGFloat icanX = nameX;
    CGFloat icanY = CGRectGetMaxY(_signatrueFrame)+kSpace;
    CGSize icanSize = [friendModel.ican sizeWithFont:kFrinedInsarchSmallFont forWidth:lineMaxLength lineBreakMode:NSLineBreakByTruncatingTail];
    self.icanFrame = (CGRect){{icanX ,icanY},icanSize};

    //我需
    CGFloat ineedX = nameX;
    CGFloat ineedY = CGRectGetMaxY(_icanFrame)+kSpace;
    CGSize ineedSize = [friendModel.ineed sizeWithFont:kFrinedInsarchSmallFont forWidth:lineMaxLength lineBreakMode:NSLineBreakByTruncatingTail];
    self.ineedFrame = (CGRect){{ineedX ,ineedY},ineedSize};
    

    //计算总高度
    self.cellHeight = CGRectGetMaxY(_ineedFrame) + 10;
    
}
@end
