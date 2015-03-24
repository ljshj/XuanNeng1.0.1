//
//  FDSUserCenterMessageManager.h
//  FDS
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "ZZMessageManager.h"
#import "FDSUserCenterMessageInterface.h"
#import "ZZSessionManager.h"

enum MODIFY_PROFILE
{
    MODIFY_PROFILE_NONE,
    MODIFY_PROFILE_NAME,
    MODIFY_PROFILE_ICON,
    MODIFY_PROFILE_SEX,
    MODIFY_PROFILE_COMPANY,
    MODIFY_PROFILE_JOB,
    MODIFY_PROFILE_PHONE,
    MODIFY_PROFILE_TEL,
    MODIFY_PROFILE_GOLFAGE,
    MODIFY_PROFILE_BRIEF,
    MODIFY_PROFILE_HANDICAP,
    MODIFY_PROFILE_EMAIL,
    MODIFY_PROFILE_MAX
};

//定义请求消息的类型（当前用户的／个人名片的／添加好友的）
typedef enum {
    UserInfoTypeNormal,
    UserInfoTypeCurrentUserInfo,
    UserInfoTypeOtherUserInfo,
    UserInfoTypeAddFriend
}UserInfoType;

@interface FDSUserCenterMessageManager : ZZMessageManager
/**
 *定义请求消息的类型（当前用户的／个人名片的／添加好友的）
 */
@property(assign,nonatomic) UserInfoType userInfoType;

+ (FDSUserCenterMessageManager*)sharedManager;
- (void)registerObserver:(id<UserCenterMessageInterface>)observer;
- (void)unRegisterObserver:(id<UserCenterMessageInterface>)observer;

//************bg用户注册*****
//bg获取用户注册的验证码
-(void)userRequestVerifyCode:(NSString*)phoneNum;
//bg 用户输入验证码后的请求
- (void)userRegister:(NSString*)phoneNumber :(NSString*)authCode;
//bg 用户注册
-(void)userRegisterWithPhoneNum:(NSString*)pNum
                         userid:(NSString*)userid
                            pwd:(NSString*)pwd;


//bg********用户登陆***********
- (void)userLogin:(NSString*)userAccount :(NSString*)passsword;


//bg忘记密码时获取验证码
-(void)userRequestVerifyCodeForForgetPWD:(NSString *)phoneNum;

// bg 换一批bg帐号
-(void)userRequestRenewCodes:(NSString*)phoneNum;

//bg忘记密码时重置密码
-(void)userResetPWDWithUserID:(NSString*)userID pwd:(NSString*)pwd;

//bg 忘记密码时验证手机号
-(void)userVerifyPNum:(NSString*)pNum withVerifyCode:(NSString*)code;

//bg 获取个人资料
-(void)userRequestUserInfo:(NSString*)userid;

//批量获取用户资料
-(void)requestUserInfoWithUserids:(NSArray *)userids;

//获取空闲业务服务器地址
-(void)requestLeisureBusinessServerAddress;

//搜索首页热词
-(void)searchHotWord;
/**
 *查找交流厅
 */
-(void)searchTempGroupWithKeyword:(NSString *)keyword;

//bg 搜索我能或我想
-(void)searchIWantOrICan:(int)type keyWord:(NSString*)word latitude:(double)latitude longitude:(double)longitude;
/**
 *会员分页搜索请求
 */
-(void)searchMemberWithType:(int)type keyword:(NSString *)keyword start:(int)start end:(int)end;
/**
 *微墙分页搜索请求
 */
-(void)searchWeiQiangWithType:(int)type keyword:(NSString *)keyword start:(int)start end:(int)end;
/**
 *橱窗分页搜索请求
 */
-(void)searchShowwindowWithType:(int)type keyword:(NSString *)keyword start:(int)start end:(int)end;
//版本更新
-(void)versionUpdateWithType:(NSString *)type;

// bg 修改“我能”
-(void)updateICan:(NSString*)ican;
//bg 修改 “我需”
-(void)updateINeed:(NSString*)iNeed;
//bg 修改头像
-(void)updateUserIcon:(NSString*)iconURL;
// bg修改个人昵称
-(void)updateNickName:(NSString*)nickName;

