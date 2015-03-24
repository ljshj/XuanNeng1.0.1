//
//  InviteMembersViewController.m
//  BGProject
//
//  Created by liao on 15-1-3.
//  Copyright (c) 2015年 zhuozhong. All rights reserved.
//

#import "InviteMembersViewController.h"
#import "DataBaseSimple.h"
#import "FriendCellFrame.h"
#import "FriendCell.h"
#import "EaseMob.h"
#import "SVProgressHUD.h"
#import "PlatformMessageManager.h"

#define DividerColor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]
#define DividerFrameZero CGRectMake(0,81-0.5 , self.view.bounds.size.width, 0.5)

@interface InviteMembersViewController ()<UITableViewDataSource,UITableViewDelegate,PlateformMessageInterface>

@property(nonatomic,strong) NSMutableArray *friendCellFrames;
@property(nonatomic,strong) NSMutableArray *addMemberArray;
@property(nonatomic,strong) NSMutableArray *addUsernames;
@property(nonatomic,strong) NSMutableArray *addUserids;
@end

@implementation InviteMembersViewController{
    
    __weak UITableView *_tableView;

    
}

-(NSMutableArray *)addUserids{
    
    if (_addUserids==nil) {
        
        _addUserids = [[NSMutableArray alloc] init];
        
    }
    
    return _addUserids;
    
}

-(NSMutableArray *)friendCellFrames{
    
    if (_friendCellFrames==nil) {
        
        _friendCellFrames = [[NSMutableArray alloc] init];
        
    }
    
    return _friendCellFrames;
    
}

-(NSMutableArray *)addMemberArray{
    
    if (_addMemberArray==nil) {
        
        _addMemberArray = [[NSMutableArray alloc] init];
        
    }
    
    return _addMemberArray;
    
}

-(NSMutableArray *)addUsernames{
    
    if (_addUsernames==nil) {
        
        _addUsernames = [[NSMutableArray alloc] init];
        
    }
    
    return _addUsernames;
    
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

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addTopBar];
    
    [self creatTableView];
    
    [self LoadFriends];
    
    
}

-(void)LoadFriends{
    
    //构建userids数组
    NSMutableArray *userids = [[NSMutableArray alloc] init];
    
    //将所有的userid取出来
    for (FriendCellModel *member in self.members) {
        
        [userids addObject:member.userid];
        
    }
    
    //删除数组
    [self.friendCellFrames removeAllObjects];
    
    //取出好友列表
    NSArray *friends = [[DataBaseSimple shareInstance] selectFriends];
    
    for (FriendCellModel *friendModel in friends) {
        
        //如果这个好友不在userids数组，说明还没添加的
        if (![userids containsObject:friendModel.userid]) {
            
            FriendCellFrame* cellFrame = [[FriendCellFrame alloc]init];
            cellFrame.model = friendModel;
            
            [self.friendCellFrames addObject:cellFrame];
            
        }
        
        
        
    }
    
    [_tableView reloadData];
    
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
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(110, 24, 90, 40)];
    label1.text = @"邀请群成员";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    //邀请群成员按钮
    UIButton *ensureButton = [[UIButton alloc] init];
    CGFloat ensureW = 30;
    CGFloat ensureX = self.view.frame.size.width-ensureW-20;
    CGFloat ensureY = 28;
    CGFloat ensureH = 30;
    ensureButton.frame = CGRectMake(ensureX, ensureY, ensureW, ensureH);
    //[ensureButton setImage:[UIImage imageNamed:@"addMembers_ensure"] forState:UIControlStateNormal];
    [ensureButton setTitle:@"确定" forState:UIControlStateNormal];
    ensureButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [ensureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ensureButton addTarget:self action:@selector(ensureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:ensureButton];

}

