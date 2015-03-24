//
//  XuanNengMainMenueViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "XuanNengMainMenueViewController.h"
#import "rewardViewController.h"
#import "AppDelegate.h"
#import "MoudleMessageManager.h"
#import "JokeModel.h"

#import "SVProgressHUD.h"
#import "XuanNengDetailViewController.h"

#import "XuanNengPaiHangBangCell.h"
#import "MJRefresh.h"
#import "UMSocial.h"
#import "BGWQCommentModel.h"
#import "BGPublishView.h"
#import "XNRelatedViewController.h"
#import "PersonlCardViewController.h"
#import "FDSUserManager.h"
#import "PersonViewController.h"
#import "XNRelatedModel.h"
#import "NSString+TL.h"
#import "humousViewController.h"
#import "AuditHumorousViewController.h"
#import "ZZUserDefaults.h"
#import "UMSocialData.h"

#define kCommentsKey @"comments"
#define TabBarHeight 49

@interface XuanNengMainMenueViewController ()<XuanNengPaiHangBangCellDelegate,UMSocialUIDelegate,BGPublishViewDelegate,UserCenterMessageInterface>

// 单元格中的toolbar中的某个按钮被单击的回调
-(void)XuanNengPaiHangBangCell:(XuanNengPaiHangBangCell *)cell
         didClickButtonAtIndex:(NSInteger)index;

// 转发微博的回调
-(void)relayToWeiBoAtXuanNengCB:(int)result;


@property(nonatomic, retain)UIView* syncView;// 阻塞用户操作。

@end

@implementation XuanNengMainMenueViewController
{
    UIView   *topView;
    UIButton *backBtn;
    UIButton *_arrowButton;
    __weak UIImageView *_tanChuView;
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    UIButton *button4;
    UIButton *btn1;
    
    UIView *btnBtoomView;
    
    UITableView *myTableView;
    NSArray *sortTypeArr;
    NSArray *arr1;
    NSArray *_listArr;
    UIView   *bannerView;
    UIView   *_bannerListView;
    UIButton *bannerBtn;
    
    UIView *moveView;
    UIView *_moveListView;
    
    MoudleMessageManager* messageManger;
    
    int rank_type;
    int type;
    
    NSMutableArray* jokesByDay;//日排行
    NSMutableArray* jokesByWeek;//周排行
    NSMutableArray* jokesByMonth;//月排行
    
    NSMutableArray *_jokesListByDay;//日榜单
    NSMutableArray *_jokesListByWeek;//周榜单
    NSMutableArray *_jokesListByMonth;//月榜单

    NSMutableArray *_sequenceArray;
    NSMutableArray *_randomArray;
    JokeListType _jokeListType;
    
    
    UIButton* selectedButton;// 记录 日 周 月 年 哪个被选中
    UIButton *_selectedListButton;// 记录 日 周 月 年 哪个被选中
    
    NSIndexPath* _selectedIndexpath;//工具条被选中的行
    NSIndexPath* _selectedDetailIndexpath;//点击详情的时候被点击的行
    
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    
    //排行榜请求开始标记
    NSInteger _dayRankTag;
    NSInteger _weekRankTag;
    NSInteger _monthRankTag;
    
    //榜单请求开始标记
    NSInteger _dayRankListTag;
    NSInteger _weekRankListTag;
    NSInteger _monthRankListTag;
    
    NSInteger _selectedRankTag;
    int _selectedRankListTag;
    
    NSInteger _sequenceTag;
    NSInteger _randomTag;
    
    //发送框
    BGPublishView *_publishView;
    //协助下拉键盘的背景图
    __weak UIView *_keyboardBackView;
    
    //标记是否已经没有数据刷新了
    BOOL *_isAllData;
    
    NSString *_otherUserid;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //初始化两个搜素类型的数组
        sortTypeArr  = [NSArray arrayWithObjects:@"最新",@"随机",@"榜单", nil];
        arr1 = [NSArray arrayWithObjects:@"日排行",@"周排行",@"月排行", nil];
        _listArr = [NSArray arrayWithObjects:@"日榜单",@"周榜单",@"月榜单", nil];
    }
    return self;
}

//
-(void)removeTanChuKuang{
    
    [_tanChuView removeFromSuperview];
    _tanChuView = nil;
    _arrowButton.selected = NO;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"炫能"];
    
    //将导航栏隐藏并
    self.navigationController.navigationBarHidden = YES;
    
    AppDelegate  *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //将tabbar隐藏起来
    [app hiddenTabelBar];
    
    //出现的时候将弹出框删除掉
    [self removeTanChuKuang];
    
    //消息回调注册代理
    [messageManger registerObserver:self];
    
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
    
    //request 70002
    if (self.isPresentModal) {
        
        //出现了说明模态视图已经下来了，要修改回来属性
        self.isPresentModal = NO;
        
    }else{
        
        //干嘛用的？？炫能itemID，0表示幽默秀
        int itemID = 1;
        
        //debug set ItemID = 0;
        itemID = 0;
        //_dayRankTag = 0;
        
        //排行榜类型，日？周？月？年？1,2,3,4
        rank_type = 1;
        type = 1;
        
        if (_dayRankTag==0) {
            
            //显示活动指示器
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            
            //发送获取笑话列表的消息
            [messageManger requestCharts:itemID
                                        :rank_type
                                        :(int)_dayRankTag
                                        :(int)_dayRankTag + kRequestCount];
            
        }
        
        
        if (_dayRankListTag==0) {
            
            //获取榜单
            [messageManger requestChartsList:itemID :type :(int)_dayRankListTag :(int)_dayRankListTag+kRequestCount];
            
        }
        
        if (_sequenceTag==0) {
            
            //每次刚进入这个视图的时候就是这个最新的类型
            _jokeListType=jokeListTypeSequence;
            
            //发送最新消息（6:随机;5:顺序;）
            [[MoudleMessageManager sharedManager] requestJokeListWithItemid:0 type:5 start:(int)_sequenceTag end:(int)_sequenceTag+kRequestCount];
            
        }
        
        
    }
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    //去除代理
    [messageManger unRegisterObserver:self];
    [[FDSUserCenterMessageManager sharedManager] unRegisterObserver:self];
    //去掉菊花
    [SVProgressHUD popActivity];
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"炫能"];
    
}

-(void)arrowButtonClick{
    
     _arrowButton.selected = !_arrowButton.selected;
    
    if (_arrowButton.selected) {
        
        [self CreatTanChuKuang];
        
    }else{
        
        [self removeTanChuKuang];
        
    }

}

