//
//  DataBaseSimple.h
//  侧滑Demo
//
//  Created by 毛志 on 14-7-2.
//  Copyright (c) 2014年 maozhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendCellModel.h"

@interface DataBaseSimple : NSObject
/**
 *当前登录用户userid
 */
@property(nonatomic,copy) NSString *loginUserid;
/**
 *数据库的初始化
 */
+ (DataBaseSimple *)shareInstance;

#pragma mark-Friends

/**
 *好友表格插入数据
 */
- (void)insertFriendswithModel:(FriendCellModel *)model;
/**
 *删除好友数据
 */
- (void)deleteFriendswithUserid:(NSString *)userid;
/**
 *查询好友数据(全部)
 */
- (NSMutableArray *)selectFriends;
/**
 *删除所有好友数据（不能删除群成员）
 */
-(void)deleteFriends;
/**
 *userid查询好友数据
 */
- (FriendCellModel *)selectFriendsWithUserid:(NSString *)userid;

#pragma mark-Groups

/**
 *群表格插入数据
 */
- (void)insertGroupsWithModel:(BaseCellModel *)model;
/**
 *删除群数据
 */
-(void)deleteGroupswithHxgroupid:(NSString *)hxgroupid;
- (void)updateDBwithKey:(NSInteger)key withModel:(FriendCellModel *)model;
/**
 *获取全部群成员
 */
-(NSMutableArray *)selectAllGroups;
/**
 *查询群数据(固定群)
 */
-(NSMutableArray *)selectGroups;
/**
 *查询群数据(临时群)
 */
-(NSMutableArray *)selectTempGroups;
/**
 *删除所有的群数据
 */
-(void)deleteGroups;
/**
 *通过环信群ID查询群数据
 */
-(BaseCellModel *)selectGroupsWithHxgroupid:(NSString *)hxgroupid;

#pragma mark-MessageIDs

/**
 *根据username插入messageid
 */
- (void)insertMessageidWithMessageid:(NSString *)messageid username:(NSString *)username;
/**
 *根据username查询messageIDs
 */
-(NSMutableArray *)selectMessageidsWithUsername:(NSString *)username;
/**
 *分页查询messageIDs
 */
-(NSMutableArray *)selectPageMessageidsWithUsername:(NSString *)username start:(int)start count:(int)count;
/**
 *根据username删除messageids
 */
- (void)deleteMessageidWithUsername:(NSString *)username;

#pragma mark-GroupMembers

/**
 *插入群成员
 */
- (void)insertMemberWithModel:(FriendCellModel *)model hxgroupid:(NSString *)hxgroupid;
/**
 *查询群成员
 */
-(NSMutableArray *)selectMembersWithHxgroupid:(NSString *)hxgroupid;
/**
 *移除群成员
 */
- (void)deleteGroupMemberWithHxgroupid:(NSString *)hxgroupid userid:(NSString *)userid;
/**
 *移除某个群的全部成员
 */
- (void)deleteGroupMemberWithHxgroupid:(NSString *)hxgroupid;

@end
