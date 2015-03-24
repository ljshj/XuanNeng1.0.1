//
//  ChatItemFrame.m
//  BGProject
//
//  Created by liao on 14-12-15.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ChatItemFrame.h"
#define IconWH 35

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation ChatItemFrame

-(void)setItem:(ChatItem *)item{
    
    _item=item;
    
    //计算出内容的长度
    CGSize contentSize = [item.content boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]} context:nil].size;
    
    //右边头像
    CGFloat rightIconW = IconWH;
    CGFloat rightIconX = ScreenWidth-rightIconW-10;
    CGFloat rightIconY = 10;
    CGFloat rightIconH = IconWH;
    _rightIconFrame = CGRectMake(rightIconX, rightIconY, rightIconW, rightIconH);
    
    //右边标签
    CGFloat rightLabelX = 10;
    CGFloat rightLabelY = 10;
    CGFloat rightLabelW = contentSize.width;
    CGFloat rightLabelH = contentSize.height;
    _rightLabelFrame = CGRectMake(rightLabelX, rightLabelY, rightLabelW, rightLabelH);
    
    if (item.type==TypeVoice) {
        
        //右边的语音按钮
        CGFloat rightVoiceX = 10;
        CGFloat rightVoiceY = 10;
        CGFloat rightVoiceW = 30;
        CGFloat rightVoiceH = 30;
        _rightVoiceFrame = CGRectMake(rightVoiceX, rightVoiceY, rightVoiceW, rightVoiceH);
        
    }
    
    
    //右边气泡
    CGFloat rightBubbleW = 0;
    CGFloat rightBubbleX = 0;
    CGFloat rightBubbleY = 0;
    CGFloat rightBubbleH = 0;
    if (item.type==TypeText) {
        
        rightBubbleW = rightLabelW+30;
        rightBubbleX = rightIconX-rightBubbleW-5;
        rightBubbleY = 10;
        rightBubbleH = rightLabelH+20;
        
    }else if(item.type==TypeImage){
        
        rightBubbleW = item.thumbnailSize.width+30;
        rightBubbleX = rightIconX-rightBubbleW-5;
        rightBubbleY = 10;
        rightBubbleH = item.thumbnailSize.height+20;
        
    }else{
        
        rightBubbleW = _rightVoiceFrame.size.width+30;
        rightBubbleX = rightIconX-rightBubbleW-5;
        rightBubbleY = 10;
        rightBubbleH = _rightVoiceFrame.size.height+20;
        
    }
    
    _rightBubbleFrame = CGRectMake(rightBubbleX, rightBubbleY, rightBubbleW, rightBubbleH);
    
    //右边图片预览图
    if (item.type==TypeImage) {
        
        CGFloat rightThumX = 10;
        CGFloat rightThumY = 10;
        CGFloat rightThumW = item.thumbnailSize.width;
        CGFloat rightThumH = item.thumbnailSize.height;
        _rightThumFrame = CGRectMake(rightThumX, rightThumY, rightThumW, rightThumH);
        
        
    }
    
    //左边头像
    CGFloat leftIconX = 10;
    CGFloat leftIconY = 10;
    CGFloat leftIconW = IconWH;
    CGFloat leftIconH = IconWH;
    _leftIconFrame = CGRectMake(leftIconX, leftIconY, leftIconW, leftIconH);
    
    //左边标签
    CGFloat leftLabelX = 20;
    CGFloat leftLabelY = 10;
    CGFloat leftLabelW = contentSize.width;
    CGFloat leftLabelH = contentSize.height;
    _leftLabelFrame = CGRectMake(leftLabelX, leftLabelY, leftLabelW, leftLabelH);
    
    if (item.type==TypeVoice) {
        
        //右边的语音按钮
        CGFloat leftVoiceX = 20;
        CGFloat leftVoiceY = 10;
        CGFloat leftVoiceW = 30;
        CGFloat leftVoiceH = 30;
        _leftVoiceFrame = CGRectMake(leftVoiceX, leftVoiceY, leftVoiceW, leftVoiceH);
        
    }
    
    //左边气泡
    CGFloat leftBubbleW = rightBubbleW;
    CGFloat leftBubbleX = CGRectGetMaxX(_leftIconFrame)+5;
    CGFloat leftBubbleY = 10;
    CGFloat leftBubbleH = rightBubbleH;
    _leftBubbleFrame = CGRectMake(leftBubbleX, leftBubbleY, leftBubbleW, leftBubbleH);
    
    //左边图片预览图
    if (item.type==TypeImage) {
        
        CGFloat leftThumX = 20;
        CGFloat leftThumY = 10;
        CGFloat leftThumW = item.thumbnailSize.width;
        CGFloat leftThumH = item.thumbnailSize.height;
        _leftThumFrame = CGRectMake(leftThumX, leftThumY, leftThumW, leftThumH);
        
        
    }
    
    if (item.type==TypeText) {
        
        _cellHeight= contentSize.height+30;
        
    }else if(item.type==TypeImage){
        
        _cellHeight= item.thumbnailSize.height+30;
        
    }else{
        
       _cellHeight= _leftVoiceFrame.size.height+30;
        
    }
   
    
    
}

-(instancetype)initWithChatItem:(ChatItem*)item{
    if(self = [super init])
    {
        self.item = item;
    }
    return self;
}


@end
