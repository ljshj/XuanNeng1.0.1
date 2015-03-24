//
//  ButtonsView.m
//  FOURBUTTON
//
//  Created by ssm on 14-9-26.
//  Copyright (c) 2014年 com.ssm. All rights reserved.
//

#import "BottomBar.h"

#import "ZZItemButton.h"
#define kDividerColor [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1]

@implementation BottomBar

-(id)init {
    if(self = [super init]) {
        //设置背景颜色
        [self setBackgroundColor:[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1]];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1].CGColor;
    }
    return self;
}

//添加按钮
-(void)addButtonWithIcon:(NSString *)icon title:(NSString *)title
{
   
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"tabBarHightedImage"] forState:UIControlStateHighlighted];
    button.titleEdgeInsets = UIEdgeInsetsMake(2, 3, 0, 0);
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
     
    [self addSubview:button];
    
}


//设置标题
-(void)setText:(NSString*) text AtIndex:(int)index {
    if(index>=[self.subviews count])
        return;
    text = [ NSString stringWithFormat:@" %@",text];
    UIButton* btn = self.subviews[index];
    if([btn isKindOfClass:[UIButton class]]) {
        [btn setTitle:text forState:UIControlStateNormal];
    }
}

//调整子控件的坐标
-(void)setFrame:(CGRect)frame {
   
    
    [super setFrame:frame];
    //reset views frame;
    CGRect bound = self.bounds;
    
    for (UIView *view in self.subviews) {
        if (view.tag == 200) {
            [view removeFromSuperview];
        }
    }
    
    int count = [self.subviews count];
    CGFloat width = bound.size.width/count;
    CGFloat height = bound.size.height;
    
    //添加按钮
    for(int i=0; i<count; i++ ) {
        
        UIButton* btn = self.subviews[i];
        //btn.backgroundColor = [UIColor redColor];
        btn.tag = i;
        
        CGFloat btnX = width*i;
        CGFloat btnY = 0;
        //CGFloat btnW = width-10;
        CGFloat btnW = width-1;
        CGFloat btnH = height;
        
        CGRect btnFrame = CGRectMake(btnX,btnY, btnW,btnH);
        
        if (i != count-1) {
            
            //添加分割线
            UIView *divider = [[UIView alloc] init];
            divider.backgroundColor = kDividerColor;
            divider.tag = 200;
            //CGFloat dividerX = CGRectGetMaxX(btnFrame)+4;
            CGFloat dividerX = CGRectGetMaxX(btnFrame);
            CGFloat dividerY = 5;
            CGFloat dividerW = 1;
            CGFloat dividerH = self.frame.size.height-5*2;
            divider.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
            
            [self addSubview:divider];
            
        }
    
        [btn setFrame:btnFrame];
    }
    
    
    
}


-(void)onBtnClick:(UIButton*)btn
{
    if([_delegate respondsToSelector:@selector(bottomBar:didClickButtonAtIndex:)])
    {
        //回调
        [_delegate bottomBar:self didClickButtonAtIndex:btn.tag];
    }
}
@end
