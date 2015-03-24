//
//  FirstViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FirstViewController.h"
//#import "KxMenu.h"
#import "SearchViewController.h"
#import "MYVoiceViewController.h"
#import "AppDelegate.h"
#import "FDSUserCenterMessageManager.h"
#import "voiceNexViewController.h"
#import "SVProgressHUD.h"

#define  UIScreenH  [UIScreen mainScreen].bounds.size.height
#define searchHotWordINeed @"ineed"
#define searchHotWordICan @"ican"
#define selectedColor [UIColor colorWithRed:229/255.0 green:100/255.0 blue:71/255.0 alpha:1.0]
#define kToolBarHight 50

@interface FirstViewController ()<UserCenterMessageInterface>{
    __weak UIImageView *_blueBuble;
    __weak UIImageView *_orangeBuble;
    __weak UIImageView *_redBuble;
    __weak UIImageView *_ICanPurple;
    __weak UIImageView *_ICanBlue;
    __weak UIImageView *_ICanorange;
    __weak UIImageView *_ICanRed;
    __weak UIImageView *_purpleBuble;
    __weak UIView *_ICanBg;
    __weak UILabel *_icanRedLab;
    __weak UILabel *_icanBlueLab;
    __weak UILabel *_icanPurpleLab;
    __weak UILabel *_icanOrangeLab;
    
    SearchType _searchType;
    NSString *_voiceStr;
    NSString *_searchWordTempGroup;
    NSTimer *_timer;
    
}
@property(weak,nonatomic) FDSUserCenterMessageManager* userCenterMessageManager;

@end

@implementation FirstViewController

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
    
    [MobClick beginLogPageView:@"首页"];
    
    //开启定时器
    [_timer setFireDate:[NSDate distantPast]];
    
    
    //1.再将要出现的时候将导航栏隐藏起来
    self.navigationController.navigationBarHidden = YES;
    
    //2.取得程序代理对象
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    //3.根据屏幕大小调整 tabBar调整 tabBar的Y值，但是个函数可以不执行，前面自定义,tabBar的时候已经是动态调整坐标
    [app showTableBar];
    
    //先将弹出框隐藏起来
    tanChuView.hidden = YES;
    
    //注册代理
    [_userCenterMessageManager registerObserver:self];
    
    //请求空闲服务器地址回调
    [_userCenterMessageManager requestLeisureBusinessServerAddress];
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    
    //关闭定时器
    [_timer setFireDate:[NSDate distantFuture]];
    
    //在他要消失的时候将它移除出数组
    [_userCenterMessageManager unRegisterObserver:self];
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"首页"];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建消息管理中心单例
    _userCenterMessageManager = [FDSUserCenterMessageManager sharedManager];
    
    //初始化搜索框／我想／我能按钮
    [self creatbtton];
    
    //添加我能以及我想的动漫图片以及上面的各种button
    [self CreatView];
    
    //设置弹出框以及上面的我想我能按钮
    [self CreatTanChuKuang];
    

}


