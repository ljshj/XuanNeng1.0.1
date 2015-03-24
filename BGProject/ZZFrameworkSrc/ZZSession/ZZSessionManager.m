    //
//  ZZSessionManager.m
//  ZZFramework
//
//  Created by zhuozhongkeji on 13-10-17.
//  Copyright (c) 2013年 zhuozhongkeji. All rights reserved.

#import "ZZSessionManager.h"
#import "ZZUserDefaults.h"

@implementation ZZSessionManager
static ZZSessionManager *sessionManager = nil;

+ (ZZSessionManager *)sharedSessionManager
{
    if (sessionManager == nil)
    {
        sessionManager = [[super allocWithZone:NULL] init];
        [sessionManager managerInit];
    }
    return sessionManager;
}

- (void)managerInit
{
    sessionManagerState = ZZSessionManagerState_NONE;
    observerArray = [[NSMutableArray alloc]initWithCapacity:0];
    messageObservers = [[NSMutableDictionary alloc]initWithCapacity:0];
    [messageObservers retain];
    self.chatServerAddress = @"112.124.46.13";
    self.chatServerPort = @"9001";
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
    [[PlatformMessageManager sharedManager ] registerObserver:self];
//    if (HTTP_DEFAULT)
//    {
//        httpManager = [ZZHttpManager shareZZHttpManager];
//        [httpManager registerObserver:self];
//    }
//    else
//    {
//        socketManager = [[ZZSocketManager alloc]init];
//        [socketManager registerObserver:self];
//    }
    
    netState = [self getNetState];
    [self registerNetStateManager];
}

/**###----net Manager------###*/
- (void)registerNetStateManager
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    reachability = [[Reachability reachabilityWithHostName:@"www.baidu.com"] retain];
    [reachability startNotifier];
}

- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability * curReach = [note object];
    NetworkStatus tem = [curReach currentReachabilityStatus];
    if(m_netStatus != tem)
    {
        m_netStatus = tem;
        if (m_netStatus == NotReachable)
        {
            netState = ZZSessionNetState_NONE;
            sessionManagerState = ZZSessionManagerState_NET_FAIL;
            dispatch_async(dispatch_get_main_queue(),^{
            [self NoticeStateToDelegate:ZZSessionManagerState_NET_FAIL];
        });
            if (!HTTP_DEFAULT)
            {
                [self distroySessionConnect];
            }
        }else if(m_netStatus == kReachableViaWiFi){
            netState = ZZSessionNetState_WIFI;
            sessionManagerState = ZZSessionManagerState_NET_OK;
            dispatch_async(dispatch_get_main_queue(),^{
                [self NoticeStateToDelegate:ZZSessionManagerState_NET_OK];
            });
            if (!HTTP_DEFAULT)
            {
                [self createSessionConnect];
            }
        }else{
            
            netState = ZZSessionNetState_2G;
            
        }
    }
}

/*   这个外部调用很少*/
- (NetworkStatus)getNetState
{
    //    if[self getSocketStatus]
    return m_netStatus;
//    Reachability * curReach = [Reachability reachabilityForInternetConnection];
//    NetworkStatus status_now = [curReach currentReachabilityStatus];
//    return status_now;
}

- (void)NoticeStateToDelegate :(enum ZZSessionManagerState)sessionState
{
    for(id<ZZSessionManagerInterface>observer in observerArray)
    {
        if([observer respondsToSelector:@selector(sessionManagerStateNotice:)])
        {
               [observer sessionManagerStateNotice:sessionState];
        }
    }
}

//通过http来发送消息
-(void)sendMessageByHTTP:(NSDictionary*)message
{
    [self sendMessage:message];
}

-(void)sendMessageBySocket:(NSDictionary*)message
{
//    if(socketManager == nil || [socketManager getSocketStatus] != ZZSocketState_CONNECTED)
//        return ;
    socketManager = [ZZSocketManager sharedSocketManager];
     NSData* packagedData = [self packetMessage:message];
    if(packagedData != nil)
    {
     [socketManager sendMessage:packagedData];
      //  [self sendMessage:message];
    }
}

