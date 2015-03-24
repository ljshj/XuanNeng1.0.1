//
//  myFansViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "myFansViewController.h"
#import "AppDelegate.h"
#import "FanCell.h"
#import "SVProgressHUD.h"
#import "FDSUserCenterMessageManager.h"
#import "FDSUserManager.h"
#import "MJRefresh.h"
#import "PersonlCardViewController.h"

@interface myFansViewController ()<FanCellDelegate>


@end

@implementation myFansViewController

{
    UIView    *topView;
    UIButton  *backBtn;
    UITableView *myTableView;
    
    FanCell* _fancell;// 这里应该用一个数组，要不然只能慢慢的提交一个操作
    
    NSString *_userid;
    
    NSString *_guanzhuUserid;
    
    BOOL _buttonStaus;
    
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    NSUInteger _focusStartTag;
    
    NSString *_otherUserid;
    
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
    
    
    
    //隐藏tabbar
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app hiddenTabelBar];
    
    //注册代理
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
    
    if (self.isClickPhoto) {
        
        //删除全部数据
        [_fans removeAllObjects];
        
        //修改请求标记为0
        _focusStartTag = 0;
        
        //发送请求关注列表消息(0表示我关注的,1:我的粉丝)
        [[FDSUserCenterMessageManager sharedManager] requestAttentionListWithType:1 start:(int)_focusStartTag end:(int)_focusStartTag+kRequestCount];
        
        //修改回来
        self.isClickPhoto = NO;
        
    }
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //去掉代理
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _focusStartTag = self.fans.count;
    
    //创建页面
    [self CreatView];
    
    //刷新数据
    [self setupMoreData];
    
    //背景颜色
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];

}

//刷新数据
-(void)setupMoreData{
    
    // 防止block循环retain，所以用__unsafe_unretained
    __unsafe_unretained myFansViewController *vc = self;
    
    //集成下拉刷新控件
    _header = [MJRefreshHeaderView header];
    _header.scrollView = myTableView;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        
        //删除全部数据
        [vc->_fans removeAllObjects];
        
        //修改请求标记为0
        vc->_focusStartTag = 0;
        
        //发送请求关注列表消息(0表示我关注的)
        [[FDSUserCenterMessageManager sharedManager] requestAttentionListWithType:1 start:vc->_focusStartTag end:vc->_focusStartTag+kRequestCount];
        
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadDeals) withObject:nil afterDelay:3];
    };
    
    // 集成上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = myTableView;
    
    // 进入上拉加载状态就会调用这个方法
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        NSString *focusStartTagStr = [NSString stringWithFormat:@"%d",vc->_focusStartTag];
        
        if ([focusStartTagStr hasSuffix:@"0"]) {
            
            //发送请求关注列表消息(0表示我关注的)
            [[FDSUserCenterMessageManager sharedManager] requestAttentionListWithType:1 start:vc->_focusStartTag end:vc->_focusStartTag+kRequestCount];
            
        }else{
            
            //提示没有更多数据
            [vc performSelector:@selector(showNoDataInfo) withObject:nil afterDelay:0];
            
        }
        
        // 3秒后刷新表格
        [vc performSelector:@selector(reloadDeals) withObject:nil afterDelay:3];
    };
    
}

-(void)showNoDataInfo{
    
    [self reloadDeals];
    
    //提示框
    [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"已经没有更多的关注用户"];
    
}

//刷新表格
- (void)reloadDeals
{
    [myTableView reloadData];
    // 结束刷新状态
    [_footer endRefreshing];
    [_header endRefreshing];
}

-(void)CreatView
{
    //导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    label1.text = @"我的粉丝";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    [self.view addSubview:topView];
    
    //表格
    CGFloat myTableViewH = self.view.frame.size.height-kTopViewHeight;
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, myTableViewH) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource =  self;
    myTableView .rowHeight =  80;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    
}

#pragma mark btnClick===================

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark tabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _fans.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellOne";
    FanCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FanCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        if(indexPath.row == 0)
        {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamedForResizeAble:@"cell_bg.png"]];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    FanCellFrame* cellFrame = [[FanCellFrame alloc]init];
    cellFrame.fan = _fans[indexPath.row];
    cell.cellFrame = cellFrame;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FanCellFrame* cellFrame = [[FanCellFrame alloc]init];
    cellFrame.fan = _fans[indexPath.row];
    return cellFrame.cellHeight;
}

//点击关注按钮的回调
-(void)didClickButtonWithUserid:(NSString *)userid buttonStaus:(BOOL)selected{
    
    //如果selected为NO发送的是关注消息，YES的就是发送取消关注消息（关注0、取消关注1）

    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //记录下操作的userid
    _guanzhuUserid = userid;
    
    //记录下按钮的状态(根据状态来决定对关注数的更改，NO增加关注数，YES减少关注数)
    _buttonStaus = selected;
    
    //发送关注或者取消关注消息
    [[FDSUserCenterMessageManager sharedManager]attentionPerson:userid type:selected];
    

}

//粉丝列表回调（关注／取消关注）
-(void)attentionPersonCB:(int)returnCode {
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if (returnCode==0) {
        
        //发送通知（修改按钮的状态）
        [[NSNotificationCenter defaultCenter]
         postNotificationName:SetupButtonStausKey object:_guanzhuUserid];
        
        //取出当前登录用户模型
        BGUser *user = [[FDSUserManager sharedManager] getNowUser];
        
        //取出关注数
        int focusNum = [user.guanzhu intValue];
        
        //根据按钮状态修改关注数(NO增加关注数，YES减少关注数)
        if (_buttonStaus) {
            
            //较少关注数
            user.guanzhu = [NSString stringWithFormat:@"%d",focusNum-1];
            
        }else{
            
            //增加关注数
            user.guanzhu = [NSString stringWithFormat:@"%d",focusNum+1];
            
        }
        
    }


}

//我的关注回调
-(void)requestAttentionListCB:(NSArray*)array {
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //干嘛取出第一个？？其他的都一样的
    FriendModel* model = nil;
    
    if (array.count!=0) {
        
        model = array[0];
        
    }
    
    int searchtype = model.searchtype;
    
    //0表示我的粉丝
    if(searchtype == 1) {
        
        for (FriendModel *friModel in array) {
            
            [self.fans addObject:friModel];
            
        }
        
        //修改请求开始标记
        _focusStartTag = _focusStartTag+array.count;
        
    }
    
    [myTableView reloadData];
    
}

//头像点击回调
-(void)fansPersontap:(NSString *)userid{
    
    //回来刷新列表
    self.isClickPhoto = YES;
    
    //记录下userid
    _otherUserid = userid;
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //获取个人资料
    [[FDSUserCenterMessageManager sharedManager] userRequestUserInfo:userid];
    
    //不是用户本身的
    [FDSUserCenterMessageManager sharedManager].userInfoType=UserInfoTypeOtherUserInfo;
    
}

-(void)getUserInfoCB:(NSDictionary *)dic{
    
    if ([FDSUserCenterMessageManager sharedManager].userInfoType==UserInfoTypeOtherUserInfo) {
        
        PersonlCardViewController *pv = [[PersonlCardViewController alloc] init];
        pv.userDic = dic;
        pv.userid = _otherUserid;
        [self.navigationController pushViewController:pv animated:YES];
        
    }
    
}


@end
