//
//  WeiQiangViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "WeiQiangViewController.h"
#import "TrendViewController.h"
#import "KxMenu.h"
#import "weiQiangModel.h"
#import "weiQiangMainMenueCell.h"
#import "detailViewController.h"
#import "PersonViewController.h"
#import "AppDelegate.h"
#import "FDSUserCenterMessageManager.h"
#import "FDSUserManager.h"
#import "MoudleMessageInterface.h"
#import "MoudleMessageManager.h"
#import "SVProgressHUD.h"
#import "myWeiQiangController.h"
#import "weiQiangModel.h"
#import "WeiQiangCell.h"
#import "UMSocial.h"
#import "MJRefresh.h"
#import "BGWQCommentModel.h"
#import "BGPublishView.h"
#import "UIAlertView+Zhangxx.h"
#import "PersonlCardViewController.h"
#import "WeiQiangRelatedModel.h"
#import "RelatedViewController.h"
#import "constants.h"
#import "NSString+TL.h"
#import "ZZUserDefaults.h"

#define kspaceH 5 // 水平留白
#define TabBarHeight 49
#define NavigationBarHeight 64

//图片数组
#define kImgsKey @"imgs"

//评论数组
#define kCommentsKey @"comments"
#define kTableBackColor [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1]

//MoudleMessageInterface:微墙和炫能模块的数据回调
@interface WeiQiangViewController ()<MoudleMessageInterface,UIGestureRecognizerDelegate,WeiQiangCellDelegate,UMSocialUIDelegate,BGPublishViewDelegate,UserCenterMessageInterface>

@property(nonatomic, retain)UIView* syncView;// 阻塞用户操作。
// 请求我关注或所有的围墙数据
-(void)weiQiangListCB:(NSArray *)result;


@end

/*
 由于之前的不规范，现在导致 btn1绑定了"关注",_tableViewForAttention,_moudelArrForAttention
 */
@implementation WeiQiangViewController
{
    
    NSTimer *_timer;
    
    BOOL isduoxianchen;
    
    UIView *topView;
    
    UIButton *btn1;
    UIButton *btn2;
    
    UIView *MoveView;

    BOOL _isClik; // 控制显示右上角的popview
    BOOL _isShowPopView;
    
    UIImageView *tanChuView;
    UIButton *btnChageBig1;
    UIButton *btnChageBig2;
    
    //数据源
    NSMutableArray *_dataArr;

    NSString* _userid;
    
    UITableView* _tableViewForAttention;    // 显示关注的tableview
    UITableView* _tableViewForAll;          // 显示所有微博的tableview
    UITableView* _tableInSelected;          // 当前显示的tableView。一般是_tableViewForAttention or_tableInSelected
    
    NSMutableArray* _modelArrForAttention;
    NSMutableArray* _modelArrForAll;
    NSMutableArray* _modelArrForMine;   // 我的围墙数据
    
    NSInteger _attentionStartTag;   // 请求关注数据的开始位置
    NSInteger _allStartTag;         // 请求所有数据的开始位置
    
    NSInteger _commentStartTag;//请求微墙详情评论的开始位置
    
    NSInteger _requestType;         //<type/>//0，我的；1：关注；2：非关注
    NSIndexPath* _selectedIndexpath;
    NSIndexPath* _selectedDetailIndexpath;
    
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_attentionFooter;
    MJRefreshHeaderView *_atttentionHeader;
    
    //发送框
    __weak BGPublishView *_publishView;
    
    //协助下拉键盘的背景图
    __weak UIView *_keyboardBackView;
    
    NSString *_otherUserid;//头像点击
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [MobClick beginLogPageView:@"微墙"];
    
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    
    //取出AppDelegate对象
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    //将tableview显示出来
    [app showTableBar];
    
    //注册代理
    [[MoudleMessageManager sharedManager] registerObserver:self];
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
    
    //如果没有数据，则请求数据。否则不请求数据  .btn1 对应 全部成员的围墙数据，关注要登录
    //意思是关注被选中并且关注数组为空的时候，请求数据
    if(btn2.selected && _attentionStartTag==0)
    {
        // 请求关注的围墙数据 2014年10月13日
        //1：关注；2：非关注，我的或者用户的要传userid
        _requestType = 1;
        
        //显示活动指示器
        [SVProgressHUD showWithMaskType:1];
        
        //列表类型／开始标签／结束标签
        [[MoudleMessageManager sharedManager] WeiQiangList:_requestType start:(int)_attentionStartTag end:(int)_attentionStartTag+kRequestCount userid:0];
        
        
    }else if (btn1.selected && _allStartTag==0 )
    {
        // 请求所有微墙数据 2014年10月13日
        _requestType = 2;
        [SVProgressHUD showWithMaskType:1];
        [[MoudleMessageManager sharedManager] WeiQiangList:(int)_requestType start:(int)_allStartTag end:(int)_allStartTag+kRequestCount userid:0];
    }
    
    //看弹出框的状态是否需要调整
    [self setupBackButtonWithStaus:self.backBtn.selected];
    
}
-(void)viewWillDisappear:(BOOL)animated  {

    //去掉注册代理
    [[MoudleMessageManager sharedManager]unRegisterObserver:self];
    
    [[FDSUserCenterMessageManager sharedManager] unRegisterObserver:self];
    
    //关掉活动指示器
    [SVProgressHUD popActivity];
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"微墙"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化成员变量
    _modelArrForAll = [NSMutableArray array];
    _modelArrForAttention = [NSMutableArray array];
    
    _allStartTag = 0;
    _attentionStartTag = 0;
    _commentStartTag = 0;
    
    //_userid什么时候存起来的？？
    _userid = [[FDSUserManager  sharedManager]NowUserID];
    
    // 不显示popview
    _isShowPopView = NO;
    
    //添加导航栏／弹出框箭头／导航栏标签／各种分割线／关注按钮／全部按钮／滑动条／关注列表／全部列表
    [self CreatView];
    
    //上拉加载更多
    [self setupMoreData];
    
    //监听键盘
    [self observeKeyboard];
    
    
}

