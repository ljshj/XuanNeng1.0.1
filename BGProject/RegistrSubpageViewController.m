//
//  RegistrSubpageViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "RegistrSubpageViewController.h"
#import "FDSUserCenterMessageManager.h"
#import "MakeSureSercretViewController.h"

@interface RegistrSubpageViewController ()

@end

@implementation RegistrSubpageViewController
{
    UITextField *tf;
    UIButton *btn2; // 下一步的按钮
    UIView *topView;
    UIButton *backBtn;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)Creatview
{
    //自定义导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    //返回按钮
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    //标签
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(140, 24, 40, 40)];
    label1.text = @"注册";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    
    
    [topView addSubview:backBtn];
    [topView addSubview:label1];
    [self.view addSubview:topView];
    
    //号码标签
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectZero];
    label.text = [NSString stringWithFormat:@"验证码已发送到 %@ 的手机请注意查收",_phoneNum];
    label.numberOfLines = 0;
    CGSize size = CGSizeMake(240, 2000);
    CGSize s = [label.text sizeWithFont:label.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    label.frame = CGRectMake(60, topView.frame.origin.y+topView.frame.size.height+20, s.width, s.height);
    [self.view addSubview:label];
    
    //输入验证码的输入框
    tf= [[UITextField alloc]initWithFrame:CGRectMake(10, label.frame.origin.y+label.frame.size.height+10, 300, 44)];
    tf.delegate = self;
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.placeholder = @"请输入您收到的验证码";
    [self.view addSubview:tf];
    
    //请进按钮
    btn2 = [[UIButton alloc]initWithFrame:CGRectMake(10, tf.frame.origin.y+tf.frame.size.height+20, 300, 44)];
    [btn2 setTitle:@"请进" forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    btn2.imageEdgeInsets = UIEdgeInsetsMake(5, 200, 5, 0);
    btn2.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 100);
    [btn2 addTarget:self action:@selector(BtnClik:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    [self.view addSubview:btn2];
}
#pragma mark btnClick---------------------
-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//用户注册
-(void)BtnClik:(UIButton *)sender
{
    if ([tf.text length]== 0)
    {
        //如果验证码为空就弹出对话框
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"警告"
                                                      message:@"验证码不能为空"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];


    } else if (![tf.text isEqualToString:self.verfyCode]) {
        //如果输入不成功就提示输入错误
        
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"警告"
                                                      message:@"验证码输入错误"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        // 发送注册消息
        FDSUserCenterMessageManager* manager =[FDSUserCenterMessageManager sharedManager];
        [manager userRegister:_phoneNum :tf.text];
        
    }

}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tf resignFirstResponder];
    return  YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //导航栏／号码标签／验证码输入框／请进按钮
    [self Creatview];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//发送验证码回调
- (void)userSendVerifyCB:(NSDictionary*)dic {
    
    //如果kVerfiedKey为1则验证成功
    int returnCode = [dic[@"returnCode"] intValue];
    
    if(returnCode==0) {
        
        MakeSureSercretViewController *markSure =[[MakeSureSercretViewController alloc]init];
        
        //拿到电话号码
        markSure.phoneNum = self.phoneNum;
        
        [self.navigationController pushViewController:markSure animated:YES];
        
        
    } else {
        NSLog(@"验证失败.........");
    }

}

-(void)viewWillAppear:(BOOL)animated {
    //注册代理
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
    [super viewWillAppear:animated];
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    
    
    //去掉代理
    [[FDSUserCenterMessageManager sharedManager] unRegisterObserver:self];
    [super viewWillDisappear:animated];
}
@end
