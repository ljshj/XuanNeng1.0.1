//
//  FDSUserCenterMessageManager.m
//  FDS
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//
#import "NSMutableDictionary+Zhangxx.h"
#import "FDSUserCenterMessageManager.h"
#import "FDSUserManager.h"
#import "FDSPublicManage.h"

#import "FDSComment.h"
#import "FDSComDesigner.h"
#import "BGSessionHeader.h"
#import "ZZLocationManager.h"
#import "WeiQiangModelAtHome.h"
#import "TLProductModel.h"
#import "AppModel.h"
#import "MemberModel.h"
#import "weiQiangModel.h"

#import "NSMutableDictionary+Zhangxx.h"
#import "FriendModel.h"

#import "NSMutableArray+TL.h"
#import "NSArray+TL.h"
#import "EaseMob.h"
#import "ProductModel.h"

#define FDSUserCenterMessageClass @"fdsUserCenterMessageManager"

@implementation FDSUserCenterMessageManager
static FDSUserCenterMessageManager *instance = nil;
+(FDSUserCenterMessageManager*)sharedManager
{
    if(nil == instance)
    {
        instance = [FDSUserCenterMessageManager alloc ];
        [instance initManager];
    }
    return instance;
}

- (void)initManager
{
    self.observerArray = [[NSMutableArray alloc]initWithCapacity:0];
    // bg 需要通过value:self key:uint16
  //  [self registerMessageManager:self :FDSUserCenterMessageClass];
    [[ZZSessionManager sharedSessionManager] registerMessageObserver:self
                               messageClass:kFDSUserCenterMessageClass];
    
    [[ZZSessionManager sharedSessionManager] registerObserver:self];
}

- (void)registerObserver:(id<UserCenterMessageInterface>)observer
{
    if ([self.observerArray containsObject:observer] == NO)
    {
        [self.observerArray addObject:observer];
    }
}

- (void)unRegisterObserver:(id<UserCenterMessageInterface>)observer
{
    if ([self.observerArray containsObject:observer])
    {
        [self.observerArray removeObject:observer];
    }
}

// 参考FDS 的parseMessageData
- (void)parseMessageData:(NSDictionary *)data
{
    int msgType = [[data objectForKey:kMessageTypeKey] intValue];
    NSAssert(msgType!=0, @"没有解析到msgtype");
    //TODO::debug 分发任务.重点调试位置！
    
    switch (msgType) {
            // 获取到手机的验证码 810001
        case kRespondMessageType_RequreVerify:
            [self dispatchUserRequestVerifyCodeCB:data];
            break;
            
            // 用户输入验证码
        case kRespondMessageType_Verify:
            [self dispatchUserVerifyCB:data];
            break;
            
        case kRespondMessageType_RenewCodes:
            [self dispatchRenewCodesCB:data];
            break;
            // 用户输入密码进行注册
        case kRespondMessageType_Register:
            [self dispatchUserRegisterCB:data];
            
        case kRespondMessageType_Login:
            [self dispatchUserLoginCB:data];
            break;
            
        case kRespondMessageType_userInfo:
            [self dispatchUserInfo:data];
            break;
            // 忘记密码时，请求验证码
        case kRespondMessageType_forgetPWD:
            [self dispatchRequestVerfyForForgetPwd:data ];
            break;
          
            // 重置密码的回调
        case kRespondMessageType_resetPWD :
            [self dispatchResetPWD:data];
            break;
            

        case kRespondMessageType_searchFrieds:
            [self dispatchSearchFriends:data];
            break;
            
        case 820002:
            [self dispatchUpDateUserInfo:data];
            break;
        case 820003:
        {
            int returnCode = [data[@"returnCode"] intValue];
            
            for(id<UserCenterMessageInterface> interface in self.observerArray)
            {
                if([interface respondsToSelector:@selector(updatLocationCB:)])
                {
                    [interface updatLocationCB:returnCode];
                }
            }
           
            break;
        }
            
        //请求我关注 或 关注我的对象
        case 820005:
            [self dispatchAttentionList:data];
            break;
            
        case 820006:
        {
            int returnCode = [data[@"returnCode"] intValue];
            for(id<UserCenterMessageInterface> interface in self.observerArray)
            {
                if([interface respondsToSelector:@selector(requestChangePWDCB:)])
                {
                    [interface requestChangePWDCB:returnCode];
                }
            }
        }
            break;
        case 820007:
        {
            int returnCode = [data[@"returnCode"] intValue];
            for(id<UserCenterMessageInterface> interface in self.observerArray)
            {
                if([interface respondsToSelector:@selector(submitFeedBackCB:)])
                {
                    [interface submitFeedBackCB:returnCode];
                }
            }
            break;
        }
        case 820004:
            [self dispatchAttentionPerson:data];
            break;
            
        case 840001:
            [self dispatchSearchIWantOrICan:data];
            
            break;
        case 840002:
            
            for(id<UserCenterMessageInterface> interface in self.observerArray)
            {
                if([interface respondsToSelector:@selector(searchMemberCB:)]) {
                    [interface searchMemberCB:data];
                }
            }
            
            break;
        case 840003:
            
            for(id<UserCenterMessageInterface> interface in self.observerArray)
            {
                if([interface respondsToSelector:@selector(searchWeiQiangCB:)]) {
                    [interface searchWeiQiangCB:data];
                }
            }
            
            break;
        case 840004:
            
            for(id<UserCenterMessageInterface> interface in self.observerArray)
            {
                if([interface respondsToSelector:@selector(searchShowwindowCB:)]) {
                    [interface searchShowwindowCB:data];
                }
            }
            
            break;
        case 840007:
            
            [self dispatchSearchHotWord:data];
    
            break;
        case 880001:
            [self dispatchVersionUpdate:data];
            
            break;
        case 840009:
        {
            for(id<UserCenterMessageInterface> interface in self.observerArray)
            {
                if([interface respondsToSelector:@selector(searchTempGroupCB:)]) {
                    [interface searchTempGroupCB:data];
                }
            }
            
            break;
        }
        case 810009:
            [self requestLeisureBusinessServerAddress:data];
            
            break;
        case 850029:
            [self requestUserInfoWithUseridsWithData:data];
            
            break;
        
        default:
        
            break;
    }
    
    
}