-(void)loadtableview{
    
    isduoxianchen = YES;
    
    //发送消息
    _requestType = 2;
    
    _allStartTag = 0;
    
    
    [[MoudleMessageManager sharedManager] WeiQiangList:2 start:0 end:kRequestCount userid:0];
    
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
    bounds.size.height = bounds.size.height-TabBarHeight-size.height;
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
    
    //取出键盘高度
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    //添加一个遮盖真个屏幕的view,事件就可以接受了，神马原因？
    [self setupkeyboardBackViewWithSize:size];
    
    //防止相互强引用
    __unsafe_unretained WeiQiangViewController *WQVc = self;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        //修改_publishView的y值
        CGRect publishF = WQVc->_publishView.frame;
        publishF.origin.y = self.view.frame.size.height-TabBarHeight-size.height;
        WQVc->_publishView.frame = publishF;
        
        //修改tableView的高度
        CGRect tableViewF = WQVc->_tableViewForAll.frame;
        tableViewF.size.height = self.view.frame.size.height-TabBarHeight-size.height-tableViewF.origin.y;
        WQVc->_tableViewForAll.frame = tableViewF;
        
    }];
}

-(void)keyboardWillHide:(NSNotification *)noti{
    
    //将从父视图遮罩移除
    [_keyboardBackView removeFromSuperview];
    
    
   __unsafe_unretained WeiQiangViewController *WQVc = self;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        //修改_publishView的y值
        CGRect publishF = WQVc->_publishView.frame;
        publishF.origin.y = self.view.frame.size.height-TabBarHeight;
        WQVc->_publishView.frame = publishF;
        
        //修改tableView的高度
        CGRect tableViewF = WQVc->_tableViewForAll.frame;
        tableViewF.size.height = self.view.frame.size.height-TabBarHeight-tableViewF.origin.y;
        WQVc->_tableViewForAll.frame = tableViewF;
    } completion:^(BOOL finished) {
        //键盘下来的时候将输入框删掉
        [WQVc->_publishView removeFromSuperview];
    }];
}

//把键盘放下去
-(void)resignKeyboardTap{
    [_publishView endEditing:YES];
}

