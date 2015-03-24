


//
//  SexViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//
#import "FDSUserCenterMessageManager.h"
#import "SVProgressHUD.h"
#import "SexViewController.h"
#import "FDSUserCenterMessageManager.h"
#import "FDSUserManager.h"

@interface SexViewController ()
@property(nonatomic,retain)BGUser* user;
@end

@implementation SexViewController
{
    UIView    *topView;
    UIButton  *backBtn;
    
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    
    UIView *barrView;
    NSArray *arr;
    BGUser* _user;
    int _sex;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        arr = [NSArray arrayWithObjects:@"女",@"男",@"保密", nil];
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
    
    //中间标签
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(140, 24, 80, 40)];
    label1.text = @"性别";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    [self.view addSubview:topView];
    
    //三个cell的背景视图
    UIView *bot = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 320, 120)];
    bot.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bot];
    
    //创建了男／女／保密三个标签
    for (int i = 0; i < 3;  i ++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10+i*40, 40, 20)];
        label.text = arr[i];
        [bot addSubview:label];
    }
    
    //创建三个选择按钮
    btn1 = [[UIButton alloc]initWithFrame:CGRectMake(280,12, 16.5, 16.5)];
    [btn1 setImage:[UIImage imageNamed:@"注册协议未选中"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"注册协议选中"] forState:UIControlStateSelected];
    btn1.tag = 0;
    //默认是女的，坑爹
//    btn1.selected = YES;
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bot addSubview:btn1];
    
    btn2 = [[UIButton alloc]initWithFrame:CGRectMake(280,52, 16.5, 16.5)];
    [btn2 setImage:[UIImage imageNamed:@"注册协议未选中"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"注册协议选中"] forState:UIControlStateSelected];
    btn2.tag = 1;
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bot addSubview:btn2];
    
    btn3 = [[UIButton alloc]initWithFrame:CGRectMake(280,92, 16.5, 16.5)];
    [btn3 setImage:[UIImage imageNamed:@"注册协议未选中"] forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"注册协议选中"] forState:UIControlStateSelected];
    btn3.tag = 2;
    [btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bot addSubview:btn3];
    
    //根据模型数据来判断选中哪个
    int tmpIndex = [_user.sex intValue];
    if(tmpIndex==0) {
        btn1.selected = YES;
    }else if(tmpIndex == 1) {
        btn2.selected = YES;
    }else {
        btn3.selected = YES;
    }
    
    //华丽丽的分割线
    for (int  i = 0; i < 4 ; i++) {
        barrView =[[UIView alloc]initWithFrame:CGRectMake(0, 40.5*i, 320, 0.5)];
        barrView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        [bot addSubview:barrView];
    }
    
    //确认按钮
    CGFloat submitButtonY = CGRectGetMaxY(bot.frame)+20;
    UIButton* submitButton =[[UIButton alloc]initWithFrame:CGRectMake(10,submitButtonY, 300, 40)];
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
    //这样做省去了很多判断
    btn1.selected = NO;
    btn2.selected = NO;
    btn3.selected = NO;
    sender.selected = YES;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _user = [[FDSUserManager sharedManager] getNowUser];
    [self CreatTopView];
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
    
}

-(void)viewWillDisappear:(BOOL)animated {


    [super viewWillDisappear:animated];
    
    
    
    [SVProgressHUD popActivity];
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)onSubmitClick:(UIButton*)sender {
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //修改用户模型，换最新的数据，这不是用户模型，这是成员变量
    if(btn1.selected) {
        _sex = 0;
    }else if(btn2.selected) {
        _sex = 1;
    }else {
        _sex = 2;
    }   
    
    //发送修改性别的消息
    [[FDSUserCenterMessageManager sharedManager]updateSex:_sex];
    
    
}

//修改个人信息回调
-(void)upDateUserInfoCB:(int)returnCode {
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //修改用户模型
    _user.sex = [@"" stringByAppendingFormat:@"%d",_sex];
    
    if(returnCode == 0) {
        
        //控制器弹出栈
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"性别更改失败"];
    }
}

@end
