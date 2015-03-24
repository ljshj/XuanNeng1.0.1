//
//  XuanNengViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "XuanNengViewController.h"
#import "XuanNengMainMenueViewController.h"


#import "AppDelegate.h"

@interface XuanNengViewController ()

@end

@implementation XuanNengViewController
{
    
    UIImageView *imgView ;//图标
    UIView      *topView ;//导航栏
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)CreatView
{
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(140, 24, 40, 40)];
    label1.text = @"炫能";
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    //隐藏导航栏并且将tabbar隐藏
    self.navigationController.navigationBarHidden = YES;
    AppDelegate  *app = (AppDelegate  *)[UIApplication sharedApplication].delegate;
    [app showTableBar];
}

-(void)tapTarget:(UITapGestureRecognizer *)sender
{
    
    [MobClick event:@"xuanneng_joke_click"];
    
    XuanNengMainMenueViewController *xuan =[[XuanNengMainMenueViewController  alloc]init];
    [self.navigationController pushViewController:xuan animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //添加导航栏／图标／标签
    [self CreatView];
    
    
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
