//
//  creatGroupViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-23.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "creatGroupViewController.h"
#import "PlatformMessageManager.h"
#import "SVProgressHUD.h"
#import "EaseMob.h"
#import "BaseCellModel.h"
#import "DataBaseSimple.h"
#import "InviteMembersViewController.h"

@interface CreatGroupViewController ()<PlateformMessageInterface,UIAlertViewDelegate,UITextViewDelegate>

@end

@implementation CreatGroupViewController{
    
    UIView *topView;
    UIButton *backBtn;
    
    __weak UIView *_keyboardBackView;
    __weak UITextView *_groupNameView;
    __weak UITextView *_groupIntroView;
    __weak UITextView *_groupNoticeView;
    
    NSString *_hxgroupid;
    NSString *_roomid;
    
    __weak UIView *_backView;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = _backView.frame;
        
        frame.origin.y = -150;
        
        _backView.frame = frame;
        
    } completion:nil];
    
    return YES;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    
    [[PlatformMessageManager sharedManager] registerObserver:self];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    
    
    [SVProgressHUD popActivity];
    
    [[PlatformMessageManager sharedManager] unRegisterObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    
    //添加导航栏
    [self addTopBar];
    
    //创建输入框和标签这些
    [self creatGroupView];
    
    //监听键盘
    [self observeKeyboard];
    
    //将某人加进群
    //[[PlatformMessageManager sharedManager] addFriendsToGroupWithUserid:@"20" groupid:@"102" type:1 agr:@"true"];
    
}

//监听键盘弹出
-(void)observeKeyboard{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

//设置keyboardBackView
-(void)setupkeyboardBackViewWithSize:(CGSize)size{
    
    UIView *keyboardBackView = [[UIView alloc] init];
    CGRect bounds = self.view.bounds;
    bounds.size.height = bounds.size.height-size.height;
    keyboardBackView.frame = bounds;
    UITapGestureRecognizer *resignKeyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboardTap)];
    [keyboardBackView addGestureRecognizer:resignKeyboardTap];
    [self.view addSubview:keyboardBackView];
    _keyboardBackView = keyboardBackView;
}

//键盘通知回调函数
-(void)keyboardWillShow:(NSNotification *)noti{
    
    //重新出现的时候要将旧的_keyboardBackView移除掉，高度不对
    [_keyboardBackView removeFromSuperview];
    _keyboardBackView = nil;
    
    //取出键盘高度
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    //添加一个遮盖真个屏幕的view,事件就可以接受了，神马原因？
    [self setupkeyboardBackViewWithSize:size];
    
}

-(void)keyboardWillHide:(NSNotification *)noti{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = _backView.frame;
        
        frame.origin.y = kTopViewHeight;
        
        _backView.frame = frame;
        
    } completion:nil];
    
    
    
    //将从父视图遮罩移除
    [_keyboardBackView removeFromSuperview];
    _keyboardBackView = nil;
    
}

//把键盘放下去
-(void)resignKeyboardTap{
    
    [self.view endEditing:YES];
}

