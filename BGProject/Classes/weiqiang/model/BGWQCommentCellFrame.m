//
//  BGWQCommentCellFrame.m
//  BGProject
//
//  Created by liao on 14-11-4.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "BGWQCommentCellFrame.h"




@implementation BGWQCommentCellFrame
-(void)setModel:(BGWQCommentModel *)model {
    _model = model;
    
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width;
    
    //1.头像
    CGFloat photoX = kCommentCellMargin;
    CGFloat photoY = kCommentCellMargin;
    CGFloat photoW = kPhotoHW;
    CGFloat photoH = kPhotoHW;
    _photoFrame = CGRectMake(photoX,photoY,photoW,photoH);
    
    //2.昵称
    CGFloat nameX = CGRectGetMaxX(_photoFrame)+kCommentCellMargin;
    CGFloat nameY = kCommentCellMargin*1.2;
    CGSize nameSize = [self sizeWithText:model.name font:TLNameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _nameFrame = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    
    //3.评论时间
    CGFloat commenttimeX = nameX;
    CGFloat commenttimeY = CGRectGetMaxY(_nameFrame)+kCommentCellMargin*0.5;
    CGSize timeSize = [self sizeWithText:model.commenttime font:TLTimeFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _timeFrame = CGRectMake(commenttimeX, commenttimeY, timeSize.width, timeSize.height);
    
    //4.评论内容
    CGFloat contentX = nameX;
    CGFloat contentY = CGRectGetMaxY(_photoFrame)+kCommentCellMargin*0.2;
    CGFloat contentMaxW = cellWidth-_timeFrame.origin.x-2*kCommentCellMargin;
    CGSize contentSize = [self sizeWithText:model.content font:TLContentFont maxSize:CGSizeMake(contentMaxW, MAXFLOAT)];
    _contentFrame = CGRectMake(contentX, contentY, contentSize.width, contentSize.height);
    
    //cell高度
    _cellHight = CGRectGetMaxY(_contentFrame)+kCommentCellMargin;
    
    //5.分割线
    CGFloat dividerX = 0;
    CGFloat dividerY = _cellHight-1;
    CGFloat dividerW = cellWidth;
    CGFloat dividerH = 1;
    _dividerFrame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
    
    
    
    
}

-(id)initWithModel:(BGWQCommentModel*)model
{
    if(self = [super init])
    {
        self.model = model;
    }
    return self;
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
