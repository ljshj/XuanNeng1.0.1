//
//  RewardRulesViewController.m
//  BGProject
//
//  Created by liao on 15-1-30.
//  Copyright (c) 2015年 zhuozhong. All rights reserved.
//

#import "RewardRulesViewController.h"

@interface RewardRulesViewController ()

@end

@implementation RewardRulesViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupNavigationbar];
    
    [self setupRuleLabel];
    
    //设置self.view的背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    
}

//设置导航栏
-(void)setupNavigationbar
{
    //导航栏
    UIView* topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopViewHeight)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    UIButton* backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"loginCancel"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(110, 24, 120, 40)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"有奖投稿规则";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    //顶部灰色横线
    UIView *barr1 =[[UIView alloc]initWithFrame:CGRectMake(0, topView.frame.origin.y+topView.frame.size.height, 320, 0.5)];
    barr1.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [self.view addSubview:barr1];
    
    [self.view addSubview:topView];
    
}

-(void)setupRuleLabel{
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, kTopViewHeight+2, self.view.frame.size.width, 330);
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel *ruleLabel = [[UILabel alloc] init];
    CGFloat ruleX = 20;
    CGFloat ruleY = 0;
    CGFloat ruleW = self.view.frame.size.width-2*ruleX;
    CGFloat ruleH = backView.frame.size.height;
    ruleLabel.frame = CGRectMake(ruleX, ruleY, ruleW, ruleH);
    ruleLabel.numberOfLines = 0;
    ruleLabel.font = [UIFont systemFontOfSize:14.0];
    //支持换行
    ruleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    ruleLabel.text = @"1.奖金分配方式:\r   日排行\r   第一名   50元\r   周排行\r   第一名   100元\r   月排行\r   第一名   300元\r   第二名   200元\r   年排行\r   第一名   3000元\r   第二名   2000元\r   第三名   1000元\r   每周结算一次现金转帐给获奖者\r2.采取积分制:按积分高低列出日排行、周排行、月排行、年排行的前三名。\r3.作品获得积分的计算方法:1分/点赞 、1分/评论、1分/转发、2分/分享！系统自动统计加分！";
    ;
    
    [backView addSubview:ruleLabel];
    
    UIButton *knowButton = [[UIButton alloc] init];
    CGFloat knowX = 40;
    CGFloat knowY = CGRectGetMaxY(backView.frame)+20;
    CGFloat knowW = self.view.frame.size.width-2*knowX;
    CGFloat knowH = 40;
    knowButton.frame = CGRectMake(knowX, knowY, knowW, knowH);
    [knowButton setTitle:@"我知道了" forState:UIControlStateNormal];
    knowButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    knowButton.backgroundColor = [UIColor colorWithRed:2/255.0 green:191/255.0 blue:60/255.0 alpha:1.0];
    [knowButton addTarget:self action:@selector(BackMainMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:knowButton];
    
}

-(void)BackMainMenu{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
