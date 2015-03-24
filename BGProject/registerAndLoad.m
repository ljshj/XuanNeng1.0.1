//
//  registerAndLoad.m
//  BGProject
//
//  Created by zhuozhong on 14-8-4.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
// 会员登录

//
#import "registerAndLoad.h"
#import "RegisterViewController.h"
#import "ForgotSecretViewController.h"

// 登录按钮的tag
#define kBtnLoginTag 0x01


@implementation registerAndLoad
{
    UIView *topView;
    UIButton *backBtn;
    
    
    UITextField *tf1;
    UITextField *tf2;
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         [self CreatMainMenue];
    }
    return self;
}

static registerAndLoad *manager;
+(registerAndLoad *)shareView
{
    if (!manager) {
        manager = [[registerAndLoad alloc]init];
    
    }
    return manager;
}



-(void)CreatMainMenue
{
    
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(140, 24, 40, 40)];
    label1.text = @"登录";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    
    [topView addSubview:backBtn];
    [topView addSubview:label1];
    [self addSubview:topView];
    
    
    tf1 =[[UITextField alloc]initWithFrame:CGRectMake(10, topView.frame.origin.y+topView.frame.size.height+30, 300, 46)];
    tf1.borderStyle = UITextBorderStyleRoundedRect;
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 17.5, 18)];
    tf1.placeholder =  @"请输入能能号或手机号";
    imageView.image =[UIImage imageNamed:@"账号"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(40, 0, 1, 46)];
    lineView.backgroundColor =[UIColor grayColor];
    lineView.alpha = 0.2;
    
    UIView *bigView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 41, 44)];
    [bigView addSubview:imageView];
    [bigView addSubview:lineView];
    tf1.delegate = self;
    tf1.leftView = bigView;
    tf1.leftViewMode = UITextFieldViewModeAlways;
    
    
    tf2 =[[UITextField alloc]initWithFrame:CGRectMake(10, tf1.frame.origin.y+tf1.frame.size.height+20, 300, 44)];
    UIImageView *imageView1 =[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 17.5, 18)];
    tf2.borderStyle = UITextBorderStyleRoundedRect;
    tf2.placeholder = @"请输入您的密码";
    imageView1.image =[UIImage imageNamed:@"密码"];
    imageView1.contentMode = UIViewContentModeScaleAspectFit;
    
    UIView *lineView1 =[[UIView alloc]initWithFrame:CGRectMake(40, 0, 1, 44)];
    lineView1.backgroundColor =[UIColor grayColor];
    lineView1.alpha = 0.2;
    
    UIView *bigView1 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 41, 44)];
    
    [bigView1 addSubview:imageView1];
    [bigView1 addSubview:lineView1];
    tf2.delegate = self;
    tf2.leftView = bigView1;
    tf2.leftViewMode = UITextFieldViewModeAlways;
    
    
    btn1 = [[UIButton alloc]initWithFrame:CGRectMake(240, tf2.frame.origin.y+tf2.frame.size.height+5, 80, 30)];
    [btn1 setTitle:@"忘记密码" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn1.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    UIView *barreLineView =[[UIView alloc]initWithFrame:CGRectMake(12, 23, 56, 1)];
    barreLineView.backgroundColor = [UIColor blueColor];
    [btn1 addSubview:barreLineView];
    
    
    btn2 = [[UIButton alloc]initWithFrame:CGRectMake(10, btn1.frame.origin.y+btn1.frame.size.height+10, 300, 46)];
    [btn2 setTitle:@"登录" forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    [btn2  setBackgroundImage:[UIImage imageNamed:@"登录按钮点击"] forState:UIControlStateSelected];
    
    
    btn3 = [[UIButton alloc]initWithFrame:CGRectMake(10, btn2.frame.origin.y+btn2.frame.size.height+20, 300, 46)];
    [btn3 setTitle:@"注册" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(btnZhuCe:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"注册按钮"] forState:UIControlStateNormal];
    [btn3  setBackgroundImage:[UIImage imageNamed:@"注册按钮点击"] forState:UIControlStateSelected];
    
    [self addSubview:tf1];
    [self addSubview:tf2];
    [self addSubview:btn1];
    [self addSubview:btn2];
    [self addSubview:btn3];
}
#pragma mark BtnClick______________

-(void)BackMainMenu:(UIButton *)sender
{
    NSLog(@"返回主页");
}

-(void)BtnClick:(UIButton *)sender
{
   __block ForgotSecretViewController *forget =[[ForgotSecretViewController  alloc]init];
}

-(void)btnZhuCe:(UIButton *)sender
{
    RegisterViewController *regiser =[[RegisterViewController alloc]init];
   // [self.navigationController pushViewController:regiser animated:YES];
}
#pragma mark textFiedDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tf1 resignFirstResponder];
    [tf2 resignFirstResponder];
    return YES;
}


#pragma mark -
#pragma 所有按钮的触发的事件
-(void)onBtnClick:(UIButton*)sender {
    if(sender.tag == kBtnLoginTag) {
        // 用户登录
        
    }
}


@end