-(void)CreatTanChuKuang
{
    //设置弹出框
    UIImageView *tanChuView = [[UIImageView alloc]initWithFrame:CGRectMake(200, topView.frame.origin.y+topView.frame.size.height-5, 229*0.5, 180*0.5)];
    //开启交互
    tanChuView.userInteractionEnabled = YES;
    tanChuView.image = [UIImage imageNamed:@"pop_bubble_humor"];
    tanChuView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:tanChuView];
    _tanChuView = tanChuView;

    
    //设置我的幽默秀按钮
    UIButton *btnChageBig2 = [[UIButton alloc]initWithFrame:CGRectMake(5, 7, 115, 40)];
    [btnChageBig2 addTarget:self action:@selector(myHumorousShow) forControlEvents:UIControlEventTouchUpInside];
    [btnChageBig2 setImage:[UIImage imageNamed:@"我的微墙_侧滑"] forState:UIControlStateNormal];
    [btnChageBig2 setTitle:@"我的幽默秀" forState:UIControlStateNormal];
    btnChageBig2.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 70);
    btnChageBig2.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 0);
    [btnChageBig2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnChageBig2.titleLabel.font = [UIFont systemFontOfSize:13];
    [tanChuView addSubview:btnChageBig2];
    
    
    //设置与我相关（炫能）按钮
    UIButton *btnChageBig3 = [[UIButton alloc]initWithFrame:CGRectMake(5, btnChageBig2.frame.origin.y+btnChageBig2.frame.size.height, 110, 40)];
    [btnChageBig3 addTarget:self action:@selector(relatedToMeXuanNeng) forControlEvents:UIControlEventTouchUpInside];
    [btnChageBig3 setImage:[UIImage imageNamed:@"related"] forState:UIControlStateNormal];
    [btnChageBig3 setTitle:@"与我相关" forState:UIControlStateNormal];
    btnChageBig3.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 70);
    btnChageBig3.titleEdgeInsets = UIEdgeInsetsMake(5, -2, 5, 0);
    [btnChageBig3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnChageBig3.titleLabel.font = [UIFont systemFontOfSize:13];
    [tanChuView addSubview:btnChageBig3];
    
}

//我的幽默秀按钮被点击
-(void)myHumorousShow{
    
    //判断是否已经登录
    if ([[FDSUserManager sharedManager] getNowUserState]!=USERSTATE_LOGIN) {
        PersonViewController *perVC = [[PersonViewController alloc] init];
        perVC.isAppearBackBtn = YES;
        self.isPresentModal = YES;
        [self.navigationController pushViewController:perVC animated:YES];
        return;
    }
    
    [MobClick event:@"xuanneng_joke_me_click"];
    
    //取出userid
    NSString *userid = [[FDSUserManager sharedManager] NowUserID];
    
    //没请求数据，直接飞过去啊？
    humousViewController   *xuan =[[humousViewController  alloc]init];
    
    xuan.userid = userid;
    
    xuan.humousType=HumousTypeMy;
    
    [self.navigationController pushViewController:xuan animated:YES];
    
}

