//
//  SegmentationView.m
//  BGProject
//
//  Created by liao on 14-12-1.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "SegmentationView.h"

@implementation SegmentationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.tag=-1;
        
        self.backgroundColor = [UIColor whiteColor];
        
        NSArray *titleArray = [NSArray arrayWithObjects:@"立即关注", @"加为好友", @"发起会话", nil];
        
        for (int i=0; i<3; i++) {
            
            UIButton *button = [[UIButton alloc] init];
            button.tag=i;
            NSString *imgName = [NSString stringWithFormat:@"card_operation_%d",i+1];
            [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            if (button.tag==0) {
                [button setTitle:@"已关注" forState:UIControlStateSelected];
            }else if (button.tag==1){
                
                [button setTitle:@"已是好友" forState:UIControlStateSelected];
                
            }
            
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:13.0];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            button.layer.borderWidth = 2;
            button.layer.borderColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0].CGColor;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
        }
        
        //注册通知(修改按钮的状态)
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(setupFocusButtonStaus)
                                                     name:SetupFocusButtonStausKey object:nil];
        
    }
    return self;
}


-(void)setupFocusButtonStaus{
    
    UIButton *focusButton = (UIButton *)[self viewWithTag:0];
    focusButton.selected = !focusButton.selected;
    
}

-(void)setIsFriend:(BOOL)isFriend{
    
    _isFriend = isFriend;
    
    //如果是好友了，那就修改标题，并且不可点
    if (isFriend) {
        
        UIButton *friendButton = (UIButton *)[self viewWithTag:1];
        friendButton.selected = YES;
        
        //不可点击，先留着，以后再做点击后移除好友关系
        //friendButton.enabled = NO;
        
    }
    
}

-(void)setIsguanzhu:(BOOL)isguanzhu{
    
    _isguanzhu = isguanzhu;
    
    //如果已经关注,那就修改标题
    if (isguanzhu) {
        
        UIButton *focusButton = (UIButton *)[self viewWithTag:0];
        focusButton.selected = YES;
    }
    
}

-(void)layoutSubviews{
    
    CGFloat buttonW = self.frame.size.width/3;
    CGFloat buttonY = 0;
    CGFloat buttonH = self.frame.size.height;
    
    for (int i=0; i<3; i++) {
        
        UIButton *button = self.subviews[i];
        CGFloat buttonX = buttonW*i;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
    }
    
}

//输出按钮被点击
-(void)buttonClick:(UIButton *)button{
    
    if (button.tag==0) {
        
        [self.delegate didSelectedButtonWithIndex:button.tag staus:button.selected];
        return;
        
    }
    
    if ([self.delegate respondsToSelector:@selector(didSelectedButtonWithIndex:)]) {
        
        if (button.selected) {
            
            //提示框（如果已经是好友就不发送回调了，提示一下就行了）
            [[FDSPublicManage sharePublicManager] showInfo:[UIApplication sharedApplication].keyWindow MESSAGE:@"你们已是好友"];
            
            return;
            
        }
        [self.delegate didSelectedButtonWithIndex:button.tag];
    }
}

-(void)dealloc{
    
    //删除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SetupFocusButtonStausKey object:nil];
    
}

@end