// 因为用Http需要加入http的包头，所以当使用
// httpManager 发送消息的时候，暂时不将dic转换成字节序列(NSData)
-(NSData*)packetMessage:(NSDictionary*)message
{
   // UInt16 messageType = [message[kMessageTypeKey] intValue];
     UInt32 messageType = [message[kMessageTypeKey] intValue];
     UInt16 classType = [message[kMessageClassKey] intValue];
    
    // 取消掉messageType and classType before package this message
    NSMutableDictionary* rawDic = [NSMutableDictionary dictionaryWithDictionary:message];
    [rawDic removeObjectForKey:kMessageTypeKey];
    [rawDic removeObjectForKey:kMessageClassKey];
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:rawDic options:NSJSONWritingPrettyPrinted error:&error];
    NSLog(@"####send message######%@",message);
    [self showDebugInfo:error];
    return [self packageData:data withMsgType:messageType withMsgClass:classType];
}
//默认为采用http
- (void)sendMessage:(NSDictionary*)message
{
    
    static int searchHotWordCount = 0;
    
    // 判断是否满足发送的条件
    //if(![self canSendMessage]) return;
    
    NSData* packagedData = [self packetMessage:message];
    
    if(packagedData) {
        
            // 对消息进行打包
            ZZHttpManager *httpManager = [ZZHttpManager shareZZHttpManager];
            [httpManager registerObserver:self];
            UInt16 messageType = [message[kMessageTypeKey] intValue];

        // 10000系列的协议使用默认地址   50000
        if((messageType>=10000 && messageType<20000) || messageType==50000) {
             [httpManager sendMessage:packagedData to:nil];
        }else{
            
            [httpManager sendMessage :packagedData to:self.businessServerAddress];
            
        }
        return;
    }
    
}

- (void)socketStateNotice:(enum ZZSocketState)socketManagerType
{
    switch (socketManagerType)
    {
        case ZZSocketState_CREATE_CLOSE_FAIL:
            break;
        case  ZZSocketState_CONNECT_FAIL:
            sessionManagerState = ZZSessionManagerState_NONE;
             [self NoticeStateToDelegate:sessionManagerState];
            [self distroySessionConnect];
            break;
        case ZZSocketState_CONNECTED:
            sessionManagerState = ZZSessionManagerState_CONNECTED;
             [self NoticeStateToDelegate:sessionManagerState];
            break;
        case ZZSocketState_CLOSE_BY_SERVER:
            sessionManagerState = ZZSessionManagerState_CONNECT_MISS;
            [self distroySessionConnect];
             [self NoticeStateToDelegate:sessionManagerState];
            break;
        default:
            break;
    }
}

- (enum ZZSessionManagerState)getSessionState
{
    return sessionManagerState;
}

- (enum ZZSessionNetState)getSessionNetState
{
    return netState;
}

