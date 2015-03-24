//
//  ZZMessageManager.m
//  ZZFramework
//
//  Created by zhuozhongkeji on 13-10-17.
//  Copyright (c) 2013年 zhuozhongkeji. All rights reserved.
//

#import "ZZMessageManager.h"
#import "ZZSessionManager.h"
#import "SVProgressHUD.h"
#import "FDSPublicManage.h"

@implementation ZZMessageManager{
    UIAlertView *_alert;
}
-(void)registerMessageManager:(ZZMessageManager*)messageManager :(NSString*)messageClass
{
    ZZSessionManager* sessionManager =  [ZZSessionManager sharedSessionManager];
    if([messageClass isEqualToString:@"fdsUserCenterMessageManager"]) {
        
        [sessionManager registerMessageObserver:messageManager
                                   messageClass:kFDSUserCenterMessageClass];
        
    }else if([messageClass isEqualToString:@"systemMessageManager"]) {
        
        [sessionManager registerMessageObserver:messageManager
                                   messageClass:kSystemMessageManagerClass];
    } else{
        
        NSString* msg = [NSString stringWithFormat:@"注册%@失败,必须将%@转换成int,注册进去",messageManager,messageClass];
        //如果注册失败，断定是一个bug,在调试时就该crash 程序。
        NSAssert(NO, msg);
    }
}

-(void)sendMessage:(NSDictionary*)message
{
//    enum ZZSessionManagerState state = [[ZZSessionManager sharedSessionManager]getSessionState];
//    if (ZZSessionManagerState_NONE == state || ZZSessionManagerState_NET_FAIL == state || ZZSessionManagerState_CONNECT_FAIL == state ||
//        ZZSessionManagerState_CONNECT_MISS == state) //网络不可用
//    {
//        
//        [SVProgressHUD popActivity];
//    
//    }
//    else
    {
        [[ZZSessionManager sharedSessionManager] sendMessage:message];
        NSLog(@"");
    }
}

-(void)sendMessageBySocket:(NSDictionary*)message
{
    [[ZZSessionManager sharedSessionManager] sendMessageBySocket:message];
}


@end
