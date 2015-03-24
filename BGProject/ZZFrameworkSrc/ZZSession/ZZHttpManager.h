//
//  ZZHttpManager.h
//  GIFT
//
//  Created by zhuozhong on 14-3-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZHttpInterface.h"
#import "ASIFormDataRequest.h"
#import "FDSUserCenterMessageInterface.h"
@interface ZZHttpManager : NSObject<ASIHTTPRequestDelegate,UserCenterMessageInterface>
{
}

//######## 业务服务器
@property(nonatomic,retain)NSString *businessServerAddress;


//####### 文件服务器
@property(nonatomic,retain)NSString *fileServerAddress;
// ######  聊天服务器
@property(nonatomic,retain)NSString *chatServerAddress;
/// token
@property(nonatomic,retain)NSString *token;
// sessionID
//@property(nonatomic,retain)NSString *sessionID;

@property (nonatomic,retain) NSMutableArray  *observerArray;

+(ZZHttpManager *)shareZZHttpManager;

-(void)updateBusinessServerHTTP_URL:(NSString*)ipAndPort;

-(void)updateFileServerHTTP_URL:(NSString*)ipAndPort;

-(void)registerObserver:(id<ZZHttpInterface>)observer;
-(void)unRegisterObserver:(id<ZZHttpInterface>)observer;

- (void)sendMessage:(NSData*)message;
//-(void)sendMessage:(NSDictionary*)message;
-(void)sendMessage:(NSData *)message to:(NSString*)httpURL;



-(void)sendMessageToBserver:(NSData*)message;
-(void)sendMessageToFserver:(NSData*)message;

-(BOOL)connectServer;

-(void)shortConnectSendData:(NSData *)message to:(NSString*)httpURL;
-(void)sendMessage:(NSData *)message to2:(NSString*)httpURL;
@end
