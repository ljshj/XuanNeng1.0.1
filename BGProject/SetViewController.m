//
//  SetViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "SetViewController.h"
#import "AppDelegate.h"
@interface SetViewController ()

@end

@implementation SetViewController

{
    UIView    *topView;
    UIButton  *backBtn;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    AppDelegate  *app = [UIApplication sharedApplication].delegate;
    [app hiddenTabelBar];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self CreatTopView];
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
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
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(140, 24, 40, 40)];
    label1.text = @"设置";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    [self.view addSubview:topView];
    
    
    
}

#pragma mark btnClick===================

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)s1change:(id)sender
{
     NSLog(@"做点什么呢 ！");
}
- (IBAction)s2change:(id)sender
{
     NSLog(@"做点什么呢 ！");
}
- (IBAction)s3change:(id)sender
{
     NSLog(@"做点什么呢 ！");
}
- (IBAction)s4change:(id)sender
{
     NSLog(@"做点什么呢 ！");
}
- (IBAction)s5change:(id)sender
{
     NSLog(@"做点什么呢 ！");
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
