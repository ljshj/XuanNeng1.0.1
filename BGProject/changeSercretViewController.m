
//
//  changeSercretViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//
#import "UIAlertView+Zhangxx.h"
#import "changeSercretViewController.h"
#import "changeNextViewController.h"

#import "FDSPublicManage.h"
#import "FDSUserCenterMessageInterface.h"
#import "FDSUserCenterMessageManager.h"
#import "SVProgressHUD.h"

#import "FDSUserManager.h"
#import "ZZUserDefaults.h"
#import "NSString+TL.h"

@interface changeSercretViewController ()<UserCenterMessageInterface>

-(void)requestChangePWDCB:(int)returnCode;
@end

@implementation changeSercretViewController
{
    UIView   *topView;
    UIButton *backBtn;
    
    UITextField *tf;    //原始密码
    UITextField *tf1;   // 新密码
    UITextField *tf2;   // 确认新密码
    UIButton    *netBtn;
    
    //新密码（MD5加密过的）
    NSString *_MD5NewPassWord;
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
    UILabel  *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    label.text = @"修改密码";
    label.textColor = TITLECOLOR;
    label.font = TITLEFONT;
    [topView addSubview:label];
    
    [self.view addSubview:topView];
    
    //原密码输入框
    tf= [[UITextField alloc]initWithFrame:CGRectMake(10, topView.frame.origin.y+topView.frame.size.height+15, 300, 44)];
    tf.delegate = self;
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.placeholder = @"请输入您的原密码";
    tf.secureTextEntry = YES;
    [self.view addSubview:tf];
    
    //输入新密码
    tf1= [[UITextField alloc]initWithFrame:CGRectMake(10, tf.frame.origin.y+tf.frame.size.height+10, 300, 44)];
    tf1.delegate = self;
    tf1.borderStyle = UITextBorderStyleRoundedRect;
    tf1.placeholder = @"请再次输入您的新密码";
     tf1.secureTextEntry = YES;
    [self.view addSubview:tf1];
    
    //输入新密码
    tf2= [[UITextField alloc]initWithFrame:CGRectMake(10, tf1.frame.origin.y+tf1.frame.size.height+10, 300, 44)];
    tf2.delegate = self;
    tf2.borderStyle = UITextBorderStyleRoundedRect;
    tf2.placeholder = @"请再次输入您的新密码";
     tf2.secureTextEntry = YES;
    [self.view addSubview:tf2];
    
    //确认按钮
    netBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, tf2.frame.origin.y+tf2.frame.size.height + 25, 300, 44)];
    [netBtn setTitle:@"确认" forState:UIControlStateNormal];
    [netBtn addTarget:self action:@selector(changePWD:) forControlEvents:UIControlEventTouchUpInside];
    [netBtn setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    [self.view addSubview:netBtn];

}

#pragma mark btn-=========

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 用于输入密码后确认
-(void)changePWD:(UIButton *)sender
{
    
    if([self isInputValid]) {
        
        //将键盘放下去
        [tf  resignFirstResponder];
        [tf1 resignFirstResponder];
        [tf2 resignFirstResponder];
        
        //爆菊花
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        
        //把密码MD5加密
        NSString *MD5NewPassWord = [NSString md5:tf1.text];
        _MD5NewPassWord = MD5NewPassWord;
        NSString *MD5OldPassWord = [NSString md5:tf.text];
        
        //发送修改密码消息，把新旧密码发送过去
        [[FDSUserCenterMessageManager sharedManager]requestChangeToNewPWD:MD5NewPassWord
                                                                   oldPWD:MD5OldPassWord];
        
    } else {

         [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"输入新密码错误"];
    }
}

#pragma mark btn------------

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tf  resignFirstResponder];
    [tf1 resignFirstResponder];
    [tf2 resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self CreatTopView];
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadView {
    UIControl* view = [[UIControl alloc]init];
    [view addTarget:self action:@selector(hiddenKeyboardByTouchSpace:) forControlEvents:UIControlEventTouchDown];
    
    self.view = view;
    
}

-(void)  hiddenKeyboardByTouchSpace:(id) sender {
    [tf  resignFirstResponder];
    [tf1 resignFirstResponder];
    [tf2 resignFirstResponder];
}



-(void)viewWillAppear:(BOOL)animated {
    
    
    
    // step 注册键盘显示和隐藏的notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    
    // 注册消息
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
    [SVProgressHUD popActivity];
}



- (void)showKeyboard:(NSNotification*) notification {
    
    // 获取notification 中的字典 userInfo
    NSDictionary* userInfo =   [notification userInfo];
    // 查看起所有key，以找到合适的key。调试用的
    // NSArray* keys = [userInfo allKeys];NSLog(@"Keys:%@",keys);
    NSValue* frameValue = [userInfo valueForKey:UIKeyboardBoundsUserInfoKey];
    CGRect frame = [frameValue CGRectValue];
    
    // 计算被重叠的高度
    for(UIView* subview in [self.view subviews]) {
        if([subview isKindOfClass:[UIButton class]]) {
            if(YES ) {
                // 找到被点击的TextField
                CGFloat keyboardY = [UIScreen mainScreen].bounds.size.height - frame.size.height;
                
                CGFloat viewMaxY = CGRectGetMaxY(subview.frame);
                
                CGFloat offset = viewMaxY - keyboardY + 15;
                
                // 移动view
                if(offset > 0) {
                    [UIView animateWithDuration:0.4 animations:^{
                        CGRect viewFrame = self.view.frame;
                        viewFrame.origin.y -= offset;
                        [self.view setFrame:viewFrame];
                    }];
                }
                
            }
        }
    }

}

-(void)hiddenKeyboard:(NSNotification*) notification {
 
    //
    [UIView animateWithDuration:0.4 animations:^{
        CGRect viewFrame = self.view.bounds;
        [self.view setFrame:viewFrame];
    }];
}

// 判断用户输入新密码是否有效
-(BOOL)isInputValid {
    
    //检查三个输入框是否为空
    if([tf.text length]==0 || [tf1.text length] == 0 || [tf2.text length] == 0)
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"密码不能为空"];
        return false;
    }
    
    //查看两次输入新密码是否一致
    if(![tf1.text isEqualToString:tf2.text])
    {
       [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"确认密码和新密码不一致"];
    }
    
    return  YES;
}

//密码修改回调
-(void)requestChangePWDCB:(int)returnCode
{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if(returnCode == 0)
    {
        //切换视图控制器
        [self.navigationController popViewControllerAnimated:YES];
        
        //先从上次的账号中提取出userCount，改密码，账号没变的
        NSString *userCount  =  [ZZUserDefaults getUserDefault:USER_COUNT];
        
        // 修改密码后重新登录,需不需要重新登录？万一控制器切换过去了，又用旧的数据怎么办
        BGUser* user =  [[FDSUserManager sharedManager]getNowUser];
        
        [FDSUserManager sharedManager].isChangePassWord = YES;
        
        //修改密码成功后再次登录(MD5加密)
        [[FDSUserCenterMessageManager sharedManager] userLogin:userCount :_MD5NewPassWord];
        
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view
                                              MESSAGE:@"修改密码失败:原始密码输入错误"];
    }
    
}
@end
