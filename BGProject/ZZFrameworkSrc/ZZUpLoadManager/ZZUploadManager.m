//
//  ZZUploadManager.m
//  ZZFrameWork
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 naval. All rights reserved.
//

#import "ZZUploadManager.h"
#import "ZZSessionManager.h"
#import "FDSUserManager.h"

@implementation ZZUploadManager

static ZZUploadManager *uploadManager = nil;
+(ZZUploadManager * )sharedUploadManager
{
    if(nil == uploadManager)
    {
        uploadManager = [[ZZUploadManager alloc]init];
        [uploadManager managerInit];
        
    }
    return uploadManager;
}

-(void)managerInit
{
    if (self.observers == nil)
    {
        self.observers = [[[NSMutableArray alloc] init] autorelease];
    }
    
    if (self.uploadRequests == nil)
    {
        self.uploadRequests = [[[NSMutableArray alloc]init] autorelease];
    }
    //TODO:: 暂时写死文件服务器地址    fserver = "192.168.1.113:7091";
  //  uploadServerURL = [[NSString stringWithFormat:@"http://192.168.1.113:7091"] retain];
    uploadServerURL = [[NSString stringWithFormat:@"http://114.215.189.189:80"] retain];
    
    LookUploadStateServerURL = [[NSString stringWithFormat:@"http://112.124.108.71/ZZFileServer/LookFileUploadPage.jsp"] retain];
    /* get for some info... */
    [[ZZSessionManager sharedSessionManager]registerMessageObserver:self messageClass:kUploadManagerClass];
    
}

-(void)registerObserver:(id<ZZUploadInterface>)observer
{
    if ([self.observers containsObject:observer] == NO)
    {
        // [observer retain];
        [self.observers addObject:observer];
    }
}
-(void)unRegisterObserver:(id<ZZUploadInterface>)observer
{
    if ([self.observers containsObject:observer]) {
        [self.observers removeObject:observer];
    }
}