-(void)ensureButtonClick{
    
    //取得要添加的用户名
    for (FriendCellModel *model in self.addMemberArray) {
        
        NSString *username = [NSString stringWithFormat:@"bg%@",model.userid];
        
        [self.addUserids addObject:model.userid];
        
        [self.addUsernames addObject:username];
        
    }
    
    if (self.addUsernames.count==0) {
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"你还没邀请任何好友"];
        return;
        
    }
    
    //发送环信邀请群成员消息
    EMError *error = nil;
    EMGroup *group = [[EaseMob sharedInstance].chatManager addOccupants:self.addUsernames toGroup:self.hxgroupid welcomeMessage:@"加群" error:&error];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    if (group) {
        
        [[PlatformMessageManager sharedManager] addFriendsToGroupWithUserid:self.addUserids groupid:self.roomid type:1 agr:@"true"];
        
        
    }else{
        
        [SVProgressHUD popActivity];
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"群成员邀请失败"];
        
        [self performSelector:@selector(backToRootVC) withObject:nil afterDelay:2.0];
        
    }
    
}

-(void)addFriendsToGroupCB:(NSArray *)result{
    
    [SVProgressHUD popActivity];
    
    if (!result.count==0) {
        
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"群成员邀请成功"];
        
        [self performSelector:@selector(backToRootVC) withObject:nil afterDelay:2.0];
        
    }else{
        
       [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"群成员邀请失败"];
        
        [self performSelector:@selector(backToRootVC) withObject:nil afterDelay:2.0];
        
    }
    
}

-(void)backToRootVC{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatTableView{
    
    //tableview
    UITableView *myTableView = [[UITableView alloc] init];
    CGFloat myTableViewH = self.view.frame.size.height-kTopViewHeight;
    myTableView.frame = CGRectMake(0, kTopViewHeight, self.view.bounds.size.width, myTableViewH);
    myTableView.delegate = self;
    myTableView.dataSource =  self;
    myTableView.bounces = NO;
    myTableView.separatorColor = [UIColor whiteColor];
    myTableView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:myTableView];
    _tableView = myTableView;

}

#pragma mark-UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _friendCellFrames.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier2 = @"CellTwo";
    
    FriendCell* friendCell = [tableView dequeueReusableCellWithIdentifier:identifier2];
    if(friendCell==nil) {
        friendCell = [[FriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
        friendCell.selectionStyle =UITableViewCellSelectionStyleNone;
        [self addDividerBottomWithCell:friendCell indexPath:indexPath];
    }
    friendCell.cellFrame = self.friendCellFrames[indexPath.row];
    return friendCell;
    
}

//添加底部分割线
-(void)addDividerBottomWithCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = DividerColor;
    
    divider.frame = DividerFrameZero;
    
    
    [cell addSubview:divider];
    
}

//取消选中效果
-(void)tableViewDeSelect:(UITableView*)table
{
    NSIndexPath* indexPath = [table indexPathForSelectedRow];
    [table deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

//将选中的cell的indexPath放进数组_editArray里面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self tableViewDeSelect:tableView];
    
    //定义一个cell来接收选中行的指针
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    for (FriendCellModel *model in self.addMemberArray) {
        
        //取出frame
        FriendCellFrame *frame = self.friendCellFrames[indexPath.row];
        
        //取出模型
        if (model==frame.model) {
            
            [self.addMemberArray removeObject:model];
            
            //设置标记
            cell.accessoryType =  UITableViewCellAccessoryNone;
            
            //返回，不执行一下代码
            return;
            
        }
        
    }
    
    //设置标记
    cell.accessoryType =  UITableViewCellAccessoryCheckmark;
    
    //取出frame
    FriendCellFrame *cellFrame = self.friendCellFrames[indexPath.row];
    
    //取出模型
    FriendCellModel *model = (FriendCellModel *)cellFrame.model;
    
    //添加到数组
    [self.addMemberArray addObject:model];
    
}


-(void)inviteMembersWithhxgroupid:(NSString *)huanxinid{
    
    
    
}


@end
