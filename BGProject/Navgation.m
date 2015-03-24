//
//  Navgation.m
//  BGProject
//
//  Created by zhuozhongkeji on 14-9-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "Navgation.h"

@implementation Navgation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)initView:(NSString*)title
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    label1.text = title;
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    [self addSubview:topView];
}
-(void)BackMainMenu:(UIButton *)sender
{
//    UIViewController * viewController = (UIViewController*)self.superview;
//    [viewController.navigationController popViewControllerAnimated:YES];
    if(self.m_delete != nil)
    {
        if([self.m_delete respondsToSelector:@selector(buttonCallCB:)])
        {
            [self.m_delete buttonCallCB:0];
        }
    }
}
-(void)initView:(NSString*)leftButton :(NSString*)title:(NSString*)rightButton
{
    
}
@end
