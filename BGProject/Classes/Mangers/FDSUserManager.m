//
//  UserManager.m
//  FDS
//
//  Created by zhuozhong on 14-1-22.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSUserManager.h"
#import "ZZUserDefaults.h"
#import "FDSUserCenterMessageManager.h"
#import "ZZSessionManager.h"
#import "FDSPublicMessageManager.h"
#import "UIAlertView+Zhangxx.h"
#import "SVProgressHUD.h"
#import "NotificationFrame.h"
#import "APService.h"


@implementation FDSUserManager
static FDSUserManager* manager = nil;

+ (FDSUserManager*)sharedManager
{
    if(nil == manager)
    {
       // m_user = nil;
        manager = [[FDSUserManager alloc]init];
        [manager managerInit];
        
        
    }
    return manager;
}

- (int)autoCheck
{
    int result = 0;
    /* get User ID ,count , password */
    NSString *userCount = [ZZUserDefaults getUserDefault:USER_COUNT];
    NSString *userPassword = [ZZUserDefaults getUserDefault:USER_PASSWORD];
    NSString *userLogout = [ZZUserDefaults getUserDefault:ISLOGOUT];
    
    if(userCount != nil && userPassword != nil)
    {
        m_user.m_account = userCount;
        m_user.m_password = userPassword;
        
        //自动登录（既然都不为空就自动登录）
        [[FDSUserCenterMessageManager sharedManager] userLogin:m_user.m_account :m_user.m_password];
        
        
        if(userLogout == nil ||  [userLogout isEqualToString:@"yes"]) //注销后不做自动登录
        {
            m_userState = USERSTATE_HAVE_ACCOUNT_NO_LOGIN_LOGINOUT;
            result = 0;
        }
        else
        {
            //有账号需自动登录  初始化为没网络（网路一旦连上需自动登录）若自动登录失败即可获知失败原因
            m_userState = USERSTATE_NONE;
            result = 1;
        }
    }
    else
    {
        m_userState = USERSTATE_NO_ACCOUNT;
    }
    return result;
}

- (void)managerInit
{
    //用户的登录状态默认是USERSTATE_NONE(没有登录的)
    m_userState = USERSTATE_NONE;
    m_user = [[BGUser alloc]init];
    
    [self autoCheck];
    
    //这么多代理，不用删除掉吗？可能都是单例，都要到最后才释放掉得，没关系的
    [[ZZSessionManager sharedSessionManager] registerObserver:self];
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
    [[PlatformMessageManager sharedManager] registerObserver:self];
    //注册环信代理接收消息
    [[[EaseMob sharedInstance] chatManager] addDelegate:self delegateQueue:nil];
    
}

- (enum USERSTATE)getNowUserState
{
    return m_userState;
}

- (void)setNowUserState:(enum USERSTATE)userState
{
    m_userState = userState;
}

- (BGUser*)getNowUser
{
    return m_user;
}

-(void)setNowUserIDEmpty{
    
    m_user.m_userID = nil;
    
}

- (void)modifyNowUser:(BGUser*)userInfo
{
    [m_user copy:userInfo];
}

- (void)sessionManagerStateNotice:(enum ZZSessionManagerState)sessionManagerState
{
    switch (sessionManagerState) {
        case ZZSessionManagerState_NET_OK:
        {
            
            //爆菊花
            //[SVProgressHUD showWithStatus:@"正在登录…"];
            
            //自动登录（不知道为啥会自动登录的）
            [[FDSUserCenterMessageManager sharedManager] userLogin:m_user.m_account :m_user.m_password];
            break;
        }
        case ZZSessionManagerState_CONNECTED:
        {
            /*  登录 */
           // [[FDSUserCenterMessageManager sharedManager] userLogin:(m_user.m_account == nil)?@"":m_user.m_account :(m_user.m_password == nil)?@"":m_user.m_password];
                 /*  login */
               // [[FDSUserCenterMessageManager sharedManager] userLogin:m_user.m_account :m_user.m_password];
           [[PlatformMessageManager sharedManager] bandChater:m_user.m_userID];
           
         //   -(void)sendIM :(FDSChatMessage*)chatMessage
//            FDSChatMessage *message = [[FDSChatMessage alloc]init];
//            message.m_recevierID = m_user.m_userID;
//            message.m_content = @"你好";
//            [[PlatformMessageManager sharedManager] sendIM:message];
            
            break;
        }
        case ZZSessionManagerState_CONNECT_FAIL:
        {
            m_userState = USERSTATE_HAVE_ACCOUNT_NO_LOGIN_NOTNET;
            break;
        }
        default:
            break;
    }
}


