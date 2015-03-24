//
//  SearchViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "SearchViewController.h"
#import "AppDelegate.h"
#import "FDSUserCenterMessageManager.h"
#import "voiceNexViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SVProgressHUD.h"
#import "HistoryTableView.h"
#import "HistoryTableViewCell.h"
#import "NSString+TL.h"

#define kCancelText     @"取消"
#define kSubmitText     @"确定"

#define kSearchSorceHistory 0
#define kSearchSorceTextField 1
#define kHistoryTableViewCell @"HistoryTableViewCell"
// @"INeedArray.archiver"
#define kINeedArray @"INeedArray.archiver"
#define kICanArray @"ICanArray.archiver"

@interface SearchViewController ()<UserCenterMessageInterface,CLLocationManagerDelegate,UIAlertViewDelegate>
{
    UIView *topView;
    UIButton *backBtn;  // 取消按钮
    UITextField *tf;    // 输入的框
    
    HistoryTableView *myTableView;
    CLLocationManager *_locationManager;
    NSMutableArray *_historyArray;
    NSString *_searchStr;//这是用于拿出历史记录的
    
    NSString *_searchWordTempGroup;//这是用来拿过去搜索交流厅的
    
    BOOL _searchSorce;
    BOOL _isArchive;
    
    
    
}

@property(weak,nonatomic)FDSUserCenterMessageManager* userCenterMessageManager;

@end

@implementation SearchViewController

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
    
    //取出AppDelegate对象
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    
    //将tabBar隐藏起来
    [app hiddenTabelBar];
    
    //先把控制器注册一下，方便后面请求回来的时候回调数据
    [_userCenterMessageManager registerObserver:self];
    
    //解档
    NSString *historyPath = nil;
    if (_searchType == kSearchType_IWanted) {
        
        historyPath = [NSString pathwithFileName:kINeedArray];
        
    }else{
        
       historyPath = [NSString pathwithFileName:kICanArray];
        
    }
    
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:historyPath];
    
    //如果为NO说明还没存档，就添加进去
    if (_isArchive == NO) {
        
        for (id hisObj in array) {
            
            [_historyArray addObject:hisObj];
            
        }
    }
    
    //刷新历史列表
    [myTableView reloadData];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    //在他要消失的时候将它移除出数组
    [_userCenterMessageManager unRegisterObserver:self];
    
    //将活动指示器去掉
    [SVProgressHUD popActivity];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化成员变量
    _historyArray = [[NSMutableArray alloc] init];
    
    //创建取消／输入框／显示搜索结果的表格
    [self CreatTopView];
    
    //创建消息管理中心单例
    _userCenterMessageManager = [FDSUserCenterMessageManager sharedManager];
    
    //定位
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 5.0;

}

