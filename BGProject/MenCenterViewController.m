//
//  MenCenterViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-23.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//
//

#import "SVProgressHUD.h"

#import "FDSPublicManage.h"

#import "UserStoreMessageInterface.h"
#import "UserStoreMessageManager.h"

#import "MenCenterViewController.h"
#import "AppDelegate.h"
#import "useraccountViewController.h"
#import "myAttentionViewController.h"
#import "myFansViewController.h"
#import "myWeiQiangController.h"
#import "myThinkViewController.h"
#import "myCanViewController.h"
#import "SetViewController.h"
#import "myXuanNengViewController.h"
#import "localManagerViewController.h"
#import "myStoreViewController.h"
#import "PersonViewController.h"
#import "FDSUserManager.h"

#import "EGOImageView.h"

#import "FDSUserCenterMessageInterface.h"
#import "FDSUserCenterMessageManager.h"
#import "MoudleMessageManager.h"
#import "FDSUserManager.h"
#import "WeiQiangViewController.h"
#import "MoreViewController.h"
#import "qianMIngViewController.h"
#import "NSString+TL.h"

#define kScrollViewMargin 5
#define kTabBarHeight 49
#define kSignButtonTag 201

#define LoginFromOtherDeviceKey @"LoginFromOtherDevice"

@interface MenCenterViewController ()<UserCenterMessageInterface,UserStoreMessageInterface>

//请求橱窗信息
-(void)request30001CB:(ChuChuangModel*)dic;

@end

@implementation MenCenterViewController
{
    UIView *topView;
    UIScrollView *myScrollerView;
    
    
    UIView *topScroView;
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UIButton *btn4;
    UIButton *btn5;
    UIButton *btn6;
    UIButton *_signBtn;
    
    
    UIView *bottom;
    UIButton *botmBtn;
    UIButton *setBtn;
    UIButton *_moreButton;
    
    NSArray *imgFontArr;
    UIImage *endImg;
    UILabel *_signLabel;
    
    
    UILabel* _nickNameLabel; //显示昵称
    EGOImageView* _iconImageView;//显示头像
    UIImageView* _sexImageView;
    UILabel* _nengnengCode;
    
    UILabel* _myGuanzhuLabel;  //显示我的关注的个数
    UILabel* _myFansLabel;//显示我的fans的个数
    UILabel* _myWeiQianglabel;// 显示我的微墙的个数@

    UILabel* _iNeedLablel;
    UILabel* _iCanLabel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        imgFontArr  = [NSArray arrayWithObjects:@"我的橱窗", nil];
       endImg = [UIImage imageNamed:@"个人中心页面_21"];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    [self CreatView];
    
    //背景颜色
    self.view .backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    
    
    // navigation压入该页面时,不请求数据
    _needUpdate = NO;
    
    //注册通知(当一个语音点击的时候通知其他cell要将GIF图删掉)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginFromOtherDevice)
                                                 name:LoginFromOtherDeviceKey object:nil];
    

}

//被踢下来了
-(void)loginFromOtherDevice{
    
    //检测登录状态
    [self loginTest];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    
    
    //将导航栏隐藏
    self.navigationController.navigationBarHidden = YES;
    
    //获得代理对象
    AppDelegate *delegaet =[UIApplication sharedApplication].delegate;
    
    //将tabbar显示出来
    [delegaet showTableBar];
   
    // 注册这三个，分别是发送神马请求的？？
    FDSUserCenterMessageManager* ucManager = [FDSUserCenterMessageManager sharedManager];
    [ucManager registerObserver:self];
    
    
    [[MoudleMessageManager sharedManager]registerObserver:self];
    
    
    [[UserStoreMessageManager sharedManager]registerObserver:self];
    
    
    // 请求个人中心的数据
    if(_needUpdate==YES)
    {
        NSString* userID = [[FDSUserManager sharedManager] NowUserID];
        [ucManager userRequestUserInfo:userID];
        
        //获取的是用户个人资料
        ucManager.userInfoType = UserInfoTypeCurrentUserInfo;
        
    } else {
        
        //在FDSUserManager内部已经发送消息并且将数据解析到BGUser模型里面了
        BGUser* user = [[FDSUserManager sharedManager]getNowUser];
        
        //如果没有用户信息，再次请求
        if([user.userName length] == 0)
        {
            //爆菊花
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            
            //获取用户的id
            NSString* userID = [[FDSUserManager sharedManager] NowUserID];
            
            //人家都还没登录，那么快就获取用户的信息了？？已经登录n久了，还发了请求，只是你没看到
            [ucManager userRequestUserInfo:userID];
            
        }
        else
        {
            //显示个人信息
            [self showUserInfo:user];
        }

    }
    
    //如果没登录就推登录控制器
    [self loginTest];
 
}

