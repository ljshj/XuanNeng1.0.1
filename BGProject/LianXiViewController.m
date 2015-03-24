//
//  LianXiViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "LianXiViewController.h"
#import "addGroupViewController.h"
#import "addGoodFriendViewController.h"
#import "AppDelegate.h"
#import "liaoTianViewController.h"
#import "PersonViewController.h"
#import "registerAndLoad.h"
#import "PlatformMessageManager.h"
#import "FDSUserManager.h"
#import "BaseCell.h"
#import "InfoCell.h"
#import "FriendCell.h"
#import "BaseCell.h"
#import "EaseMob.h"
#import "SVProgressHUD.h"
#import "ZZUserDefaults.h"
#import "NotificationViewController.h"
#import "FDSUserCenterMessageManager.h"
#import "NotificationFrame.h"
#import "DataBaseSimple.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "GroupInfoViewController.h"
#import "PersonlCardViewController.h"
#import "NSDateFormatter+Category.h"
#import "NSDate+Category.h"
#import "BGBadgeButton.h"

#define TabBarHeight 49
#define BannerViewH 35
#define BannerViewBtnW 55
#define SearchViewMargin 10

#define LoginFromOtherDeviceKey @"LoginFromOtherDevice"

#define DividerColor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]
#define DividerFrameZero CGRectMake(0,80-0.5 , self.view.bounds.size.width, 0.5)
#define DividerFrameTop CGRectMake(0,0.5 , self.view.bounds.size.width, 0.5)


@interface LianXiViewController ()<PlateformMessageInterface,EMChatManagerDelegate,FriendCellDelegate,UserCenterMessageInterface>

@end

@implementation LianXiViewController
{
    UIView *topView;
    UIView *bannerView;
    UITableView *myTableView;
    UITableView *friendTableView;
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    UIButton *button4;
    UIButton *btn1;
    NSArray *arr;
    BOOL  isLoad;
    
    UITextField *searchView;
    
    //记录下点击群的名字（好友列表）
    NSString *_hxgroupidSelected;
    
    //记录下roomid
    NSString *_roomid;
    
    //记录下点击的群类型
    NSString *_grouptype;
    
    //记录下群名称(临时群才需要搜索)
    NSString *_groupname;
    
    //记录下被删除的userid
    NSString *_deleteUserid;
    
    //记录下被点击头像的的userid
    NSString *_personTapUserid;
    
    //协助下拉键盘的背景图
    __weak UIView *_keyboardBackView;
    
    //看点击到哪个按钮了
    int _selectedIndex;
    
    //徽章按钮
    BGBadgeButton *_badgeButton;
    
    //徽章数字
    int _badgeCount;

    //此刻是否在消息列表那里
    BOOL _isAppearMessageList;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //按钮用的标题
        arr = [NSArray arrayWithObjects:@"消息",@"好友",@"群",@"交流厅", nil];
        _messageCellFrames  = [NSMutableArray array];
        _friendCellFrames = [NSMutableArray array];
        _crowdCellFrames = [NSMutableArray array];
        _tempCrowdCellFrames = [NSMutableArray array];
        
        //delete        friendArr   = [NSMutableArray array];
        exchangeArr = [NSMutableArray array];
        groupArr    = [NSMutableArray array];
        
        //添加假数据
        [self initData];
    }
    return self;
}

-(NSMutableArray *)messages{
    
    if (_messages==nil) {
        
        _messages = [[NSMutableArray alloc] init];
        
    }
    
    return _messages;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"联系"];
    
    //判断是否已经登录
    if ([[FDSUserManager sharedManager] getNowUserState]!=USERSTATE_LOGIN) {
        PersonViewController *perVC = [[PersonViewController alloc] init];
        [self.navigationController pushViewController:perVC animated:NO];
    }
    
    //每一次出现都要刷新列表
    [self LoadContactListFromDB];
    
    //获取会话信息
    [self LoadConversations];
    
    //将导航栏隐藏起来
    self.navigationController.navigationBarHidden = YES;
    
    //将tablebar显示出来
    AppDelegate *app =[UIApplication sharedApplication].delegate ;
    [app showTableBar];
    
    //注册代理
    [[PlatformMessageManager sharedManager] registerObserver:self];
    
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
    
    
    
}

#pragma mark-多线程请求好友和群列表

-(void)requestContactData{
    
    [[PlatformMessageManager sharedManager] requestContactList];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    [MobClick endLogPageView:@"联系"];
    
    //去掉代理
    [[PlatformMessageManager sharedManager] unRegisterObserver:self];
    
    [[FDSUserCenterMessageManager sharedManager] unRegisterObserver:self];
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTableView)
                                                 name:DisbandGroupKey object:nil];
    
    //注册通知(把群组页面刷新)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshGroupList)
                                                 name:didLeaveFromGroup object:nil];
    
    //注册通知(接收好友请求)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshFriendsList)
                                                 name:didAcceptedByFriend object:nil];
    
    //注册通知(重新登录后刷新页面数据)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshContactData:)
                                                 name:@"requestContactDataAgain" object:nil];
    
    //注册通知(重新登录后刷新页面数据)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshMessageData)
                                                 name:SetupMessageBadgeCountKey object:nil];
    
    //导航栏／分类视图／消息表格
    [self CreatView];
    
    
    //注册环信代理接收消息
    [[[EaseMob sharedInstance] chatManager] addDelegate:self delegateQueue:nil];

    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    
    //后台开启一个线程刷新数据
    [self performSelectorInBackground:@selector(requestContactData) withObject:nil];
    
    //监听键盘弹出
    [self observeKeyboard];
    
}

//有系统消息后刷新会话列表，也修改徽章
-(void)refreshMessageData{
    
    [self LoadConversations];
    
    
}

//重新登录后刷新数据
-(void)refreshContactData:(NSNotification *)noti{
    
    NSDictionary *data = (NSDictionary *)noti.object;
    
    //在那边请求完数据再传过来，这样就保证有数据了，不会怕代理来不及设置没回调
    [self requestContactListCB:data];
    
}

