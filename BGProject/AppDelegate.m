//
//  AppDelegate.m
//  BGProject
//  test svn
//  Created by zhuozhong on 14-7-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//
#import "FirstViewController.h"
#import "PersonViewController.h"
#import "WeiQiangViewController.h"
#import "XuanNengViewController.h"
#import "LianXiViewController.h"
#import "MenCenterViewController.h"
#import "AppDelegate.h"
#import "UMSocial.h"
#import "EaseMob.h"
#import "constants.h"
#import "ZZSessionManager.h"
#import "FDSUserCenterMessageManager.h"
#import "FDSPublicMessageManager.h"
#import "FDSUserManager.h"
#import "FDSPathManager.h"
#import "FDSPushManager.h"
#import "DataBaseSimple.h"
#import "MoudleMessageManager.h"
#import "APService.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "NewFeatureViewController.h"
#import "SVProgressHUD.h"
#import "RelatedViewController.h"
#import "WeiQiangRelatedModel.h"
#import "XNRelatedViewController.h"
#import "XNRelatedModel.h"
#import "XuanNengMainMenueViewController.h"
#import "MobClick.h"
#import "UMSocialQQHandler.h"
#import "ZZUserDefaults.h"
#import "UMSocialSinaHandler.h"


//App Key：2552447950
//App Secret：05ee6ec0dfb52b43da1626d204f04532
//创建时间：2014-08-22
//应用地址：http://www.1000phone.com

#import "Test.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
#import "BGBadgeButton.h"
//tabBar高度
#define kToolBarHight 50

@implementation AppDelegate
{
    UITabBarController *_tabBarController;
    //tabBar
    UIView *_customeTabBarView;

    // 依次是 首页 个人中心 微墙 炫能 联系 的按钮
    UIButton *_button1;
    UIButton *_button2;
    //徽章按钮
    BGBadgeButton *_badgeButton;
    //当前是否在联系页面
    BOOL _isAppearContactVC;
    UIButton *_button3;
    UIButton *_button4;
    UIButton *_button5;
    
    CLGeocoder *_geocoder;
    
    // 个人中心
    UINavigationController *NavPerson;
    // 联系
    UINavigationController *NavLian;
    UINavigationController *NavWeiQiang;
    UINavigationController *NavXuan;
    BOOL _isLoad;
    
    //是否是推送的请求的数据，这个回调会一直在内存里面，其他页面的回调一概不接收
    BOOL _isPushWQNotification;
    
    CLLocationManager *_locationManager;
    
}
//静态全局变量
static UIColor *mainColor;

+(UIColor *)shareColor
{
    if (mainColor ==nil) {
    mainColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    }
 
    return mainColor;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}
-(void)showTableBar
{
    [UIView animateWithDuration:0.3 animations:^{

        if (DEVICE_IS_IPHONE5) {
            //如果是iPhone5，将Y值调整位518
            _customeTabBarView.frame = CGRectMake(0, 518, 320, 50);
        }
        else
        {
          //如果非iPhone5，将Y值调整位430
          _customeTabBarView.frame= CGRectMake(0, 430, 320, 50);
        }
        
    }];
}
-(void)hiddenTabelBar
{
    //把坐标下移了50，加上动画
    if (DEVICE_IS_IPHONE5)
    {
        [UIView animateWithDuration:0.3 animations:^{
      _customeTabBarView.frame = CGRectMake(0, 568, 320, 50);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            _customeTabBarView.frame = CGRectMake(0, 480, 320, 50);
        }];
    }
    
}
-(void)showTabelBar
{
    //把坐标下移了50，加上动画
    if (DEVICE_IS_IPHONE5)
    {
        [UIView animateWithDuration:0.3 animations:^{
            _customeTabBarView.frame = CGRectMake(0, 568-50, 320, 50);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            _customeTabBarView.frame = CGRectMake(0, 480-50, 320, 50);
        }];
    }
    
}