//bg 更新签名
-(void)updateSignature:(NSString*)signature;
//bg 0 女 1 男 2 保密
-(void)updateSex:(int)sex;
//bg
-(void)updateAge:(int)age;
//bg
-(void)updateBirthday:(NSString*)birthday;
//bg修改星座
-(void)updateConste:(NSString*)conste;
//bg
-(void)updateHometown:(NSString*)hometown;
//bg修改所在地
-(void)updateLocalplace:(NSString*)localplace;
//bg
-(void)updateEmail:(NSString*)email ;
//bg 更新血型
-(void)updateBtype:(NSString*)btype;

//更新位置信息(20003)
-(void)updateLocationWithLongitude:(CGFloat)longitude latitude:(CGFloat)latitude;

//20004 关注 or 取消关注
-(void)attentionPerson:(NSString*)userid
                  type:(int)type;

// 20005 关注对象 TYPE:0 我关注    1 关注我的
-(void)requestAttentionListWithType:(int)type
                              start:(int)start
                                end:(int)end;// 类似于count的作用

//20006
-(void)requestChangeToNewPWD:(NSString*)newPWD
                      oldPWD:(NSString*)oldPWD;

//20007,意见反馈
-(void)submitFeedbackWithMessage:(NSString *)message contactnum:(NSString *)contactnum;
//bg 搜索好友
- (void)searchFriends:(NSString*)KeyWord;

////********发送即时聊天***********
- (void)sendIM:(FDSChatMessage*)chatMessage;

//
////********用户注销***********
//- (void)userLogout:(NSString*)userID;

////********得到个人的好友列表***********
//- (void)getUserFriends:(NSString*)userID;
//

//
////***************发送添加好友请求****************
//- (void)addFriend:(NSString*)friendID :(NSString*)queryInfo;
//
////***************回复加好友请求****************
//- (void)addFriendRequestReply:(NSString*)friendID :(NSString*)result;
//
//
////***************获取好友的个人名片****************
//- (void)getUserCard:(NSString*)friendID;
//
////***************删除好友****************
//- (void)subFriend:(NSString*)friendID;
//
////***************修改好友备注名****************
//- (void)modifyFriendsRemarkName:(NSString*)friendID :(NSString*)remarkName;
//
////***************得到用户企业列表****************
//- (void)getJoinedCompanyList;
//
////***************得到个人动态****************
//- (void)getUserRecord:(NSString*)friendID :(NSString*)recordID :(NSString*)getWay :(NSInteger)count;
//
////***************发表个人动态****************
//- (void)sendUserRecord:(NSString*)content :(NSMutableArray*)images;
//
////***************发表评论，回复(都不支持图片)****************
//- (void)sendRecordCommentRevert:(NSString*)recordID :(NSString*)content :(NSString*)type :(NSString*)revertedID;
//
////***************删除动态，评论，回复****************
//- (void)deleteRecordCommentRevert:(NSString*)commentObjectID :(NSString*)type :(NSString*)objectID;
//
////***************意见反馈****************
//- (void)feedback:(NSString*)content :(NSString*)contactWay;
//
////***************修改密码****************
//- (void)modifyPassword:(NSString*)sessionID;
//
//- (void)modifyPassword:(NSString*)sessionID :(NSString*)phoneNum;
//
//- (void)modifyNewPassword:(NSString*)sessionID :(NSString*)authCode :(NSString*)newPassword;
//- (void)modifyNewPassword:(NSString*)sessionID :(NSString*)authCode :(NSString*)newPassword :(NSString*)phoneNum;
//
//
////***************得到群成员****************
//- (void)getGroupMembers:(NSString*)groupID :(NSString*)groupType;
//
////***************删除群成员****************
//- (void)deleteGroupMember:(NSString*)deletedorID :(NSString*)groupID :(NSString*)groupType;
//
//
////***************验证用户为平台用户****************
//- (void)checkUsersMembersByPhone:(NSMutableArray*)userList;
//
////***************获取推送设置****************
//- (void)getPushSetting;
//
////***************修改推送设置****************
//- (void)setPushSetting:(NSString*)ONOFF :(NSInteger)setType;
//
////***************检查版本更新****************
//- (void)checkVersion;

@end
