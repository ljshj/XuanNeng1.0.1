//
//  PersonViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//  debug登录  完成登录页面的协议

// 登录按钮的tag
#define kBtnTagLogin 0x1
#import "AppDelegate.h"
#import "FDSUserManager.h"

#import "ZZUserDefaults.h"

#import "PersonViewController.h"
#import "ForgotSecretViewController.h"
#import "RegisterViewController.h"
#import "FirstViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "FDSUserCenterMessageManager.h"
#import "NSString+TL.h"
#import "PlatformMessageManager.h"

#define requestContactDataKey @"requestContactDataAgain"

@interface PersonViewController ()<PlateformMessageInterface>
@property(nonatomic,copy)NSString* account;//账号
@property(nonatomic,copy)NSString* password;//密码
@end

@implementation PersonViewController
{
    UIView *topView;
    UIButton *backBtn;
    
    
    UITextField *tf1;   // 帐号
    UITextField *tf2;   // 密码
    UIButton *btn1; // 忘记密码
    UIButton *btn2; // 登录按钮
    UIButton *btn3; // 注册按钮
 
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
    
    
    
    NSLog(@"%@",self.navigationController.viewControllers);
    //如果已经登录,则不显示该页面
    //初始化中心
    FDSUserManager* userManager = [FDSUserManager sharedManager];
    
    //如果状态是已登录，将控制器弹出栈
    if([userManager getNowUserState] == USERSTATE_LOGIN) {
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    
    //注册代理
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
    [[PlatformMessageManager sharedManager] registerObserver:self];
    
    //将返回按钮隐藏起来
    self.navigationItem.hidesBackButton = NO;
    
    //获得代理对象
    AppDelegate *delegaet =[UIApplication sharedApplication].delegate;
    
    if (self.isAppearBackBtn) {
        
        //将tabbar显示出来
        [delegaet hiddenTabelBar];
        
        
    }else{
        
        //将tabbar显示出来
        [delegaet showTableBar];
        
    }
    

}


-(void)viewWillDisappear:(BOOL)animated {
    
    
    
    //关掉菊花
    [SVProgressHUD popActivity];
    
    //去掉代理
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
    [[PlatformMessageManager sharedManager] unRegisterObserver:self];

}

-(void)CreatMainMenue
{
    
    //导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    //返回按钮，登录页面加个返回按钮干啥？？后面隐藏掉了
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    //默认是隐藏起来的
    backBtn.hidden = !self.isAppearBackBtn;
    
    
    //导航栏标签
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(140, 24, 40, 40)];
    label1.text = @"登录";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    
    [topView addSubview:backBtn];
    [topView addSubview:label1];
    [self.view addSubview:topView];
    
    //账号输入框
    tf1 =[[UITextField alloc]initWithFrame:CGRectMake(10, topView.frame.origin.y+topView.frame.size.height+30, 300, 46)];
    tf1.borderStyle = UITextBorderStyleRoundedRect;
    tf1.placeholder =  @"请输入能能号或手机号";
    
    
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 17.5, 18)];
    imageView.image =[UIImage imageNamed:@"账号"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //分割线
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(40, 0, 1, 46)];
    lineView.backgroundColor =[UIColor grayColor];
    lineView.alpha = 0.2;
    
    //干嘛会个背景视图
    UIView *bigView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 41, 44)];
    [bigView addSubview:imageView];
    [bigView addSubview:lineView];
    tf1.delegate = self;
    tf1.leftView = bigView;
    tf1.leftViewMode = UITextFieldViewModeAlways;
    
    //密码背景视图
    tf2 =[[UITextField alloc]initWithFrame:CGRectMake(10, tf1.frame.origin.y+tf1.frame.size.height+20, 300, 44)];
    UIImageView *imageView1 =[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 17.5, 18)];
    tf2.borderStyle = UITextBorderStyleRoundedRect;
    tf2.placeholder = @"请输入您的密码";
    tf2.secureTextEntry = YES;
    
    
    imageView1.image =[UIImage imageNamed:@"密码"];
    imageView1.contentMode = UIViewContentModeScaleAspectFit;
    
    //分割线
    UIView *lineView1 =[[UIView alloc]initWithFrame:CGRectMake(40, 0, 1, 44)];
    lineView1.backgroundColor =[UIColor grayColor];
    lineView1.alpha = 0.2;
    
    //背景视图
    UIView *bigView1 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 41, 44)];
    
    [bigView1 addSubview:imageView1];
    [bigView1 addSubview:lineView1];
    tf2.delegate = self;
    tf2.leftView = bigView1;
    tf2.leftViewMode = UITextFieldViewModeAlways;
 
    //先从上次的账号中提取，用的是封装NSUserDefaults
    tf1.text  =  [ZZUserDefaults getUserDefault:USER_COUNT];
    tf2.text =   [ZZUserDefaults getUserDefault:USER_PASSWORD];
    
    //忘记密码按钮
    btn1 = [[UIButton alloc]initWithFrame:CGRectMake(240, tf2.frame.origin.y+tf2.frame.size.height+5, 80, 30)];
    [btn1 setTitle:@"忘记密码" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn1.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    UIView *barreLineView =[[UIView alloc]initWithFrame:CGRectMake(12, 23, 56, 1)];
    barreLineView.backgroundColor = [UIColor blueColor];
    [btn1 addSubview:barreLineView];
 
    
    //登录按钮
    btn2 = [[UIButton alloc]initWithFrame:CGRectMake(10, btn1.frame.origin.y+btn1.frame.size.height+10, 300, 46)];
    btn2.tag = kBtnTagLogin;
    [btn2 setTitle:@"登录" forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"登录按钮点击"] forState:UIControlStateSelected];
    [btn2 addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //注册按钮
    btn3 = [[UIButton alloc]initWithFrame:CGRectMake(10, btn2.frame.origin.y+btn2.frame.size.height+20, 300, 46)];
    [btn3 setTitle:@"注册" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(btnZhuCe:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"注册按钮"] forState:UIControlStateNormal];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"注册按钮点击"] forState:UIControlStateSelected];
    
    [self.view addSubview:tf1];
    [self.view addSubview:tf2];
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
    [self.view addSubview:btn3];
}
#pragma mark BtnClick______________


