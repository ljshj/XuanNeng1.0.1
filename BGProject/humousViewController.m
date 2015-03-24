//
//  humousViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//


#import "humousViewController.h"
#import "MoudleMessageManager.h"
#import "SVProgressHUD.h"
#import "FDSPublicManage.h"
#import "MJRefresh.h"
#import "BGPublishView.h"
#import "XuanNengPaiHangBangCell.h"
#import "XuanNengDetailViewController.h"
#import "BGWQCommentModel.h"
#import "FDSUserManager.h"

#define kCommentsKey @"comments"
// 投稿

// 正在审核的稿件
//#import "CheckingTopicCell.h"
//我的投稿 //0，未审核；1：审核通过
#define kTypeForSubmit  1
//审核中
#define kTypeForCheck   0

#define kRequestCount 10


@interface humousViewController ()<XuanNengPaiHangBangCellDelegate>




-(void)requestDeleteTopicCB:(int)result;

@end

@implementation humousViewController

{
    UIView    *topView;
    UIButton  *backBtn;
    
    
    //我的投稿
    UIButton *btn1;
    // 审核中
    UIButton *btn2;
    //审核失败
    UIButton *btn3;
    UIView   *MoveView;
    UITableView *myTableView;
    
    // 分别记录 我的投稿 、审核中的请求起始索引。
    int _submitStart;
    int _checkStart;
    int _failureStart;
    
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    
    NSIndexPath *_selectedDetailIndexpath;
    
    //发送框
    BGPublishView *_publishView;
    //协助下拉键盘的背景图
    __weak UIView *_keyboardBackView;
    
    
    // 保存我的投稿和 审核中的数据
    NSMutableArray* _submitJokes;
    NSMutableArray* _checkJokes;
    NSMutableArray *_failureJokes;
    
    // 标记 btn1 btn2 哪个被选中
    UIButton* _selectedButton;
    NSIndexPath* _deleteIndexPath;
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)CreatTopView
{
    //导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(130, 24, 60, 40)];
    label1.text = @"幽默秀";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    [self.view addSubview:topView];
    
    //分割线
    UIView *barr1 =[[UIView alloc]initWithFrame:CGRectMake(0, topView.frame.origin.y+topView.frame.size.height, 320, 0.5)];
    barr1.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [self.view addSubview:barr1];
    
    CGFloat buttonW = self.view.frame.size.width/3;
    
    //我的投稿按钮
    btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, topView.frame.origin.y+topView.frame.size.height+0.5,buttonW, 40);
    [btn1 setTitle:@"已审核" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(treds:) forControlEvents:UIControlEventTouchUpInside];
    btn1.backgroundColor =[UIColor whiteColor];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    // 默认btn1 被选中
    _selectedButton = btn1;
    
#pragma mark-请求我的投稿
    //默认请求@"已审核"
    [self treds:btn1];
    
    //分割线
    UIView *barr2 =[[UIView alloc]initWithFrame:CGRectMake(btn1.frame.origin.x+btn1.frame.size.width,btn1.frame.origin.y,0.5, 40)];
    barr2.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [self.view addSubview:barr2];
    
    //审核中按钮
    btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(btn1.frame.origin.x+btn1.frame.size.width+0.5,btn1.frame.origin.y, buttonW, 40);
    [btn2 setTitle:@"审核中" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(all:) forControlEvents:UIControlEventTouchUpInside];
    btn2.backgroundColor =[UIColor whiteColor];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    
    //审核中按钮
    btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(btn2.frame.origin.x+btn2.frame.size.width+0.5,btn2.frame.origin.y, buttonW, 40);
    [btn3 setTitle:@"审核失败" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(failureAudit:) forControlEvents:UIControlEventTouchUpInside];
    btn3.backgroundColor =[UIColor whiteColor];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    
    //底部的分割线
    UIView  *BootView = [[UIView alloc]initWithFrame:CGRectMake(0, btn1.frame.origin.y+btn1.frame.size.height, 320, 0.5)];
    [BootView setBackgroundColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1]];
    [self.view addSubview:BootView];
    
    //滑动条
    MoveView = [[UIView alloc]initWithFrame:CGRectMake(0,0, buttonW, 2)];
    [MoveView setBackgroundColor:[UIColor blueColor]];
    [BootView addSubview:MoveView];
    
    CGRect screenRect = [[UIScreen mainScreen]bounds];
    CGFloat tableViewHeight = 0;
    CGFloat myTableViewY = 0;
    NSString *userid = [[FDSUserManager sharedManager] NowUserID];
    
    //如果不是当前登录用户的炫能，就隐藏审核状态
    if ([userid isEqualToString:self.userid]) {
        
        tableViewHeight = screenRect.size.height  - (CGRectGetMaxY(BootView.frame)+3);
        myTableViewY = CGRectGetMaxY(BootView.frame)+2;
        
    }else{
        
        tableViewHeight = screenRect.size.height  - kTopViewHeight;
        myTableViewY = CGRectGetMaxY(topView.frame)+2;
    }
    
    CGFloat myTableViewX = 0;
    CGFloat myTableViewW = self.view.bounds.size.width;
    CGFloat myTableViewH = tableViewHeight;
    myTableView = [[UITableView alloc] init];
    myTableView.frame = CGRectMake(myTableViewX, myTableViewY, myTableViewW, myTableViewH);
    myTableView.delegate = self;
    myTableView.dataSource =  self;
    myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    myTableView.bounces = YES;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
    [self.view addSubview:myTableView];

}