-(void)loginTest{
    
    PersonViewController *person = [[PersonViewController alloc]init];
    FDSUserManager* userManager = [FDSUserManager sharedManager];
    
    
    if([userManager getNowUserState]!=USERSTATE_LOGIN ){
        [self.navigationController pushViewController:person animated:YES];
    }
    
}


-(void)getUserInfoCB:(NSDictionary *)dic {
    
    if ([FDSUserCenterMessageManager sharedManager].userInfoType==UserInfoTypeCurrentUserInfo) {
        
        [SVProgressHUD popActivity];
        BGUser* user = [[BGUser alloc]init];
        [user updateWithDic:dic];
        [self showUserInfo:user];
        
    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    
    
    [SVProgressHUD popActivity];
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
    [[MoudleMessageManager sharedManager]unRegisterObserver:self];
    [[UserStoreMessageManager sharedManager] unRegisterObserver:self];
    [super viewWillDisappear:animated];
    
}


-(void)CreatView
{
    //导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    //导航栏标签
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    label1.text = @"个人中心";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    
    [topView addSubview:label1];
    [self.view addSubview:topView];
    
    //440
    CGFloat myScrollerViewX = kScrollViewMargin;
    CGFloat myScrollerViewY = CGRectGetMaxY(topView.frame)+2*kScrollViewMargin;
    CGFloat myScrollerViewW = self.view.bounds.size.width-kScrollViewMargin*2;
    CGFloat myScrollerViewH = self.view.bounds.size.height-kTabBarHeight-myScrollerViewY;//为何高度是440？？
    myScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(myScrollerViewX, myScrollerViewY, myScrollerViewW, myScrollerViewH)];
    myScrollerView.pagingEnabled = YES;
    
    
    myScrollerView.showsVerticalScrollIndicator = NO;
    
    //上面我的关注那一个整体
    topScroView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 310, 224+60+10)];
    topScroView.layer.borderWidth = 0.5;
    topScroView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    topScroView.backgroundColor = [UIColor whiteColor];
    
    //背景按钮，控件都放在上面
    btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 310, 90)];
    btn1.backgroundColor = [UIColor colorWithRed:105/255.0 green:184/255.0 blue:252/255.0 alpha:1.0];
    btn1.tag = 0;

    //头像
    EGOImageView *iconImg = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 70, 70)];
    iconImg.placeholderImage = [UIImage imageNamed:@"11.png"];
    //设置头像的圆角
    iconImg.layer.borderWidth = 2.0;
    iconImg.layer.borderColor = [UIColor whiteColor].CGColor;
    CGFloat radius = iconImg.bounds.size.width*0.5;
    [iconImg.layer setCornerRadius:radius];
    [iconImg.layer setMasksToBounds:YES];
    _iconImageView = iconImg;
    
    //昵称
    _nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconImg.frame.origin.x+iconImg.frame.size.width+10, 10, 100, 33)];
    _nickNameLabel.text  = @"昵称";
    _nickNameLabel.textColor = [UIColor whiteColor];
    _nickNameLabel.font = [UIFont boldSystemFontOfSize:15.0];
    
    //性别图片
    UIImageView *sexImg = [[UIImageView alloc]initWithFrame:CGRectMake(_nickNameLabel.frame.origin.x+_nickNameLabel.frame.size.width, _nickNameLabel.frame.origin.y+10, 12.5, 12.5)];
    //btn1img2.image = [UIImage imageNamed:@"男"];
    _sexImageView = sexImg;
    
    //能能号
    UILabel *nengnengCode = [[UILabel alloc]initWithFrame:CGRectMake(_nickNameLabel.frame.origin.x, _nickNameLabel.frame.origin.y+_nickNameLabel.frame.size.height+5, 200, 25)];
    nengnengCode.textColor = [UIColor whiteColor];
    nengnengCode.font = [UIFont boldSystemFontOfSize:13.0];
    nengnengCode.text = [NSString stringWithFormat:@"能能号"];
    _nengnengCode = nengnengCode;
    
    //箭头
    UIImageView *arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(288, 40, 12, 12)];
    arrowImg.image = endImg;
    
    
    [btn1 addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 addSubview:iconImg];
    [btn1 addSubview:_nickNameLabel];
    [btn1 addSubview:sexImg];
    [btn1 addSubview:nengnengCode];
    [btn1 addSubview:arrowImg];
    [topScroView addSubview:btn1];
    
    //签名
    CGFloat signBtnY = CGRectGetMaxY(btn1.frame);
    _signBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, signBtnY, 310, 60)];
    _signBtn.tag = kSignButtonTag;
    [_signBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topScroView addSubview:_signBtn];
    
    UILabel *signTitleLab = [[UILabel alloc] init];
    signTitleLab.frame = CGRectMake(10, 20, 60,20 );
    signTitleLab.text = @"个人签名";
    signTitleLab.font = [UIFont boldSystemFontOfSize:13.0];
    signTitleLab.textColor = [UIColor blackColor];
    [_signBtn addSubview:signTitleLab];
    
    //中间那条线
    UIView *barline = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_signBtn.frame), 310, 3)];
    barline.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [topScroView addSubview:barline];
    
    //箭头
    CGFloat signArrowY = (_signBtn.frame.size.height-12)/2;
    UIImageView *signArrow = [[UIImageView alloc]initWithFrame:CGRectMake(288, signArrowY, 12, 12)];
    signArrow.image = endImg;
    [_signBtn addSubview:signArrow];
    
    _signLabel = [[UILabel alloc] init];
    CGFloat signLabelH = 20;
    CGFloat signLabelX = CGRectGetMaxX(signTitleLab.frame)+5;
    CGFloat signLabelY = (_signBtn.frame.size.height-signLabelH)/2;
    CGFloat signLabelW = signArrow.frame.origin.x-signLabelX-10;
    _signLabel.frame = CGRectMake(signLabelX, signLabelY, signLabelW, signLabelH);
    _signLabel.font = [UIFont systemFontOfSize:13.0];
    _signLabel.textColor = [UIColor grayColor];
    [_signBtn addSubview:_signLabel];
    
    //分割线
    for (int i = 0; i < 4; i++) {
        
        //只有第一条是100其他都是44
        UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(barline.frame)+i*44, 310, 0.5)];
        barView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        [topScroView addSubview:barView];
    }
    
    //我的关注底部按钮
    btn2 = [[UIButton alloc]initWithFrame:CGRectMake(btn1.frame.origin.x, CGRectGetMaxY(barline.frame), 155, 44)];
    [btn2 addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn2.tag = 1;
    
    //关注数
    UILabel *btn2label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, btn2.frame.size.width, 20)];
    _myGuanzhuLabel = btn2label;
    
    //关注标签
    UILabel *btn2label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, btn2.frame.size.width, 20)];
    btn2label.textAlignment = NSTextAlignmentCenter;
    btn2label1.textAlignment = NSTextAlignmentCenter;
    btn2label1.text = @"我的关注";
    
    [btn2 addSubview:btn2label];
    [btn2 addSubview:btn2label1];
    
    //横向分割线
    UIView *subBarrView = [[UIView alloc]initWithFrame:CGRectMake(btn2.frame.origin.x+btn2.frame.size.width, btn2.frame.origin.y, 0.5, 44)];
    subBarrView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [topScroView addSubview:subBarrView];
    
    //我的粉丝背景按钮
    btn3 = [[UIButton alloc]initWithFrame:CGRectMake(btn2.frame.origin.x+btn2.frame.size.width+0.5, btn2.frame.origin.y, btn2.frame.size.width, 44)];
    [btn3 addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn3.tag = 2;
    
    //粉丝数
    UILabel *btn3label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, btn2.frame.size.width, 20)];
    _myFansLabel = btn3label;
    
    //粉丝标签
    UILabel *btn3label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, btn2.frame.size.width, 20)];
    btn3label1.text = @"我的粉丝";
    btn3label.textAlignment = NSTextAlignmentCenter;
    btn3label1.textAlignment = NSTextAlignmentCenter;
    [btn3 addSubview:btn3label];
    [btn3 addSubview:btn3label1];
    
    
    //横向分割线
    UIView *subBarrView1 = [[UIView alloc]initWithFrame:CGRectMake(btn3.frame.origin.x+btn3.frame.size.width, btn3.frame.origin.y, 0.5, 44)];
    subBarrView1.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    
    [topScroView addSubview:subBarrView1];
    
    //我想背景按钮，占据整个cell
    btn5 = [[UIButton alloc]initWithFrame:CGRectMake(0, btn2.frame.origin.y+btn2.frame.size.height+0.5, 310, 44)];
    btn5.tag = 4;

    //我想图标
    UIImageView *btn5label = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 34, 34)];
    btn5label.image = [UIImage imageNamed:@"imiss"];
    
    //我想内容
    UILabel *btn5label1 = [[UILabel alloc ]initWithFrame:CGRectMake(btn5label.frame.origin.x+btn5label.frame.size.width+15, 5, /*130*/220, 30)];
    btn5label1.text  = @"";
    _iNeedLablel = btn5label1;
    _iNeedLablel.numberOfLines = 0;
    _iNeedLablel.font = [UIFont systemFontOfSize:13];
    //内容适应宽度
    _iNeedLablel.adjustsFontSizeToFitWidth = YES;
    //最小字体大小
    _iNeedLablel.minimumFontSize = 7;
    
    //箭头
    UIImageView *imgView5 = [[UIImageView alloc]initWithFrame:CGRectMake(288, 14, 12, 12)];
    imgView5.image = endImg;
    
    [btn5 addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn5 addSubview:btn5label];
    [btn5 addSubview:btn5label1];
    [btn5 addSubview:imgView5];
    
    //我能背景按钮
    btn6 = [[UIButton alloc]initWithFrame:CGRectMake(0,btn5.frame.origin.y+btn5.frame.size.height+0.5, 310, 44)];
    btn6.tag = 5;
    btn6.backgroundColor = [UIColor whiteColor];
    
    //我想图标
    UIImageView *btn6label = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 34, 34)];
    btn6label.image = [UIImage imageNamed:@"ican"];
    
    //我能内容
    UILabel *btn6label1 = [[UILabel alloc ]initWithFrame:CGRectMake(btn5label.frame.origin.x+btn5label.frame.size.width+15, 5, 220, 30)];
