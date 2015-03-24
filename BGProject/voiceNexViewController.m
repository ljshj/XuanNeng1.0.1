//
//  voiceNexViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-8-1.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "voiceNexViewController.h"
#import "scanViewController.h"
#import "ProductModel.h"
#import "FDSUserCenterMessageInterface.h"
#import "FDSUserCenterMessageManager.h"
#import "PersonlCardViewController.h"
#import "SVProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import "MemberCell.h"
#import "WeiQiangCellAtHome.h"
#import "WeiQiangCellAtHomeFrame.h"
#import "MJRefresh.h"
#import "NSMutableArray+TL.h"
#import "NSArray+TL.h"
#import "ProductTableViewCell.h"
#import "MYVoiceViewController.h"
#import "BaseCellModel.h"
#import "BaseCell.h"
#import "DataBaseSimple.h"
#import "AppDelegate.h"
#import "MoudleMessageManager.h"
#import "detailViewController.h"
#import "BGWQCommentModel.h"
#import "ProductDetailViewController.h"
#import "liaoTianViewController.h"
#import "FDSUserManager.h"
#import "PersonViewController.h"
#import "ZZUserDefaults.h"

#define kAppsKey @"apps"
#define kCabinetKey @"cabinet"
#define kMembersKey @"members"
#define kWeiqiangKey @"weiqiang"

#define DividerColor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]
#define DividerFrameShowZero CGRectMake(0,80-0.5 , self.view.bounds.size.width, 0.5)
//图片数组
#define kImgsKey @"imgs"
//评论数组
#define kCommentsKey @"comments"
#define selectedColor [UIColor colorWithRed:229/255.0 green:100/255.0 blue:71/255.0 alpha:1.0]
//UserCenterMessageInterface用户中心代理，包含注册／登录／获取验证码等接口
@interface voiceNexViewController ()<UserCenterMessageInterface,CLLocationManagerDelegate,MJRefreshBaseViewDelegate,TempGroupCellDelegate,PlateformMessageInterface,MoudleMessageInterface>
{
    NSMutableArray* _cabinetArr;   //橱窗
    NSMutableArray* _memberArr;   // 会员
    NSMutableArray* _weiqiangArr; // 微墙
    NSInteger _selectIndex; // 会员 相关应用  微墙  橱窗  哪个被选中
    CLLocationManager *_locationManager;
    int _memberStartTag;
    int _weiQiangStartTag;
    int _showwindowStartTag;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    NSString *_otherUserid;
    int _commentStartTag;
    NSIndexPath* _selectedDetailIndexpath;
    
    UIImageView *tanChuView;
    
    UIButton *btnChageBig1;
    UIButton *btnChageBig2;
    
    //将roomid记录下来，马上聊天之前需要获取群成员
    NSString *_roomid;
    
    NSString *_hxgroupidSelected;
    NSString *_groupname;
    
    __weak UILabel *_promptLabel;
    
}
//搜索回调函数
-(void)searchIWantOrICanCB:(NSDictionary *)dic;

@end

@implementation voiceNexViewController
{
    UIView       *topView,*bannerView,*moveView;
    UIButton     *backBtn,*rightBtn,*bannerBtn;
    UITextField  *tf;
    
    UITableView  *myTableView,*topTabelView;
    
    NSArray *arr1;
}

