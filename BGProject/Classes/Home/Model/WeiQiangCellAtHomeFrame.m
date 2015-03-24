//
//  WeiQiangModelAtHomeFrame.m
//  BGProject
//
//  Created by ssm on 14-10-8.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "WeiQiangCellAtHomeFrame.h"
#import "weiQiangModel.h"

#define kIconHeight 70
#define kIconWidth kIconHeight

#define kBigSpace 20
#define kSpace    5 //控件之间的标准距离

#define kNameMaxLength 100

@implementation WeiQiangCellAtHomeFrame

-(void)setModel:(weiQiangModel *)model {
    
    _model = model;
    
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    //icon 的位置
    CGFloat imgX = 10;
    CGFloat imgY = 5;
    self.imgFrame = CGRectMake(imgX, imgY, kIconHeight, kIconHeight);
    

    CGFloat contentX = CGRectGetMaxX(_imgFrame) +kBigSpace;
    CGFloat contentY = imgY + 5;
    CGSize contentConstrainedSize  = (CGSize){screenSize.width-contentX-20, _imgFrame.size.height*0.7};
    CGSize contentSize = [model.content sizeWithFont:kContentFont
                                   constrainedToSize:contentConstrainedSize
                                       lineBreakMode:NSLineBreakByTruncatingTail];
    self.contentFrame = (CGRect){{contentX,contentY},contentSize};
    
    
    CGFloat nameHight = [kNameFont lineHeight];
    CGSize nameConstrainedSize  = (CGSize){200, nameHight};
    CGSize nameSize = [model.name sizeWithFont:kNameFont constrainedToSize:nameConstrainedSize lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGFloat nameY = CGRectGetMaxY(self.imgFrame) - nameHight-5;
    CGFloat nameX = screenSize.width - 30 - nameSize.width;
    self.nameFrame = (CGRect){{nameX,nameY},nameSize};
    
    CGFloat dashW = 30;
    CGFloat dashX = nameX-dashW-5;
    CGFloat dashY = CGRectGetMaxY(self.imgFrame)-nameHight*0.5-5;
    CGFloat dashH = 1;
    self.dashFrame = CGRectMake(dashX, dashY, dashW, dashH);
    
    //计算总高度
    self.cellHeight = CGRectGetMaxY(_imgFrame) + 5;

}
@end
