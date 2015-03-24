//
//  ZZHttpManager.m
//  GIFT
//
//  Created by zhuozhong on 14-3-28.
//  Copyright (c) 2014Âπ zhuozhong. All rights reserved.
//
#define kMaxMemory 5*1024*1024

#import "ZZHttpManager.h"
#import "SVProgressHUD.h"
#import "NSMutableDictionary+Zhangxx.h"
#import "FDSUserCenterMessageManager.h"





//#define HTTP_REQ_URL      @"http://192.168.1.117:5000" //Ê≥®Â∞Â

//#define HTTP_REQ_URL      @"http://192.168.1.119:5000" //Ê≥®Â∞Â

#define HTTP_REQ_URL      @"http://114.215.189.189:5000" //Ê≥®Â∞Â

static ZZHttpManager  *httpManager = nil;



@implementation ZZHttpManager
{
    UInt32 _sessionID;
    
    NSString* _bserverHttp;
    NSString* _fserverHttp;
}

+(ZZHttpManager*)shareZZHttpManager
{
    if(httpManager == nil)
    {
        httpManager = [[ZZHttpManager alloc] init];
        [httpManager managerInit];
    }
    return httpManager;
}



- (void)managerInit
{
    //-fno-objc-arc
//    self.observerArray = [[NSMutableArray arrayWithCapacity:0] retain];
    self.observerArray = [NSMutableArray arrayWithCapacity:0];
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
    
    
}
//TODO::test cb

//
-(void)userLoginCB:(NSDictionary*)dic
{
     self.businessServerAddress = [dic objectForKey:@"bserver"];
     self.fileServerAddress = [dic objectForKey:@"fserver"];
     self.token =[dic objectForKey:@"token"];
    
    //[self longConnectCreate:self.businessServerAddress :nil];
  //   self.sessionID =  [dic objectForKey:@"userid"];

}
///*  http , short connect */
//-(void)shortConnectSendData:(NSData *)message to:(NSString*)httpURL
//{
//    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:httpURL]];
//    [request setRequestMethod:@"POST"];
//    
//    [request addRequestHeader:@"Content-Type" value:@"Application"];
//    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [message length]]];
//    [request appendPostData:message];
//    [request setValidatesSecureCertificate:NO];
//    [request setTimeOutSeconds:20];
//    request.defaultResponseEncoding = NSUTF8StringEncoding;
//    [request setDelegate:self];
//    [request startAsynchronous];
//}
ASIHTTPRequest * longRequest = nil;
-(void) longConnectCreate:(NSString*)httpURL :(NSData *)message
{
    if( longRequest == nil)
    {
        longRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:httpURL]];
        [longRequest setRequestMethod:@"POST"];
        [longRequest addRequestHeader:@"Content-Type" value:@"Application"];
        [longRequest addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [message length]]];
        [longRequest appendPostData:message];
        [longRequest setValidatesSecureCertificate:NO];
        [longRequest setTimeOutSeconds:20];
        longRequest.defaultResponseEncoding = NSUTF8StringEncoding;
        [longRequest setDelegate:self];
        [longRequest startAsynchronous];
    }
}
-(void)longConnectSendData:(NSData *)message
{
    if(longRequest != nil)
    {
      [longRequest addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [message length]]];
      [longRequest appendPostData:message];
  //  [longRequest setValidatesSecureCertificate:NO];
   // [request setTimeOutSeconds:20];
   // longRequest.defaultResponseEncoding = NSUTF8StringEncoding;
   // [longRequest setDelegate:self];
    [longRequest startAsynchronous];
    }
}

- (void)registerObserver:(id<ZZHttpInterface>)observer
{
    if ([self.observerArray containsObject:observer] == NO)
    {
        [self.observerArray addObject:observer];
    }
#ifdef DEBUG_ZZHttpManager_showObservers
    NSLog(@"DEBUG_ZZHttpManager_showObservers:%@",self.observerArray);
#endif
}

- (void)unRegisterObserver:(id<ZZHttpInterface>)observer
{
    if ([self.observerArray containsObject:observer])
    {
        [self.observerArray removeObject:observer];
    }
}