-(void)creatTabelbar
{
    //创建首页控制器
    FirstViewController *firstViewC = [[FirstViewController alloc]init];
    //创建首页导航控制器，并把firstViewC作为根控制器
    UINavigationController *NavFirst = [[UINavigationController alloc]initWithRootViewController:firstViewC];
    
    //创建微墙导航控制器并包一层导航控制器
    WeiQiangViewController *weiQiangViewC = [[WeiQiangViewController alloc]init];
    NavWeiQiang = [[UINavigationController alloc]initWithRootViewController:weiQiangViewC];
    
    //创建炫能导航控制器并把xuanViewC作为根控制器
    XuanNengViewController *xuanViewC = [[XuanNengViewController alloc]init];
    NavXuan = [[UINavigationController alloc]initWithRootViewController:xuanViewC];
    
    //登录前的注册页面
    PersonViewController *personmenCenterVC =[[PersonViewController alloc]init];
    //登录后的个人中心页面
    MenCenterViewController *menCenter = [[MenCenterViewController alloc]init];
    //联系的登录页面
    PersonViewController *personlianxiViewVC =[[PersonViewController alloc]init];

    //登录后的联系页面
    LianXiViewController *lianxiViewC = [[LianXiViewController alloc]init];
    
    
    // 无论是否加载 首先依次push进去普通页面和注册页面
    //先把menCenter压入栈底，再把personViewC登录页面压进去
    //害死了，同一个个人控制器加了两次，只能加在一个导航控制器
    NavPerson = [[UINavigationController alloc]initWithRootViewController:menCenter];
    [NavPerson pushViewController:personmenCenterVC animated:NO];
    
    NavLian = [[UINavigationController alloc ]initWithRootViewController:lianxiViewC];
    [NavLian pushViewController:personlianxiViewVC animated:NO];

    //初始化_tabBarController
    _tabBarController  =[[UITabBarController alloc]init];
    
    [self createCustomeTabBar];
    
    //把首页／联系／微墙／炫能／个人导航控制器添加到_tabBarController数组中管理
    _tabBarController.viewControllers = @[NavFirst,NavLian,NavWeiQiang,NavXuan,NavPerson];
    
    //取出沙盒中存储的上次使用软件的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"CFBundleVersion";
    NSString *lastVersion = [defaults stringForKey:key];
    
    //获取当前版本号
    NSString *currentVersion =  [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    
    if ([currentVersion isEqualToString:lastVersion]) {
        
        
        //将_tabBarController设为窗口的根控制器
        self.window.rootViewController  = _tabBarController;
        
    } else { // 新版本
        
        self.window.rootViewController  = [[NewFeatureViewController alloc] init];
        self.tempTabBarController = _tabBarController;
        
        // 存储新版本
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
    }
    
}


//创建tablebar
- (void)createCustomeTabBar
{
    //将自带的tabBar隐藏起来
    _tabBarController.tabBar.hidden  = YES;
    
    //取得屏幕宽高
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    //设置_customeTabBarView的frame
    CGFloat x = 0;
    CGFloat y = screenFrame.size.height - kToolBarHight;
    CGFloat w = screenFrame.size.width;
    CGFloat h = kToolBarHight;
    CGRect tabBarViewFrame = (CGRect){{x,y},{w,h}};
    //初始化tabBar
    _customeTabBarView = [[UIView alloc]initWithFrame:tabBarViewFrame];
    //设置tabBar自适应，一直粘在屏幕父视图底部
    _customeTabBarView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;

    //首页，背景图片／图标／文字／tag
    _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button1.frame = CGRectMake(0, 0, BTNJIANGE, BTNHIGHT);
    [_button1 setBackgroundImage:[UIImage imageNamed:@"tab底部"]forState:UIControlStateNormal];
    [_button1 setBackgroundImage:[UIImage imageNamed:@"background_08"]forState:UIControlStateSelected];
    [_button1 setTitle:@"首页" forState:UIControlStateNormal];
    [_button1 setImage:[UIImage imageNamed:@"nomal_03"] forState:UIControlStateNormal];
    [_button1 setImage:[UIImage imageNamed:@"选中_03"] forState:UIControlStateSelected];
    _button1.imageEdgeInsets = UIEdgeInsetsMake(5, 22, 23, 21);
    _button1.titleEdgeInsets = UIEdgeInsetsMake(27,-40, 3, 0);
    _button1.titleLabel.font = [UIFont systemFontOfSize:12];
    _button1.tag = 0;
    [_button1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor whiteColor ] forState:UIControlStateSelected];
    _button1.selected = YES;
    [_customeTabBarView addSubview:_button1];
    

    //我
    _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button2 setBackgroundImage:[UIImage imageNamed:@"tab底部"]forState:UIControlStateNormal];
    [_button2 setBackgroundImage:[UIImage imageNamed:@"background_08"]forState:UIControlStateSelected];
    [_button2 setImage:[UIImage imageNamed:@"nomal_11"] forState:UIControlStateNormal];
    [_button2 setImage:[UIImage imageNamed:@"选中_11"] forState:UIControlStateSelected];
    [_button2 setTitle:@"联系" forState:UIControlStateNormal];
    _button2.frame = CGRectMake(BTNJIANGE, 0, BTNJIANGE, BTNHIGHT);
    _button2.imageEdgeInsets = UIEdgeInsetsMake(5, 22, 23, 21);
    _button2.titleEdgeInsets = UIEdgeInsetsMake(27,-40, 3, 0);
    _button2.titleLabel.font = [UIFont systemFontOfSize:12];
    _button2.tag = 1;
    [_button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_button2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_customeTabBarView addSubview:_button2];
    
    _badgeButton = [[BGBadgeButton alloc] init];
    _badgeButton.frame = CGRectMake(105, 0, 10, 10);
    [_customeTabBarView addSubview:_badgeButton];
    
    // 微墙
    _button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button3 setImage:[UIImage imageNamed:@"nomal_07"] forState:UIControlStateNormal];
    [_button3 setImage:[UIImage imageNamed:@"选中_07"] forState:UIControlStateSelected];
    [_button3 setTitle:@"微墙" forState:UIControlStateNormal];
    _button3.frame = CGRectMake(2*BTNJIANGE,0,BTNJIANGE, BTNHIGHT);
    _button3.imageEdgeInsets = UIEdgeInsetsMake(5, 22, 23, 21);
    _button3.titleEdgeInsets = UIEdgeInsetsMake(27,-40, 3, 0);
    _button3.tag = 2;
    _button3.titleLabel.font = [UIFont systemFontOfSize:12];
    [_button3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_button3 setBackgroundImage:[UIImage imageNamed:@"tab底部"]forState:UIControlStateNormal];
    [_button3 setBackgroundImage:[UIImage imageNamed:@"background_08"]forState:UIControlStateSelected];
    [_button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button3 setTitleColor:[UIColor whiteColor ] forState:UIControlStateSelected];
     [_customeTabBarView addSubview:_button3];
    
    //炫能
    _button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button4 setImage:[UIImage imageNamed:@"nomal_09"] forState:UIControlStateNormal];
    [_button4 setImage:[UIImage imageNamed:@"选中_09"] forState:UIControlStateSelected];
    [_button4 setTitle:@"炫能" forState:UIControlStateNormal];
    _button4.frame = CGRectMake(3*BTNJIANGE, 0, BTNJIANGE, BTNHIGHT);
    _button4.imageEdgeInsets = UIEdgeInsetsMake(5, 22, 23, 21);
    _button4.titleEdgeInsets = UIEdgeInsetsMake(27,-40, 3, 0);
    _button4.tag = 3;
    _button4.titleLabel.font = [UIFont systemFontOfSize:12];
    [_button4 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_button4 setBackgroundImage:[UIImage imageNamed:@"tab底部"]forState:UIControlStateNormal];
    [_button4 setBackgroundImage:[UIImage imageNamed:@"background_08"]forState:UIControlStateSelected];
    [_button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button4 setTitleColor:[UIColor whiteColor ] forState:UIControlStateSelected];
    [_customeTabBarView addSubview:_button4];
    
    
    // 联系
    _button5 = [UIButton buttonWithType:UIButtonTypeCustom];

    [_button5 setImage:[UIImage imageNamed:@"nomal_05"] forState:UIControlStateNormal];
    [_button5 setImage:[UIImage imageNamed:@"选中_05"] forState:UIControlStateSelected];
    [_button5 setTitle:@"我" forState:UIControlStateNormal];

    _button5.frame = CGRectMake(4*BTNJIANGE, 0, BTNJIANGE, BTNHIGHT);
    _button5.imageEdgeInsets = UIEdgeInsetsMake(5, 22, 23, 21);
    _button5.titleEdgeInsets = UIEdgeInsetsMake(27,-40, 3, 0);
    _button5.tag = 4;
    [_button5 setBackgroundImage:[UIImage imageNamed:@"tab底部"]forState:UIControlStateNormal];
    [_button5 setBackgroundImage:[UIImage imageNamed:@"background_08"]forState:UIControlStateSelected];
    [_button5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button5 setTitleColor:[UIColor whiteColor ] forState:UIControlStateSelected];
    _button5.titleLabel.font = [UIFont systemFontOfSize:12];
    [_button5 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_customeTabBarView addSubview:_button5];
    
    [_tabBarController.view addSubview:_customeTabBarView];
    
    
}

