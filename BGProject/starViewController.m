



//
//  starViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//
#import "SVProgressHUD.h"

#import "starViewController.h"
#import "FDSUserCenterMessageManager.h"
#import "FDSUserManager.h"
#import "UIAlertView+Zhangxx.h"
@interface starViewController ()

@end

@implementation starViewController

{
    UIView    *topView;
    UIButton  *backBtn;
    UITableView *myTableView;
    UIPickerView * picker;
    
    NSArray *arr;
    NSString* _constellation;
    BGUser* _user;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        arr = [NSArray arrayWithObjects:@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座",nil];
    }
    return self;
}
-(void)CreatTopView
{
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(140, 24, 80, 40)];
    label1.text = @"星座";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    [self.view addSubview:topView];
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 216)];
    picker.backgroundColor =  [UIColor clearColor];
    picker.delegate = self;
    picker.dataSource = self;
    
    int selectedIndex = [self getIndexByString:_user.conste];
    
    [picker selectRow:selectedIndex inComponent:0 animated:NO];
    [self.view addSubview:picker];
    
    // 添加确定按钮
    CGFloat submitBtnY = CGRectGetMaxY(picker.frame)+20;
    UIButton* submitBtn =[[UIButton alloc]initWithFrame:CGRectMake(10,submitBtnY, 300, 40)];
    [submitBtn setTitle:@"确认" forState:UIControlStateNormal];

    [submitBtn addTarget:self action:@selector(onSubmitClk:) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    
    [self.view addSubview:submitBtn];
    
    
}

#pragma mark btnClick===================

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _user = [[FDSUserManager sharedManager]getNowUser];
    
    [self CreatTopView];
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    _constellation = _user.conste;
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
}
-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    
    
    [SVProgressHUD popActivity];
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
    
}
#pragma mark pickViewDataSouce======
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
    _constellation = arr[row];
    _user.conste = arr[row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//    [[FDSUserCenterMessageManager sharedManager]updateConste:_constellation];

-(int) getIndexByString:(NSString*)string {
    int index = 0;
    for(index=0; index<[arr count]; index++ ) {
        if([arr[index] isEqualToString:string])
            break;
    }
    //if not found
    if(index==[arr count]) {
        index = 0;
    }
    return index;
}


-(void)onSubmitClk:(UIButton*)sender {
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[FDSUserCenterMessageManager sharedManager]updateConste:_user.conste];
}



-(void)upDateUserInfoCB:(int)returnCode {
    
    [SVProgressHUD popActivity];
    if(returnCode==0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
//        [UIAlertView showMessage:@"星座更新失败"];
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"星座更新失败"];
    }
}


@end