//监听键盘弹出
-(void)observeKeyboard{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//把键盘放下去
-(void)resignKeyboardTap{
    [searchView endEditing:YES];
}
//设置keyboardBackView
-(void)setupkeyboardBackViewWithSize:(CGSize)size{
    
    UIView *keyboardBackView = [[UIView alloc] init];
    CGRect bounds = self.view.bounds;
    bounds.size.height = bounds.size.height-size.height;
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

    
}

-(void)keyboardWillHide:(NSNotification *)noti{
    
    //将从父视图遮罩移除
    [_keyboardBackView removeFromSuperview];
    
    
}

#pragma mark-获取会话信息

-(void)LoadConversations{
    
    //[[EaseMob sharedInstance].chatManager removeConversationByChatter:@"14201702207324" deleteMessages:YES];
    
    
    //取出数据库的所有会话
    NSArray *DBconversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabase];
    
    //构建排序数组（以时间先后排序）
    NSMutableArray *timeConversations = [[NSMutableArray alloc] init];
    [timeConversations addObjectsFromArray:DBconversations];

    
    for (int i = 0; i<[timeConversations count]; i++)
    {
        for (int j=i+1; j<[timeConversations count]; j++)
        {
            EMConversation *a = [timeConversations objectAtIndex:i];
            
            EMConversation *b = [timeConversations objectAtIndex:j];
           
            if (a.latestMessage.timestamp < b.latestMessage.timestamp)
            {
                [timeConversations replaceObjectAtIndex:i withObject:b];
                [timeConversations replaceObjectAtIndex:j withObject:a];
            }
            
        }
        
    }
    
    //清空数组
    [_messageCellFrames removeAllObjects];
    
    //清空徽章
    _badgeCount = 0;
    
    
    //取出所有用户名
    for (EMConversation *conversation in timeConversations) {
        
        //取出最后一条消息放上去
        EMMessage *message = conversation.latestMessage;
        
        //取出消息数组
        NSArray *bodies = message.messageBodies;
        
        //取出文本对象
        EMTextMessageBody *body = bodies[0];
        
        //取出用户名
        NSString *username = conversation.chatter;
        
        //先过滤掉群组
        if ([username hasPrefix:@"bg"]) {
            
            //用户名转换成userid
            NSString *userid = [username stringByReplacingOccurrencesOfString:@"bg" withString:@""];
            
            //从数据库取出模型
            FriendCellModel *friendModel = [[DataBaseSimple shareInstance] selectFriendsWithUserid:userid];
            
            InfoCellModel *infoModel = [[InfoCellModel alloc] init];
            
            //拼凑模型
            infoModel.name = friendModel.name;
            infoModel.detail = [self getMessageTextWith:body];
            infoModel.image = friendModel.image;
            infoModel.userid = friendModel.userid;
            NSString *dateStr = [NSDate formattedTimeFromTimeInterval:message.timestamp];
    
            if ([dateStr hasPrefix:@"1970"]) {
                infoModel.dateString = @"";
            }else{
                infoModel.dateString = dateStr;
            }
            infoModel.badgeCount = (int)conversation.unreadMessagesCount;//未读的消息数量
            _badgeCount = _badgeCount+(int)conversation.unreadMessagesCount;
            infoModel.InfoModelType = InfoModelTypeFriend;//模型类型
            
            InfoCellFrame* cellFrame = [[InfoCellFrame alloc]init];
            cellFrame.model = infoModel;
            
            [_messageCellFrames addObject:cellFrame];
            
        }else{//群
            
            //从数据库取出模型(用户名就是环信群ID)
            BaseCellModel *fixModel = [[DataBaseSimple shareInstance] selectGroupsWithHxgroupid:username];
            
            InfoCellModel *infoModel = [[InfoCellModel alloc] init];
            //拼凑模型
            infoModel.name = fixModel.name;
            infoModel.detail = [self getMessageTextWith:body];
            //群暂时还没有图片，为空
            infoModel.image = fixModel.image;
            infoModel.hxgroupid = fixModel.hxgroupid;
            infoModel.roomid = fixModel.roomid;
            NSString *dateStr = [NSDate formattedTimeFromTimeInterval:message.timestamp];
            if ([dateStr hasPrefix:@"1970"]) {
                infoModel.dateString = @"";
            }else{
                infoModel.dateString = dateStr;
            }
            
            infoModel.badgeCount = (int)conversation.unreadMessagesCount;//未读的消息数量
             _badgeCount = _badgeCount+(int)conversation.unreadMessagesCount;
            infoModel.grouptype = fixModel.grouptype;
            infoModel.infoModelType = InfoModelTypeGroup;
            
            InfoCellFrame* cellFrame = [[InfoCellFrame alloc]init];
            cellFrame.cellFrameType=CellFrameTypeGroup;
            cellFrame.model = infoModel;
            
            [_messageCellFrames addObject:cellFrame];
            
        }
        
    }
    
    //添加完聊天的未读消息后，还要添加系统通知的消息
    _badgeCount = _badgeCount + [FDSUserManager sharedManager].badgeCount;
    
    //只有不再消息列表里面的时候才会显示徽章
    if (_isAppearMessageList) {
        
        _badgeButton.hidden = YES;
        
    }else{
        
        _badgeButton.hidden = NO;
        
        //调整徽章(只要控制器出现就会刷一次会话)
        _badgeButton.badgeValue = [NSString stringWithFormat:@"%d",_badgeCount];
        if (_badgeCount==0) {
            
            _badgeButton.hidden = YES;
            
        }else{
            
            _badgeButton.hidden = NO;
            
        }
        
    }
    
    //刷列表
    [myTableView reloadData];
    
}

//获取各种消息体的显示文本(语音和图片都用文本表示)
-(NSString *)getMessageTextWith:(EMTextMessageBody *)body{
    
    NSString *msgText = nil;
    
    if (body.messageBodyType==eMessageBodyType_Text) {
        
        msgText = [ConvertToCommonEmoticonsHelper convertToSystemEmoticons:body.text];
        
    }else if (body.messageBodyType==eMessageBodyType_Image){
        
        msgText=@"[图片]";
        
    }else if (body.messageBodyType==eMessageBodyType_Voice){
        
        msgText=@"[语音]";
        
    }else if(body.messageBodyType==eMessageBodyType_Location){
        
        msgText=@"[数据无法解析]";
        
    }else if(body.messageBodyType==eMessageBodyType_File){
        
        msgText=@"[数据无法解析]";
        
    }else if(body.messageBodyType==eMessageBodyType_Command){
        
        msgText=@"[数据无法解析]";
        
    }else if(body.messageBodyType==eMessageBodyType_Video){
        
        msgText=@"[数据无法解析]";
        
    }
    
    return msgText;
    
}

#pragma mark-加载数据库
-(void)LoadContactListFromDB{
    
    //好友列表
    [self LoadFriends];
    
    //群列表
    [self LoadFixrooms];
    
    //交流厅
    [self LoadTempGroup];
}

-(void)LoadTempGroupWithKeyword:(NSString *)keyword{
    
    //删除所有元素
    [_tempCrowdCellFrames removeAllObjects];
    
    //取出群数组
    NSArray *tempGroups = [[DataBaseSimple shareInstance] selectTempGroups];
    
    //将字典数组转换成模型数组
    for (BaseCellModel *fixModel in tempGroups) {
        
        if ([fixModel.name hasPrefix:keyword]) {
            
            BaseCellFrame* cellFrame = [[FriendCellFrame alloc]init];
            cellFrame.model = fixModel;
            cellFrame.cellFrameType=CellFrameTypeGroup;
            [_tempCrowdCellFrames addObject:cellFrame];
            
        }
        
        
    }
    
    //刷新列表
    [myTableView reloadData];
    
}

-(void)LoadTempGroup{
    
    //删除所有元素
    [_tempCrowdCellFrames removeAllObjects];
    
    //取出群数组
    NSArray *tempGroups = [[DataBaseSimple shareInstance] selectTempGroups];
    
    //将字典数组转换成模型数组
    for (BaseCellModel *fixModel in tempGroups) {
        
        BaseCellFrame* cellFrame = [[FriendCellFrame alloc]init];
        cellFrame.model = fixModel;
        cellFrame.cellFrameType=CellFrameTypeGroup;
        [_tempCrowdCellFrames addObject:cellFrame];
        
        
    }
    
    //刷新列表
    [myTableView reloadData];
    
}

