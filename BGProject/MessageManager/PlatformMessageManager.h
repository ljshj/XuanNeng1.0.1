//
//  PlatformMessageManager.h
//  BGProject
//
//  Created by zhuozhongkeji on 14-9-16.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ZZMessageManager.h"
#import "PlateformMessageInterface.h"
#import "ZZSessionManager.h"

#import "BGUser.h"
@interface PlatformMessageManager : ZZMessageManager
+ (PlatformMessageManager*)sharedManager;
- (void)registerObserver:(id<PlateformMessageInterface>)observer;
- (void)unRegisterObserver:(id<PlateformMessageInterface>)observer;

// 添加好友回复
-(void)addFriendReply :(BGUser*)user :(NSString*)result;

// 获得好友列表
-(void)getFriends;

// 发送聊天信息
-(void)sendIM :(FDSChatMessage*)chatMessage;

//绑定聊天者（登录聊天服务器）
-(void)bandChater:(NSString*)userID;

//搜索好友
-(void)searchFriend:(NSString*)keyword;

//##################集成环信IM之后添加接口####################

/**
 *查找好友
 */
-(void)checkFriendsWithKeyword:(NSString *)keyword start:(int)start end:(int)end;
/**
 *同意添加好友
 */
-(void)agreeToAddFriendsWithUserid:(NSString *)userid recver:(NSArray *)recver msg:(NSString *)msg;
/**
 *删除好友
 */
-(void)deleteGoodfriendWithUserids:(NSArray *)userids;
/**
 *返回联系人列表（好友／群）
 */
-(void)requestContactList;
/**
 *创建群
 */
-(void)creatGroupWithName:(NSString *)name type:(int)type intro:(NSString *)intro notice:(NSString *)notice;
/**
 *解散群
 */
-(void)disbandGroupWithGroupid:(NSString *)groupid;
/**
 *退出群
 */
-(void)exitGroupWithGroupid:(NSString *)groupid userid:(NSString *)userid;
/**
 *查找群
 */
-(void)findGroupWithKeyword:(NSString *)keyword start:(int)start end:(int)end;
/**
 *添加群成员进群
 */
-(void)addFriendsToGroupWithUserid:(NSArray *)userids groupid:(NSString *)groupid type:(int)type agr:(NSString *)agr;
/**
 *添加群成员到交流厅
 */
-(void)addFriendsToTempGroupWithUserid:(NSArray *)userids groupid:(NSString *)groupid agr:(NSString *)agr;
/**
 *获取群成员
 */
-(void)requestGroupMembersWithRoomid:(NSString *)roomid;
/**
 *获取群信息(id和groupid，其中一个必须0或者小于0)
 */
-(void)requestGroupInfoWithHxgroupid:(NSString *)hxgroupid roomid:(NSString *)roomid;
/**
 *移除群成员
 */
-(void)deleteGroupMemberWithGroupid:(NSString *)groupid userid:(NSString *)userid;

@end
