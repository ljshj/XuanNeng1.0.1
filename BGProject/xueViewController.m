



//
//  xueViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-29.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "SVProgressHUD.h"

#import "FDSUserManager.h"
#import "UIAlertView+Zhangxx.h"
#import "xueViewController.h"
#import "FDSUserCenterMessageManager.h"

#define kBloodTypeTag 0xFF000
@interface xueViewController ()

@end

@implementation xueViewController

{
    UIView    *topView;
    UIButton  *backBtn;
    
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UIButton *btn4;
    
    UIView *barrView;
    
    NSArray *bloodArr;
    NSString* _bloodType;
    
    BGUser* _user;
    
    UIButton* submitButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        bloodArr = [NSArray arrayWithObjects:@"A型",@"B型",@"O型",@"AB型",nil];
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
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(140, 24, 80, 40)];
    label1.text = @"血型";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    [self.view addSubview:topView];
    
    
    UIView *bot = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 320, 160)];
    bot.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bot];
    
    for (int i = 0; i < 4;  i ++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10+i*40, 40, 20)];
        label.text = bloodArr[i];
        label.tag = 0xfe + i;
        [bot addSubview:label];
    }
    btn1 = [[UIButton alloc]initWithFrame:CGRectMake(280,12, 16.5, 16.5)];
    [btn1 setImage:[UIImage imageNamed:@"注册协议未选中"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"注册协议选中"] forState:UIControlStateSelected];
    btn1.tag = 0 + kBloodTypeTag;
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bot addSubview:btn1];
    
    btn2 = [[UIButton alloc]initWithFrame:CGRectMake(280,52, 16.5, 16.5)];
    [btn2 setImage:[UIImage imageNamed:@"注册协议未选中"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"注册协议选中"] forState:UIControlStateSelected];
    btn2.tag = 1 + kBloodTypeTag;
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bot addSubview:btn2];
    
    btn3 = [[UIButton alloc]initWithFrame:CGRectMake(280,92, 16.5, 16.5)];
    [btn3 setImage:[UIImage imageNamed:@"注册协议未选中"] forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"注册协议选中"] forState:UIControlStateSelected];
    btn3.tag = 2 + kBloodTypeTag;
    [btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bot addSubview:btn3];
    
    btn4= [[UIButton alloc]initWithFrame:CGRectMake(280,132, 16.5, 16.5)];
    [btn4 setImage:[UIImage imageNamed:@"注册协议未选中"] forState:UIControlStateNormal];
    [btn4 setImage:[UIImage imageNamed:@"注册协议选中"] forState:UIControlStateSelected];
    btn4.tag = 3 + kBloodTypeTag;
    [btn4 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bot addSubview:btn4];
    int btnTag = [self getIndexByType:_user.btype];
    UIButton* btn = (UIButton*)[bot viewWithTag:btnTag];
    if([btn isKindOfClass:[UIButton class]]) {
            btn.selected = YES;
    } else {
        // error tag@!!
        NSLog(@"error tag@!!");
    }
    
    
    for (int  i = 0; i < 4 ; i++) {
        barrView =[[UIView alloc]initWithFrame:CGRectMake(0, 40.5*i, 320, 0.5)];
        barrView.tag = 0xff00+i;
        barrView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        [bot addSubview:barrView];
    }
    
    
    CGFloat submitButtonY = CGRectGetMaxY(bot.frame)+20;
    submitButton =[[UIButton alloc]initWithFrame:CGRectMake(10,submitButtonY, 300, 40)];
    [submitButton setTitle:@"确认" forState:UIControlStateNormal];
    
    [submitButton setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(onSubmitClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:submitButton];

    
    
}

#pragma mark btnClick===================

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnClick:(UIButton *)sender
{
    btn1.selected = NO;
    btn2.selected = NO;
    btn3.selected = NO;
    btn4.selected = NO;
    sender.selected = YES;
    _bloodType = [self getTypeWithInt:sender.tag];
    
}
- (void)viewDidLoad
{
    _user = [[FDSUserManager sharedManager] getNowUser];

    [super viewDidLoad];
    [self CreatTopView];
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    
}



-(void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    
    
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
    [SVProgressHUD popActivity];
}

-(void)viewWillAppear:(BOOL)animated     {
    [super viewWillAppear:animated];
    
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
}

-(void)onSubmitClick:(UIButton*)sender {
    
       if(_bloodType==nil) {
           
//           [UIAlertView showMessage:@"血型不对"];
               [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"血型不对"];
       } else {
           [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
           [[FDSUserCenterMessageManager sharedManager]updateBtype:_bloodType];
       }
   
}



-(void)upDateUserInfoCB:(int)returnCode {
    [SVProgressHUD popActivity];
    if(returnCode==0) {
        [self.navigationController popViewControllerAnimated:YES];
            _user.btype = _bloodType;
    } else {
//        [UIAlertView showMessage:@"血型修改失败"];
           [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"血型修改失败"];
    }
}

-(NSString*)getTypeWithInt:(int)index {
    index -= kBloodTypeTag;
    NSString* type = bloodArr[index];
    return type;
}

-(int)getIndexByType:(NSString*)bloodType {

    for(int i=0; i<[bloodArr count]; i++) {
        if([bloodType isEqualToString:bloodArr[i]]) {
            _bloodType = bloodType;
            return i+kBloodTypeTag;
        }
    }
    return 0;
}

@end
