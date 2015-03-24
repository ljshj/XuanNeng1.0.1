//
//  PlatformMessageManager.m
//  BGProject
//
//  Created by zhuozhongkeji on 14-9-16.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "PlatformMessageManager.h"
#import "NSMutableDictionary+Zhangxx.h"
#import "FriendCellModel.h"
#import "DataBaseSimple.h"

//一些实体类
#import "FriendModel.h"


@implementation PlatformMessageManager
static PlatformMessageManager *instance = nil;
+(PlatformMessageManager*)sharedManager
{
    if(nil == instance)
    {
        instance = [PlatformMessageManager alloc ];
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
                                                        messageClass:kPlatformMessageClass];
    
    [[ZZSessionManager sharedSessionManager] registerObserver  :self];
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
- (void)sendMessage:(NSMutableDictionary *)message
{
    
    // 添加发送消息的标记，等到服务器返回的时候，依据该标记找到发送者
    [message setObject:[NSNumber numberWithInt:kPlatformMessageClass] forKey:kMessageClassKey];
    
    [super sendMessage:message];

}

-(void)sendMessageBySocket:(NSMutableDictionary *)message
{
    // 添加发送消息的标记，等到服务器返回的时候，依据该标记找到发送者
    [message setObject:[NSNumber numberWithInt:kPlatformMessageClass] forKey:kMessageClassKey];
    
    [super sendMessageBySocket:message];
}
// 参考FDS 的parseMessageData
- (void)parseMessageData:(NSDictionary *)data
{
    int msgType = [[data objectForKey:kMessageTypeKey] intValue];
    NSAssert(msgType!=0, @"没有解析到msgtype");
    //TODO::debug 分发任务.重点调试位置！
    
    switch (msgType) {
        //请求聊天服务器地址
        case 850000:
        {
            NSString * serverAddress = [data objectForKey:@"imserver"];
            NSString *port = [data objectForKey:@"port"];
            for(id<PlateformMessageInterface> interface in self.observerArray)
            {
                // TODO::2014年09月13日
                if([interface respondsToSelector:@selector(getChatServerCB::)]) {
                    [interface getChatServerCB:serverAddress : port];
                }
            }
            break;
        }
        case 850006://返沪好友列表
        {
            
            for(id<PlateformMessageInterface> interface in self.observerArray)
            {
                // TODO::2014年09月13日
                if([interface respondsToSelector:@selector(requestContactListCB:)]) {
                    
                    [interface requestContactListCB:data];
                    
                    
                }
            }
            
            break;
        }
        case 850008://删除好友回调
        {
            
            int returnCode = [data[@"returnCode"] intValue];
            
            for(id<PlateformMessageInterface> interface in self.observerArray)
            {
                // TODO::2014年09月13日
                if([interface respondsToSelector:@selector(deleteGoodfriendCB:)]) {
                    
                    [interface deleteGoodfriendCB:returnCode];
                    
                    
                }
            }
            
            break;
        }
        case 850024://删除好友回调
        {
            
            int returnCode = [data[@"returnCode"] intValue];
            
            for(id<PlateformMessageInterface> interface in self.observerArray)
            {
                // TODO::2014年09月13日
                if([interface respondsToSelector:@selector(deleteGroupMemberCB:)]) {
                    
                    [interface deleteGroupMemberCB:returnCode];
                    
                    
                }
            }
            
            break;
        }
        case 850025://插入好友到固定群
        {
            
            NSArray *items = data[@"items"];
            
            for(id<PlateformMessageInterface> interface in self.observerArray)
            {
                // TODO::2014年09月13日
                if([interface respondsToSelector:@selector(addFriendsToGroupCB:)]) {
                    
                    [interface addFriendsToGroupCB:items];
                    
                    
                }
            }
            
            break;
        }
        case 850030://插入群成员到交流厅
        {
            
            NSArray *items = data[@"items"];
            
            for(id<PlateformMessageInterface> interface in self.observerArray)
            {
                // TODO::2014年09月13日
                if([interface respondsToSelector:@selector(addFriendsToTempGroupCB:)]) {
                    
                    [interface addFriendsToTempGroupCB:items];
                    
                    
                }
            }
            
            break;
        }
        case 850013:
        {
            
            //取出群成员数组
            NSArray *items = data[@"items"];
            
            //初始化模型数组
            NSMutableArray *members = [[NSMutableArray alloc] init];
            
            //将字典数组转换成模型数组(用的是好友模型)
            for (NSDictionary *dic in items) {
                
                FriendCellModel *model = [[FriendCellModel alloc] initWithDic:dic];
                
                [members addObject:model];
            }
            
            //回调
            for(id<PlateformMessageInterface> interface in self.observerArray)
            {
                // TODO::2014年09月13日
                if([interface respondsToSelector:@selector(requestGroupMembersCB:)]) {
                    
                    [interface requestGroupMembersCB:members];
                    
                    
                }
            }
            
            break;
        }
        case 850016://解散群回调
        {
            
            int returnCode = [data[@"returnCode"] intValue];
            
            for(id<PlateformMessageInterface> interface in self.observerArray)
            {
                // TODO::2014年09月13日
                if([interface respondsToSelector:@selector(disbandGroupCB:)]) {
                    
                    [interface disbandGroupCB:returnCode];
                    
                    
                }
            }
            
            break;
        }
        case 850015://解散群回调
        {
            
            for(id<PlateformMessageInterface> interface in self.observerArray)
            {
                // TODO::2014年09月13日
                if([interface respondsToSelector:@selector(findGroupCB:)]) {
                    
                    [interface findGroupCB:data];
                    
                    
                }
            }
            
            break;
        }
        case 850018://解散群回调
        {
            
            int returnCode = [data[@"returnCode"] intValue];
            
            for(id<PlateformMessageInterface> interface in self.observerArray)
            {
                // TODO::2014年09月13日
                if([interface respondsToSelector:@selector(exitGroupCB:)]) {
                    
                    [interface exitGroupCB:returnCode];
                    
                    
                }
            }
            
            break;
        }
        case 850027://同意添加好友(调用环信后的调用的接口)
        {
            
            //取出新添加的用户数组
            NSArray *items = data[@"items"];
            
            //字典数组转换成模型数组
            NSMutableArray *tempItems = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in items) {
                
                //用另外一个字典转数组的方法
                FriendCellModel *model = [[FriendCellModel alloc] initWithDic:dic];
                
                [tempItems addObject:model];
                
                //将数据插入到数据库
                [[DataBaseSimple shareInstance] insertFriendswithModel:model];
                
            }
            
            
            for(id<PlateformMessageInterface> interface in self.observerArray)
            {
                // TODO::2014年09月13日
                if([interface respondsToSelector:@selector(addFriendsCB:)]) {
                    
                    [interface addFriendsCB:tempItems];
                    
                    
                }
            }
            
            break;
        }
        case 850014://创建群
        {
            //回调
            for(id<PlateformMessageInterface> interface in self.observerArray)
            {
                // TODO::2014年09月13日
                if([interface respondsToSelector:@selector(creatGroupCB:)]) {
                    [interface creatGroupCB:data];
                    
                }
            }
            
            break;
        }
        case 850012://查询群信息
        {
            //回调
            for(id<PlateformMessageInterface> interface in self.observerArray)
            {
                // TODO::2014年09月13日
                if([interface respondsToSelector:@selector(requestGroupInfoCB:)]) {
                    [interface requestGroupInfoCB:data];
                    
                }
            }
            
            break;
        }
        //搜索好友返回
        case 850009:
        {
            //初始化好友数组
            NSMutableArray *friendList = [[NSMutableArray alloc] init];
            
            //取出好友数组
            NSArray *tmpArr = [data objectForKey:@"items"];
            
            //将字典转换成模型
            for (int i=0; i < tmpArr.count; i++)
            {
                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                
                FriendModel* friend = [[FriendModel alloc]initWithDic:tmpDic];
                
                [friendList addObject:friend];
               
            }
            for(id<PlateformMessageInterface> interface in self.observerArray)
            {
                // TODO::2014年09月13日
                if([interface respondsToSelector:@selector(checkFriendsCB:)]) {
                    [interface checkFriendsCB:friendList];
                    
                }
            }
            
            break;
        }
      
        default:
            
            break;
    }

}