-(NSMutableArray *)tempGroupFrames{
    
    if (_tempGroupFrames==nil) {
        
        _tempGroupFrames = [[NSMutableArray alloc] init];

    }
    
    return _tempGroupFrames;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //刚开始加载就初始化一个数组
        arr1 = [NSArray arrayWithObjects:@"会员",@"微墙",@"橱窗", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //将所有的请求标记修改，开始可能已经有数据了
    _memberStartTag = (int)_memberArr.count;
    _weiQiangStartTag = (int)_weiqiangArr.count;
    _showwindowStartTag = (int)_cabinetArr.count;
    
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    
    //默认选中的就是标签值为0
    _selectIndex = 0;
    
    //添加自定义的导航栏视图／搜索框／一个背后的tableview/分类视图／分类列表
    [self CreatView];
    
    //设置定位
    [self setupLlocationManager];
    
    //上下拉刷新更多数据
    [self setupMoreData];
    
    //搜索交流厅
    [self searchTempGroupWithSearchWord:self.searchWordTempGroup];
    
    
}

//刷新数据
-(void)setupMoreData{
    
    // 防止block循环retain，所以用__unsafe_unretained
    __unsafe_unretained voiceNexViewController *vc = self;
    
    //集成下拉刷新控件
    _header = [MJRefreshHeaderView header];
    _header.scrollView = myTableView;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        
        if (vc->_selectIndex==0) {
            
            //修改请求标记为0
            vc->_memberStartTag = 0;
            
            //发送会员分页搜索消息(不用定位)
            [[FDSUserCenterMessageManager sharedManager] searchMemberWithType:vc->_searchType keyword:vc->tf.text start:vc->_memberStartTag end:vc->_memberStartTag+kRequestCount ];
            
        }else if (vc->_selectIndex==1){
            
            //修改请求标记为0
            vc->_weiQiangStartTag = 0;
            
            //发送微墙分页搜索消息(不用定位)
            [[FDSUserCenterMessageManager sharedManager] searchWeiQiangWithType:vc->_searchType keyword:vc->tf.text start:vc->_weiQiangStartTag end:vc->_weiQiangStartTag+kRequestCount ];

            
        }else if (vc->_selectIndex==2){
            
            //修改请求标记为0
            vc->_showwindowStartTag = 0;
            
            //发送橱窗分页搜索消息(不用定位)
            [[FDSUserCenterMessageManager sharedManager] searchShowwindowWithType:vc->_searchType keyword:vc->tf.text start:vc->_showwindowStartTag end:vc->_showwindowStartTag+kRequestCount ];
            
        }
        
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadDeals) withObject:nil afterDelay:3];
    };
    
    // 集成上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = myTableView;
    
    // 进入上拉加载状态就会调用这个方法
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        if (vc->_selectIndex==0) {
            
            NSString *memberStartTagStr = [NSString stringWithFormat:@"%d",vc->_memberStartTag];
            
            if ([memberStartTagStr hasSuffix:@"0"]) {
                
                //发送搜索消息(不用定位)
                [[FDSUserCenterMessageManager sharedManager] searchMemberWithType:vc->_searchType keyword:vc->tf.text start:vc->_memberStartTag end:vc->_memberStartTag+kRequestCount ];
                
            }else{
                
                //提示没有更多数据
                [vc performSelector:@selector(showNoDataInfo) withObject:nil afterDelay:0];
                
            }
            
        }else if (vc->_selectIndex==1){
            
            NSString *weiQiangStartTagStr = [NSString stringWithFormat:@"%d",vc->_weiQiangStartTag];
            
            if ([weiQiangStartTagStr hasSuffix:@"0"]) {
                
                //发送微墙分页搜索消息(不用定位)
                [[FDSUserCenterMessageManager sharedManager] searchWeiQiangWithType:vc->_searchType keyword:vc->tf.text start:vc->_weiQiangStartTag end:vc->_weiQiangStartTag+kRequestCount ];
                
            }else{
                
                //提示没有更多数据
                [vc performSelector:@selector(showNoDataInfo) withObject:nil afterDelay:0];
                
            }
            
        }else if (vc->_selectIndex==2){
            
            NSString *showwindowStartTagStr = [NSString stringWithFormat:@"%d",vc->_showwindowStartTag];
            
            if ([showwindowStartTagStr hasSuffix:@"0"]) {
                
                //发送橱窗分页搜索消息(不用定位)
                [[FDSUserCenterMessageManager sharedManager] searchShowwindowWithType:vc->_searchType keyword:vc->tf.text start:vc->_showwindowStartTag end:vc->_showwindowStartTag+kRequestCount ];
                
            }else{
                
                //提示没有更多数据
                [vc performSelector:@selector(showNoDataInfo) withObject:nil afterDelay:0];
                
            }
            
        }
        
        // 3秒后刷新表格
        [vc performSelector:@selector(reloadDeals) withObject:nil afterDelay:3];
    };
    
}

-(void)showNoDataInfo{
    
    [self reloadDeals];
    
    //提示框
    [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"已经没有更多的结果了"];
    
}

//刷新表格
- (void)reloadDeals
{
    [myTableView reloadData];
    // 结束刷新状态
    [_footer endRefreshing];
    [_header endRefreshing];
}

//初始化定位
-(void)setupLlocationManager{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    //精度
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //每隔5米更新一次定位
    _locationManager.distanceFilter = 5.0;
}

