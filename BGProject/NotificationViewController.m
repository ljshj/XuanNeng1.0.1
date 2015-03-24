//
//  NotificationViewController.m
//  BGProject
//
//  Created by liao on 14-12-27.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "NotificationViewController.h"
#import "AppDelegate.h"
#import "NotificationCell.h"
#import "PlatformMessageManager.h"
#import "SVProgressHUD.h"
#import "BaseCellModel.h"
#import "FDSUserManager.h"

#define DividerColor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]
#define DividerFrameZero CGRectMake(0,60-0.5, self.view.bounds.size.width, 0.5)
#define DividerFrameTop CGRectMake(0,0.5,self.view.bounds.size.width, 0.5)
#define didAcceptedByFriend @"didAcceptedByFriend"

@interface NotificationViewController ()<UITableViewDataSource,UITableViewDelegate,NotificationCellDelegate,PlateformMessageInterface>

@end

@implementation NotificationViewController{
    
    UIButton *backBtn;
    __weak UITableView *_tableView;
    
    //记录下要删除的位置
    int _index;
    
    //记录下要同意进群的userid
    NSString *_userid;
    
    //记录下同意要求的userid
    NSString *_friendUserid;
    
    //透明的遮罩，阻塞用户连续操作
    UIView *_backView;
    
}

//数组的懒加载
-(NSMutableArray *)messages{
    
    if (_messages==nil) {
        
        _messages = [[NSMutableArray alloc] init];
        
    }
    
    return _messages;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    AppDelegate *appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [appDelegate hiddenTabelBar];
    
    [[PlatformMessageManager sharedManager] registerObserver:self];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [SVProgressHUD popActivity];
    
    [[PlatformMessageManager sharedManager] unRegisterObserver:self];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //导航栏
    [self addTopBar];
    
    //表格
    [self addTableView];
    
}

//添加表格
-(void)addTableView{
    
    UITableView *tableView = [[UITableView alloc] init];
    CGFloat tableViewX = 0;
    CGFloat tableViewY = kTopViewHeight;
    CGFloat tableViewW = self.view.bounds.size.width;
    CGFloat tableViewH = self.view.bounds.size.height-tableViewY;
    tableView.frame = CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
    
}

// 最上方类似于导航栏的界面
-(void)addTopBar {
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    [self.view addSubview:topView];
    
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    label1.text = @"申请通知";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
}

-(void)BackMainMenu:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark-UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NotificationFrame *cellFrame = self.messages[indexPath.row];
    
    return cellFrame.cellHeight;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.messages.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *indentifier = @"NotificationCell";
    
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (!cell) {
        
        cell = [[NotificationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        
        cell.delegate = self;
        
        [self addDividerBottomWithCell:cell indexPath:indexPath];
        
        if (indexPath.row==0) {
            
            [self addDividerTopWithCell:cell indexPath:indexPath];
            
        }
    }
    
    //取出模型
    NotificationFrame *cellFrame = self.messages[indexPath.row];
    
    cell.cellFrame = cellFrame;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

//添加底部分割线
-(void)addDividerBottomWithCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = DividerColor;
    
    divider.frame = DividerFrameZero;
    
    
    [cell addSubview:divider];
    
}

//添加顶部分割线
-(void)addDividerTopWithCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = DividerColor;
    divider.frame = DividerFrameTop;
    [cell addSubview:divider];
}

#pragma mark-NotificationCellDelegate

//接受按钮被点击(好友请求)
-(void)didClickAgreeButtonWithUserid:(NSString *)userid{
    
    //添加遮罩
    [self creatBackView];
    
    //记录下被同意的userid
    _friendUserid = userid;
    
    //构建recver数组
    NSArray *recverArr = [[NSArray alloc] initWithObjects:userid, nil];
    
    //取出用户ID
    NSString *currentUserid = [[FDSUserManager sharedManager] NowUserID];
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //发送同意添加消息(不需要回调了，只要成功了就会把数据插入搭DB)
    [[PlatformMessageManager sharedManager] agreeToAddFriendsWithUserid:currentUserid recver:recverArr msg:@"true"];
    

    
}