- (void)btnClick:(UIButton *)sender
{
    
    if (sender.tag==0) {
        
        //统计首页点击
        [MobClick event:@"home_click"];
        
    }else if (sender.tag==1){
        
        //统计联系点击
        [MobClick event:@"chat_click"];
        
    }else if (sender.tag==2){
        
        
        
    }
    
    //先把控制器挪到被选中的导航控制器
    _tabBarController.selectedIndex = sender.tag;
    
    //通过设置选中状态来控制图片／文字的切换
    _button1.selected =  NO;
    _button2.selected =  NO;
    _button3.selected =  NO;
    _button4.selected =  NO;
    _button5.selected =  NO;
    sender.selected = YES;
    
    if (sender.tag==1) {
        
        _isAppearContactVC = YES;
        _badgeButton.hidden = YES;
        
    }else{
        
        _isAppearContactVC = NO;
        
    }
    
    if(sender.tag==1 || sender.tag== 4) {
        // 判断并删除其中存在的 登录注册页面
        FDSUserManager* userManager = [FDSUserManager sharedManager];
        
        if([userManager getNowUserState]==USERSTATE_LOGIN)   {
          
            // 可以优化成只执行一次
            //取出1或者4对应的导航控制器
            UINavigationController* navi = _tabBarController.viewControllers[sender.tag];
            
            //取出导航控制器中viewControllers
            NSArray* viewControllers = navi.viewControllers;
            NSMutableArray* newViewControllers = [NSMutableArray array];
            
            //遍历数组
            for(int i=0; i<[viewControllers count]; i++) {
                UIViewController* controller = viewControllers[i];
                if([controller isKindOfClass:[PersonViewController class]]) {
                    // 不添加到新的控制器组中，啥也不干
                    
                } else {
                    [newViewControllers addObject:controller];
                }
            }
            
            // 更新最新的控制器viewControllers
            navi.viewControllers = newViewControllers;
        }
    }
}

