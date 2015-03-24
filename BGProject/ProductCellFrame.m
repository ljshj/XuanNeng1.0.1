//
//  ProductCellFrame.m
//  BGProject
//
//  Created by zhuozhong on 14-10-10.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ProductCellFrame.h"

#define kIconHeight 65
#define kIconWidth kIconHeight

#define kBigSpace 25
#define kSpace    5 //控件之间的标准距离

@implementation ProductCellFrame


-(void)setModel:(ProductModel *)model
{
    _model = model;
    
    //整个屏幕的size
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    //头像
    CGRect photoFrame = CGRectMake(10, 5, kIconHeight, kIconWidth);
    _photoFrame = photoFrame;
    
    //商品名称
    CGFloat nameY =photoFrame.origin.y;
    CGFloat nameX = CGRectGetMaxX(photoFrame) + 2*kSpace;
    CGSize constrainedSize = CGSizeMake(screenSize.width-nameX-kSpace, 40);
    CGSize nameSize = [model.product_name sizeWithFont:kIntroFont constrainedToSize:constrainedSize lineBreakMode:UILineBreakModeWordWrap];
    
   _nameFrame  = (CGRect){{nameX, nameY}, nameSize};
    

    //价格
    CGSize priceSize = [model.priceStr  sizeWithFont:kPriceFont forWidth:200 lineBreakMode:NSLineBreakByTruncatingTail];
    CGFloat priceX = CGRectGetMaxX(photoFrame)+5;
    CGFloat priceY = CGRectGetMaxY(_nameFrame)+5;
    self.priceFrame = (CGRect){{priceX, priceY},priceSize};
    
    
    _cellHight = CGRectGetMaxY(_photoFrame) + _photoFrame.origin.y;
    
}
@end
