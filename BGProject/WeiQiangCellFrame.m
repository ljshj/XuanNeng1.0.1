//
//  WeiqiangCellFrame.m
//  BGProject
//
//  Created by ssm on 14-9-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "WeiQiangCellFrame.h"
#import "StatusImageListView.h"
#import "NSString+TL.h"
#import "WeiQiangRelatedModel.h"
#import "BGWQCommentCellFrame.h"

#define kSpace 10

#define kIconHeight 45
#define kIconWidth kIconHeight


@implementation WeiQiangCellFrame

-(void)setModel:(weiQiangModel *)model {

    _model = model;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width-16;
    
    CGRect photoFrame = CGRectMake(13, 13, kIconHeight, kIconWidth);
    _photoFrame = photoFrame;
    
    //用户名字的frame
    CGFloat nameX = CGRectGetMaxX(photoFrame) + kSpace;
    CGFloat nameY = photoFrame.origin.y;
    CGSize nameSize = [model.name sizeWithFont:kBigFont forWidth:screenWidth-nameX lineBreakMode:NSLineBreakByTruncatingTail];
    CGRect nameFrame = (CGRect){{nameX, nameY},nameSize};
    _nameFrame = nameFrame;
    
    //距离图标
    CGFloat distanceTagX = CGRectGetMaxX(nameFrame)+kSpace/2;
    CGFloat distanceTagY = nameY+4;
    CGFloat distanceTagWH = 12;
    CGSize  distanceTagSize = CGSizeMake(distanceTagWH, distanceTagWH);
    CGRect distanceTagFrame = (CGRect){{distanceTagX,distanceTagY},distanceTagSize};
    _distanceTagFrame = distanceTagFrame;
    
    //显示距离
    CGFloat distanceX = CGRectGetMaxX(distanceTagFrame)+2;
    CGFloat distanceY = distanceTagY-2.5;
    NSString *distance = [self getIntWithNSNumber:model.distance];
    CGSize distanceSize = [NSString sizeWithText:distance font:kMiddleFont maxSize:CGSizeMake(100, 20)];
    CGRect distanceFrame = (CGRect){{distanceX,distanceY},distanceSize};
    _distanceFrame = distanceFrame;
    
    //显示时间，在名字的下方
    CGFloat dateX = nameX;
    CGFloat dateY = CGRectGetMaxY(nameFrame)+5;
    CGSize dateSize = [model.date_time sizeWithFont:kMiddleFont forWidth:screenWidth-nameX lineBreakMode:NSLineBreakByTruncatingTail];
    CGRect dateFrame = (CGRect){{dateX,dateY},dateSize};
    _dateFrame = dateFrame;
    
    //删除按钮
    CGFloat deleteX = screenWidth - 50;
    CGFloat deleteY = nameY;
    CGSize  deleteSize = CGSizeMake(25, 25);
    _deleteFrame = (CGRect){{deleteX,deleteY}, deleteSize};
    
    
    //正文内容位置
    CGFloat contentX =photoFrame.origin.x;
    CGFloat contentY = CGRectGetMaxY(photoFrame) + kSpace;
    //如果有转发，那么正文位置放的是转发评论,否则放的就是原文
    NSString *content = nil;
    if (![model.fromname isEqualToString:@""]) {
        
        //赋值正文
        if ([model.comments isEqualToString:@""]) {
            //如果为空，就是转发微墙
            content = @"转发微墙";
            
        }else{
            
            content = model.comments;
            
        }
        
        //转发正文内容位置（如果有转发就算）
        if (![model.content isEqualToString:@""]) {
            CGFloat fromContentX =kSpace;
            CGFloat fromContentY = kSpace;
            CGSize fromContentSize = [NSString sizeWithText:model.content font:kMiddleFont maxSize:CGSizeMake(screenWidth - 4 * kSpace, MAXFLOAT)];
            _fromContentFrame = (CGRect){{fromContentX, fromContentY}, fromContentSize};
        }else{
            
            _fromContentFrame = CGRectZero;
            
        }
        
    }else{
        //没有转发赋值
        content = model.content;
        
        
    }
    CGSize contentSize = [content sizeWithFont:kMiddleFont constrainedToSize:CGSizeMake(screenWidth - 2 * kSpace, MAXFLOAT)];
    _contentFrame = (CGRect){{contentX, contentY}, contentSize};
    
    if (![model.fromname isEqualToString:@""]){
        
        //有转发,图片计算
        if (model.imgs.count) {
            CGFloat imageListViewX = kSpace;
            CGFloat imageListViewY = CGRectGetMaxY(_fromContentFrame) + kSpace;
            CGSize imageListViewSize = [StatusImageListView imageSizeWithCount:model.imgs.count];
            _imageListViewFrame = (CGRect){{imageListViewX, imageListViewY}, imageListViewSize};
        }
        
    }else{
        
        //没有转发图片列表计算
        if (model.imgs.count) {
            CGFloat imageListViewX = photoFrame.origin.x;
            CGFloat imageListViewY = CGRectGetMaxY(_contentFrame) + kSpace;
            CGSize imageListViewSize = [StatusImageListView imageSizeWithCount:model.imgs.count];
            _imageListViewFrame = (CGRect){{imageListViewX, imageListViewY}, imageListViewSize};
        }
        
    }
    
    //转发正文背景视图
    if (![model.fromname isEqualToString:@""]){
        
        CGFloat fromBackViewX = kSpace;
        CGFloat fromBackViewY = CGRectGetMaxY(_contentFrame)+kSpace;
        CGFloat fromBackViewW = screenWidth-2*kSpace;
        CGFloat fromBackViewH = 0;
        if (model.imgs.count) {
            fromBackViewH = CGRectGetMaxY(_imageListViewFrame)+kSpace;
        }else{
            fromBackViewH = CGRectGetMaxY(_fromContentFrame)+kSpace;
        }
        
        _fromBackViewFrame = CGRectMake(fromBackViewX, fromBackViewY, fromBackViewW, fromBackViewH);
        
    }
    
    //工具条
    CGFloat boomBarX = 0;
    CGRect tempF;
    if (![model.fromname isEqualToString:@""]){
        
        tempF = _fromBackViewFrame;
    
    }else{
        
        if (model.imgs.count) {
            tempF = _imageListViewFrame;
        }else{
            tempF = _contentFrame;
        }
        
    }
    CGFloat boomBarY = CGRectGetMaxY(tempF) + kSpace;
    CGFloat boomBarH = 31;
    CGFloat boomBarW = screenWidth;
    _boomBarFrame = (CGRect){{boomBarX, boomBarY}, {boomBarW,boomBarH}};
    
    //点赞viewframe
    CGFloat likeuserViewX = 0;
    CGFloat likeuserViewY = CGRectGetMaxY(_boomBarFrame);
    CGFloat likeuserViewW = screenWidth;
    CGFloat likeuserViewH = 30;
    _likeuserViewFrame = CGRectMake(likeuserViewX, likeuserViewY, likeuserViewW, likeuserViewH);
    
    //初始化评论列表（与我相关）总高度
    int allCommentCellHeight = 0;
    
    //只有与我相关才有commentlist这个属性
    if (self.cellType==CellTypeRelated) {
        
        //先把模型转换过来
        WeiQiangRelatedModel *relateModel = (WeiQiangRelatedModel *)model;
        
        //最多5个评论加进去
        for (int i = 0; i<relateModel.commentlist.count; i++) {
            
            if (i<5) {
                
                BGWQCommentCellFrame *commentF = relateModel.commentlist[i];
                allCommentCellHeight = allCommentCellHeight+commentF.cellHight;
            }
            
            
        }
        
    }
    
    //评论列表（与我相关）
    CGFloat commentX = 0;
    CGFloat commentY = CGRectGetMaxY(_likeuserViewFrame);
    CGFloat commentW = screenWidth;
    CGFloat commentH = allCommentCellHeight;
    _commentViewFrame = CGRectMake(commentX, commentY, commentW, commentH);
    
    //根据不同的类型计算cell的高度
    if (self.cellType==CellTypeRelated) {
        
        _cellHight = CGRectGetMaxY(_commentViewFrame)+10;
        
    }else{
        
        _cellHight = CGRectGetMaxY(_boomBarFrame)+10;
        
    }
    

}

-(id)initWithModel:(weiQiangModel*)model cellType:(CellType)cellType
{
    if(self = [super init])
    {
        self.cellType=cellType;
        self.model = model;
        
    }
    return self;
}

//nsnumber转换成NSString
-(NSString *)getIntWithNSNumber:(NSNumber *)nsnumber{
    
    double x = [nsnumber doubleValue];
    int distance = 0;
    NSString *distanceStr = @"";
    
    if (x>1000) {
        
        x = x/1000.00000000;
        distance = (int)(x<0 ? x-0.5 : x+0.5);
        distanceStr = [NSString stringWithFormat:@"%dkm",distance];
        
    }else{
        
        distance = (int)(x<0 ? x-0.5 : x+0.5);
        distanceStr = [NSString stringWithFormat:@"%dm",distance];
    }
    
    return distanceStr;
    
}

@end