//系统方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //SDK方法调用
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册推送失败"
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}



//系统方法（本地通知接收函数）
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //SDK方法调用
    [[EaseMob sharedInstance] application:application didReceiveLocalNotification:notification];
    
    [self pushToMessageListOfContactVC];
}

//跳转到消息列表
-(void)pushToMessageListOfContactVC{
    
    for(id<PlateformMessageInterface> interface in [PlatformMessageManager sharedManager].observerArray)
    {
        if ([interface isKindOfClass:[LianXiViewController class]]) {
            
            LianXiViewController *Lx = (LianXiViewController *)interface;
            
            [Lx isPushChatNotification];
        }
    }
    [self btnClick:_button2];
    
}

//跳转到微墙与我相关
-(void)pushToXuanNengRelatedToMe{
    
    //点击微墙按钮
    [self btnClick:_button4];
    
    //将控制器推到根控制器，确保在各个页面都能去到与我相关那里
    [NavXuan popToRootViewControllerAnimated:NO];
    
    //去到炫能排行页面
    XuanNengMainMenueViewController *xuan =[[XuanNengMainMenueViewController  alloc]init];
    [NavXuan pushViewController:xuan animated:NO];
    
    //发送获取与我相关消息（从新开始请求数据)
    //XuanNengMainMenueViewController 已经存在回调了，就不需要在这边回调了，发送请求即可
    [[MoudleMessageManager sharedManager] beRelatedToMeXuanNengWithStart:0 end:kRequestCount];
    
}