//    btn6label1.text  = @"我能打篮球";
    _iCanLabel =btn6label1;
    _iCanLabel.numberOfLines = 0;
    _iCanLabel.font = [UIFont systemFontOfSize:13];
    //同上，字体大小自适应
    _iCanLabel.adjustsFontSizeToFitWidth = YES;
    _iCanLabel.minimumFontSize = 7;
    
    //箭头
    UIImageView *imgView6= [[UIImageView alloc]initWithFrame:CGRectMake(288, 14, 12, 12)];
    imgView6.image = endImg;
    
    [btn6 addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn6 addSubview:btn6label];
    [btn6 addSubview:btn6label1];
    [btn6 addSubview:imgView6];
    
    
    [topScroView addSubview:btn2];
    [topScroView addSubview:btn3];
    [topScroView addSubview:btn4];
    [topScroView addSubview:btn5];
    [topScroView addSubview:btn6];
    
    
    [myScrollerView addSubview:topScroView];
    

    // 最下面的部分，哎呦，写的不累，看都看累了
    
    //我的店铺
    bottom = [[UIView alloc]initWithFrame:CGRectMake(0, topScroView.frame.origin.y+topScroView.frame.size.height+3, 310, 44)];
    bottom.layer.borderWidth = 0.5;
    bottom.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    bottom.backgroundColor = [UIColor whiteColor];
    
    //添加我的橱窗按钮
    for (int i = 0; i < imgFontArr.count; i++) {
        
        //背景按钮
        botmBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, i*40, 310, 44)];
        botmBtn.tag = 6+i;
        
        //图标
        UIImageView *imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 22.5, 22.5)];
        //没得救了，把名字放到数组里面去
        imgView1.image = [UIImage imageNamed:imgFontArr[i]];
        
        //标签
        UILabel *label = [[UILabel alloc ]initWithFrame:CGRectMake(imgView1.frame.origin.x+imgView1.frame.size.width+15, 5, 130, 30)];
        label.text  = imgFontArr[i];
        
        //箭头
        UIImageView *imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(288, 14, 12, 12)];
        imgView2.image = endImg;
        
        [botmBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [botmBtn addSubview:imgView1];
        [botmBtn addSubview:label];
        [botmBtn addSubview:imgView2];
        [bottom addSubview:botmBtn];
    }
    
    //设置背景按钮
    setBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, bottom.frame.origin.y+bottom.frame.size.height+3, 310, 0)];
    setBtn.tag = 9;
    setBtn.backgroundColor = [UIColor whiteColor];
    setBtn.layer.borderWidth = 0.5;
    setBtn.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    //设置图标
    UIImageView *imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 22.5, 22.5)];
    imgView1.image = [UIImage imageNamed:@"设置"];
    
    //设置标签
    UILabel *label = [[UILabel alloc ]initWithFrame:CGRectMake(imgView1.frame.origin.x+imgView1.frame.size.width+15, 5, 130, 30)];
    label.text  = @"设置";
    
    //箭头
    UIImageView *imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(288, 14, 12, 12)];
    imgView2.image = endImg;
    
    [setBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [setBtn addSubview:imgView1];
    [setBtn addSubview:label];
    [setBtn addSubview:imgView2];
    [myScrollerView addSubview:setBtn];
    
    [myScrollerView addSubview:bottom];
    
#pragma mark-更多
    //更多按钮
    _moreButton = [[UIButton alloc] init];
    _moreButton.tag = 10;
    _moreButton.backgroundColor = [UIColor whiteColor];
    CGFloat moreButtonX = 0.5;
    CGFloat moreButtonY = CGRectGetMaxY(setBtn.frame);
    CGFloat moreButtonW = kScreenWidth-11;
    CGFloat moreButtonH = 44;
    _moreButton.frame = CGRectMake(moreButtonX, moreButtonY, moreButtonW, moreButtonH);
    
    UIImageView *moreIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10,(44-5.5)*0.5, 21, 5.5)];//图标
    moreIcon.image = [UIImage imageNamed:@"moreIcon"];
    [_moreButton addSubview:moreIcon];
    
    UILabel *morelabel = [[UILabel alloc ]initWithFrame:CGRectMake(moreIcon.frame.origin.x+moreIcon.frame.size.width+15, 5, 130, 30)];//标签
    morelabel.text  = @"更多";
    [_moreButton addSubview:morelabel];
    
    //箭头
    UIImageView *moreArrow = [[UIImageView alloc]initWithFrame:CGRectMake(288, 14, 12, 12)];
    moreArrow.image = endImg;
    [_moreButton addSubview:moreArrow];
    
    [_moreButton addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [myScrollerView addSubview:_moreButton];
    
    //干嘛让它滚动呢？不解
    myScrollerView.contentSize = CGSizeMake(310,CGRectGetMaxY(_moreButton.frame)+10);//滚动距离是500，几个意思？？
    
    [self.view addSubview:myScrollerView];
    

    
}

