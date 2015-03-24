



//
//  ForgotEndViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//
#import "AppDelegate.h"
#import "ForgotEndViewController.h"
#import "UIAlertView+Zhangxx.h"
#import "NSString+TL.h"
#import "FDSPublicManage.h"
@interface ForgotEndViewController ()

@end

@implementation ForgotEndViewController

{
    UITextField *tf;
    UITextField *tf1;
    
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    self.navigationController.navigationBarHidden = YES;
    
    //注册消息
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];

}

-(void)viewWillDisappear:(BOOL)animated {
    
    
    
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
    
}


-(void)CreatView
{
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 24, 100, 40)];
    label1.text = @"输入新密码";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    
    [topView addSubview:backBtn];
    [topView addSubview:label1];
    [self.view addSubview:topView];
    
    
    tf= [[UITextField alloc]initWithFrame:CGRectMake(10, topView.frame.origin.y+topView.frame.size.height+15, 300, 44)];
    tf.delegate = self;
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.placeholder = @"请输入您的密码";
    [self.view addSubview:tf];
    
    tf1= [[UITextField alloc]initWithFrame:CGRectMake(10, tf.frame.origin.y+tf.frame.size.height+15, 300, 44)];
    tf1.delegate = self;
    tf1.borderStyle = UITextBorderStyleRoundedRect;
    tf1.placeholder = @"请再次输入您的密码";
    [self.view addSubview:tf1];
    
    overBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, tf1.frame.origin.y+tf1.frame.size.height + 25, 300, 44)];
    [overBtn setTitle:@"完成" forState:UIControlStateNormal];
    [overBtn addTarget:self action:@selector(onBtnClickSendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [overBtn setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    [self.view addSubview:overBtn];
}
#pragma mark btnClik________________
-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 发送更新密码的请求
-(void)onBtnClickSendMessage:(UIButton *)sender
{
    
    if([self isPwdInvalid]) {
        
        //密码md5加密
        NSString *MD5PassWord = [NSString md5:tf.text];
        
        //发送修改密码请求
        [[FDSUserCenterMessageManager sharedManager]userResetPWDWithUserID:_phoneNum pwd:MD5PassWord];
        
    } else {
        // do nothing
    }
//    [self.navigationController popToRootViewControllerAnimated:YES];
//
//    if ([tf.text isEqualToString:tf1.text]&&tf.text &&tf1.text)
//    {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    else
//    {
//        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"警告" message:@"密码必须相同且不能为空" delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"取消", nil];
//        [alert show];
//    }
}

#pragma mark textFed---------

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tf resignFirstResponder ];
    [tf1 resignFirstResponder];
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self CreatView];
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 判断用户输入的密码是否有效
-(BOOL)isPwdInvalid {
    if([tf.text length]==0||[tf1.text length] == 0) {
//        [UIAlertView showMessage:@"请输入两次密码"];
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"请输入两次密码"];
        return  NO;
    }
    if(![tf.text isEqualToString:tf1.text]) {
//        [UIAlertView showMessage:@"输入的两次密码不一致"];
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"输入的两次密码不一致"];
        return NO;
    }
    
    if([tf.text length]<6 || [tf1.text length]<6) {
//         [UIAlertView showMessage:@"密码的长度不能小于6"];
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"密码的长度不能小于6"];
        return NO;
    }
    return YES;
}

//修改密码回调
-(void)userResetPwdForForgetPwdCB:(NSDictionary*)dic {
    NSLog(@"%s--%@",__func__, dic);
    BOOL isSucced = [dic[kSuccessKey] boolValue];
    if(isSucced) {
        
        //统计修改密码成功
        [MobClick event:@"sys_forget_pwd_modify_click"];
        
        // 发送登录请求
        NSString* userid = dic[kUseridKey];
        
        //MD5加密
        NSString *MD5PassWord = [NSString md5:tf.text];
        
        [[FDSUserCenterMessageManager sharedManager]userLogin:userid :MD5PassWord];
    } else {
//        [UIAlertView showMessage:@"修改密码失败!,请重试"];
           [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"修改密码失败!,请重试"];
    }
}


// 处理登录后的回掉
-(void)userLoginCB:(NSDictionary*)dic {
    BOOL isSuccess = [dic[kSuccessKey] boolValue];
    if(isSuccess) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {

         [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"自动登录失败"];
        
    }
}



@end