//TODO::test cb
-(void)userLoginCB:(NSDictionary *)dic
{
    //业务服务器地址
    self.businessServerAddress = [dic objectForKey:@"bserver"];
    
    //文件服务器
    self.fileServerAddress = [dic objectForKey:@"fserver"];
    
    //把文件服务器地址存起来
    [ZZUserDefaults setUserDefault:FserverKey :self.fileServerAddress];
    
    //暂时用不上
    self.token =[dic objectForKey:@"token"];
    
    //用户id
    self.sessionID =[dic objectForKey:@"userid"];
}
//终将会建立一个socket链接
- (void)createSessionConnect
{
    if(socketManager == nil)
    {
       socketManager = [[ZZSocketManager alloc]init];
       [socketManager registerObserver:self];
    }
    
    if(socketManager != nil && [socketManager getSocketStatus] == ZZSocketState_NONE)
    {
        [socketManager connectServer:self.chatServerAddress : [self.chatServerPort intValue] ];
       //  [socketManager connectServer:self.chatServerAddress : [self.chatServerPort intValue] ];
        //[socketManager connectServer:SERVER_IP : SERVER_PORT ];
    }
}
-(void)getChatServerCB:(NSString *)serverAddress :(NSString *)port
{
    self.chatServerAddress = serverAddress;
    self.chatServerPort = port;
    [self createSessionConnect];
}
- (void)distroySessionConnect
{
     if(socketManager != nil && [socketManager getSocketStatus] != ZZSocketState_NONE)
     {
         [socketManager closeSocket:YES];
     }
 
}
-(NSData*)rePacketMessage:(NSData*)data
{
    const void* pData  = [data bytes];
    
//    UInt32 length  = 0;
//    memcpy((char*)&length, pData, sizeof(length));
//    pData += sizeof(length);
    
    
    //packetLength =
    // int length = ntohl(packet);
    
    UInt32 messageType = 0;
    memcpy((char*)&messageType, pData, sizeof(messageType));
    pData += sizeof(messageType);
    
    UInt32 sessionID = 0;
    memcpy((char*)&sessionID, pData, sizeof(sessionID));
    pData += sizeof(sessionID);
   // _sessionID = sessionID;
    
    
    UInt16 messageClass = 0;
    memcpy((char*)&messageClass, pData,sizeof(messageClass));
    pData += sizeof(messageClass);
    
    UInt16 returnCode = -1;
    memcpy((char*)&returnCode, pData,sizeof(returnCode));
    pData += sizeof(returnCode);
    if(returnCode!=0) {
        NSLog(@"return code error...!!!");
    }
    
    
    UInt32 responseBodyLength = 0;
    memcpy((char*)&responseBodyLength, pData,sizeof(responseBodyLength));
    pData += sizeof(responseBodyLength);
    
    NSData* messageBodyData = [NSData dataWithBytes:pData length:responseBodyLength];
    return messageBodyData;
}
/*   */
- (void)socketRecvMessage:(NSData *)data :(UInt16)messageClass :(UInt32)messageType
{
    NSError *error = nil;
    if (data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%s recesive dic:%@", __FILE__, dic);
        
        // TODO:: 更新bserver fserver 的地址
        //依据返回消息初始化bServerHttpManager\fServerHttpManager
        
        if (!error) {
            ZZMessageManager *messageManager = [messageObservers objectForKey:[NSNumber numberWithInt:messageClass]];
            //debug 添加messageType 到字典中，给下个接口解析
            NSMutableDictionary* mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            
            // 为了复用之前的代码，将messageType 传到下一阶段
            [mutableDic setObject:[NSNumber numberWithInt:messageType] forKey:kMessageTypeKey];
            
            if(messageManager && [messageManager respondsToSelector:@selector(parseMessageData:)])
            {
                // 这里应该找到FDSUserCenterMessageManager 或其他Messagemanager 来处理服务器的回包数据
                [messageManager parseMessageData:mutableDic];
            }
            
        }
        else
        {
            NSLog(@"##############Json数据解析出错编号3！！！###################");
        }
    }

}
/*  socket回调  */
- (void)socketRecvMessage:(NSData *)data
{
    NSData *messagedata = [self rePacketMessage:data];
    NSError *error = nil;
    if (messagedata) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:messagedata options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",dic);
        if (!error) {
            NSString* key = [dic objectForKey:@"messageClass"];
            
            if(key)
            {
                ZZMessageManager *messageManager = [messageObservers objectForKey:key];
                if(messageManager && [messageManager respondsToSelector:@selector(parseMessageData:)])
                {
                    [messageManager parseMessageData:dic];
                }
            }
        }
        else
        {
            NSLog(@"##############Json数据解析出错编号1！！！###################");
        }
    }
}

/*  http信息接收回调   */
- (void)receiveHttpMessage:(NSData*)data
{
    NSLog(@"%@",data);
    NSError *error = nil;
    if (data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        if (!error) {
            NSString *key = [dic objectForKey:@"messageClass"];
            if(key)
            {
                ZZMessageManager *messageManager = [messageObservers objectForKey:key];
                if(messageManager && [messageManager respondsToSelector:@selector(parseMessageData:)])
                {
                    [messageManager parseMessageData:dic];
                }
            }
        }
        else
        {
            NSLog(@"##############Json数据解析出错编号2！！！###################");
        }
    }
}





/*  http信息接收回调  BG的回调，因为bg的MessageClass 在这个方法栈的之前调用,
 所以MessageClass作为 参数传入*/
