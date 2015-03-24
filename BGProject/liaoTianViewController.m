//
//  liaoTianViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-29.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//   


#import "liaoTianViewController.h"
#import "AppDelegate.h"
#import "constants.h"
#import "BGUser.h"
#import "FDSUserManager.h"
#import "FDSPublicManage.h"
#import "ChatItem.h"
#import "ChatCell.h"
#import "EaseMob.h"
#import "ChatItemFrame.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "DXFaceView.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "ChatMoreView.h"
#import "ZZUserDefaults.h"
#import "ChatTooBar.h"
#import "GroupInfoViewController.h"
#import "DataBaseSimple.h"
#import "PlatformMessageManager.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "PersonlCardViewController.h"

#define kMessageListViewColor     COLOR(231, 231, 231, 1)


//toobar高度
#define ToobarHeight 44

@interface liaoTianViewController ()<UITableViewDelegate,UITableViewDataSource,IChatManagerDelegate,FacialViewDelegate,ChatTooBarDelegate,ChatMoreViewDelegate,DXFaceDelegate,PlateformMessageInterface,MJRefreshBaseViewDelegate,ChatCellDelegate,UserCenterMessageInterface>

@end

@implementation liaoTianViewController
{
    
    //表情测试
    DXFaceView *_faceView;
    
    //协助下拉键盘的背景图
    __weak UIView *_keyboardBackView;
    
    //本地发送图片的对象
    EMImageMessageBody *_imageBody;
    
    //发送框
    ChatTooBar *_toolBar;
    
    //工具条更多
    ChatMoreView *_chatMoreView;
    
    //群图标
    __weak UIButton *_groupButton;
    
    //聊天记录请求开始标记
    int _requestRecordTag;
    
    //请求个数
    int _requestCount;
    
    //下拉刷新
    MJRefreshHeaderView *_header;
    
    //头像点击记录下userid
    NSString *_personTapUserid;
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

//获取聊天记录
-(void)gainMessageLog{
    
    //初始化消息数组
    self.messageList = [[NSMutableArray alloc] init];
    
    //获取会话对象
    EMConversation *conversation = [self getConversation];
    
    //记录里面的全部设置为已读的(进来之后全部设置为已读)
    [conversation markAllMessagesAsRead:YES];
    
    
    //删除某个会话对象
//    [[EaseMob sharedInstance].chatManager removeConversationByChatter:@"1419403794611240" deleteMessages:YES];
//    NSArray *conversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabase];
    
    //取出messageIDs数组
    NSArray *messageIDs = [self getMessageidsWithIsFirstRequest:YES];
    
    //通过messageIDs获得聊天记录
    NSArray *messages = [conversation loadMessagesWithIds:messageIDs];
    
    //解析EMMessage
    for (EMMessage *msg in messages) {
        
        //调用接收消息的回调，那里可以解析数据并添加到数组
        [self analysisEMMessageWithMessage:msg messageType:MessageTypeRecord];
        
    }
    
}

//获取会话对象
-(EMConversation *)getConversation{
    
    EMConversation *conversation = nil;
    
    if (self.chatType==ChatTypeSingle) {
        
        conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.username isGroup:NO];
        
    }else{
        //一定要区分是否是群，否则它里面的未读消息数量不减
        conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.username isGroup:YES];
        
    }
    
    return conversation;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    //隐藏table bar
    AppDelegate  *app = [UIApplication sharedApplication].delegate;
    [app hiddenTabelBar];
    
    [[PlatformMessageManager sharedManager] registerObserver:self];
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
    
    //监听键盘
    [self observeKeyboard];
    
    //刷新群成员的数据
    self.members = nil;
    self.members = [[DataBaseSimple shareInstance] selectMembersWithHxgroupid:self.username];

}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    
    
    [[PlatformMessageManager sharedManager] unRegisterObserver:self];
    [[FDSUserCenterMessageManager sharedManager] unRegisterObserver:self];
    
    //监听键盘
    [self RemoveObserveKeyboard];
    
}
#pragma mark-下拉刷新数据
-(void)setupRefreshHeaderView{
    
    //集成下拉刷新控件
    _header = [MJRefreshHeaderView header];
    _header.scrollView = messageListView;
    _header.delegate = self;
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    
    if (refreshView == _header) { // 下拉刷新

        //获取会话对象
        EMConversation *conversation = [self getConversation];
        
        //记录里面的全部设置为已读的(进来之后全部设置为已读)
        [conversation markAllMessagesAsRead:YES];
        
        //取出messageIDs数组
        NSArray *messageIDs = [self getMessageidsWithIsFirstRequest:NO];
        
        //通过messageIDs获得聊天记录
        NSArray *tempMessages = [conversation loadMessagesWithIds:messageIDs];
        
        //将数组逆序插入
        NSMutableArray *messages = [[NSMutableArray alloc] init];
        
        for (int i = tempMessages.count-1;i>=0; i--) {
            
            [messages addObject:tempMessages[i]];
            
        }
        
        //解析EMMessage
        for (EMMessage *msg in messages) {
            
            //调用接收消息的回调，那里可以解析数据并添加到数组
            ChatItemFrame *frame = [self convertEMMessage:msg];
            //将模型加进数组
            [self.messageList insertObject:frame atIndex:0];
            
        }
        
        //2秒后刷新表格
        [self performSelector:@selector(reloadDeals) withObject:nil afterDelay:2];
    }
}