#pragma mark-CLLocationManagerDelegate
//判断是否能够定位，根据系统用不同的方法
-(void)locationServicesIsAbled{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startUpdatingLocation];
        
    }else{
        if ([CLLocationManager locationServicesEnabled]) {
            [_locationManager startUpdatingLocation];
        }else{
            [SVProgressHUD popActivity];
            [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"定位失败，请开启GPS定位"];
        }
    }
    
}

//ios8,调用的函数
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [_locationManager requestAlwaysAuthorization];
            }
            break;
        default:
            break;
            
            
    }
}

//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    //取出经纬度
    double latitude = newLocation.coordinate.latitude;
    double longitude = newLocation.coordinate.longitude;
    
    //停止定位
    [_locationManager stopUpdatingLocation];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //发送搜索消息
    [[FDSUserCenterMessageManager sharedManager] searchIWantOrICan:self.searchType keyWord:tf.text latitude:latitude longitude:longitude];
    
    //统计关键词搜索
    [MobClick event:@"home_search_click"];
    
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    double latitude = 0.0;
    double longitude = 0.0;
    
    //停止定位
    [_locationManager stopUpdatingLocation];
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //发送搜索消息
    [[FDSUserCenterMessageManager sharedManager] searchIWantOrICan:self.searchType keyWord:tf.text latitude:latitude longitude:longitude];
    
    //统计关键词搜索
    [MobClick event:@"home_search_click"];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    
    //取出AppDelegate对象
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    
    //将tabBar隐藏起来
    [app hiddenTabelBar];
    
    [super viewWillAppear:animated];
    
    
    
    //将要出现的时候就控制器添加进去
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
    
    [[PlatformMessageManager sharedManager] registerObserver:self];
    
    [[MoudleMessageManager sharedManager] registerObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [SVProgressHUD popActivity];
    //已经出现的时候就将控制器删掉
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
    [[PlatformMessageManager sharedManager] unRegisterObserver:self];
    [[MoudleMessageManager sharedManager] unRegisterObserver:self];
    [super viewWillDisappear:animated];
    
    
    
}

-(void)CreatView
{
    //导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    //返回按钮
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.tag = 1;
    [topView addSubview:backBtn];
    
    //导航栏标签
    UILabel  *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    if([_titleStr length]==0)
    {
          label.text = @"语音搜索";
    } else
    {
       //显示“搜索结果”
       label.text = _titleStr;
    }
    

    label.textColor = TITLECOLOR;
    label.font = TITLEFONT;
    [topView addSubview:label];
    [self.view addSubview:topView];
    
    //输入框
    tf= [[UITextField alloc]initWithFrame:CGRectMake(10, topView.frame.origin.y+topView.frame.size.height+2, 260, 30)];
    tf.delegate = self;
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.placeholder = @"请输入搜索内容";
    tf.text = self.searchWordTempGroup;
    tf.returnKeyType = UIReturnKeySearch;
    
#pragma mark-左边的倒三角
    
    UIButton *triangleButton = [[UIButton alloc] init];
    CGFloat triangleX = 15;
    CGFloat triangleY = 15;
    CGFloat triangleW = 15;
    CGFloat triangleH = 15;
    triangleButton.frame = CGRectMake(triangleX, triangleY, triangleW, triangleH);
    [triangleButton addTarget:self action:@selector(triangleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [triangleButton setImage:[UIImage imageNamed:@"首頁我能_08"] forState:UIControlStateNormal];
    
    //线
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(40, 0, 1, 44)];
    lineView.backgroundColor =[UIColor grayColor];
    lineView.alpha = 0.2;
    
    //输入框左边的背景图
    UIView *bigView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 41, 44)];
    [bigView addSubview:triangleButton];
    [bigView addSubview:lineView];
    tf.leftView = bigView;
    tf.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:tf];
    
    //左边搜索按钮
    rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(275, tf.frame.origin.y , 40, 30)];
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    rightBtn.titleLabel.textColor = [UIColor blackColor];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag = 2;
    [self.view addSubview:rightBtn];
    