#pragma mark CREATBTN====================
-(void)creatbtton
{
    //顶部背景View
    topView = [[UIView alloc]initWithFrame:CGRectMake(10, 30, 300, 30)];
    //设置圆角／边框大小／颜色
    topView.layer.cornerRadius = 5;
    topView.layer.borderWidth = 0.5;
    topView.layer.borderColor = [UIColor redColor].CGColor;
    
    //设置左边按钮
    TopLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    TopLeftButton.frame = CGRectMake(2, 0, 50, 30);
    [TopLeftButton setTitle:@"我想" forState:UIControlStateNormal];
    [TopLeftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    TopLeftButton.contentMode =UIViewContentModeScaleAspectFit;
    TopLeftButton.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 10);
    [TopLeftButton addTarget:self action:@selector(WoXiangWoNeng:) forControlEvents:UIControlEventTouchUpInside];
    TopLeftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //按钮里面的图片,ps：不是里面的图片只是直接加再背景上面去的
    imageView1 =[[UIImageView alloc]initWithFrame:CGRectMake(40, 10, 10, 10)];
    imageView1.image =[UIImage imageNamed:@"首頁我能_08"];
    
    // 分割线
    imgView1 =[[UIImageView alloc]initWithFrame:CGRectMake(TopLeftButton.frame.origin.x+TopLeftButton.frame.size.width+2, TopLeftButton.frame.origin.y, 0.5, TopLeftButton.frame.size.height)];
    imgView1.image =[UIImage imageNamed:@"首頁我能_03"];
    
    
     //中间按钮
    TopMiddleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    TopMiddleButton.frame = CGRectMake(imgView1.frame.origin.x+imgView1.frame.size.width, imgView1.frame.origin.y, 200, 30);
    [TopMiddleButton setTitle:@"动词加名词；例如：“打篮球”" forState:UIControlStateNormal];
    TopMiddleButton.titleLabel.font  = [UIFont systemFontOfSize:14];
    [TopMiddleButton addTarget:self action:@selector(MySearch) forControlEvents:UIControlEventTouchUpInside];
    [TopMiddleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    //分割线
    imgView2 =[[UIImageView alloc]initWithFrame:CGRectMake(TopMiddleButton.frame.origin.x+TopMiddleButton.frame.size.width+2, TopMiddleButton.frame.origin.y, 0.5, TopMiddleButton.frame.size.height)];
    imgView2.image =[UIImage imageNamed:@"首頁我能_03"];
   

    //语音搜索按钮
    TopRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    TopRightButton.frame = CGRectMake(imgView2.frame.origin.x+imgView2.frame.size.width, imgView2.frame.origin.y,50, 30);
    [TopRightButton addTarget:self action:@selector(MyVoiceSearch) forControlEvents:UIControlEventTouchUpInside];
    //按钮里面的图片
    imageView2 =[[UIImageView alloc]initWithFrame:CGRectMake(15, 8, 10.5, 16)];
    imageView2.image =[UIImage imageNamed:@"首頁我能_05"];
    
    //我想按钮
    thinkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    thinkBtn.frame = CGRectMake(topView.frame.origin.x, topView.frame.origin.y+topView.frame.size.height+20, 150, 30);
    [thinkBtn setTitle:@"我想" forState:UIControlStateNormal];
    [thinkBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    thinkBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [thinkBtn addTarget:self action:@selector(ThinkPage:) forControlEvents:UIControlEventTouchUpInside];
    
    //我能按钮
    canBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    canBtn.frame = CGRectMake(thinkBtn.frame.origin.x+thinkBtn.frame.size.width,thinkBtn.frame.origin.y, 150, 30);
    [canBtn setTitle:@"我能" forState:UIControlStateNormal];
    [canBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    canBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [canBtn addTarget:self action:@selector(CanPage:) forControlEvents:UIControlEventTouchUpInside];
   
    
    //底部View(就是底部灰色那条线)
    BootView = [[UIView alloc]initWithFrame:CGRectMake(10, thinkBtn.frame.origin.y+thinkBtn.frame.size.height+5, 300, 0.5)];
    [BootView setBackgroundColor:[UIColor grayColor]];
    
    //滑动的View（覆盖再灰色线条上面）
    MoveView = [[UIView alloc]initWithFrame:CGRectMake(0,0, 150, 2)];
    [MoveView setBackgroundColor:[UIColor blueColor]];
    
    //加入父试图 顶部
    [TopLeftButton  addSubview:imageView1];
    [topView        addSubview:TopLeftButton];
    [topView        addSubview:imgView1];
    [topView        addSubview:TopMiddleButton];
    [topView        addSubview:imgView2];
    [topView        addSubview:TopRightButton];
    [TopRightButton addSubview:imageView2];
    [self.view      addSubview:topView];
    
    //中间的
    [self.view addSubview:thinkBtn];
    [self.view addSubview:canBtn];
    [self.view addSubview:BootView];
    [BootView  addSubview:MoveView];

}

-(void)CreatTanChuKuang
{
    //弹出框的背景图片，泡泡
    tanChuView = [[UIImageView alloc]initWithFrame:CGRectMake(11, topView.frame.origin.y+topView.frame.size.height, 120, 93)];
    tanChuView.userInteractionEnabled = YES;
    tanChuView.image = [UIImage imageNamed:@"首頁我能_14"];
    tanChuView.contentMode = UIViewContentModeScaleAspectFit;

    //泡泡－我想按钮
    btnChageBig1 = [[UIButton alloc]initWithFrame:CGRectMake(5, 8, 110, 40)];
    btnChageBig1.selected = YES;
    [btnChageBig1 addTarget:self action:@selector(IWant:) forControlEvents:UIControlEventTouchUpInside];
    [btnChageBig1 setTitle:@"我想" forState:UIControlStateNormal];
    [btnChageBig1 setImage:[UIImage imageNamed:@"firstPage_search"] forState:UIControlStateNormal];
    [btnChageBig1 setImage:[UIImage imageNamed:@"firstPage_search_highlighted"] forState:UIControlStateSelected];
    [btnChageBig1 setTitleColor:selectedColor forState:UIControlStateSelected];
    btnChageBig1.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 70);
    btnChageBig1.titleEdgeInsets = UIEdgeInsetsMake(5, -10, 5, 0);
    [btnChageBig1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnChageBig1.titleLabel.font = [UIFont systemFontOfSize:14];

 
    //泡泡－我能按钮
    btnChageBig2 = [[UIButton alloc]initWithFrame:CGRectMake(5, btnChageBig1.frame.origin.y+btnChageBig1.frame.size.height, 110, 40)];
    [btnChageBig2 addTarget:self action:@selector(MyCan:) forControlEvents:UIControlEventTouchUpInside];
    [btnChageBig2 setImage:[UIImage imageNamed:@"firstPage_search"] forState:UIControlStateNormal];
    [btnChageBig2 setImage:[UIImage imageNamed:@"firstPage_search_highlighted"] forState:UIControlStateSelected];
    [btnChageBig2 setTitle:@"我能" forState:UIControlStateNormal];
    [btnChageBig2 setTitleColor:selectedColor forState:UIControlStateSelected];
    btnChageBig2.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 70);
    btnChageBig2.titleEdgeInsets = UIEdgeInsetsMake(5, -10, 5, 0);
    [btnChageBig2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnChageBig2.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [tanChuView addSubview:btnChageBig1];
    [tanChuView addSubview:btnChageBig2];
    [self.view addSubview:tanChuView];
    
    
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHidden:)];
    [self.view addGestureRecognizer:tap];

    
}
#pragma mark CREAT VIEW

-(void)CreatView
{
#pragma mark-创建我能视图
    //设置我能背景视图
    UIView *ICanBg = [[UIView alloc] init];
    CGFloat ICanBgX = 0;
    CGFloat ICanBgY = 125.5;
    CGFloat ICanBgW = self.view.bounds.size.width;
    CGFloat ICanBgH = self.view.bounds.size.height-ICanBgY-kToolBarHight;
    ICanBg.frame = CGRectMake(ICanBgX, ICanBgY, ICanBgW, ICanBgH);
    ICanBg.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    ICanBg.hidden = YES;
    [self.view addSubview:ICanBg];
    _ICanBg = ICanBg;
    
    
    //设置我能小人图片
    MyCanView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"my_can_man"]];
    CGFloat MyCanViewW = MyCanView.image.size.width;
    CGFloat MyCanViewX = (ICanBg.frame.size.width-MyCanViewW)*0.5;
    CGFloat MyCanViewH = MyCanView.image.size.height;
    CGFloat MyCanViewY = 0;
    
    
    //取出背景视图中点6
    CGPoint ICanBgCenter = _ICanBg.center;
    
    //区分设备
    if (kScreenHeight>=568) {
       MyCanViewY = ICanBgCenter.y-170;
    }else{
        
       MyCanViewY = ICanBgCenter.y-210;
    }
    
    MyCanView.frame = CGRectMake(MyCanViewX, MyCanViewY, MyCanViewW, MyCanViewH);
    //先把它隐藏起来
    MyCanView.contentMode = UIViewContentModeScaleAspectFit;
    MyCanView.userInteractionEnabled = YES;
    [ICanBg addSubview:MyCanView];
    
    //开启定时器
    [self startTimer];
    
    
    //我能紫色气泡
    UIImageView *ICanPurple = [[UIImageView alloc] init];
    ICanPurple.userInteractionEnabled = YES;
    ICanPurple.image = [UIImage imageNamed:@"ican_purple"];
    CGFloat ICanPurpleX = 25;
    CGFloat ICanPurpleY = MyCanView.frame.origin.y+60;
    CGFloat ICanPurpleW = ICanPurple.image.size.width;
    CGFloat ICanPurpleH = ICanPurple.image.size.height;
    ICanPurple.frame = CGRectMake(ICanPurpleX, ICanPurpleY, ICanPurpleW, ICanPurpleH);
    [ICanBg addSubview:ICanPurple];
    _ICanPurple = ICanPurple;
    //标签
    UILabel *icanPurpleLab = [[UILabel alloc] init];
    icanPurpleLab.userInteractionEnabled  =YES;
    CGFloat icanPurpleLabW = 60;
    CGFloat icanPurpleLabX = 5;
    CGFloat icanPurpleLabY = 15;
    CGFloat icanPurpleLabH = 20;
    icanPurpleLab.frame = CGRectMake(icanPurpleLabX, icanPurpleLabY, icanPurpleLabW, icanPurpleLabH);
    icanPurpleLab.text = @"教街舞";
    icanPurpleLab.textAlignment = NSTextAlignmentCenter;
    icanPurpleLab.textColor = [UIColor colorWithRed:192/255.0 green:125/255.0 blue:224/255.0 alpha:1.0];
    icanPurpleLab.adjustsFontSizeToFitWidth = YES;
    UITapGestureRecognizer *purpleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick:)];
    [icanPurpleLab addGestureRecognizer:purpleTap];
    [ICanPurple addSubview:icanPurpleLab];
    _icanPurpleLab = icanPurpleLab;
    
    //我能橙色气泡
    UIImageView *ICanOrange = [[UIImageView alloc] init];
    ICanOrange.userInteractionEnabled = YES;
    ICanOrange.image = [UIImage imageNamed:@"ican_orange"];
    CGFloat ICanOrangeX = 60;
    CGFloat ICanOrangeY = MyCanView.frame.origin.y-60;
    CGFloat ICanOrangeW = ICanOrange.image.size.width;
    CGFloat ICanOrangeH = ICanOrange.image.size.height;
    ICanOrange.frame = CGRectMake(ICanOrangeX, ICanOrangeY, ICanOrangeW, ICanOrangeH);
    [ICanBg addSubview:ICanOrange];
    _ICanorange = ICanOrange;
    //标签
    UILabel *ICanOrangeLab = [[UILabel alloc] init];
    ICanOrangeLab.userInteractionEnabled  =YES;
    CGFloat ICanOrangeLabW = 60;
    CGFloat ICanOrangeLabX = 5;
    CGFloat ICanOrangeLabY = 15;
    CGFloat ICanOrangeLabH = 20;
    ICanOrangeLab.frame = CGRectMake(ICanOrangeLabX, ICanOrangeLabY, ICanOrangeLabW, ICanOrangeLabH);
    ICanOrangeLab.text = @"教小提琴";
    ICanOrangeLab.textAlignment = NSTextAlignmentCenter;
    ICanOrangeLab.textColor = [UIColor colorWithRed:228/255.0 green:135/255.0 blue:107/255.0 alpha:1.0];
    UITapGestureRecognizer *orangeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick:)];
    [ICanOrangeLab addGestureRecognizer:orangeTap];
    ICanOrangeLab.adjustsFontSizeToFitWidth = YES;
    [ICanOrange addSubview:ICanOrangeLab];
    _icanOrangeLab = ICanOrangeLab;
    
    //我能蓝色气泡
    UIImageView *ICanBlue = [[UIImageView alloc] init];
    ICanBlue.userInteractionEnabled = YES;
    ICanBlue.image = [UIImage imageNamed:@"ican_blue"];
    CGFloat ICanBlueX = 160;
    CGFloat ICanBlueY = MyCanView.frame.origin.y-90;
    CGFloat ICanBlueW = ICanOrange.image.size.width;
    CGFloat ICanBlueH = ICanOrange.image.size.height;
    ICanBlue.frame = CGRectMake(ICanBlueX, ICanBlueY, ICanBlueW, ICanBlueH);
    [ICanBg addSubview:ICanBlue];
    _ICanBlue = ICanBlue;
    //标签
    UILabel *ICanBlueLab = [[UILabel alloc] init];
    ICanBlueLab.userInteractionEnabled  =YES;
    CGFloat ICanBlueLabW = 60;
    CGFloat ICanBlueLabX = 5;
    CGFloat ICanBlueLabY = 15;
    CGFloat ICanBlueLabH = 20;
    ICanBlueLab.frame = CGRectMake(ICanBlueLabX, ICanBlueLabY, ICanBlueLabW, ICanBlueLabH);
    ICanBlueLab.text = @"教摄影";
    ICanBlueLab.textAlignment = NSTextAlignmentCenter;
    ICanBlueLab.textColor = [UIColor colorWithRed:140/255.0 green:144/255.0 blue:215/255.0 alpha:1.0];
    UITapGestureRecognizer *blueTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick:)];
    [ICanBlueLab addGestureRecognizer:blueTap];
    ICanBlueLab.adjustsFontSizeToFitWidth = YES;
    [ICanBlue addSubview:ICanBlueLab];
    _icanBlueLab = ICanBlueLab;
    
    //我能红色气泡
    UIImageView *ICanRed = [[UIImageView alloc] init];
    ICanRed.userInteractionEnabled = YES;
    ICanRed.image = [UIImage imageNamed:@"ican_red"];
    CGFloat ICanRedX = 235;
    CGFloat ICanRedY = MyCanView.frame.origin.y-40;
    CGFloat ICanRedW = ICanOrange.image.size.width;
    CGFloat ICanRedH = ICanOrange.image.size.height;
    ICanRed.frame = CGRectMake(ICanRedX, ICanRedY, ICanRedW, ICanRedH);
    [ICanBg addSubview:ICanRed];
    _ICanRed = ICanRed;
    //标签
    UILabel *ICanRedLab = [[UILabel alloc] init];
    ICanRedLab.userInteractionEnabled  =YES;
    CGFloat ICanRedLabW = 60;
    CGFloat ICanRedLabX = 5;
    CGFloat ICanRedLabY = 15;
    CGFloat ICanRedLabH = 20;
    ICanRedLab.frame = CGRectMake(ICanRedLabX, ICanRedLabY, ICanRedLabW, ICanRedLabH);
    ICanRedLab.text = @"讲笑话";
    ICanRedLab.textAlignment = NSTextAlignmentCenter;
    ICanRedLab.textColor = [UIColor colorWithRed:230/255.0 green:133/255.0 blue:200/255.0 alpha:1.0];
    UITapGestureRecognizer *redTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick:)];
    [ICanRedLab addGestureRecognizer:redTap];
    ICanRedLab.adjustsFontSizeToFitWidth = YES;
    [ICanRed addSubview:ICanRedLab];
    _icanRedLab = ICanRedLab;