//将模型转换成frame
-(ChatItemFrame *)convertEMMessage:(EMMessage *)message{
    
    //取出消息数组
    NSArray *bodies = message.messageBodies;
    
    //取出文本对象
    EMTextMessageBody *body = bodies[0];
    
    //初始化ChatItem
    ChatItem *chatItem = [[ChatItem alloc] init];
    
    
    if (body.messageBodyType==eMessageBodyType_Text) {
        
        NSString *text = body.text;
        
        //将文本＋表情转换成字符串
        NSString *willSendText = [ConvertToCommonEmoticonsHelper convertToSystemEmoticons:text];
        //内容
        chatItem.content = willSendText;
        
    }else if (body.messageBodyType==eMessageBodyType_Image){
        
        //将文本转换成图片类型
        EMImageMessageBody *imageBody = (EMImageMessageBody *)body;
        
        //判断是否是自己发出的
        if ([message.from isEqualToString:[self getUsername]]) {
            
            //获取预览图的本地路径
            chatItem.localPath = imageBody.localPath;
            
            //预览图的尺寸(如果是自己发出的要将尺寸减半才行)
            CGFloat thumbnailW = imageBody.thumbnailSize.width*0.5;
            CGFloat thumbnailH = imageBody.thumbnailSize.height*0.5;
            CGSize tempThumSize = CGSizeMake(thumbnailW, thumbnailH);
            chatItem.thumbnailSize=tempThumSize;
            
        }else{//不是自己发出的（解密后已经再本地了，也用本地路径）
            
            //获得预览图的服务器路径
            chatItem.localPath = imageBody.localPath;
            
            //预览图的尺寸
            chatItem.thumbnailSize=imageBody.thumbnailSize;
            
        }
        
        //模型类型
        chatItem.type = TypeImage;
        
    }else if (body.messageBodyType==eMessageBodyType_Voice){
        
        //模型类型
        chatItem.type = TypeVoice;
        
        //取出语音对象
        EMVoiceMessageBody *body = bodies[0];
        
        NSURL *voiceUrl = nil;
        
        NSData *voiceData = nil;
        
        if ([message.from isEqualToString:[self getUsername]]) {
            
            voiceData = [[NSData alloc] initWithContentsOfFile:body.localPath];
            
        }else{
            
            //获取服务器的URL
            voiceUrl = [[NSURL alloc] initWithString:body.remotePath];
            
            voiceData = [[NSData alloc] initWithContentsOfURL:voiceUrl];
            
        }
        
        //生成EMChatVoice对象
        EMChatVoice *voice = [[EMChatVoice alloc] initWithData:voiceData displayName:body.displayName];
        
        //模型获取语音对象
        chatItem.voice=voice;
        
        
    }else{
        
        //内容
        chatItem.content = @"[数据无法解析]";
        
    }
    
    //如果来源不是这个用户名，说明不是自身发出的
    if ([message.from isEqualToString:[self getUsername]]) {
        
        //是否为自己发出
        chatItem.isSelf = YES;
        //头像
        chatItem.icon = [self getUserImage];
        
        //取得当前登录用户的userid
        chatItem.userid = [[FDSUserManager sharedManager] NowUserID];
        
    }else{
        
        //是否为自己发出
        chatItem.isSelf = NO;
        
        //头像
        if (self.chatType==ChatTypeSingle) {
            
            chatItem.icon = self.icon;
            
            chatItem.userid = self.userid;
            
        }else{
            
            //群聊需要通过groupSenderName获取对应的头像
            chatItem.icon = [self getMemberPhotoWithFrom:message.groupSenderName];
            
            //解析出userid
            chatItem.userid = [message.groupSenderName stringByReplacingOccurrencesOfString:@"bg" withString:@""];
            
        }
        
    }
    
    //将模型转换成frame
    ChatItemFrame *frame = [[ChatItemFrame alloc] initWithChatItem:chatItem];
    
    return frame;
    
}