-(void)requestUserInfoWithUseridsWithData:(NSDictionary *)data{
    
    for(id<UserCenterMessageInterface> interface in self.observerArray)
    {
        if([interface respondsToSelector:@selector(requestUserInfoWithUseridsCB:)])
            [interface requestUserInfoWithUseridsCB:data];
    }
    
    
}

// 请求服务器的注册码
-(void)dispatchUserRequestVerifyCodeCB:(NSDictionary*)data {
    
    NSString *authCode  = [data objectForKey:kVerfyKey];
    for(id<UserCenterMessageInterface> interface in self.observerArray)
    {
        if([interface respondsToSelector:@selector(userRequestVerifyCodeCB:::)])
            [interface userRequestVerifyCodeCB:nil:authCode:nil];
    }
}

// 验证服务器的验证码
-(void)dispatchUserVerifyCB:(NSDictionary*)data {
    
    for(id<UserCenterMessageInterface> interface in self.observerArray)
    {
        if([interface respondsToSelector:@selector(userSendVerifyCB:)]) {
            
            [interface userSendVerifyCB:data];
        }
    }
}

// 用户请求更换bg codes 后的回掉
-(void)dispatchRenewCodesCB:(NSDictionary*)data {
    for(id<UserCenterMessageInterface> interface in self.observerArray)
    {
        // 该方法在FDSUserCenterMessageInterface 已经完成声明！
        if([interface respondsToSelector:@selector(userRenewCodesCB:)]) {
            
            [interface userRenewCodesCB:data];
        }
    }
}

// 用户发送玩注册消息后的回调
-(void)dispatchUserRegisterCB:(NSDictionary*)data {
    
    for(id<UserCenterMessageInterface> interface in self.observerArray)
    {
        if([interface respondsToSelector:@selector(userRegisterCB:)]) {
            
            [interface userRegisterCB:data];
        }
    }
}


-(void)dispatchResetPWD:(NSDictionary*)dic {
    for(id<UserCenterMessageInterface> interface in self.observerArray)
    {
        // TODO::2014年09月13日
        if([interface respondsToSelector:@selector(userResetPwdForForgetPwdCB:)]) {
            [interface userResetPwdForForgetPwdCB:dic];
        }
    }
}




-(void)dispatchSearchFriends:(NSDictionary*)dic {
    for(id<UserCenterMessageInterface> interface in self.observerArray)
    {
        // TODO::2014年09月13日
        if([interface respondsToSelector:@selector(searchFriendCB:)]) {
            [interface searchFriendCB:dic];
            
        }
    }
}



//用户登录回调
-(void)dispatchUserLoginCB:(NSDictionary*)data {
    for(id<UserCenterMessageInterface> interface in self.observerArray)
    {
        if([interface respondsToSelector:@selector(userLoginCB:)]) {
            
            [interface userLoginCB:data];
        }
    }
}


//用户更新用户信息，如血型btype 等
-(void)dispatchUpDateUserInfo:(NSDictionary*)data {
    int returnCode = [data[kReturnCodeKey] intValue];
    for(id<UserCenterMessageInterface> interface in self.observerArray){
        if([interface respondsToSelector:@selector(upDateUserInfoCB:)]) {
            [interface upDateUserInfoCB:returnCode];
        }
    }
}