//刷新数据
-(void)setupMoreData{
    
    // 防止block循环retain，所以用__unsafe_unretained
    __unsafe_unretained WeiQiangViewController *vc = self;
    
    //集成下拉刷新控件
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _tableViewForAll;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        
        //发送消息
        vc->_requestType = 2;
        
        vc->_allStartTag = 0;

        [[MoudleMessageManager sharedManager] WeiQiangList:vc->_requestType start:vc->_allStartTag end:vc->_allStartTag+kRequestCount userid:0];
        
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadDeals) withObject:nil afterDelay:3];
    };
    
    //关注列表继承下拉刷新控件
    _atttentionHeader = [MJRefreshHeaderView header];
    _atttentionHeader.scrollView = _tableViewForAttention;
    _atttentionHeader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        
        //发送消息
        vc->_requestType = 1;
        
        //请求开始标识
        vc->_attentionStartTag = 0;
        
        //获取用户userid
        int userid = [[[FDSUserManager sharedManager] NowUserID] intValue];
        
        [[MoudleMessageManager sharedManager] WeiQiangList:vc->_requestType start:vc->_attentionStartTag end:vc->_attentionStartTag+kRequestCount userid:userid];
        
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadDeals) withObject:nil afterDelay:3];
    };
    
    // 集成上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _tableViewForAll;
    
    // 进入上拉加载状态就会调用这个方法
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        vc->_requestType = 2;
        
        
        NSString *_allStartTagStr = [NSString stringWithFormat:@"%d",vc->_allStartTag];
        
        //如果不包含0，说明已经是最后了，不用请求
        if ([_allStartTagStr hasSuffix:@"0"]) {
            
            [[MoudleMessageManager sharedManager] WeiQiangList:vc->_requestType start:vc->_allStartTag end:vc->_allStartTag+kRequestCount userid:0];
            
        }else{
            
            //提示没有更多数据
            [vc performSelector:@selector(showNoDataInfo) withObject:nil afterDelay:0];
            
        }
        
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadDeals) withObject:nil afterDelay:3];
    };
    
    //关注列表继承下拉刷新控件
    // 集成上拉加载更多控件
    _attentionFooter = [MJRefreshFooterView footer];
    _attentionFooter.scrollView = _tableViewForAttention;
    // 进入上拉加载状态就会调用这个方法
    _attentionFooter.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        //发送消息
        vc->_requestType = 1;
        
        //获取用户userid
        int userid = [[[FDSUserManager sharedManager] NowUserID] intValue];
        
        
        NSString *_attentionStartTagStr = [NSString stringWithFormat:@"%d",vc->_attentionStartTag];
        
        //如果不包含0，说明已经是最后了，不用请求
        if ([_attentionStartTagStr hasSuffix:@"0"]) {
            
            [[MoudleMessageManager sharedManager] WeiQiangList:vc->_requestType start:vc->_attentionStartTag end:vc->_attentionStartTag+kRequestCount userid:userid];
            
        }else{
            
            //提示没有更多数据
            [vc performSelector:@selector(showNoDataInfo) withObject:nil afterDelay:0];
            
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
    [_tableViewForAll reloadData];
    // 结束刷新状态
    [_footer endRefreshing];
    [_attentionFooter endRefreshing];
    [_atttentionHeader endRefreshing];
    [_header endRefreshing];
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

-(void)CreatView
{
    //自定义导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    //弹出框的箭头按钮
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(320-29-15, 35, 29, 16)];
    [self.backBtn setImage:[UIImage imageNamed:@"右上角"] forState:UIControlStateNormal];
    [self.backBtn setImage:[UIImage imageNamed:@"右上角"] forState:UIControlStateSelected];
    [self.backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    //中间标签
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(140, 24, 40, 40)];
    label1.text = @"微墙";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    
    [topView addSubview:self.backBtn];
    [topView addSubview:label1];
    [self.view addSubview:topView];
    
    //顶部灰色横线
    UIView *barr1 =[[UIView alloc]initWithFrame:CGRectMake(0, topView.frame.origin.y+topView.frame.size.height, 320, 0.5)];
    barr1.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [self.view addSubview:barr1];
    
    //关注按钮设置
    btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, topView.frame.origin.y+topView.frame.size.height+0.5, 160, 40);
    [btn1 setTitle:@"全部" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(requestWeiQiang:) forControlEvents:UIControlEventTouchUpInside];
    btn1.backgroundColor =[UIColor whiteColor];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    
    //中间灰色分割线
    UIView *barr2 =[[UIView alloc]initWithFrame:CGRectMake(btn1.frame.origin.x+btn1.frame.size.width,btn1.frame.origin.y,0.5, 40)];
    barr2.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [self.view addSubview:barr2];
    
    //全部按钮
    btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(btn1.frame.origin.x+btn1.frame.size.width+0.5,btn1.frame.origin.y, 160, 40);
    [btn2 setTitle:@"关注" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(requestWeiQiang:) forControlEvents:UIControlEventTouchUpInside];
    btn2.backgroundColor =[UIColor whiteColor];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    
    //底部灰色横线
    UIView *BootView = [[UIView alloc]initWithFrame:CGRectMake(0, btn1.frame.origin.y+btn1.frame.size.height, 320, 0.5)];
    [BootView setBackgroundColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1]];
    [self.view addSubview:BootView];
    
    //滑动条
    MoveView = [[UIView alloc]initWithFrame:CGRectMake(0,-1.5, 160, 2)];
    [MoveView setBackgroundColor:[UIColor blueColor]];
    [BootView addSubview:MoveView];
    
    //关注是默认选中的，导致回来的时候请求了关注的数据，但是滑条没弄回来
    btn1.selected = YES;
    
    CGFloat tableX = 0;
    CGFloat tableY =(BootView.frame.origin.y+BootView.frame.size.height);
    //33是个什么东西？？
    CGFloat tableH =  kMSTableViewHeight-(BootView.frame.origin.y+BootView.frame.size.height)+20-50;
    CGFloat tableW = kMSScreenWith;
    
    //关注列表设置
    _tableViewForAttention = [[UITableView alloc]initWithFrame:CGRectMake(tableX,tableY,tableW,tableH)];
    _tableViewForAttention.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewForAttention.delegate = self;
    _tableViewForAttention.dataSource = self;
    [self.view setUserInteractionEnabled:YES];//开启交互
    _tableViewForAttention.backgroundColor = kTableBackColor;
    
    //debug
    
    //设置全部列表
    _tableViewForAll = [[UITableView alloc]initWithFrame:CGRectMake(tableX,tableY,tableW,tableH)];
    _tableViewForAll.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewForAll.delegate = self;
    _tableViewForAll.dataSource = self;
    [self.view addSubview:_tableViewForAll];
    _tableInSelected = _tableViewForAll;// 当前显示的tableView
    _tableViewForAll.backgroundColor = kTableBackColor;
    
    //取出缓存
    NSArray *cacheArray = [self getCache];
    
    [_modelArrForAll addObjectsFromArray:cacheArray];
    
    [_tableInSelected reloadData];
    
}


