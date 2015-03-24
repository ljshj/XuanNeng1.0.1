//
//  myThinkViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "myThinkViewController.h"
#import "AppDelegate.h"
#import "FDSUserCenterMessageManager.h"
#import "FDSUserManager.h"
#import "UIAlertView+Zhangxx.h"
#import "SVProgressHUD.h"


#import "FDSPublicManage.h"

@interface myThinkViewController ()

@end

@implementation myThinkViewController
{
    UIView    *topView;
    UIButton  *backBtn;
    UITextView *tv;
    UILabel  *label;
    UIButton *netBtn;
    
    BGUser* user;
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
    
    self.navigationController.navigationBarHidden = YES;
    AppDelegate  *app = [UIApplication sharedApplication].delegate;
    [app hiddenTabelBar];
    
    
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    
    
    [SVProgressHUD popActivity ];
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self CreatTopView];
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    user = [[FDSUserManager sharedManager]getNowUser];
    tv.text = user.ineed;
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
    label1.text = @"我想";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    [self.view addSubview:topView];
    
    tv = [[UITextView alloc]initWithFrame:CGRectMake(10, topView.frame.origin.y+topView.frame.size.height+10, 300, 145)];
    tv.delegate = self;
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 30)];
    if([tv.text length]!=0) {
        label.text = @"请输入你的想法;例如“去旅游”";
    } else {
        label.text = @"";
    }

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


//发送修改的请求
-(void)nextPage:(UIButton *)sender
{
    if([tv.text length]>0) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
         [[FDSUserCenterMessageManager sharedManager]updateINeed:tv.text];
    } else {
//        [UIAlertView showMessage:@"请输入内容"];
      [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"请输入内容"];
        
    }
//    [self.navigationController popViewControllerAnimated:YES];
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


-(void)upDateUserInfoCB:(int)returnCode {
    [SVProgressHUD popActivity];
    if(returnCode==0)
    {
      
        user.ineed = tv.text;
        [self.navigationController popViewControllerAnimated:YES];
    } else {
//        [UIAlertView showMessage:@"修改失败"];
      [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"修改失败"];
    }
    

}

@end