// 820004
-(void)dispatchAttentionPerson:(NSDictionary*)data {
    int returnCode = [data[kReturnCodeKey] intValue];
    for(id<UserCenterMessageInterface> interface in self.observerArray){
        if([interface respondsToSelector:@selector(attentionPersonCB:)]) {
            [interface attentionPersonCB:returnCode];
        }
    }
}


// 获取关注列表 820005
-(void )dispatchAttentionList:(NSDictionary*)data {
    
    //取出关注模型的数组
    NSMutableArray* array = [NSMutableArray array];
    NSArray* items = data[@"items"];
    
    if (data[@"items"]==[NSNull null]) {
        return;
    }
    
    for(int i=0; i<[items count]; i++ ) {
        
        //将字典转换成模型
        FriendModel* model = [[FriendModel alloc]initWithDic:items[i]];
        
        [array addObject:model];
    }
    
    for(id<UserCenterMessageInterface> interface in self.observerArray){
        
        if([interface respondsToSelector:@selector(requestAttentionListCB:)]) {
                [interface requestAttentionListCB:array];
        }
    }
}

// 分发用户信息的数据 TODO::添加 FDSUserManager 更新用户数据
-(void)dispatchUserInfo:(NSDictionary*)data {
    for(id<UserCenterMessageInterface> interface in self.observerArray)
    {
        if([interface respondsToSelector:@selector(getUserInfoCB:)]) {
            
            [interface getUserInfoCB:data];
        }
    }
}

// 用户忘记密码后请求验证码返回
-(void)dispatchRequestVerfyForForgetPwd:(NSDictionary*)dic {
    for(id<UserCenterMessageInterface> interface in self.observerArray)
    {
        if([interface respondsToSelector:@selector(userRequestVerifyCodeForForgetPWDCB:)]) {
            [interface userRequestVerifyCodeForForgetPWDCB:dic];
        }
    }
}

////添加产品(添加商品) 的回调
//-(void)dispatchAddProduct:(NSDictionary*)dic {
//    for(id<FDSUserCenterMessageInterface> interface in self.observerArray) {
//        // 文档返回的数据为空,只是为了方便调试,显示结果
//        if([interface respondsToSelector:@selector(addProductCB:)]) {
//            [interface addProductCB:dic];
//        }
//    }
//}


//40001
-(void)dispatchSearchIWantOrICan:(NSDictionary*)dic {
    // dic 中的元素分解方法
    //apps的元素对应 appModel
    //cabinet 元素对应 CaibinetModel
    //members 元素对应 MemberModel
    //weiqiang 元素对应 weiqiangModel(注意:给为微墙只有5个字段)
    // id 、name、img、img_thum、content
    
    NSMutableDictionary* resultDic = [NSMutableDictionary dictionary];
    NSMutableArray* appsArr = [NSMutableArray array];
    NSMutableArray* cabinetArr = [NSMutableArray array];
    NSMutableArray* membersArr = [NSMutableArray array];
    NSMutableArray* weiqiangArr = [NSMutableArray array];
    
    NSArray* rawArr = nil;

    //apps
    rawArr = dic[@"apps"];
    [rawArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* rawDic = obj;
        
        AppModel* model = [[AppModel alloc] init];
        // 数组的每个元素都是一个字典
        [rawDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [model setValue:obj   forKey:key];
        }];
        
        [appsArr addObject:model];
    }];
    [resultDic setObject:appsArr forKey:@"apps"];
    
    
    //cabinet product
    rawArr = dic[@"cabinet"];
    //rawArr = [NSArray arrayWithFileName:@"product.plist"];
    [rawArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* rawDic = obj;

        TLProductModel* model = [[TLProductModel alloc] init];
        // 数组的每个元素都是一个字典
        [rawDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [model setValue:obj   forKey:key];
        }];
        [cabinetArr addObject:model];
    }];
    [resultDic setObject:cabinetArr forKey:@"cabinet"];
    
    //members
    rawArr = dic[@"members"];
    
    [rawArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* rawDic = obj;
        
        MemberModel* model = [[MemberModel alloc] init];
        // 数组的每个元素都是一个字典
        [rawDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [model setValue:obj   forKey:key];
        }];
        [membersArr addObject:model];
    }];
    
    [resultDic setObject:membersArr forKey:@"members"];
    
    
    //weiqiang
    rawArr = dic[@"weiqiang"];

    for (NSDictionary *dic in rawArr) {
        
        weiQiangModel* model = [[weiQiangModel alloc] initWithDic:dic];
        
        model.isSearchWeiQiang = YES;
        
        [weiqiangArr addObject:model];
        
    }
    
    [resultDic setObject:weiqiangArr forKey:@"weiqiang"];
    
    for(id<UserCenterMessageInterface> interface in self.observerArray) {

        if([interface respondsToSelector:@selector(searchIWantOrICanCB:)])
        {
            [interface searchIWantOrICanCB:resultDic];
        }
    }
}



