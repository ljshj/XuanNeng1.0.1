//
//  PublicMessageManager.m
//  BGProject
//
//  Created by zhuozhongkeji on 14-9-16.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "PublicMessageManager.h"
#import "NSMutableDictionary+Zhangxx.h"

@implementation PublicMessageManager

static PublicMessageManager *instance = nil;
+(PublicMessageManager*)sharedManager
{
    if(nil == instance)
    {
        instance = [PublicMessageManager alloc ];
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
                                                        messageClass:kPublicMessageClass];
    
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
    [message setObject:[NSNumber numberWithInt:kPublicMessageClass] forKey:kMessageClassKey];
    
    [super sendMessage:message];
}



// 参考FDS 的parseMessageData
- (void)parseMessageData:(NSDictionary *)data
{
    int msgType = [[data objectForKey:kMessageTypeKey] intValue];
    NSAssert(msgType!=0, @"没有解析到msgtype");
    //TODO::debug 分发任务.重点调试位置！
    
    switch (msgType) {
        case 880001:
            [self dispatchCheckLastVersion:data];
            break;
            
        default:
            break;
    }
            
}

// 检测版本是否需要更新
-(void)checkLastVersion:(NSString *)version {
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    [msg setObject:version forKey:@"version"];
    [msg setInt:80001 forKey:kMessageTypeKey];
    [self sendMessage:msg];
}

-(void)dispatchCheckLastVersion:(NSDictionary*)data {
    for(id<PublicMessageInterface>interface  in self.observerArray)
    {
        if([interface respondsToSelector:@selector(checkLastVersionCB:)])
        {
            [interface checkLastVersionCB:data];
        }
    }
}



@end