#pragma mari btnclik===============
-(void)bottomBtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            useraccountViewController *ues =[[useraccountViewController alloc]init];
            [self.navigationController pushViewController:ues animated:YES];
        }
            break;
        case 1:
        {

            //爆菊花
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            
            //请求类型
            int attType = 0;//0表示我关注
            
            //发送请求关注列表消息
            [[FDSUserCenterMessageManager sharedManager] requestAttentionListWithType:attType start:0 end:10];
            
        }
            break;
        case 2:
        {  // 显示 我的粉丝 2014年09月27日
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            int attType = 1;//0表示关注我的
            [[FDSUserCenterMessageManager sharedManager] requestAttentionListWithType:attType start:0 end:10];
        }
            break;
          
        case kSignButtonTag:
        {

            //签名
            qianMIngViewController *nicheng =[[qianMIngViewController alloc]init];
            [self.navigationController pushViewController:nicheng animated:YES];
            
        }
            break;
        case 4:
        {
            
            [MobClick event:@"me_change_want_click"];
            
            //我想
            myThinkViewController  *think = [[myThinkViewController alloc]init];
            [self.navigationController pushViewController:think animated:YES];
        }
            break;
        case 5:
        {
            
            [MobClick event:@"me_change_can_click"];
            
            //我能
            myCanViewController  *can = [[myCanViewController alloc]init];
            [self.navigationController pushViewController:can animated:YES];
            
        }
            break;
        case 6://我的橱窗
        {
            
            [MobClick event:@"me_showcase_click"];
            
            //取出userid
            NSString* userid = [[FDSUserManager sharedManager]NowUserID];
            
            //爆菊花
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            
            //发送请求橱窗消息
            [[UserStoreMessageManager sharedManager]request30001WithID:userid];
            
        }
            break;
            
        case 9:
        {
            SetViewController  *can = [[SetViewController alloc]init];
            [self.navigationController pushViewController:can animated:YES];
        }
            break;
        case 10:
        {
            
            [MobClick event:@"me_more_click"];
            
            MoreViewController  *more = [[MoreViewController alloc]init];
            [self.navigationController pushViewController:more animated:YES];
        }
            break;
        default:
            break;
    }
}