//获取空闲业务服务器地址
-(void)requestLeisureBusinessServerAddress:(NSDictionary *)data{
    for(id<UserCenterMessageInterface> interface in self.observerArray)
    {
        if([interface respondsToSelector:@selector(requestLeisureBusinessServerAddressCB:)]) {
            
            [interface requestLeisureBusinessServerAddressCB:data];
        }
    }
}

//版本更新回调
-(void)dispatchVersionUpdate:(NSDictionary *)data{
    
    
    for(id<UserCenterMessageInterface> interface in self.observerArray)
    {
        if([interface respondsToSelector:@selector(versionUpdateCB:)]) {
            [interface versionUpdateCB:data];
        }
    }
    
}

//请求首页的热词
-(void)dispatchSearchHotWord:(NSDictionary *)data{
    for(id<UserCenterMessageInterface> interface in self.observerArray)
    {
        if([interface respondsToSelector:@selector(searchHotWordCB:)]) {
            [interface searchHotWordCB:data];
        }
    }
}

- (void)sendMessage:(NSMutableDictionary *)message
{
    
    // 添加发送消息的标记，等到服务器返回的时候，依据该标记找到发送者
    [message setObject:[NSNumber numberWithInt:kFDSUserCenterMessageClass] forKey:kMessageClassKey];
    
    [super sendMessage:message];
}

//********用户注册***********


//bg 请求用户注册的验证码
-(void)userRequestVerifyCode:(NSString*)phoneNum {
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:phoneNum forKey:kPnumKey];
    [dic setObject:[NSNumber numberWithInt:kMessageType_RequreVerify] forKey:kMessageTypeKey];
    [self sendMessage:dic];// add message Type
}


//bg 用户确认注册验证码
-(void)userRegister:(NSString *)phoneNumber :(NSString *)authCode {
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    [dic setObject:phoneNumber forKey:kPnumKey];
    [dic setObject:authCode forKey:kVerfyKey];
    NSNumber* msgType = [NSNumber numberWithInt:kMessageType_Verify];
    [dic setObject:msgType forKey:kMessageTypeKey];
    
    [self sendMessage:dic];
}

//bg 用户注册
-(void)userRegisterWithPhoneNum:(NSString*)pNum
                         userid:(NSString*)userid
                            pwd:(NSString*)pwd {
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:pNum forKey:kPnumKey];
    [dic setObject:userid  forKey:kUseridKey];
    [dic setObject:pwd  forKey:kPwdKey];
    NSNumber* msgType = [NSNumber numberWithInt:kMessageType_Register];
    [dic setObject:msgType forKey:kMessageTypeKey];
    [self sendMessage:dic];
}

//bg 用户登录
- (void)userLogin:(NSString*)userAccount :(NSString*)passsword
{
    /* 登录  */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    // sometimes userAccount or password is nil.
    if(userAccount==nil) {
        userAccount = @"";
    }
    if(passsword==nil) {
        passsword =@"";
    }
    
    [dic setObject:userAccount forKey:kUseridKey];
    [dic setObject:passsword forKey:kPwdKey];
    [dic setInt:kMessageType_Login forKey:kMessageTypeKey];
    //测试，添加额外的key,测试结果：服务器会无视，同时不会原样返回该key-value
    //[dic setObject:@"testValue" forKey:@"testKey"];
    [self sendMessage:dic];
}

//bg忘记密码时获取验证码
-(void)userRequestVerifyCodeForForgetPWD:(NSString *)phoneNum {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:phoneNum forKey:kPnumKey];
    [dic setInt:kMessageType_forgetPWD forKey:kMessageTypeKey];
    [self sendMessage:dic];
}

//bg 注册的时候，更换一批bg号码
-(void)userRequestRenewCodes:(NSString*)phoneNum {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:phoneNum forKey:kPnumKey];
    [dic setInt:kMessageType_RenewCodes forKey:kMessageTypeKey];
    [self sendMessage:dic];
}


//bg忘记密码时重置密码
-(void)userResetPWDWithUserID:(NSString*)userID pwd:(NSString*)pwd {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:userID forKey:kUseridKey];
    [dic setObject:pwd forKey:kPwdKey];
    [dic setInt:kMessageType_resetPWD forKey:kMessageTypeKey];
    [self sendMessage:dic];
}

//bg 忘记密码时验证手机号
-(void)userVerifyPNum:(NSString*)pNum withVerifyCode:(NSString*)code {
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    [dic setObject:pNum forKey:kPnumKey];
    [dic setObject:code forKey:kVerfyKey];
    [dic setInt:kMessageType_VerifyPnum forKey:kMessageTypeKey];
    [self sendMessage:dic];
}