#pragma mark-创建我想视图
    //我想
    MyThinkView = [[UIImageView alloc] init];
    MyThinkView.image =[UIImage imageNamed:@"小人_16"];
    
    
    CGFloat MyThinkViewW = MyThinkView.image.size.width*0.5;
    CGFloat MyThinkViewH = MyThinkView.image.size.height*0.5;
    MyThinkView.bounds = CGRectMake(0, 0, MyThinkViewW, MyThinkViewH);
    CGPoint MyThinkViewcenter;
    MyThinkViewcenter.x = [UIScreen mainScreen].bounds.size.width*0.5-10;
    MyThinkViewcenter.y = CGRectGetMaxY(BootView.frame) + (UIScreenH-50-CGRectGetMaxY(BootView.frame))*0.6;
    MyThinkView.center = MyThinkViewcenter;
    MyThinkView.contentMode = UIViewContentModeScaleAspectFit;
    MyThinkView.userInteractionEnabled = YES;
    
    //设置弹钢琴button
    UIImageView *blueBuble = [[UIImageView alloc] init];
    blueBuble.image = [UIImage imageNamed:@"说话框_14"];
    CGFloat blueBubleX = 10;
    CGFloat blueBubleY = MyThinkView.frame.origin.y-35;
    CGFloat blueBubleW = blueBuble.image.size.width*0.5;
    CGFloat blueBubleH = blueBuble.image.size.height*0.5;
    blueBuble.frame = CGRectMake(blueBubleX, blueBubleY, blueBubleW, blueBubleH);
    blueBuble.userInteractionEnabled = YES;
    [self.view addSubview:blueBuble];
    _blueBuble = blueBuble;
    
    label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(6, 6, 50, 30);
    //label1.text = @"弹钢琴";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor colorWithRed:0/255.0 green:142/255.0 blue:251/255.0 alpha:1];
    label1.tag = 1;
    label1.adjustsFontSizeToFitWidth = YES;
    label1.userInteractionEnabled  =YES;
    UITapGestureRecognizer *label1Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick:)];
    [label1 addGestureRecognizer:label1Tap];
    [_blueBuble addSubview:label1];
    
    //设置学小提琴button
    UIImageView *orangeBuble = [[UIImageView alloc] init];
    orangeBuble.image = [UIImage imageNamed:@"说话框_03"];
    orangeBuble.userInteractionEnabled = YES;
    CGFloat orangeBubleX = 75;
    CGFloat orangeBubleY = MyThinkView.frame.origin.y-70;
    CGFloat orangeBubleW = orangeBuble.image.size.width*0.5;
    CGFloat orangeBubleH = orangeBuble.image.size.height*0.5;
    orangeBuble.frame = CGRectMake(orangeBubleX, orangeBubleY, orangeBubleW, orangeBubleH);
    [self.view addSubview:orangeBuble];
    _orangeBuble = orangeBuble;
    
    
    label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(10, 5, 50, 30);
    //label2.text = @"学小提琴";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor colorWithRed:255/255.0 green:136/255.0 blue:101/255.0 alpha:1];
    label2.adjustsFontSizeToFitWidth = YES;
    label2.tag = 2;
    label2.userInteractionEnabled = YES;
    UITapGestureRecognizer *label2Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick:)];
    [label2 addGestureRecognizer:label2Tap];
    [_orangeBuble addSubview:label2];
    
    //设置找男朋友button
    UIImageView *redBuble = [[UIImageView alloc] init];
    redBuble.image = [UIImage imageNamed:@"说话框_06"];
    redBuble.userInteractionEnabled = YES;
    CGFloat redBubleX = 160;
    CGFloat redBubleY = MyThinkView.frame.origin.y-60;
    CGFloat redBubleW = redBuble.image.size.width*0.5;
    CGFloat redBubleH = redBuble.image.size.height*0.5;
    redBuble.frame = CGRectMake(redBubleX, redBubleY, redBubleW, redBubleH);
    [self.view addSubview:redBuble];
    _redBuble = redBuble;
    
    label3 = [[UILabel alloc] init];
    label3.frame = CGRectMake(11, 5, 50, 30);
    //label3.text = @"找男朋友";
    label3.textAlignment = NSTextAlignmentCenter;
    label3.textColor = [UIColor colorWithRed:255/255.0 green:101/255.0 blue:218/255.0 alpha:1];
    label3.adjustsFontSizeToFitWidth = YES;
    label3.userInteractionEnabled = YES;
    label3.tag = 3;
    UITapGestureRecognizer *label3Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick:)];
    [label3 addGestureRecognizer:label3Tap];
    [_redBuble addSubview:label3];
    //设置找会员button
    
    UIImageView *purpleBuble = [[UIImageView alloc] init];
    purpleBuble.image = [UIImage imageNamed:@"说话框_11"];
    purpleBuble.userInteractionEnabled = YES;
    CGFloat purpleBubleX = 230;
    CGFloat purpleBubleY = MyThinkView.frame.origin.y-20;
    CGFloat purpleBubleW = purpleBuble.image.size.width*0.5;
    CGFloat purpleBubleH = purpleBuble.image.size.height*0.5;
    purpleBuble.frame = CGRectMake(purpleBubleX, purpleBubleY, purpleBubleW, purpleBubleH);
    [self.view addSubview:purpleBuble];
    _purpleBuble = purpleBuble;
    

    label4 = [[UILabel alloc] init];
    label4.frame = CGRectMake(13, 10, 50, 30);
    //label4.text = @"找会员";
    label4.textAlignment = NSTextAlignmentCenter;
    label4.textColor = [UIColor colorWithRed:160/255.0 green:120/255.0 blue:255/255.0 alpha:1];
    label4.adjustsFontSizeToFitWidth = YES;
    label4.tag = 4;
    label4.userInteractionEnabled = YES;
    UITapGestureRecognizer *label4Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick:)];
    [label4 addGestureRecognizer:label4Tap];
    [_purpleBuble addSubview:label4];
    
    [self.view addSubview:MyThinkView];
}