//刷新表格
- (void)reloadDeals
{
    [messageListView reloadData];
    // 结束刷新状态
    [_header endRefreshing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //注册通知(当一个语音点击的时候通知其他cell要将GIF图删掉)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshMessageListView)
                                                 name:ClearChatHistoryKey object:nil];
    
    
    //获取聊天消息记录(viewDidLoad只调用一次)
    [self gainMessageLog];

    //导航栏／工具条／聊天列表
    [self CreatView];
    
    [self setupRefreshHeaderView];
    
    //注册环信代理接收消息
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
}


-(void)CreatView
{
    //添加导航栏
    [self addTopBar];
    
    //创建显示聊天列表
    [self addMessageListView];
    
    //添加聊天工具条
    [self addToolBar];

}


#pragma mark 界面搭建 
// 最上方类似于导航栏的界面
-(void) addTopBar {
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    [self.view addSubview:topView];
    
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-80)*0.5, 24, 80, 40)];
    if (self.chatType==ChatTypeSingle) {
        
        label1.text = self.friendname;
        
    }else{
        
        label1.text = self.groupname;
        
    }
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    //群图标
    UIButton *groupButton = [[UIButton alloc] init];
    CGFloat groupW = 30;
    CGFloat groupH = 30;
    CGFloat groupX = self.view.bounds.size.width-groupW-20;
    CGFloat groupY = (44-groupH)*0.5+20;
    groupButton.frame = CGRectMake(groupX, groupY, groupW, groupH);
    [groupButton setImage:[UIImage imageNamed:@"group"] forState:UIControlStateNormal];
    [groupButton addTarget:self action:@selector(groupButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //群聊显示
    if (!self.chatType==ChatTypeSingle) {
        
        groupButton.hidden = NO;
        
    }else{
        
        groupButton.hidden = YES;
        
    }
    [topView addSubview:groupButton];
    _groupButton = groupButton;
    
}

-(void)addMessageListView {
    
    //聊天列表
    CGFloat messageListX = 0;
    CGFloat messageListY = kTopViewHeight;
    CGFloat messageListW = self.view.bounds.size.width;
    CGFloat messageListH = self.view
    .bounds.size.height-kTopViewHeight-ToobarHeight;
    
    messageListView = [[UITableView alloc] init];
    messageListView.frame = CGRectMake(messageListX, messageListY, messageListW, messageListH);
    [messageListView setBackgroundColor:kMessageListViewColor];
    messageListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    messageListView.delegate=self;
    messageListView.dataSource=self;
    [self.view addSubview:messageListView];
    

}

-(void)addToolBar {
    
    //发送框
    CGFloat toolBarX=0;
    CGFloat toolBarW = self.view.bounds.size.width;
    CGFloat toolBarH = ToobarHeight;
    CGFloat toolBarY = self.view.bounds.size.height-ToobarHeight;
    _toolBar = [[ChatTooBar alloc]initWithFrame:CGRectMake(toolBarX,toolBarY, toolBarW, toolBarH)];
    _toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _toolBar.delegate=self;
    [self.view addSubview:_toolBar];
    
    //初始化表情View
    _faceView = [[DXFaceView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 216, 320, 216)];
    _faceView.delegate=self;
    
    //初始化chatMoreView
    _chatMoreView = [[ChatMoreView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-160, self.view.frame.size.width, 160)];
    _chatMoreView.delegate = self;
    
    
}

#pragma mark-群图标被点击
-(void)groupButtonClick{
    
    GroupInfoViewController *gv = [[GroupInfoViewController alloc] init];
    
    //获取群类型
    gv.chatType=self.chatType;
    
    //取得群名称
    gv.groupname = self.groupname;
    
    //取得成员数组
    for (FriendCellModel *model in self.members) {
        
        [gv.members addObject:model];
        
    }
    
    //取得环信群组ID
    gv.hxgroupid = self.username;
    
    //取得炫能ID
    gv.roomid = self.roomid;
    
    [self.navigationController pushViewController:gv animated:YES];
    
}

-(void)refreshMessageListView{
    
    //删除所有数组元素
    [self.messageList removeAllObjects];
    
    //刷新列表
    [messageListView reloadData];
    
}

#pragma mark-监听键盘弹出

//监听键盘弹出
-(void)observeKeyboard{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//移除键盘监听
-(void)RemoveObserveKeyboard{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
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
    __unsafe_unretained liaoTianViewController *LTVc = self;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        //修改toobar的y值
        CGRect toobarF = LTVc->_toolBar.frame;
        toobarF.origin.y = self.view.frame.size.height-ToobarHeight-size.height;
        LTVc->_toolBar.frame = toobarF;
        
        //修改messageListView的高度
        CGRect messageListF = LTVc->messageListView.frame;
        //（整个view高度－导航栏高度－发送框高度－键盘高度）
        messageListF.size.height = self.view.frame.size.height-kTopViewHeight-ToobarHeight-size.height;
        LTVc->messageListView.frame = messageListF;
        
    }];
}

