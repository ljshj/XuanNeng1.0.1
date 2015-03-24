//
//  GroupInfoViewController.m
//  BGProject
//
//  Created by liao on 14-12-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "GroupInfoViewController.h"
#import "GroupMemberView.h"
#import "GroupExitAndClearView.h"
#import "EaseMob.h"
#import "ZZUserDefaults.h"
#import "FDSPublicManage.h"
#import "PlatformMessageManager.h"
#import "FriendCellModel.h"
#import "FDSUserManager.h"
#import "Cell.h"
#import "SVProgressHUD.h"
#import "InviteMembersViewController.h"
#import "BaseCellFrame.h"
#import "RelatedGroupViewController.h"
#import "PersonlCardViewController.h"

#define ClearButtonTitle @"确定删除?"
#define DisbandTitle @"确定解散该群？"
#define ExitGoupTitle @"确定退出该群？"


#define DividerColor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]
#define DividerFrameZero CGRectMake(0,44-0.5 , self.view.bounds.size.width, 0.5)
#define DividerFrameBottom CGRectMake(10,44-0.5 , self.view.bounds.size.width-10, 0.5)
#define DividerFrameTop CGRectMake(13,0.5,self.view.bounds.size.width-13, 0.5)


@interface GroupInfoViewController ()<UITableViewDataSource,UITableViewDelegate,GroupExitAndClearViewDelegate,UIAlertViewDelegate,PlateformMessageInterface,UICollectionViewDataSource,UICollectionViewDelegate,MemberCellDelegate,UserCenterMessageInterface>

@end

@implementation GroupInfoViewController{
    
    UIView *topView;
    UIButton *backBtn;
    
    __weak UITableView *_tableView;
    __weak UICollectionView *_collectionView;
    
    NSMutableArray *_titleArray;
    NSMutableArray *_datailTitleArray;
    
    NSString *_userid;
    
    //被点击群成员的userid
    NSString *_selectedUserid;
    
}

-(NSMutableArray *)members{
    
    if (_members==nil) {
        
        _members = [[NSMutableArray alloc] init];
        
    }
    
    return _members;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    
    //注册代理
    [[PlatformMessageManager sharedManager] registerObserver:self];
    
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    
    
    //去掉代理
    [[PlatformMessageManager sharedManager] unRegisterObserver:self];
    
    [[FDSUserCenterMessageManager sharedManager] unRegisterObserver:self];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //初始化数组
    [self setupDataArrays];
    
    //导航栏
    [self addTopBar];
    
    //表格
    [self addTableView];
    
}

//初始化数组
-(void)setupDataArrays{
    
    //初始化标题数组
    _titleArray = [[NSMutableArray alloc] initWithObjects:@"群组ID",@"群组人数",@"群设置", nil];
    
    //拼接群人数标签
    NSString *menbersCount = [NSString stringWithFormat:@"%d/200",self.members.count];
    
    //构建副标题数组
    _datailTitleArray = [[NSMutableArray alloc] initWithObjects:self.hxgroupid,menbersCount,@"", nil];
    
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
    label1.text = @"群详情";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    if (self.chatType==ChatTypeGroupTemp) {
        
        UIButton *relGroupButton = [[UIButton alloc] init];
        CGFloat relatedGroupW = 70;
        CGFloat relatedGroupX = self.view.frame.size.width-relatedGroupW-10;
        CGFloat relatedGroupY = 27;
        CGFloat relatedGroupH = 30;
        relGroupButton.frame = CGRectMake(relatedGroupX, relatedGroupY, relatedGroupW, relatedGroupH);
        [relGroupButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [relGroupButton setTitle:@"相关群组" forState:UIControlStateNormal];
        relGroupButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        relGroupButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [relGroupButton addTarget:self action:@selector(relGroupButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:relGroupButton];
        
    }
}

//更多群组按钮点击
-(void)relGroupButtonClick{
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //发送搜索群消息
    [[PlatformMessageManager sharedManager] findGroupWithKeyword:self.groupname start:0 end:10];
    
}

-(void)BackMainMenu:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
    
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    CGFloat collectionViewH = [self getCollectionViewH];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, collectionViewH) collectionViewLayout:layout];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[Cell class] forCellWithReuseIdentifier:@"Cell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    _collectionView = collectionView;
    _tableView.tableHeaderView = collectionView;
    
    //清除和退出按钮
    GroupExitAndClearView *exitAndClearView = [[GroupExitAndClearView alloc] init];
    exitAndClearView.isGroupOwer = [self isGroupOwner];
    exitAndClearView.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
    exitAndClearView.delegate = self;
    _tableView.tableFooterView = exitAndClearView;
    
}