//计时器
-(void)startTimer{
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(MyThinkViewZoom) userInfo:nil repeats:YES];
    
}

#pragma mark-热词搜索

-(void)itemClick:(UITapGestureRecognizer *)tap{
    
    //取出标签
    UILabel *searchLab = (UILabel *)tap.view;
    
    //热词
    _searchWordTempGroup = searchLab.text;
    
    //发送搜索消息(不定位了)
    [_userCenterMessageManager searchIWantOrICan:self.searchType keyWord:_searchWordTempGroup latitude:0.0 longitude:0.0];
    
    //统计热词搜索
    if (self.searchType==kSearchType_IWanted) {
        
        [MobClick event:@"home_ithink_hot_click"];
        
    }else{
        
        [MobClick event:@"home_ican_click"];
        
    }
    
    
}

-(void)searchIWantOrICanCB:(NSDictionary *)dic
{
    
    //创建搜索结果控制器
    voiceNexViewController* viewController = [[voiceNexViewController alloc] init];
    
    //记录下搜索的词语，那边还要搜一下交流厅
    viewController.searchWordTempGroup = _searchWordTempGroup;
    
    //两种搜索方式，导航栏标签是不一样的
    viewController.titleStr = @"搜索结果";
    
    //搜索类型
    viewController.searchType = self.searchType;
    
    //返回的会员／应用／围墙／橱窗的数据都在这个字典里
    viewController.allModelsArr  = dic;
    
    //切换控制器
    [self.navigationController pushViewController:viewController animated:YES];
    
}