-(void)setupMoreData{
    
    // 防止block循环retain，所以用__unsafe_unretained
    __unsafe_unretained humousViewController *vc = self;
    
    //集成下拉刷新控件
    _header = [MJRefreshHeaderView header];
    _header.scrollView = myTableView;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        
        
        if (vc->btn1.selected==YES) {
            
            //先将开始请求标识为0，重新请求
            vc->_submitStart=0;
            
            //将数组清空
            [vc->_submitJokes removeAllObjects];
            
            //发送我的投稿消息
            [[MoudleMessageManager sharedManager] requestSubmittedTopicList:kTypeForSubmit start:vc->_submitStart end:(vc->_submitStart+kRequestCount) userid:vc->_userid];
            
        }else if(vc->btn2.selected==YES){
            
            vc->_checkStart=0;
            
            [vc->_checkJokes removeAllObjects];
            
            [[MoudleMessageManager sharedManager] requestSubmittedTopicList:kTypeForCheck start:vc->_checkStart end:(vc->_checkStart+kRequestCount) userid:vc->_userid];
            
        }else{
            
            vc->_failureStart=0;
            
            [vc->_failureJokes removeAllObjects];
            
            [[MoudleMessageManager sharedManager] requestSubmittedTopicList:-1 start:vc->_failureStart end:(vc->_failureStart+kRequestCount) userid:vc->_userid];
            
        }
        
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadDeals) withObject:nil afterDelay:3];
        
    };
    
    // 集成上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = myTableView;
    
    // 进入上拉加载状态就会调用这个方法
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        if (vc->btn1.selected==YES) {
            
            NSString *_submitStartStr = [NSString stringWithFormat:@"%d",vc->_submitStart];
            
            if ([_submitStartStr hasSuffix:@"0"]) {
                
                [[MoudleMessageManager sharedManager] requestSubmittedTopicList:kTypeForSubmit start:vc->_submitStart end:(vc->_submitStart+kRequestCount) userid:vc->_userid];
                
            }else{
                
                //提示没有更多数据
                [vc performSelector:@selector(showNoDataInfo) withObject:nil afterDelay:0];
                
            }
            
        }else if(vc->btn2.selected==YES){
            
            NSString *_checkStartStr = [NSString stringWithFormat:@"%d",vc->_checkStart];
            
            if ([_checkStartStr hasSuffix:@"0"]) {
                
                [[MoudleMessageManager sharedManager] requestSubmittedTopicList:kTypeForCheck start:vc->_checkStart end:(vc->_checkStart+kRequestCount) userid:vc->_userid];
                
            }else{
                
                //提示没有更多数据
                [vc performSelector:@selector(showNoDataInfo) withObject:nil afterDelay:0];
                
            }
            
        }else{
            
            NSString *_failureStartStr = [NSString stringWithFormat:@"%d",vc->_failureStart];
            
            if ([_failureStartStr hasSuffix:@"0"]) {
                
                [[MoudleMessageManager sharedManager] requestSubmittedTopicList:-1 start:vc->_failureStart end:(vc->_failureStart+kRequestCount) userid:vc->_userid];
                
            }else{
                
                //提示没有更多数据
                [vc performSelector:@selector(showNoDataInfo) withObject:nil afterDelay:0];
                
            }
            
        }
        
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadDeals) withObject:nil afterDelay:3];
        
    };
    
}

-(void)showNoDataInfo{
    
    [self reloadDeals];
    
    //提示框
    [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"已经没有的数据了"];
    
}

//刷新表格
- (void)reloadDeals
{
    [myTableView reloadData];
    // 结束刷新状态
    [_footer endRefreshing];
    [_header endRefreshing];
}

