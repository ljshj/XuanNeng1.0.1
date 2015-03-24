//
//  AuditBar.m
//  BGProject
//
//  Created by liao on 15-3-13.
//  Copyright (c) 2015年 zhuozhong. All rights reserved.
//

#import "AuditBar.h"
#define Margin 10
#define DividerColor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
#define DividerW self.frame.size.width/3
#define DividerH self.frame.size.height

@interface AuditBar ()
/**
 *原创按钮
 */
@property (nonatomic, weak) UIButton *originalButton;
/**
 *不通过按钮
 */
@property (nonatomic, weak) UIButton *unPassButton;
/**
 *通过按钮
 */
@property (nonatomic, weak) UIButton *passButton;

@end

@implementation AuditBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        UIButton *originalButton = [[UIButton alloc] init];
        originalButton.tag = 2;
        [originalButton setTitle:@"原创" forState:UIControlStateNormal];
        [originalButton setImage:[UIImage imageNamed:@"icon_original"] forState:UIControlStateNormal];
        originalButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [originalButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [originalButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:originalButton];
        self.originalButton = originalButton;
        
        UIButton *unPassButton = [[UIButton alloc] init];
        unPassButton.tag = 0;
        [unPassButton setTitle:@"不通过" forState:UIControlStateNormal];
        [unPassButton setImage:[UIImage imageNamed:@"unbud"] forState:UIControlStateNormal];
        [unPassButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        unPassButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [unPassButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:unPassButton];
        self.unPassButton = unPassButton;
        
        UIButton *passButton = [[UIButton alloc] init];
        passButton.tag = 1;
        [passButton setTitle:@"通过" forState:UIControlStateNormal];
        [passButton setImage:[UIImage imageNamed:@"bud"] forState:UIControlStateNormal];
        passButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [passButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [passButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:passButton];
        self.passButton = passButton;
        
    }
    return self;
}

//按钮被点击
-(void)buttonClick:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(didClickButtonAtIndex:)]) {
        
        [self.delegate didClickButtonAtIndex:button.tag];
        
    }
    
}

//设置分割线
-(void)setupDividerWithIndex:(int)index{
    
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = DividerColor;
    
    divider.frame = CGRectMake(DividerW*index, Margin, 1, self.frame.size.height-Margin*2);
    [self addSubview:divider];
    
}


-(void)layoutSubviews{
    
    self.originalButton.frame = CGRectMake(0, 0, DividerW, DividerH);
    
    //添加分割线
    [self setupDividerWithIndex:1];
    
    self.unPassButton.frame = CGRectMake(CGRectGetMaxX(self.originalButton.frame), 0, DividerW,DividerH);
    
    //添加分割线
    [self setupDividerWithIndex:2];
    
    self.passButton.frame = CGRectMake(CGRectGetMaxX(self.unPassButton.frame), 0, DividerW,DividerH);
    
}

@end