- (void)sendMessage:(NSData*)message
{
    [self sendMessage:message to:HTTP_REQ_URL];
}


-(void)sendMessageToBserver:(NSData*)message {
    // ∂ÂÂ≠®‰ªÂ∂Â‰ΩøÁ®‰°Ê°ÂÔºÊØËæ≤Âß„ÊØÂ¶Ê≤°ÁªÂ∂ÂÔºÁ¥¢Ê 
//    if([_bserverHttp length] == 0) {
//        _bserverHttp = @"http://192.168.1.113:5001";
//    }
    
//    NSLog(@"send message to:%@",bserverHttp);
    [self sendMessage:message to:self.businessServerAddress];
}
-(BOOL)connectServer
{
    BOOL result = false;
    return  result;

}

-(void)sendMessageToFserver:(NSData*)message {
    
    [self sendMessage:message to:_fserverHttp];
}
ASIHTTPRequest * request = nil;
// ßÂ∞Êkeep this breakpoint

//检测网络状态
-(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    switch ([reach currentReachabilityStatus]) {
            
        case NotReachable:
            
            isExistenceNetwork = NO;
            
            NSLog(@"notReachable");
            
            break;
            
        case ReachableViaWiFi:
            
            isExistenceNetwork = YES;
            
            NSLog(@"WIFI");
            
            break;
            
        case ReachableViaWWAN:
            
            isExistenceNetwork = YES;
            
            NSLog(@"3G");
            
            break;
            
    }
    
    return isExistenceNetwork;
    
}


-(void)sendMessage:(NSData *)message to:(NSString*)httpURL {
    
    //检测网络状态
    BOOL isExistenceNetwork = [self isConnectionAvailable];
    
    //这里还要处理一下，所有的请求在发送之前都要检测网络状态，im那块，在跟换新通讯之前也要检测网络状态，现在做的是除了im之外的
    if (!isExistenceNetwork) {
        
        //去掉菊花
        [SVProgressHUD popActivity];
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:keyWindow MESSAGE:@"网络未连接"];
        
        return;
        
    }
    
    if(httpURL == nil)
        httpURL = HTTP_REQ_URL;

    if([httpURL hasPrefix:@"http://"]== false) {
        httpURL = [NSString stringWithFormat:@"http://%@", httpURL];
    }
    NSLog(@"user server address:%@",httpURL);
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:httpURL]];
    request.defaultResponseEncoding = NSUTF8StringEncoding;

    [request setRequestMethod:@"POST"];
    
    [request addRequestHeader:@"Content-Type" value:@"Application"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [message length]]];
    [request appendPostData:message];
    [request setValidatesSecureCertificate:NO];
    [request setTimeOutSeconds:20];
    [request setDelegate:self];
    [request startAsynchronous];
    
    //  [jsonString release];
}

