//
//  ageViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ageViewController.h"
#import "SVProgressHUD.h"
#import "FDSUserCenterMessageManager.h"
#import "FDSUserManager.h"
#import "FDSPublicManage.h"

@interface ageViewController ()

@end

@implementation ageViewController
{
    UIView    *topView;
    UIButton  *backBtn;
    UIPickerView *picker;
    
    NSMutableArray  *arr;
    int _age;
    BGUser* _user;

    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        arr = [NSMutableArray array];
    }
    return self;
}

//初始化年龄数组
-(void)initArray
{
    //0-129岁
    for (int i = 0; i < 130; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [arr addObject:str];
    }
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
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(140, 24, 80, 40)];
    label1.text = @"年龄";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    [self.view addSubview:topView];
    
    //选择控件，咋用呢？？？
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 216)];
    picker.backgroundColor =  [UIColor clearColor];
    picker.delegate = self;
    picker.dataSource = self;
    
    //取出当前用户年龄
    int currAge = [_user.age integerValue];
    
    //如果当前年龄在选择控件范围内
    if(currAge>=0 && currAge<[arr count]) {
        
        //将选择控件的行数调到那一行，无需动画
        [picker selectRow:currAge inComponent:0 animated:NO];

    }
    [self.view addSubview:picker];
    
    //确认按钮
    CGFloat submitButtonY = CGRectGetMaxY(picker.frame)+20;
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


- (void)viewDidLoad
{
 
    [super viewDidLoad];
    
    //获取当前用户模型
    _user = [[FDSUserManager sharedManager]getNowUser];
    
    //往年龄数组里面添加元素
    [self initArray];
    
    //创建页面
    [self CreatTopView];
    
    //背景颜色
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    
    //注册代理
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //去掉菊花
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
}

#pragma mark pickViewDataSouce
//有多少个组件
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//每个组件有多少行
// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

    return arr.count;
    
}

//每个组件的文字
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [arr objectAtIndex:row];
}

//选择了某行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"已经选择了%d组件  %d行",component,row);
    _age = [arr[row] intValue];
    
}



-(void)onSubmitClick:(UIButton*)sender {
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //发送修改年龄的消息
    [[FDSUserCenterMessageManager sharedManager]updateAge:_age];
    
}

//更改用户消息回调
-(void)upDateUserInfoCB:(int)returnCode {
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //如果修改成功
    if(returnCode==0) {
        
        //修改模型数据
        _user.age = [@"" stringByAppendingFormat:@"%d",_age];
        
        //将控制器弹出栈
        [self.navigationController popViewControllerAnimated:YES];
        
    }else  {
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"年龄修改失败"];
    }
}

@end