//bg 获取个人资料
-(void)userRequestUserInfo:(NSString *)userid{
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    [dic setObject:userid forKey:kUseridKey];
    [dic setInt:kMessageType_userInfo forKey:kMessageTypeKey];
    [self sendMessage:dic];
}

//批量获取用户数据
-(void)requestUserInfoWithUserids:(NSArray *)userids{
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    [dic setObject:userids forKey:kUseridKey];
    [dic setInt:50029 forKey:kMessageTypeKey];
    
    [self sendMessage:dic];
    
}

- (void)userLogout:(NSString*)userID
{
    /* 用户注销  */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"userLogout" forKey:@"messageType"];
    [dic setObject:userID forKey:@"userID"];
    [self sendMessage:dic];
}

-(void)requestLeisureBusinessServerAddress{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setInt:kMessageType_leisureBusinessServerAddress forKey:kMessageTypeKey];
    [self sendMessage:dic];
}

//版本更新
-(void)versionUpdateWithType:(NSString *)type{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setInt:80001 forKey:kMessageTypeKey];
    [dic setObject:type forKeyedSubscript:@"type"];
    [self sendMessage:dic];
    
}

//搜索首页热词
-(void)searchHotWord{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setInt:kMessageType_searchHotWord forKey:kMessageTypeKey];
    
    [self sendMessage:dic];

}

//查询交流厅
-(void)searchTempGroupWithKeyword:(NSString *)keyword{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setInt:40009 forKey:kMessageTypeKey];
    
    [dic setObject:keyword forKey:@"keyword"];
    
    [self sendMessage:dic];
    
}

//bg
-(void)searchIWantOrICan:(int)type keyWord:(NSString*)word latitude:(double)latitude longitude:(double)longitude{
    /* 得到个人的好友列表 */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //组织字典
    [dic setInt:type forKey:kSearchTypeKey];
    [dic setObject:word forKey:kKeyWordKey];
    //NSDictionary *lation = [ZZLocationManager location];
    
    [dic setFloat:latitude forKey:kLatitudeKey];
    [dic setFloat:longitude forKey:kLongitudeKey];
    [dic setInt:kMessageType_searchICanOrIWant forKey:kMessageTypeKey];
    
    // 设置分页字段
    [dic setInt:0 forKey:@"start"];
    [dic setInt:10 forKey:@"end"];
    [self sendMessage:dic];
}

//会员分页搜索请求
-(void)searchMemberWithType:(int)type keyword:(NSString *)keyword start:(int)start end:(int)end{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setInt:40002 forKey:kMessageTypeKey];
    [dic setInt:type forKey:@"type"];
    [dic setObject:keyword forKey:@"keyword"];
    [dic setInt:start forKey:@"start"];
    [dic setInt:end forKey:@"end"];
    
    [self sendMessage:dic];
    
}

//微墙分页搜索请求
-(void)searchWeiQiangWithType:(int)type keyword:(NSString *)keyword start:(int)start end:(int)end{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setInt:40003 forKey:kMessageTypeKey];
    [dic setInt:type forKey:@"type"];
    [dic setObject:keyword forKey:@"keyword"];
    [dic setInt:start forKey:@"start"];
    [dic setInt:end forKey:@"end"];
    
    [self sendMessage:dic];
    
}

//橱窗分页搜索请求
-(void)searchShowwindowWithType:(int)type keyword:(NSString *)keyword start:(int)start end:(int)end{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setInt:40004 forKey:kMessageTypeKey];
    [dic setInt:type forKey:@"type"];
    [dic setObject:keyword forKey:@"keyword"];
    [dic setInt:start forKey:@"start"];
    [dic setInt:end forKey:@"end"];
    
    [self sendMessage:dic];
    
}

// 所有修改个人信息都由此出口发送消息
-(void)upDateUserInfo:(NSDictionary*)rawDic {
    NSMutableDictionary*dic = [NSMutableDictionary dictionaryWithDictionary:rawDic];
    
    [dic setInt:kMessageType_upDateInfo forKey:kMessageTypeKey];
    [self sendMessage:dic];
}

// bg 修改“我能”
-(void)updateICan:(NSString*)ican {
    NSMutableDictionary* rawDic = [NSMutableDictionary dictionary];
    [rawDic setObject:@"ican" forKey:kChangeTypeKey];
    [rawDic setObject:ican forKey:kChangeValueKey];
    
    [self upDateUserInfo:rawDic];
}

//bg 修改 “我需”
-(void)updateINeed:(NSString*)iNeed {
    NSMutableDictionary* rawDic = [NSMutableDictionary dictionary];
    [rawDic setObject:@"ineed" forKey:kChangeTypeKey];
    [rawDic setObject:iNeed forKey:kChangeValueKey];
    [self upDateUserInfo:rawDic];
}