-(void)LoadFixroomsWithKeyword:(NSString *)keyword{
    
    //删除所有元素
    [_crowdCellFrames removeAllObjects];
    
    //取出群数组
    NSArray *fixrooms = [[DataBaseSimple shareInstance] selectGroups];
    
    //将字典数组转换成模型数组
    for (BaseCellModel *fixModel in fixrooms) {
        
        if ([fixModel.name hasPrefix:keyword]) {
            
            BaseCellFrame* cellFrame = [[FriendCellFrame alloc]init];
            cellFrame.model = fixModel;
            cellFrame.cellFrameType=CellFrameTypeGroup;
            [_crowdCellFrames addObject:cellFrame];
            
        }
        
    }
    
    //刷新列表
    [myTableView reloadData];
    
}

-(void)LoadFixrooms{
    
    //删除所有元素
    [_crowdCellFrames removeAllObjects];
    
    //取出群数组
    NSArray *fixrooms = [[DataBaseSimple shareInstance] selectGroups];
    
    //将字典数组转换成模型数组
    for (BaseCellModel *fixModel in fixrooms) {
        
        BaseCellFrame* cellFrame = [[FriendCellFrame alloc]init];
        cellFrame.model = fixModel;
        
        cellFrame.cellFrameType=CellFrameTypeGroup;
        
        [_crowdCellFrames addObject:cellFrame];
        
        
    }
    
    //刷新列表
    [myTableView reloadData];
    
}

//通过关键词搜索
-(void)LoadFriendsWithkeyWord:(NSString *)keyword{
    
    //删除数组
    [_friendCellFrames removeAllObjects];
    
    //索引排序类
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    
    //创建一个装好友模型的数组
    NSMutableArray *friendOrderModels = [NSMutableArray array];
    
    //取出好友列表
    NSArray *friends = [[DataBaseSimple shareInstance] selectFriends];
    
    for (FriendCellModel *friendModel in friends) {
        
        //有此前缀的才会被加进搜索数组
        if ([friendModel.name hasPrefix:keyword]) {
            
            //记录下每个模型属于哪一组
            friendModel.section = [theCollation sectionForObject:friendModel collationStringSelector:@selector(name)];
            
            [friendOrderModels addObject:friendModel];
            
        }
        
    }
    
    //将数组拿去排序
    [self sortFriendsWithArray:friendOrderModels];
    
    [friendTableView reloadData];
    
}

-(void)LoadFriends{
    
    //删除数组
    [_friendCellFrames removeAllObjects];
    
    //取出好友列表
    NSArray *friends = [[DataBaseSimple shareInstance] selectFriends];
    
    //索引排序类
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    
    //创建一个装好友模型的数组
    NSMutableArray *friendOrderModels = [NSMutableArray array];
    
    for (FriendCellModel *friendModel in friends) {
        
        //记录下每个模型属于哪一组
        friendModel.section = [theCollation sectionForObject:friendModel collationStringSelector:@selector(name)];
        
        [friendOrderModels addObject:friendModel];
        
        
    }
    
    //将数组拿去排序
    [self sortFriendsWithArray:friendOrderModels];
    
    [friendTableView reloadData];
    
}


-(void)CreatView
{
    //导航栏背景图
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.layer.borderWidth = 0.5;
    topView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    [self.view addSubview:topView];
    
    //导航栏上面那个分类视图
    bannerView = [[UIView alloc]initWithFrame:CGRectMake(35, 22, 241.5, BannerViewH)];
    bannerView.layer.borderWidth = 0.5;
    bannerView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    [topView addSubview:bannerView];
    
    //消息按钮
    CGFloat button1W = BannerViewBtnW;
    button1 = [self addButtonWithFrame:CGRectMake(0, 0, button1W, BannerViewH) withTag:0];
    //一开始选中的是开始按钮，刷新的也是消息列表，所以一开始不可能会刷新好友列表的
    [button1 setSelected:YES];
    _isAppearMessageList = YES;
    
    //徽章
    _badgeButton = [[BGBadgeButton alloc] init];
    _badgeButton.frame = CGRectMake(75, 17, 10, 10);
    [topView addSubview:_badgeButton];
    
    //分割线
    CGFloat bannerSubView1X = CGRectGetMaxX(button1.frame);
    UIView *bannerSubView1 =[[UIView alloc]initWithFrame:CGRectMake(bannerSubView1X, 0, 0.5, BannerViewH)];
    bannerSubView1.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [bannerView addSubview:bannerSubView1];
    
    //好友按钮
    button2 = [self addButtonWithFrame:CGRectMake(bannerSubView1X+0.5, 0, BannerViewBtnW, BannerViewH) withTag:1];
    
    //分割线
    UIView *bannerSubView2 =[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button2.frame), 0, 0.5, BannerViewH)];
    bannerSubView2.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [bannerView addSubview:bannerSubView2];
    
    //群按钮
    button3 = [self addButtonWithFrame:CGRectMake(CGRectGetMaxX(button2.frame)+0.5, 0, BannerViewBtnW, BannerViewH) withTag:2];
    
    //分割线
    UIView *bannerSubView3 =[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button3.frame), 0, 0.5, BannerViewH)];
    bannerSubView3.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [bannerView addSubview:bannerSubView3];
    
    //交流厅按钮
    button4 = [self addButtonWithFrame:CGRectMake(CGRectGetMaxX(button3.frame)+0.5, 0, 60, BannerViewH) withTag:3];
    
    //修改分类视图的宽度
    CGRect bannerViewF = bannerView.frame;
    bannerViewF.size.width = CGRectGetMaxX(button4.frame);
    bannerView.frame = bannerViewF;
    
    //导航栏右边的添加按钮
    btn1 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bannerView.frame)+15, bannerView.frame.origin.y+5, 25, 25)];
    [btn1 setImage:[UIImage imageNamed:@"大加号"] forState:UIControlStateNormal];
    btn1.imageView.contentMode=UIViewContentModeCenter;
    [btn1 addTarget:self action:@selector(addBtn:) forControlEvents:UIControlEventTouchUpInside];
    //一开始是隐藏的
    btn1.hidden = YES;
    [topView addSubview:btn1];
    
    //搜索框
    searchView = [[UITextField alloc]initWithFrame:CGRectMake(10, kTopViewHeight+SearchViewMargin, 300, 35)];
    searchView.delegate = self;
    searchView.placeholder = @"搜索好友";
    searchView.font = [UIFont systemFontOfSize:13.0];
    searchView.borderStyle = UITextBorderStyleRoundedRect;
    searchView.returnKeyType = UIReturnKeySearch;
    //搜索框的左边放大镜
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(11, 13, 17, 17)];
    imageView.image =[UIImage imageNamed:@"联系－固定群_19"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //搜索框分割线
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(40, 0, 1, 44)];
    lineView.backgroundColor =[UIColor grayColor];
    lineView.alpha = 0.2;
    UIView *bigView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 41, 44)];
    [bigView addSubview:imageView];
    [bigView addSubview:lineView];
    
    searchView.leftView = bigView;
    searchView.leftViewMode = UITextFieldViewModeAlways;
    //搜索框一开始是隐藏起来的
    searchView.hidden = YES;
    [self.view addSubview:searchView];
    
    //tableview
    CGFloat myTableViewH = self.view.frame.size.height-kTopViewHeight-TabBarHeight;
    myTableView = [[UITableView alloc] init];
    myTableView.frame = CGRectMake(0, kTopViewHeight, self.view.bounds.size.width, myTableViewH);
    myTableView.delegate = self;
    myTableView.dataSource =  self;
    myTableView.bounces = NO;
    myTableView.separatorInset = UIEdgeInsetsZero;
    myTableView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.sectionIndexColor = [UIColor grayColor];
    [self.view addSubview:myTableView];
    
    CGFloat friendTableViewH = self.view.frame.size.height-kTopViewHeight-TabBarHeight;
    friendTableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, kTopViewHeight, self.view.bounds.size.width, friendTableViewH))];
    friendTableView.delegate = self;
    friendTableView.dataSource =  self;
    friendTableView.hidden = YES;
    friendTableView.bounces = NO;
    friendTableView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    friendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    friendTableView.sectionIndexColor = [UIColor grayColor];
    [self.view addSubview:friendTableView];

}