-(void)keyboardWillHide:(NSNotification *)noti{
    
    //将从父视图遮罩移除
    [_keyboardBackView removeFromSuperview];
    
    
    __unsafe_unretained liaoTianViewController *LTVc = self;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        //修改toobar的y值
        CGRect toobarF = LTVc->_toolBar.frame;
        toobarF.origin.y = self.view.frame.size.height-ToobarHeight;
        LTVc->_toolBar.frame = toobarF;
        
        //修改messageListView的高度
        CGRect messageListF = LTVc->messageListView.frame;
        //（整个view高度－导航栏高度－发送框高度）
        messageListF.size.height = self.view.frame.size.height-kTopViewHeight-ToobarHeight;
        LTVc->messageListView.frame = messageListF;
    }];
}

//设置keyboardBackView
-(void)setupkeyboardBackViewWithSize:(CGSize)size{
    
    UIView *keyboardBackView = [[UIView alloc] init];
    CGRect bounds = self.view.bounds;
    bounds.size.height = bounds.size.height-size.height-ToobarHeight;
    keyboardBackView.frame = bounds;
    UITapGestureRecognizer *resignKeyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboardTap)];
    [keyboardBackView addGestureRecognizer:resignKeyboardTap];
    [self.view addSubview:keyboardBackView];
    _keyboardBackView = keyboardBackView;
}
//把键盘放下去
-(void)resignKeyboardTap{
    
    [_toolBar.inputView endEditing:YES];
    
}

#pragma mark-ChatMoreViewDelegate
-(void)didClickPhotoButton{
    
    UIActionSheet*alert = [[UIActionSheet alloc]
                           initWithTitle:@"选择照相还是相册"
                           delegate:self
                           cancelButtonTitle:NSLocalizedString(@"取消",nil)
                           destructiveButtonTitle:nil
                           otherButtonTitles:NSLocalizedString(@"相机拍摄",nil),
                           NSLocalizedString(@"手机相册",nil),
                           nil];
    [alert showInView:self.view];
    
}

#pragma mark-ChatTooBarDelegate

//取消录制视频
-(void)didCancelRecord{
    
    //取消录制语音
    [[EaseMob sharedInstance].chatManager asyncCancelRecordingAudio];
    
    
}

//更多按钮的回调
-(void)didClickMoreButtonWithStaus:(BOOL)isSelected{
    
    //更新键盘
    if (isSelected) {
        
        _toolBar.inputView.inputView = _chatMoreView;
        [_toolBar.inputView reloadInputViews];
        
    }else{
        
        _toolBar.inputView.inputView = nil;
        [_toolBar.inputView reloadInputViews];
        
    }
    
    //如果此时不是第一响应者就将键盘弹出
    if (![_toolBar.inputView isFirstResponder]) {
        
        [_toolBar.inputView becomeFirstResponder];
        
    }
    
}