#pragma mark-显示交流厅的列表
    topTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tf.frame)+2, self.view.frame.size.width, 80)];
    topTabelView.delegate = self;
    topTabelView.dataSource =  self;
    topTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:topTabelView];
    
    //如果没有搜索到交流厅就显示出来
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-300)/2, 25, 300, 30)];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.text = @"没有搜索到相关的交流厅，再试试";
    promptLabel.font = [UIFont systemFontOfSize:15.0];
    promptLabel.textColor = [UIColor grayColor];
    promptLabel.hidden = YES;
    [topTabelView addSubview:promptLabel];
    _promptLabel = promptLabel;
    
    //分类视图
    bannerView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topTabelView.frame), 320, 50)];
    bannerView.layer.borderWidth =  0.5;
    bannerView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    bannerView.backgroundColor = [UIColor whiteColor];

    //设置上面的三个按钮
    for (int  i = 0; i < 3; i++) {
        bannerBtn = [[UIButton  alloc]initWithFrame:CGRectMake(i*(320/3-0.5)+i*0.5, 0.5, (320/3-0.5), 49)];
        bannerBtn.tag = 100+i;
        [bannerBtn setTitle:arr1[i] forState:UIControlStateNormal];
        [bannerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bannerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bannerBtn addTarget:self action:@selector(bannerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bannerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bannerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        if (bannerBtn.tag ==100) {
            bannerBtn.selected = YES;
        }
        //添加到分类视图上面
        [bannerView addSubview:bannerBtn];
        
    }
    
    for (int i = 0; i < 2; i++) {
        //添加三条分割线
        UIView *bannerSubView =[[UIView alloc]initWithFrame:CGRectMake((i+1)*(320/3-0.5)+i*0.5, 0, 0.5, 50)];
        bannerSubView.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        [bannerView addSubview:bannerSubView];
    }
    [self.view addSubview:bannerView];
    
    //下面那条滑条
    moveView =[[UIView alloc]initWithFrame:CGRectMake(0,48, self.view.frame.size.width/3, 2)];
    moveView.backgroundColor = [UIColor blueColor];
    [bannerView addSubview:moveView];
    
    //分类列表的tableview
    CGFloat tableViewX = 0;
    CGFloat tableViewY = CGRectGetMaxY(bannerView.frame);
    CGFloat tableViewW = self.view.bounds.size.width;
    CGFloat tableViewH = self.view.bounds.size.height-tableViewY;
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH) style:UITableViewStylePlain];
    myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    myTableView.delegate = self;
    myTableView.dataSource =  self;
    myTableView .rowHeight =  80;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTableView registerNib:[UINib nibWithNibName:@"ProductTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProductTableViewCell"];
    [self.view addSubview:myTableView];
    

}

//三角被点击
-(void)triangleButtonClick:(UIButton *)button{
    
    //修改状态
    button.selected = !button.selected;
    
    
    if (button.selected) {
        
        [self CreatTanChuKuang];
        
    }else{
        
        [self removeTanChuKuang];
        
    }
    
}


//删除弹出框
-(void)removeTanChuKuang{
    
    [tanChuView removeFromSuperview];
    tanChuView = nil;
    
}