//与我相关按钮
-(void)relatedToMeXuanNeng{
    
    [MobClick event:@"xuanneng_joke_mention_click"];
    
    //判断是否已经登录
    if ([[FDSUserManager sharedManager] getNowUserState]!=USERSTATE_LOGIN) {
        PersonViewController *perVC = [[PersonViewController alloc] init];
        perVC.isAppearBackBtn = YES;
        self.isPresentModal = YES;
        [self.navigationController pushViewController:perVC animated:YES];
        return;
    }
    
    //发送获取与我相关消息
    [[MoudleMessageManager sharedManager] beRelatedToMeXuanNengWithStart:0 end:10];
    
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
    
    //弹出框的箭头按钮
    _arrowButton = [[UIButton alloc]initWithFrame:CGRectMake(320-29-15, 33, 29, 16)];
    [_arrowButton setImage:[UIImage imageNamed:@"右上角"] forState:UIControlStateNormal];
    [_arrowButton setImage:[UIImage imageNamed:@"右上角"] forState:UIControlStateSelected];
    [_arrowButton addTarget:self action:@selector(arrowButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_arrowButton];
    
    //分类搜索背景视图
    btnBtoomView = [[UIView alloc]initWithFrame:CGRectMake(70+10, 23, 53*3+1, 34)];
    btnBtoomView.layer.borderWidth = 0.5;
    btnBtoomView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1 ].CGColor;
    
    //最新按钮
    button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0 , 53, 34)];
    button1.tag = 0;
    [button1 setTitle:sortTypeArr[0] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(sortJokes:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button1.titleLabel.font = [UIFont systemFontOfSize:14];
    [button1 setBackgroundImage:[UIImage imageNamed:@"background_08"] forState:UIControlStateSelected];
    [button1 setBackgroundImage:[UIImage imageNamed:@"tab底部"] forState:UIControlStateNormal];
    //默认选中
    button1.selected = YES;
    button1.titleEdgeInsets = UIEdgeInsetsMake(0,0,0,5);
    [btnBtoomView addSubview:button1];
    
    //中间分割线
    UIView *barrView = [[UIView alloc]initWithFrame:CGRectMake(53, 0, 0.5, 34)];
    barrView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [btnBtoomView addSubview:barrView];
    
    //随机按钮
    button2 = [[UIButton alloc]initWithFrame:CGRectMake(53.5, 0 , 53, 34)];
    button2.tag = 1;
    [button2 setTitle:sortTypeArr[1] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(sortJokes:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button2.titleLabel.font = [UIFont systemFontOfSize:14];
    [button2 setBackgroundImage:[UIImage imageNamed:@"background_08"] forState:UIControlStateSelected];
    [button2 setBackgroundImage:[UIImage imageNamed:@"tab底部"] forState:UIControlStateNormal];
    button2.titleEdgeInsets = UIEdgeInsetsMake(0,0,0,5);
    [btnBtoomView addSubview:button2];
    
    //华丽丽的分割线
    UIView *barrView1 = [[UIView alloc]initWithFrame:CGRectMake(106.5, 0, 0.5, 34)];
    barrView1.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [btnBtoomView addSubview:barrView1];
    
    //榜单按钮
    button3 = [[UIButton alloc]initWithFrame:CGRectMake(107, 0 , 53, 34)];
    button3.tag = 2;
    [button3 setTitle:sortTypeArr[2] forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(sortJokes:) forControlEvents:UIControlEventTouchUpInside];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button3.titleLabel.font = [UIFont systemFontOfSize:14];
    [button3 setBackgroundImage:[UIImage imageNamed:@"background_08"] forState:UIControlStateSelected];
    //为何用导航栏的背景图片？？
    [button3 setBackgroundImage:[UIImage imageNamed:@"tab底部"] forState:UIControlStateNormal];
    button3.titleEdgeInsets = UIEdgeInsetsMake(0,0,0,5);
    [btnBtoomView addSubview:button3];
    
    //华丽丽的分割线
    UIView *barrView2 = [[UIView alloc]initWithFrame:CGRectMake(160, 0, 0.5, 34)];
    barrView2.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [btnBtoomView addSubview:barrView2];
    
    //榜单按钮
//    button4 = [[UIButton alloc]initWithFrame:CGRectMake(160.5, 0 , 53, 34)];
//    button4.tag = 3;
//    [button4 setTitle:sortTypeArr[3] forState:UIControlStateNormal];
//    [button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button4 addTarget:self action:@selector(sortJokes:) forControlEvents:UIControlEventTouchUpInside];
//    [button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//    button4.titleLabel.font = [UIFont systemFontOfSize:14];
//    [button4 setBackgroundImage:[UIImage imageNamed:@"background_08"] forState:UIControlStateSelected];
//    //为何用导航栏的背景图片？？
//    [button4 setBackgroundImage:[UIImage imageNamed:@"tab底部"] forState:UIControlStateNormal];
//    button4.titleEdgeInsets = UIEdgeInsetsMake(0,0,0,5);
//    [btnBtoomView addSubview:button4];
    
    //添加视图
    [topView addSubview:btnBtoomView];
    [topView addSubview:backBtn];
    
    [self.view addSubview:topView];
    
    
 
}

//创建排行榜（日／周／月）
-(void)CreatBanner
{
    
    //排行榜的背景视图
    bannerView = [[UIView alloc]initWithFrame:CGRectMake(0, topView.frame.origin.y+topView.frame.size.height, 320, 50)];
    bannerView.layer.borderWidth =  0.5;
    bannerView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    CGFloat bannerBtnW = self.view.frame.size.width/3-0.5;
    
    //不同的排行榜按钮
    for (int  i = 0; i < 3; i++) {
        bannerBtn = [[UIButton  alloc]initWithFrame:CGRectMake(i*bannerBtnW+i*0.5, 0.5, bannerBtnW, 49)];
        bannerBtn.tag = 100+i;
        [bannerBtn setTitle:arr1[i] forState:UIControlStateNormal];
        [bannerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bannerBtn addTarget:self action:@selector(bannerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bannerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bannerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        
        //第一个按钮默认选中
        if (bannerBtn.tag ==100) {
            
            bannerBtn.selected = YES;
            
            //标记选中按钮
            selectedButton = bannerBtn;
        }
        [bannerView addSubview:bannerBtn];
        
    }
    
    //添加三条分割线
    for (int i = 0; i < 3; i++) {
        UIView *bannerSubView =[[UIView alloc]initWithFrame:CGRectMake((i+1)*bannerBtnW+i*0.5, 0, 0.5, 50)];
        bannerSubView.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        [bannerView addSubview:bannerSubView];
    }
    [self.view addSubview:bannerView];
    
    //添加下方的滑动视图
    moveView =[[UIView alloc]initWithFrame:CGRectMake(0, 48, bannerBtnW+0.5, 2)];
    moveView.backgroundColor = [UIColor blueColor];
    [bannerView addSubview:moveView];
    
    //添加myTableView
    CGFloat tableY = topView.frame.origin.y+topView.frame.size.height+2;
    CGFloat tableH = self.view.bounds.size.height - tableY;
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tableY, 320, tableH) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource =  self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = TableViewBgColor;
    [self.view addSubview:myTableView];
    
    [_sequenceArray addObjectsFromArray:[self getCache]];
    [myTableView reloadData];
  
}

//创建榜单下面的分类视图
-(void)creatListBanner{
    
    //排行榜的背景视图
    _bannerListView = [[UIView alloc]initWithFrame:CGRectMake(0, topView.frame.origin.y+topView.frame.size.height, 320, 50)];
    _bannerListView.layer.borderWidth =  0.5;
    _bannerListView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    CGFloat bannerBtnW = self.view.frame.size.width/3-0.5;
    
    //不同的排行榜按钮
    for (int  i = 0; i < 3; i++) {
        UIButton *bannerListBtn = [[UIButton  alloc]initWithFrame:CGRectMake(i*bannerBtnW+i*0.5, 0.5, bannerBtnW, 49)];
        bannerListBtn.tag = 200+i;
        [bannerListBtn setTitle:_listArr[i] forState:UIControlStateNormal];
        [bannerListBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bannerListBtn addTarget:self action:@selector(bannerListBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bannerListBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bannerListBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        
        //第一个按钮默认选中
        if (bannerListBtn.tag ==200) {
            
            bannerListBtn.selected = YES;
            
            //标记选中按钮
            _selectedListButton = bannerListBtn;
        }
        [_bannerListView addSubview:bannerListBtn];
        
    }
    
    //添加三条分割线
    for (int i = 0; i < 3; i++) {
        UIView *bannerSubView =[[UIView alloc]initWithFrame:CGRectMake((i+1)*bannerBtnW+i*0.5, 0, 0.5, 50)];
        bannerSubView.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        [_bannerListView addSubview:bannerSubView];
    }
    [self.view addSubview:_bannerListView];
    
    //添加下方的滑动视图
    _moveListView =[[UIView alloc]initWithFrame:CGRectMake(0, 48, bannerBtnW+0.5, 2)];
    _moveListView.backgroundColor = [UIColor blueColor];
    [_bannerListView addSubview:_moveListView];
    
    _bannerListView.hidden = YES;
    
}

#pragma mari BtnClick --------

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sortJokes:(UIButton *)sender
{
    
    //首先把弹出框删除
    [self removeTanChuKuang];
    
    //调整各个按钮的选中状态
    button1.selected = NO;
    button2.selected = NO;
    button3.selected = NO;
    //button4.selected = NO;
    sender.selected = YES;

    //bannerView是否隐藏／修改myTableView的高度
    
    if (sender.tag==0) {
        
        [MobClick event:@"xuanneng_joke_order_click"];
        
        //设置列表的类型
        _jokeListType = jokeListTypeSequence;
        
        //隐藏下面的排行榜
        bannerView.hidden = YES;
        _bannerListView.hidden = YES;
        //修改表格的位置
        CGFloat tableH = self.view.bounds.size.height -  (topView.frame.origin.y+topView.frame.size.height+2);
        myTableView.Frame = CGRectMake(0, topView.frame.origin.y+topView.frame.size.height+2, 320, tableH);
        NSLog(@"table:%lf",tableH);
        
        if (_sequenceTag==0) {
            
            //发送顺序消息（6:随机;5:顺序;）
            [[MoudleMessageManager sharedManager] requestJokeListWithItemid:0 type:5 start:(int)_sequenceTag end:(int)_sequenceTag+kRequestCount];
            
        }

        
    }else if (sender.tag==1){
        
        [MobClick event:@"xuanneng_joke_radom_click"];
        
        //设置列表的类型
        _jokeListType = jokeListTypeRandom;
        
        _bannerListView.hidden = YES;
        bannerView.hidden = YES;
        CGFloat tableH = self.view.bounds.size.height -  (topView.frame.origin.y+topView.frame.size.height+2);
        myTableView.Frame = CGRectMake(0, topView.frame.origin.y+topView.frame.size.height+2, 320, tableH);
        
        if (_randomTag==0) {
            
            //发送随机消息（0:随机;1:顺序,6,5）
            [[MoudleMessageManager sharedManager] requestJokeListWithItemid:0 type:6 start:(int)_randomTag end:(int)_randomTag+kRequestCount];
        }
        
        
    }else if (sender.tag==2){
        
        [MobClick event:@"xuanneng_joke_record_click"];
        
        //设置列表的类型
        _jokeListType = jokeListTypeRankList;
        
        //隐藏下面的排行榜
        bannerView.hidden = YES;
        _bannerListView.hidden = NO;
        CGFloat tableH = self.view.bounds.size.height -  (bannerView.frame.origin.y+bannerView.frame.size.height+2);
        myTableView.frame = CGRectMake(0, bannerView.frame.origin.y+bannerView.frame.size.height+2, 320, tableH);
        
    }else{
        
    }
    
    [myTableView reloadData];
    
}

//请求日／周／月榜单
-(void)bannerListBtnClick:(UIButton *)sender{
    
    //标记被点击的按钮
    _selectedListButton = sender;
    
    //遍历一遍，调整各个按钮的选中状态
    for (UIButton *btn in [_bannerListView subviews])
    {
        if (btn.tag == 200||btn.tag==201||btn.tag==202) {
            btn.selected = NO;
        }
        sender.selected = YES;
    }
    
    //调整滑条坐标
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _moveListView.frame;
        rect.origin.x = sender.frame.origin.x;
        _moveListView.frame = rect;
    }];
    
    //根据按钮的tag值来决定start
    int start = 0;
    switch (sender.tag) {
        case 200:
        {
            type = 1;
            start = (int)[_jokesListByDay count];
        }
            break;
        case 201:
        {
            type = 2;
            start = (int)[_jokesListByWeek count];
        }
            break;
        case 202:
        {
            type = 3;
            start = (int)[_jokesListByMonth count];
            
        }
            break;
            
        default:
            break;
    }
    
    
    if (start==0) {
        
        //爆菊花
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        
        //发送消息（不能每次点击都发送消息)
        [messageManger requestChartsList:0 :type :start :start+kRequestCount];
        
        
    }else{
        
        //如果不发送消息，总得刷新一下数据吧
        [myTableView reloadData];
        
    }
    
    
}

// 请求ri 周 月 年 的70002 2014年10月12日
-(void)bannerBtnClick:(UIButton *)sender
{
    //标记被点击的按钮
    selectedButton = sender;
    
    //遍历一遍，调整各个按钮的选中状态
    for (UIButton *btn in [bannerView subviews])
    {
        if (btn.tag == 100||btn.tag==101||btn.tag==102||btn.tag==103) {
            btn.selected = NO;
        }
        sender.selected = YES;
    }
    
    //调整滑条坐标
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = moveView.frame;
        rect.origin.x = sender.frame.origin.x;
        moveView.frame = rect;
    }];
    
    //根据按钮的tag值来决定start
    int start = 0;
    switch (sender.tag) {
        case 100:
        {
            rank_type = 1;
            start = (int)[jokesByDay count];
        }
            break;
        case 101:
        {
            rank_type = 2;
            start = (int)[jokesByWeek count];
        }
            break;
        case 102:
        {
            rank_type = 3;
            start = (int)[jokesByMonth count];
        
        }
            break;
            
        default:
            break;
    }
    
    //幽默秀是0
    int itemID = 0;
    
    //只有当开始请求标识为0才请求数据，0表示之前没有数据，只有第一次才发送消息，上下拉刷新来加载更多数据
    if (start==0) {
        
        //爆菊花
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        
        //发送消息（不能每次点击都发送消息)
        [messageManger requestCharts:itemID
                                    :rank_type
                                    :start
                                    :start+kRequestCount];
        
    }else{
        
        //如果不发送消息，总得刷新一下数据吧
        [myTableView reloadData];
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化messageManger
    messageManger = [MoudleMessageManager sharedManager];
    
    //初始化数组
    jokesByDay = [NSMutableArray array];
    jokesByWeek = [NSMutableArray array];
    jokesByMonth = [NSMutableArray array];
    
    _jokesListByDay = [NSMutableArray array];
    _jokesListByWeek = [NSMutableArray array];
    _jokesListByMonth = [NSMutableArray array];
    
    _sequenceArray = [NSMutableArray array];
    _randomArray = [NSMutableArray array];
    
    //添加导航栏的各种视图：返回／分类选项卡／有奖投稿
    [self CreatView];
    
    //添加排行榜的选项卡／tabbleview
    [self CreatBanner];
    
    //添加榜单选项卡
    [self creatListBanner];
    
    //刷新数据
    [self setupMoreData];
    
    //监听键盘弹出
    [self observeKeyboard];
    
    //设置审核悬浮按钮
    [self setupAuditSubmitButon];
    
}

#pragma mark-审核悬浮按钮

-(void)setupAuditSubmitButon{
    
    //审核和发表按钮背景视图
    UIImageView *auditSubmitBackView = [[UIImageView alloc] init];
    auditSubmitBackView.userInteractionEnabled = YES;
    auditSubmitBackView.image = [UIImage imageNamed:@"bg_audit_submit"];
    CGFloat auditSubmitW = 48;
    CGFloat auditSubmitX = self.view.frame.size.width-auditSubmitW;
    CGFloat auditSubmitY = self.view.frame.size.height-300;
    CGFloat auditSubmitH = 241*0.5;
    auditSubmitBackView.frame = CGRectMake(auditSubmitX, auditSubmitY, auditSubmitW, auditSubmitH);
    [self.view addSubview:auditSubmitBackView];
    
    //发表按钮
    CGFloat submitWH = 74*0.5;
    CGFloat submitX = (auditSubmitW-submitWH)*0.5;
    CGFloat submitY = (auditSubmitH*0.5-submitWH)*0.5;
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(submitX, submitY, submitWH, submitWH)];
    [submitButton setImage:[UIImage imageNamed:@"icon_submit"] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [auditSubmitBackView addSubview:submitButton];
    
    //审核按钮
    CGFloat auditWH = 74*0.5;
    CGFloat auditX = (auditSubmitW-auditWH)*0.5;
    CGFloat auditY = auditSubmitH*0.5 + (auditSubmitH*0.5-auditWH)*0.5;
    UIButton *auditButton = [[UIButton alloc] initWithFrame:CGRectMake(auditX, auditY, auditWH, auditWH)];
    [auditButton setImage:[UIImage imageNamed:@"icon_audit"] forState:UIControlStateNormal];
    [auditButton addTarget:self action:@selector(auditButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [auditSubmitBackView addSubview:auditButton];
    
}

//投稿按钮被点击
-(void)submitButtonClick{
    
    //判断是否已经登录
    if ([[FDSUserManager sharedManager] getNowUserState]!=USERSTATE_LOGIN) {
        PersonViewController *perVC = [[PersonViewController alloc] init];
        perVC.isAppearBackBtn = YES;
        self.isPresentModal = YES;
        [self.navigationController pushViewController:perVC animated:YES];
        return;
    }
    
    rewardViewController *reward =[[rewardViewController alloc]init];
    [self.navigationController pushViewController:reward animated:YES];
    
}

-(void)auditButtonClick{
    
    [MobClick event:@"xuanneng_joke_audit_click"];
    
    //拿出上次打开存起来的jokeid
    NSString *jokeid = [ZZUserDefaults getUserDefault:JokeidKey];
    
    if (jokeid) {
        
        //获取未审核内容
        [[MoudleMessageManager sharedManager] requestUnauditedContentWithItemid:0 type:0 start:0 end:5 maxxnid:[jokeid intValue]];
        
    }else{
        
        //获取未审核内容
        [[MoudleMessageManager sharedManager] requestUnauditedContentWithItemid:0 type:0 start:0 end:5 maxxnid:0];
        
    }
    
}

//获取未审核数据回调
-(void)requestUnauditedContentCB:(NSArray *)result{
    
    AuditHumorousViewController *auditVC = [[AuditHumorousViewController alloc] init];
    
    [auditVC.dataArray addObjectsFromArray:result];
    
    [self.navigationController pushViewController:auditVC animated:YES];
    
}

//监听键盘弹出
-(void)observeKeyboard{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//键盘通知回调函数
-(void)keyboardWillShow:(NSNotification *)noti{
    
    //重新出现的时候要将旧的_keyboardBackView移除掉，高度不对
    [_keyboardBackView removeFromSuperview];
    
    //取出键盘高度
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    //添加一个遮盖真个屏幕的view,事件就可以接受了，神马原因？
    [self setupkeyboardBackViewWithSize:size];
    
    //防止相互强引用
    __unsafe_unretained XuanNengMainMenueViewController *XNVc = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        //修改_publishView的y值
        CGRect publishF = XNVc->_publishView.frame;
        publishF.origin.y = self.view.frame.size.height-TabBarHeight-size.height;
        XNVc->_publishView.frame = publishF;
        
        //修改tableView的高度
        CGRect tableViewF = XNVc->myTableView.frame;
        tableViewF.size.height = self.view.frame.size.height-TabBarHeight-size.height-tableViewF.origin.y;
        XNVc->myTableView.frame = tableViewF;
        
    }];
    
}

-(void)keyboardWillHide:(NSNotification *)noti{
    
    //将从父视图遮罩移除
    [_keyboardBackView removeFromSuperview];
    
    //防止相互强引用
    __unsafe_unretained XuanNengMainMenueViewController *XNVc = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        //修改_publishView的y值
        CGRect publishF = XNVc->_publishView.frame;
        publishF.origin.y = self.view.frame.size.height-TabBarHeight;
        XNVc->_publishView.frame = publishF;
        
        //修改tableView的高度
        CGRect tableViewF = XNVc->myTableView.frame;
        tableViewF.size.height = self.view.frame.size.height-tableViewF.origin.y;
        XNVc->myTableView.frame = tableViewF;
    } completion:^(BOOL finished) {
        //键盘下来的时候将输入框删掉
        [XNVc->_publishView removeFromSuperview];
    }];
    
}
//把键盘放下去
-(void)resignKeyboardTap{
    [_publishView endEditing:YES];
}
//设置keyboardBackView
-(void)setupkeyboardBackViewWithSize:(CGSize)size{
    
    UIView *keyboardBackView = [[UIView alloc] init];
    CGRect bounds = self.view.bounds;
    bounds.size.height = bounds.size.height-TabBarHeight-size.height;
    keyboardBackView.frame = bounds;
    UITapGestureRecognizer *resignKeyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboardTap)];
    [keyboardBackView addGestureRecognizer:resignKeyboardTap];
    [self.view addSubview:keyboardBackView];
    _keyboardBackView = keyboardBackView;
}