//bg 修改头像
-(void)updateUserIcon:(NSString*)iconURL {
    
    NSMutableDictionary* rawDic = [NSMutableDictionary dictionary];
    [rawDic setObject:@"photo" forKey:kChangeTypeKey];
    [rawDic setObject:iconURL forKey:kChangeValueKey];
    
    [self upDateUserInfo:rawDic];
}

// bg修改个人昵称
-(void)updateNickName:(NSString*)nickName {
    
    NSMutableDictionary* rawDic = [NSMutableDictionary dictionary];
    [rawDic setObject:@"nickname" forKey:kChangeTypeKey];
    [rawDic setObject:nickName forKey:kChangeValueKey];
    [self upDateUserInfo:rawDic];
}


// 更新签名
-(void)updateSignature:(NSString*)signature {
    NSMutableDictionary* rawDic = [NSMutableDictionary dictionary];
    [rawDic setObject:@"signature" forKey:kChangeTypeKey];
    [rawDic setObject:signature forKey:kChangeValueKey];
    [self upDateUserInfo:rawDic];
}

-(void)updateSex:(int)sex {
    NSMutableDictionary* rawDic = [NSMutableDictionary dictionary];
    [rawDic setObject:@"sex" forKey:kChangeTypeKey];
    
//    if([sex isEqualToString:@"女"]) {
//        [rawDic setInt:2 forKey:kChangeValueKey];
//    }else if([sex isEqualToString:@"男"]) {
//        [rawDic setInt:1 forKey:kChangeValueKey];
//    }else {
//       [rawDic setInt:0 forKey:kChangeValueKey];
//    }
    [rawDic setInt:sex forKey:kChangeValueKey];
    [self upDateUserInfo:rawDic];
}


-(void)updateAge:(int)age {
    NSMutableDictionary* rawDic = [NSMutableDictionary dictionary];
    [rawDic setObject:@"age" forKey:kChangeTypeKey];
    [rawDic setInt:age      forKey:kChangeValueKey];
    [self upDateUserInfo:rawDic];
}
-(void)updateBirthday:(NSString*)birthday {
    NSMutableDictionary* rawDic = [NSMutableDictionary dictionary];
    [rawDic setObject:@"birthday" forKey:kChangeTypeKey];
    [rawDic setObject:birthday forKey:kChangeValueKey];
    [self upDateUserInfo:rawDic];
}

//修改星座
-(void)updateConste:(NSString*)conste {
    NSMutableDictionary* rawDic = [NSMutableDictionary dictionary];
    [rawDic setObject:@"conste" forKey:kChangeTypeKey];
    [rawDic setObject:conste forKey:kChangeValueKey];
    [self upDateUserInfo:rawDic];
}


-(void)updateHometown:(NSString*)hometown {
    NSMutableDictionary* rawDic = [NSMutableDictionary dictionary];
    [rawDic setObject:@"hometown" forKey:kChangeTypeKey];
    [rawDic setObject:hometown forKey:kChangeValueKey];
    [self upDateUserInfo:rawDic];
}

//修改所在地
-(void)updateLocalplace:(NSString*)localplace {
    NSMutableDictionary* rawDic = [NSMutableDictionary dictionary];
    [rawDic setObject:@"localplace" forKey:kChangeTypeKey];
    [rawDic setObject:localplace forKey:kChangeValueKey];
    [self upDateUserInfo:rawDic];
}


-(void)updateEmail:(NSString*)email {
    NSMutableDictionary* rawDic = [NSMutableDictionary dictionary];
    [rawDic setObject:@"email" forKey:kChangeTypeKey];
    [rawDic setObject:email forKey:kChangeValueKey];
    [self upDateUserInfo:rawDic];
}

// 更新血型
-(void)updateBtype:(NSString*)btype {
    NSMutableDictionary* rawDic = [NSMutableDictionary dictionary];
    [rawDic setObject:@"btype" forKey:kChangeTypeKey];
    [rawDic setObject:btype forKey:kChangeValueKey];
    [self upDateUserInfo:rawDic];
}

//更新位置信息
-(void)updateLocationWithLongitude:(CGFloat)longitude latitude:(CGFloat)latitude{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setInt:20003 forKey:kMessageTypeKey];
    [dic setDouble:longitude forkey:@"longitude"];
    [dic setDouble:latitude forkey:@"latitude"];
    
    [self sendMessage:dic];
    
}

-(void)attentionPerson:(NSString*)userid
                  type:(int)type {
    NSString* myUserID = [[FDSUserManager sharedManager] NowUserID];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setInt:20004 forKey:kMessageTypeKey];
    [dic setInt:type forKey:@"type"];
    [dic setObject:userid forKey:@"userid"];
    [dic setObject:myUserID forKey:@"byuserid"];// 我的userid
    
    [self sendMessage:dic];
    
   
}

