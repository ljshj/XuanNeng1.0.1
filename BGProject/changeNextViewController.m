




//
//  changeNextViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "changeNextViewController.h"
#import "AppDelegate.h"
@interface changeNextViewController ()

@end

@implementation changeNextViewController
{
    UIView    *topView;
    UIButton  *backBtn;
    
    UITextField *tf;
    UIButton *netBtn;
    
    UIView *backView;

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
    
    
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app hiddenTabelBar];
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
    
    UILabel  *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    label.text = @"修改密码";
    label.textColor = TITLECOLOR;
    label.font = TITLEFONT;
    [topView addSubview:label];
    
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
    
    
    netBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, tf.frame.origin.y+tf.frame.size.height + 25, 300, 44)];
    [netBtn setTitle:@"完成" forState:UIControlStateNormal];
    [netBtn addTarget:self action:@selector(nextPage:) forControlEvents:UIControlEventTouchUpInside];
    [netBtn setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    [self.view addSubview:netBtn];
}

#pragma mark btn =====
-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nextPage:(UIButton *)sender
{
    
    
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    backView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [keywindow addSubview:backView];
    [keywindow bringSubviewToFront:backView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 120, 42)];
    imageView.image = [UIImage imageNamed:@"登录成功_03"];
    [backView addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer   *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTaget:)];
    [imageView addGestureRecognizer:tap];
    NSLog(@"keywindow");
    
    
}


-(void)tapTaget:(UITapGestureRecognizer *)sender
{

    [backView removeFromSuperview];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self CreatTopView];
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];

}

#pragma mark textfiedDelegate=====

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tf resignFirstResponder];
    return YES;
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
