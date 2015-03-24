//
//  RecomProductFrame.m
//  BGProject
//
//  Created by liao on 14-11-19.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "RecomProductFrame.h"
#import "NSString+TL.h"

//整个屏幕的宽度
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define kCellMargin 10
#define kdateIconWH 19*0.5
#define kProductNameFont [UIFont systemFontOfSize:14.0]

@implementation RecomProductFrame

-(void)setModel:(RecomProductModel *)model{
    
    _model = model;
    
    //日期图标
    CGFloat dateIconX = kCellMargin;
    CGFloat dateIconY = kCellMargin;
    CGFloat dateIconW = kdateIconWH;
    CGFloat dateIconH = kdateIconWH;
    _dateIconFrame = CGRectMake(dateIconX, dateIconY, dateIconW, dateIconH);
    
    //日期
    CGFloat dateX = CGRectGetMaxX(_dateIconFrame)+5;
    CGFloat dateY = 5;
    CGFloat dateW = 150;
    CGFloat dateH = 20;
    _dateFrame = CGRectMake(dateX, dateY, dateW, dateH);
    
    //推荐标识
    CGFloat recomButtonW = 60;
    CGFloat recomButtonX = screenWidth-recomButtonW-kCellMargin;
    CGFloat recomButtonY = 0;
    CGFloat recomButtonH = 24;
    _recomTagFrame = CGRectMake(recomButtonX, recomButtonY, recomButtonW, recomButtonH);
    
    //产品图片
    CGFloat imgX = kCellMargin;
    CGFloat imgY = CGRectGetMaxY(_dateFrame)+kCellMargin;
    CGFloat imgW = screenWidth-kCellMargin*2;
    CGFloat imgH = 160;
    _imgFrame = CGRectMake(imgX, imgY, imgW, imgH);
    
    //产品名称
    CGFloat nameX = kCellMargin;
    CGFloat nameY = CGRectGetMaxY(_imgFrame);
    CGSize nameSize = [self sizeWithText:model.product_name font:kProductNameFont maxSize:CGSizeMake(imgW, MAXFLOAT)];
    _nameFrame = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    
    //价格
    CGFloat priceX = kCellMargin;
    CGFloat priceY = CGRectGetMaxY(_nameFrame);
    CGFloat priceW = 100;
    CGFloat priceH = 20;
    _priceFrame = CGRectMake(priceX, priceY, priceW, priceH);
    
    //cell高度
    _cellHight = CGRectGetMaxY(_priceFrame)+kCellMargin+10;
    
}

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}



@end