// 请求 关注列表 20005
-(void)requestAttentionListWithType:(int)type
                              start:(int)start
                                end:(int)end {
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setInt:20005 forKey:kMessageTypeKey];
    [dic setInt:start forKey:kStartKey];
    [dic setInt:end forKey:kEndKey];
    [dic setInt:type forKey:kTypeKey];
    //干嘛传这个参数
    //[dic setInt:100 forKey:@"SSMTYPE"];
    [self sendMessage:dic];
}


// 修改密码
//<msgbody>
//<oldpassword/>//原始密码
//<newpassword/>//新密码
//</msgbody>
-(void)requestChangeToNewPWD:(NSString*)newPWD
                      oldPWD:(NSString*)oldPWD
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setInt:20006 forKey:kMessageTypeKey];
    [dic setObject:newPWD forKey:@"newpassword"];
    [dic setObject:oldPWD forKey:@"oldpassword"];
    [self sendMessage:dic];
}

-(void)submitFeedbackWithMessage:(NSString *)message contactnum:(NSString *)contactnum{
    
    //创建字典
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setInt:20007 forKey:kMessageTypeKey];
    [dic setObject:message forKey:@"message"];
    [dic setObject:contactnum forKey:@"contactnum"];
    [self sendMessage:dic];
    
}

//bg 搜索要添加的好友
- (void)searchFriends:(NSString*)keyWord start:(int)start end:(int)end
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setInt:kMessageType_searchFrieds forKey:kMessageTypeKey];
    [dic setInt:start forKey:kStartKey];
    [dic setInt:end forKey:kEndKey];
    [dic setObject:keyWord forKey:kKeyWordKey];
    
    [self sendMessage:dic];
}




- (void)getUserFriends:(NSString*)userID
{
    /* 得到个人的好友列表 */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getUserFriends" forKey:@"messageType"];
    [dic setObject:userID forKey:@"userID"];
    [self sendMessage:dic];
}




- (void)addFriend:(NSString*)friendID :(NSString*)queryInfo
{
    /* 发送添加好友请求 */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"addFriend" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:friendID forKey:@"friendID"];
    [dic setObject:@"friend" forKey:@"friendType"];
    [dic setObject:queryInfo forKey:@"accesswords"];
    [self sendMessage:dic];
}

- (void)addFriendRequestReply:(NSString*)friendID :(NSString*)result
{
    /* 回复加好友请求 */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"addFriendRequestReply" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:friendID forKey:@"friendID"];
    [dic setObject:result forKey:@"result"]; //ok or reject
    [dic setObject:@"friend" forKey:@"friendType"];  //?
    [dic setObject:@"" forKey:@"replywords"];
    [self sendMessage:dic];
}



- (void)getUserCard:(NSString*)friendID
{
    /*    获取好友的个人名片  */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getUserCard" forKey:@"messageType"];
    NSString *userID = [[FDSUserManager sharedManager] getNowUser].m_userID;
    if (userID && userID.length>0)
    {
        [dic setObject:userID forKey:@"userID"];
    }
    else
    {
        [dic setObject:@"" forKey:@"userID"];
    }
    [dic setObject:friendID forKey:@"friendID"];
    [self sendMessage:dic];
}


- (void)subFriend:(NSString*)friendID
{
    /*    删除好友  */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"subFriend" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:friendID forKey:@"friendID"];
    [self sendMessage:dic];
}


- (void)modifyFriendsRemarkName:(NSString*)friendID :(NSString*)remarkName
{
    /*    修改好友备注名   */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"modifyFriendsRemarkName" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:friendID forKey:@"friendID"];
    [dic setObject:remarkName forKey:@"remarkName"];
    [self sendMessage:dic];
}


- (void)getJoinedCompanyList
{
    /*    得到用户企业列表   */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getJoinedCompanyList" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [self sendMessage:dic];
}

- (void)getUserRecord:(NSString*)friendID :(NSString*)recordID :(NSString*)getWay :(NSInteger)count
{
    /*    得到个人动态    */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getUserRecord" forKey:@"messageType"];
    NSString *userID = [[FDSUserManager sharedManager] getNowUser].m_userID;
    if (userID && userID.length>0)
    {
        [dic setObject:userID forKey:@"userID"];
    }
    else
    {
        [dic setObject:@"" forKey:@"userID"];
    }
    [dic setObject:friendID forKey:@"friendID"];
    [dic setObject:recordID forKey:@"recordID"];
    [dic setObject:getWay forKey:@"getWay"];
    [dic setObject:[NSString stringWithFormat:@"%d",count] forKey:@"count"];
    
    [self sendMessage:dic];
}


