

//
//  birthdayViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "birthdayViewController.h"
#import "FDSUserCenterMessageManager.h"
#import "FDSUserManager.h"
#import "SVProgressHUD.h"
#import "FDSUserManager.h"
#import "UIAlertView+Zhangxx.h"
#import "FDSPublicManage.h"

@interface birthdayViewController ()

@end

@implementation birthdayViewController

{
    UIView    *topView;
    UIButton  *backBtn;
    
    NSDateFormatter* _dateFromatter;
    NSDate* _date;
    NSString* _dateStr;
    UIDatePicker *datePicker;
    
    NSString* _dateValue;
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
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    label1.text = @"生日";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    [self.view addSubview:topView];
    
    //日期选择器
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 150, 320, 216)];
    
    //本地显示格式
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    //设置显示类型
    datePicker.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview:datePicker];
    
    
    //    [datePicker addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventValueChanged];

    //获取用户生日
    NSDate* tmpDate = [_dateFromatter dateFromString:_user.birthday];
    if(tmpDate !=nil) {
        
        //在日期选择器上面显示用户日期
        [datePicker setDate:tmpDate animated:NO];
    }
    
    //确定按钮
    CGFloat submitButtonY = CGRectGetMaxY(datePicker.frame)+20;
    UIButton* submitButton =[[UIButton alloc]initWithFrame:CGRectMake(10,submitButtonY, 300, 40)];
    [submitButton setTitle:@"确认修改" forState:UIControlStateNormal];
    
    [submitButton setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(onSubmitClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:submitButton];
    
    

}

#pragma mark btnClick===================

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectDate:(UIDatePicker *)picker
{

    _date =  [picker date];
    _dateStr = [_dateFromatter stringFromDate:_date];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //获取用户模型
    _user = [[FDSUserManager sharedManager]getNowUser];
    
    //初始化日期管理器
    _dateFromatter = [[NSDateFormatter alloc]init];
    [_dateFromatter setDateFormat:@"yyyy-MM-dd"];
    
    //取出生日
    _dateStr = _user.birthday;
    
    //创建页面
    [self CreatTopView];
    
    //背景颜色
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD popActivity];
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
//    [[FDSUserCenterMessageManager sharedManager]updateBirthday:_dateStr];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    

    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//修改用户消息回调
-(void)upDateUserInfoCB:(int)returnCode  {
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //如果修改成功
    if(returnCode==0) {
        
        //修改用户模型数据
        _user.birthday = _dateValue;
        
        //控制器弹出栈
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"生日更新失败"];
    }
}


-(void)onSubmitClick:(UIButton*)sender {
    
    //获取选择器当前的日期
    NSDate* date  = [datePicker date];
    _dateValue = [_dateFromatter stringFromDate:date];
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //发送修改生日的消息
    [[FDSUserCenterMessageManager sharedManager]updateBirthday:_dateValue];
}



@end