-(void)CreatTanChuKuang
{
    //设置弹出框
    tanChuView = [[UIImageView alloc]initWithFrame:CGRectMake(195, topView.frame.origin.y+topView.frame.size.height-5, 120, 120)];
    //开启交互
    tanChuView.userInteractionEnabled = YES;
    tanChuView.image = [UIImage imageNamed:@"pop_bubble"];
    tanChuView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:tanChuView];
    
    //设置发表动态按钮
    btnChageBig1 = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 110, 40)];
    [btnChageBig1 addTarget:self action:@selector(publishTrends:) forControlEvents:UIControlEventTouchUpInside];
    [btnChageBig1 setTitle:@"发表动态" forState:UIControlStateNormal];
    [btnChageBig1 setImage:[UIImage imageNamed:@"发表微墙"] forState:UIControlStateNormal];
    btnChageBig1.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 60);
    btnChageBig1.titleEdgeInsets = UIEdgeInsetsMake(6, 10, 5, 0);
    [btnChageBig1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnChageBig1.titleLabel.font = [UIFont systemFontOfSize:13];
    [tanChuView addSubview:btnChageBig1];
    
    //设置我的微墙按钮
    btnChageBig2 = [[UIButton alloc]initWithFrame:CGRectMake(5, btnChageBig1.frame.origin.y+btnChageBig1.frame.size.height, 110, 40)];
    [btnChageBig2 addTarget:self action:@selector(MyweiQiang:) forControlEvents:UIControlEventTouchUpInside];
    [btnChageBig2 setImage:[UIImage imageNamed:@"我的微墙_侧滑"] forState:UIControlStateNormal];
    [btnChageBig2 setTitle:@"我的微墙" forState:UIControlStateNormal];
    btnChageBig2.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 60);
    btnChageBig2.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 0);
    [btnChageBig2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnChageBig2.titleLabel.font = [UIFont systemFontOfSize:13];
    [tanChuView addSubview:btnChageBig2];
    
    //与我相关按钮
    UIButton *relatedButton = [[UIButton alloc]initWithFrame:CGRectMake(5, btnChageBig2.frame.origin.y+btnChageBig2.frame.size.height, 110, 40)];
    [relatedButton addTarget:self action:@selector(relatedToMe) forControlEvents:UIControlEventTouchUpInside];
    [relatedButton setImage:[UIImage imageNamed:@"related"] forState:UIControlStateNormal];
    [relatedButton setTitle:@"与我相关" forState:UIControlStateNormal];
    relatedButton.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 60);
    relatedButton.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 0);
    [relatedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    relatedButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [tanChuView addSubview:relatedButton];
    
}

//与我相关点击（微墙）
-(void)relatedToMe{
    
    [MobClick event:@"weiqiang_mention_click"];
    
    //判断是否已经登录
    if ([[FDSUserManager sharedManager] getNowUserState]!=USERSTATE_LOGIN) {
        PersonViewController *perVC = [[PersonViewController alloc] init];
        perVC.isAppearBackBtn = YES;
        [self.navigationController pushViewController:perVC animated:YES];
        return;
    }
    
    //发送获取与我相关消息
    [[MoudleMessageManager sharedManager] beRelatedToMeWithStart:0 end:10];
    
}

