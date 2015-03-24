//
//  GroupExitAndClearView.m
//  BGProject
//
//  Created by liao on 14-12-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "GroupExitAndClearView.h"
#define ClearButtonBg [UIColor colorWithRed:74/255.0 green:182/255.0 blue:221/255.0 alpha:1.0]
#define ExitButtonBg [UIColor colorWithRed:235/255.0 green:33/255.0 blue:46/255.0 alpha:1.0]
#define ClearTitle @"清除聊天记录"
#define ExitTitle @"退出该群"
#define DisbandTitle @"解散该群"

@interface GroupExitAndClearView()

/**
 *清除聊天记录
 */
@property(nonatomic,weak) UIButton *clearButton;
/**
 *退出该群
 */
@property(nonatomic,weak) UIButton *exitButton;

@end

@implementation GroupExitAndClearView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //清除按钮
        UIButton *clearButton = [[UIButton alloc] init];
        clearButton = [self setupButton:clearButton bg:ClearButtonBg title:ClearTitle];
        [clearButton addTarget:self action:@selector(clearButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.clearButton = clearButton;
        
        //退出按钮
        UIButton *exitButton = [[UIButton alloc] init];
        exitButton = [self setupButton:exitButton bg:ExitButtonBg title:ExitTitle];
        [exitButton addTarget:self action:@selector(exitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.exitButton = exitButton;
        
    }
    return self;
}

//是否是群主
-(void)setIsGroupOwer:(BOOL)isGroupOwer{
    
    _isGroupOwer = isGroupOwer;
    
    //如果是群主，修改标题
    if (isGroupOwer) {
        
        [self.exitButton setTitle:DisbandTitle forState:UIControlStateNormal];
        
    }
    
}

//设置按钮
-(UIButton *)setupButton:(UIButton *)button bg:(UIColor *)bg title:(NSString *)title{
    
    button.backgroundColor = bg;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    //设置圆角
    CGFloat radius = 5;
    [button.layer setCornerRadius:radius];
    [button.layer setMasksToBounds:YES];
    
    [self addSubview:button];
    
    return button;
    
}

//清除按钮被点击
-(void)clearButtonClick{
    
    if ([self.delegate respondsToSelector:@selector(didClickClearButton)]) {
        
        
        [self.delegate didClickClearButton];
        
        
    }
    
}

//退出按钮被点击
-(void)exitButtonClick{
    
    if ([self.delegate respondsToSelector:@selector(didClickExitButton)]) {
        
        
        [self.delegate didClickExitButton];
        
        
    }
    
}

-(void)layoutSubviews{
    
    //清除按钮
    CGFloat clearX = 20;
    CGFloat clearY = 30;
    CGFloat clearW = self.frame.size.width-clearX*2;
    CGFloat clearH = 40;
    self.clearButton.frame = CGRectMake(clearX, clearY, clearW, clearH);
    
    //退出按钮
    CGFloat exitX = 20;
    CGFloat exitY = CGRectGetMaxY(self.clearButton.frame)+30;
    CGFloat exitW = self.frame.size.width-exitX*2;
    CGFloat exitH = 40;
    self.exitButton.frame = CGRectMake(exitX, exitY, exitW, exitH);
    
    //修改高度
    CGRect exitClearViewF = self.frame;
    exitClearViewF.size.height = CGRectGetMaxY(self.exitButton.frame)+30;
    self.frame = exitClearViewF;
    
}

@end