// bg用户登入成功后，自动刷新user状态
//<msgbody>
//<userid>bg000001</userid>//用户id
//<success>true</success> //是否注册成功
//<token>xxxxxxx</token>//更高安全要求时用到，目前可忽略
//<bserver>ip:port</bserver>//业务处理服务器地址,以后所有请求都用它
//<fserver>http://www.xxx.com/uploadfile.ashx</fserver>//文件服务器，上传图片或文件
//
//</msgbody>
//TOOD:: 登入完成后更新用户状态 2014年09月04日

//提交别名回调
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

-(void)userLoginCB:(NSDictionary*)dic
{
   // NSLog(@"更新了用户的状态：%@",dic);
    bool isLoginSuccess = [dic[kSuccessKey] boolValue];
    if(isLoginSuccess) {
        
        //统计登录
        [MobClick event:@"sys_login_click"];
        
        //所有的登录都要经过这里
        m_userState = USERSTATE_LOGIN;
        m_user.m_userID = dic[kUseridKey];
        
        //发送别名
        [APService setTags:nil alias:m_user.m_userID callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
        
        if(m_user.m_userID != nil)
        {
            
            //如果会员登录成功，登录环信
            
            //如果是修改密码的，环信重新登录肯定失败，如果不显示了
            if (self.isChangePassWord==YES) {
                
                //获取完个人信息直接返回
                [self requestUserinfo];
                
                //改回来
                self.isChangePassWord = NO;
                
                return;
                
            }
            //拼接用户名
            NSString *username = [NSString stringWithFormat:@"bg%@",m_user.m_userID];
            
            //如果已经登录了，就不再登录了，过滤掉
            BOOL isLoggedIn = [[EaseMob sharedInstance].chatManager isLoggedIn];
            if (!isLoggedIn) {
                
                //同步登录
                EMError *error = nil;
                [[EaseMob sharedInstance].chatManager loginWithUsername:username password:@"banggood123" error:&error];
                if (!error) {
                    //环信登录成功
                    //提示框
                    [[FDSPublicManage sharePublicManager] showInfo:[UIApplication sharedApplication].keyWindow MESSAGE:@"登录成功"];
                    
                    [self requestUserinfo];
                    
                }else{
                    
                    //弹出失败提示
                    [[FDSPublicManage sharePublicManager] showInfo:[UIApplication sharedApplication].keyWindow MESSAGE:@"登录失败"];
                    
                }
                
            }
            
        }
        
    }else {
        
        //登录失败
    }
   
    
}

-(void)requestUserinfo{
    
    //获取用户个人信息
    [[FDSUserCenterMessageManager sharedManager]userRequestUserInfo:m_user.m_userID];
    
    //是用户本身的消息
    [FDSUserCenterMessageManager sharedManager].userInfoType=UserInfoTypeCurrentUserInfo;
    
    //设置联系徽章
    [self setupContactBadgeCount];
    
    
}

//设置联系徽章
-(void)setupContactBadgeCount{
    
    //取出数据库的所有会话，登录成功后才能取得会话
    NSArray *DBconversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabase];
    
    int badgeCount = 0;
    
    for (EMConversation *con in DBconversations) {
        
        badgeCount = badgeCount+(int)con.unreadMessagesCount;
        
    }
    
    badgeCount = badgeCount+self.badgeCount;
    
    //发送通知（刷新联系的徽章）
    NSString *badgeStr = [NSString stringWithFormat:@"%d",badgeCount];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:SetupContactBadgeCountKey object:badgeStr];
    
    
}

