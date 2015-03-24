//
//  PlateformMessageInterface.h
//  BGProject
//
//  Created by zhuozhongkeji on 14-9-16.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGUser.h"

@protocol PlateformMessageInterface <NSObject>

@optional
//  添加好友申请
-(void)getAddFriendRequestCB:(BGUser*)user :(NSString *)checkWorld;
// 添加好友收到回复
-(void)getAddFriendReplyCB:(BGUser*)user :(NSString*)result;

//发送聊天返回
-(void)sendIMCB:(NSString*)result;

// 请求聊天服务器
-(void)getChatServerCB:(NSString*)serverAddress :(NSString*)port;

// 获得好友列表
-(void)getFriendsCB:(NSArray*)friends;

// 发送聊天信息
//-(void)sendIMCB :(NSString*)result;

-(void)searchFriendCB:(NSArray*)friends;

//##########集成信IM之后添加的回调############

/**
 *查找好友回调
 */
-(void)checkFriendsCB:(NSArray *)data;
/**
 *同意添加好友回调
 */
-(void)addFriendsCB:(NSArray *)data;
/**
 *删除好友
 */
-(void)deleteGoodfriendCB:(int)result;
/**
 *创建固定群回调
 */
-(void)creatGroupCB:(NSDictionary *)data;
/**
 *查找群回调
 */
-(void)findGroupCB:(NSDictionary *)data;
/**
 *返回联系人列表
 */
-(void)requestContactListCB:(NSDictionary *)data;

/**
 *获取群成员列表返回
 */
-(void)requestGroupMembersCB:(NSArray *)data;
/**
 *解散群回调
 */
-(void)disbandGroupCB:(int)result;
/**
 *退出群回调
 */
-(void)exitGroupCB:(int)result;
/**
 *群信息回调
 */
-(void)requestGroupInfoCB:(NSDictionary *)data;
/**
 *添加某人进群回调
 */
-(void)addFriendsToGroupCB:(NSArray *)result;
/**
 *添加某人到进交流厅
 */
-(void)addFriendsToTempGroupCB:(NSArray *)result;
/**
 *移除群成员回调
 */
-(void)deleteGroupMemberCB:(int)result;
@end
