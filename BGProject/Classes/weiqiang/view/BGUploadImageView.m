//
//  BGUploadImageView.m
//  BGProject
//
//  Created by liao on 14-11-1.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "BGUploadImageView.h"

@implementation BGUploadImageView{
    __weak UIButton *_deleteButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //开启交互
        self.userInteractionEnabled = YES;
        
        //添加删除按钮
        UIButton *deleteButton = [[UIButton alloc] init];
        //deleteButton.backgroundColor = [UIColor redColor];
        [deleteButton setImage:[UIImage imageNamed:@"deleteButton"] forState:UIControlStateNormal];
        [self addSubview:deleteButton];
        [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton = deleteButton;
    }
    return self;
}
-(void)layoutSubviews{
    
    //调整删除按钮的坐标
    CGFloat deleteX = self.frame.size.height-20;
    CGFloat deleteY = -5;
    CGFloat deleteW = 25;
    CGFloat deleteH = 25;
    CGRect deleteF = CGRectMake(deleteX,deleteY ,deleteW , deleteH);
    _deleteButton.frame = deleteF;
}

//输出按钮被点击
-(void)deleteButtonClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(didSelectedDeleteButtonWithIndex:)]) {
        [self.delegate didSelectedDeleteButtonWithIndex:self.tag];
    }
}

@end