//-(void)all:(UIButton *)sender
-(void)requestWeiQiang:(UIButton*)sender
{
    
    // 在点击两个按钮的时候将popview隐藏起来
    [self setupBackButtonWithStaus:self.backBtn.selected];
    
    if([sender.titleLabel.text isEqualToString:@"全部"])
    {
        
        //记录下当前的选中按钮
        self.buttonType = ButtonTypeAll;
        
        //移动滑动条
        [UIView animateWithDuration:0.3 animations:^{
            
            MoveView.frame = CGRectMake(0,-1.5, 160, 2);
        }];
        [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [SVProgressHUD popActivity];
        
        //请求数据
        if (_allStartTag == 0) {
            // 请求若干 （全部type）的数据
            _requestType = 2;
            
        
            [[MoudleMessageManager sharedManager] WeiQiangList:_requestType start:_allStartTag end:_allStartTag+kRequestCount userid:0];
        }else{
            [_tableInSelected removeFromSuperview];
            _tableInSelected = _tableViewForAll;
            //_tableInSelected.delegate = self;
            [self.view addSubview:_tableInSelected ];
            [_tableInSelected reloadData];
        }
        
    }else if([sender.titleLabel.text isEqualToString:@"关注"])
    {
        
        //判断是否已经登录
        if ([[FDSUserManager sharedManager] getNowUserState]!=USERSTATE_LOGIN) {
            PersonViewController *perVC = [[PersonViewController alloc] init];
            perVC.isAppearBackBtn = YES;
            [self.navigationController pushViewController:perVC animated:YES];
            return;
        }
        
        //记录下当前的选中按钮
        self.buttonType = ButtonTypeAttention;
        
        //移动滑动条
        [UIView animateWithDuration:0.3 animations:^{
            MoveView.frame = CGRectMake(160, -1.5, 160, 2);
        }];
        
        //调整按钮的颜色
        [btn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //去掉菊花
        [SVProgressHUD popActivity];
        
        //如果开始标签为0，请求数据
        if (_attentionStartTag == 0) {
            
            // 1请求若干关注的数据
            _requestType = 1;
            
            NSString *userid = [[FDSUserManager sharedManager] NowUserID];
            
            //发送请求关注列表的消息
            [[MoudleMessageManager sharedManager] WeiQiangList:(int)_requestType start:(int)_attentionStartTag end:(int)_attentionStartTag+kRequestCount userid:[userid intValue]];
            
        }else{
            
            //如果标识不为0，那就刷新关注列表，不请求
            [_tableInSelected removeFromSuperview];
            _tableInSelected = _tableViewForAttention;
            [self.view addSubview:_tableInSelected ];
            
            //刷新页面
            [_tableInSelected reloadData];
            
        }
    }
    
}

-(void)BackMainMenu:(UIButton *)sender
{
    
    self.backBtn.selected = !self.backBtn.selected;
    
    if (self.backBtn.selected) {
        
        //创建弹出框
        [self CreatTanChuKuang];
        
    }else{
        
        [tanChuView removeFromSuperview];
        tanChuView = nil;
        
    }
    
}

#pragma mark 进入发微博页面
-(void)publishTrends:(id)sender
{
    
    //判断是否已经登录
    if ([[FDSUserManager sharedManager] getNowUserState]!=USERSTATE_LOGIN) {
        PersonViewController *perVC = [[PersonViewController alloc] init];
        perVC.isAppearBackBtn = YES;
        [self.navigationController pushViewController:perVC animated:YES];
        return;
    }
    
    TrendViewController *trend = [[TrendViewController alloc]init];
    
    //push到发微博的控制器
    [self.navigationController pushViewController:trend animated:YES];
}

// 请求我的微墙数据
-(void)MyweiQiang:(id)sender
{
    
    [MobClick event:@"weiqiang_me_click"];
    
    //判断是否已经登录
    if ([[FDSUserManager sharedManager] getNowUserState]!=USERSTATE_LOGIN) {
        PersonViewController *perVC = [[PersonViewController alloc] init];
        perVC.isAppearBackBtn = YES;
        [self.navigationController pushViewController:perVC animated:YES];
        return;
    }
    
    //我的微墙类型
    _requestType = 0;
    
    //取出用户id
    int userID = [[[FDSUserManager sharedManager ] NowUserID] intValue];
    
    //发送消息获取我的微墙列表
    [[MoudleMessageManager sharedManager] WeiQiangList:(int)_requestType start:0 end:kRequestCount userid:userID];
    
}

//type/>//0，我的；1：关注；2：非关注
-(void)weiQiangListCB:(NSArray *)models {
    
    //将活动指示器关掉
    [SVProgressHUD popActivity];
    
    if(_requestType == 0) {
        
        //初始化数组
        if(_modelArrForMine == nil) {
            _modelArrForMine = [NSMutableArray arrayWithArray:models];
        }else {
            //先将全部的元素删掉
            [_modelArrForMine removeAllObjects];
            
            //将全部返回的模型加进去
            [_modelArrForMine addObjectsFromArray:models];
        }
#pragma mark-myWeiQiangController
        //初始化myWeiQiangController
        myWeiQiangController *weiQiang =[[myWeiQiangController    alloc]init];
        weiQiang.userid = [[FDSUserManager sharedManager] NowUserID];
        //将弹出框隐藏起来
        tanChuView.hidden = YES;
        
        //改变箭头方向
        [self.backBtn setImage:[UIImage imageNamed:@"右上角"] forState:UIControlStateNormal];
        
        //传数组过去
        weiQiang.weiQianArr  = _modelArrForMine;
        
        [self.navigationController pushViewController:weiQiang animated:YES];
        
    }
    else if(_requestType == 1) {//关注列表回调数据
        
        //初始化数组
        if(_modelArrForAttention == nil)
        {_modelArrForAttention = [NSMutableArray array];}
        
        
        if (models.count) {
            
            //如果_attentionStartTag，说明是下拉刷新或者是刚开始
            if (_attentionStartTag == 0) {
                
                //确定有数据后才将全部的元素删掉
                [_modelArrForAttention removeAllObjects];
                
            }
            
            //添加最新的数据
            [_modelArrForAttention addObjectsFromArray:models];
            
            //确定有新数据后才修改发送请求的标识
            _attentionStartTag += models.count;
            
        }

        //先把当前的选中的tableview从父视图移除，再重新添加上去
        [_tableInSelected removeFromSuperview];
        _tableInSelected = _tableViewForAttention;
        [self.view addSubview:_tableInSelected ];
        
        //刷新页面
        [_tableInSelected reloadData];
        
        
    } else if(_requestType == 2) {
        
        //设置缓存
        [self setupCacheWithModels:models];
        
        //接受到全部类型的微博数据
        if(_modelArrForAll == nil)
        {_modelArrForAll = [NSMutableArray array];}
        
        if (models.count) {
            
            //如果_mineStartTag＝＝0，说明是下拉刷新或者是刚开始
            if (_allStartTag == 0) {
                
                //确定有数据后才将全部的元素删掉
                [_modelArrForAll removeAllObjects];
                
            }
            
            //将全部返回的模型加进去
            [_modelArrForAll addObjectsFromArray:models];;
        
            //确定有新数据后才修改发送请求的标识
            _allStartTag += models.count;
            
        }
        
        //将目前选中的view删除
        [_tableInSelected removeFromSuperview];
        
        //把全部作为选中的view
        _tableInSelected = _tableViewForAll;
        //_tableInSelected.delegate = self;
        
        //添加选中的view
        [self.view addSubview:_tableInSelected ];
        
        //刷新选中的view
        [_tableInSelected reloadData];
        
    }

}

#pragma mark tabelViewDelegate------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //根据不同的tableView返回不同的数量
    if(tableView == _tableViewForAll) {
        
        return [_modelArrForAll count];
        
    }else if (tableView == _tableViewForAttention){
        
        return [_modelArrForAttention count];
        
    }
    
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

   static NSString* cellReuseForAll = @"WeiQiangViewController_cellForAll";
   static NSString* cellReuseForAttention = @"WeiQiangViewController_cellForAttention";
    
    //用的都是MJ的封装，两个模型一个cell
    if(tableView == _tableViewForAll)
    {
        WeiQiangCell* cell = [tableView dequeueReusableCellWithIdentifier:cellReuseForAll];
        if(cell == nil)
        {
            cell = [[WeiQiangCell alloc]initWithStyle:0 reuseIdentifier:cellReuseForAll];
            
            cell.delegate = self;
            cell.needHideDeleteButton = YES;// 不显示删除按钮

        }
        
        weiQiangModel * model = _modelArrForAll[indexPath.row];
        //计算出所有控件的frame
        WeiQiangCellFrame* cellFrame = [[WeiQiangCellFrame alloc]initWithModel:model cellType:CellTypeWeiQiang];
        cell.cellFrame = cellFrame;
        return cell;
    }else
    {
        if(tableView == _tableViewForAttention)
        {
            WeiQiangCell* cell = [tableView dequeueReusableCellWithIdentifier:cellReuseForAttention];
            if(cell == nil)
            {
                cell = [[WeiQiangCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseForAttention];
                cell.delegate = self;
                cell.needHideDeleteButton = YES;// 不显示删除按钮

                
            }
            
            weiQiangModel * model = _modelArrForAttention[indexPath.row];
            WeiQiangCellFrame* cellFrame = [[WeiQiangCellFrame alloc]initWithModel:model cellType:CellTypeWeiQiang];
            cell.cellFrame = cellFrame;
            return cell;
        }
    }
    
    return [[UITableViewCell alloc]init];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _tableViewForAll)
    {
        weiQiangModel * model = _modelArrForAll[indexPath.row];
        WeiQiangCellFrame* cellFrame = [[WeiQiangCellFrame alloc]initWithModel:model cellType:CellTypeWeiQiang];
        return  cellFrame.cellHight;
        
    } else {
        
        weiQiangModel * model = _modelArrForAttention[indexPath.row];
        WeiQiangCellFrame* cellFrame = [[WeiQiangCellFrame alloc]initWithModel:model cellType:CellTypeWeiQiang];
        return  cellFrame.cellHight;
        
    }
    
}

//deselected the cell
-(void)tableViewDeSelect:(UITableView*)table
{
    NSIndexPath* indexPath = [table indexPathForSelectedRow];
    [table deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [MobClick event:@"weiqiang_detial_click"];
    
    //取消点击效果
    [self tableViewDeSelect:tableView];

    weiQiangModel *model = nil;
    
    if (tableView == _tableViewForAll) {
        
        //取出模型
        model = _modelArrForAll[indexPath.row];
        
    }else{
        
        //取出模型
        model = _modelArrForAttention[indexPath.row];
        
    }
    
    
    //记录下选中的cell
    _selectedDetailIndexpath = indexPath;
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //发送微博详情消息
    if (tableView == _tableViewForAll) {
        [[MoudleMessageManager sharedManager] requestContentDetailsAtWeiQiang:[model.weiboid integerValue] :_commentStartTag :_commentStartTag+kRequestCount];
    }else{
        
        [[MoudleMessageManager sharedManager] requestContentDetailsAtWeiQiang:[model.weiboid integerValue] :0 :kRequestCount];
        
    }
    
    
    
    
    
}

//self.view和tableview上面的手势冲突了，不拦截tableview的响应事件
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//如果当前是tableView
        //做自己想做的事
        return NO;
    }
    return YES;
}