-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//忘记密码
-(void)BtnClick:(UIButton *)sender
{
    
    //统计成功注册
    [MobClick event:@"sys_forget_pwd_click"];
    
    ForgotSecretViewController *forget =[[ForgotSecretViewController  alloc]init];
    [self.navigationController pushViewController:forget animated:YES];
}

-(void)btnZhuCe:(UIButton *)sender
{
    
    //统计注册
    [MobClick event:@"sys_register_click"];
    
    //注册控制器
    RegisterViewController *regiser =[[RegisterViewController alloc]init];
    [self.navigationController pushViewController:regiser animated:YES];
}
#pragma mark textFiedDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tf1 resignFirstResponder];
    [tf2 resignFirstResponder];
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.view的背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
 
    [self CreatMainMenue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//把账号密码放在成员变量又没有把它存起来
-(BOOL)isValidLogin {
    
    _account = tf1.text;
    
    //MD5加密
    NSString *MD5PassWord = [NSString md5:tf2.text];
    _password = MD5PassWord;
    
    return YES;
}


#pragma mark -
#pragma mark 所有按钮的触发代码
-(void)onBtnClick:(UIButton*)sender {
    if(sender.tag == kBtnTagLogin) {
        
        //无论哪个处于第一响应者的状态都将键盘放下去
        if ([tf1 isFirstResponder]) {
            
            [tf1 resignFirstResponder];
            
        }
        else if ([tf2 isFirstResponder]) {
            
            [tf2 resignFirstResponder];
            
        }
        
        
        if ([self isValidLogin])
        {
            
            //爆菊花，用户不能点击
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            
            //发送登录消息
            [[FDSUserCenterMessageManager sharedManager]userLogin:self.account :self.password];
            

        }


    }
}

//登录完成的回调
-(void)userLoginCB:(NSDictionary*)dic {
    
    //判断是否成功
    BOOL isLoginSuccess = [dic[kSuccessKey] boolValue];
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //如果为true
    if(isLoginSuccess) {
        
        //TODO::暂时缺少 更新UserManager状态,这里不需要更新，用userManager自行注册更新！！！这是神马东西？？
        
        //ZZUserDefaults将用户名和密码存起来
        [ZZUserDefaults setUserDefault:USER_COUNT    :_account];
        
        //存进去的应该是经过MD5加密的密码
        [ZZUserDefaults setUserDefault:USER_PASSWORD :_password];
        
        [SVProgressHUD showWithStatus:@"正在加载数据……" maskType:SVProgressHUDMaskTypeNone];
        
        //加载聊天数据，请求完再过去，发通知过去不能保证那个时候回调回到那里
        [[PlatformMessageManager sharedManager] requestContactList];
        
        
    } else {
//       //提醒用户
        //[[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"用户名或密码错误"];
        
    }
}

//登录后请求的数据回调
-(void)requestContactListCB:(NSDictionary *)data{
    
    [SVProgressHUD popActivity];
    
    //发送通知（发送刷新好友列表的消息，所有的用户登录都要经过这里，无论是登录还是重新登录都刷一次数据）
    [[NSNotificationCenter defaultCenter]
     postNotificationName:requestContactDataKey object:data];
    
    //将登录控制器弹出栈(分两种情况，一种是没有返回按钮的登录页面，直接返回根控制器，一种是有返回按钮，会返回上一个控制器)
    if (self.isAppearBackBtn) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    
    //发送通知（去掉退出账号那个控制器）
    [[NSNotificationCenter defaultCenter]
     postNotificationName:PopLogoffControllerKey object:nil];
    
}

#pragma mark 删除该Navigation中注册页面


@end