//录音按钮长按回调
-(void)didClickRecordButtonWithStaus:(BOOL)isBeginRecord{
    
    //检测是否有网络
    BOOL isExistenceNetwork = [self isConnectionAvailable];
    
    if (!isExistenceNetwork) {
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"网络未连接"];
        return;
        
    }
    
    if (isBeginRecord) {
        
        //开始录音
        NSError *error = nil;
        [[EaseMob sharedInstance].chatManager startRecordingAudioWithError:&error];
        if (error) {
            NSLog(@"开始录音失败");
        }
        
    }else{
        
        __unsafe_unretained liaoTianViewController *LV = self;
        
        //停止录音
        [[EaseMob sharedInstance].chatManager asyncStopRecordingAudioWithCompletion:
         ^(EMChatVoice *voice, NSError *error){
             
             //发送录音
             EMVoiceMessageBody *voiceBody = [[EMVoiceMessageBody alloc] initWithChatObject:voice];
             
             EMMessage *msg = [[EMMessage alloc] initWithReceiver:self.username
                                                           bodies:@[voiceBody]];
             
             //设置是否是群聊（必须）
             [self setMsgGroupPropertyWithMsg:msg];
             
             EMError *voiceError=nil;
             [[EaseMob sharedInstance].chatManager sendMessage:msg progress:nil error:&voiceError];
             if (!voiceError) {
                 
                 //发送成功
                 
                 //先将messageID存起来
                 [self saveMessageIDWithMessageID:msg.messageId];
                 
                 //初始化ChatItem
                 ChatItem *chatItem = [[ChatItem alloc] init];
                 
                 //头像
                 chatItem.icon = [self getUserImage];
                 
                 //取得userid(自己发的)
                 chatItem.userid = [[FDSUserManager sharedManager] NowUserID];
                 
                 //模型类型
                 chatItem.type = TypeVoice;
                 
                 //模型获取语音对象
                 chatItem.voice=voice;
                 
                 //是否为自己发出
                 chatItem.isSelf = YES;
                 
                 //模型转换成frame
                 ChatItemFrame *frame = [[ChatItemFrame alloc] initWithChatItem:chatItem];
                 
                 //将模型加进数组
                 [LV->_messageList addObject:frame];
                 [LV->messageListView reloadData];
                 
             }
             
             
         } onQueue:nil];
        
    }
    
}

//表情按钮被点击
-(void)didClickFaceButtonWithStaus:(BOOL)isSelected{
    
    //更新键盘
    if (isSelected) {
        
        _toolBar.inputView.inputView = _faceView;
        [_toolBar.inputView reloadInputViews];
        
    }else{
        
        _toolBar.inputView.inputView = nil;
        [_toolBar.inputView reloadInputViews];
        
    }
    
    //如果此时不是第一响应者就将键盘弹出
    if (![_toolBar.inputView isFirstResponder]) {
        
        [_toolBar.inputView becomeFirstResponder];
        
    }
    
    
}

//发送文本消息(包含表情)
-(void)didSendMessage:(NSString *)text{
    
    //检测是否有网络
    BOOL isExistenceNetwork = [self isConnectionAvailable];
    
    if (!isExistenceNetwork) {
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"网络未连接"];
        return;
        
    }
    
    NSString *willSendText = [ConvertToCommonEmoticonsHelper convertToSystemEmoticons:text];
    
    if (![willSendText isEqualToString:@""])
    {
        
        //发送文本消息
        EMChatText *chatText = [[EMChatText alloc] initWithText:willSendText];
        EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:chatText];
        EMMessage *msg = [[EMMessage alloc] initWithReceiver:self.username
                                                      bodies:@[body]];
        
        //群聊的话一定要设置这个属性，否则没办法接收到消息
        [self setMsgGroupPropertyWithMsg:msg];
        
        
        //EMImageMessageBody
        EMError *error = nil;
        [[EaseMob sharedInstance].chatManager sendMessage:msg progress:nil error:&error];
        
        //发送成功
        if (!error) {
            
            //将messageId存进去,以后读取聊天记录要用到
            [self saveMessageIDWithMessageID:msg.messageId];
            
            //初始化ChatItem
            ChatItem *chatItem = [[ChatItem alloc] init];
            
            //头像
            chatItem.icon = [self getUserImage];
            
            //取得userid，点击头像用的
            chatItem.userid = [[FDSUserManager sharedManager] NowUserID];
            
            //内容
            chatItem.content = willSendText;
            
            //是否为自己发出
            chatItem.isSelf = YES;
            
            //模型转换成frame
            ChatItemFrame *frame = [[ChatItemFrame alloc] initWithChatItem:chatItem];
            
            //将模型加进数组
            [self.messageList addObject:frame];
        }
        
        //刷新列表
        [messageListView reloadData];
        
    }
    
}