//跳转到微墙与我相关
-(void)pushToWeiQiangRelatedToMe{
    
    //修改布尔值
    _isPushWQNotification = YES;
    
    //点击微墙按钮
    [self btnClick:_button3];
    
    //将控制器推到根控制器，确保在各个页面都能去到与我相关那里
    [NavWeiQiang popToRootViewControllerAnimated:NO];

    //发送获取与我相关消息（从新开始请求数据）
    [[MoudleMessageManager sharedManager] beRelatedToMeWithStart:0 end:kRequestCount];
    
}

//微墙与我相关回调
-(void)beRelatedToMeCB:(NSArray *)result{
    
    if (_isPushWQNotification) {
        
        RelatedViewController *rv = [[RelatedViewController alloc] init];
        
        for (WeiQiangRelatedModel *model in result) {
            
            [rv.dataArray  addObject:model];
            
        }
        
        [NavWeiQiang pushViewController:rv animated:NO];
        
    }else{
        
        //推送完了，改回来
        _isPushWQNotification = NO;
        
        return;
        
    }

    
}

//自定义方法
- (void)registerRemoteNotification
{
#if !TARGET_IPHONE_SIMULATOR
    UIApplication *application = [UIApplication sharedApplication];
    
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
#endif
}

#pragma mark-网络状态实时监听

-(void)reachabilityChanged: (NSNotification* )note

{
    
    Reachability* curReach = [note object];
    
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    NetworkStatus status = [curReach currentReachabilityStatus];

    if(status == kReachableViaWWAN)
    {
        [self login];
    }
    else if(status == kReachableViaWiFi)
    {
        [self login];
    }else{
        
    }
    
    
}

//如果有网络但是还没登录就登录
-(void)login{
    
    //如果有网络但是还没有登录的话就登录
    if ([[FDSUserManager sharedManager] getNowUserState]!=USERSTATE_LOGIN) {
        
        //取出上次登录的用户和密码
        NSString *userCount = [ZZUserDefaults getUserDefault:USER_COUNT];
        NSString *password = [ZZUserDefaults getUserDefault:USER_PASSWORD];
        
        //发送登录消息
        [[FDSUserCenterMessageManager sharedManager] userLogin:userCount :password];
        
    } ;
    
}

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    //1.初始化一组单例
    [self systemInit];
    
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
#pragma mark-更新定位(每5min上传一次位置)
    
    [self locationServicesIsAbled];
    [NSTimer scheduledTimerWithTimeInterval:1.0f*60*5 target:self selector:@selector(locationServicesIsAbled) userInfo:nil repeats:NO];
    
    //注册通知(设置联系徽章)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshContactBadgeCount:)
                                                 name:SetupContactBadgeCountKey object:nil];
    
    //设置徽章为0
    [application setApplicationIconBadgeNumber:0];
    
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self
                                        delegateQueue:nil];

#pragma mark-友盟分享集成
    //54f6d2a1fd98c5d705000132
    [UMSocialData setAppKey:@"54f6d2a1fd98c5d705000132"];
    
    //[UMSocialConfig showAllPlatform:YES];
    
    //新浪微博
//    App Key：2552447950
//    App Secret：05ee6ec0dfb52b43da1626d204f04532
//    创建时间：2014-08-22
//    应用地址：http://www.1000phone.com
    
    //微信
    [UMSocialWechatHandler setWXAppId:@"wx8fd7339391e0d06a" appSecret:@"a6cfc6406d9c31305c882f77b8aead65" url:@"http://www.showneng.com"];
    
    
    //qq空间
    [UMSocialQQHandler setQQWithAppId:@"1104200467" appKey:@"FecuY1h9fM7kTxZN" url:@"http://www.showneng.com"];
    
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://www.showneng.com"];
    
    [UMSocialData openLog:YES];
    
    
