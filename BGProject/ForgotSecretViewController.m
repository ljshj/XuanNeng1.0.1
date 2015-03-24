


//
//  ForgotSecretViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ForgotSecretViewController.h"
#import "ForgotNextViewController.h"
#import "UIAlertView+Zhangxx.h"
@interface ForgotSecretViewController ()

@end

@implementation ForgotSecretViewController
{
    UITextField *tf;
    
    UIView *topView;
    UIButton *backBtn;
    UIButton *fontBtn;
    
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
    
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    
    
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    [self CreatView];
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
}

-(void)setPassValueBlock:(myBlock)newBlock
{
    passValueBlock = newBlock;
}

-(void)pushController:(myBlock)block
{
    if (passValueBlock) {
        passValueBlock(self);
    }
}

-(void)CreatView
{
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    
    fontBtn = [[UIButton alloc]initWithFrame:CGRectMake(260, 24, 60, 40)];
    [fontBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [fontBtn setTitleColor:TITLECOLOR forState:UIControlStateNormal];
    [fontBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    fontBtn.titleLabel.font =[UIFont systemFontOfSize:12];
    
    UILabel  *label = [[UILabel alloc]initWithFrame:CGRectMake(130, 24, 80, 40)];
    label.text = @"忘记密码";
    label.textColor = TITLECOLOR;
    label.font = TITLEFONT;
    
    [topView addSubview:backBtn];
    [topView addSubview:label];
    [topView addSubview:fontBtn];
    [self.view addSubview:topView];
    

    
    tf= [[UITextField alloc]initWithFrame:CGRectMake(10, topView.frame.origin.y+topView.frame.size.height+35, 300, 44)];
    tf.delegate = self;
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.keyboardType = UIKeyboardTypePhonePad;
    tf.placeholder = @"请输入您使用的手机号";
    [self.view addSubview:tf];
}

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//按钮
-(void)BtnClick:(UIButton *)sender
{
    //判断内容是否合法
    NSString* phoneNum = tf.text;
    //
    if ([self isValid:phoneNum])
    {

        //TODO::请求验证码
        [[FDSUserCenterMessageManager sharedManager]
         userRequestVerifyCodeForForgetPWD:phoneNum];
       
    }
    else
    {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"警告" message:@"没有输入手机号或手机号不合法" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}



#pragma mark ----blcok




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 判断用户输入的数据是否有效
-(BOOL)isValid:(NSString*)phoneNum {
   return  [phoneNum length]==11;
}


//用户发送手机号后的返回
-(void)userRequestVerifyCodeForForgetPWDCB:(NSDictionary*)dic {
    NSLog(@"%s dic:%@",__func__, dic );
    
    // 获取验证码
    NSString* verfy = dic[kVerfyKey];
    if([verfy length]>0) {
        
        ForgotNextViewController *next =[[ForgotNextViewController alloc]init];
        next.recStr = tf.text;
        next.verfy = verfy;
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@",tf.text]]];
        [self.navigationController pushViewController:next animated:YES];
        
    } else {
        [UIAlertView showMessage:@"请求验证码失败!"];
    }
    
}
@end
