//
//  RegisterViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//  mession:001 完成用户注册信息，以及信息的回调

#import "RegisterViewController.h"
#import "RegistrSubpageViewController.h"


#import "FDSUserCenterMessageManager.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
{
    UITextField *tf;
    UIButton *btn1; // 勾选按钮
    UIButton *btn2; // 注册按钮
    
    UIView *topView;
    UIButton *backBtn;
    
    BOOL _isClick;
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
    //自定义导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    //返回按钮
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    //导航栏标签
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(140, 24, 40, 40)];
    label1.text = @"注册";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    
    [topView addSubview:backBtn];
    [topView addSubview:label1];
    [self.view addSubview:topView];
    
    //手机好输入框
    tf= [[UITextField alloc]initWithFrame:CGRectMake(10, topView.frame.origin.y+topView.frame.size.height+30, 300, 44)];
    tf.delegate = self;
    //设置键盘类型
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.placeholder = @"请输入您的11位手机号";
    //debug
    tf.text = @"";
    [self.view addSubview:tf];
    
    //注册协议选中
    btn1 = [[UIButton alloc]initWithFrame:CGRectMake(10, tf.frame.origin.y+tf.frame.size.height+25, 16.5, 16.5)];
    //默认选中
    _isClick = YES;
    [btn1 setImage:[UIImage imageNamed:@"注册协议选中"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(BtnClik:) forControlEvents:UIControlEventTouchUpInside];
    
    //协议标签
    UILabel *labale =[[UILabel alloc]initWithFrame:CGRectMake(30, btn1.frame.origin.y-2, 140, 20)];
    labale.text  = @"已阅读并同意心想能成";
    labale.font =[UIFont systemFontOfSize:14];
    
    //注册使用协议，不是一个按钮吗？？
    UILabel *labele1 = [[UILabel alloc]initWithFrame:CGRectMake(labale.frame.origin.x+labale.frame.size.width, labale.frame.origin.y, 140, 20)];
    labele1.text = @"<注册使用协议>";
    labele1.font = [UIFont systemFontOfSize:14];
    labele1.textColor = [UIColor redColor];
    
    [self.view addSubview:btn1];
    [self.view addSubview:labale];
    [self.view addSubview:labele1];
    
    // 注册按钮设置
    btn2 = [[UIButton alloc]initWithFrame:CGRectMake(10, labale.frame.origin.y+labale.frame.size.height+20, 300, 44)];
    [btn2 setTitle:@"心想事成欢迎你" forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    btn2.imageEdgeInsets = UIEdgeInsetsMake(5, 200, 5, 0);
    btn2.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 100);
    [btn2 addTarget:self action:@selector(BtnClikSubRegister:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    [self.view addSubview:btn2];
}
#pragma mark btnclick___------------

-(void)BtnClik:(UIButton *)sender
{
    _isClick = !_isClick;
    if (_isClick) {
        [btn1 setImage:[UIImage imageNamed:@"注册协议选中"] forState:UIControlStateNormal];
    }
    else
    {
        [btn1 setImage:[UIImage imageNamed:@"注册协议未选中"] forState:UIControlStateNormal];
    }

    
}

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 用户注册-获取注册码
-(void)BtnClikSubRegister:(UIButton *)sender
{
    
    if ([self isValidStr:tf.text]&&_isClick==YES)
    {
        
        //统计注册获取验证码
        [MobClick event:@"sys_resgiter_verifycode_click"];
        
        // 发送注册信息
        [[FDSUserCenterMessageManager sharedManager]userRequestVerifyCode:tf.text];
    }
    else
    {
        //弹出对话框
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"警告" message:@"请输入合法的手机号码并阅读<注册使用协议>" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self CreatView];
    
    //注册通知(如果重复注册接收到的通知)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registrPhoneNumAgainNoti)
                                                 name:@"PhoneNumberRegisterAgain" object:nil];
    
    //背景颜色设置
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
}

-(void)registrPhoneNumAgainNoti{
    
    //修改布尔值，号码已经注册过
    self.isPhoneNumRegisterAgain = YES;
    
    //提示框
    [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"该号码已注册"];
    
}


//这到底是神马跟神马？？
-(BOOL)isValidStr:(NSString*)string {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:string] == YES)
        || ([regextestcm evaluateWithObject:string] == YES)
        || ([regextestct evaluateWithObject:string] == YES)
        || ([regextestcu evaluateWithObject:string] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}



#pragma mark -
#pragma mark cb

-(void)viewWillAppear:(BOOL)animated {
    
    
    
    //注册代理
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    
    
    //去掉代理
    [[FDSUserCenterMessageManager sharedManager] unRegisterObserver:self];
}

- (void)userRequestVerifyCodeCB:(NSString*)result :(NSString*)authCode :(NSString*)timeout {
    
    //如果是重复注册就不跳到下一个控制器了
    if (self.isPhoneNumRegisterAgain) {
        
        self.isPhoneNumRegisterAgain = NO;
        
        return;
        
    }
    
    RegistrSubpageViewController *regiserSub =[[RegistrSubpageViewController alloc]init];
    
    //拿到号码还有验证码
    regiserSub.phoneNum = tf.text;
    regiserSub.verfyCode = authCode;
    
    [self.navigationController pushViewController:regiserSub animated:YES];
}
@end