//查找好友
-(void)checkFriendsWithKeyword:(NSString *)keyword start:(int)start end:(int)end{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setInt:50009 forKey:kMessageTypeKey];
    [dic setObject:keyword forKey:@"keyword"];
    [dic setInt:start forKey:@"start"];
    [dic setInt:end forKey:@"end"];
    
    [self sendMessage:dic];
    
}

//同意添加好友
-(void)agreeToAddFriendsWithUserid:(NSString *)userid recver:(NSArray *)recver msg:(NSString *)msg{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setInt:50027 forKey:kMessageTypeKey];
    [dic setObject:userid forKey:@"userid"];
    [dic setObject:recver forKey:@"recver"];
    [dic setObject:msg forKey:@"msg"];
    
    [self sendMessage:dic];
    
}

//删除好友
-(void)deleteGoodfriendWithUserids:(NSArray *)userids
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setInt:50008 forKey:kMessageTypeKey];
    [dic setObject:userids forKey:@"userid"];
    
    [self sendMessage:dic];
    
}

//返回联系人列表
-(void)requestContactList{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setInt:50006 forKey:kMessageTypeKey];
    
    [self sendMessage:dic];
    
}

//创建固定群
-(void)creatGroupWithName:(NSString *)name type:(int)type intro:(NSString *)intro notice:(NSString *)notice{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setInt:50014 forKey:kMessageTypeKey];
    [dic setObject:name forKey:@"name"];
    [dic setInt:type forKey:@"type"];
    [dic setObject:intro forKey:@"intro"];
    [dic setObject:notice forKey:@"notice"];
    
    [self sendMessage:dic];
    
}