-(void)CreatTopView
{
    
    //取消按钮
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(270, 30, 50, 30)];
    [backBtn setTitle:kCancelText forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    //创建输入框
    tf= [[UITextField alloc]initWithFrame:CGRectMake(10, 30, 260, 30)];
    tf.delegate = self;
    tf.returnKeyType = UIReturnKeySearch;
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.font = [UIFont systemFontOfSize:13.0];
    tf.placeholder = @"请输入搜索内容";
    
    
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 13, 13)];
    imageView.image =[UIImage imageNamed:@"首頁我能_08"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(40, 0, 1, 44)];
    lineView.backgroundColor = [UIColor blackColor];
    lineView.alpha = 0.1;
    UIView *bigView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 41, 44)];
    [bigView addSubview:imageView];
    [bigView addSubview:lineView];
    
    tf.leftView = bigView;
    tf.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:backBtn];
    [self.view addSubview:tf];
    
    UIButton *clearButton = [[UIButton alloc] init];
    
    clearButton.frame = CGRectMake(0, 0, 200, 80);
    [clearButton setTitle:@"清除历史记录" forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    clearButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [clearButton addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
    
    //创建一个用于显示搜索结果的myTableView
    myTableView = [[HistoryTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    myTableView.delegate = self;
    myTableView.tf = tf;
    myTableView.dataSource =  self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.tableFooterView = clearButton;
    [myTableView registerNib:[UINib nibWithNibName:kHistoryTableViewCell bundle:nil] forCellReuseIdentifier:kHistoryTableViewCell];
    [self.view addSubview:myTableView];
    
    
}

#pragma mark btn=====

-(void)BackMainMenu:(UIButton *)sender
{
    NSString* buttonTitle = sender.titleLabel.text;
    //如果是取消就返回首页
    if([buttonTitle isEqualToString:kCancelText]) {
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        [app showTableBar];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if([buttonTitle isEqualToString:kSubmitText]) {
        // 开始搜索
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark textFiedDelegate
//return按钮被点击
//2014年09月09日：开始搜索
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //失去第一响应，键盘下去
    [tf resignFirstResponder];
    
    //将搜索内容归档
    NSString *searchWord =[NSString stringWithFormat:@"%@",tf.text];
    if ([searchWord isEqualToString:@""]) {
        
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"搜索内容不能为空"];
        
    }else{
        
        //归档／定位
        [self readyToResearch:searchWord];
        
    }
    
    
    return YES;
}
-(void)readyToResearch:(NSString *)searchWord{
    
    //如果数组里面没有元素，直接添加进去
    if (_historyArray.count == 0) {
        
        //讲搜索词语添加到历史数组里面去
        [_historyArray addObject:searchWord];
        
    }else{
        
        //检测要搜索的词语在数组里面是否存在
        BOOL isHistoryExist = NO;
        for (NSString *searchStr in _historyArray) {
            if ([searchStr isEqualToString:searchWord]) {
                isHistoryExist = YES;
                break;
            }
        }
        
        //搜索的不在历史数组里面
        if (isHistoryExist == NO) {
            
            //添加进历史数组
            [_historyArray addObject:searchWord];
            
        }
    }
    
    //根据请求类型（0:我想1:我能）生成存储路径
    NSString *historyPath = nil;
    if (_searchType == kSearchType_IWanted) {
       historyPath = [NSString pathwithFileName:kINeedArray];
    }else{
       historyPath = [NSString pathwithFileName:kICanArray];
    }
    
    
    if([NSKeyedArchiver archiveRootObject:_historyArray toFile:historyPath]){
        
        NSLog(@"NSKeyedArchiver archiveRootObject sucessess");
        
        //表示已经存储搜索词
        _isArchive = YES;
    }

    //设置搜索词的来源
    _searchSorce = kSearchSorceTextField;
    
    //弹出活动指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //判断是否能够定位，根据系统用不同的方法
    [self locationServicesIsAbled];
    
    
}

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
    
    //从搜索历史／输入框获取搜索关键字
    NSString *searchStr = nil;
    if (_searchSorce == kSearchSorceHistory) {
        searchStr = _searchStr;
    }else{
        searchStr = tf.text;
    }
    
    //停止定位
    [_locationManager stopUpdatingLocation];
    
    //发送搜索消息
    [_userCenterMessageManager searchIWantOrICan:_searchType keyWord:searchStr latitude:latitude longitude:longitude];
    
    //统计关键词搜索
    [MobClick event:@"home_search_click"];
    
    //记录下搜索的词语
    _searchWordTempGroup = searchStr;
    
    
}
//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [SVProgressHUD popActivity];
    
    double latitude = 0;
    double longitude = 0;
    
    //从搜索历史／输入框获取搜索关键字
    NSString *searchStr = nil;
    if (_searchSorce == kSearchSorceHistory) {
        searchStr = _searchStr;
    }else{
        searchStr = tf.text;
    }
    
    //定位失败也要发送搜索消息
    [_userCenterMessageManager searchIWantOrICan:_searchType keyWord:searchStr latitude:latitude longitude:longitude];
    
    //统计关键词搜索
    [MobClick event:@"home_search_click"];
    
    //记录下搜索的词语，用于搜索交流厅
    _searchWordTempGroup = searchStr;
    
    //停止定位
    [_locationManager stopUpdatingLocation];
    
    
    NSLog(@"%@",error);
    
}
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    
//    if([textField.text length]>0) {
//        [backBtn setTitle:kSubmitText forState:UIControlStateNormal];
//    }else {
//        [backBtn setTitle:kCancelText forState:UIControlStateNormal];
//    }
//    
//    return YES;
//}

#pragma mark tabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_historyArray.count == 0) {
        myTableView.tableFooterView.hidden = YES;
    }else{
        myTableView.tableFooterView.hidden = NO;
    }
    return _historyArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHistoryTableViewCell];
    cell.searchWord.text = _historyArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //取出相应的搜索词
    _searchStr = _historyArray[indexPath.row];
    
    //从历史中选择
    _searchSorce = kSearchSorceHistory;
    
    //判断是否能够定位
    [self locationServicesIsAbled];
    
}


-(void)clearHistory{
    
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"删除提示" message:@"确认清除搜索历史？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    

    
}

//UIAlertView回调
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //确认要清除记录
    if (buttonIndex == 1) {
        
        [self reallyClearHistory];
        
    }
}


-(void)reallyClearHistory{
    
    //先讲数组的元素全部删除
    [_historyArray removeAllObjects];
    
    //根据请求类型取出相应的数组
    NSString *historyPath = nil;
    if (_searchType == kSearchType_IWanted) {
        
        historyPath = [NSString pathwithFileName:kINeedArray];
        
    }else{
        
        historyPath = [NSString pathwithFileName:kICanArray];
        
    }
    
    //再讲空数组存进去
    [NSKeyedArchiver archiveRootObject:_historyArray toFile:historyPath];
    
    //刷新列表
    [myTableView reloadData];
    
    
}
-(void)searchIWantOrICanCB:(NSDictionary *)dic
{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //创建搜索结果控制器
    voiceNexViewController* viewController = [[voiceNexViewController alloc]initWithNibName:nil bundle:nil   ];
    
    //记录下搜索的词语，那边还要搜一下交流厅
    viewController.searchWordTempGroup = _searchWordTempGroup;
    
    //两种搜索方式，导航栏标签是不一样的
    viewController.titleStr = @"搜索结果";
    
    //搜索类型
    viewController.searchType = _searchType;
    
    //返回的会员／应用／围墙／橱窗的数据都在这个字典里
    viewController.allModelsArr  = dic;
    
    //历史记录被点击也是已经存档到数据，要标记
    _isArchive = YES;
    
    //切换控制器
    [self.navigationController pushViewController:viewController animated:YES];
    
}


@end