// 将userInfo的数据显示在界面中,注册到个人中心消息中
-(void)showUserInfo:(BGUser*) user{
  
    //显示昵称
    [_nickNameLabel setText:user.nickn];
    
    //显示性别图片
    [self setSexImage:user.sex];
    
    //个人头像
    _iconImageView.imageURL =[NSURL URLWithString:[NSString setupSileServerAddressWithUrl:user.photo]];
    
    //用户名或者能能号
    [_nengnengCode setText:[NSString stringWithFormat:@"能能号:%@",user.userName]];
    
    //个性签名
    _signLabel.text = user.signature;
    
    //我的关注
    [_myGuanzhuLabel setText:user.guanzhu];
    
    //我的粉丝
    [_myFansLabel setText:user.fansnumber];
    
    //我的微墙
    [_myWeiQianglabel setText:user.weiqiang];
    
    //我想
    [_iNeedLablel setText:user.ineed];
    
    //我能
    [_iCanLabel setText:user.ican];
    
}

-(void)setSexImage:(NSString*) sex {
    if([sex length]>0) {
        int sexCode = [sex intValue];
        UIImage* sexImg = nil;
        //女
        if(sexCode==0) {
             sexImg = [UIImage imageNamed:@"女"];
                    }
         // 男
        if(sexCode==1) {
            sexImg = [UIImage imageNamed:@"男"];
        }
        //保密
        if(sexCode==2) {
           
            sexImg = nil;

        }
        _sexImageView.image = sexImg;
        
    } else {
        [_sexImageView setImage:nil];
    }
}

