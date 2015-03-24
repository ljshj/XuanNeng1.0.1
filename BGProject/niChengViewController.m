//
//  niChengViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "niChengViewController.h"

#import "FDSUserCenterMessageManager.h"
#import "FDSUserManager.h"
#import "SVProgressHUD.h"
@interface niChengViewController ()

@end

@implementation niChengViewController

{
    UIView    *topView;
    UIButton  *backBtn;
    UITextView *tv; //用户输入内容
    UILabel  *label;
    UIButton *netBtn;
    
    NSString* _nickName;
    
    BGUser* _user;
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
    
    //导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    //返回按钮
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    //导航栏标签
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(140, 24, 80, 40)];
    label1.text = @"昵称";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    [self.view addSubview:topView];
    
    //输入框
    tv = [[UITextView alloc]initWithFrame:CGRectMake(10, topView.frame.origin.y+topView.frame.size.height+10, 300, 60)];
    tv.delegate = self;
    tv.text = _user.nickn;
    
    //占位标签
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 30)];
    label.enabled = NO;
    label.backgroundColor =[UIColor clearColor];
    if([tv.text length]==0) {
        label.text = @"输入正文";
    }
    [tv addSubview:label];
    [self.view addSubview:tv];
    
    //确定按钮
    netBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, tv.frame.origin.y+tv.frame.size.height + 10, 300, 44)];
    [netBtn setTitle:@"确定" forState:UIControlStateNormal];
    [netBtn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [netBtn setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    [self.view addSubview:netBtn];
}

#pragma mark btnClick===================

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 发送修改昵称请求
-(void)onBtnClick:(UIButton *)sender
{
    if([self isUserInputValid] == YES) {
        [[FDSUserCenterMessageManager sharedManager]updateNickName:tv.text];
    } else {
        
         [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"昵称不能为空"];
    }
  //  [self.navigationController popViewControllerAnimated:YES];
}

//修改昵称回调
-(void)upDateUserInfoCB:(int)returnCode {
    if(returnCode==0) {
        
        //将最新的昵称给用户模型 PS:这里没有请求数据，直接在本地修改了旧数据，既然成功了，请不请求都是一样，省点流量
        _user.nickn = tv.text;
        
        //控制器弹出栈
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"修改失败"];
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //获得用户资料
    _user = [[FDSUserManager sharedManager]getNowUser];
    
    [self CreatTopView];
    
    //背景颜色
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];

}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    
    //注册代理
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated {
   
    [super viewWillDisappear:animated];
    
    
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //去掉注册
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
    
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


-(BOOL)isUserInputValid {
    // 判断用户输入是否有效
    if([tv.text length]<1) {
        return NO;
    }
    return YES;
}
@end
