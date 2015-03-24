//
//  modeViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-29.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//


#import "modeViewController.h"
#import "myStoreViewController.h"
#import "FDSPublicManage.h"

@interface modeViewController ()

@end

@implementation modeViewController
{
    UIView    *topView;
    UIButton  *backBtn;
    
    NSString* _colorPath;
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
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 24, 100, 40)];
    label1.text = @"个性化模版";
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


- (IBAction)btn1Click:(UIButton*)sender
{
//    _mainColor = sender.backgroundColor;
    
    //简单粗暴的搞定吧　時間が少しあります。
    int vcCount = [self.navigationController.viewControllers count];
    myStoreViewController* vc = (myStoreViewController*)self.navigationController.viewControllers[vcCount-2];
    vc.mainColor = sender.backgroundColor;
    
    [self writeColor:sender.backgroundColor];
    
    
}

// 2014年10月11日 能不能不要这么傻,每个按钮来一次。
//- (IBAction)btn2Click:(UIButton*)sender
//{
//    _mainColor = sender.backgroundColor;
////    NSLog(@"传颜色");
//}
//- (IBAction)btn3Click:(UIButton*)sender
//{
////    NSLog(@"传颜色");
//    _mainColor = sender.backgroundColor;
//}
//- (IBAction)btn4Click:(UIButton*)sender
//{
////    NSLog(@"传颜色");
//    _mainColor = sender.backgroundColor;
//}

- (void)viewDidLoad
{

    
    [super viewDidLoad];
    
    _colorPath = [FDSPublicManage getColorFilePath];
    [self CreatTopView];
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)writeColor:(UIColor*)bgColor;
{
    CGFloat R, G, B;
    CGColorRef color = [bgColor CGColor];
    int numComponents = CGColorGetNumberOfComponents(color);
    
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(color);
        R = components[0];
        G = components[1];
        B = components[2];
    }
    
    NSNumber* RN = [NSNumber numberWithFloat:R];
    NSNumber* GN = [NSNumber numberWithFloat:G];
    NSNumber* BN = [NSNumber numberWithFloat:B];
    
    NSArray* RGB = @[RN,GN,BN];
    [RGB writeToFile:_colorPath atomically:YES];
    
//    [UIAlertView showMessage:@"修改成功"];
       [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"修改成功"];
    
}
@end