- (void)receiveHttpMessage:(NSData *)data :(UInt16)messageClass :(UInt32)messageType
{
#ifdef DEBUG_ZZSessionManager_receiveHttpMessage
    NSLog(@"DEBUG_ZZSessionManager_receiveHttpMessage:调试回包处理");
#endif
    NSError *error = nil;
    if (data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%ld recesive dic:%@", messageType, dic);
        
        // TODO:: 更新bserver fserver 的地址
        //依据返回消息初始化bServerHttpManager\fServerHttpManager
        NSString* bServerIP = [dic objectForKey:kBserverKey];
        self.leisureBusinessServerAddress = bServerIP;
        if(bServerIP!=nil) {
            [[ZZHttpManager  shareZZHttpManager] updateBusinessServerHTTP_URL:bServerIP];
        }
        
        NSString* fServerIP = [dic objectForKey:kFserverKey];
        if(fServerIP!=nil) {
            [[ZZHttpManager shareZZHttpManager] updateFileServerHTTP_URL:fServerIP];
        }
        
        if (!error) {
            ZZMessageManager *messageManager = [messageObservers objectForKey:[NSNumber numberWithInt:messageClass]];
            //debug 添加messageType 到字典中，给下个接口解析
            NSMutableDictionary* mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
         
            // 为了复用之前的代码，将messageType 传到下一阶段
            [mutableDic setObject:[NSNumber numberWithInt:messageType] forKey:kMessageTypeKey];
            
            if(messageManager && [messageManager respondsToSelector:@selector(parseMessageData:)])
            {
                // 这里应该找到UserCenterMessageManager 或其他Messagemanager 来处理服务器的回包数据
                [messageManager parseMessageData:mutableDic];
            }
            
        }
        else
        {
            NSLog(@"##############Json数据解析出错编号3！！！###################");
        }
    }
}

- (void)registerObserver:(id<ZZSessionManagerInterface>)observer
{
   if(![observerArray containsObject:observer])
   {
       [observerArray addObject:observer];
   }
}

- (void)unRegisterObserver:(id<ZZSessionManagerInterface>)observer
{
    if([observerArray containsObject:observer])
    {
        [observerArray removeObject:observer];
    }
}


//由于bg中用整数作为messageclass 的key。所以需要修改之前用字符串作为key的实现
-(void)registerMessageObserver:(id<ZZSessionManagerInterface>)observer
                  messageClass:(int)classType {
    
    NSNumber* key = [NSNumber numberWithInt:classType];
    
    if([messageObservers objectForKey:key]==nil) {
        [messageObservers setObject:observer forKey:key];
    }
    
}
//由于bg中用整数作为messageclass 的key。所以需要修改之前用字符串作为key的实现
-(void)unRegisterMessageObserverWithInt:(int)classType {
    
    NSNumber* key = [NSNumber numberWithInt:classType];
    
    if([messageObservers objectForKey:key]!=nil) {
        [messageObservers removeObjectForKey:key];
    }
}



-(BOOL)canSendMessage {
//    if (HTTP_DEFAULT)
//    {
//        if(httpManager == nil)
//            return NO;
//    }
//    else
//    {
//        if(socketManager == nil || [socketManager getSocketStatus] != ZZSocketState_CONNECTED)
//            return NO;
//    }
    
    return YES;
}

-(void)showDebugInfo:(NSError*)error {
    if (!error)
    {
        NSLog(@"Process JSON data is sucessed...");
    }
    else
    {
        NSLog(@"Process JSON data has error...");
    }
}

// debug 调试接口最重要的地方
// 对http传输的字节序 按照协议添加内容

//在网络上传输的是以低位字节进行的；htonl，将int转换为网络字节序的int，
//                            ntohl，将网络字节序的int转换回来，


