





//
//  phoneViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "phoneViewController.h"

@interface phoneViewController ()

@end

@implementation phoneViewController
{
    UIView    *topView;
    UIButton  *backBtn;
    UITextView *tv;
    UILabel  *label;
    UIButton *netBtn;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)CreatTopView
{
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    label1.text = @"我想";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    [self.view addSubview:topView];
    
    tv = [[UITextView alloc]initWithFrame:CGRectMake(10, topView.frame.origin.y+topView.frame.size.height+10, 300, 60)];
    tv.delegate = self;
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 30)];
    label.text = @"请输入你的手机号";
    label.enabled = NO;
    label.backgroundColor =[UIColor clearColor];
    [tv addSubview:label];
    [self.view addSubview:tv];
    
    netBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, tv.frame.origin.y+tv.frame.size.height + 10, 300, 44)];
    [netBtn setTitle:@"确定" forState:UIControlStateNormal];
    [netBtn addTarget:self action:@selector(nextPage:) forControlEvents:UIControlEventTouchUpInside];
    [netBtn setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    [self.view addSubview:netBtn];
}

#pragma mark btnClick===================

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nextPage:(UIButton *)sender
{
    // 发送修改请求
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self CreatTopView];
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
}

#pragma mark textviewDelegate----
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        label.text = @"请输入正文";
    }
    else
    {
        label.text = @"";
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [tv resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