#pragma mark-友盟统计集成
    
    //设置appkey
    [MobClick startWithAppkey:@"54f6d2a1fd98c5d705000132" reportPolicy:BATCH   channelId:@""];
    
    //设置版本标识
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    //打开程序
    [MobClick event:@"sys_start"];
    
    //2.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //3.一个tabBar
    [self creatTabelbar];

    self.window.backgroundColor = [UIColor whiteColor];
    //4.获取用户的登录状态
    [self initSetting];
    
#pragma mark-注册代理
    [[MoudleMessageManager sharedManager]
     registerObserver:self];
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
    
#pragma mark-讯飞语音集成
    //将“12345678”替换成您申请的APPID,申请地址:http://open.voicecloud.cn
    NSString *initString = [NSString stringWithFormat:@"appid=%@",@"54ba40ae"];
    [IFlySpeechUtility createUtility:initString];

    
#pragma mark-环信(IM)
    // 真机的情况下,notification提醒设置
    UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
    UIRemoteNotificationTypeSound |
    UIRemoteNotificationTypeAlert;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    
    //注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    NSString *apnsCertName = @"BangGuHuanXinPush";
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"banggood#shownengapp" apnsCertName:apnsCertName];
    [[EaseMob sharedInstance] enableBackgroundReceiveMessage];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    
#pragma mark-极光推送
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required 初始化推送
    [APService setupWithOption:launchOptions];
    
    
    //取出本地通知
    UILocalNotification *localNoti = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (localNoti) {
        
        NSLog(@"localNoti空");
        
       [self pushToMessageListOfContactVC];
        
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

//提交别名回调
//- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
//    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
//}

//上传token到服务器
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    // Required
    [APService registerDeviceToken:deviceToken];
    
    
    //SDK方法调用
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    //程序进入后台
    self.isAppActive = NO;
    
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
    
    [FDSUserManager sharedManager].isApplicationBackGround = YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    
    //设置徽章为0
    [application setApplicationIconBadgeNumber:0];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    //程序进入前台
    self.isAppActive = YES;
    
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
    
    [FDSUserManager sharedManager].isApplicationBackGround = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}



//ios8收到推送消息，上报服务器收到消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    NSLog(@"this is iOS8 Remote Notification,content:%@,badge:%ld,sound:%@",content,badge,sound);
    
    //取出是那个推送过来的（targettype微墙－0，炫能－1）
    NSString *targettype = [userInfo valueForKey:@"targettype"];
    
    if ([targettype intValue]==0) {
        
        [self pushToWeiQiangRelatedToMe];
        
    }else{
        
        [self pushToXuanNengRelatedToMe];
        
    }
    
    // Required
    [APService handleRemoteNotification:userInfo];
    
    //SDK方法调用
    [[EaseMob sharedInstance] application:application didReceiveRemoteNotification:userInfo];
    
}

//这是干嘛用的？iOS7要用到这个？
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    //如果程序在前台，不推与我相关控制器
    if (self.isAppActive) {
        
        return;
        
    }
    
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    //取出是那个推送过来的（targettype微墙－0，炫能－1）
    NSString *targettype = [userInfo valueForKey:@"targettype"];
    
    if ([targettype intValue]==0) {
        
        [self pushToWeiQiangRelatedToMe];
        
    }else{
        
        [self pushToXuanNengRelatedToMe];
        
    }
    
    NSLog(@"this is iOS7 Remote Notification,content:%@,badge:%ld,sound:%@",content,badge,sound);
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

// 强制竖屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    // UIInterfaceOrientationMaskPortrait
    return UIInterfaceOrientationMaskPortrait;
}

-(void)isONload:(BOOL)isONload {
    _isONload = isONload;
    if(isONload) {
        [self updateOnLoadStateWithUsername:@"noName"];
    } else {
        [self updateOnLoadStateWithUsername:nil];
    }

}

// 程序启动的时候,初始化已有设置。
-(void)initSetting {
    // 获取用户登录状态 PS:这个登录状态是在什么时候存进去的？？？
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString* loginName = [userDefault objectForKey:kUserName];
    //如果loginName的长度>0,说明已经登录，将isONload改位YES
    if(loginName.length > 0) {
        self.isONload = YES;
    } else {
        self.isONload = NO;
    }
    
    
}

