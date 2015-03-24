//
//  enditNextViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-29.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "enditNextViewController.h"
#import "AppDelegate.h"
@interface enditNextViewController ()

@end

@implementation enditNextViewController

{
    UIView    *topView;
    UIButton  *backBtn;
    
    UIButton  *netBtn;
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
    
    
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    [app hiddenTabelBar];
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
    label1.text = @"编辑产品";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    [self.view addSubview:topView];
    
    netBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 420, 300, 44)];
    [netBtn setTitle:@"确定修改" forState:UIControlStateNormal];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteImage:(id)sender
{
    _imageView.image = [UIImage imageNamed:@"2"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self CreatTopView];
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