-(NSData*)packageData:(NSData*)data
          withMsgType:(enum MESSAGETYPE)msgType
        withMsgClass:(enum ClassTYPE)msgClass {
    
    NSMutableData* result= [NSMutableData data];
    NSLog(@"BODY LENGTH:%d", [data length]);
    const char* beginTag = [ @"<<<" UTF8String];               // 起始标志
    UInt32 messageLength = 0;                 // 长度为4,用来记录整条消息的长度
    UInt32 messageType = msgType;
    
    
    
#warning sessionID应该通过SessionManager维护 获取，暂时写死
    UInt32 sessionID = [self.sessionID intValue];
    UInt16 messageClass = msgClass;      // 标记传入该消息的class
    UInt32 messageBodyLength = 0;           // 计算messageBody的长度
    
    NSData* messageBody = data;             //消息体的json数据
    //    UInt32 fileLength = 0;                // 文件的总长度，如果没有则填写0
    const char* endTag = [ @">>>" UTF8String];
    
    // 计算消息的总体长度  4*4 +2 + body + begin + end
    //4*4 +2 + body +
    messageLength = strlen(beginTag) + sizeof(messageLength) + sizeof(messageType) + sizeof(sessionID) + sizeof(messageClass) + sizeof(messageBodyLength) + [data length] /*+ sizeof(fileLength)*/+strlen(endTag);
    
    messageBodyLength = [messageBody length];
    [result appendBytes:beginTag length:strlen(beginTag)];
    [result appendBytes:&messageLength length:sizeof(messageLength)];
    [result appendBytes:&messageType length:sizeof(messageType)];
    
    [result appendBytes:&sessionID length:sizeof(sessionID)];
    [result appendBytes:&messageClass length:sizeof(messageClass)];
    [result appendBytes:&messageBodyLength length:sizeof(messageBodyLength)];
    
    [result appendBytes:[messageBody bytes] length:[messageBody length]];
    // [result appendBytes:&fileLength length:sizeof(fileLength)];
    [result appendBytes:endTag length:strlen(endTag)];
  //  [self printData:result];
    return result;

}


-(NSData*)packageData:(NSData*)data
          withMsgTpye:(enum MESSAGETYPE)type{
    
    NSMutableData* result= [NSMutableData data];
    NSLog(@"BODY LENGTH:%lud", (unsigned long)[data length]);
    const char* beginTag = [ @"<<<" UTF8String];               // 起始标志
    UInt32 messageLength = 0;                 // 长度为4,用来记录整条消息的长度
    UInt32 messageType = type;
    
    
    
#warning sessionID应该通过SessionManager维护 获取，暂时写死
    UInt32 sessionID = 0;
    UInt16 messageClass = 0;                // 标记传入该消息的class
    UInt32 messageBodyLength = 0;           // 计算messageBody的长度
    
    NSData* messageBody = data;             //消息体的json数据
//    UInt32 fileLength = 0;                // 文件的总长度，如果没有则填写0
    const char* endTag = [ @">>>" UTF8String];
    
    // 计算消息的总体长度  4*4 +2 + body + begin + end
    //4*4 +2 + body +
    messageLength = (UInt32)(strlen(beginTag) + sizeof(messageLength) + sizeof(messageType) + sizeof(sessionID) + sizeof(messageClass) + sizeof(messageBodyLength) + [data length] /*+ sizeof(fileLength)*/+strlen(endTag));

    messageBodyLength = (UInt32)[messageBody length];
    [result appendBytes:beginTag length:strlen(beginTag)];
    [result appendBytes:&messageLength length:sizeof(messageLength)];
    [result appendBytes:&messageType length:sizeof(messageType)];
    
    [result appendBytes:&sessionID length:sizeof(sessionID)];
    [result appendBytes:&messageClass length:sizeof(messageClass)];
    [result appendBytes:&messageBodyLength length:sizeof(messageBodyLength)];
    
    [result appendBytes:[messageBody bytes] length:[messageBody length]];
   // [result appendBytes:&fileLength length:sizeof(fileLength)];
    [result appendBytes:endTag length:strlen(endTag)];
  //  [self printData:result];
    return result;
}

//debug
-(void)printData:(NSData*)data {
    NSUInteger length= [data length];
    char* arr = (char*)data.bytes;
    printf("<<<data:::\n");
    
    for(int i=0; i<length;i++) {
        printf("%2d,",*(arr+i));
    }
    printf("\ndata end>>>\n");
}


@end