//同意添加回调
-(void)addFriendsCB:(NSArray *)data{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //去掉遮罩
    [self removeBackView];
    
    if (data) {
        
        //发送通知（刷新好友列表通知），请求回来回调的时候已经插入数据库了，刷新列表即可
        [[NSNotificationCenter defaultCenter]
         postNotificationName:didAcceptedByFriend object:nil];
        
        //去掉cell
        [self clearNotificationCellWithUserid:_friendUserid];
        
    }
    
}

//拒绝按钮被点击（好友请求）
-(void)didClickRejectButtonWithUserid:(NSString *)userid{
    
    [self creatBackView];
    
    [self clearNotificationCellWithUserid:userid];
    
}

//删除cell
-(void)clearNotificationCellWithUserid:(NSString *)userid{
    
    //是0可能会重复，搞个－1
    _index = -1;
    
    //删除控制器数组里面的模型
    for (NotificationFrame *modelFrame in self.messages) {
        
        NotificationModel *model = modelFrame.model;
        
        if ([model.userid isEqualToString:userid]) {
            
            //找出在数组中的标记
            _index = [self.messages indexOfObject:modelFrame];
            //警告：不能边遍历数组一边删除元素，否则蹦掉
        }
        
    }
    
    //删除数组中对应的元素（一定要先删除数据，先记录下位置）
    [self.messages removeObjectAtIndex:_index];
    
    //取出对应位置的indexpath
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:_index inSection:0];
    
    //删除tableview上面对应deleteIndexPath的cell
    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexpath]
                      withRowAnimation:UITableViewRowAnimationFade];
    
    [self removeBackView];
    
}

//拒绝进群请求
-(void)didClickRejectButtonWithUserid:(NSString *)userid hxgroupid:(NSString *)hxgroupid{
    
    [self creatBackView];
    
    [self clearNotificationCellWithUserid:userid];
    
}

//同意进群请求
-(void)didClickAgreeButtonWithUserid:(NSString *)userid hxgroupid:(NSString *)hxgroupid{
    
    //添加遮罩
    [self creatBackView];
    
    NSLog(@"记录下同意进群的userid,以后要删除cell");
    
    //记录下同意进群的userid,以后要删除cell
    _userid = userid;
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    NSLog(@"查询群信息");
    
    //查询群信息
    [[PlatformMessageManager sharedManager] requestGroupInfoWithHxgroupid:hxgroupid roomid:@"0"];
    
}

//群消息回调（在FDSUsercenter，那里回调已经把群插入数据库了，这里不需要插入）
-(void)requestGroupInfoCB:(NSDictionary *)data{
    
    //这里还不能去掉遮罩，下面还要插入群成员
    
    //字典转换成模型
    BaseCellModel *model = [[BaseCellModel alloc] initWithDic:data];
    
    //发送插入群成员(在数据回调的时候已经插入数据库了，这里也不需要插入数据库了)
    [[PlatformMessageManager sharedManager] addFriendsToGroupWithUserid:@[_userid] groupid:model.roomid type:1 agr:@"true"];
    
}

//添加群成员回调
-(void)addFriendsToGroupCB:(NSArray *)result{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if (!result.count==0) {
        
        [self clearNotificationCellWithUserid:_userid];
        
        _userid = nil;
        
    }
    
    //去掉遮罩
    [self removeBackView];
    
}

//拒绝按钮被点击
-(void)didClickRejectButton{
    
    NSLog(@"didClickRejectButton");
    
}

-(void)creatBackView{
    
    _backView = [[UIView alloc] init];
    //_backView.backgroundColor = [UIColor redColor];
    _backView.frame = CGRectMake(0, kTopViewHeight, self.view.frame.size.width, self.view.frame.size.height-kTopViewHeight);
    [self.view addSubview:_backView];
    
}

-(void)removeBackView{
    
    //如果已经去掉了就算了
    if (_backView==nil) {
        
        return;
        
    }
    
    [_backView removeFromSuperview];
    
    _backView = nil;
    
}

@end