- (void)sendUserRecord:(NSString*)content :(NSMutableArray*)images
{
    /*    发表个人动态     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"sendUserRecord" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:content forKey:@"content"];
    if (images && images.count > 0)
    {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];
        for (int i=0; i<images.count; i++)
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:[images objectAtIndex:i] forKey:@"URL"];
            [arr addObject:dic];
        }
        [dic setObject:arr forKey:@"images"];
    }
    [self sendMessage:dic];
}


- (void)sendRecordCommentRevert:(NSString*)recordID :(NSString*)content :(NSString*)type :(NSString*)revertedID
{
    /*    发表评论，回复(都不支持图片)     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"sendRecordCommentRevert" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:recordID forKey:@"recordID"];
    [dic setObject:content forKey:@"content"];
    [dic setObject:type forKey:@"type"];
    [dic setObject:revertedID forKey:@"revertedID"];
    
    [self sendMessage:dic];
}


- (void)deleteRecordCommentRevert:(NSString*)commentObjectID :(NSString*)type :(NSString*)objectID
{
    /*    删除动态，评论，回复     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"deleteRecordCommentRevert" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:commentObjectID forKey:@"commentObjectID"];
    [dic setObject:type forKey:@"type"];
    [dic setObject:objectID forKey:@"id"];
    
    [self sendMessage:dic];
}

- (void)feedback:(NSString*)content :(NSString*)contactWay
{
    /*    意见反馈     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"feedback" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:content forKey:@"content"];
    [dic setObject:contactWay forKey:@"contactWay"];
    
    [self sendMessage:dic];
}

- (void)modifyPassword:(NSString*)sessionID
{
    /*     修改密码    */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"modifyPassword01" forKey:@"messageType"];
    [dic setObject:sessionID forKey:@"sessionID"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    
    [self sendMessage:dic];
}

- (void)modifyPassword:(NSString*)sessionID :(NSString*)phoneNum
{
    /*     修改密码    */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"modifyPassword01" forKey:@"messageType"];
    [dic setObject:sessionID forKey:@"sessionID"];
    [dic setObject:phoneNum forKey:@"userID"];
    
    [self sendMessage:dic];
}

- (void)modifyNewPassword:(NSString*)sessionID :(NSString*)authCode :(NSString*)newPassword
{
    /*     修改密码    */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"modifyPassword02" forKey:@"messageType"];
    [dic setObject:sessionID forKey:@"sessionID"];
    [dic setObject:authCode forKey:@"authCode"];
    [dic setObject:newPassword forKey:@"newPassword"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    
    [self sendMessage:dic];
}

- (void)modifyNewPassword:(NSString*)sessionID :(NSString*)authCode :(NSString*)newPassword :(NSString*)phoneNum
{
    /*     修改密码    */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"modifyPassword02" forKey:@"messageType"];
    [dic setObject:sessionID forKey:@"sessionID"];
    [dic setObject:authCode forKey:@"authCode"];
    [dic setObject:newPassword forKey:@"newPassword"];
    [dic setObject:phoneNum forKey:@"userID"];
    
    [self sendMessage:dic];
}

- (void)getGroupMembers:(NSString*)groupID :(NSString*)groupType
{
    /*      得到群成员    */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getGroupMembers" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:groupID forKey:@"groupID"];
    [dic setObject:groupType forKey:@"groupType"];
    
    [self sendMessage:dic];
}

- (void)deleteGroupMember:(NSString*)deletedorID :(NSString*)groupID :(NSString*)groupType
{
    /*   删除群成员   */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"deleteGroupMember" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:deletedorID forKey:@"deletedorID"];
    [dic setObject:groupType forKey:@"groupType"];
    [dic setObject:groupID forKey:@"groupID"];
    
    [self sendMessage:dic];
}

- (void)checkUsersMembersByPhone:(NSMutableArray*)userList
{
    /*    验证用户为平台用户     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"checkUsersMembersByPhone" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    if (userList && userList.count > 0)
    {
        [dic setObject:userList forKey:@"users"];
    }
    
    [self sendMessage:dic];
}


- (void)getPushSetting
{
    /*    获取推送设置     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getPushSetting" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    
    [self sendMessage:dic];
}

- (void)setPushSetting:(NSString*)ONOFF :(NSInteger)setType
{
    /*    修改推送设置     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"setPushSetting" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    if (0 == setType)//免打扰
    {
        [dic setObject:ONOFF forKey:@"restMode"];
    }
    else if(1 == setType)//系统通知
    {
        [dic setObject:ONOFF forKey:@"systemPushMessage"];
    }
    else //2 好友通知
    {
        [dic setObject:ONOFF forKey:@"friendPushMessage"];
    }
    
    [self sendMessage:dic];
}

- (void)checkVersion
{
    /*  检查版本更新  */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"checkVersion" forKey:@"messageType"];
    [dic setObject:@"ios" forKey:@"platform"];
    
    [self sendMessage:dic];
}





@end