#pragma mark-faceViewDelegate
- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete{
    
    if (isDelete) {
        
        NSString *chatText = _toolBar.inputView.text;
        
        if (chatText.length >= 2)
        {
            NSString *subStr = [chatText substringFromIndex:chatText.length-2];
            if ([(DXFaceView *)_faceView stringIsFace:subStr]) {
                _toolBar.inputView.text = [chatText substringToIndex:chatText.length-2];
                //如果输入的字符串长度已经为空了，就清除文本，设置占位文本
                if (chatText.length-2==0) {
                    
                    [_toolBar clearInputViewText];
                    
                }
                
                return;
            }
        }
        
        if (chatText.length > 0) {
            _toolBar.inputView.text = [chatText substringToIndex:chatText.length-1];
            
            //如果输入的字符串长度已经为空了，就清除文本，设置占位文本
            if (chatText.length-1==0) {
                
                [_toolBar clearInputViewText];
                
            }
        }
    }else{
        
        //将占位文本去掉
        [_toolBar clearInputViewPlaceholder];
        
        //将表情拼接字符串
        _toolBar.inputView.text = [NSString stringWithFormat:@"%@%@",_toolBar.inputView.text,str];
        
        //修改输入字符的长度
        _toolBar.inputStrLength+=2;
        
    }
    
    
}

//发送表情
-(void)sendFace{
    
    //发送文本消息（调用inputview的代理）
    [self didSendMessage:_toolBar.inputView.text];
    
    //将文本清空
    [_toolBar clearInputViewText];
    
}

//实现接收消息的委托
#pragma mark - IChatManagerDelegate

//发送图片后判断是否成功的回调
-(void)didSendMessage:(EMMessage *)message error:(EMError *)error{
    
    if (!error) {
        
        //首先将messageID存起来
        [self saveMessageIDWithMessageID:message.messageId];
        
        //初始化ChatItem
        ChatItem *chatItem = [[ChatItem alloc] init];
        
        //头像
        chatItem.icon = [self getUserImage];
        
        //取得userid，自己的userid
        chatItem.userid = [[FDSUserManager sharedManager] NowUserID];
        
        //获得预览图的本地路径
        chatItem.localPath = _imageBody.localPath;
        
        //预览图的尺寸(如果是自己发出的要将尺寸减半才行)
        CGFloat thumbnailW = _imageBody.thumbnailSize.width*0.5;
        CGFloat thumbnailH = _imageBody.thumbnailSize.height*0.5;
        CGSize tempThumSize = CGSizeMake(thumbnailW, thumbnailH);
        chatItem.thumbnailSize=tempThumSize;
        
        //模型类型
        chatItem.type = TypeImage;
        
        //是否为自己发出
        chatItem.isSelf = YES;
        
        //将模型转换成frame
        ChatItemFrame *frame = [[ChatItemFrame alloc] initWithChatItem:chatItem];
        
        //将模型加进数组
        [self.messageList addObject:frame];
        
        //刷新列表
        [messageListView reloadData];
        
    }
    
}

//取消录制音频回调
-(void)didCancelRecordAudio:(EMChatVoice *)aChatVoice error:(NSError *)error{
    
    if (error) {
        
        NSLog(@"取消录制语音失败");
        
    }
    
}

//图片下载完成后回调
-(void)didFetchMessage:(EMMessage *)aMessage error:(EMError *)error{
    
    if (!error) {
        
        //拿数据去解析
        [self analysisEMMessageWithMessage:aMessage messageType:MessageTypeReceive];
        
    }
    
}

