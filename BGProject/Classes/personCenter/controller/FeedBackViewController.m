//
//  FeedBackViewController.m
//  BGProject
//
//  Created by liao on 14-11-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FeedBackViewController.h"
#import "FDSUserManager.h"
#import "FDSUserCenterMessageManager.h"
#import "SVProgressHUD.h"

#define kTextViewMargin 10
#define kTextViewPlaceholder @"请将你的建议和意见告诉我们，炫能有你更精彩！"
#define kContactwayFieldPlaceholder @"联系方式(QQ/EMAIL/手机号)或其他联系方式"
#define kTextViewFont [UIFont systemFontOfSize:12.0]
#define kSubmitButtonColor [UIColor colorWithRed:81/255.0 green:195/255.0 blue:242/255.0 alpha:1.0]

@interface FeedBackViewController ()<UITextViewDelegate,UITextFieldDelegate,UserCenterMessageInterface>

@end

@implementation FeedBackViewController{
    
    __weak UILabel *_placeholder;
    __weak UITextView *_feedBackView;
    __weak UIView *_backView;
    __weak UITextField *_contactway;
    __weak UIView *_contactBg;
    
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
    
    //去掉注册
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //要设置白色，如果是透明的话会看到控制器的切换页面
    self.view.backgroundColor = [UIColor whiteColor];;
    
    //创建导航栏
    [self setupNavigationbar];
    
    //设置意见输入框
    [self setupFeedBackView];
    
    //设置联系方式输入框
    [self setupContactwayField];
    
    //设置提交按钮
    [self setupSubmitButton];
    
    
    
}

//将键盘放下去
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

-(void)setupSubmitButton{
    
    UIButton *submitButton = [[UIButton alloc] init];
    CGFloat submitButtonW = 200;
    CGFloat submitButtonX = (kScreenWidth-submitButtonW)*0.5;
    CGFloat submitButtonY = CGRectGetMaxY(_contactBg.frame)+50;
    CGFloat submitButtonH = 44;
    submitButton.frame = CGRectMake(submitButtonX, submitButtonY, submitButtonW, submitButtonH);
    submitButton.backgroundColor = kSubmitButtonColor;
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //设置圆角
    submitButton.layer.borderWidth = 0.5;
    submitButton.layer.borderColor = [UIColor grayColor].CGColor;
    CGFloat radius = 5;
    [submitButton.layer setCornerRadius:radius];
    [submitButton.layer setMasksToBounds:YES];
    
    [submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:submitButton];
}



-(void)submitButtonClick{
    
    if (_feedBackView.text.length == 0) {
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"意见反馈不可为空，请重新输入"];
        return;
        
    }
    
    if (_contactway.text.length == 0) {
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"联系方式不可为空，请重新输入"];
        return;
        
    }
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //发送意见反馈消息
    [[FDSUserCenterMessageManager sharedManager] submitFeedbackWithMessage:_feedBackView.text contactnum:_contactway.text];
    
}

//意见反馈回调
-(void)submitFeedBackCB:(int)returnCode{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if (returnCode==0) {
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"意见提交成功"];
        [self performSelector:@selector(popController) withObject:nil afterDelay:2.0];
        
        
    }else{
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"意见提交失败"];
        
    }
    
}

-(void)popController{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)setupContactwayField{
    
    UIView *contactBg = [[UIView alloc] init];
    contactBg.frame = CGRectMake(kTextViewMargin, CGRectGetMaxY(_backView.frame)+kTextViewMargin, kScreenWidth-kTextViewMargin*2, 30);
    //设置圆角
    contactBg.layer.borderWidth = 1.0;
    contactBg.layer.borderColor = [UIColor grayColor].CGColor;
    CGFloat radius = 7;
    [contactBg.layer setCornerRadius:radius];
    [contactBg.layer setMasksToBounds:YES];
    [self.view addSubview:contactBg];
    _contactBg = contactBg;
    
    UITextField *contactway = [[UITextField alloc] init];
    contactway.delegate = self;
    CGFloat contactwayX = kTextViewMargin;
    CGFloat contactwayY = 0;
    CGFloat contactwayW = contactBg.frame.size.width-kTextViewMargin*2;
    CGFloat contactwayH = 30;
    contactway.frame = CGRectMake(contactwayX, contactwayY, contactwayW, contactwayH);
    contactway.placeholder = kContactwayFieldPlaceholder;
    contactway.font = kTextViewFont;
    [contactBg addSubview:contactway];
    _contactway = contactway;
    
    
    [self.view addSubview:contactBg];
    
    
}

-(void)setupFeedBackView{
    
    //设置输入框背景视图
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(kTextViewMargin, kTopViewHeight+10, kScreenWidth-kTextViewMargin*2, 150);
    //设置圆角
    backView.layer.borderWidth = 1.0;
    backView.layer.borderColor = [UIColor grayColor].CGColor;
    CGFloat radius = 10;
    [backView.layer setCornerRadius:radius];
    [backView.layer setMasksToBounds:YES];
    [self.view addSubview:backView];
    _backView = backView;
    
    //设置输入框
    UITextView *feedBackView = [[UITextView alloc] init];
    CGFloat feedBackViewX = kTextViewMargin;
    CGFloat feedBackViewY = kTextViewMargin;
    CGFloat feedBackViewW = backView.frame.size.width-kTextViewMargin*2;
    CGFloat feedBackViewH = backView.frame.size.height-kTextViewMargin*2;
    feedBackView.frame = CGRectMake(feedBackViewX, feedBackViewY, feedBackViewW, feedBackViewH);
    feedBackView.delegate = self;
    [backView addSubview:feedBackView];
    _feedBackView = feedBackView;
    
    //设置占位文字
    UILabel *placeholder = [[UILabel alloc] init];
    placeholder.frame = CGRectMake(5, 4, feedBackViewW-5,20);
    placeholder.font = kTextViewFont;
    placeholder.textAlignment = NSTextAlignmentLeft;
    placeholder.alpha = 0.3;
    placeholder.text = kTextViewPlaceholder;
    _placeholder = placeholder;
    [feedBackView addSubview:placeholder];

    
}

-(void)setupNavigationbar
{
    //导航栏
    UIView* topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopViewHeight)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    UIButton* backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"意见反馈";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    [self.view addSubview:topView];
    
}

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length == 0) {
        _placeholder.text = kTextViewPlaceholder;
    }else{
        _placeholder.text = @"";
    }
}



@end