#pragma mark BtnClick-----------
-(void)bannerBtnClick:(UIButton *)sender
{
    
    if (sender.tag==1) {
        
        myTableView.hidden = YES;
        friendTableView.hidden = NO;
        
    }else{
        
        myTableView.hidden = NO;
        friendTableView.hidden = YES;
        
    }
    
    button1.selected = NO;
    button2.selected = NO;
    button3.selected = NO;
    button4.selected = NO;
    sender.selected  = YES;
    
    switch (sender.tag) {
        case 0:
        {
            
            //统计消息点击
            [MobClick event:@"chat_history_click"];
            
            //点击了消息按钮
            _isAppearMessageList = YES;
            
            _selectedIndex = 0;
            
            //每次点击消息按钮都要刷新一次列表
            [self LoadConversations];
            
            //将搜索框隐藏
            searchView.hidden = YES;
            
            //将加号隐藏
            btn1.hidden = YES;
            
            //调整坐标
            CGFloat myTableViewH = self.view.frame.size.height-kTopViewHeight-TabBarHeight;
            myTableView.frame = CGRectMake(0, kTopViewHeight, 320, myTableViewH);
            
            //刷新表格
            [myTableView reloadData];
            
            
        }
            break;
        case 1:
        {
            
            //统计好友点击
            [MobClick event:@"chat_friend_click"];
            
            //没有显示消息列表
            _isAppearMessageList = NO;
            
            _selectedIndex = 1;
            
            //清除之前的搜索内容
            searchView.text = @"";
            
            //搜索框显示出来
            searchView.hidden = NO;
            
            //修改占位文字
            searchView.placeholder = @"搜索好友";
            
            //加号显示出来
            btn1.hidden = NO;
            
            //调整坐标
            [self setupTableViewFrameWithTableView:friendTableView];
            
            //刷新列表(自己独立出来建立一个有索引的好友表格)
            [friendTableView reloadData];
            
        }
            break;
        case 2:
        {
            
            //统计群组点击
            [MobClick event:@"chat_group_click"];
            
            //没有显示消息列表
            _isAppearMessageList = NO;
            
            _selectedIndex = 2;
            
            //清除之前的搜索内容
            searchView.text = @"";
            
            //搜索框显示出来
            searchView.hidden = NO;
            
            //修改占位文字
            searchView.placeholder = @"搜索群";
            
            //加号显示出来
            btn1.hidden = NO;
            
            //调整坐标
            [self setupTableViewFrameWithTableView:myTableView];
            
            [myTableView reloadData];
            
            
        }
            break;
        case 3:
        {
            
            //统计交流厅点击
            [MobClick event:@"chat_communicate_click"];
            
            _isAppearMessageList = NO;
            
            _selectedIndex = 3;
            
            //清除之前的搜索内容
            searchView.text = @"";
            
            //搜索框显示出来
            searchView.hidden = NO;
            
            //修改占位文字
            searchView.placeholder = @"搜索交流厅";
            
            //加号隐藏起来
            btn1.hidden = YES;
            
            //调整坐标
            [self setupTableViewFrameWithTableView:myTableView];
            
            //刷新列表
            [myTableView reloadData];
            
        }
            break;
            
        default:
            break;
    }
}

//后面三个按钮调整坐标
-(void)setupTableViewFrameWithTableView:(UITableView *)tableView{
    
    CGFloat myTableViewY = CGRectGetMaxY(searchView.frame)+SearchViewMargin;
    CGFloat myTableViewH = self.view.frame.size.height-myTableViewY-TabBarHeight;
    tableView.frame = CGRectMake(0,myTableViewY , 320, myTableViewH);
    
}

-(void)addBtn:(UIButton *)sender
{
    //原代码
    if (button2.selected == YES)
    {
        addGoodFriendViewController *goodFriend =[[addGoodFriendViewController    alloc]init];
        [self.navigationController pushViewController:goodFriend animated:YES];
    }
    if (button3.selected == YES) {
        addGroupViewController *add =[[addGroupViewController alloc]init];
        [self.navigationController pushViewController:add animated:YES];
    }
    
    
    
}

#pragma mark-EMChatManagerDelegate

//警告：离线消息表情没办法解析，在线消息可以
//    EMTextMessageBody *mbody = message.messageBodies[0];
//
//    NSString *text = mbody.text;
//
//    NSLog(@"text==%@",text);
//
//    return;

//账号在其它设备登录
- (void)didLoginFromOtherDevice
{
    //退出到登录页面代码
    
    //环信账户注销(一定要先注销，用户中心那里会以为现在还有用户再登录，就不会请求用户信息了，个人中心那里的数据就没办法修改了)
    EMError *error = nil;
    [[EaseMob sharedInstance].chatManager logoffWithError:&error];
    if (error) {
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"退出登录失败"];
        
    }else{
        
        //修改登录状态为没登录
        [[FDSUserManager sharedManager] setNowUserState:USERSTATE_NONE];
        
        //将用户ID置空
        [[FDSUserManager sharedManager] setNowUserIDEmpty];
        
        //清空账号即可
        [ZZUserDefaults setUserDefault:USER_COUNT    :nil];
        [ZZUserDefaults setUserDefault:USER_PASSWORD :nil];
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:[UIApplication sharedApplication].keyWindow MESSAGE:@"当前用户已在其他设备登录"];
        
        //登录页面
        PersonViewController *person = [[PersonViewController alloc]init];
        
        [self.navigationController pushViewController:person animated:YES];
        
    }
    
    //发送通知（被别人踢下来了）
    [[NSNotificationCenter defaultCenter]
     postNotificationName:LoginFromOtherDeviceKey object:nil];
    
}

