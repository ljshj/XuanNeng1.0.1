//
//  BGSessionHeader.h
//  BGProject
//
//  Created by ssm on 14-9-2.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

// 添加bg 项目中的所有网络协议用到的常量
// 主要有 messageType
//      classType


#ifndef BGProject_BGSessionHeader_h
#define BGProject_BGSessionHeader_h

// 所有消息类型
enum MESSAGETYPE{
    MESSAGETYPE_NONE,
    

    kMessageType_RequreVerify = 10001, // 请求手机验证码
    
    kMessageType_Verify = 10002,     // 获取到服务器的验证码后,验证用户输入的验证码
    kMessageType_RenewCodes = 10003, // 更换一批bg帐号
    kMessageType_Register = 10004,   // 用户输入密码后的注册请求
    
    kMessageType_Login = 10005,     // 用户登录
    kMessageType_forgetPWD = 10006, //忘记密码时获取验证码
    
    kMessageType_resetPWD = 10007,  //忘记密码时重置密码
    kMessageType_VerifyPnum = 10008,//忘记密码时验证手机号
    
    kMessageType_userInfo = 20001,//获取个人资料
    kMessageType_upDateInfo = 20002,//修改"我能”,"我需”，“头像”等信息
    
    kMessageType_searchICanOrIWant = 40001, // 搜索我想 我能
    kMessageType_searchHotWord = 40007, //搜索热词
    
    kMessageType_leisureBusinessServerAddress = 10009,//空闲业务服务器地址
    
    kMessageType_searchFrieds = 50009,      // 搜索好友
    
    kMessageType_WeiQiang = 60001,       //获取炫墙列表
    
    //添加商品
    kMessageType_AddProduct = 30003,
    
    MESSAGETYPE_MAX
    
};

// 定义回应消息的消息类型
enum RESPOND_MESSAGETYPE {
    RESPOND_MESSAGETYPE_NONE,
    kRespondMessageType_RequreVerify = 810001,
    kRespondMessageType_Verify    =  810002,

    kRespondMessageType_RenewCodes = 810003,
    kRespondMessageType_Register  =  810004,

    
    kRespondMessageType_Login     =  810005,
    kRespondMessageType_forgetPWD =  810006,
    
    //添加商品
    kRespondMessageType_AddProduct = 830003,
    
    kRespondMessageType_resetPWD = 810007,
    kRespondMessageType_userInfo = 820001,
    
    kRespondMessageType_searchFrieds = 850009,
    kRespondMessageType_WeiQiang = 860001,       //获取炫墙列表
    
    RESPOND_MESSAGETYPE_MAX
};


// 标记发送消息的类
enum ClassTYPE{
    ClassTYPE_NONE,
    kFDSUserCenterMessageClass = 10,//个人中心 登录、忘记密码、个人资料
    kSystemMessageManagerClass = 20,// 在注册FDSPublicMessageManager时使用
    kUploadManagerClass = 30,
    kUserStoreMessageClass = 40,//个人商城
    kPlatformMessageClass = 50,//平台     聊天、群
    kModuleMessageClass = 60,//模块部分    微墙、炫能
    kPublicMessageClass = 70,//公共部分
    
    
    //kFDSPublicMessageManagerClass = 2,

    
    ClassTYPE_MAX
    
};



#define kItemId @"itemid"

#define kMessageTypeKey    @"MessageType"
#define kMessageClassKey   @"MessageClass"
#define kPnumKey           @"pnum"

// 用户验证码的key
#define kVerfyKey          @"verfy"
// 用户是否验证成功
#define kVerfiedKey       @"verfied"
#define kUseridKey       @"userid"

#define kPwdKey            @"pwd"
#define kSuccessKey     @"success"
#define kTokenKey       @"token"

#define kBserverKey     @"bserver"
#define kFserverKey     @"fserver"

#define kIdKey              @"id"
#define kIdsKey             @"ids"

#define kSearchTypeKey     @"type"
#define kKeyWordKey         @"keyword"

#define kLongitudeKey       @"longitude"
#define kLatitudeKey        @"latitude"

#define kTagKey            @"tag"
#define kExtraKey          @"extra"




#define kChangeTypeKey         @"type"
#define kChangeValueKey        @"value"

#define kStartKey           @"start"
#define kEndKey             @"end"


#define kICanKey            @"ican"
#define kINeedKey           @"ineed"
#define kPhotoKey           @"photo"

#define kNickNameKey        @"nickn"
#define kSignatureKey       @"signature"
#define kSexKey             @"sex"

#define kBirthdayKey        @"birthday"
#define kConsteKey          @"conste" //星座
#define kHometownKey        @"hometown"

#define kLoplaceKey         @"loplace"
#define kEmailKey           @"email"
#define kBtypeKey           @"btype"        //血型

#define kNicktitleKey       @"nicktitle"
#define kLevelKey            @"level"
#define kFavorKey           @"favor"

#define kCreditKey          @"credit"

#define kExpKey             @"exp"
#define kGuanzhuKey         @"guanzhu"
#define kFansnumberKey      @"fansnumber"

#define kWeiqiangKey        @"weiqiang"


#define kComment_startKey   @"comment_start"
#define kComment_endKey     @"comment_end"


#define kXnIDKey            @"xnid"
#define kMsgbodyKey            @"msgbody"
#define kJokeIDKey             @"jokeid"

#define kReturnCodeKey      @"returnCode"

#define kTypeKey    @"type"


#endif