// 更新应用的登录状态
-(void)updateOnLoadStateWithUsername:(NSString*)userName {
    
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    if(userName!=nil) {
        [userDefault setObject:userName forKey:kUserName];
        [userDefault synchronize];
    } else {
        [userDefault removeObjectForKey:kUserName];
    }
}


/*  system start */
//将一群单例初始化，单例初始化过程干了什么还不清楚？
-(void)systemInit
{
    [ZZSessionManager sharedSessionManager];
    
    
    [FDSUserCenterMessageManager sharedManager];//用户消息模块初始化
    
    [MoudleMessageManager sharedManager];

    
    [FDSPublicMessageManager sharedManager];
    [FDSUserManager sharedManager ];// 用户管理器初始化
    
    [FDSPathManager sharePathManager];
    [FDSPushManager sharePushManager];
    
    [FDSUserManager sharedManager];
    
    //数据库
    [DataBaseSimple shareInstance];
    
    //初始化定位
    [self setupLlocationManager];
    
}


//判断用户是否已经登录
-(BOOL)isUserlogin {
    
    FDSUserManager* manager = [FDSUserManager sharedManager];
    
    if([manager getNowUserState] == USERSTATE_LOGIN) {
        return YES;
    }
    
    return NO;
}


- (void)userLogoutCB:(NSString*)result {
    
    PersonViewController *personViewC =[[PersonViewController alloc]init];
    
    [NavPerson popToRootViewControllerAnimated:NO];
    [NavPerson pushViewController:personViewC animated:NO];
    
    [NavLian popToRootViewControllerAnimated:NO];
    [NavLian pushViewController:personViewC animated:NO];
}

#pragma mark-环信重连
- (void)willAutoReconnect{
    
    [SVProgressHUD showWithStatus:@"正在重连……" maskType:SVProgressHUDMaskTypeBlack];
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
   
    if (!error) {
        
        [SVProgressHUD showSuccessWithStatus:@"重连成功"];
        
    }else{
    
        [SVProgressHUD showSuccessWithStatus:@"重连失败"];
        
    }
    
    
}

//设置联系徽章
-(void)refreshContactBadgeCount:(NSNotification *)noti{
    
    _badgeButton.badgeValue = (NSString *)noti.object;
    
    if (_isAppearContactVC) {
        
        _badgeButton.hidden = YES;
        
    }else{
        
        if ([_badgeButton.badgeValue intValue]==0) {
            
            _badgeButton.hidden = YES;
            
        }else{
            
            _badgeButton.hidden = NO;
            
        }
        
    }
    
}

#pragma mark-CLLocationManagerDelegate

//初始化定位
-(void)setupLlocationManager{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    //精度
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //每隔5米更新一次定位
    _locationManager.distanceFilter = 5.0;
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
            
            [[FDSPublicManage sharePublicManager] showInfo:[UIApplication sharedApplication].keyWindow MESSAGE:@"定位失败"];
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

//存起来获取微墙或者获取炫能的时候用
-(void)saveLocationWithLatitude:(double)latitude longitude:(double)longitude{
    
    [ZZUserDefaults setDefaultWithObject:[NSNumber numberWithDouble:latitude] forkey:LatitudeKey];
    [ZZUserDefaults setDefaultWithObject:[NSNumber numberWithDouble:longitude] forkey:LongitudeKey];

    
}

//定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    //取出经纬度
    double latitude = newLocation.coordinate.latitude;
    double longitude = newLocation.coordinate.longitude;
    
    //存起来获取微墙或者获取炫能的时候用
    [self saveLocationWithLatitude:latitude longitude:longitude];
    
    //停止定位
    [_locationManager stopUpdatingLocation];
    
    //发送经纬度到服务器
    [[FDSUserCenterMessageManager sharedManager] updateLocationWithLongitude:longitude latitude:latitude];
    
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    //停止定位
    [_locationManager stopUpdatingLocation];
    
    
    
}

@end
