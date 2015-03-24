//
//  MYVoiceViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "MYVoiceViewController.h"
#import "AppDelegate.h"
#import "voiceNexViewController.h"
#import "OLImage.h"
#import "OLImageView.h"

#import "FDSUserCenterMessageManager.h"
#import <CoreLocation/CoreLocation.h>
#import "SVProgressHUD.h"

#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlySpeechConstant.h"

@interface MYVoiceViewController ()<UserCenterMessageInterface,CLLocationManagerDelegate,IFlyRecognizerViewDelegate>

@end

@implementation MYVoiceViewController
{
    UIView *topView;
    UIButton *backBtn;
    OLImageView *_GifView;
    IFlyRecognizerView *_iflyRecognizerView;
    BOOL ISfailImg;
    BOOL _isPushController;
    UIButton *startBtn;
    NSString *_searchStr;
    CLLocationManager *_locationManager;
    NSString *_voiceStr;
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
    
    //取出AppDelegate对象
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    
    //将tabBar隐藏起来
    [app hiddenTabelBar];
    
    //先把控制器注册一下，方便后面请求回来的时候回调数据
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
    
    [super viewWillAppear:animated];
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    
   
    //终止识别
    [_iflyRecognizerView cancel];
    [_iflyRecognizerView setDelegate:nil];
    
    //在他要消失的时候将它移除出数组
    [[FDSUserCenterMessageManager sharedManager] unRegisterObserver:self];
    
    //将活动指示器去掉
    [SVProgressHUD popActivity];
    
    [super viewWillDisappear:animated];
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建导航栏／返回按钮／中间标签／gifview／开始按钮／停止按钮
    [self CreatTopView];
    
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    //一开始，开始按钮可以点击，停止按钮不可以点击
    startBtn.enabled = YES;
    
    //设置定位
    [self setupLocationManager];
    
    //初始化语音识别控件
    [self setupIflyRecognizerView];

    
}

//初始化语音识别控件
-(void)setupIflyRecognizerView{
    
    //初始化语音识别控件
    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    _iflyRecognizerView.delegate = self;
    [_iflyRecognizerView setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path保存录音文件名,如不再需要,设置value为nil表示取消,默认目录是documents
    //设置结果数据格式，可设置为json，xml，plain，默认为json。
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
}

-(void)setupLocationManager{
    
    //定位
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 5.0;
    
}


-(void)CreatTopView
{
    //设置导航栏以及返回按钮
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    backBtn.backgroundColor = [UIColor redColor];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    //添加导航栏中间标签
    UILabel  *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    label.text = @"语音搜索";
    label.textColor = TITLECOLOR;
    label.font = TITLEFONT;
    [topView addSubview:label];
    [self.view addSubview:topView];
    
    //开始说话按钮
    startBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 360, 100 , 100)];
    CGPoint startBtnCenter = startBtn.center;
    startBtnCenter.x = self.view.bounds.size.width*0.5;
    startBtn.center = startBtnCenter;
    startBtn.layer.cornerRadius = 20;
    [startBtn setImage:[UIImage imageNamed:@"语音搜索-1_03"] forState:UIControlStateNormal];
    UILabel *labelStart = [[UILabel alloc]initWithFrame:CGRectMake(13,80, 80, 25)];
    labelStart.text = @"开始说话";
    labelStart.font = [UIFont systemFontOfSize:13.0];
    labelStart.textAlignment = NSTextAlignmentCenter;
    [startBtn addSubview:labelStart];
    startBtn.tag = 100;
    [self.view addSubview:startBtn];
    [startBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)setupGifView{
    
    _GifView = [OLImageView new];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"语音搜索-2" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:filePath];
    _GifView.image = [OLImage imageWithData:gifData];
    [_GifView setFrame:CGRectMake(28, 84, 264, 294)];
    _GifView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:_GifView];
    
}

#pragma mark btnClick----------

-(void)btnClick:(UIButton *)sender
{
    //添加gif图
    //[self setupGifView];
    
    //点击过后不能点击
    startBtn.enabled = NO;
    
    //开启语音识别
    [_iflyRecognizerView start];
    
}

-(void)pushController{
    
    if (_isPushController == YES) {
        
        //重新可以点击
        startBtn.enabled = YES;
        
        //爆菊花
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        
        //能否定位
        [self locationServicesIsAbled];
        
    }
    
}

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
    
    //发送搜索消息
    [[FDSUserCenterMessageManager sharedManager] searchIWantOrICan:_searchType keyWord:_searchStr latitude:latitude longitude:longitude];
    
    //统计语音搜索
    [MobClick event:@"home_speech_click"];
    
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    //去掉菊花
    [SVProgressHUD popActivity];

    double latitude = 0;
    double longitude = 0;
    
    //定位失败也要发送搜索消息
    [[FDSUserCenterMessageManager sharedManager] searchIWantOrICan:_searchType keyWord:_searchStr latitude:latitude longitude:longitude];
    
    //停止定位
    [_locationManager stopUpdatingLocation];
    
    //统计语音搜索
    [MobClick event:@"home_speech_click"];
    
    NSLog(@"%@",error);
    
}

//搜索回调
-(void)searchIWantOrICanCB:(NSDictionary *)dic
{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //创建搜索结果控制器
    voiceNexViewController* viewController = [[voiceNexViewController alloc]initWithNibName:nil bundle:nil];
    
    //两种搜索方式，导航栏标签是不一样的
    viewController.titleStr = @"搜索结果";
    
    //搜索类型
    viewController.searchType = _searchType;
    
    //返回的会员／应用／围墙／橱窗的数据都在这个字典里
    viewController.allModelsArr  = dic;
    
    //取得搜索词语，那边搜索交流厅
    viewController.searchWordTempGroup = _searchStr;
    
    //切换控制器
    [self.navigationController pushViewController:viewController animated:YES];
    
}

-(void)BackMainMenu:(UIButton *)sender
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app showTableBar];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*识别会话错误返回代理
 @ param error 错误码
 */
- (void)onError: (IFlySpeechError *) error {
    //提示框
    [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:[NSString stringWithFormat:@"%@",error.errorDesc]];
    startBtn.enabled = YES;
}
/*识别结果返回代理
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResult: (NSArray *)resultArray isLast:(BOOL) isLast {
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    
    if (result.length > 0) {
        
        _isPushController = YES;
        _searchStr = result;
        [self pushController];
    }

}

@end
