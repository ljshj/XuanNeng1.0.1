//
//  addGoodFriendViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-23.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "addGoodFriendViewController.h"
#import "AppDelegate.h"
#import "TableViewCell.h"
#import "UserCardViewController.h"
#import "FriendInSearchCell.h"
#import "NameCardModel.h"
#import "SVProgressHUD.h"
#import "EaseMob.h"
#import "FDSUserManager.h"

//显示用户名片
#import "scanViewController.h"

#define DividerColor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]
#define DividerFrameZero CGRectMake(0,91-0.5 , self.view.bounds.size.width, 0.5)

@interface addGoodFriendViewController ()<PlateformMessageInterface,EMChatManagerDelegate,FriendInSearchCellDelegate,UIAlertViewDelegate>

@end

@implementation addGoodFriendViewController

{
    UIView *topView;
    UIButton *backBtn;
    // 这是搜索框？好吧
    UITextField *tf;
    
    UITableView *myTableView;
    
    //记录下被添加的用户名
    NSString *_username;
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
    
    
    
    
    //为啥要将数组置空？
    self.friends = nil;
    
    //将tabbar隐藏起来
    AppDelegate *daa =(AppDelegate*)[UIApplication sharedApplication].delegate;
    [daa hiddenTabelBar];
    
    //注册代理
    [[PlatformMessageManager sharedManager] registerObserver:self];
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //去掉代理
    [[PlatformMessageManager sharedManager] unRegisterObserver:self];

    
}

-(void)CreatView
{
    //导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    [self.view addSubview:topView];
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(130, 24, 80, 40)];
    label1.text = @"添加好友";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    //搜索框
    tf= [[UITextField alloc]initWithFrame:CGRectMake(10, kTopViewHeight+10, 300, 44)];
    tf.delegate = self;
    tf.borderStyle = UITextBorderStyleRoundedRect;
    //tf.keyboardType = UIKeyboardTypeNumberPad;//改变键盘的类型
    tf.font = [UIFont systemFontOfSize:15.0];
    tf.placeholder = @"请输入好友账号";
    UIView *bigView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 41, 44)];
    tf.rightView = bigView;
    tf.returnKeyType = UIReturnKeySearch;
    tf.rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:tf];
    
    //右边的放大镜
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 11, 20, 22)];
    imageView.image =[UIImage imageNamed:@"添加好友_06"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTarget:)];
    [imageView addGestureRecognizer:tap];//放大镜可以点击并搜索
    [bigView addSubview:imageView];
    
    //分割线
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(0, 8, 1, 44-8*2)];
    lineView.backgroundColor =[UIColor grayColor];
    lineView.alpha = 0.2;
    [bigView addSubview:lineView];
    
    //搜索结果列表
    CGFloat myTableViewX=0;
    CGFloat myTableViewY = CGRectGetMaxY(tf.frame)+10;
    CGFloat myTableViewW = self.view.bounds.size.width;
    CGFloat myTableViewH = self.view.bounds.size.height-myTableViewY;
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(myTableViewX, myTableViewY, myTableViewW, myTableViewH) style:UITableViewStylePlain];
    myTableView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate   = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    
}
#pragma mark btncl====================
-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//发送搜索请求.
-(void)tapTarget:(UITapGestureRecognizer *)sender
{
//    //取得搜索词
    NSString *keyword = tf.text;
    
    //发送查找消息
    [[PlatformMessageManager sharedManager] checkFriendsWithKeyword:keyword start:0 end:10];
    
    //统计搜索好友
    [MobClick event:@"chat_search_friend_click"];
    
    //将键盘放下去
    [tf resignFirstResponder];
    
    
}

//查找好友回调
-(void)checkFriendsCB:(NSArray *)data{
   
    self.friends=data;
    [myTableView reloadData];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [tf resignFirstResponder];
    
}

//TODO::2014年09月21日 获取实体类
-(void)searchFriendCB:(NSArray *)friends
{
    self.friends = friends;
    [myTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //导航栏／搜索框／搜索结果列表
    [self CreatView];
    
    [[[EaseMob sharedInstance] chatManager] addDelegate:self delegateQueue:nil];
    
    //背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
}


#pragma mari textfiedDelegate-------
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self tapTarget:nil];
    
    [tf resignFirstResponder];
    return  YES;
}

#pragma mark uitableviewDelegate-----------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //三目运算
    int number = (self.friends == nil)?0:[self.friends  count];
    
    return  number;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"CellOne";
    FriendInSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FriendInSearchCell alloc]initWithStyle:0
                                        reuseIdentifier:identifier];
        //设置代理
        cell.delegate = self;
        
    }
    
    
    FriendInSearchCellFrame* cellFrame = [[FriendInSearchCellFrame alloc]init];
    
    cellFrame.friendModel = _friends[indexPath.row];
    
    cell.cellFrame = cellFrame;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self addDividerBottomWithCell:cell indexPath:indexPath];
    
    return cell;
}

//添加底部分割线
-(void)addDividerBottomWithCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = DividerColor;
    
    divider.frame = DividerFrameZero;
    
    
    [cell addSubview:divider];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FriendInSearchCellFrame* cellFrame = [[FriendInSearchCellFrame alloc]init];
    
    
    cellFrame.friendModel = _friends[indexPath.row];
    
    return cellFrame.cellHeight;
    
}

//添加按钮回调
-(void)didClickAddButtonWithUsername:(NSString *)username{
    
    //统计搜索好友
    [MobClick event:@"chat_add_friend_click"];
    
    //先把用户名记录下来先
    _username = username;
    
    //弹出对话框，捎点啥
    [self alertviewShow];
    
}

//弹出邀请对话框
-(void)alertviewShow{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"说点啥吧" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
}

//alertView代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        
        //检测是否有网络
        BOOL isExistenceNetwork = [self isConnectionAvailable];
        
        if (!isExistenceNetwork) {
            
            //提示框
            [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"网络未连接"];
            return;
            
        }
        
        //得到输入框
        UITextField *inviteField=[alertView textFieldAtIndex:0];
        
        //发送环信添加好友消息前，设定布尔值,在更新列表过滤
        [FDSUserManager sharedManager].isAddAndDeleteByHX=YES;
        
        //发送环信添加好友消息
        EMError *error = nil;
        [[EaseMob sharedInstance].chatManager addBuddy:_username message:inviteField.text error:&error];
        if (!error) {
            
            //提示框
            [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"好友申请已发送"];
            
        }
        
        
    }

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


//添加好友被拒绝的回调
- (void)didRejectedByBuddy:(NSString *)username{
  
    
    
}

@end
