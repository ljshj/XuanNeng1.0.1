//
//  UserManager.h
//  FDS
//
//  Created by zhuozhong on 14-1-22.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGUser.h"
#import "FDSUserCenterMessageManager.h"
#import "ZZSessionManagerInterface.h"
#import "EaseMob.h"
#import "NotificationModel.h"
#import "DataBaseSimple.h"
#define didLeaveFromGroup @"didLeaveFromGroup"
#define didAcceptedByFriend @"didAcceptedByFriend"

#define SetupMessageBadgeCountKey @"setupMessageBadgeCount"
#define SetupContactBadgeCountKey @"setupContactBadgeCount"

//定义个人信息请求类型(好友请求／群请求)
typedef enum {
    RequestUserInfoTypeNomal,//这个是默认的，没啥用
    RequestUserInfoTypeFriend,
    RequestUserInfoTypeGroup
}RequestUserInfoType;

//定义群信息请求类型(个人中心发出去的才会调用函数)
typedef enum {
    RequestGoupInfoTypeNomal,//这个是默认的，没啥用
    RequestGoupInfoTypeUserManager
}RequestGoupInfoType;

@interface FDSUserManager : NSObject<UserCenterMessageInterface,ZZSessionManagerInterface,ZZSocketInterface,EMChatManagerDelegate,PlateformMessageInterface>
{
    BGUser *m_user;
    enum USERSTATE m_userState;
}
/**
 *被同意后记录下来的userid，用于插入数据库用的
 */
@property(nonatomic,copy) NSString *agreeUserid;
/**
 *个人信息的请求类型（好友请求／进群申请）
 */
@property(nonatomic,assign) RequestUserInfoType requestUserInfoType;
/**
 *
 */
@property(nonatomic,assign) RequestGoupInfoType requestGoupInfoType;
/**
 *徽章数量
 */
@property(nonatomic,assign) int badgeCount;
/**
 *通知消息数组
 */
@property(nonatomic,strong) NSMutableArray *messages;
/**
 *通知消息(好友请求)
 */
@property(nonatomic,copy) NSString *message;
/**
 *记录下要进群的群名
 */
@property(nonatomic,copy) NSString *groupname;
/**
 *环信群组id
 */
@property(nonatomic,copy) NSString *hxgroupid;
/**
 *是否是被删除好友发送的消息,回调的时候要用
 */
@property(nonatomic,assign) BOOL isDeleteByGoodFriend;
/**
 *是否调用环信接口增加或者删除好友
 */
@property(nonatomic,assign) BOOL isAddAndDeleteByHX;
/**
 *判断程序是否在后台，默认是NO,默认在前台
 */
@property(nonatomic,assign) BOOL isApplicationBackGround;
/**
 *是否在修改密码之后登录的，如果是，环信就不重新登录了，重新登录会显示失败
 */
@property(nonatomic,assign) BOOL isChangePassWord;
/**
 *联系控制器是否已经存在了,存在了就不发送通知了
 */
@property(nonatomic,assign) BOOL isAppearContactConVC;

+(FDSUserManager*)sharedManager;
- (enum USERSTATE)getNowUserState;
- (void)setNowUserState:(enum USERSTATE)userState;
- (BGUser*)getNowUser;

- (void)modifyNowUser:(BGUser*)userInfo;
- (void)setNowUserWithStyle:(enum MODIFY_PROFILE)modifyType withContext:(NSString*)context;
-(NSString*)NowUserID;
-(void)setNowUserIDEmpty;
// 获取到用户信息后，更新用户信息
-(void)getUserInfoCB:(NSDictionary*)data;
@end