//群名输入
-(void)creatGroupView{
    
    UIView *backView = [[UIView alloc] init];
    CGFloat backX = 0;
    CGFloat backY = kTopViewHeight;
    CGFloat backW = self.view.frame.size.width;
    CGFloat backH = self.view.frame.size.height-kTopViewHeight;
    backView.frame = CGRectMake(backX, backY, backW, backH);
    [self.view addSubview:backView];
    _backView = backView;
    [self.view sendSubviewToBack:_backView];
    
    //群名标签
    UILabel *nameLabel = [[UILabel alloc] init];
    CGFloat nameX = 15;
    CGFloat nameY = 10;
    CGFloat nameW = 100;
    CGFloat nameH = 30;
    nameLabel.frame = CGRectMake(nameX, nameY, nameW, nameH);
    nameLabel.text = @"请输入群名";
    nameLabel.textColor = [UIColor grayColor];
    nameLabel.font = [UIFont systemFontOfSize:15.0];
    [backView addSubview:nameLabel];
    
    //群名输入框
    UITextView *groupNameView = [[UITextView alloc] init];
    groupNameView.backgroundColor = [UIColor whiteColor];
    CGFloat groupNameX = nameX;
    CGFloat groupNameY = CGRectGetMaxY(nameLabel.frame)+5;
    CGFloat groupNameW = self.view.frame.size.width-nameX*2;
    CGFloat groupNameH = 30;
    groupNameView.frame = CGRectMake(groupNameX, groupNameY, groupNameW, groupNameH);
    [backView addSubview:groupNameView];
    _groupNameView = groupNameView;
    
    //群简介标签
    UILabel *introLabel = [[UILabel alloc] init];
    CGFloat introX = nameX;
    CGFloat introY = CGRectGetMaxY(groupNameView.frame)+10;
    CGFloat introW = 100;
    CGFloat introH = 30;
    introLabel.frame = CGRectMake(introX, introY, introW, introH);
    introLabel.text = @"请输入群简介";
    introLabel.textColor = [UIColor grayColor];
    introLabel.font = [UIFont systemFontOfSize:15.0];
    [backView addSubview:introLabel];
    
    //群简介输入框
    UITextView *groupIntroView = [[UITextView alloc] init];
    groupIntroView.backgroundColor = [UIColor whiteColor];
    CGFloat groupIntroX = nameX;
    CGFloat groupIntroY = CGRectGetMaxY(introLabel.frame)+5;
    CGFloat groupIntroW = groupNameW;
    CGFloat groupIntroH = self.view.frame.size.height*0.18;
    groupIntroView.frame = CGRectMake(groupIntroX, groupIntroY, groupIntroW, groupIntroH);
    [backView addSubview:groupIntroView];
    _groupIntroView = groupIntroView;
    
    //群公告标签
    UILabel *noticeLabel = [[UILabel alloc] init];
    CGFloat noticeX = nameX;
    CGFloat noticeY = CGRectGetMaxY(groupIntroView.frame)+10;
    CGFloat noticeW = 100;
    CGFloat noticeH = 30;
    noticeLabel.frame = CGRectMake(noticeX, noticeY, noticeW, noticeH);
    noticeLabel.text = @"请输入群公告";
    noticeLabel.textColor = [UIColor grayColor];
    noticeLabel.font = [UIFont systemFontOfSize:15.0];
    [backView addSubview:noticeLabel];
    
    //群公告输入框
    UITextView *groupNoticeView = [[UITextView alloc] init];
    groupNoticeView.backgroundColor = [UIColor whiteColor];
    CGFloat groupNoticeX = nameX;
    CGFloat groupNoticeY = CGRectGetMaxY(noticeLabel.frame)+5;
    CGFloat groupNoticeW = groupNameW;
    CGFloat groupNoticeH = self.view.frame.size.height*0.18;
    groupNoticeView.frame = CGRectMake(groupNoticeX, groupNoticeY, groupNoticeW, groupNoticeH);
    groupNoticeView.tag = 101;
    groupNoticeView.delegate = self;
    [backView addSubview:groupNoticeView];
    _groupNoticeView = groupNoticeView;
    
    //创建按钮
    UIButton *creatButton = [[UIButton alloc] init];
    CGFloat creatButtonX = nameX;
    CGFloat creatButtonY = CGRectGetMaxY(groupNoticeView.frame)+20;
    CGFloat creatButtonW = groupNameW;
    CGFloat creatButtonH = self.view.frame.size.height*0.088;
    creatButton.frame = CGRectMake(creatButtonX, creatButtonY, creatButtonW, creatButtonH);
    creatButton.backgroundColor = [UIColor colorWithRed:49/255.0 green:213/255.0 blue:44/255.0 alpha:1.0];
    creatButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    creatButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    creatButton.titleLabel.textColor = [UIColor whiteColor];
    [creatButton setTitle:@"创建完成" forState:UIControlStateNormal];
    [creatButton addTarget:self action:@selector(creatButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:creatButton];
    
}

-(void)creatButtonClick{
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    //发送创建群消息
    [[PlatformMessageManager sharedManager] creatGroupWithName:_groupNameView.text type:0 intro:_groupIntroView.text notice:_groupNoticeView.text];
    
}

// 最上方类似于导航栏的界面
-(void) addTopBar {
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    [self.view addSubview:topView];
    
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    label1.text = @"创建群";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];

    
}

//邀请按钮被点击
-(void)inviteButtonClick{
    
    InviteMembersViewController *InvitVC = [[InviteMembersViewController alloc] init];
    InvitVC.hxgroupid = _hxgroupid;
    InvitVC.roomid = _roomid;
    [self.navigationController pushViewController:InvitVC animated:YES];
    
}

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//创建群回调
-(void)creatGroupCB:(NSDictionary *)data{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if (data) {
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"创建群成功"];
        
        //将字典转换成模型(这里不插入数据库，它回回调一个自动加入群的函数，群主和一般群成员自动加入都是那里插入)
        BaseCellModel *model = [[BaseCellModel alloc] initWithDic:data];
        
        //插入数据库
        [[DataBaseSimple shareInstance] insertGroupsWithModel:model];
        
        _hxgroupid = model.hxgroupid;
        
        _roomid = model.roomid;
        
        [self performSelector:@selector(inviteMembers) withObject:nil afterDelay:1.5];
        
        
        
    }
    
}

-(void)inviteMembers{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否邀请群成员？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alert show];
    
}

//alertView代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        
        [self inviteButtonClick];
        
    }
    
}
@end