//数组懒加载
-(NSMutableArray *)messages{
    
    if (_messages==nil) {
        
        _messages = [[NSMutableArray alloc] init];
        
    }
    
    return _messages;
    
}

#pragma mark-EMChatManagerDelegate

-(void)didReceiveMessage:(EMMessage *)message{
    
    //播放音频（新消息提示）
    [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
    [[EaseMob sharedInstance].deviceManager playVibration];
    
    //直接将messageID存进去，到控制器以聊天被提取出来(from是用户名也是环信群ID)
    [[DataBaseSimple shareInstance] insertMessageidWithMessageid:message.messageId username:message.from];
    
    //设置联系徽章
    [self setupContactBadgeCount];
    
    if (!self.isApplicationBackGround) {
        
        //如果在前台，直接返回，不发送本地通知
        return;
        
    }
    
    
    //取出消息数组
    NSArray *bodies = message.messageBodies;
    
    //取出文本对象
    EMTextMessageBody *body = bodies[0];
    
    //本地通知
    UILocalNotification *localNoti = [[UILocalNotification alloc] init];
    localNoti.alertBody = body.text;
    localNoti.soundName = UILocalNotificationDefaultSoundName;
    localNoti.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber+1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
    
}

//下载完成
-(void)didFetchMessage:(EMMessage *)aMessage error:(EMError *)error{
    
    if (!error) {
        
        //转化之后再插进数据库，聊天记录取出来的是解密后的路径
        [[DataBaseSimple shareInstance] insertMessageidWithMessageid:aMessage.messageId username:aMessage.from];
        
    }
    
}

//警告：离线消息表情没办法解析，在线消息可以
//    EMMessage *msg = offlineMessages[0];
//
//    EMTextMessageBody *body = msg.messageBodies[0];
//
//    NSString *text = body.text;
//
//    NSLog(@"text==%@",text);
//
//    return;

//离线聊天消息回调
- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages{
    
    //播放音频（新消息提示）
    [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
    [[EaseMob sharedInstance].deviceManager playVibration];
    
    //将messageid存起来，到那边刷新消息列表会出现徽章,然后进入聊天页面会拿记录出来
    for (EMMessage *message in offlineMessages) {
        
        //取出消息数组
        NSArray *bodies = message.messageBodies;
        
        //取出消息体
        EMTextMessageBody *body = bodies[0];
        
        if (body.messageBodyType==eMessageBodyType_Image) {
            
            //发送环信图片解密消息
            [[EaseMob sharedInstance].chatManager asyncFetchMessage:message progress:nil];
        }else{
            
            //直接插入数据库，不用解密
            [[DataBaseSimple shareInstance] insertMessageidWithMessageid:message.messageId username:message.from];
            
        }
        
    }
    
}

//好友请求的回调
- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message{
    
    //播放音频（新消息提示）
    [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
    [[EaseMob sharedInstance].deviceManager playVibration];
    
    //解析出userid
    NSString *userid =  [username stringByReplacingOccurrencesOfString:@"bg" withString:@""];
    
    //记录下消息
    self.message = message;
    
    //此时的请求类型为好友请求
    self.requestUserInfoType = RequestUserInfoTypeFriend;
    
    //发送请求用户信息的消息
    [[FDSUserCenterMessageManager sharedManager] requestUserInfoWithUserids:@[userid]];
    
    
}

//批量个人信息回调
-(void)requestUserInfoWithUseridsCB:(NSDictionary *)data{
    
    //取出字典数组
    NSArray *items = data[@"items"];
    
    if (self.requestUserInfoType==RequestUserInfoTypeGroup) {
        
        for (int i=0; i<items.count; i++) {
            
            //取出字典
            NSDictionary *dic = items[i];
            
            //拼凑模型
            NotificationModel *model = [[NotificationModel alloc] init];
            model.name = dic[@"name"];
            model.message = [NSString stringWithFormat:@"请求进群 %@",self.groupname];
            model.image = dic[@"img"];
            model.userid = [NSString stringWithFormat:@"%d",[dic[@"userid"] intValue]];
            model.hxgroupid = self.hxgroupid;
            model.groupname = self.groupname;
            
            //算坐标
            NotificationFrame *groupFrame = [[NotificationFrame alloc] initWithNotificationModel:model];
            
            //设置类型
            groupFrame.notificationFrameType = NotificationFrameTypeGroup;
            
            //添加到数组里面去
            [self.messages addObject:groupFrame];
            
            //改变徽章数量
            self.badgeCount = self.badgeCount+1;
            
        }
        
        //不执行下面的代码
        return;
        
    }
    
    for (int i=0; i<items.count; i++) {
        
        //取出字典
        NSDictionary *dic = items[i];
        
        //拼凑模型
        NotificationModel *model = [[NotificationModel alloc] init];
        model.name = dic[@"name"];
        model.message = self.message;
        model.image = dic[@"photo"];
        model.userid = [NSString stringWithFormat:@"%d",[dic[@"userid"] intValue]];
        model.detail = dic[@"signatrue"];
        
        //算坐标
        NotificationFrame *friendFrame = [[NotificationFrame alloc] initWithNotificationModel:model];
        
        //为了在接受请求的时候更好区分
        friendFrame.notificationFrameType = NotificationFrameTypeFriend;
        
        //添加到数组里面去
        [self.messages addObject:friendFrame];
        
        //改变徽章数量
        self.badgeCount = self.badgeCount+1;
        
    }
    
    //发送通知（刷新会话列表）
    [[NSNotificationCenter defaultCenter]
     postNotificationName:SetupMessageBadgeCountKey object:nil];
    
    //也刷新联系控制器，如果不再联系页面的话
    [self setupContactBadgeCount];
    
    
}

//接收到进群申请
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId groupname:(NSString *)groupname applyUsername:(NSString *)username reason:(NSString *)reason error:(EMError *)error{
    
    //播放音频（新消息提示）
    [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
    [[EaseMob sharedInstance].deviceManager playVibration];
    
    //解析出userid
    NSString *userid =  [username stringByReplacingOccurrencesOfString:@"bg" withString:@""];
    
    //此时的请求类型为进群申请的请求
    self.requestUserInfoType = RequestUserInfoTypeGroup;
    
    //记录下要进的群名和ID
    self.groupname = groupname;
    self.hxgroupid = groupId;
    
    //发送请求用户信息的消息
    [[FDSUserCenterMessageManager sharedManager] requestUserInfoWithUserids:@[userid]];
    
    
}

//申请加入群，被群主同意的回调
-(void)didReceiveAcceptApplyToJoinGroup:(NSString *)groupId groupname:(NSString *)groupname error:(EMError *)error{
    
    //只要group相等，不执行下面代码
    NSArray *groups = [[DataBaseSimple shareInstance] selectAllGroups];
    
    for (BaseCellModel *model in groups) {
        
        if ([model.hxgroupid isEqualToString:groupId]) {
            
            return;
            
        }
        
    }
    
    //查询群资料
    [[PlatformMessageManager sharedManager] requestGroupInfoWithHxgroupid:groupId roomid:@"0"];
    
    //个人中心发出的消息
    self.requestGoupInfoType=RequestGoupInfoTypeUserManager;
    
}

//添加好友的请求被接受的回调
- (void)didAcceptedByBuddy:(NSString *)username{
    
    //解析出userid
    NSString *userid =  [username stringByReplacingOccurrencesOfString:@"bg" withString:@""];
    
    //记录下要添加的用户ID，后面插入数据库要用到，返回的数据里面没有userid
    self.agreeUserid = userid;
    
    //获取用户个人信息
    [[FDSUserCenterMessageManager sharedManager]userRequestUserInfo:userid];
    
    //不是用户本身的消息
    [FDSUserCenterMessageManager sharedManager].userInfoType=UserInfoTypeAddFriend;
    
}

//离线的时候被还有删除只能用这种办法了（好友被莫名奇妙删掉了，应该是这里的问题）
- (void)didUpdateBuddyList:(NSArray *)buddyList
            changedBuddies:(NSArray *)changedBuddies
                     isAdd:(BOOL)isAdd
{

    //删除用户会调，增加用户也会调，刚刚启动的时候也会调
    //设置只能启动的时候调就行了
    if (!self.isAddAndDeleteByHX) {
        
        //先把未经认证的过滤掉
        NSMutableArray *approvalUserids = [[NSMutableArray alloc] init];
        
        for (EMBuddy *buddy in buddyList) {
            
            //经过认证的
            if (!buddy.isPendingApproval) {
                
                //取出用户名
                NSString *username = buddy.username;
                
                //换成userid
                NSString *userid = [username stringByReplacingOccurrencesOfString:@"bg" withString:@""];
                
                //添加到数组
                [approvalUserids addObject:userid];
                
            }
            
        }
        
        //先把数据库的模型全部拿出来
        NSMutableArray *friends = [[DataBaseSimple shareInstance] selectFriends];
        
        //遍历模型数组,看模型在不在最新的用户列表里面
        //如果不在，说明已经被删除，从数据库删掉
        for (FriendCellModel *friend in friends) {
            
            //是否存在这个用户ID
            BOOL isContain = [approvalUserids containsObject:friend.userid];
            
            //如果不是就从数据库删除掉
            if (!isContain) {
                
                //修改布尔值，被好友删除
                self.isDeleteByGoodFriend = YES;

                
            }
            
        }

    }
    
}

//在线的时候被被好友删除的回调
- (void)didRemovedByBuddy:(NSString *)username{
    
    //修改布尔值，被好友删除
    self.isDeleteByGoodFriend = YES;
    
    //用户名转换成userid
    NSString *userid =  [username stringByReplacingOccurrencesOfString:@"bg" withString:@""];
    
    
    //数据库移除用户
    [[DataBaseSimple shareInstance] deleteFriendswithUserid:userid];
    
    //将相关的会话对象和messageID去掉(不再判断了，没去掉算了)
    [[EaseMob sharedInstance].chatManager removeConversationByChatter:username deleteMessages:YES];
    
    [[DataBaseSimple shareInstance] deleteMessageidWithUsername:username];
    
    //发送通知（刷新好友列表通知）
    [[NSNotificationCenter defaultCenter]
     postNotificationName:didAcceptedByFriend object:nil];
    
    
}

//截取字符串（不要"bgxx:"）
-(NSString *)substringFromColonWithMsg:(NSString *)msg{
    
    //截取字符串（不要"bgxx:"）
//    NSString *colon = @"：";//冒号
//    NSRange range = [msg rangeOfString:colon];//冒号位置
//
//    //截取字符串
//    NSString *tempMsg = [msg substringFromIndex:(range.location+1)];
    //不知道为啥会没有冒号的
    return msg;
    
}

-(void)groupDidUpdateInfo:(EMGroup *)group error:(EMError *)error{
    
    
    
}

//离开群
- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error{
    
    //从数据库里面删除
    [[DataBaseSimple shareInstance] deleteGroupswithHxgroupid:group.groupId];
    
    //移除这个群的全部成员
    [[DataBaseSimple shareInstance] deleteGroupMemberWithHxgroupid:group.groupId];
    
    //将相关的会话对象和messageID去掉(不再判断了，没去掉算了)
    [[EaseMob sharedInstance].chatManager removeConversationByChatter:group.groupId deleteMessages:YES];
    
    [[DataBaseSimple shareInstance] deleteMessageidWithUsername:group.groupId];
    
    //发一个通知过去刷新页面（群组和交流厅都在这里删掉）
    [[NSNotificationCenter defaultCenter]
     postNotificationName:didLeaveFromGroup object:nil];
    
}


//被别人邀请进群，自动进入某群的回调（在建群的时候已经插进去了）
-(void)didAcceptInvitationFromGroup:(EMGroup *)group error:(EMError *)error{
    
    //只要group相等，不执行下面代码
    NSArray *groups = [[DataBaseSimple shareInstance] selectAllGroups];
    
    for (BaseCellModel *model in groups) {
        
        if ([model.hxgroupid isEqualToString:group.groupId]) {
            
            return;
            
        }
        
    }
    
    //查询群资料
    [[PlatformMessageManager sharedManager] requestGroupInfoWithHxgroupid:group.groupId roomid:@"0"];
    
    //个人中心发出的查询消息
    self.requestGoupInfoType = RequestGoupInfoTypeUserManager;
    
    
}

//查询群资料回调（自动进群和被同意进群都经过这个接口插入数据库和刷新数据）
-(void)requestGroupInfoCB:(NSDictionary *)data{
    
    if (self.requestGoupInfoType!=RequestGoupInfoTypeUserManager) {
        return;
    }
    
    //字典转换成模型
    BaseCellModel *model = [[BaseCellModel alloc] initWithDic:data];
    
    //插入数据库(交流厅和临时群都在这里插入，没问题)
    [[DataBaseSimple shareInstance] insertGroupsWithModel:model];
    
    //播放音频（新消息提示）
    [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
    [[EaseMob sharedInstance].deviceManager playVibration];
    
    //提示框（通知用户）
    NSString *grouptypeStr = nil;
    if ([model.grouptype isEqualToString:@"0"]) {
        grouptypeStr = @"群";
    }else{
        grouptypeStr = @"交流厅";
    }
    NSString *msgStr = [NSString stringWithFormat:@"你已进入%@ %@ ",grouptypeStr,model.name];
    [[FDSPublicManage sharePublicManager] showInfo:[UIApplication sharedApplication].keyWindow MESSAGE:msgStr time:4.0];
    
    //发送通知（删除和添加群和交流厅都是用这个通知刷新群和交流厅的列表）
    [[NSNotificationCenter defaultCenter]
     postNotificationName:didLeaveFromGroup object:nil];
}


//bg 获取用户id
-(NSString*)NowUserID {
    return  m_user.m_userID;
}

//获取用户个人信息回调
-(void)getUserInfoCB:(NSDictionary *)data {
    
    if ([FDSUserCenterMessageManager sharedManager].userInfoType==UserInfoTypeCurrentUserInfo) {
        
        [SVProgressHUD popActivity];
        
        BGUser* user = [self getNowUser];
        [user updateWithDic:data ];
        
    }else if([FDSUserCenterMessageManager sharedManager].userInfoType==UserInfoTypeAddFriend){
        if (data) {
            
            FriendCellModel *model = [[FriendCellModel alloc] init];
            
            //构建数据库模型
            model.userid = self.agreeUserid;
            model.detail = data[@"signature"];
            model.image = data[@"photo"];
            model.name = data[@"nickn"];
            
            //插入数据库
            [[DataBaseSimple shareInstance] insertFriendswithModel:model];
            
            //播放音频（新消息提示）
            [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
            [[EaseMob sharedInstance].deviceManager playVibration];
            
            //提示框（通知用户）
            NSString *msgStr = [NSString stringWithFormat:@"%@ 同意了你的好友请求",model.name];

            [[FDSPublicManage sharePublicManager] showInfo:[UIApplication sharedApplication].keyWindow MESSAGE:msgStr time:4.0];
            
            //发送通知（刷新好友列表通知）
            [[NSNotificationCenter defaultCenter]
             postNotificationName:didAcceptedByFriend object:nil];
            
            
        }else{
            
            NSLog(@"没有返回数据");
            
        }
        
        
    }
    
    
}
@end