//接收消息
-(void)didReceiveMessage:(EMMessage *)message{
    
    //取出消息数组
    NSArray *bodies = message.messageBodies;
    
    //取出消息体
    EMTextMessageBody *body = bodies[0];
    
    //NSString *text = body.text;
    
    //如果不是当前聊天的对象发来的消息一概接收
    if (![message.from isEqualToString:self.username]) {
        
        return;
        
    }
    
    //播放音频（新消息提示）
    [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
    [[EaseMob sharedInstance].deviceManager playVibration];
    
    //在聊天页面接收到的都是已读,外面就不显示徽章了
    [self markMessageIsReadWithMessageId:message.messageId];
    
    
    if (body.messageBodyType==eMessageBodyType_Image) {
        
        //发送环信图片解密消息
        [[EaseMob sharedInstance].chatManager asyncFetchMessage:message progress:nil];
        
        return;//先不去解析数据，先解密
        
    }
    
    [self analysisEMMessageWithMessage:message messageType:MessageTypeReceive];
    
}

//标记某条消息为已读
-(void)markMessageIsReadWithMessageId:(NSString *)messageId{
    
    //获取会话对象
    EMConversation *conversation = [self getConversation];
    
    //记录里面的全部设置为已读的(进来之后全部设置为已读)
    [conversation markMessageWithId:messageId asRead:YES];
    
}

//解析EMMessage数据
-(void)analysisEMMessageWithMessage:(EMMessage *)message messageType:(MessageType)messageType{
    
    //只需要存储接收到的消息messageID(消息记录已经存储过了）
    if (messageType==MessageTypeReceive) {
        
        [self saveMessageIDWithMessageID:message.messageId];
        
    }
    
    //将模型转换成frame
    ChatItemFrame *frame = [self convertEMMessage:message];
    
    //将模型加进数组
    [self.messageList addObject:frame];
    
    
    //刷新列表
    [messageListView reloadData];
    
}

//返回发送此消息的群成员头像和userid
-(NSString *)getMemberPhotoWithFrom:(NSString *)from{
    
    //解析出userid
    NSString *userid = [from stringByReplacingOccurrencesOfString:@"bg" withString:@""];
    
    //返回的头像
    NSString *photo = nil;
    
    //遍历数组，找出发送此消息的群成员
    for (FriendCellModel *model in self.members) {
        
        if ([model.userid isEqualToString:userid]) {
            
            photo = model.image;
            
        }
        
    }
    
    return photo;
    
}

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([actionSheet.title isEqualToString:@"选择照相还是相册"])
    {
        switch(buttonIndex)
        {
            case 1:
            {
                UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
                [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [imagePicker setDelegate:self];
                [imagePicker setAllowsEditing:NO];
                
                [self presentViewController:imagePicker animated:YES completion:nil];
                
                
            }
                break;
            case 0:
            {
                UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
                
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                    [imagePicker setDelegate:self];
                    [imagePicker setAllowsEditing:YES];
                }
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }
}

//调用摄像机
-(void)addCarema
{
    //判断是否可以打开相机，模拟器此功能无法使用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;  //是否可编辑
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark-UIImagePickerControllerDelegate

//拍摄完成后要执行的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //检测是否有网络
    BOOL isExistenceNetwork = [self isConnectionAvailable];
    
    if (!isExistenceNetwork) {
        
        //提示框（放在图片控制器上面）
        [[FDSPublicManage sharePublicManager] showInfo:picker.view MESSAGE:@"网络未连接"];
        
        return;
        
    }
    
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];

    //初始化一个EMChatImage对象
    EMChatImage *chatImage = [[EMChatImage alloc] initWithUIImage:image displayName:@"image.jpg"];
    
    //初始化一个MessageBody对象
    //chatImage：大图
    //thumbnailImage：缩略图（可不传, 传nil系统会自动生成缩略图）
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithImage:chatImage thumbnailImage:nil];
    
    //将发送的body记录下来，发送成功了要用到
    _imageBody=body;
    
    //初始化一个MessageBody数组(目前暂时只支持一个body)
    NSArray *bodies = [NSArray arrayWithObject:body];
    
    //初始化一个EMMessage对象
    EMMessage *retureMsg = [[EMMessage alloc] initWithReceiver:self.username bodies:bodies];
    
    //设置是否是群聊（必须）
    [self setMsgGroupPropertyWithMsg:retureMsg];
    
    //发送数据是否需要加密
    //retureMsg.requireEncryption = YES;
    
    //发送图片消息
    [[EaseMob sharedInstance].chatManager asyncSendMessage:retureMsg progress:nil];
    
    //将模态视图放下去
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}