#pragma mark btnClick===================

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//审核失败按钮被点击
-(void)failureAudit:(UIButton *)sender{
    
    _selectedButton = sender;
    
    btn1.selected = NO;
    btn2.selected = NO;
    btn3.selected = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        MoveView.frame = CGRectMake(self.view.frame.size.width/3*2,0, self.view.frame.size.width/3, 2);
        
    }];
    
    [btn3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if (_failureStart==0) {
        
        [[MoudleMessageManager sharedManager] requestSubmittedTopicList:-1 start:_failureStart end:kRequestCount userid:self.userid];
        
    }else{
        
        [myTableView reloadData];
        
    }
    
}


 //@"请求所有投稿"
-(void)treds:(UIButton *)sender
{
    _selectedButton = sender;
    
    btn1.selected = YES;
    btn2.selected = NO;
    btn3.selected = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        MoveView.frame = CGRectMake(0,0, self.view.frame.size.width/3, 2);
        
    }];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    if (_submitStart==0) {
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        
        [[MoudleMessageManager sharedManager] requestSubmittedTopicList:kTypeForSubmit start:_submitStart end:(_submitStart+kRequestCount) userid:self.userid];
        
    }else{
        
        [myTableView reloadData];
        
    }
    
}

//请求审核中的
-(void)all:(UIButton *)sender
{
    _selectedButton = sender;
    
    btn2.selected = YES;
    btn1.selected = NO;
    btn3.selected = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        MoveView.frame = CGRectMake(self.view.frame.size.width/3, 0, self.view.frame.size.width/3, 2);
    }];
    [btn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   // NSLog(@"请求审核中的");
    
    if (_checkStart==0) {
        
       [[MoudleMessageManager sharedManager] requestSubmittedTopicList:kTypeForCheck start:_checkStart end:(_checkStart+kRequestCount) userid:self.userid];
        
    }else{
        
        [myTableView reloadData];
        
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _submitStart = 0;
    _checkStart = 0;
    _submitJokes = [NSMutableArray array];
    _checkJokes = [NSMutableArray array];
    _failureJokes = [NSMutableArray array];
    
    _selectedButton = btn1;
    
    [self CreatTopView];
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    
    [self setupMoreData];
    
}


#pragma mark tabelViewDataSource-=-------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    
    if(_selectedButton ==  btn1) {
        
        count = (int)[_submitJokes count];
   
    }else if(_selectedButton ==  btn2){
        
        count = (int)[_checkJokes count];
        
    }else{
        
        
        count = (int)[_failureJokes count];
    }
    
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellHeight = 20;
    
    
    JokeModel* joke = nil;
    
    XuanNengPaiHangBangCellFrame* cf =[[XuanNengPaiHangBangCellFrame alloc] init];
    
    
    if (btn1.selected == YES) {
        
        joke = _submitJokes[indexPath.row];
        
    }else if(btn2.selected == YES){
        
        joke = _checkJokes[indexPath.row];
        
        //不算操作条的高度
        cf.needHideBottomBar = YES;
        
    }else{
        
        joke = _failureJokes[indexPath.row];
        
        //不算操作条的高度
        cf.needHideBottomBar = YES;
        
    }
    
    if(joke !=nil) {
        
        cf.model = joke;
        cellHeight = cf.cellHight;
    }
    
    return cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(btn1.selected == YES)
    {
        static NSString *identifier = @"CellOne";
        XuanNengPaiHangBangCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[XuanNengPaiHangBangCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.delegate = self;
            // 这是个bug。
            //  cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSString *userid = [[FDSUserManager sharedManager] NowUserID];
        if ([userid isEqualToString:self.userid]) {
            
            cell.needHideDeleteButton = NO;
            
        }else{
            
            cell.needHideDeleteButton = YES;
            
        }

        JokeModel* model = _submitJokes[indexPath.row];
        XuanNengPaiHangBangCellFrame* cellframe = [[XuanNengPaiHangBangCellFrame alloc]init];
        
        cellframe.model = model;
        cell.cellFrame = cellframe;
        return cell;
        
    }else if(btn2.selected == YES){
        // 显示审核的数据
        static NSString *identifier = @"CellTow";
        XuanNengPaiHangBangCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[XuanNengPaiHangBangCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.delegate = self;
        }
        cell.needHideDeleteButton = YES;
        
        JokeModel* model = _checkJokes[indexPath.row];
        XuanNengPaiHangBangCellFrame* cellframe = [[XuanNengPaiHangBangCellFrame alloc]init];
        cellframe.needHideBottomBar = YES;
        cellframe.model = model;
        cell.cellFrame = cellframe;
        return cell;
    }
    
    // 显示审核的数据
    static NSString *identifier = @"CellTow";
    XuanNengPaiHangBangCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[XuanNengPaiHangBangCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
    }
    cell.needHideDeleteButton = YES;
    
    JokeModel* model = _failureJokes[indexPath.row];
    XuanNengPaiHangBangCellFrame* cellframe = [[XuanNengPaiHangBangCellFrame alloc]init];
    cellframe.needHideBottomBar = YES;
    cellframe.model = model;
    cell.cellFrame = cellframe;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选中后效果立马消失，封装了一下
    [self tableViewDeSelect:tableView];
    
    
    //取出cell
    XuanNengPaiHangBangCell* cell =(XuanNengPaiHangBangCell*) [tableView cellForRowAtIndexPath:indexPath];
    
    //取出model
    JokeModel* model = cell.cellFrame.model;
    
    //记录选中的行数
    _selectedDetailIndexpath = indexPath;
    
    //70009 发送笑话详情消息
    [[MoudleMessageManager sharedManager] requestJoke:model.jokeid :0 :kRequestCount];
    
}

//笑话详情回调
-(void)requestJokeCB:(NSDictionary *)result{
    
    //如果字典存在
    if (result) {
        //取出cell
        XuanNengPaiHangBangCell* cell =(XuanNengPaiHangBangCell*) [myTableView cellForRowAtIndexPath:_selectedDetailIndexpath];
        
        //取出model
        JokeModel* model = cell.cellFrame.model;
        
        //初始化控制器
        XuanNengDetailViewController*  detailVC = [[XuanNengDetailViewController alloc]init];
        
        //取得模型
        detailVC.model = model;
        
        //取出评论数组
        NSArray *comments = result[kCommentsKey];
        
        //将字典转换成模型
        for (NSDictionary *dic in comments) {
            
            //字典转换成模型
            BGWQCommentModel *model = [BGWQCommentModel commentWithDic:dic];
            //添加到评论模型数组中去
            [detailVC.commentsArray addObject:model];
            
        }
        
        //切换控制器
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    
}

//deselected the cell
-(void)tableViewDeSelect:(UITableView*)table
{
    NSIndexPath* indexPath = [table indexPathForSelectedRow];
    [table deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    
    [[MoudleMessageManager sharedManager]registerObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
    
    [SVProgressHUD popActivity] ;
    [[MoudleMessageManager sharedManager]unRegisterObserver:self];
}

//请求我的投稿回调
-(void)requestSubmittedTopicListCB:(NSArray*)result {
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if(btn1.selected==YES) {
        
        //往所有产品中添加最新的数据
        [_submitJokes addObjectsFromArray:result];
        
        //修改请求开始标识
        _submitStart = _submitStart+(int)result.count;
        
    }else if(btn2.selected){
        
        //往所有产品中添加最新的数据
        [_checkJokes addObjectsFromArray:result];
        
        //修改请求开始标识
        _checkStart = _checkStart+(int)result.count;
        
    }else{
        
        //往失败数组添加最新的数据
        [_failureJokes addObjectsFromArray:result];
        
        //修改请求开始标识
        _failureStart = _failureStart+(int)result.count;
        
    }

    // 更新数据
    [myTableView reloadData];
    
}



//删除炫能回调
-(void)SubmittedTopicCellDelete:(XuanNengPaiHangBangCell *)cell
{
    // 通过selectButton 来区分不同tableview的单元格
    
    if(_selectedButton == btn1)
    {
        //请求删除服务器删除  60004
        // 首先计算出要删除单元格的位置 ，保存到 deleteIndexPath,后面的cb用到该位置
        JokeModel* model = cell.cellFrame.model;
        NSInteger index = [_submitJokes indexOfObject:model];
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
        _deleteIndexPath = indexpath;
        
        int jokeid = [model.jokeid intValue];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        //2014年10月11日
        //
        //[UIAlertView showMessage:@"服务器没有提供删除接口,敬请期待"];
        [[MoudleMessageManager sharedManager]requestDeleteTopic:jokeid];
        
    }
    else
    {
        
        
        //请求删除服务器删除  60004
        // 首先计算出要删除单元格的位置 ，保存到 deleteIndexPath,后面的cb用到该位置
        JokeModel* model = cell.cellFrame.model;
        NSInteger index = [_checkJokes indexOfObject:model];
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
        _deleteIndexPath = indexpath;
        
        int jokeid = [model.jokeid intValue];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        //2014年10月11日
        //
        //[UIAlertView showMessage:@"服务器没有提供删除接口,敬请期待"];
        [[MoudleMessageManager sharedManager]requestDeleteTopic:jokeid];
    }
}

//删除炫能回调
-(void)requestDeleteTopicCB:(int)result
{
    [SVProgressHUD popActivity];
    if(result == 0)
    {
        if(_selectedButton == btn1)
        {
            [_submitJokes removeObjectAtIndex:_deleteIndexPath.row];
            [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:_deleteIndexPath]
                               withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [_checkJokes removeObjectAtIndex:_deleteIndexPath.row];
            [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:_deleteIndexPath]
                               withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}



@end
