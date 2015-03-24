//
//  GroupSearchInfoViewController.m
//  BGProject
//
//  Created by liao on 15-1-5.
//  Copyright (c) 2015年 zhuozhong. All rights reserved.
//

#import "GroupSearchInfoViewController.h"
#import "NSString+TL.h"
#import "EaseMob.h"
#import "FDSUserManager.h"
#import "SVProgressHUD.h"

@interface GroupSearchInfoViewController ()<PlateformMessageInterface,EMChatManagerDelegate>

@end

@implementation GroupSearchInfoViewController{
    
    __weak UIButton *_applyButton;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    [self addTopBar];
    [self creatGroupInfoView];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)creatGroupInfoView{
    
    UIImageView *iconView = [[UIImageView alloc] init];
    CGFloat iconViewX = 10;
    CGFloat iconViewY = kTopViewHeight+10;
    CGFloat iconViewW = 40;
    CGFloat iconViewH = 40;
    iconView.frame = CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH);
    iconView.image = [UIImage imageNamed:@"group"];
    [self.view addSubview:iconView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    CGFloat nameX = CGRectGetMaxX(iconView.frame)+10;
    CGFloat nameY = kTopViewHeight+20;
    CGFloat nameW = 200;
    CGFloat nameH = 20;
    nameLabel.frame = CGRectMake(nameX, nameY, nameW, nameH);
    nameLabel.text = self.name;
    nameLabel.font = [UIFont systemFontOfSize:14.0];
    nameLabel.textColor = [UIColor blackColor];
    [self.view addSubview:nameLabel];
    
    UIView *infoBackView = [[UIView alloc] init];
    CGFloat infoBackX = iconViewX;
    CGFloat infoBackY = CGRectGetMaxY(iconView.frame)+10;
    CGFloat infoBackW = self.view.frame.size.width-infoBackX*2;
    CGFloat infoBackH = 80;
    infoBackView.frame = CGRectMake(infoBackX, infoBackY, infoBackW, infoBackH);
    infoBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:infoBackView];
    
    UILabel *owerTitleLab = [[UILabel alloc] init];
    CGFloat owerTitleX = 10;
    CGFloat owerTitleY = 10;
    CGFloat owerTitleW = 30;
    CGFloat owerTitleH = 20;
    owerTitleLab.frame = CGRectMake(owerTitleX, owerTitleY, owerTitleW, owerTitleH);
    owerTitleLab.textAlignment = NSTextAlignmentCenter;
    owerTitleLab.font = [UIFont systemFontOfSize:14.0];
    owerTitleLab.textColor = [UIColor grayColor];
    [infoBackView addSubview:owerTitleLab];
    owerTitleLab.text = @"群主";
    
    UILabel *owerLabel = [[UILabel alloc] init];
    CGFloat owerX = CGRectGetMaxX(owerTitleLab.frame)+10;
    CGFloat owerY = 10;
    CGFloat owerW = 200;
    CGFloat owerH = 20;
    owerLabel.frame = CGRectMake(owerX, owerY, owerW, owerH);
    owerLabel.font = [UIFont systemFontOfSize:13.0];
    owerLabel.textColor = [UIColor blackColor];
    [infoBackView addSubview:owerLabel];
    owerLabel.text = self.owerName;
    
    UILabel *introTitleLab = [[UILabel alloc] init];
    CGFloat introTitleX = owerTitleX;
    CGFloat introTitleY = CGRectGetMaxY(owerTitleLab.frame)+20;
    CGFloat introTitleW = owerTitleW;
    CGFloat introTitleH = 20;
    introTitleLab.frame = CGRectMake(introTitleX, introTitleY, introTitleW, introTitleH);
    introTitleLab.textAlignment = NSTextAlignmentCenter;
    introTitleLab.textColor = [UIColor grayColor];
    introTitleLab.font = [UIFont systemFontOfSize:14.0];
    [infoBackView addSubview:introTitleLab];
    introTitleLab.text = @"简介";
    
    UILabel *introLabel = [[UILabel alloc] init];
    CGFloat introX = owerX;
    CGFloat introY = CGRectGetMaxY(owerLabel.frame)+22.5;
    CGSize introSize = [NSString sizeWithText:self.intro font:[UIFont systemFontOfSize:13.0] maxSize:CGSizeMake(200, 200)];
    CGFloat introW = introSize.width;
    CGFloat introH = introSize.height;
    introLabel.frame = CGRectMake(introX, introY, introW, introH);
    introLabel.font = [UIFont systemFontOfSize:13.0];
    introLabel.textColor = [UIColor blackColor];
    introLabel.numberOfLines = 0;
    [infoBackView addSubview:introLabel];
    introLabel.text = self.intro;
    
    CGRect infoBackViewF = infoBackView.frame;
    infoBackViewF.size.height = CGRectGetMaxY(introLabel.frame)+10;
    infoBackView.frame = infoBackViewF;
    
    UIButton *applyButton = [[UIButton alloc] init];
    CGFloat applyX = 10;
    CGFloat applyY = CGRectGetMaxY(infoBackView.frame)+20;
    CGFloat applyW = self.view.frame.size.width-applyX*2;
    CGFloat applyH = 44;
    applyButton.frame = CGRectMake(applyX, applyY, applyW, applyH);
    [applyButton setTitle:@"申请加入" forState:UIControlStateNormal];
    applyButton.backgroundColor = [UIColor colorWithRed:2/255.0 green:191/255.0 blue:60/255.0 alpha:1.0];
    applyButton.titleLabel.textColor = [UIColor whiteColor];
    [applyButton addTarget:self action:@selector(applyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyButton];
    _applyButton = applyButton;
    
}

//检测网络状态
-(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    switch ([reach currentReachabilityStatus]) {
            
        case NotReachable:
            
            isExistenceNetwork = NO;
            
            NSLog(@"notReachable");
            
            break;
            
        case ReachableViaWiFi:
            
            isExistenceNetwork = YES;
            
            NSLog(@"WIFI");
            
            break;
            
        case ReachableViaWWAN:
            
            isExistenceNetwork = YES;
            
            NSLog(@"3G");
            
            break;
            
    }
    
    return isExistenceNetwork;
    
}

-(void)applyButtonClick{
    
    //检测是否有网络
    BOOL isExistenceNetwork = [self isConnectionAvailable];
    
    if (!isExistenceNetwork) {
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"网络未连接"];
        return;
        
    }
    
    [MobClick event:@"chat_add_group_click"];
    
    [[EaseMob sharedInstance].chatManager asyncApplyJoinPublicGroup:self.hxgroupid withGroupname:self.name message:@"进群" completion:^(EMGroup *group, EMError *error) {
        
        if (!error) {
            //提示框
            [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"已发送申请"];
            
        }
        else{
            
            //提示框
            [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"发送失败"];
        }
    } onQueue:nil];
    
}


-(void)backToRootVC{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

// 最上方类似于导航栏的界面
-(void) addTopBar {
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    [self.view addSubview:topView];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    label1.text = @"群详情";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
}

-(void)BackMainMenu:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
