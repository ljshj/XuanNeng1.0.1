//
//  ForgotNextViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ForgotNextViewController.h"
#import "ForgotEndViewController.h"
#import "HongDingYi.h"
#import "UIAlertView+Zhangxx.h"

@interface ForgotNextViewController ()

@end

@implementation ForgotNextViewController
{
    UITextField *tf;
    
    UIView *topView;
    UIButton *backBtn;
    UIButton *fontBtn;
    
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
    
    
}
-(void)CreatView
{
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    
    fontBtn = [[UIButton alloc]initWithFrame:CGRectMake(250, 24, 60, 40)];
    [fontBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [fontBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    fontBtn.titleLabel.font =[UIFont systemFontOfSize:12];
    [fontBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    label1.text = @"忘记密码";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    
    [topView addSubview:backBtn];
    [topView addSubview:label1];
    [topView addSubview:fontBtn];
    [self.view addSubview:topView];
    
    UILabel *label2 =[[UILabel alloc]initWithFrame:CGRectZero];
    label2.text = [NSString stringWithFormat:@"验证码已发送到 %@ 的手机请注意查收",_recStr];
    label2.numberOfLines = 0;
     CGSize size = CGSizeMake(200, 3000);
         CGSize s = [label2.text sizeWithFont:label2.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    label2.frame = CGRectMake(70, 90, s.width, s.height);
   
    
    [self.view addSubview:label2];
    
    tf= [[UITextField alloc]initWithFrame:CGRectMake(10, 160, 300, 44)];
    tf.delegate = self;
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.placeholder = @"请输入您收到的验证码";
    [self.view addSubview:tf];
}

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)BtnClick:(UIButton *)sender
{
    // 判断用户的输入是否有效
    NSString* verfy = tf.text;
    
    if ([self isValide:verfy]) {

        //TODO::将phoneNum 传到下个页面
        ForgotEndViewController *end =[[ForgotEndViewController alloc]init];
        end.phoneNum = self.recStr;
        [self.navigationController pushViewController:end animated:YES];
    }
    else
    {
        [UIAlertView showMessage:@"请输入正确的验证码"];
    }

}


-(BOOL)isValide:(NSString*)verfy {
    if([verfy isEqualToString:self.verfy]) {
        return YES;
    }
    return NO;
}

#pragma mark textFied---------

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tf  resignFirstResponder ];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
