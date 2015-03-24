//
//  myXuanNengViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "myXuanNengViewController.h"
#import "AppDelegate.h"
#import "humousViewController.h"
@interface myXuanNengViewController ()

@end

@implementation myXuanNengViewController

{
    UIImageView *imgView ;
    UIView      *topView ;
    UIButton   *backBtn;
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
    
    
    
    AppDelegate  *app = [UIApplication sharedApplication].delegate;
    [app hiddenTabelBar];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self CreatView];
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
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
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    if (self.xuanNengType==XuanNengTypeOther) {
        
        label1.text = @"TA的炫能";
        
    }else{
        
        label1.text = @"我的炫能";
        
    }
    
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    [self.view addSubview:topView];
    
    imgView  = [[UIImageView alloc]initWithFrame:CGRectMake(10, topView.frame.origin.y+topView.frame.size.height+10, 60, 60)];
    imgView.image = [UIImage imageNamed:@"幽默秀"];
    [self.view addSubview:imgView];
    imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTarget:)];
    [imgView addGestureRecognizer:tap];
    
    UILabel  *label2 = [[UILabel alloc]initWithFrame:CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y+imgView.frame.size.height+5, imgView.frame.size.width, 40)];
    label2.text = @"幽默秀";
    label2.textAlignment = UITextAlignmentCenter;
    label2.textColor = [UIColor blackColor];
    label2.font =[UIFont systemFontOfSize:16];
    [self.view addSubview:label2];
}

#pragma mark btn----------

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tapTarget:(UITapGestureRecognizer *)sender
{
    //没请求数据，直接飞过去啊？
    humousViewController   *xuan =[[humousViewController  alloc]init];
    
    xuan.userid = self.userid;
    
    if (self.xuanNengType==XuanNengTypeOther) {
        
        xuan.humousType=HumousTypeOther;
        
    }else{
        
        xuan.humousType=HumousTypeMy;
        
    }
    
    [self.navigationController pushViewController:xuan animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