//根据是否是群主获取不同的
-(CGFloat)getCollectionViewH{
    
    CGFloat collectionViewH = 0;
    
    if ([self isGroupOwner]) {
        
        if (self.members.count<=3) {
            
            collectionViewH  = 52+20;
            
        }else{
            
            collectionViewH  = 52*2+30;
            
        }
        
    }else{
        
        if (self.members.count<=5) {
            
            collectionViewH  = 52+20;
            
        }else{
            
            collectionViewH  = 52*2+30;
            
        }
    }
    
    return collectionViewH;
    
}

#pragma mark-UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *indentifier = @"GroupInfo";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
        
        if (indexPath.row==0) {
            
            //添加顶部分割线
            [self addDividerTopWithCell:cell indexPath:indexPath];
            
        }
        
        //添加底部分割线
        [self addDividerBottomWithCell:cell indexPath:indexPath];
        
    }
    
    
    //设置标题
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    
    //设置副标题
    cell.detailTextLabel.text = _datailTitleArray[indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    
}

#pragma mark-GroupExitAndClearViewDelegate

-(void)didClickClearButton{
    
    //提示框
    [self alertviewShowWitnMessage:ClearButtonTitle alertViewType:AlertViewTypeClearHistory];
    
}

-(void)didClickExitButton{
    
    if ([self isGroupOwner]) {
        
        //提示框(类型一样影响不大)
        [self alertviewShowWitnMessage:DisbandTitle alertViewType:AlertViewTypeExit];
        
    }else{
        
        //提示框
        [self alertviewShowWitnMessage:ExitGoupTitle alertViewType:AlertViewTypeExit];
        
    }
    
}

#pragma mark-PlateformMessageInterface

//解散群回调
-(void)disbandGroupCB:(int)result{
    
    //解散成功后，要删除会话对象以及messageid
    if (result==0) {
        
        //删除messageID和会话对象
        [self deleteConversationAndMessageID];
        
        //还要从数据库里面删掉
        [[DataBaseSimple shareInstance] deleteGroupswithHxgroupid:self.hxgroupid];
        
        //移除这个群的全部成员
        [[DataBaseSimple shareInstance] deleteGroupMemberWithHxgroupid:self.hxgroupid];
        
        //将相关的会话对象和messageID去掉(不再判断了，没去掉算了)
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:self.hxgroupid deleteMessages:YES];
        
        [[DataBaseSimple shareInstance] deleteMessageidWithUsername:self.hxgroupid];
        
        //发送通知
        [[NSNotificationCenter defaultCenter]
         postNotificationName:DisbandGroupKey object:nil];
        
        
        //直接pop到跟控制器，刷新列表
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    
}

//退出群回调
-(void)exitGroupCB:(int)result{
    
    //退群成功后
    if (result==0) {
        
        //要删除会话对象以及messageid
        [self deleteConversationAndMessageID];
        
        //还要从数据库里面删掉
        [[DataBaseSimple shareInstance] deleteGroupswithHxgroupid:self.hxgroupid];
        
        //移除这个群的全部成员
        [[DataBaseSimple shareInstance] deleteGroupMemberWithHxgroupid:self.hxgroupid];
        
        //将相关的会话对象和messageID去掉(不再判断了，没去掉算了)
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:self.hxgroupid deleteMessages:YES];
        
        [[DataBaseSimple shareInstance] deleteMessageidWithUsername:self.hxgroupid];
        
        //发送通知
        [[NSNotificationCenter defaultCenter]
         postNotificationName:DisbandGroupKey object:nil];
        
        //直接pop到跟控制器，刷新列表
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    
}