//创建弹出框
-(void)CreatTanChuKuang
{
    //弹出框的背景图片，泡泡
    tanChuView = [[UIImageView alloc]initWithFrame:CGRectMake(9, kTopViewHeight+30, 120, 93)];
    tanChuView.userInteractionEnabled = YES;
    tanChuView.image = [UIImage imageNamed:@"首頁我能_14"];
    tanChuView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:tanChuView];
    
    //泡泡－我想按钮
    btnChageBig1 = [[UIButton alloc]initWithFrame:CGRectMake(5, 8, 110, 40)];
    
    if (self.searchType==kSearchType_IWanted) {
        btnChageBig1.selected = YES;
    }
    
    [btnChageBig1 addTarget:self action:@selector(bubleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    btnChageBig1.tag = 101;
    [btnChageBig1 setTitle:@"我想" forState:UIControlStateNormal];
    [btnChageBig1 setImage:[UIImage imageNamed:@"firstPage_search"] forState:UIControlStateNormal];
    [btnChageBig1 setImage:[UIImage imageNamed:@"firstPage_search_highlighted"] forState:UIControlStateSelected];
    [btnChageBig1 setTitleColor:selectedColor forState:UIControlStateSelected];
    btnChageBig1.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 70);
    btnChageBig1.titleEdgeInsets = UIEdgeInsetsMake(5, -10, 5, 0);
    [btnChageBig1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnChageBig1.titleLabel.font = [UIFont systemFontOfSize:14];
    [tanChuView addSubview:btnChageBig1];
    
    
    //泡泡－我能按钮
    btnChageBig2 = [[UIButton alloc]initWithFrame:CGRectMake(5, btnChageBig1.frame.origin.y+btnChageBig1.frame.size.height, 110, 40)];
    btnChageBig2.tag = 102;
    if (self.searchType==kSearchType_ICan) {
        btnChageBig2.selected = YES;
    }
    [btnChageBig2 addTarget:self action:@selector(bubleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnChageBig2 setImage:[UIImage imageNamed:@"firstPage_search"] forState:UIControlStateNormal];
    [btnChageBig2 setImage:[UIImage imageNamed:@"firstPage_search_highlighted"] forState:UIControlStateSelected];
    [btnChageBig2 setTitle:@"我能" forState:UIControlStateNormal];
    [btnChageBig2 setTitleColor:selectedColor forState:UIControlStateSelected];
    btnChageBig2.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 70);
    btnChageBig2.titleEdgeInsets = UIEdgeInsetsMake(5, -10, 5, 0);
    [btnChageBig2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnChageBig2.titleLabel.font = [UIFont systemFontOfSize:14];
    [tanChuView addSubview:btnChageBig2];
    
}

//泡泡按钮被点击（我能／我想）
-(void)bubleButtonClick:(UIButton *)button{
    
    if (button.tag==101) {
        
        //修改按钮的状态（哪个按钮被点击哪个按钮就被选中）
        btnChageBig1.selected = YES;
        btnChageBig2.selected = NO;
        
        //修改搜索类型
        self.searchType = kSearchType_IWanted;
        
    }else{
        
        //修改按钮的状态（哪个按钮被点击哪个按钮就被选中）
        btnChageBig1.selected = NO;
        btnChageBig2.selected = YES;
        
        //修改搜索类型
        self.searchType = kSearchType_ICan;
    }
    
}

-(void)searchTempGroupWithSearchWord:(NSString *)word{
    
    //查询交流厅数据
    [[FDSUserCenterMessageManager sharedManager] searchTempGroupWithKeyword:word];
    
}

#pragma mark btnclik=======================
-(void)search:(UIButton *)sender
{
    
    //开启线程搜索交流厅
    [NSThread detachNewThreadSelector:@selector(searchTempGroupWithSearchWord:) toTarget:self withObject:tf.text];
    
    //失去第一响应
    [tf resignFirstResponder];
    
    if (sender.tag == 1) {
        //返回上一页
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        //右边搜索按钮
        NSLog(@"开始搜索");
        if([tf.text length]>0) {
            
            [self locationServicesIsAbled];
            
        } else {
            
            //如果没有输入内容
            [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"搜索内容不能为空"];
            
        }
    }
}

-(void)bannerBtnClick:(UIButton *)sender
{
    for (UIButton *btn in [bannerView subviews])
    {
        //将其他选中状态置为NO
        if (btn.tag == 100||btn.tag==101||btn.tag==102) {
            btn.selected = NO;
        }
        //将传进来的button选中状态置YES
        sender.selected = YES;
    }
    //改变滑条的坐标
    [UIView animateWithDuration:0.3 animations:^{
        //
        CGRect rect = moveView.frame;
        rect.origin.x = sender.frame.origin.x;
        moveView.frame = rect;
    }];
    
    //相应的按钮做相应的事，刷新tableview的数据
    switch (sender.tag) {
        case 100:
        {
            NSLog(@"会员");
            
            //统计会员栏目
            [MobClick event:@"home_result_member_click"];
            
            //记下选中按钮的标签
            _selectIndex = 0;
            
            [myTableView reloadData];
            
        }
            break;
        case 101:
        {
            
            //统计微墙栏目
            [MobClick event:@"home_result_weiqiang_click"];
            
            _selectIndex = 1;
            
            [myTableView reloadData];
            
            NSLog(@"微墙");
            
        }
            break;
        case 102:
        {
            
            //统计橱窗栏目
            [MobClick event:@"home_result_chuchuang_click"];
            
            _selectIndex = 2;
            
            [myTableView reloadData];
            
            NSLog(@"橱窗");
            
        }
            break;
            
        default:
            _selectIndex = 0;
            break;
    }
}




#pragma mark tabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==topTabelView) {
        
        return self.tempGroupFrames.count;
        
    }
    else//下面那个分类列表
    {
        NSUInteger count = 0;
        //根据不同的标签选中不同的数组进行数据显示
        if (_selectIndex == 0)
        {
           count =  _memberArr.count;
        }
        
        if(_selectIndex == 1)
        {
            count = _weiqiangArr.count;
        }
        
        if(_selectIndex == 2)
        {
           count = _cabinetArr.count;
        }
        
        // default value
        return  count;
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==topTabelView && self.tempGroupFrames.count!=0) {
        
        BaseCellFrame *frame = self.tempGroupFrames[indexPath.row];
        return frame.cellHeight;
        
    }
    
    if (_selectIndex==1) {
        
        WeiQiangCellAtHomeFrame* cellFrame = [[WeiQiangCellAtHomeFrame alloc]init];
        cellFrame.model = _weiqiangArr[indexPath.row];
        
        return cellFrame.cellHeight;
        
    }else if (_selectIndex==0){
        
        MemberCellFrame* cellFrame = [[MemberCellFrame alloc]init];
        cellFrame.model = _memberArr[indexPath.row];
        return cellFrame.cellHeight;
    }
    
    return 80;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(tableView==myTableView) {
        if(_selectIndex == 0) {
            
            static NSString *identifier = @"memeberCell";
            MemberCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MemberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            MemberCellFrame* cellFrame = [[MemberCellFrame alloc]init];
            cellFrame.model = _memberArr[indexPath.row];
            cell.cellFrame = cellFrame;

            
            return cell;
        }else if(_selectIndex == 2) {
            static NSString *identifier = @"ProductTableViewCell";
            ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[ProductTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.model = _cabinetArr[indexPath.row];
            
            [self addDividerBottomWithCell:cell indexPath:indexPath];
            
            return cell;
            
        }else if(_selectIndex == 1){
            static NSString *identifier = @"weiqiangCell";
            WeiQiangCellAtHome *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[WeiQiangCellAtHome alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            WeiQiangCellAtHomeFrame* cellFrame = [[WeiQiangCellAtHomeFrame alloc]init];
            cellFrame.model = _weiqiangArr[indexPath.row];
            
            cell.cellFrame = cellFrame;
            
            [self addDividerBottomWithCell:cell indexPath:indexPath];
            
            return cell;
        }
    }
    
    static NSString *crowedCellID = @"crowedCell";
    
    BaseCell *crowedCell = [tableView dequeueReusableCellWithIdentifier:crowedCellID];
    if (!crowedCell)
    {
        crowedCell = [[BaseCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:crowedCellID];
        crowedCell.delegate = self;
    }
    crowedCell.cellFrame =self.tempGroupFrames[indexPath.row];
    crowedCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return crowedCell;
}

//取消选中效果
-(void)tableViewDeSelect:(UITableView*)table
{
    NSIndexPath* indexPath = [table indexPathForSelectedRow];
    [table deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self tableViewDeSelect:tableView];
    
    if (tableView==topTabelView) {
        
        
        
    }else{
        
        if (_selectIndex==0) {//会员
            
            //统计会员
            [MobClick event:@"home_result_member_info_click"];
            
            //取出模型
            MemberModel *model = _memberArr[indexPath.row];
            
            NSString *userid = [NSString stringWithFormat:@"%d",[model.userid intValue]];
            _otherUserid = userid;
            
            //爆菊花
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            
            //获取个人资料
            [[FDSUserCenterMessageManager sharedManager] userRequestUserInfo:userid];
            
            //不是用户本身的
            [FDSUserCenterMessageManager sharedManager].userInfoType=UserInfoTypeOtherUserInfo;
            
        }else if (_selectIndex==1){
            
            //统计微墙
            [MobClick event:@"home_result_weiqiang_info_click"];
            
            //取出微墙模型
            weiQiangModel *model = _weiqiangArr[indexPath.row];
            
            //记录下选中的cell
            _selectedDetailIndexpath = indexPath;
            
            //发送获取微墙详情消息
            [[MoudleMessageManager sharedManager] requestContentDetailsAtWeiQiang:[model.weiboid intValue] :_commentStartTag :_commentStartTag+kRequestCount];
            
        }else{
            
            //统计橱窗
            [MobClick event:@"home_result_chuchuang_info_click"];
            
            //创建产品详情控制器
            ProductDetailViewController* vc = [[ProductDetailViewController alloc]initWithNibName:nil bundle:nil ];
            
            
            TLProductModel *tlModel = _cabinetArr[indexPath.row];
            ProductModel *model = [[ProductModel alloc] init];
            model.product_name = tlModel.title;
            model.product_id = [NSNumber numberWithInt:[tlModel.productid intValue]];
            model.product_id_int = [model.product_id intValue];
            NSString *pricestr = [tlModel.price stringByReplacingOccurrencesOfString:@"¥" withString:@""];
            model.price = [NSNumber numberWithInt:[pricestr intValue]];
            model.img = tlModel.img;
            model.img_thum = tlModel.img_thum;
            
            //获取产品模型
            vc.model = model;
            vc.productType=ProductTypeAll;
            
            //切换控制器
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }
    
}

//添加底部分割线
-(void)addDividerBottomWithCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = DividerColor;
    
    if (_selectIndex==0) {
        
        
    }else if (_selectIndex==2){
        
        divider.frame = DividerFrameShowZero;
        
    }else if (_selectIndex==1){
        
        divider.frame = DividerFrameShowZero;
        
    }
    
    
    [cell addSubview:divider];
    
}

//微博详情数据回调
-(void)contentDetailsCB:(NSDictionary *)result{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //跳到下个页面
    if (result) {
        
        detailViewController *detail = [[detailViewController alloc]init];
        
        weiQiangModel *model = _weiqiangArr[_selectedDetailIndexpath.row];
        
        
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

#pragma mark --uitextFiedDelegate====

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //失去第一响应
    [tf resignFirstResponder];
    
    [self search:nil];
    
    return  YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //在键盘点击其他地方的时候推下去
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchIWantOrICanCB:(NSDictionary *)dic
{
    //将活动指示器关掉
    [SVProgressHUD popActivity];
    [self setAllModelsArr:dic];
    
    //刷新数据
    [myTableView reloadData];
}

//搜索会员回调
-(void)searchMemberCB:(NSDictionary *)data{
    
    //如果是0，说明是下拉刷新或者是刚开始请求数据
    if (_memberStartTag==0) {
        
        [_memberArr removeAllObjects];
        
    }
    
    //members
    NSArray *rawArr = data[@"members"];
    
    __unsafe_unretained voiceNexViewController *vc = self;
    
    [rawArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* rawDic = obj;
        
        MemberModel* model = [[MemberModel alloc] init];
        // 数组的每个元素都是一个字典
        [rawDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [model setValue:obj   forKey:key];
        }];
        [vc->_memberArr addObject:model];
    }];
    
    //修改请求标记
    _memberStartTag = _memberStartTag+(int)rawArr.count;
    
    [myTableView reloadData];
    
}

//微墙分页搜索
-(void)searchWeiQiangCB:(NSDictionary *)data{
    
    //如果是0，说明是下拉刷新或者是刚开始请求数据
    if (_weiQiangStartTag==0) {
        
        [_weiqiangArr removeAllObjects];
        
    }
    
    //weiqiang
    NSArray *rawArr = data[@"weiqiang"];
    
    for (NSDictionary *dic in rawArr) {
        
        weiQiangModel* model = [[weiQiangModel alloc] initWithDic:dic];
        
        model.isSearchWeiQiang = YES;
        
        [_weiqiangArr addObject:model];
        
    }
    
    //修改请求标记
    _weiQiangStartTag = _weiQiangStartTag+(int)rawArr.count;
    
    [myTableView reloadData];
    
}

//橱窗搜索分页请求回调
-(void)searchShowwindowCB:(NSDictionary *)data{
    
    //如果是0，说明是下拉刷新或者是刚开始请求数据
    if (_showwindowStartTag==0) {
        
        [_cabinetArr removeAllObjects];
        
    }
    
    //cabinet product
    NSArray *rawArr = data[@"cabinet"];
    
    __unsafe_unretained voiceNexViewController *vc = self;
    
    [rawArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* rawDic = obj;
        
        TLProductModel* model = [[TLProductModel alloc] init];
        // 数组的每个元素都是一个字典
        [rawDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [model setValue:obj   forKey:key];
        }];
        [vc->_cabinetArr addObject:model];
    }];
    
    //修改请求标记
    _showwindowStartTag = _showwindowStartTag+(int)rawArr.count;
    
    [myTableView reloadData];
}

-(void)searchTempGroupCB:(NSDictionary *)dic{
    
    //去掉数组
    [SVProgressHUD popActivity];
    
    //不管三七二十一，先删掉所有数据
    [self.tempGroupFrames removeAllObjects];
    
    //取出交流厅数组
    NSArray *items = dic[@"items"];
    
    //如果返回的是null就不再执行下去了
    if (dic[@"items"]==[NSNull null]) {
        
        NSLog(@"null");
        
        return;
        
    }
    
    //字典数组转换成模型数组
    for (NSDictionary *tempDic in items) {
        
        BaseCellModel *model = [[BaseCellModel alloc] initWithDic:tempDic];
        
        BaseCellFrame *groupFrame = [[BaseCellFrame alloc] init];
        groupFrame.model = model;
        
        //这种类型的会显示加入交流厅按钮
        groupFrame.cellFrameType=CellFrameTypeJoinJTempGroup;
        
        [self.tempGroupFrames addObject:groupFrame];
        
    }
    
    if (self.tempGroupFrames.count==0) {
        
        _promptLabel.hidden = NO;
        
    }else{
        
        _promptLabel.hidden = YES;
        
    }
    
    //刷新列表
    [topTabelView reloadData];
    
}

//加入交流厅按钮被点击
-(void)didClickJoinButtonWithRoomid:(NSString *)roomid userid:(NSString *)userid{
    
    //判断是否已经登录
    if ([[FDSUserManager sharedManager] getNowUserState]!=USERSTATE_LOGIN) {
        PersonViewController *perVC = [[PersonViewController alloc] init];
        perVC.isAppearBackBtn = YES;
        [self.navigationController pushViewController:perVC animated:YES];
        return;
    }
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //发送添加群成员的消息
    [[PlatformMessageManager sharedManager] addFriendsToTempGroupWithUserid:@[userid] groupid:roomid agr:@"true"];
    
}

-(void)addFriendsToTempGroupCB:(NSArray *)result{
    
    if (result.count!=0) {
        
        //取出第一个模型
        BaseCellFrame *tempFrame = self.tempGroupFrames[0];
        
        //插入数据库
        [[DataBaseSimple shareInstance] insertGroupsWithModel:tempFrame.model];
        
//##################直接推聊天控制器#################
        
        //记录下群名称
        _hxgroupidSelected = tempFrame.model.hxgroupid;
        
        //记录下roomid
        _roomid = tempFrame.model.roomid;
        
        //记录下群名称
        _groupname = tempFrame.model.name;
        
        
        //发送获取群成员列表消息
        [[PlatformMessageManager sharedManager] requestGroupMembersWithRoomid:_roomid];
        
        //提示框
        //[[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"加入成功"];
        
    }else{
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"加入失败"];
        
    }
    
}