//接收消息(这里接收的都不是在聊天页面里面的，到那边之后再添加)
-(void)didReceiveMessage:(EMMessage *)message{
    
    //播放音频（新消息提示）
    [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
    [[EaseMob sharedInstance].deviceManager playVibration];
    
    //直接将messageID存进去，到控制器以聊天被提取出来(from是用户名也是环信群ID)
    [[DataBaseSimple shareInstance] insertMessageidWithMessageid:message.messageId username:message.from];
    
    //重新加载会话列表
    [self LoadConversations];
    

}

//同意添加消息回调
-(void)addFriendsCB:(NSArray *)data{
    
    if (data.count!=0) {
        
        //将数组清空
        [_friendCellFrames removeAllObjects];
        
        //加载数据库，刷新列表
        [self LoadFriends];
        
        
    }else{
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"添加好友失败"];
        
    }
    
}

//接收到加群邀请
-(void)didReceiveGroupInvitationFrom:(NSString *)groupId inviter:(NSString *)username message:(NSString *)message error:(EMError *)error{
    NSLog(@"didReceiveGroupInvitationFrom");
    
}

//退出登录
-(void)loginOff{
    
    [[EaseMob sharedInstance].chatManager asyncLogoff];
    
}

-(void)didLogoffWithError:(EMError *)error{
    
    if (!error) {
        
        NSLog(@"退出登录成功");
        
    }else{
        
        NSLog(@"退出登录失败");
        
    }
    
}

//环信注册
-(void)HuanXinRegisterNewAccount{
    
    //发送注册消息
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:@"bg40"
                                                         password:@"banggood123"
                                                   withCompletion:
     ^(NSString *username, NSString *password, EMError *error) {
         
         
         if (!error) {
             
             NSLog(@"Registersucess");
             
         }else{
             
             NSLog(@"Registerfailed");
             
             switch (error.errorCode) {
                 case EMErrorServerNotReachable:
                     
                     NSLog(@"连接服务器失败!");
                     break;
                 case EMErrorServerDuplicatedAccount:
                     
                     NSLog(@"您注册的用户已存在!");
                     break;
                 case EMErrorServerTimeout:
                     
                     NSLog(@"连接服务器超时!");
                     break;
                 default:
                     
                     NSLog(@"注册失败");
                     break;
             }
         }
     } onQueue:nil];
    
}

#pragma mark tabelViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (button1.selected==YES){
        
        return 2;
        
    }else if (button2.selected==YES){
        
        return _friendCellFrames.count;
        
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = 0;
    
    //根据按钮的状态来决定用哪个数据源
    if (button1.selected) {
        
        if (section==0) {
            
            count = 1;
            
        }else{
            
            count = [_messageCellFrames count];
            
        }
        
    } else if(button2.selected) {
        
        //count = [_friendCellFrames count];
        count = [[_friendCellFrames objectAtIndex:section] count];
        
    } else if(button3.selected) {
        
        count = [_crowdCellFrames count];
        
    } else if(button4.selected) {
        
        count = [_tempCrowdCellFrames count];
        
    }
    
    return count;
    
}

//####################################################

//取出对应section的标题，如果没有元素则不显示
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *title = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    
    if ([[_friendCellFrames objectAtIndex:section] count]) {
        
        return [NSString stringWithFormat:@"  %@",title];
        
    }
    
    return nil;
    
}

//每一行标题的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (button2.selected) {
        return [[_friendCellFrames objectAtIndex:section] count] ? tableView.sectionHeaderHeight : 0;
    }
    
    return 0;
    
}

//将要展示的HeaderView的回调
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    //颜色
    view.tintColor = [UIColor colorWithRed:201/255.0 green:202/255.0 blue:201/255.0 alpha:1.0];

    // 字体颜色
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
}

//索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    NSArray *titles = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
    
    //返回一个没有＃的数组
    if (tableView==friendTableView) {
        
        //只有是好友列表才有索引
        return [self tempArrayWithArray:titles];
        
    }
    
    return nil;
    
}

//返回一个没有＃的数组
-(NSMutableArray *)tempArrayWithArray:(NSArray *)titles{
    
    int titlesCount = (int)titles.count;
    NSMutableArray *tempTitles = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < titles.count; i++) {
        if (i != titlesCount-1) {
            
            NSString *title = titles[i];
            
            [tempTitles addObject:title];
        }
    }
    return tempTitles;
}

//返回用户点击到的第几个索引
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