#pragma mark -------------BtnTarget
//顶部搜索框左边按钮被点击，根据状态判断是否隐藏弹出框
- (void)WoXiangWoNeng:(UIButton *)sender
{
    
    if (!_isClick) {
        //创建弹出框  ps:为何要创建两次呢？难道隐藏的时候删除掉了？晕，重复创建了。。。
        //[self CreatTanChuKuang];
        tanChuView.hidden = NO;
        [self.view bringSubviewToFront:tanChuView];
    }
    else
    {
        tanChuView .hidden = YES;
    }
    _isClick = !_isClick;
    
    
}
-(void)IWant:(UIButton*)sender
{
    
    [self ThinkPage:(UIButton *)sender];
    
}
-(void)MyCan:(UIButton*)sender
{
    [self CanPage:(UIButton *)sender];
}

//中间搜索按钮被点击
-(void)MySearch
{
    SearchViewController *search =[[SearchViewController alloc]init];
    //debug 本来search的搜索类型依据首页我能or我想 这两个按钮的选中状态决定，为了方便调试，暂时写死
    //根据左边按钮的状态来决定给哪一个枚举值
    search.searchType = _searchType;
    
    [self.navigationController pushViewController:search animated:YES];
}
//右边语音搜索按钮被点击，跳转到语音搜索控制器
-(void)MyVoiceSearch
{
    MYVoiceViewController *voiceSearch =[[MYVoiceViewController  alloc]init];
    voiceSearch.searchType = _searchType;
    [self.navigationController pushViewController:voiceSearch animated:YES];
}