-(NSArray*)getNowUploadRequests
{
    return self.uploadRequests;
}
/*  begin a uploadSession */
-(enum ZZUploadState)beginUploadRequest:(NSString *)filePath :(NSString *)fileName :(NSString *)uploadSessionID :(NSString *)storeWay :(NSData *)fileDatas :(NSString *)fileType :(NSString *)folder{
    //上传状态吗？
    enum ZZUploadState uploadState = ZZUploadState_NONE;
    
    //上传一个上传请求
    ZZUploadRequest * uploadRequest = [[ZZUploadRequest alloc]init];
    
    //设置上传请求
    uploadRequest.m_filePath = filePath;
    uploadRequest.m_fileName = fileName;
    uploadRequest.m_uploadSessionID = uploadSessionID;
    uploadRequest.m_storeWay = storeWay;
    uploadRequest.m_fileDatas = fileDatas;
    uploadRequest.m_fileType = fileType;
    uploadRequest.m_fileSize =[fileDatas length];
    uploadRequest.m_folder = folder;
    //将请求加进上传请求数组uploadRequests里面，难道这是个线程池？？
    [self.uploadRequests addObject:uploadRequest];
    
    //上传状态开始／成功还是失败？？
    uploadRequest.m_uploadState = ZZUploadState_UPLOAD_BEGIN;
    
    //干嘛用的？
    [self uploadManagerStateNotice:uploadRequest];
    
    //开始上传
    [self startUploadRequst:uploadRequest];
    
    //返回上传状态
    return uploadState;

}
-(ZZUploadRequest*)getUploadRequestByASIHTTPRequest:(ASIHTTPRequest*)asiHTTPRequest
{
    for(ZZUploadRequest *uploadRequest in self.uploadRequests)
    {
         if(uploadRequest.m_asiFormDataRequest ==asiHTTPRequest)
             return uploadRequest;
    }
    return nil;
}
-(ZZUploadRequest*)getUploadRequestByHTTPRequest:(ASIHTTPRequest*)httpRequest
{
    for(ZZUploadRequest *uploadRequest in self.uploadRequests)
    {
        if(uploadRequest.m_stateCheckHTTPRequest ==httpRequest)
            return uploadRequest;
    }
    return nil;
}
-(void)startUploadRequst:(ZZUploadRequest*)uploadRequest
{
    //NSString* userid = [[FDSUserManager sharedManager] NowUserID];
    NSString* userid = uploadRequest.m_uploadSessionID;//userid 等同于 sessionID
    NSString *urlString = [[NSString stringWithFormat:@"%@/upload.ashx?%@=%@&%@=%@&%@=%@",uploadServerURL,kUseridKey,userid,  kTagKey,uploadRequest.m_folder,  kExtraKey,@"png"] retain];
    NSLog(@"urlString:%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];//image/jepg
    [request addRequestHeader:@"Content-Type" value:@"binary/octet-stream"];
    [request setTimeOutSeconds:15];
    [request setRequestMethod:@"POST"];
    
    // 当同时存在多个上传请求时(比如聊天界面，同时上传多个图片)用于作为key，区分不同的上传请求
    uploadRequest.m_asiFormDataRequest = request;
    /**test sample
    NSString* userid = [[FDSUserManager sharedManager] NowUserID];
    [request setPostValue:userid forKey:kUseridKey];
    [request setPostValue:@"userinfo" forKey:kTagKey];
    [request setPostValue:@"png" forKey:kExtraKey];
    
    [request addData:uploadRequest.m_fileDatas withFileName:uploadRequest.m_fileName andContentType:@"image/jpeg" forKey:uploadRequest.m_filePath];
     **/
    
     NSMutableData* imageData = [NSMutableData dataWithData:uploadRequest.m_fileDatas];
    [request setPostBody:imageData];

    [request setDelegate:self];
    
    [request setDidFailSelector:@selector(upLoadDidFailed:)];
    [request setDidFinishSelector:@selector(uploadDidSuccess:)];
    [request startAsynchronous];
    
    //TODO::暂时没有提供上传检测
//    uploadRequest.m_asiFormDataRequest = request;

//    uploadRequest.m_uploadState = ZZUploadState_UPLOADING;
//    [self uploadManagerStateNotice:uploadRequest];
//    [self uploadStateCheck:uploadRequest];
}//uploadStateNotice
-(void)uploadManagerStateNotice :(ZZUploadRequest*)uploadRequest
{
    
    
    for(id<ZZUploadInterface> upLoadInterface in self.observers)
    {
        if([upLoadInterface respondsToSelector:@selector(uploadStateNotice:)])
        {
           [upLoadInterface uploadStateNotice:uploadRequest];
        }
    }
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error = nil;
    NSLog(@"request-head:%@", request.responseHeaders);
    
    NSLog(@"requestFinished Response is %@",[request responseString]);
    NSString *resultString = [request responseString];
    resultString = [resultString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[resultString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    if (!error) {
        NSLog(@"JSON Data has Decoded...");
       
        ZZUploadRequest *uploadRequest = [self getUploadRequestByASIHTTPRequest:request];
        if(uploadRequest != nil)
        {
             NSString *result = [dic objectForKey:@"result"];
            if([result compare:@"success"] == 0)
             {
                /*  ok */
                uploadRequest.m_uploadState = ZZUploadState_UPLOAD_OK;
                uploadRequest.m_filePath = [dic objectForKey:@"fileURL"];
             }
            else
             {
             /*  fail */
                uploadRequest.m_uploadState = ZZUploadState_UPLOAD_FAIL;
              }
            [self uploadManagerStateNotice:uploadRequest];
            [self removeUploadrequest:uploadRequest];
        }
        else/*state check */
        {
            ZZUploadRequest *uploadRequest1 = [self getUploadRequestByHTTPRequest:request];
            if(uploadRequest1 == nil)
                return;
            NSString *result = [dic objectForKey:@"result"];
            NSString *bytesRead = [dic objectForKey:@"bytesRead"];
            if([result compare:@"sucess"] == 0)
            {
                uploadRequest1.m_uploadedSize = [bytesRead intValue];
                [self uploadManagerStateNotice:uploadRequest1];
                NSLog(@"get the state check, fileSize is  :%d,and upload Size is :%d",uploadRequest1.m_fileSize,uploadRequest1.m_uploadedSize);
                if(uploadRequest1.m_uploadState == ZZUploadState_UPLOADING && (uploadRequest1.m_uploadedSize < uploadRequest1.m_fileSize))
                {
                    [self uploadStateCheck:uploadRequest1];
                }
            }
            else
            {
                if(uploadRequest1.m_uploadState == ZZUploadState_UPLOADING)
                {
                     [self uploadStateCheck:uploadRequest1];
                }
            // fail
            }
            
            
        }
        
    }
    else{
        
        NSLog(@"##############Json数据解析出错编号4！！！###################");
    }
}


-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"upfile failed!!!\nReason:%@",request.responseString);
    
    ZZUploadRequest *uploadRequest = [self getUploadRequestByASIHTTPRequest:request];
    uploadRequest.m_uploadState = ZZUploadState_UPLOAD_FAIL;
    [self uploadManagerStateNotice:uploadRequest];
    [self removeUploadrequest:uploadRequest];
}
-(void)removeUploadrequest:(ZZUploadRequest*)uploadRequest
{
    [self.uploadRequests removeObject:uploadRequest];
}

/* state check */
-(void)uploadStateCheck:(ZZUploadRequest*)uploadRequest
{
    NSString *urlString = [NSString stringWithFormat:@"%@?UploadSessionID=%@",LookUploadStateServerURL,uploadRequest.m_uploadSessionID];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    uploadRequest.m_stateCheckHTTPRequest =request;
}

-(void)sessionManagerStateNotice:(enum ZZSessionManagerState)sessionManagerState
{
    if(sessionManagerState == ZZSessionManagerState_GETSEVERS)
    {
        
    }
}


// 上传图片成功，获取图片url
- (void)uploadDidSuccess:(ASIFormDataRequest *)request
{
    NSError *error = nil;
    NSLog(@" uploadDidSuccess Response is %@",[request responseString]);
    NSString *resultString = [request responseString];
    resultString = [resultString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //将字符串格式化成json格式
    
   // resultString = [self formatString:resultString];
    NSData* data = [resultString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];

    
    if (!error) {
        NSLog(@"JSON Data has Decoded...");
        
        ZZUploadRequest *uploadRequest = [self getUploadRequestByASIHTTPRequest:request];
        if(uploadRequest != nil)
        {
            NSString *result = [dic objectForKey:@"success"];
            

            // 这里有个逻辑漏洞，如果没有这个result key值,compare的判断还是==0!!!!
            //if([result compare:@"success"] == 0)
            if([result boolValue]==YES)
            {
                /*  ok debug this message*/
                uploadRequest.m_uploadState = ZZUploadState_UPLOAD_OK;
                uploadRequest.m_responseImgURL = dic[@"url"];
                uploadRequest.m_responseSmallURL =dic[@"smallurl"];
                
            }
            else
            {
                /*  fail */
                uploadRequest.m_uploadState = ZZUploadState_UPLOAD_FAIL;
            }
            [self uploadManagerStateNotice:uploadRequest];
            [self removeUploadrequest:uploadRequest];
        }
    }
    if(request) {
        [request release];
    }
}

    

-(void)upLoadDidFailed:(ASIFormDataRequest *)request{
        
    NSError *error = nil;
    NSLog(@" upLoadDidFailed Response is %@",[request responseString]);
//    NSString *resultString = [request responseString];
//    resultString = [resultString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    //将字符串格式化成json格式
//    
//    resultString = [self formatString:resultString];
//    NSData* data = [resultString dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    if (!error) {
        NSLog(@"JSON Data has Decoded...");
        
        ZZUploadRequest *uploadRequest = [self getUploadRequestByASIHTTPRequest:request];
        if(uploadRequest != nil)
        {
            uploadRequest.m_uploadState = ZZUploadState_UPLOAD_FAIL;
            [self uploadManagerStateNotice:uploadRequest];
            [self removeUploadrequest:uploadRequest];
        }

    }
    
    if(request) {
        [request release];
    }
}
    

-(NSString*)formatString:(NSString*)str {

    NSMutableString* tmpStr = [NSMutableString stringWithString:str];
    NSString* successKey = @"success";
    NSRange keyRang = [tmpStr rangeOfString:successKey];
    if(keyRang.location!=NSNotFound){
        [tmpStr replaceCharactersInRange:keyRang withString:@"\'success\'"];
    }
    NSString* targe1 = @"url";
    NSRange r1 = [tmpStr rangeOfString:targe1];
    if(r1.location!=NSNotFound){
        [tmpStr replaceCharactersInRange:r1 withString:@"\'url\'"];
    }
    
    
    NSString* targe2 = @"smallurl";
    NSRange r2 = [tmpStr rangeOfString:targe2];
    if(r2.location!=NSNotFound) {
        [tmpStr replaceCharactersInRange:r2 withString:@"\'smallurl\'"];
    }
    
    
    NSData* data = [tmpStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString* target = [NSString stringWithUTF8String:[data bytes]];
    
    char* p =(char*) [data bytes];
    for(int i=0; i<[data length]-1; i++) {
        
        while(*p=='\'') {
            *p = '\"';
        }
        p++;
    }
    target = [NSString stringWithUTF8String:[data bytes]];
    
    
    return target;
    
}
@end