// tableView 删除单元格
-(void)WeiQiangCellDelete:(WeiQiangCell *)cell
{
    //请求删除服务器删除  60004
    // 首先计算出要删除单元格的位置 ，保存到 deleteIndexPath,后面的cb用到该位置
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];

    
    //将cell对应的model拿出来
    weiQiangModel* model = cell.cellFrame.model;
    
    //找出在数组中的标记
    NSInteger index = [_modelArrForAll indexOfObject:model];
    
    //取出对应位置的indexpath
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
    
    //删除数组中的对应的数据模型
    [_modelArrForAll removeObjectAtIndex:indexpath.row];
    
    //删除tableview上面对应deleteIndexPath的cell
    [_tableViewForAll deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexpath]
                       withRowAnimation:UITableViewRowAnimationFade];
    
    [self delete];
    
}
-(void)delete{
    [SVProgressHUD popActivity];
}

//点击发送按钮的回调
-(void)didSelectedPublishButton:(NSString *)text{
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    //发送评论
    if (_publishView.commentType==commentTypeComment) {
        
        //评论微博
        [[MoudleMessageManager sharedManager] submitCommentAtWeiQiang:_publishView.weiboid :text ];
        
    }else{
        //发送转发消息
        [[MoudleMessageManager sharedManager] relayWeiBoAtWeiQiang:_publishView.weiboid comments:text];
        
    }
    
    [_publishView endEditing:YES];
}