#pragma mark-UIAlertViewDelegate
//弹出邀请对话框
-(void)alertviewShowWitnMessage:(NSString *)msg alertViewType:(AlertViewType)alertViewType{
    
    //设置弹框类型
    self.alertViewType = alertViewType;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alert show];
    
    
}

//alertView代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        
        if (self.alertViewType==AlertViewTypeClearHistory) {
            
            //清除聊天记录
            [self ClearChatHistory];
            
        }else{
            
            //退出按钮按下确定
            self.isExitButtonEnsure = YES;
            
            if ([self isGroupOwner]) {
                
                //发送解散群的消息
                [[PlatformMessageManager sharedManager] disbandGroupWithGroupid:self.roomid];
                
            }else{
                
                //取得当前用户userid
                NSString *userid = [[FDSUserManager sharedManager] NowUserID];
                
                //发送退出群的消息
                [[PlatformMessageManager sharedManager] exitGroupWithGroupid:self.roomid userid:userid];
            }
            
        }
        
    }
    
}

//清除聊天记录
-(void)ClearChatHistory{
    
    //删除会话对象以及messageid
    [self deleteConversationAndMessageID];
    
    //获取所有的会话
    NSArray *conversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabase];
    
    //遍历会话对象
    for (EMConversation *conversation in conversations){
        
        if ([conversation.chatter isEqualToString:self.hxgroupid]) {
            
            //删除失败
            [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"删除失败"];
            
            //如果删除失败就不显示下面的提示框
            return;
        }
        
    }
    
    //删除失败
    [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"删除成功"];
    
    //删除历史成功（可以属性回调删除列表数组元素）
    //self.isClearChatHistory = YES;
    
    //发送通知
    [[NSNotificationCenter defaultCenter]
     postNotificationName:ClearChatHistoryKey object:nil];
    
}

//删除聊天记录以及存储的messageID
-(void)deleteConversationAndMessageID{
    
    NSArray *array = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabase];
    
    //首先将messageids置空
    [[DataBaseSimple shareInstance] deleteMessageidWithUsername:self.hxgroupid];
    
    //删除群会话对象(这个判断不准都是YES)
    [[EaseMob sharedInstance].chatManager removeConversationByChatter:self.hxgroupid deleteMessages:YES];

    
}



//判断当前登录用户是否是群主
-(BOOL)isGroupOwner{
    
    NSString *groupOwerUserid = nil;
    
    //取出群主模型
    for (FriendCellModel *model in self.members) {
        
        if (model.type==2) {
            
            //记录下群主的userid
            groupOwerUserid = model.userid;
            
        }
        
    }
    
    //取出当前登录用户的userid
    NSString *userid = [[FDSUserManager sharedManager] NowUserID];
    
    //是否是群主
    BOOL isGroupOwer = NO;
    
    if ([userid isEqualToString:groupOwerUserid]) {
        
        isGroupOwer = YES;
        
    }
    
    return isGroupOwer;
    
}

//添加底部分割线
-(void)addDividerBottomWithCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = DividerColor;
    
    if (indexPath.row==2) {
        
        divider.frame = DividerFrameZero;
        
    }else{
        
        divider.frame = DividerFrameBottom;
        
    }
    
    
    [cell addSubview:divider];
    
}


//添加顶部分割线
-(void)addDividerTopWithCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = DividerColor;
    divider.frame = DividerFrameTop;
    [cell addSubview:divider];
}

#pragma mark-UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    int itemCount = 0;
    
    //只有群主才会显示出后面两个邀请和移除按钮
    if ([self isGroupOwner]) {
        
        itemCount = self.members.count+2;
        
    }else{
        
        itemCount = self.members.count;
        
    }
    
    return itemCount;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(52, 52);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Cell *Cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Cell.delegate = self;
    FriendCellModel *model = nil;
    if (indexPath.row<=self.members.count-1) {
       model = self.members[indexPath.row];
    }
    
    
    if (indexPath.row==self.members.count) {

        [Cell setImage:@"addMembers" title:nil isMember:NO];
        
    }else if (indexPath.row==self.members.count+1){
        
        [Cell setImage:@"deleteMembers" title:nil isMember:NO];
        
    }else{
        
        [Cell setImage:model.image title:model.name isMember:YES];
        Cell.model = model;
    }
    
    
    return Cell;
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    //(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
}