//我的关注回调
-(void)requestAttentionListCB:(NSArray*)array {
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    
    if (array.count==0) {
        
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"没有相关的数据"];
        
        return;
        
    }
    
    //干嘛取出第一个？？其他的都一样的
    FriendModel* model = array[0];
    
    int searchtype = model.searchtype;
    
    //0表示我的关注
    if(searchtype == 0) {
        //guanzhutype = 1 (我的关注)
        myAttentionViewController *myAttentionVC =[[myAttentionViewController alloc]init];
        
        myAttentionVC.myAttendList = [NSMutableArray arrayWithArray:array];
        
        [self.navigationController pushViewController:myAttentionVC animated:YES];
        
    } else {
        
        //1表示我的粉丝
        myFansViewController *fansVC =[[myFansViewController alloc]init];
        fansVC.fans = [NSMutableArray arrayWithArray    :array];
        [self.navigationController pushViewController:fansVC animated:YES];
        
    }

    


}

//我的微墙回调
-(void)weiQiangListCB:(NSArray *)result {
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //如果数组为空，说明没有微博
    if([result count] == 0)
    {
        //显示提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"暂时没有微博数据"];
        
    } else {
        
        // 我的微墙的回调 2014年09月27日 copy之前写的jock 完成微墙的单元格
        myWeiQiangController *weiQiang =[[myWeiQiangController alloc]init];
        weiQiang.weiQianArr = [NSMutableArray array];
        
        //取出userid
        weiQiang.userid = [[FDSUserManager sharedManager] NowUserID];
        
        //设置微墙类型
        weiQiang.weiQiangType=WeiQiangTypeMy;
        
        //遍历数组，将元素加进weiQianArr
        [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [weiQiang.weiQianArr addObject:obj];
        }];
        
        //切换控制器
        [self.navigationController pushViewController:weiQiang animated:YES];
    }
}


//请求橱窗信息，橱窗信息里面包含有推荐列表的信息
-(void)request30001CB:(ChuChuangModel*)model
{
    //去掉菊花
    [SVProgressHUD popActivity];
    
    myStoreViewController *store = [[myStoreViewController alloc]init];
    
    //获取模型
    store.model = model;
    
    //获取userid
    store.userid = [[FDSUserManager sharedManager] NowUserID];
    
    //设置橱窗类型
    store.storeType=StoreTypeMy;
    
    //切换控制器
    [self.navigationController pushViewController:store animated:YES];
    
}

-(void)dealloc{
    
    //删除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LoginFromOtherDeviceKey object:nil];
    
}

@end