//TODO:: 2014Âπ0906 πËËØ•Â,•ÁÊ≠£Á°Æ
/*   ∞Ê?Ë≤‰ººÊ∞Ê•Ê  */
#pragma mark -ASIHTTPRequestDelegate Methods
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    //无论如何都要将菊花放下去
    //[SVProgressHUD popActivity];

    NSData *ndata = [request responseData];
    NSInteger byteLength = [ndata length];
    NSInteger leastLength = sizeof(UInt32)+sizeof(UInt32)+sizeof(UInt32)
    +sizeof(UInt16)+sizeof(UInt16) + sizeof(UInt32);
    if(leastLength>byteLength) {
        [self printData:ndata];
        NSLog(@"error: message is too short to parse....!");
        return;
    }
    
    
   // [self printData:ndata];
    const void* pData  = [ndata bytes];
    
    UInt32 length  = 0;
    memcpy((char*)&length, pData, sizeof(length));
    pData += sizeof(length);
    
    
    //packetLength =
   // int length = ntohl(packet);
    
    UInt32 messageType = 0;
    memcpy((char*)&messageType, pData, sizeof(messageType));
    pData += sizeof(messageType);
    
    UInt32 sessionID = 0;
    memcpy((char*)&sessionID, pData, sizeof(sessionID));
    pData += sizeof(sessionID);
    _sessionID = sessionID;
    
    
    UInt16 messageClass = 0;
    memcpy((char*)&messageClass, pData,sizeof(messageClass));
    pData += sizeof(messageClass);
    
    UInt16 returnCode = -1;
    memcpy((char*)&returnCode, pData,sizeof(returnCode));
    pData += sizeof(returnCode);
    
    if(returnCode!=0) {
        NSLog(@"%d",returnCode);
        NSLog(@"return code error...!!!");
        
        if (returnCode==204) {
            
            //发送通知（号码已经注册过）
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"PhoneNumberRegisterAgain" object:nil];
            
        }else if (returnCode==201){
                
            //提示框
            [[FDSPublicManage sharePublicManager] showInfo:[UIApplication sharedApplication].keyWindow MESSAGE:@"密码错误"];
            
        }else if (returnCode==202){
        
            //提示框
            [[FDSPublicManage sharePublicManager] showInfo:[UIApplication sharedApplication].keyWindow MESSAGE:@"登录账号不存在"];
            
        }else if (returnCode==203){
            
            [[FDSPublicManage sharePublicManager] showInfo:[UIApplication sharedApplication].keyWindow MESSAGE:@"登录账号已被禁用"];
            
        }
        
    }
    
    UInt32 responseBodyLength = 0;
    memcpy((char*)&responseBodyLength, pData,sizeof(responseBodyLength));
    pData += sizeof(responseBodyLength);
    
    if(responseBodyLength>kMaxMemory) {
        //debug print responseData before Crash
        NSLog(@"was crash?, take a look at this respnese data:");
        [self printData:ndata];
    }

    //sometimes server only return 0 or -1. Don't have responseBody!
    //Make a NSData myself,contains a json value {"returnCode":1}
    
    NSData* messageBodyData = nil;
    if(responseBodyLength==0) {
        NSMutableDictionary* bodyDic = [NSMutableDictionary dictionary];
        
        [bodyDic setInt:returnCode forKey:kReturnCodeKey];
        
        messageBodyData = [NSJSONSerialization dataWithJSONObject:bodyDic options:NSJSONWritingPrettyPrinted error:nil];
        
    }else {
        messageBodyData = [NSData dataWithBytes:pData length:responseBodyLength];
    }
    
    
    dispatch_async(dispatch_get_main_queue(),^{
        for(id<ZZHttpInterface>observer in self.observerArray)
        {
            // ËøË¶‰º•‰‰∏
            if([observer respondsToSelector:@selector(receiveHttpMessage:::)])
            {

              // [observer receiveHttpMessage:ndata];
                // ssm ËøË¶Â∞‰πËß£Ê∞ÁmessageClass ‰Ω‰∏∫Â∞‰
                [observer receiveHttpMessage:messageBodyData :messageClass :messageType];
            }
        }
    });
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD popActivity];
    NSString *result = [request responseString];
    NSError *error = [request error];
    NSLog(@"responseString:%@ \n%@",result,error.description);
    
    //判断roadTitleLab.text 是否含有qingjoin
    if([error.description rangeOfString:@"Code=2"].location !=NSNotFound)
    {
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:[UIApplication sharedApplication].keyWindow MESSAGE:@"网络请求超时"];
        
    }else if([error.description rangeOfString:@"Code=1"].location !=NSNotFound){

        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:[UIApplication sharedApplication].keyWindow MESSAGE:@"网络未连接"];
        
    }
    
}



-(NSString*)packageMessage:(NSString*)jsonMessage{
    NSMutableString* packagedMessage = [NSMutableString string];
    return packagedMessage;
}


-(void)updateBusinessServerHTTP_URL:(NSString*)ipAndPort {
    _bserverHttp =[ NSString stringWithFormat:@"http://%@",ipAndPort];
}

-(void)updateFileServerHTTP_URL:(NSString*)ipAndPort {
    _fserverHttp =[ NSString stringWithFormat:@"http://%@",ipAndPort];
}



//debug
-(void)printData:(NSData*)data {
    int length= [data length];
    char* arr = (char*)data.bytes;
    
    printf("<<<recv data:::(char)\n");
    
    for(int i=0; i<length;i++) {
        printf("%c,",*(arr+i));
    }
    printf("\nreve data end>>>\n");
    
}


@end