-(void)setupMoreData{
    
    // 防止block循环retain，所以用__unsafe_unretained
    __unsafe_unretained XuanNengMainMenueViewController *vc = self;
    
    //集成下拉刷新控件
    _header = [MJRefreshHeaderView header];
    _header.scrollView = myTableView;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        
        if (vc->_jokeListType==jokeListTypeSequence) {
            
            vc->_sequenceTag = 0;
            
            [vc->messageManger requestJokeListWithItemid:0 type:5 start:(int)vc->_sequenceTag end:(int)vc->_sequenceTag+kRequestCount];
            
        }else if (vc->_jokeListType==jokeListTypeRandom){
            
            vc->_randomTag=0;
            
            [vc->messageManger requestJokeListWithItemid:0 type:6 start:(int)vc->_randomTag end:(int)vc->_randomTag+kRequestCount];
            
        }else if(vc->_jokeListType==jokeListTypeRankList){
        
            //上拉刷新，无论哪个数据都是重头开始
            vc->_selectedRankListTag = 0;
            
            //排行榜的所有请求标记都要变成0，否则那边数据不会清除
            vc->_dayRankListTag = 0;
            vc->_monthRankListTag = 0;
            vc->_weekRankListTag = 0;
            
            //发送获取笑话列表的消息
            [vc->messageManger requestChartsList:0 :vc->type :vc->_selectedRankListTag :vc->_selectedRankListTag + kRequestCount];
        
        }else{
            
            
            
        }
        
        
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadDeals) withObject:nil afterDelay:3];
    };
    
    // 集成上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = myTableView;
    
    // 进入上拉加载状态就会调用这个方法
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        //获取当前选中按钮的标题
        NSString *selectString = vc->selectedButton.titleLabel.text;
        
        NSString *selectListString = vc->_selectedListButton.titleLabel.text;
        
        if (vc->_jokeListType==jokeListTypeSequence) {
            
            NSString *_sequenceTagStr = [NSString stringWithFormat:@"%d",(int)vc->_sequenceTag];
            
            //如果不包含0，说明已经是最后了，不用请求
            if ([_sequenceTagStr hasSuffix:@"0"]) {
                
                [vc->messageManger requestJokeListWithItemid:0 type:5 start:(int)vc->_sequenceTag end:(int)vc->_sequenceTag+kRequestCount];
                
            }else{
                
                //提示没有更多数据
                [vc performSelector:@selector(showNoDataInfo) withObject:nil afterDelay:0];
                
            }
            
        }else if (vc->_jokeListType==jokeListTypeRandom){
            
            NSString *_randomTagStr = [NSString stringWithFormat:@"%d",(int)vc->_randomTag];
            
            //如果不包含0，说明已经是最后了，不用请求
            if ([_randomTagStr hasSuffix:@"0"]) {
                
                [vc->messageManger requestJokeListWithItemid:0 type:6 start:(int)vc->_randomTag end:(int)vc->_randomTag+kRequestCount];
                
            }else{
                
                //提示没有更多数据
                [vc performSelector:@selector(showNoDataInfo) withObject:nil afterDelay:0];
                
            }
            
        }else if(vc->_jokeListType==jokeListTypeRankList){
            
            //根据selectedButton的文字来选择请求开始标识
            if([selectListString hasPrefix:@"日"])
            {
                vc->_selectedRankListTag = (int)vc->_dayRankListTag;
                
            }else if ([selectListString hasPrefix:@"周"]){
                
                vc->_selectedRankListTag = (int)vc->_weekRankListTag;
                
            }else if ([selectListString hasPrefix:@"月"]){
                
                vc->_selectedRankListTag = (int)vc->_monthRankListTag;
                
            }
            
            NSString *_selectedRankListStr = [NSString stringWithFormat:@"%d",vc->_selectedRankListTag];
            
            //如果不包含0，说明已经是最后了，不用请求
            if ([_selectedRankListStr hasSuffix:@"0"]) {
                
                //发送获取笑话列表的消息
                [vc->messageManger requestChartsList:0 :vc->type :vc->_selectedRankListTag :vc->_selectedRankListTag + kRequestCount];
                
            }else{
                
                //提示没有更多数据
                [vc performSelector:@selector(showNoDataInfo) withObject:nil afterDelay:0];
                
            }
                
        }else{
            
            
            
        }
            
        
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadDeals) withObject:nil afterDelay:3];
    };
}