//我想按钮被点击
-(void)ThinkPage:(UIButton *)sender
{
    
    //设置搜索类型
    self.searchType=kSearchType_IWanted;
    
    //改变弹出框按钮的状态
    btnChageBig1.selected = YES;
    btnChageBig2.selected = NO;
    
    //通过隐藏来完成两个图片的切换
    MyThinkView.hidden = NO;
    _blueBuble.hidden = NO;
    _redBuble.hidden = NO;
    _orangeBuble.hidden = NO;
    _purpleBuble.hidden = NO;
    
    _ICanBg.hidden = YES;
    //移动下面的蓝色滑条
    [UIView animateWithDuration:0.3 animations:^{
        MoveView.frame = CGRectMake(0,0, 150, 2);
        
    }];
    //设置颜色和顶部左边按钮的文字
    [thinkBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [canBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [TopLeftButton setTitle:@"我想" forState:UIControlStateNormal];
    _searchType = kSearchType_IWanted;
}

//我能按钮被点击
-(void)CanPage:(UIButton *)sender
{
    //设置搜索类型
    self.searchType=kSearchType_ICan;
    
    //改变弹出框按钮的状态
    btnChageBig1.selected = NO;
    btnChageBig2.selected = YES;
    
    _ICanBg.hidden = NO;
    MyThinkView.hidden = YES;
    
    _blueBuble.hidden = YES;
    _redBuble.hidden = YES;
    _orangeBuble.hidden = YES;
    _purpleBuble.hidden = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        MoveView.frame = CGRectMake(150, 0, 150, 2);
    }];
    [canBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [thinkBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [TopLeftButton setTitle:@"我能" forState:UIControlStateNormal];
    _searchType = kSearchType_ICan;

}
//self.view被点击，将弹出框隐藏起来
-(void)tapHidden:(UITapGestureRecognizer *)sender
{
    tanChuView.hidden = YES;
}

-(void)btnClick:(UIButton *)sender
{
    [self MySearch];
}


-(void)MyThinkViewZoom{
    
    __unsafe_unretained FirstViewController *vc = self;
    
    //动画
    [UIView animateWithDuration:1.5 animations:^{
        
        //我想
        _blueBuble.transform = CGAffineTransformMakeScale(0.2f, 0.2f);
        _orangeBuble.transform = CGAffineTransformMakeScale(0.2f, 0.2f);
        _redBuble.transform = CGAffineTransformMakeScale(0.2f, 0.2f);
        _purpleBuble.transform = CGAffineTransformMakeScale(0.2f, 0.2f);
        
        //我能
        _ICanBlue.transform = CGAffineTransformMakeScale(0.2f, 0.2f);
        _ICanorange.transform = CGAffineTransformMakeScale(0.2f, 0.2f);
        _ICanPurple.transform = CGAffineTransformMakeScale(0.2f, 0.2f);
        _ICanRed.transform = CGAffineTransformMakeScale(0.2f, 0.2f);
        
    } completion:^(BOOL finished) {
        /*
         要改变热词，在这里赋值
         */
        if ([vc isConnectionAvailable]) {
            
           [vc->_userCenterMessageManager searchHotWord];
            
        }
        

        [UIView animateWithDuration:1.5 animations:^{
            
            //我想
            _blueBuble.transform = CGAffineTransformIdentity;
            
            _orangeBuble.transform = CGAffineTransformIdentity;
            
            _redBuble.transform = CGAffineTransformIdentity;
            
            _purpleBuble.transform = CGAffineTransformIdentity;
            
            //我能
            _ICanBlue.transform = CGAffineTransformIdentity;
            _ICanorange.transform = CGAffineTransformIdentity;
            _ICanPurple.transform = CGAffineTransformIdentity;
            _ICanRed.transform = CGAffineTransformIdentity;
            
        }];

    }];
    
}

-(void)updateINeedHotWord:(NSArray *)array{
    label1.text = array[0];
    label2.text = array[1];
    label3.text = array[2];
    label4.text = array[3];
    
}

-(void)updateICanHotWord:(NSArray *)array{
    
    _icanPurpleLab.text = array[0];
    _icanOrangeLab.text = array[1];
    _icanPurpleLab.text = array[2];
    _icanRedLab.text = array[3];
    
}

//热词消息回调
-(void)searchHotWordCB:(NSDictionary *)dic{
    NSArray *searchINeedArray = dic[searchHotWordINeed];
    NSArray *searchICanArray = dic[searchHotWordICan];
    
    if (searchICanArray.count!=0) {
        
        [self updateINeedHotWord:searchICanArray];
        
    }
    
    if (searchINeedArray.count!=0) {
        
        [self updateICanHotWord:searchINeedArray];
        
    }
    
    
}
//空闲业务服务器回调
-(void)requestLeisureBusinessServerAddressCB:(NSDictionary *)dic{
    
    //发送热词消息
    [_userCenterMessageManager searchHotWord];

}

//检测网络状态
-(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    switch ([reach currentReachabilityStatus]) {
            
        case NotReachable:
            
            isExistenceNetwork = NO;
            
            NSLog(@"notReachable");
            
            break;
            
        case ReachableViaWiFi:
            
            isExistenceNetwork = YES;
            
            NSLog(@"WIFI");
            
            break;
            
        case ReachableViaWWAN:
            
            isExistenceNetwork = YES;
            
            NSLog(@"3G");
            
            break;
            
    }
    
    return isExistenceNetwork;
    
}

@end