//将弹出框缩回去，传一个状态过来的就行了
-(void)setupBackButtonWithStaus:(BOOL)selected{
    
    //如果弹出框弹出来的话，缩回去
    if (selected) {
        self.backBtn.selected = !self.backBtn.selected;
        [tanChuView removeFromSuperview];
        tanChuView = nil;
        
    }
    
}

//下面的工具条的回调
-(void)WeiQiangCell:(WeiQiangCell *)cell didSelectedButtonIndex:(NSInteger)index{
    
    if (self.buttonType==ButtonTypeAll) {
        //判断是否已经登录
        if ([[FDSUserManager sharedManager] getNowUserState]!=USERSTATE_LOGIN) {
            PersonViewController *perVC = [[PersonViewController alloc] init];
            perVC.isAppearBackBtn = YES;
            [self.navigationController pushViewController:perVC animated:YES];
            return;
        }
    }
    
    //看弹出框的状态是否需要改变
    [self setupBackButtonWithStaus:self.backBtn.selected];
    
    //评论的时候不用添加这个阻塞的，本来键盘就有一个背景view
    if (index == 0) {
        //加了一个view覆盖再tableview上面
        _syncView = [[UIView alloc]initWithFrame:_tableViewForAll.frame];
        [self.view addSubview:_syncView];//权宜之计。阻止用户乱点。
        
    }

    //记录下cell的indexPath
    _selectedIndexpath = [_tableInSelected indexPathForCell:cell];
    
    
    switch (index) {
        case 0:
            //赞 60008
        {
            
            [MobClick event:@"weiqiang_zan_click"];
            
            //拿出模型
            weiQiangModel* model = cell.cellFrame.model;
            
            //拿出weiboid
            int weiboid = [model.weiboid integerValue];
            
            //发送消息
            [[MoudleMessageManager sharedManager]submitSupportAtWeiQiang:weiboid];
        }
            
            break;
        case 1:
        {//评论
            
            [MobClick event:@"weiqiang_reply_click"];
            
            //创建_publishView
            [self setupPublishView];
            
            //通过这个commentField成为第一响应者将键盘弹出
            [_publishView.commentField becomeFirstResponder];
            
            //拿出模型
            weiQiangModel* model = cell.cellFrame.model;
            
            //取得被评论的weiboid
            _publishView.weiboid = [model.weiboid intValue];
            
            //微博评论
            _publishView.commentType = commentTypeComment;
            
            //设置占位文字
            _publishView.commentField.placeholder = PlaceholderComment;
            
            [_tableInSelected scrollToRowAtIndexPath:_selectedIndexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

            break;
            
        }
        case 2:
            //分享60006
        {
            
            [MobClick event:@"weiqiang_share_click"];
            
            //取出cell，取出model，取出like_count＋1.再刷新页面
            WeiQiangCell* cell =(WeiQiangCell*) [_tableInSelected cellForRowAtIndexPath:_selectedIndexpath];
            weiQiangModel* model = cell.cellFrame.model;
            
            //如果有图片就分享第一张
            if (model.imgs.count!=0) {
                
                NSDictionary *urlDic = model.imgs[0];
                
                NSString *img = urlDic[@"img"];
                
                //处于分享状态，不能删除代理
                [self shareWeiQiang:model.content imageUrl:[NSString setupSileServerAddressWithUrl:img] xnid:[model.weiboid intValue]];
                
                
            }else{
                
                
                //处于分享状态，不能删除代理
                [self shareWeiQiang:model.content imageUrl:nil xnid:[model.weiboid intValue]];
            }
        }
            break;
            
        default:
            break;
    }
    
}

//设置回调地址
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
    NSString *shareUrl = [NSString stringWithFormat:@"http://www.showneng.com/xnshare.aspx?objid=%d&tag=wq",xnid];
    
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
        WeiQiangCell* cell =(WeiQiangCell*) [_tableViewForAll cellForRowAtIndexPath:_selectedIndexpath];
        weiQiangModel* model = cell.cellFrame.model;
        
        //取出weiboid
        int weiboid = (int)[model.weiboid integerValue];
        
        //发送消息60006
        [[MoudleMessageManager sharedManager] shareWeiBoAtWeiQiang:weiboid];
    }
}
//点赞回调
-(void)submitSupportAtWeiQiangCB:(int)result{
    
    //数据回来后，将_syncView删掉
    [_syncView removeFromSuperview];
    
    if (result==205) {
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"你已点赞"];
        return;
        
    }
    
    //取出cell，取出model，取出like_count＋1.再刷新页面
    WeiQiangCell* cell = (WeiQiangCell*) [_tableInSelected cellForRowAtIndexPath:_selectedIndexpath];
    
    weiQiangModel* model = cell.cellFrame.model;
    int tmpInt = [model.like_count intValue];
    tmpInt += 1;
    
    if (tmpInt>=10000) {
        //大于一万的全都表示x万
        tmpInt = tmpInt/10000;
        model.like_count = [NSString stringWithFormat:@"%d万", tmpInt];
    }else{
        model.like_count = [NSString stringWithFormat:@"%d", tmpInt];
 
    }
    
    //刷新页面
    [_tableInSelected reloadData];
    
}