//####################################################

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier0 = @"notificationCell";
    static NSString *identifier1 = @"CellOne";
    static NSString *identifier2 = @"CellTwo";
    static NSString *identifier3 = @"CellThree";
    static NSString *identifier4 = @"CellFour";
    
    if (button1.selected==YES)
    {
        if (indexPath.section==0) {
            
            BaseCell *notificationCell = [tableView dequeueReusableCellWithIdentifier:identifier0];
            
            if (!notificationCell)
            {
                notificationCell = [[BaseCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier0];
                notificationCell.cellType=CellTypeNotification;
            }
            
            BaseCellFrame *baseFrame = [[BaseCellFrame alloc] init];
            
            //设置frame的类型
            baseFrame.cellFrameType=CellFrameTypeNotification;
            
            notificationCell.cellFrame = baseFrame;
            
            [self addDividerBottomWithCell:notificationCell indexPath:indexPath];
            
            return notificationCell;
            
        }
        
        InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell) {
            
            cell = [[InfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
            
        }
        
        cell.cellFrame = _messageCellFrames[indexPath.row];
        
        [self addDividerBottomWithCell:cell indexPath:indexPath];
        
        return cell;
        
    }
    else if(button2.selected == YES)
    {
        FriendCell* friendCell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if(friendCell==nil) {
            friendCell = [[FriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
            //代理，删除好友的
            friendCell.delegate = self;
            
            //底部加线
            [self addDividerBottomWithCell:friendCell indexPath:indexPath];
            
        }
        
        NSArray *tempFriends = _friendCellFrames[indexPath.section];
        
        friendCell.cellFrame = tempFriends[indexPath.row];
        
        return friendCell;
    }
    
    
    else if(button3.selected == YES)
    {
        BaseCell *crowedCell = [tableView dequeueReusableCellWithIdentifier:identifier3];
        if (!crowedCell)
        {
            crowedCell = [[BaseCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier3];
        }
        
        if (_crowdCellFrames.count!=0 && indexPath.row<_crowdCellFrames.count) {
            
            crowedCell.cellFrame =_crowdCellFrames[indexPath.row];
            
        }
        
        [self addDividerBottomWithCell:crowedCell indexPath:indexPath];
        
        return crowedCell;
    }
    
    BaseCell *tempCrowedCell = [tableView dequeueReusableCellWithIdentifier:identifier4];
    if (!tempCrowedCell)
    {
        tempCrowedCell = [[BaseCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier4];
    }
    
    if (_tempCrowdCellFrames.count!=0 && indexPath.row<_tempCrowdCellFrames.count) {
        
        tempCrowedCell.cellFrame = _tempCrowdCellFrames[indexPath.row];
        
        
    }
    
    
    [self addDividerBottomWithCell:tempCrowedCell indexPath:indexPath];
    
    return tempCrowedCell;
    
}

//添加底部分割线
-(void)addDividerBottomWithCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    UIView *divider = [[UIView alloc] init];
    
    divider.backgroundColor = DividerColor;
    
    divider.frame = DividerFrameZero;
    
    
    [cell addSubview:divider];
    
}

//添加底部分割线
-(void)addDividerTopWithCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    UIView *divider = [[UIView alloc] init];
    
    divider.backgroundColor = DividerColor;
    
    divider.frame = DividerFrameTop;
    
    
    [cell addSubview:divider];
    
}

//取消选中效果
-(void)tableViewDeSelect:(UITableView*)table
{
    NSIndexPath* indexPath = [table indexPathForSelectedRow];
    [table deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //取消选中效果
    [self tableViewDeSelect:tableView];
    
    
    //好友列表
    if (button2.selected) {
        
        //里面的东西全部分组了
        NSArray *tempFriends = _friendCellFrames[indexPath.section];

        //取出frame
        FriendCellFrame *frame = tempFriends[indexPath.row];
        
        //取出模型
        FriendCellModel *model = (FriendCellModel *)frame.model;
        
        //取出userid
        NSString *userid = model.userid;
        
        //拼接用户名
        NSString *username = [NSString stringWithFormat:@"bg%@",userid];
        
        liaoTianViewController *lv = [[liaoTianViewController alloc] init];
        
        //设置聊天类型
        lv.chatType = ChatTypeSingle;
        
        //取得userid（聊天页面点击头像用到）
        lv.userid = model.userid;
        
        //取得用户名
        lv.username = username;
        
        lv.friendname = model.name;
        
        //取得用户头像
        lv.icon = model.image;
        
        
        [self.navigationController pushViewController:lv animated:YES];

    }else if (button3.selected){
        
        //取出frame
        BaseCellFrame *fixFrame = _crowdCellFrames[indexPath.row];
        
        //取出模型
        BaseCellModel *fixModel = fixFrame.model;
        
        //记录下群名称
        _hxgroupidSelected = fixModel.hxgroupid;
        
        //记录下群类型
        _grouptype = fixModel.grouptype;
        
        //记录下群名称
        _groupname = fixModel.name;
        
        //记录下roomid
        _roomid = fixModel.roomid;
        
        NSArray *members = [[DataBaseSimple shareInstance] selectMembersWithHxgroupid:fixModel.hxgroupid];

        
        if (members.count==0) {
            
            //爆菊花
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            
            //发送获取群成员列表消息
            [[PlatformMessageManager sharedManager] requestGroupMembersWithRoomid:fixModel.roomid];
            
        }else{
            
            //后台开启一个线程刷新群成员数据
            [self performSelectorInBackground:@selector(threadRequestGroupMembersWithRoomid:) withObject:fixModel.roomid];
            
            [self pushToChatViewControllerWithMembers:members];
            
        }
        
    }else if (button4.selected){
        
        //取出frame
        BaseCellFrame *tempFrame = _tempCrowdCellFrames[indexPath.row];
        
        //取出模型
        BaseCellModel *tempModel = tempFrame.model;
        
        //记录下群名称
        _hxgroupidSelected = tempModel.hxgroupid;
        
        //记录下roomid
        _roomid = tempModel.roomid;
        
        //记录下群类型
        _grouptype = tempModel.grouptype;
        
        //记录下群名称
        _groupname = tempModel.name;
        
        NSArray *members = [[DataBaseSimple shareInstance] selectMembersWithHxgroupid:tempModel.hxgroupid];
        
        
        if (members.count==0) {
            
            //爆菊花
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            
            //发送获取群成员列表消息
            [[PlatformMessageManager sharedManager] requestGroupMembersWithRoomid:tempModel.roomid];
            
        }else{
            
            //后台开启一个线程刷新群成员数据
            [self performSelectorInBackground:@selector(threadRequestGroupMembersWithRoomid:) withObject:tempModel.roomid];
            
            [self pushToChatViewControllerWithMembers:members];
            
        }
        
    }else if (button1.selected){
        
        if (indexPath.section==0) {
            
            //这两个数组通知为0，才是没有通知
            if ([FDSUserManager sharedManager].messages.count==0) {
                
                //提示框
                [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"暂时没有通知"];
                return;
                
            }
            
            NotificationViewController *nv = [[NotificationViewController alloc] init];
            
            for (NotificationFrame *tempFrame in [FDSUserManager sharedManager].messages) {
                
                [nv.messages addObject:tempFrame];
                
            }

            [self.navigationController pushViewController:nv animated:YES];

            
        }else{//下面的会话对象
            
            //取出frame
            InfoCellFrame *frame = _messageCellFrames[indexPath.row];
            
            //取出模型
            InfoCellModel *model = (InfoCellModel *)frame.model;
            
            //如果是群模型
            if (model.infoModelType==InfoModelTypeGroup) {
                
                //记录下群名称
                _hxgroupidSelected = model.hxgroupid;
                
                //记录下roomid
                _roomid = model.roomid;
                
                //记录下群类型
                _grouptype = model.grouptype;
                
                //记录下真正的群名称
                _groupname = model.name;
                
                NSArray *members = [[DataBaseSimple shareInstance] selectMembersWithHxgroupid:model.hxgroupid];
                
                
                if (members.count==0) {
                    
                    //爆菊花
                    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
                    
                    //发送获取群成员列表消息
                    [[PlatformMessageManager sharedManager] requestGroupMembersWithRoomid:model.roomid];
                    
                }else{
                    
                    //后台开启一个线程刷新群成员数据
                    [self performSelectorInBackground:@selector(threadRequestGroupMembersWithRoomid:) withObject:model.roomid];
                    
                    [self pushToChatViewControllerWithMembers:members];
                    
                }
                
                return;//立即返回，不执行下面的代码
                
            }
            
            liaoTianViewController *lv = [[liaoTianViewController alloc] init];

            //取出userid
            NSString *userid = model.userid;
            
            //拼接用户名
            NSString *username = [NSString stringWithFormat:@"bg%@",userid];
            
            
            //设置聊天类型
            lv.chatType = ChatTypeSingle;
            
            //取得用户名
            lv.username = username;
            
            lv.friendname = model.name;
            
            //取得用户头像
            lv.icon = model.image;
            
            //取得userid
            lv.userid = model.userid;
            
            [self.navigationController pushViewController:lv animated:YES];

            
            
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark uitextfiedDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [searchView resignFirstResponder];
    
    if (_selectedIndex==1) {
        
        [self LoadFriendsWithkeyWord:searchView.text];
        
    }else if (_selectedIndex==2){
        
        [self LoadFixroomsWithKeyword:searchView.text];
        
    }else if(_selectedIndex==3){
        
        [self LoadTempGroupWithKeyword:searchView.text];
        
    }
    
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //输入框没有内容的时候会调用一次，当开始打入第二个字的时候也会调用一次
    if (textField.text.length==1) {
        
        if (_selectedIndex==1) {
            
            [self LoadFriends];
            
        }else if (_selectedIndex==2){
            
            [self LoadFixrooms];
            
        }else if(_selectedIndex==3){
            
            [self LoadTempGroup];
            
        }
        
        
        
    }
    
    
    return YES;
    
}

//简化代码，抽出重复代码
-(UIButton*) addButtonWithFrame:(CGRect)frame  withTag:(int)tag{
    
    UIButton* button = nil;
    button = [[UIButton alloc]initWithFrame:frame];
    button.tag = tag;
    
    [button setBackgroundImage:[UIImage imageNamed:@"顶部通用背景"] forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:@"background_08"] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button setTitle:arr[tag] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [button addTarget:self action:@selector(bannerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bannerView addSubview:button];
    return button;
}

-(void)initData {
    
    // 模拟临时群的数据源
    for(int i=0; i<3;i++) {
        BaseCellModel* model = [[BaseCellModel alloc]init];
        model.name = @"启明星组委会";
        model.detail= @"当我们感到无力是因为我们没有看到彼此";
        model.image = [self createAImageName];
        BaseCellFrame* cellFrame = [[FriendCellFrame alloc]init];
        cellFrame.model = model;
        [_tempCrowdCellFrames addObject:cellFrame];
    }
    
    
    
}

-(NSString*)createAImageName {
    int i = arc4random()%6;
    NSString* str = [NSString stringWithFormat:@"%d.png",i];
    return str;
}

//好友列表回调
-(void)requestContactListCB:(NSDictionary *)data{
    
    //取出所有会话
    NSArray *conversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabase];
    
    //会话里面的用户ID数组
    NSMutableArray *conUserids = [[NSMutableArray alloc] init];
    
    //会话里面的群ID数组
    NSMutableArray *conHxgroupids = [[NSMutableArray alloc] init];
    
    //返回的数据里面的用户ID数组
    NSMutableArray *newUserids = [[NSMutableArray alloc] init];
    
    //返回的数据里面的群ID数组
    NSMutableArray *newHxgroupids = [[NSMutableArray alloc] init];
    
    //取出所有用户名
    for (EMConversation *conversation in conversations) {
        
        
        //取出用户名
        NSString *username = conversation.chatter;
        
        //将群的username过滤掉
        if ([username hasPrefix:@"bg"]) {
            
            //用户名转换成userid
            NSString *userid = [username stringByReplacingOccurrencesOfString:@"bg" withString:@""];
            
            if (![userid isEqualToString:@"0"]) {
                
                //添加进数组
                [conUserids addObject:userid];
                
            }
            
            
        }else{
            
            //群组ID
            [conHxgroupids addObject:username];
            
        }
        
        
    }
    
    //取出分组数组
    NSArray *groups = data[@"groups"];
    
    //目前只有一组好友，取出第一个
    NSDictionary *group =nil;
    
    if (groups.count!=0) {
        
      group = groups[0];
        
    }
    
    
    //好友字典数组
    NSArray *items = group[@"items"];
    
    //先把数组清空
    [_friendCellFrames removeAllObjects];
    
    //插入数据库之前，一定要清楚数据库好友数据
    [[DataBaseSimple shareInstance] deleteFriends];
    
    //索引排序类
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    
    //创建一个装好友模型的数组
    NSMutableArray *friendOrderModels = [NSMutableArray array];
    
    for (NSDictionary *dic in items) {
        
        FriendCellModel *friendModel = [[FriendCellModel alloc] initWithDic:dic];
        
        //记录下每个模型属于哪一组
        friendModel.section = [theCollation sectionForObject:friendModel collationStringSelector:@selector(name)];
        
        //插入数据到数据库(不用做判断，因为里面做了过滤处理)
        [[DataBaseSimple shareInstance] insertFriendswithModel:friendModel];
        
        //添加到数组
        [friendOrderModels addObject:friendModel];
        
        //添加最新的用户ID进数组，下面遍历对象
        [newUserids addObject:friendModel.userid];
        
    }
    
    //构建小秘书模型并加入数组
    FriendCellModel *systemModel = [self getSystemModelWithCollation:theCollation];
    [friendOrderModels addObject:systemModel];
    
    //对传过去的数组进行排序
    [self sortFriendsWithArray:friendOrderModels];

    
    //遍历会话的userid，看在不在最新的userid里面，如果不在，删除该会话
    for (NSString *conUserid in conUserids) {
        
        //是否存在这个用户ID（如果群的ID也在里面，肯定不存在里面，会被删除掉群会话的）
        BOOL isContain = [newUserids containsObject:conUserid];
        
        //如果不存在说明已经被删除了，就删除该会话和messageid
        if (!isContain) {
            
            //拼接用户名
            NSString *deleteUsername = [NSString stringWithFormat:@"bg%@",conUserid];
            
            //删除离线删除的会话和messageid，数据库不用删除了，全部好友数据已经清空了
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:deleteUsername deleteMessages:YES];
            [[DataBaseSimple shareInstance] deleteMessageidWithUsername:deleteUsername];
        }
        
    }
    
    //取出群数组
    NSArray *fixrooms = data[@"fixrooms"];
    
    //先把数组清空
    [_crowdCellFrames removeAllObjects];
    [_tempCrowdCellFrames removeAllObjects];
    
    //插入之前，全部群数据要删除
    [[DataBaseSimple shareInstance] deleteGroups];
    
    //将字典数组转换成模型数组
    for (NSDictionary *fixDic in fixrooms) {
        
        BaseCellModel *fixModel = [[BaseCellModel alloc] initWithDic:fixDic];
        
        BaseCellFrame* cellFrame = [[FriendCellFrame alloc]init];
        cellFrame.model = fixModel;
        
        //设置群类型，到了里面好区分群和好友到默认图片
        cellFrame.cellFrameType=CellFrameTypeGroup;
        
        //插入群数据库
        [[DataBaseSimple shareInstance] insertGroupsWithModel:fixModel];
        
        //将新拿回来的数组ID放进数组里面跟会话进行比较
        [newHxgroupids addObject:fixModel.hxgroupid];
        
        //0:固定群／1:临时群
        if ([fixModel.grouptype intValue]==1) {

            [_tempCrowdCellFrames addObject:cellFrame];
            
        }else{
            
            [_crowdCellFrames addObject:cellFrame];
            
        }
        
    }
    
    //遍历会话的conHxgroupid，看在不在最新的newHxgroupids里面，如果不在，删除该会话
    for (NSString *conHxgroupid in conHxgroupids) {
        
        //是否存在这个用户ID（如果群的ID也在里面，肯定不存在里面，会被删除掉群会话的）
        BOOL isContain = [newHxgroupids containsObject:conHxgroupid];
        
        //如果不存在说明已经被删除了，就删除该会话和messageid
        if (!isContain) {
            
            //conHxgroupid就是username了，不用拼接
            //删除离线删除的会话和messageid，数据库不用删除了，全部群数据已经清空了
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:conHxgroupid deleteMessages:YES];
            
            [[DataBaseSimple shareInstance] deleteMessageidWithUsername:conHxgroupid];
        }
        
    }
    
    //每次都要刷新会话列表，有可能被好友在线删除了，会话对象还在内存里
    [self LoadConversations];
    
    //刷新列表
    [myTableView reloadData];
    
}

//返回一个小秘书模型
-(FriendCellModel *)getSystemModelWithCollation:(UILocalizedIndexedCollation *)collation{
    
    FriendCellModel *systemModel = [[FriendCellModel alloc] init];
    
    systemModel.userid = @"0";
    systemModel.name = @"小秘书";
    systemModel.section = [collation sectionForObject:systemModel collationStringSelector:@selector(name)];
    
    //插入数据库
    [[DataBaseSimple shareInstance] insertFriendswithModel:systemModel];
    
    return systemModel;
    
}

-(void)sortFriendsWithArray:(NSMutableArray *)friendOrderModels{
    
    //索引排序类
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    
    //创建一个装有所有Section数组的数组
    NSInteger highSection = [[theCollation sectionTitles] count];
    
    //设置一个26个元素的数组
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    
    //初始化所有的26个section数组
    for (int i=0; i<highSection; i++)
    {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    //将相应的模型放到相应的数组
    for (FriendCellModel* orderModel in friendOrderModels)
    {
        
        [(NSMutableArray *)[sectionArrays objectAtIndex:orderModel.section] addObject:orderModel];
        
    }
    
    //对每个section数组内部元素进行排序
    for (NSMutableArray *sectionArray in sectionArrays)
    {
        
        //得到排序后的数组
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        for (FriendCellModel *tempModel in sortedSection) {
            
            //构建排好顺序的frame数组
            FriendCellFrame* cellFrame = [[FriendCellFrame alloc]init];
            cellFrame.model = tempModel;
            [tempArray addObject:cellFrame];
            
        }
        
        [_friendCellFrames addObject:tempArray];
        
    }
    
    
}

//获取群成员回调(如果是线程回调的时候，已经去到聊天控制器了，不会回调这里了，不需要区分)
-(void)requestGroupMembersCB:(NSArray *)data{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    for (FriendCellModel *model in data) {
        
        //插入数据库
        [[DataBaseSimple shareInstance] insertMemberWithModel:model hxgroupid:_hxgroupidSelected];
        
    }
    
    [self pushToChatViewControllerWithMembers:data];
    
    
}


-(void)pushToChatViewControllerWithMembers:(NSArray *)members{
    
    liaoTianViewController *lv = [[liaoTianViewController alloc] init];
    
    //设置聊天类型
    if ([_grouptype intValue]==0) {
        
        lv.chatType = ChatTypeGroupRegular;
        
    }else{
        
        lv.chatType = ChatTypeGroupTemp;
        
    }
    
    
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

-(void)refreshTableView{
    
    //刷新列表
    [myTableView reloadData];
    
}

#pragma mark-FriendCellDelegate

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

-(void)friendPersontap:(NSString *)userid{
    
    [MobClick event:@"namecard_friend_click"];
    
    _personTapUserid = userid;
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //获取个人资料
    [[FDSUserCenterMessageManager sharedManager] userRequestUserInfo:userid];
    
    //不是用户本身的
    [FDSUserCenterMessageManager sharedManager].userInfoType=UserInfoTypeOtherUserInfo;
    
}

-(void)deleteGoodFriendWithUserid:(NSString *)userid{
    
    //检测是否有网络
    BOOL isExistenceNetwork = [self isConnectionAvailable];
    
    if (!isExistenceNetwork) {
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"网络未连接"];
        return;
        
    }
    
    //不能干掉小秘书
    if ([userid isEqualToString:@"0"]) {
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"不可删除小秘书"];
        return;
    }
    
    //记录下要删除的userid(回调要用到)
    _deleteUserid = userid;
    
    //拼接用户名
    NSString *username = [NSString stringWithFormat:@"bg%@",userid];
    
    //发送环信删除好友消息前，设定布尔值,在更新列表过滤
    [FDSUserManager sharedManager].isAddAndDeleteByHX=YES;
    
    //发送环信移除好友消息
    EMError *error = nil;
    
    BOOL isRemove = [[EaseMob sharedInstance].chatManager removeBuddy:username removeFromRemote:YES error:&error];
    
    if (isRemove) {
        
        //发送炫能移除消息
        [[PlatformMessageManager sharedManager] deleteGoodfriendWithUserids:@[userid]];
    }else{
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"移除好友失败"];
        
    }
    
    
    
}

//删除好友回调
-(void)deleteGoodfriendCB:(int)result{
    
    if (result==0) {
        
        //数据库移除用户
        [[DataBaseSimple shareInstance] deleteFriendswithUserid:_deleteUserid];
        
        //拼接用户名
        NSString *username = [NSString stringWithFormat:@"bg%@",_deleteUserid];
        
        //将相关的会话对象和messageID去掉(不再判断了，没去掉算了)
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:username deleteMessages:YES];
        [[DataBaseSimple shareInstance] deleteMessageidWithUsername:username];
        
        //提示框（被好友删除不显示）
        if (![FDSUserManager sharedManager].isDeleteByGoodFriend) {
            
            [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"移除好友成功"];
            
        }
        
        
        //将数组清空
        [_friendCellFrames removeAllObjects];
        
        //重新加载数据库
        [self LoadFriends];
        
        
    }else{
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"移除好友失败"];
        
    }
    
}

//刷新群列表
-(void)refreshGroupList{
    
    //刷新群组
    [self LoadFixrooms];
    
    //刷新交流厅列表
    [self LoadTempGroup];
    
    //也要刷新会话列表（如果此时是在消息列表的话要刷新）
    [self LoadConversations];
}

//刷新好友列表
-(void)refreshFriendsList{
    
    [self LoadFriends];
    
    [self LoadConversations];
    
}

-(void)isPushChatNotification{
    
    [self bannerBtnClick:button1];
    
}

//从线程更新群成员数据
-(void)threadRequestGroupMembersWithRoomid:(NSString *)roomid{
    
    [[PlatformMessageManager sharedManager] requestGroupMembersWithRoomid:roomid];
    
}

//个人信息回调
-(void)getUserInfoCB:(NSDictionary *)dic{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if ([FDSUserCenterMessageManager sharedManager].
        userInfoType==UserInfoTypeOtherUserInfo) {
        
        PersonlCardViewController *pv = [[PersonlCardViewController alloc] init];
        pv.userDic = dic;
        pv.userid = _personTapUserid;
        
        [self.navigationController pushViewController:pv animated:YES];
        
    }
    
    
}

-(void)dealloc{
    
    //删除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DisbandGroupKey object:nil];
    
    //删除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:didLeaveFromGroup object:nil];
    
    //删除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:didAcceptedByFriend object:nil];
    
    //删除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"requestContactDataAgain" object:nil];
    
    //删除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SetupMessageBadgeCountKey object:nil];
    
}

@end
