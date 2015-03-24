//
//  FDSUserCenterMessageInterface.h
//  FDS
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//  
#import <Foundation/Foundation.h>

@class FDSMessageCenter;
@class FDSChatMessage;
@class BGUser;

@protocol UserCenterMessageInterface <NSObject>

@optional
//bg注册获取验证码
- (void)userRequestVerifyCodeCB:(NSString*)result :(NSString*)authCode :(NSString*)timeout;
//bg发送验证码注册
- (void)userSendVerifyCB:(NSDictionary*)dic;


//bg 更换一批验证码
-(void)userRenewCodesCB:(NSDictionary*)dic;

//bg用户输入密码完成注册的回调
-(void)userRegisterCB:(NSDictionary*)dic;

-(void)userLoginCB:(NSDictionary*)dic;

// 发送密码完成注册的回调
- (void)userLoginCB:(NSString *)result :(NSString *)reason :(BGUser *)user;  //登录


// bg 忘记密码请求验证码
-(void)userRequestVerifyCodeForForgetPWDCB:(NSDictionary*)dic;


// 用户忘记密码后，重置密码的回调
-(void)userResetPwdForForgetPwdCB:(NSDictionary*)dic;

// bg获取个人资料
-(void)getUserInfoCB:(NSDictionary*)dic;



//bg 搜索好友的回调
-(void)searchFriendCB:(NSDictionary*)dic;



//bg TODO::2014年09月18日
-(void)upDateUserInfoCB:(int)returnCode;

//更新位置信息
-(void)updatLocationCB:(int)returnCode;

//bg 2014年09月27日 关注 or 取消关注
-(void)attentionPersonCB:(int)returnCode;


//bg 20005
-(void)requestAttentionListCB:(NSArray*)persons;

//bg 20005 添加type 用于区分我的粉丝 和我的关注
-(void)requestAttentionListCB:(NSArray*)persons Type:(int)type;

//bg 20006 修改密码的回调
-(void)requestChangePWDCB:(int)returnCode;

//20007 意见反馈回调
-(void)submitFeedBackCB:(int)returnCode;

//bg 40001 获取搜索结果
-(void)searchIWantOrICanCB:(NSDictionary*)dic;
/**
 *会员分页搜索请求
 */
-(void)searchMemberCB:(NSDictionary *)data;
/**
 *微墙分页搜索请求
 */
-(void)searchWeiQiangCB:(NSDictionary *)data;
/**
 *橱窗分页搜索请求
 */
-(void)searchShowwindowCB:(NSDictionary *)data;
//40007 获取关键词
-(void)searchHotWordCB:(NSDictionary *)dic;
/**
 *查询交流厅
 */
-(void)searchTempGroupCB:(NSDictionary *)dic;

//本版升级80001
-(void)versionUpdateCB:(NSDictionary *)dic;

-(void)requestLeisureBusinessServerAddressCB:(NSDictionary *)dic;

- (void)userLogoutCB:(NSString*)result; //用户注销


- (void)getUserFriendsCB:(NSMutableArray*)friendList;//个人的好友列表

- (void)sendIMCB:(NSString*)result :(NSString*)messageID;//即时聊天

- (void)getIMCB:(FDSChatMessage*)chatMessage :(FDSMessageCenter*)messageCenter; //push 收消息

/* push消息 收到对方的添加好友请求 */
- (void)addFriendRequestCB:(FDSMessageCenter*)centerMessage :(BGUser*)friendInfo;

/* push消息 发出添加好友请求后收到的回复 */
- (void)addFriendReplyCB:(BGUser*)friendInfo :(FDSMessageCenter*)messageCenter;

/* 查找好友 */
- (void)searchFriendsCB:(NSMutableArray*)friendList;

/*  获取好友的个人名片 */
- (void)getUserCardCB:(BGUser*)contactInfo :(NSString*)result;

/*    主动删除好友 */
- (void)subFriendCB:(NSString*)result :(BGUser*)friendInfo;

/*  push消息  被好友对方删除  */
- (void)subedFriend:(BGUser*)friendInfo;

/*    修改好友备注名   */
- (void)modifyFriendsRemarkNameCB:(NSString*)result;

/*   得到用户企业列表  */
- (void)getJoinedCompanyListCB:(NSMutableArray*)companyList;

/*    得到个人动态       */
- (void)getUserRecordCB:(NSMutableArray*)recordList;

/*    发表个人动态      */
- (void)sendUserRecordCB:(NSString*)result :(NSString*)recordID;

/*    发表评论，回复(都不支持图片)     */
- (void)sendRecordCommentRevertCB:(NSString*)result :(NSString*)commentID;

/*    删除动态，评论，回复     */
- (void)deleteRecordCommentRevertCB:(NSString*)result;

/*   意见反馈     */
-(void)feedbackCB:(NSString*)result;

//***************修改密码****************
- (void)modifyPasswordCB:(NSString*)result :(NSString*)authCode :(NSString*)timeout :(NSString*)sessionID;

- (void)modifyNewPasswordCB :(NSString*)result :(NSString*)reason;

/*    得到群成员     */
- (void)getGroupMembersCB:(NSString*)groupName :(NSString*)groupIcon :(NSString*)relation :(NSMutableArray*)friendList;

/*   删除群成员   */
- (void)deleteGroupMemberCB:(NSString*)result;

/*    验证用户为平台用户     */
- (void)checkUsersMembersByPhoneCB:(NSMutableArray*)resultList;

/*    好友修改名称 修改头像消息推送     */
- (void)cardInfoModifyCB:(NSString*)cardType :(NSString*)modifyName :(NSString*)modifyIcon :(NSString*)userID;

/*      获取推送设置       */
- (void)getPushSettingCB:(NSString*)result :(NSString*)restMode :(NSString*)systemPushMessage :(NSString*)friendPushMessage;

/*        修改推送设置        */
- (void)setPushSettingCB:(NSString*)result;

/*        检查版本更新        */
- (void)checkVersionCB:(NSString*)version :(NSString*)downloadURL;

/**
 *批量获取用户信息回调
 */
-(void)requestUserInfoWithUseridsCB:(NSDictionary *)data;

@end