//点击Cancel按钮后执行方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //将模态视图放下去
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil) {
        
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        
        //设置代理，头像点击的
        cell.delegate = self;
        
        //cell没有选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    //取出模型
    ChatItemFrame *chatItemFrame = [self.messageList objectAtIndex:indexPath.row];
    cell.chatItemFrame=chatItemFrame;
    
    return cell;
    
}


#pragma tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //取出模型
    ChatItemFrame *chatItemFrame = [self.messageList objectAtIndex:indexPath.row];
    
    //cell高度
    return chatItemFrame.cellHeight;
    
}

//获取用户头像
-(NSString *)getUserImage{
    
    BGUser *user = [[FDSUserManager sharedManager] getNowUser];
    return user.photo;
    
}


//获取当前登录用户名
-(NSString *)getUsername{
    
    //获取userid
    NSString *userid = [[FDSUserManager sharedManager] NowUserID];
    
    //拼接用户名
    return [NSString stringWithFormat:@"bg%@",userid];
    
}

//存储messageID
-(void)saveMessageIDWithMessageID:(NSString *)messageID{
    
    //插入数据库
    [[DataBaseSimple shareInstance] insertMessageidWithMessageid:messageID username:self.username];
    
}

//获取messageID数组
-(NSArray *)getMessageidsWithIsFirstRequest:(BOOL)isFirstRequest{
    
    if (isFirstRequest) {
        
        NSArray *allMessageids = [[DataBaseSimple shareInstance] selectMessageidsWithUsername:self.username];
        _requestCount = 5;
        if (allMessageids.count<5) {
            
            _requestRecordTag = 0;
            _requestCount = allMessageids.count;
            
        }else{
            
            _requestRecordTag = allMessageids.count-5;
            
        }
        
        
    }else{
        
        _requestRecordTag = _requestRecordTag-5;
        
        //如果请求标记比0小说明这个时候剩下的个数已经小于5了
        if (_requestRecordTag<0) {
            
            _requestCount = _requestRecordTag+5;
            
            _requestRecordTag = 0;
            
        }
        
    }
    
    NSArray *messageIDs = [[NSArray alloc] init];
    
    //获取messageID（存储的都是username，单聊是用户名，群聊就是环新群ID)
    messageIDs = [[DataBaseSimple shareInstance] selectPageMessageidsWithUsername:self.username start:_requestRecordTag count:_requestCount];
    
    return messageIDs;
    
}

//设置isGroup属性，同意在这里设置
-(void)setMsgGroupPropertyWithMsg:(EMMessage *)msg{
    
    if (!self.chatType==ChatTypeSingle) {
        
       msg.isGroup = YES;
        
    }
    
}

//群成员线程刷新的数据在这里回调，这个控制器肯定出现了
-(void)requestGroupMembersCB:(NSArray *)data{
    
    //更新数据库首先要将相应的群成员清除掉
    [[DataBaseSimple shareInstance] deleteGroupMemberWithHxgroupid:self.username];
    
    for (FriendCellModel *model in data) {
        
        //只有是群的时候才会插入数据库
        if (![self.username hasPrefix:@"bg"]) {
            
            //插入数据库
            [[DataBaseSimple shareInstance] insertMemberWithModel:model hxgroupid:self.username];
            
        }
        
    }
    
    //修改内存的群成员数据，不会延迟很多
    self.members = data;
    
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

#pragma mark-ChatCellDelegate

-(void)chatCellPersontapWithUserid:(NSString *)userid{
    
    //先拿userid
    _personTapUserid = userid;
    
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
    
    if ([FDSUserCenterMessageManager sharedManager].
        userInfoType==UserInfoTypeOtherUserInfo) {
        
        PersonlCardViewController *pv = [[PersonlCardViewController alloc] init];
        pv.userDic = dic;
        pv.userid = _personTapUserid;
        
        [self.navigationController pushViewController:pv animated:YES];
        
    }
    
    
}

@end