//分享回调
-(void)shareWeiBoCB:(int)result{
    
    //取出cell,取出model,改变forward_count
    WeiQiangCell* cell =(WeiQiangCell*) [_tableInSelected cellForRowAtIndexPath:_selectedIndexpath];
    
    weiQiangModel* model = cell.cellFrame.model;
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
    [_tableInSelected reloadData];
}

//微博详情数据回调
-(void)contentDetailsCB:(NSDictionary *)result{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //跳到下个页面
    if (result) {
        
        detailViewController *detail = [[detailViewController alloc]init];
        
        weiQiangModel *model = nil;
        
        if (self.buttonType ==ButtonTypeAll) {
            
           model = _modelArrForAll[_selectedDetailIndexpath.row];
            
        }else{
            
           model = _modelArrForAttention[_selectedDetailIndexpath.row];
            
        }
        
        //取出图片数组
        NSArray *imgs = result[kImgsKey];
        
        //赋值
        model.imgs = imgs;
        detail.model = model;
        
        //取出对应的评论字典数组并且转换成模型数组
        NSArray *comments = result[kCommentsKey];
        for (NSDictionary *dic in comments) {
            BGWQCommentModel *model = [BGWQCommentModel commentWithDic:dic];
            [detail.commentsArray addObject:model];
            
        }
        
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}


//微博评论回调
-(void)submitCommentAtWeiQiangCB:(int)result{
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if (result == 0) {
        //取出cell,取出model,改变forward_count
        WeiQiangCell* cell =(WeiQiangCell*) [_tableInSelected cellForRowAtIndexPath:_selectedIndexpath];
        
        weiQiangModel* model = cell.cellFrame.model;
        int tmpInt = [model.comment_count intValue];
        tmpInt += 1;
        
        if (tmpInt>=10000) {
            //大于一万的全都表示x万
            tmpInt = tmpInt/10000;
            model.comment_count = [NSString stringWithFormat:@"%d万", tmpInt];
        }else{
            model.comment_count = [NSString stringWithFormat:@"%d", tmpInt];
            
        }
        
        //刷新页面
        [_tableInSelected reloadData];
    }else{
        [UIAlertView showMessage:@"评论失败"];
    }
    
}

-(void)persontap:(NSString *)userid{
    
    //记录下userid
    _otherUserid = userid;
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //是手势触发的
    self.isTouchByTap = YES;
    
    //获取个人资料
    [[FDSUserCenterMessageManager sharedManager] userRequestUserInfo:userid];
    
    //不是用户本身的
    [FDSUserCenterMessageManager sharedManager].userInfoType=UserInfoTypeOtherUserInfo;
    
}

//个人信息回调
-(void)getUserInfoCB:(NSDictionary *)dic{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //只响应手势触发的回调
    if (self.isTouchByTap) {
        
        if ([FDSUserCenterMessageManager sharedManager].userInfoType==UserInfoTypeOtherUserInfo) {
            
            PersonlCardViewController *pv = [[PersonlCardViewController alloc] init];
            pv.userDic = dic;
            pv.userid = _otherUserid;
            [self.navigationController pushViewController:pv animated:YES];
            
        }
    }

    
}

//与我相关回调
-(void)beRelatedToMeCB:(NSArray *)result{
    
    RelatedViewController *rv = [[RelatedViewController alloc] init];
    
    for (WeiQiangRelatedModel *model in result) {
        
        [rv.dataArray  addObject:model];
        
    }
    
    [self.navigationController pushViewController:rv animated:YES];
    
}

#pragma mark－缓存设置
//设置全部缓存
-(void)setupCacheWithModels:(NSArray *)models{
    
    NSString *cachePath = [NSString pathwithFileName:WeiQiangCacheKey];
    
    //再讲空数组存进去
    [NSKeyedArchiver archiveRootObject:models toFile:cachePath];
    
}

//获取缓存
-(NSArray *)getCache{
    
    NSString *cachePath = [NSString pathwithFileName:WeiQiangCacheKey];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
    
}

@end
