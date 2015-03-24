//
//  myAttentionViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "myAttentionViewController.h"
#import "AppDelegate.h"
#import "MyAttentionCell.h"
#import "FDSUserCenterMessageManager.h"
#import "SVProgressHUD.h"
#import "UIAlertView+Zhangxx.h"
#import "FDSPublicManage.h"
#import "FDSUserManager.h"
#import "MJRefresh.h"
#import "PersonlCardViewController.h"

@interface myAttentionViewController ()

@end

@implementation myAttentionViewController
{
    UIView    *topView;
    UIButton  *backBtn;
    UITableView  *myTableView;
    
    //把模型在数组的的位置标记下来，出来后才能删除
    int _index;
    
    //记录下取消关注的userid
    NSString *_userid;
    
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
    
    //如果点击了头像，有可能已经改了关注状态，回来一定要刷新
    if (self.isClickPhoto) {
        
        //删除全部数据
        [_myAttendList removeAllObjects];
        
        //修改请求标记为0
        _focusStartTag = 0;
        
        //发送请求关注列表消息(0表示我关注的)
        [[FDSUserCenterMessageManager sharedManager] requestAttentionListWithType:0 start:(int)_focusStartTag end:(int)_focusStartTag+kRequestCount];
        
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

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //过来的时候就已经有数据了
    _focusStartTag = self.myAttendList.count;
    
    [self CreatView];
    
    //背景颜色
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    
    //刷新数据
    [self setupMoreData];
    
}

//刷新数据
-(void)setupMoreData{
    
    // 防止block循环retain，所以用__unsafe_unretained
    __unsafe_unretained myAttentionViewController *vc = self;
    
    //集成下拉刷新控件
    _header = [MJRefreshHeaderView header];
    _header.scrollView = myTableView;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        
        //删除全部数据
        [vc->_myAttendList removeAllObjects];
        
        //修改请求标记为0
        vc->_focusStartTag = 0;
        
        //发送请求关注列表消息(0表示我关注的)
        [[FDSUserCenterMessageManager sharedManager] requestAttentionListWithType:0 start:vc->_focusStartTag end:vc->_focusStartTag+kRequestCount];
        
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
            [[FDSUserCenterMessageManager sharedManager] requestAttentionListWithType:0 start:vc->_focusStartTag end:vc->_focusStartTag+kRequestCount];
            
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
    label1.text = @"我的关注";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    [self.view addSubview:topView];
    
    //tableview
    CGFloat myTableViewH = self.view.frame.size.height-kTopViewHeight;
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kTopViewHeight, 320, myTableViewH) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource =  self;
    myTableView.rowHeight =  80;
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
    
    return _myAttendList.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellOne";
    
    MyAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[MyAttentionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.row == 0){
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamedForResizeAble:@"cell_bg.png"]];
        }
    }
    
    MyAttentionCellFrame* cellFrame = [[MyAttentionCellFrame alloc]init];
    cellFrame.myAttentionPerson = _myAttendList[indexPath.row];
    cell.cellFrame = cellFrame;
    
    return cell;
}

-(void)didUnfollowWithUserid:(NSString *)userid{
    
    //记录下取消关注的userid
    _userid = userid;
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //发送关注或者取消关注消息(type:关注0、取消关注1)
    [[FDSUserCenterMessageManager sharedManager]attentionPerson:userid type:1];
    
}

//回调
-(void)attentionPersonCB:(int)returnCode {
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if(returnCode == 0) {
        
        //修改单例里面的数据，过去个人中心页面会刷新
        BGUser *user = [[FDSUserManager sharedManager] getNowUser];
        
        int focusNum = [user.guanzhu intValue];
        user.guanzhu = [NSString stringWithFormat:@"%d",focusNum-1];
        
        //是0可能会重复，搞个－1
        _index = -1;
        
        //删除控制器数组里面的模型
        for (FriendModel *model in _myAttendList) {
            
            if ([model.Userid isEqualToString:_userid]) {
                
                //找出在数组中的标记
                _index = [_myAttendList indexOfObject:model];
                //警告：不能边遍历数组一边删除元素，否则蹦掉
            }
            
        }
        
        //删除数组中对应的元素（一定要先删除数据，先记录下位置）
        [_myAttendList removeObjectAtIndex:_index];
        
        //取出对应位置的indexpath
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:_index inSection:0];
        
        //删除tableview上面对应deleteIndexPath的cell
        [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexpath]
                          withRowAnimation:UITableViewRowAnimationFade];
        
    }else {
        
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"取消关注失败"];
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
    
    //0表示我的关注
    if(searchtype == 0) {
        
        for (FriendModel *friModel in array) {
            
            [self.myAttendList addObject:friModel];
            
        }
        
        //修改请求开始标记
        _focusStartTag = _focusStartTag+array.count;
        
    }
    
    [myTableView reloadData];
    
}

//头像点击回调
-(void)attentionPersontap:(NSString *)userid{
    
    //已经点击头像，回来无论如何都要刷一遍数据
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
