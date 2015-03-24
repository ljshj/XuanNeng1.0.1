//
//  PushManager.m
//  FDS
//
//  Created by zhuozhong on 14-1-22.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSPushManager.h"
#import "PlatformMessageManager.h"
#import "FDSUserManager.h"


@implementation FDSPushManager

static FDSPushManager* manager = nil;

+ (FDSPushManager *)sharePushManager
{
    if(nil == manager)
    {
        manager = [[FDSPushManager alloc]init];
        [manager managerInit];
    }
    return manager;
}

- (void)managerInit
{
   // [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
    
    [[PlatformMessageManager sharedManager] registerObserver:self];
   // [[ZZSessionManager sharedSessionManager] registerObserver:self];
}
//-(void)sessionManagerStateNotice:(enum ZZSessionManagerState)sessionManagerState
//{
//    switch (sessionManagerState) {
//        case ZZSessionManagerState_CONNECTED:
//        {
//            [[PlatformMessageManager sharedManager] bandChater:[[FDSUserManager sharedManager] getNowUser].m_userID];
//            break;
//        }
//        default:
//            break;
//    }
//}
-(void)getIMCB:(FDSChatMessage *)chatMessage
{
 
}
///*  push 收消息  */
//- (void)getIMCB:(FDSChatMessage*)chatMessage :(FDSMessageCenter*)messageCenter
//{
//    /* 添加该条聊天数据到数据库 先注册先回调*/
//   // [[NSNotificationCenter defaultCenter] postNotificationName:SYSTEM_NOTIFICATION_TAB_MESSAGE_ADD_MARK object:nil];
//    [[FDSDBManager sharedManager] AddChatMessageToDB:chatMessage];
//    
//    /* 更新一条消息到MessageCenter */
//    [[FDSDBManager sharedManager]updateMessageCenterToDB:messageCenter];
//}

-(void)getAddFriendRequestCB:(BGUser *)user :(NSString *)checkWorld
{

}
-(void)getAddFriendReplyCB:(BGUser *)user :(NSString *)result
{

}
///* push消息 收到对方的添加好友请求 */
//- (void)addFriendRequestCB:(FDSMessageCenter*)centerMessage :(FDSUser*)friendInfo
//{
//    /* 更新一条消息到MessageCenter */
//  //  [[NSNotificationCenter defaultCenter] postNotificationName:SYSTEM_NOTIFICATION_TAB_MESSAGE_ADD_MARK object:nil];
//
//    [[FDSDBManager sharedManager]updateMessageCenterToDB:centerMessage];
//}
//
///* push消息 发出添加好友请求后收到的回复 */
//- (void)addFriendReplyCB:(FDSUser*)friendInfo :(FDSMessageCenter*)messageCenter;
//{
//    if (friendInfo)
//    {
//        /* 不为空即表示添加成功 */
//       // [[NSNotificationCenter defaultCenter] postNotificationName:SYSTEM_NOTIFICATION_TAB_MESSAGE_ADD_MARK object:nil];
//
//        [[FDSDBManager sharedManager]AddFriendToDB:friendInfo];
//        /* 更新一条消息到MessageCenter */
//        [[FDSDBManager sharedManager]updateMessageCenterToDB:messageCenter];
//    }
//}

/*  主动删除好友 */
- (void)subFriendCB:(NSString*)result :(BGUser*)friendInfo
{
    if ([result isEqualToString:@"OK"])
    {
        
    }
}

/*  push消息  被好友对方删除  */
- (void)subedFriend:(BGUser*)friendInfo
{
    
}

/*    好友修改名称 修改头像消息推送     */
- (void)cardInfoModifyCB:(NSString*)cardType :(NSString*)modifyName :(NSString*)modifyIcon :(NSString*)userID
{
    if (modifyName && modifyName.length > 0)
    {
        
    }
    else
    {
        [[EGOImageLoader sharedImageLoader]clearCacheForURL:[NSURL URLWithString:modifyIcon]];
//        [[FDSDBManager sharedManager]updateIconPath:modifyIcon :userID];
    }
}


- (void)dealloc
{
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
   // [super dealloc];
}

@end
