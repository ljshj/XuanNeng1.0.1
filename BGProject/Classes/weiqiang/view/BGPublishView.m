//
//  BGPublishView.m
//  BGProject
//
//  Created by liao on 14-11-4.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "BGPublishView.h"

#define kCommentFieldTextColor [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0]
#define kPublishViewBorderColor [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0].CGColor
#define kPublishButtonTitleColor [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1.0]
#define kCommentFieldFont [UIFont systemFontOfSize:12]

@interface BGPublishView()
/**
 *  发表按钮
 */
@property (nonatomic, weak) UIButton *publishButton;
/**
 *  弹出对话框
 */
@property (nonatomic, strong) UIAlertView *alertView;

@end
@implementation BGPublishView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = kPublishViewBorderColor;
        
        //输入框
        UITextField *commentField = [[UITextField alloc] init];
        commentField.backgroundColor = kCommentFieldTextColor;
        commentField.borderStyle = UITextBorderStyleRoundedRect;
        commentField.font = kCommentFieldFont;
        commentField.delegate = self;
        [self addSubview:commentField];
        self.commentField = commentField;
        
        //发表按钮
        UIButton *publishButton = [[UIButton alloc] init];
        [publishButton setTitleColor:kPublishButtonTitleColor forState:UIControlStateNormal];
        [publishButton setTitle:@"发表" forState:UIControlStateNormal];
        [publishButton addTarget:self action:@selector(publishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publishButton];
        self.publishButton = publishButton;
        
    }
    return self;
}

//发表按钮被点击
-(void)publishButtonClick:(UIButton *)button{
    if ([self.commentField.text isEqualToString:@""]) {
        //弹出对话框
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"温性提示" message:@"输入内容不能为空,请重新输入" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        self.alertView = alertView;
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss) userInfo:nil repeats:NO];
        [alertView show];
    }else{
        if ([self.delegate respondsToSelector:@selector(didSelectedPublishButton:)]) {
            NSString *text = nil;
            if ([self.commentField.placeholder isEqualToString:PlaceholderComment]||[self.commentField.placeholder isEqualToString:PlaceholderFrom]) {
                text = self.commentField.text;
                
            }else{
                //去掉用户输入的空格，否则@那里会把后面的内容也当作是用户名的一部分
                NSString *newFieldText = [self.commentField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                text = [NSString stringWithFormat:@"%@%@",self.commentField.placeholder,newFieldText];
            }
            
            [self.delegate didSelectedPublishButton:text];
        }
    }
    
    
}

//将提示框放下去
-(void)performDismiss{
    
    [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
    self.alertView = nil;
    
}

//调整子控件的位置
-(void)layoutSubviews{
    
    //输入框
    CGFloat commentFieldX = 25;
    CGFloat commentFieldY = 10;
    CGFloat commentFieldW = self.frame.size.width-70-commentFieldX;
    CGFloat commentFieldH = self.frame.size.height-2*commentFieldY;
    self.commentField.frame = CGRectMake(commentFieldX, commentFieldY, commentFieldW, commentFieldH);
    
    //发表按钮
    CGFloat publishButtonX = CGRectGetMaxX(self.commentField.frame)+5;
    CGFloat publishButtonY = 10;
    CGFloat publishButtonW = self.frame.size.width-publishButtonX-5;
    CGFloat publishButtonH = commentFieldH;
    self.publishButton.frame = CGRectMake(publishButtonX, publishButtonY, publishButtonW, publishButtonH);
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //NSLog(@"要开始编辑");
    return YES;
}

@end
