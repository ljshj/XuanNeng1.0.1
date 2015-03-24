//
//  AboutViewController.m
//  BGProject
//
//  Created by liao on 14-11-22.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //要设置白色，如果是透明的话会看到控制器的切换页面
    self.view.backgroundColor = [UIColor whiteColor];;
    
    //创建导航栏
    [self setupNavigationbar];
    
    //创建其他的视图
    [self setupOtherViews];
}

-(void)setupOtherViews{
    
    //分割线
    UIView *devider = [[UIView alloc] initWithFrame:CGRectMake(0, kTopViewHeight, self.view.bounds.size.width, 1)];
    devider.backgroundColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1.0];
    
    [self.view addSubview:devider];
    
    //图标
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aboutIcon"]];
    CGFloat iconViewX = (kScreenWidth-iconView.image.size.width)*0.5;
    CGFloat iconViewY = kTopViewHeight+30;
    CGFloat iconViewW = iconView.image.size.height;
    CGFloat iconViewH = iconView.image.size.width;
    iconView.frame = CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH);
    [self.view addSubview:iconView];
    
    //标签
    UILabel *titleLabel = [[UILabel alloc] init];
    CGFloat titleLabelW = kScreenWidth;
    CGFloat titleLabelX = 0;
    CGFloat titleLabelY = CGRectGetMaxY(iconView.frame)+5;
    CGFloat titleLabelH = 20;
    titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    titleLabel.text = @"炫能";
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    //价值观标签
    UILabel *valuelabel = [[UILabel alloc] init];
    CGFloat valuelabelW = kScreenWidth;
    CGFloat valuelabelX = 0;
    CGFloat valuelabelY = CGRectGetMaxY(titleLabel.frame)+5;
    CGFloat valuelabelH = 20;
    valuelabel.frame = CGRectMake(valuelabelX, valuelabelY, valuelabelW, valuelabelH);
    valuelabel.text = @"炫了就有可能";
    valuelabel.font = [UIFont systemFontOfSize:13.0];
    valuelabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:valuelabel];
    
    
    //版权标签
    UILabel *versionLabel = [[UILabel alloc] init];
    CGFloat versionLabelW = kScreenWidth;
    CGFloat versionLabelX = 0;
    CGFloat versionLabelH = 20;
    CGFloat versionLabelY = self.view.bounds.size.height-versionLabelH-10;
    versionLabel.frame = CGRectMake(versionLabelX, versionLabelY, versionLabelW, versionLabelH);
    versionLabel.text = @"邦固科技 版权所有 BANDGOOD 4.3.5";
    versionLabel.font = [UIFont systemFontOfSize:11.0];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
    
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
    label1.text = @"关于炫能";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    [self.view addSubview:topView];
    
}

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
