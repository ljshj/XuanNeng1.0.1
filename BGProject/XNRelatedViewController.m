//
//  XNRelatedViewController.m
//  BGProject
//
//  Created by liao on 15-1-16.
//  Copyright (c) 2015年 zhuozhong. All rights reserved.
//

#import "XNRelatedViewController.h"
#import "XNRelatedModel.h"
#import "XuanNengPaiHangBangCellFrame.h"
#import "XuanNengPaiHangBangCell.h"
#import "MJRefresh.h"
#import "MoudleMessageManager.h"
#import "SVProgressHUD.h"
#import "XNRelatedModel.h"

@interface XNRelatedViewController ()<UITableViewDataSource,UITableViewDelegate,MoudleMessageInterface>

@end

@implementation XNRelatedViewController{
    
    UITableView *_tableView;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    NSUInteger _relatedXNStartTag;
}

-(NSMutableArray *)dataArray{
    
    if (_dataArray==nil) {
        
        _dataArray = [[NSMutableArray alloc] init];
        
    }
    
    return _dataArray;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    //将控制器注册，方便回调
    [[MoudleMessageManager sharedManager]registerObserver:self];
    
    [super viewWillAppear:animated];
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    //将活动指示器去掉
    [SVProgressHUD popActivity];
    
    //去掉注册
    [[MoudleMessageManager sharedManager]unRegisterObserver:self];
    
    [super viewWillDisappear:animated];
    
    
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //一进来就有数据了，请求标记从那里开始
    _relatedXNStartTag = self.dataArray.count;
    
    //设置导航栏
    [self setupNavigationbar];
    
    //创建表格
    [self setupTableView];
    
    //刷新数据
    [self setupMoreData];
}

//刷新数据
-(void)setupMoreData{
    
    // 防止block循环retain，所以用__unsafe_unretained
    __unsafe_unretained XNRelatedViewController *vc = self;
    
    //集成下拉刷新控件
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _tableView;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        
        //删除全部数据
        [vc->_dataArray removeAllObjects];
        
        //修改请求标记为0
        vc->_relatedXNStartTag = 0;
        
        //发送获取与我相关消息（从新开始请求数据）
        [[MoudleMessageManager sharedManager] beRelatedToMeXuanNengWithStart:vc->_relatedXNStartTag end:kRequestCount];
        
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadDeals) withObject:nil afterDelay:3];
    };
    
    // 集成上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _tableView;
    
    // 进入上拉加载状态就会调用这个方法
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        NSString *relatedXNStartTagStr = [NSString stringWithFormat:@"%d",vc->_relatedXNStartTag];
        
        if ([relatedXNStartTagStr hasSuffix:@"0"]) {
            
            //发送获取与我相关消息（从新开始请求数据）
            [[MoudleMessageManager sharedManager] beRelatedToMeXuanNengWithStart:vc->_relatedXNStartTag end:vc->_relatedXNStartTag+kRequestCount];
            
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
    [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"已经没有更多的评论了"];
    
}

//刷新表格
- (void)reloadDeals
{
    [_tableView reloadData];
    // 结束刷新状态
    [_footer endRefreshing];
    [_header endRefreshing];
}

//设置表格
-(void)setupTableView{
    
    _tableView = [[UITableView alloc] init];
    CGFloat tableViewX = 0;
    CGFloat tableViewY = kTopViewHeight;
    CGFloat tableViewW = self.view.bounds.size.width;
    CGFloat tableViewH = self.view.bounds.size.height-kTopViewHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.frame = CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH);
    [self.view addSubview:_tableView];
    
}

//设置导航栏
-(void)setupNavigationbar
{
    //导航栏
    UIView* topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopViewHeight)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    UIButton* backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"与我相关";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    //顶部灰色横线
    UIView *barr1 =[[UIView alloc]initWithFrame:CGRectMake(0, topView.frame.origin.y+topView.frame.size.height, 320, 0.5)];
    barr1.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [self.view addSubview:barr1];
    
    [self.view addSubview:topView];
    
}

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XNRelatedModel* model = [[XNRelatedModel alloc] init];
    if (self.dataArray.count!=0) {
        
        model = self.dataArray[indexPath.row];
        
    }
    
    //计算出所有控件的frame
    XuanNengPaiHangBangCellFrame* cf =[[XuanNengPaiHangBangCellFrame alloc] initWithModel:model cellType:CellTypeRelated];
    
    return cf.cellHight;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"xuannengTableViewCell_related";
    
    XuanNengPaiHangBangCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
    
    if (!cell) {
        cell =[[XuanNengPaiHangBangCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //设置代理，方便以后回调
        //cell.delegate = self;
        cell.needHideDeleteButton = YES;
        
        if(indexPath.row == 0)
        {
            //把第一个cell的背景换掉，为何换掉？？？
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamedForResizeAble:@"cell_bg_3side_03.png"]];
            
            
        }
        
    }
    
    XNRelatedModel *model = [[XNRelatedModel alloc] init];
    
    if (self.dataArray.count!=0) {
        
        //算好子控件的坐标
        model = self.dataArray[indexPath.row];
        
    }
    
    
    //初始化frame
    XuanNengPaiHangBangCellFrame* cellframe =[[XuanNengPaiHangBangCellFrame alloc] initWithModel:model cellType:CellTypeRelated];
    
    //调整子控件的位置
    cell.cellFrame =cellframe;
    
    return cell;
}

//与我相关回调
-(void)beRelatedToMeXuanNengCB:(NSArray *)result{
    
    //将最新的数据放进数组里面
    for (XNRelatedModel *model in result) {
        
        [self.dataArray addObject:model];
        
    }
    
    //修改请求标记
    _relatedXNStartTag = _relatedXNStartTag+result.count;
    
    [_tableView reloadData];
    
}

@end
