//
//  ZZSessionManager.h
//  ZZFramework
//
//  Created by zhuozhongkeji on 13-10-17.
//  Copyright (c) 2013年 zhuozhongkeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZSocketManager.h"
#import "ZZMessageManager.h"
#import "ZZSessionManagerInterface.h"
#import "Reachability.h"
#import "ZZHttpManager.h"
#import "BGSessionHeader.h"
#import "FDSUserCenterMessageManager.h"
#import "PlatformMessageManager.h"

#define FserverKey @"fserver"

/*
 每一个消息都附带一个messageClass
 
 */

#define HTTP_OR_MESSAGE

#ifdef  HTTP_OR_MESSAGE
     #define HTTP_DEFAULT  1
#else
     #define HTTP_DEFAULT  0
#endif

@interface ZZSessionManager : NSObject<ZZSocketInterface,ZZHttpInterface,UserCenterMessageInterface,PlateformMessageInterface>
{
    NSMutableDictionary *messageObservers;
    NSMutableArray *observerArray;
    enum ZZSessionManagerState sessionManagerState;
    
    Reachability *reachability;
    NetworkStatus m_netStatus;
    enum ZZSessionNetState netState;// net state
    
    ZZSocketManager *socketManager; // socket manager.
    
  //  ZZHttpManager   *httpManager;
    
//    //bg 有bServer 和 fServer 服务器。所以相对于FDS要多出两个HttpManager 来收发消息
//    ZZHttpManager* bServerHttpManager;
//    ZZHttpManager* fServerHttpManager;
    
}
//######## 业务服务器
@property(nonatomic,copy)NSString *businessServerAddress;

//####### 文件服务器
@property(nonatomic,copy)NSString *fileServerAddress;

//####### 空闲业务服务器
@property(nonatomic,copy)NSString *leisureBusinessServerAddress;
// ######  聊天服务器
@property(nonatomic,retain)NSString *chatServerAddress;
@property(nonatomic,retain)NSString *chatServerPort;
//  sessionID
@property(nonatomic,retain)NSString *sessionID;
/// token
@property(nonatomic,retain)NSString *token;
+(ZZSessionManager *)sharedSessionManager;
-(void)sendMessage:(NSDictionary*)message;

/*  http ... */

/*   tcp */
// socket  创建链接
-(void)createSessionConnect;
// socket  关闭链接
-(void)distroySessionConnect;


//通过http来发送消息
-(void)sendMessageByHTTP:(NSDictionary*)message;
//- (void)sendMessage:(NSDictionary*)message  :(enum MESSAGETYPE)messageType :(int)messageClass;
// 通过socket 来发送消息
-(void)sendMessageBySocket:(NSDictionary*)message;


-(void)registerObserver:(id<ZZSessionManagerInterface>)observer;
-(void)unRegisterObserver:(id<ZZSessionManagerInterface>)observer;



//ssm_由于bg中用整数作为messageclass 的key。所以需要修改之前用字符串作为key的实现
-(void)registerMessageObserver:(id<ZZSessionManagerInterface>)observer
                  messageClass:(int)classType;

-(void)unRegisterMessageObserverWithInt:(int)classType;





- (enum ZZSessionManagerState)getSessionState;
-(enum ZZSessionNetState)getSessionNetState;




@end