-(void)showNoDataInfo{
    
    [self reloadDeals];
    
    //提示框
    [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"已经没有更多的数据了"];
    
}

//刷新表格
- (void)reloadDeals
{
    [myTableView reloadData];
    // 结束刷新状态
    [_footer endRefreshing];
    [_header endRefreshing];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *temoArr = [self setupJokeListArray];

    return [temoArr count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellHeight = 20;
    
    
    //初始化数组
    NSArray* models = [self setupJokeListArray];
    
    JokeModel* joke = [models objectAtIndex:indexPath.row];
    if(joke !=nil) {
        XuanNengPaiHangBangCellFrame* cf =[[XuanNengPaiHangBangCellFrame alloc] init];
        cf.model = joke;
        cellHeight = cf.cellHight;
    }
    
    return cellHeight;
}

//deselected the cell
-(void)tableViewDeSelect:(UITableView*)table
{
    NSIndexPath* indexPath = [table indexPathForSelectedRow];
    [table deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"xuannengTableViewCell";
    
    XuanNengPaiHangBangCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
    
    if (!cell) {
        cell =[[XuanNengPaiHangBangCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //设置代理，方便以后回调
        cell.delegate = self;
        cell.needHideDeleteButton = YES;
        
        if(indexPath.row == 0)
        {
            //把第一个cell的背景换掉，为何换掉？？？
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamedForResizeAble:@"cell_bg_3side_03.png"]];
            
            
        }
        
    }
    
    //初始化数组
    NSArray* models = [self setupJokeListArray];
    
    //初始化frame
    XuanNengPaiHangBangCellFrame* cellframe =[XuanNengPaiHangBangCellFrame alloc];
    
    //算好子控件的坐标
    cellframe.model = models[indexPath.row];
    
    //调整子控件的位置
    cell.cellFrame =cellframe;
    
    return cell;
    
}

//设置排行／顺序／随机数组
-(NSArray *)setupJokeListArray{
    
    //初始化数组
    NSArray* jokeModels = nil;
    
    if (_jokeListType==jokeListTypeSequence) {
        
        jokeModels = _sequenceArray;
        
    }else if (_jokeListType==jokeListTypeRankList){
        
        jokeModels = [self setupRankListModelsArray];
        
    }else if(_jokeListType==jokeListTypeRandom){
        
        jokeModels = _randomArray;
        
    }else{
        
        
        
    }
    
    return jokeModels;
    
}

//设置排行里面的数组（日／周／月）
-(NSArray *)setupRankListModelsArray{
    
    NSArray *tempModels = nil;
    
    //取得选中按钮的标题
    NSString* selectString = _selectedListButton.titleLabel.text;
    
    //根据selectedButton拿到响应的数组
    if([selectString hasPrefix:@"日"])
    {
        tempModels = _jokesListByDay;
    }
    
    if([selectString hasPrefix:@"周"])
    {
        tempModels = _jokesListByWeek;
    }
    
    if([selectString hasPrefix:@"月"])
    {
        tempModels = _jokesListByMonth ;
    }
    
    return tempModels;
    
}

//设置排行里面的数组（日／周／月）
-(NSArray *)setupRankModelsArray{
    
    NSArray *tempModels = nil;
    
    //取得选中按钮的标题
    NSString* selectString = selectedButton.titleLabel.text;
    
    //根据selectedButton拿到响应的数组
    if([selectString hasPrefix:@"日"])
    {
        tempModels = jokesByDay;
    }
    
    if([selectString hasPrefix:@"周"])
    {
        tempModels = jokesByWeek;
    }
    
    if([selectString hasPrefix:@"月"])
    {
        tempModels = jokesByMonth ;
    }
    
    return tempModels;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [MobClick event:@"xuanneng_joke_detail_click"];
    
    //选中后效果立马消失，封装了一下
    [self tableViewDeSelect:tableView];
    
    //取出cell
    XuanNengPaiHangBangCell* cell =(XuanNengPaiHangBangCell*) [tableView cellForRowAtIndexPath:indexPath];
    
    //取出model
    JokeModel* model = cell.cellFrame.model;
    
    //记录选中的行数
    _selectedDetailIndexpath = indexPath;
    
    //70009 发送笑话详情消息
    [messageManger requestJoke:model.jokeid :0 :kRequestCount];
    

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

//顺序或者随机数据回调
-(void)requestJokeListCB:(NSArray *)result{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if (result) {
        
        if (_jokeListType==jokeListTypeSequence) {
            
            //如果_sequenceTag＝＝0，有可能是下拉刷新，要将数组清空，放进新元素
            if (_sequenceTag == 0) {
                
                [_sequenceArray removeAllObjects];
                
            }
            
            //添加新元素
            [_sequenceArray addObjectsFromArray:result];
            
            //修改请求标识
            _sequenceTag += result.count;
            
            //有数据才存进去，不然把之前村的数据干掉了
            //现在只存最新的
            if (result) {
                
                [self setupCacheWithModels:result];
                
            }
            
        }else{
            
            //如果_randomTag＝＝0，有可能是下拉刷新，要将数组清空，放进新元素
            if (_randomTag == 0) {
                
                [_randomArray removeAllObjects];
                
            }
            
            //添加新元素
            [_randomArray addObjectsFromArray:result];
            
            //修改请求标识
            _randomTag += result.count;
            
        }
        
        
        
    }
    
    //刷新数据
    [myTableView reloadData];
    
}

//榜单数据回调
-(void)requestChartsListCB:(NSArray *)result{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if (result) {
        
        //取出选中按钮上面的标题
        NSString* selectString = _selectedListButton.titleLabel.text;
        
        //hasPrefix：判断是否是以某个字符串开始
        if([selectString hasPrefix:@"日"])
        {
            
            //如果_dayRankTag＝＝0，有可能是下拉刷新，要将数组清空，放进新元素
            if (_dayRankListTag == 0) {
                
                [_jokesListByDay removeAllObjects];
                
            }
            
            //添加新元素
            [_jokesListByDay addObjectsFromArray:result];
            
            //修改请求标识
            _dayRankListTag += result.count;
            
            
        }else if ([selectString hasPrefix:@"周"]){
            
            if (_weekRankListTag == 0) {
                
                [_jokesListByWeek removeAllObjects];
                
            }
            
            //添加新元素
            [_jokesListByWeek addObjectsFromArray:result];
            
            //修改请求标识
            _weekRankListTag += result.count;
            
            
            
        }else if ([selectString hasPrefix:@"月"]){
            
            if (_monthRankListTag == 0) {
                
                [_jokesListByMonth removeAllObjects];
                
            }
            
            //添加新元素
            [_jokesListByMonth addObjectsFromArray:result];
            
            //修改请求标识
            _monthRankListTag += result.count;
            
            
        }
        
        
        //刷新数据
        [myTableView reloadData];
        
    }
    
}

//排行数据的回调
-(void)requestChartsCB:(NSArray*)result {
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if (result) {
        
        //取出选中按钮上面的标题
        NSString* selectString = selectedButton.titleLabel.text;
        
        //判断是否滑动到第一行的标识
        int tempRank = -10;
        
        //hasPrefix：判断是否是以某个字符串开始
        if([selectString hasPrefix:@"日"])
        {
            
            //如果_dayRankTag＝＝0，有可能是下拉刷新，要将数组清空，放进新元素
            if (_dayRankTag == 0) {
                
                [jokesByDay removeAllObjects];
                
            }
            
            //添加新元素
            [jokesByDay addObjectsFromArray:result];
            
            //修改请求标识
            _dayRankTag += result.count;
            tempRank = (int)_dayRankTag;
            
        }else if ([selectString hasPrefix:@"周"]){
            
            if (_weekRankTag == 0) {
                
                [jokesByWeek removeAllObjects];
                
            }
            
            //添加新元素
            [jokesByWeek addObjectsFromArray:result];
            
            //修改请求标识
            _weekRankTag += result.count;
            
            tempRank = (int)_weekRankTag;
            
        }else if ([selectString hasPrefix:@"月"]){
            
            if (_monthRankTag == 0) {
                
                [jokesByMonth removeAllObjects];
                
            }
            
            //添加新元素
            [jokesByMonth addObjectsFromArray:result];
            
            //修改请求标识
            _monthRankTag += result.count;
            
            tempRank = (int)_monthRankTag;
            
        }
        
        
        //刷新数据
        [myTableView reloadData];
        
        //在刷新之后再滚动，刷新之后一般都有cell了
        
        //如果等于请求的个数，说明它之前是为0的，是第一次请求或者下拉刷新
        if (tempRank==kRequestCount && _jokeListType==JokeTypeRankList) {
            
            //取得第一行
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            
            //将第一行滚动到第一行
            [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
        }
        
    }
    
    
    
}



//设置评论框
-(void)setupPublishView{
    
    BGPublishView *publishView = [[BGPublishView alloc] init];
    publishView.delegate = self;
    CGFloat publishViewX = 0;
    CGFloat publishViewY = self.view.frame.size.height-TabBarHeight;
    CGFloat publishViewW = self.view.frame.size.width;
    CGFloat publishViewH = TabBarHeight;
    publishView.frame = CGRectMake(publishViewX,publishViewY ,publishViewW , publishViewH);
    [self.view addSubview:publishView];
    _publishView = publishView;
    
}


#pragma mark-单元格提供赞 评论 分享 等支持
-(void)XuanNengPaiHangBangCell:(XuanNengPaiHangBangCell *)cell
         didClickButtonAtIndex:(NSInteger)index
{
    //判断是否已经登录
    if ([[FDSUserManager sharedManager] getNowUserState]!=USERSTATE_LOGIN) {
        PersonViewController *perVC = [[PersonViewController alloc] init];
        perVC.isAppearBackBtn = YES;
        self.isPresentModal = YES;
        [self.navigationController pushViewController:perVC animated:YES];
        return;
    }
    
    if (index == 0) {
       
        //加了一个view覆盖再tableview上面
        _syncView = [[UIView alloc]initWithFrame:myTableView.frame];
        [self.view addSubview:_syncView];//权宜之计。阻止用户乱点。
        //爆菊花
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    }
    
    
    //记录下cell的indexPath
    _selectedIndexpath = [myTableView indexPathForCell:cell];
    
    switch (index) {
        case 0:
            //赞 70007
        {
            
            [MobClick event:@"xuanneng_joke_zan_click"];
            
            //拿出模型
            JokeModel* model = cell.cellFrame.model;
            
            //拿出jokeid
            int itemId = [model.jokeid integerValue];
            
            //发送消息
            [[MoudleMessageManager sharedManager]submitSupportAtXuanNeng:itemId];
        }

            break;
        case 1:
        {
            
            [MobClick event:@"xuanneng_joke_reply_click"];
            
            //创建_publishView
            [self setupPublishView];
            
            //通过这个commentField成为第一响应者将键盘弹出
            [_publishView.commentField becomeFirstResponder];
            
            //拿出模型
            JokeModel* model = cell.cellFrame.model;
            
            //取得被评论的weiboid
            _publishView.jokeid = [model.jokeid intValue];
            
            //设置评论类型
            _publishView.commentType=commentTypeComment;
            
            //设置占位文字
            _publishView.commentField.placeholder = PlaceholderComment;
            
            //选中哪一行，哪一行滚到最后
            [myTableView scrollToRowAtIndexPath:_selectedIndexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
        }
            break;
        case 2:
            //分享
        {
            
            //取出cell，取出model，取出like_count＋1.再刷新页面
            XuanNengPaiHangBangCell* cell =(XuanNengPaiHangBangCell*) [myTableView cellForRowAtIndexPath:_selectedIndexpath];
            JokeModel* model = cell.cellFrame.model;
            
            //如果有图片就分享第一张
            if (model.imgs.count!=0) {
                
                NSDictionary *urlDic = model.imgs[0];
                
                NSString *img = urlDic[@"img"];
                
                //处于分享状态，不能删除代理
                [self shareWeiQiang:model.content imageUrl:[NSString setupSileServerAddressWithUrl:img] xnid:[model.jokeid intValue]];
                
                
            }else{
                
                
                //处于分享状态，不能删除代理
                [self shareWeiQiang:model.content imageUrl:nil xnid:model.xnid];
            }
        }
        default:
            break;
    }
}

//点击发送按钮的回调
-(void)didSelectedPublishButton:(NSString *)text{
    
    //去掉菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    //发送评论
    if (_publishView.commentType==commentTypeComment) {
        
        //发送评论消息
        [[MoudleMessageManager sharedManager] submitCommentAtXuanNeng:_publishView.jokeid :text];
        
    }else{
        //发送转发消息
        [[MoudleMessageManager sharedManager] relayToWeiBoAtXuanNeng:_publishView.jokeid comments:text];
        
    }
    
    //放键盘下来
    [_publishView endEditing:YES];
    
}

-(void)setupShareUrlWithStr:(NSString *)shareUrl{
    
    //微信好友
    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
    //微信朋友圈
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
    //qq空间
    [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl;
    //qq好友
    [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
    
    
}

//弹出分享框
-(void)shareWeiQiang:(NSString *)content imageUrl:(NSString *)url xnid:(int)xnid{
    
    //构建分享地址
    NSString *shareUrl = [NSString stringWithFormat:@"http://www.showneng.com/xnshare.aspx?objid=%d&tag=xn",xnid];
    
    //设置分享地址
    [self setupShareUrlWithStr:shareUrl];
    
    UIImage *shareImage = nil;
    
    if (url==nil) {
        
        shareImage = [UIImage imageNamed:@"logo.png"];
        
    }else{
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        
        //这里暂时同步下载，影响用户体验
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        shareImage = [UIImage imageWithData:imageData];
        
    }
    
    [SVProgressHUD popActivity];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"54f6d2a1fd98c5d705000132"
                                      shareText:content
                                     shareImage:shareImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToTencent,UMShareToRenren,UMShareToQQ,UMShareToQzone,nil]
                                       delegate:self];
}
//分享回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        NSLog(@"responseCode == UMSResponseCodeSuccess");
        
        //取出cell，取出model，取出like_count＋1.再刷新页面
        XuanNengPaiHangBangCell* cell =(XuanNengPaiHangBangCell*) [myTableView cellForRowAtIndexPath:_selectedIndexpath];
        JokeModel* model = cell.cellFrame.model;
        
        //取出jokeid
        int jokeid = [model.jokeid intValue];
        
        //发送分享笑话消息
        [messageManger shareJokeAtXuanNeng:jokeid];
        
    }
}

//分享回调
-(void)shareJokeAtXuanNengCB:(int)result{
    //数据回来后，将_syncView删掉
    [_syncView removeFromSuperview];
    
    //取出cell,取出model,改变forward_count
    XuanNengPaiHangBangCell* cell =(XuanNengPaiHangBangCell*) [myTableView cellForRowAtIndexPath:_selectedIndexpath];
    
    JokeModel* model = cell.cellFrame.model;
    int tmpInt = [model.share_count intValue];
    tmpInt += 1;
    
    if (tmpInt>=10000) {
        //大于一万的全都表示x万
        tmpInt = tmpInt/10000;
        model.share_count = [NSString stringWithFormat:@"%d万", tmpInt];
    }else{
        model.share_count = [NSString stringWithFormat:@"%d", tmpInt];
        
    }
    
    //刷新页面
    [myTableView reloadData];
}

//点赞回调
-(void)submitSupportAtXuanNengCB:(int)result
{

    //数据回来后，将_syncView删掉
    [_syncView removeFromSuperview];
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if (result==205) {
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"你已点赞"];
        return;
        
    }
    
    //取出cell，取出model，取出like_count＋1.再刷新页面
    XuanNengPaiHangBangCell* cell =(XuanNengPaiHangBangCell*) [myTableView cellForRowAtIndexPath:_selectedIndexpath];
    JokeModel* model = cell.cellFrame.model;
    int tmpInt = [model.like_count intValue];
    tmpInt += 1;
    model.like_count = [NSString stringWithFormat:@"%d", tmpInt];
    
    //刷新页面
    [myTableView reloadData];
    
}

//转发微博回调
-(void)relayToWeiBoAtXuanNengCB:(int)result
{
    if (result == 0) {
        //去掉菊花，删除_syncView
        [SVProgressHUD popActivity];
        [_syncView removeFromSuperview];
        
        // 更新页面显示。
        // 简单粗暴的刷新页面搞定
        
        //取出cell,取出model,改变forward_count
        XuanNengPaiHangBangCell* cell =(XuanNengPaiHangBangCell*) [myTableView cellForRowAtIndexPath:_selectedIndexpath];
        
        JokeModel* model = cell.cellFrame.model;
        int tmpInt = [model.forward_count intValue];
        tmpInt += 1;
        model.forward_count = [NSString stringWithFormat:@"%d", tmpInt];
        
        //刷洗页面
        [myTableView reloadData];
    }
    
}

//评论回调
-(void)submitCommentAtXuanNengCB:(int)result{
    if (result == 0) {
        //去掉菊花，删除_syncView
        [SVProgressHUD popActivity];
        
        //移除阻塞视图
        [_syncView removeFromSuperview];
        
        //取出cell,取出model,改变forward_count
        XuanNengPaiHangBangCell* cell =(XuanNengPaiHangBangCell*) [myTableView cellForRowAtIndexPath:_selectedIndexpath];
        
        JokeModel* model = cell.cellFrame.model;
        int tmpInt = [model.comment_count intValue];
        tmpInt += 1;
        model.comment_count = [NSString stringWithFormat:@"%d", tmpInt];
        
        
        //刷洗页面
        [myTableView reloadData];
    }
    
    
}

//与我相关回调
-(void)beRelatedToMeXuanNengCB:(NSArray *)result{
    
    XNRelatedViewController *xnrv = [[XNRelatedViewController alloc] init];
    
    for (XNRelatedModel *model in result) {
        
        [xnrv.dataArray addObject:model];
        
    }
    
    [self.navigationController pushViewController:xnrv animated:YES];
    
}

-(void)xuanNengPersontap:(NSString *)userid{
    
    //记录下userid
    _otherUserid = userid;
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //获取个人资料
    [[FDSUserCenterMessageManager sharedManager] userRequestUserInfo:userid];
    
    //不是用户本身的
    [FDSUserCenterMessageManager sharedManager].userInfoType=UserInfoTypeOtherUserInfo;
    
}

//个人信息回调
-(void)getUserInfoCB:(NSDictionary *)dic{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if ([FDSUserCenterMessageManager sharedManager].userInfoType==UserInfoTypeOtherUserInfo) {
        
        PersonlCardViewController *pv = [[PersonlCardViewController alloc] init];
        pv.userDic = dic;
        pv.userid = _otherUserid;
        [self.navigationController pushViewController:pv animated:YES];
        
    }

    
}

#pragma mark－缓存设置

//设置全部缓存
-(void)setupCacheWithModels:(NSArray *)models{
    
    NSString *cachePath = [NSString pathwithFileName:XuanNengCacheKey];
    
    //再讲空数组存进去
    [NSKeyedArchiver archiveRootObject:models toFile:cachePath];
    
}

//获取缓存
-(NSArray *)getCache{
    
    NSString *cachePath = [NSString pathwithFileName:XuanNengCacheKey];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
    
}

@end