//解散群
-(void)disbandGroupWithGroupid:(NSString *)groupid{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setInt:50016 forKey:kMessageTypeKey];
    [dic setObject:groupid forKey:@"groupid"];
    
    [self sendMessage:dic];
    
}

//退出群
-(void)exitGroupWithGroupid:(NSString *)groupid userid:(NSString *)userid{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setInt:50018 forKey:kMessageTypeKey];
    [dic setObject:groupid forKey:@"groupid"];
    [dic setObject:userid forKey:@"userid"];
    
    [self sendMessage:dic];
    
}

//查找群
-(void)findGroupWithKeyword:(NSString *)keyword start:(int)start end:(int)end{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setInt:50015 forKey:kMessageTypeKey];
    [dic setObject:keyword forKey:@"keyword"];
    [dic setInt:start forKey:@"start"];
    [dic setInt:end forKey:@"end"];
    
    [self sendMessage:dic];
    
}

//同意添加群成员
-(void)addFriendsToGroupWithUserid:(NSArray *)userids groupid:(NSString *)groupid type:(int)type agr:(NSString *)agr;{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setInt:50025 forKey:kMessageTypeKey];
    [dic setObject:userids forKey:@"userid"];
    [dic setObject:groupid forKey:@"groupid"];
    [dic setInt:type forKey:@"type"];
    [dic setObject:agr forKey:@"agr"];
    
    [self sendMessage:dic];
    
}

//添加群成员到交流厅
-(void)addFriendsToTempGroupWithUserid:(NSArray *)userids groupid:(NSString *)groupid agr:(NSString *)agr{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setInt:50030 forKey:kMessageTypeKey];
    [dic setObject:userids forKey:@"userid"];
    [dic setObject:groupid forKey:@"groupid"];
    [dic setObject:agr forKey:@"agr"];
    
    [self sendMessage:dic];
    
}

//获取群成员列表
-(void)requestGroupMembersWithRoomid:(NSString *)roomid{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setInt:50013 forKey:kMessageTypeKey];
    [dic setObject:roomid forKey:@"id"];
    
    [self sendMessage:dic];
    
}

//群信息列表
-(void)requestGroupInfoWithHxgroupid:(NSString *)hxgroupid roomid:(NSString *)roomid{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setInt:50012 forKey:kMessageTypeKey];
    [dic setObject:roomid forKey:@"id"];
    [dic setObject:hxgroupid forKey:@"hxgroupid"];
    
    [self sendMessage:dic];
    
}

-(void)deleteGroupMemberWithGroupid:(NSString *)groupid userid:(NSString *)userid{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setInt:50024 forKey:kMessageTypeKey];
    [dic setObject:groupid forKey:@"groupid"];
    [dic setObject:userid forKey:@"userid"];
    
    [self sendMessage:dic];
    
}

//搜索好友
-(void)searchFriend:(NSString*)keyword
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setInt:50009 forKey:kMessageTypeKey];
    
    [dic setObject:keyword forKey:@"keyword"];
    [dic setObject:@"0" forKey:@"start"];
    [dic setObject:@"10" forKey:@"end"];
    
    [self sendMessage:dic];
}
@end