-(void)requestGroupMembersCB:(NSArray *)data{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if (data.count!=0) {
        
        for (FriendCellModel *model in data) {
            
            //插入数据库
            [[DataBaseSimple shareInstance] insertMemberWithModel:model hxgroupid:_hxgroupidSelected];
            
        }
        
        [self pushToChatViewControllerWithMembers:data];
        
    }else{
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"群信息加载失败"];
        
    }
    
    
}

//马上聊天

-(void)pushToChatViewControllerWithMembers:(NSArray *)members{
    
    [MobClick event:@"home_result_chat_click"];
    
    liaoTianViewController *lv = [[liaoTianViewController alloc] init];
    
    //设置聊天类型
    lv.chatType = ChatTypeGroupTemp;
    
    //取得用户名
    lv.username = _hxgroupidSelected;
    
    //取得群名称
    lv.groupname = _groupname;
    
    //赋值过后就要将其置空,只有选择的时候才不为空
    _hxgroupidSelected = nil;
    
    //取得群成员数组
    lv.members = members;
    
    //获取roomid(转化成字符串，作为messageid的key)
    lv.roomid = _roomid;
    
    [self.navigationController pushViewController:lv animated:YES];
    
}

//将字典里面的数据分发给各个列表数组，跳过来的时候没有分发
-(void)setAllModelsArr:(NSDictionary *)allModelsArr {
    
    _cabinetArr = allModelsArr[kCabinetKey];
    _memberArr = allModelsArr[kMembersKey];
    _weiqiangArr = allModelsArr[kWeiqiangKey];
    
}
-(void)dealloc{
    
    _cabinetArr = nil;
    _memberArr = nil;
    _weiqiangArr = nil;
    _locationManager = nil;
    _footer= nil;
    _header=nil;
    self.titleStr = nil;
    self.allModelsArr = nil;
    
    topView = nil;
    bannerView = nil;
    moveView = nil;
    backBtn = nil;
    rightBtn = nil;
    bannerBtn=nil;
    tf = nil;
    myTableView = nil;
    topTabelView = nil;
    arr1 =nil;
    
    
}
@end
