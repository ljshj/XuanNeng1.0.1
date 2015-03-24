//
//  LikeuserView.m
//  BGProject
//
//  Created by liao on 14-12-5.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "LikeuserView.h"
#import "NSString+TL.h"

@interface LikeuserView()

/**
 *  点赞图标
 */
@property (nonatomic, weak) UIImageView *likeIcon;

@end

@implementation LikeuserView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //点赞图标
        UIImageView *likeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"赞"]];
        [self addSubview:likeIcon];
        self.likeIcon = likeIcon;
        
        //设置边框颜色
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1].CGColor;
        
    }
    return self;
}

-(void)setLikeUserList:(NSArray *)likeUserList{
    
    _likeUserList = likeUserList;
    
    //所有按钮相加的长度
    int allWidth = 0;
    
    //显示点赞数的按钮
    UIButton *countButton = [[UIButton alloc] init];
    NSString *countTitle = [NSString stringWithFormat:@"等%d人点赞",likeUserList.count];
    [countButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    countButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
    [countButton setTitle:countTitle forState:UIControlStateNormal];
    [self addSubview:countButton];
    
    for (int i=0; i<likeUserList.count; i++) {
        
        UIButton *button = [[UIButton alloc] init];
        button.tag = i+100;
        
        //取出模型
        LikeUser *user = likeUserList[i];
        
        //设置标题
        NSString *title = [NSString stringWithFormat:@"%@、",user.nicename];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11.0];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        CGSize titleSize = [NSString sizeWithText:title font:[UIFont systemFontOfSize:11.0] maxSize:CGSizeMake(1000, 20)];
        
        //拿出前一个按钮
        int preTag = i+100-1;
        UIButton *prebutton = (UIButton *)[self viewWithTag:preTag];
        
        //设置坐标
        CGFloat buttonW = titleSize.width;
        allWidth += buttonW;
        CGFloat buttonX = 0;
        if (i==0) {
            
            buttonX = (_likeIcon.image.size.width+10);
            
        }else{
            
            buttonX = CGRectGetMaxX(prebutton.frame);
            
        }
        CGFloat buttonH = 20;
        CGFloat buttonY = 6;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        
        if (allWidth<220) {
            
            [self addSubview:button];
            
            CGFloat countButtonX = CGRectGetMaxX(button.frame)-6;
            CGFloat countButtonY = buttonY;
            CGFloat countButtonW = 60;
            CGFloat countButtonH = 20;
            countButton.frame = CGRectMake(countButtonX, countButtonY, countButtonW, countButtonH);
            
            
        }
    
    }
    
}

-(void)layoutSubviews{
    
    //点赞图标
    CGFloat likeIconX = 5;
    CGFloat likeIconW = _likeIcon.image.size.width;
    CGFloat likeIconH = _likeIcon.image.size.height;
    CGFloat likeIconY = (self.frame.size.height-likeIconH)/2;
    _likeIcon.frame = CGRectMake(likeIconX, likeIconY, likeIconW, likeIconH);
    
}

@end
