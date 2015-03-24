
//  MakeSureSercretViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ZZUserDefaults.h"

#import "MakeSureSercretViewController.h"
#import "FDSUserCenterMessageManager.h"
#import "AppDelegate.h"
#import "NSString+TL.h"
#import "EaseMob.h"

@interface MakeSureSercretViewController ()

@end

@implementation MakeSureSercretViewController
{
    UITextField *tf;    // 输入密码
    UITextField *tf1;   // 再次确认密码
    UITextField *tf2;
    UIView *topView;
    UIButton *backBtn;
    UIButton *overBtn;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//注册
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    //隐藏导航栏并且注册代理
    self.navigationController.navigationBarHidden = YES;
    
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];

}

-(void)viewWillDisappear:(BOOL)animated {
    //去除代理
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
    [super viewWillDisappear:animated];
    
    
}

-(void)CreatView
{
    //自定义导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    //返回按钮
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    //导航栏标签
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 24, 100, 40)];
    label1.text = @"输入新密码";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    
    [topView addSubview:backBtn];
    [topView addSubview:label1];
    [self.view addSubview:topView];
    
    //输入密码
    tf= [[UITextField alloc]initWithFrame:CGRectMake(10, topView.frame.origin.y+topView.frame.size.height+20, 300, 44)];
    tf.delegate = self;
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.placeholder = @"请输入您的密码";
    [self.view addSubview:tf];
    
    //再次输入框
    tf1= [[UITextField alloc]initWithFrame:CGRectMake(10, tf.frame.origin.y+tf.frame.size.height+20, 300, 44)];
    tf1.delegate = self;
    tf1.borderStyle = UITextBorderStyleRoundedRect;
    tf1.placeholder = @"请再次输入您的密码";
    [self.view addSubview:tf1];
    
    //昵称输入框
    tf2= [[UITextField alloc]initWithFrame:CGRectMake(10, tf1.frame.origin.y+tf1.frame.size.height+20, 300, 44)];
    tf2.delegate = self;
    tf2.borderStyle = UITextBorderStyleRoundedRect;
    tf2.placeholder = @"请输入你的昵称";
    [self.view addSubview:tf2];
    
    //登录按钮
    overBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, tf2.frame.origin.y+tf2.frame.size.height + 30, 300, 44)];
    [overBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    [overBtn addTarget:self action:@selector(onBtnClickRegister:) forControlEvents:UIControlEventTouchUpInside];
    [overBtn  setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    [self.view addSubview:overBtn];
}
#pragma mark btnClik________________
-(void)BackMainMenu:(UIButton *)sender
{
   
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onBtnClickRegister:(UIButton *)sender
{
    [tf resignFirstResponder ];
    [tf1 resignFirstResponder];
    [tf2 resignFirstResponder];

    if([self userInputValide]) {
        
        // userid到底是什么东东？哪里被第一次初始化？哥，这是注册后得到的能能号
        FDSUserCenterMessageManager* manager = [FDSUserCenterMessageManager sharedManager];
        
        //密码md5加密
        NSString *MD5PassWord = [NSString md5:tf.text];
        
        //发送登录消息
        [manager userRegisterWithPhoneNum:self.phoneNum
                                   userid:tf2.text
                                      pwd:MD5PassWord];

        
    } else {
        UIAlertView* alert = [[UIAlertView  alloc]initWithTitle:@"注意" message:@"密码输入错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }





}

#pragma mark textFied---------

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
 
    
    [tf resignFirstResponder ];
    [tf1 resignFirstResponder];
    [tf2 resignFirstResponder];
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self CreatView];
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
}

-(void)userRegisterCB:(NSDictionary *)dic {
    
    BOOL isSuccess = [dic[kSuccessKey] boolValue];
    
    // 注册成功
    if(isSuccess) {
        //尼玛的，在这里被害死了！！
        //注册成功返回的userid，用来注册环信
        NSString* userid = [NSString stringWithFormat:@"%d",[dic[kUseridKey] intValue]];
        NSString* phoneNum = self.phoneNum;
        NSString* token = dic[kTokenKey];
        NSString* bServer = dic[kBserverKey];
        NSString* fServer = dic[kFserverKey];
        
        //统计成功注册
        [MobClick event:@"sys_register_done"];
        
        // 自动登录
        [[FDSUserCenterMessageManager sharedManager]userLogin:phoneNum :[NSString md5:tf.text]];
        
    } else {
        //注册失败
    }
    
    
}

// 用户注册完后，自动登录。
-(void)userLoginCB:(NSDictionary*)dic {
    
    BOOL isSuccess = [dic[kSuccessKey] boolValue];
    
    // 注册成功
    if(isSuccess) {
        NSString* userid = dic[kUseridKey];
        NSString* token = dic[kTokenKey];
        NSString* bServer = dic[kBserverKey];
        NSString* fServer = dic[kFserverKey];

        //TODO:: 完成后，暂时没有更新usermanage的状态。
//        AppDelegate *app = [UIApplication sharedApplication].delegate;
//        app.isONload = YES;
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        //save user and pwd(没保存起来)
        [ZZUserDefaults setUserDefault:USER_COUNT :self.phoneNum];
        
        [ZZUserDefaults setUserDefault:USER_PASSWORD :[NSString md5:tf.text]];
        
    } else {
        //注册失败
    }
}



-(BOOL)userInputValide {
    // 判断用户输入两次密码有效
    return YES;
}
@end
