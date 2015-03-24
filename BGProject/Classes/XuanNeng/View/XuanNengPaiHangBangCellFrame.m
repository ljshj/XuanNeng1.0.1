//
//  XuanNengPaiHangBangCellFrame.m
//  BGProject
//
//  Created by ssm on 14-9-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "XuanNengPaiHangBangCellFrame.h"
#import "StatusImageListView.h"
#import "NSString+TL.h"
#import "XNRelatedModel.h"
#import "BGWQCommentCellFrame.h"

#define kSpace 10

#define kIconHeight 45
#define kIconWidth kIconHeight
#define TabBarHeight 49

@implementation XuanNengPaiHangBangCellFrame

//XuanNengPaiHangBangCell 子控件的位置
-(void)setModel:(JokeModel *)model {
    
    _model = model;
    
    //取出这个屏幕的size
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    //计算cell的宽度
    CGFloat cellWidh = screenSize.width-CellMargin*2;
    
    //头像
    CGRect photoFrame = CGRectMake(13, 13, kIconHeight, kIconWidth);
    _photoFrame = photoFrame;
    
    //用户名字的frame
    CGFloat nameX = CGRectGetMaxX(photoFrame) + kSpace;
    CGFloat nameY = photoFrame.origin.y;
    CGSize nameSize = [model.username sizeWithFont:kBigFont forWidth:200 lineBreakMode:NSLineBreakByTruncatingTail];
    CGRect nameFrame = (CGRect){{nameX, nameY},nameSize};
    _nameFrame = nameFrame;
    
    //获奖时间
    CGSize rankDateSize = [NSString sizeWithText:model.opartime font:[UIFont systemFontOfSize:13.0] maxSize:CGSizeMake(200, 20)];
    CGFloat rankDateX = cellWidh-rankDateSize.width-10;
    CGFloat rankDateY = CGRectGetMaxY(nameFrame)+5;
    CGRect rankDateFrame = (CGRect){{rankDateX,rankDateY},rankDateSize};
    _rankDateFrame = rankDateFrame;
    
    //距离图标
    CGFloat distanceTagX = CGRectGetMaxX(nameFrame)+3;
    CGFloat distanceTagY = nameY+3;
    CGFloat distanceTagH = 12;
    CGSize  distanceTagSize = CGSizeMake(distanceTagH, distanceTagH);
    CGRect distanceTagFrame = (CGRect){{distanceTagX,distanceTagY},distanceTagSize};
    _distanceTagFrame = distanceTagFrame;
    
    //距离
    CGFloat distanceX = CGRectGetMaxX(distanceTagFrame)+2.5;
    CGFloat distanceY = distanceTagY-2.5;
    NSString *distance = [self getIntWithNSNumber:model.distance];
    CGSize distanceSize = [NSString sizeWithText:distance font:kMiddleFont maxSize:CGSizeMake(100, 20)];
    CGRect distanceFrame = (CGRect){{distanceX,distanceY},distanceSize};
    _distanceFrame = distanceFrame;
    
    //时间
    CGFloat dateX = nameX;
    CGFloat dateY = CGRectGetMaxY(nameFrame)+5;
        CGSize dateSize = [model.date_time sizeWithFont:kMiddleFont forWidth:200 lineBreakMode:NSLineBreakByTruncatingTail];
    CGRect dateFrame = (CGRect){{dateX,dateY},dateSize};
    _dateFrame = dateFrame;
    
    //内容
    CGFloat contentX =photoFrame.origin.x;
    CGFloat contentY = CGRectGetMaxY(photoFrame) + kSpace;
    CGSize contentSize = [model.content sizeWithFont:kMiddleFont constrainedToSize:CGSizeMake(cellWidh - 2 * kSpace-5, MAXFLOAT)];
    _contentFrame = (CGRect){{contentX, contentY}, contentSize};
    
    //图片列表
    if (model.imgs.count) {
        CGFloat imageListViewX = photoFrame.origin.x;
        CGFloat imageListViewY = CGRectGetMaxY(_contentFrame) + kSpace;
        CGSize imageListViewSize = [StatusImageListView imageSizeWithCount:model.imgs.count];
        _imageListViewFrame = (CGRect){{imageListViewX, imageListViewY}, imageListViewSize};
    }
    
    //工具条
    CGFloat boomBarX = 0;
    CGRect tempF;
    if (model.imgs.count) {
        tempF = _imageListViewFrame;
    }else{
        tempF = _contentFrame;
    }
    CGFloat boomBarY = CGRectGetMaxY(tempF) + kSpace;
    CGFloat boomBarH = 31;
    CGFloat boomBarW = cellWidh;
    _boomBarFrame = (CGRect){{boomBarX, boomBarY}, {boomBarW,boomBarH}};
    
    //点赞viewframe
    CGFloat likeuserViewX = 0;
    CGFloat likeuserViewY = CGRectGetMaxY(_boomBarFrame);
    CGFloat likeuserViewW = cellWidh;
    CGFloat likeuserViewH = 30;
    _likeuserViewFrame = CGRectMake(likeuserViewX, likeuserViewY, likeuserViewW, likeuserViewH);
    
    //初始化评论列表（与我相关）总高度
    int allCommentCellHeight = 0;
    
    //只有与我相关才有commentlist这个属性
    if (self.cellType==CellTypeRelated) {
        
        //先把模型转换过来
        XNRelatedModel *relateModel = (XNRelatedModel *)model;
        
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
    CGFloat commentW = cellWidh;
    CGFloat commentH = allCommentCellHeight;
    _commentViewFrame = CGRectMake(commentX, commentY, commentW, commentH);
    
    //cell的高度
    if (_needHideBottomBar == YES) {
        
        _cellHight = CGRectGetMaxY(_boomBarFrame)+10-_boomBarFrame.size.height;
        
    }else{
        
        //根据不同的类型计算cell的高度
        if (self.cellType==CellTypeRelated) {
            
            _cellHight = CGRectGetMaxY(_commentViewFrame)+10;
            
        }else{
            
            _cellHight = CGRectGetMaxY(_boomBarFrame)+10;
            
        }
        
    }


}

-(id)initWithModel:(JokeModel*)model cellType:(CellType)cellType
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
        
        x = x/100.00000000;
        distance = (int)(x<0 ? x-0.5 : x+0.5);
        distanceStr = [NSString stringWithFormat:@"%dkm",distance];
        
    }else{
        
        distance = (int)(x<0 ? x-0.5 : x+0.5);
        distanceStr = [NSString stringWithFormat:@"%dm",distance];
    }
    
    return distanceStr;
    
}

@end
