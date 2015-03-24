//
//  localManagerViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "localManagerViewController.h"
#import "downloanManagerViewController.h"
#import "AppDelegate.h"
@interface localManagerViewController ()

@end

@implementation localManagerViewController

{
    UIImageView *imgView ;
    UIView      *topView ;
    UIButton   *backBtn;
    UITextField *tf;
    UIButton *rightBackBtn;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    [app hiddenTabelBar];
}

-(void)CreatView
{
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 24, 120, 40)];
    label1.text = @"本地应用管理";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    [self.view addSubview:topView];
    
    
    rightBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(260, 24, 40, 40)];
    [rightBackBtn setImage:[UIImage imageNamed:@"右上角"] forState:UIControlStateNormal];
    [rightBackBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightBackBtn];

    
    tf= [[UITextField alloc]initWithFrame:CGRectMake(10, topView.frame.origin.y+topView.frame.size.height+10, 300, 30)];
    tf.delegate = self;
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.placeholder = @"请输入搜索内容";
    
    
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 22)];
    imageView.image =[UIImage imageNamed:@"添加好友_06"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(40, 0, 1, 44)];
    lineView.backgroundColor =[UIColor grayColor];
    lineView.alpha = 0.2;
    
    UIView *bigView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 41, 44)];
    
    
    [bigView addSubview:imageView];
    [bigView addSubview:lineView];
    
    tf.leftView = bigView;
    tf.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:backBtn];
    [self.view addSubview:tf];
    
}


#pragma mark btn---------------

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnClick:(UIButton *)sender
{
    downloanManagerViewController *dowm = [[downloanManagerViewController  alloc  ]init];
    [self.navigationController pushViewController:dowm animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self CreatView];
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
}

#pragma mark uitextfiedDelegate---
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tf resignFirstResponder ];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
