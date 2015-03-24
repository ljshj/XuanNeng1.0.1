//
//  ChatMoreView.m
//  BGProject
//
//  Created by liao on 14-12-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ChatMoreView.h"
#define ChatMoreViewBg [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0]

@interface ChatMoreView()

/**
 *输入框占位标签
 */
@property (nonatomic, weak) UIButton *photoButton;

@end

@implementation ChatMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //背景颜色
        self.backgroundColor = ChatMoreViewBg;
        
        
        UIButton *photoButton = [[UIButton alloc] init];
        [photoButton setBackgroundImage:[UIImage imageNamed:@"chatPhoto"] forState:UIControlStateNormal];
        [photoButton addTarget:self action:@selector(photoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:photoButton];
        self.photoButton=photoButton;
        
        
        
    }
    return self;
}

//图片按钮被点击
-(void)photoButtonClick{
    
    if ([self.delegate respondsToSelector:@selector(didClickPhotoButton)]) {
        
        
        [self.delegate didClickPhotoButton];
        
        
    }
    
}

-(void)layoutSubviews{
    
    CGFloat photoButtonX = 20;
    CGFloat photoButtonY = 20;
    CGFloat photoButtonW = 50;
    CGFloat photoButtonH = photoButtonW;
    self.photoButton.frame = CGRectMake(photoButtonX, photoButtonY, photoButtonW, photoButtonH);
    
}

@end