//设置每一行之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==self.members.count+1) {
        
        //修改属性，通过改变属性来控制删除图标的显示与否
        self.isDelete = !self.isDelete;
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:isDeleteKey object:[NSNumber numberWithBool:self.isDelete]];
        
    }else if (indexPath.row==self.members.count){
        
        //邀请群成员(跟建群那个控制器是一样的)
        InviteMembersViewController *vc = [[InviteMembersViewController alloc] init];
        
        //取得环信ID
        vc.hxgroupid = self.hxgroupid;
        
        //取得成员数组
        vc.members = self.members;
        
        //取得炫能群ID
        vc.roomid = self.roomid;
        
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        //取出模型
        FriendCellModel *model = self.members[indexPath.row];
        
        //记录下userid
        _selectedUserid = model.userid;
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        
        //获取个人资料
        [[FDSUserCenterMessageManager sharedManager] userRequestUserInfo:model.userid];
        
        //不是用户本身的
        [FDSUserCenterMessageManager sharedManager].userInfoType=UserInfoTypeOtherUserInfo;
        
    }
    
}

//个人信息回调
-(void)getUserInfoCB:(NSDictionary *)dic{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if ([FDSUserCenterMessageManager sharedManager].userInfoType==UserInfoTypeOtherUserInfo) {
        
        PersonlCardViewController *pv = [[PersonlCardViewController alloc] init];
        pv.userDic = dic;
        pv.userid = _selectedUserid;
        [self.navigationController pushViewController:pv animated:YES];
        
    }
    
    
}


#pragma mark-MemberCellDelegate

//移除群成员
-(void)didClickDeleteButtonWithUserid:(NSString *)userid{
    
    //过滤掉群主
    NSString *loginUserid = [[FDSUserManager sharedManager] NowUserID];
    if ([loginUserid isEqualToString:userid]) {
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"不能删除自己"];
        
        return;
        
    }

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //发送移除群成员消息
    [[PlatformMessageManager sharedManager] deleteGroupMemberWithGroupid:self.roomid userid:userid];
    
    //记录下被删除的userid
    _userid = userid;
    
    
    
}


//移除群成员回调
-(void)deleteGroupMemberCB:(int)result{
    
    [SVProgressHUD popActivity];
    
    if (result==0) {
        
        //如果某个成员被删除了，那么此时的状态应该是NO
        self.isDelete = NO;
        
        //从数据库删掉
        [[DataBaseSimple shareInstance] deleteGroupMemberWithHxgroupid:self.hxgroupid userid:_userid];
        
        [self.members removeAllObjects];
        
        //取出数组
        self.members = [[DataBaseSimple shareInstance] selectMembersWithHxgroupid:self.hxgroupid];
        
        //刷新表格
        [_collectionView reloadData];
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"移除成功"];
        
        
    }
    
}

-(void)findGroupCB:(NSDictionary *)data{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    NSArray *items = data[@"items"];
    
    RelatedGroupViewController *rv = [[RelatedGroupViewController alloc] init];
    
    
    for (NSDictionary *dic in items) {
        
        BaseCellModel *model = [[BaseCellModel alloc] initWithDic:dic];
        
        BaseCellFrame* cellFrame = [[BaseCellFrame alloc]init];
        cellFrame.model = model;
        
        
        [rv.groups addObject:cellFrame];
    }
    
    if (rv.groups.count!=0) {
        
        [self.navigationController pushViewController:rv animated:YES];
        
    }
    
}

-(void)dealloc{
    
    //删除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ClearChatHistoryKey object:nil];
    
    //删除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DisbandGroupKey object:nil];
    
}

@end
