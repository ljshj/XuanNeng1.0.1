//
//  MoudleMessageManager.m
//  BGProject
//
//  Created by zhuozhongkeji on 14-9-16.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "AD_ATHumorModel.h"
#import "ZZLocationManager.h"
#import "FDSPublicManage.h"
#import "JokeModel.h"

#import "MoudleMessageManager.h"
#import "NSMutableDictionary+Zhangxx.h"
#import "weiQiangModel.h"
#import "WeiQiangRelatedModel.h"
#import "XNRelatedModel.h"
#import "ZZUserDefaults.h"

@implementation MoudleMessageManager

static MoudleMessageManager *instance = nil;

+(MoudleMessageManager*)sharedManager
{
    if(nil == instance)
    {
        instance = [MoudleMessageManager alloc ];
        instance.ranking = 1;//一开始的排名是1
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
                                                        messageClass:kModuleMessageClass];
    
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
    [message setObject:[NSNumber numberWithInt:kModuleMessageClass] forKey:kMessageClassKey];
    [super sendMessage:message];
    
}

// 参考FDS 的parseMessageData
- (void)parseMessageData:(NSDictionary *)data
{
    int msgType = [[data objectForKey:kMessageTypeKey] intValue];
    NSAssert(msgType!=0, @"没有解析到msgtype");
    //TODO::debug 分发任务.重点调试位置！
    
    NSLog(@"DEBUG MESSAGE-data:%@",data);
    switch (msgType) {
        case 870011:
        {
            int returnCode = [data[@"returnCode"]intValue];

            for(id<MoudleMessageInterface> interface in self.observerArray) {
                if([interface respondsToSelector:@selector(requestDeleteTopicCB:)])
                {
                    [interface requestDeleteTopicCB:returnCode];
                }
            }
        }
        break;
        case 870010:
            [self dispatchAD_AtHumour:data];
            break;
            
        case 870009:
            [self dispatchJoke:data];
            break;
            
         case 870008:
            [self dispatchSubmittedTopicList:data];
            break;
            
        case 870007:
            //炫能  赞
            [self dispatchSubmitSupportAtXuanNeng:data];
        break;
        case 870005:
            //炫能 分享回调
            [self dispatchSubmitShareAtXuanNeng:data];
        break;
            
        case 870006:
        [self dispatchSubmitCommentAtXuanNeng:data];
        break;
            
        // 炫能转发到微博
        case 870004:
        {
            int returnCode = [data[@"returnCode"]intValue];
            
            for(id<MoudleMessageInterface> interface in self.observerArray) {
                if([interface respondsToSelector:@selector(relayToWeiBoAtXuanNengCB:)])
                {
                    [interface relayToWeiBoAtXuanNengCB:returnCode];
                }
            }
        }
        break;
            
        //发表微博
        case 860003:
            [self dispatchIssueWeiBoAtWeiQiang:data];
            break;
            
            //炫能 投稿
        case 870003:
            [self dispatch87003WithDic:data];
            break;
            
        case 870002:
            [self dispatch87002WithDic:data];
            break;
        case 870019:
            [self dispatch87019WithDic:data];
            break;
            // 炫能转发到微博
        case 870021:
        {
            int returnCode = [data[@"returnCode"]intValue];
            
            for(id<MoudleMessageInterface> interface in self.observerArray) {
                if([interface respondsToSelector:@selector(contentApprovalCB:)])
                {
                    [interface contentApprovalCB:returnCode];
                }
            }
        }
            break;
        case 870022:
            [self dispatch87022WithDic:data];
            break;
        case 870001:
            [self dispatch87001WithDic:data];
            break;
            
        //获取微墙列表
        case 860001:
            [self dispatchWeiQiangList:data];
            break;
            
        //获取与我相关(微墙)
        case 860009:
            [self dispatchBeRelatedToMe:data];
            break;
        //获取与我相关（炫能）
        case 870012:
            [self dispatchBeRelatedXNToMe:data];
            break;
        case 860002:
            [self dispatchWeiQiangDetails:data];
            break;
        case 860004:
            [self dispatchDeleWeiBoAtWeiQiang:data];
            break;
        case 860005:
            [self dispatchTransmitWeiBoAtWeiQian:data];
            break;
        case 860006:
            [self dispatchShareWeiBoAtWeiQian:data];
            break;
        case 860007:
            [self dispatchSubmitCommentAtWeiQiang:data];
            break;
        case 860008:
            //  赞
            [self dispatchSubmitSupportAtWeiQiang:data];
            break;
        default:
            break;
    }
    
}




#pragma mark-获取经纬度

-(double)getLatitude{
    
    return [[ZZUserDefaults getDefault:LatitudeKey] doubleValue];
    
}

-(double)getLongitude{
    
    return [[ZZUserDefaults getDefault:LongitudeKey] doubleValue];
    
}

#pragma mark 微墙
//################微墙模块#####################
//获取墙列表
-(void)WeiQiangList:(int)type
              start:(int)start
                end:(int)end userid:(int)userid{
    
//    <type/>//1：关注；2：所有
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    [msg setInt:type forKey:@"type"];
    [msg setInt:start forKey:@"start"];
    [msg setInt:end forKey:@"end"];
    [msg setInt:userid forKey:@"userid"];
    [msg setDouble:[self getLatitude] forkey:LatitudeKey];
    [msg setDouble:[self getLongitude] forkey:LongitudeKey];
    
    
    [msg setInt:60001 forKey:kMessageTypeKey];
    [self sendMessage:msg];
}

//获取与我相关
-(void)beRelatedToMeWithStart:(int)start end:(int)end{
    
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];

    [msg setInt:start forKey:@"start"];
    [msg setInt:end forKey:@"end"];
    [msg setInt:60009 forKey:kMessageTypeKey];
    [self sendMessage:msg];
    
}

-(void)beRelatedToMeXuanNengWithStart:(int)start end:(int)end{
    
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    
    [msg setInt:start forKey:@"start"];
    [msg setInt:end forKey:@"end"];
    [msg setInt:70012 forKey:kMessageTypeKey];
    [self sendMessage:msg];
    
}

//获取内容详情
-(void)requestContentDetailsAtWeiQiang:(int)weiboid
                     :(int)comment_start
                     :(int)comment_end
{
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    [msg setInt:weiboid forKey:@"weiboid"];
    [msg setInt:comment_start forKey:@"comment_start"];
    [msg setInt:comment_end forKey:@"comment_end"];
    
    [msg setInt:60002 forKey:kMessageTypeKey];
    [self sendMessage:msg];
    
}


//发布微博
-(void)issueWeiBoAtWeiQiang:(NSString*)content img:(NSString*)img img_thum:(NSString*)img_thum longitude:(CGFloat)longitude latitude:(CGFloat)latitude{
    if (img==nil) {
        img = @"";
    }
    if(img_thum==nil) {
        img_thum = @"";
    }
    
    if(content==nil) {
        content = @"";
    }
    
    
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    [msg setObject:content forKey:@"content"];

    NSDictionary* imgs = @{@"img":img, @"img_thum":img_thum};
    [msg setObject:imgs forKey:@"imgs"];
    NSString* date_time = [[FDSPublicManage sharePublicManager]dateByFormate:@"yyyy-MM-dd HH:mm:ss"];

    [msg setObject:date_time forKey:@"date_time"];
    [msg setDouble:longitude forkey:@"longitude"];
    [msg setDouble:latitude forkey:@"latitude"];
    [msg setInt:60003 forKey:kMessageTypeKey];
    [self sendMessage:msg];
}


// 发送有多个图片的微博 2014年10月13日
-(void)issueWeiBoAtWeiQiangWithContent:(NSString*)content imageUrls:(NSArray*)imageUrls longitude:(CGFloat)longitude latitude:(CGFloat)latitude{
    
    if(content==nil) {
        content = @"";
    }
    
    //组织字典
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    
    //内容
    [msg setObject:content forKey:@"content"];
    
    //图片数组
    [msg setObject:imageUrls forKey:@"imgs"];
    
    //应该是发送时间
    NSString* date_time = [[FDSPublicManage sharePublicManager]dateByFormate:@"yyyy-MM-dd HH:mm:ss"];
    
    [msg setObject:date_time forKey:@"date_time"];
    [msg setDouble:longitude forkey:@"longitude"];
    [msg setDouble:latitude forkey:@"latitude"];
    [msg setInt:60003 forKey:kMessageTypeKey];
    
    //发送出去
    [self sendMessage:msg];
    
}

//删除微博
-(void)deleteWeiBoAtWeiQiang:(int)weiboid {
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    [msg setInt:weiboid forKey:@"weiboid"];
    [msg setInt:60004 forKey:kMessageTypeKey];
    [self sendMessage:msg];
}

// 转发微博
-(void)relayWeiBoAtWeiQiang:(int)weiboid comments:(NSString *)comments{
    
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    [msg setInt:weiboid forKey:@"weiboid"];
    [msg setObject:comments forKey:@"comments"];
    [msg setInt:60005 forKey:kMessageTypeKey];
    [self sendMessage:msg];
    
}

//分享微博
-(void)shareWeiBoAtWeiQiang:(int)weiboid {
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    
    [msg setInt:weiboid forKey:@"weiboid"];
    [msg setInt:60006 forKey:kMessageTypeKey];
    [self sendMessage:msg];
}

//用户评论  微博
-(void)submitCommentAtWeiQiang:(int)itemid :(NSString*)comments {
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    
    [msg setInt:itemid forKey:@"weiboid"];
    [msg setObject:comments forKey:@"comments"];
    [msg setInt:60007 forKey:kMessageTypeKey];
    [self sendMessage:msg];
}


//微墙中 用户点赞
-(void)submitSupportAtWeiQiang:(int)itemID {
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    
    [msg setInt:itemID forKey:@"weiboid"];
    [msg setInt:60008 forKey:kMessageTypeKey];
    [self sendMessage:msg];
}

#pragma mark 炫能
//################炫能模块#####################

// 获取笑话列表
-(void)requestJokeListWithItemid:(int)itemid type:(int)type start:(int)start end:(int)end{
    
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    
    [msg setInt:itemid forKey:@"itemid"];
    [msg setInt:type forKey:@"type"];
    [msg setInt:start forKey:@"start"];
    [msg setInt:end forKey:@"end"];
    [msg setDouble:[self getLatitude] forkey:LatitudeKey];
    [msg setDouble:[self getLongitude] forkey:LongitudeKey];
    
    [msg setInt:70001 forKey:kMessageTypeKey];
    [self sendMessage:msg];
    
}

// 获取排行榜
//参考文档，提交的参数是 日、周、月、年等
// itemid 0： 表示炫能  1：表示幽默秀
-(void)requestCharts:(int)itemid :(int)rank_type :(int)start :(int)end
{
    
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    [msg setInt:itemid forKey:@"itemid"];
    [msg setInt:rank_type forKey:@"rank_type"];
    [msg setInt:start forKey:kStartKey];
    [msg setInt:end forKey:kEndKey];
    [msg setDouble:[self getLatitude] forkey:LatitudeKey];
    [msg setDouble:[self getLongitude] forkey:LongitudeKey];
    
    [msg setInt:70002 forKey:kMessageTypeKey];
    [self sendMessage:msg];
}


//获取榜单（日／周／月）
-(void)requestChartsList:(int)itemid :(int)type :(int)start :(int)end
{
    
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    [msg setInt:itemid forKey:@"itemid"];
    [msg setInt:type forKey:@"type"];
    [msg setInt:start forKey:kStartKey];
    [msg setInt:end forKey:kEndKey];
    [msg setObject:@"" forKey:@"timestart"];
    [msg setObject:@"" forKey:@"timeend"];
    [msg setDouble:[self getLatitude] forkey:LatitudeKey];
    [msg setDouble:[self getLongitude] forkey:LongitudeKey];
    [msg setInt:70019 forKey:kMessageTypeKey];
    
    [self sendMessage:msg];
}

// 投稿(无图片)
-(void)submitTopic:(NSString*)content img:(NSString*)img img_thum:(NSString*)img_thum itemId:(NSInteger)itemId longitude:(CGFloat)longitude latitude:(CGFloat)latitude{
    
    if(img==nil) {
        img =@"";
    }
    if(img_thum==nil) {
        img_thum=@"";
    }
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    [msg setInt:(int)itemId forKey:kItemId];
    [msg setObject:content forKey:@"content"];
    
    NSDictionary* imgs = @{@"img":img, @"img_thum":img_thum};
    [msg setObject:imgs forKey:@"imgs"];
    [msg setDouble:longitude forkey:@"longitude"];
    [msg setDouble:latitude forkey:@"latitude"];
    [msg setInt:70003 forKey:kMessageTypeKey];
    [self sendMessage:msg];
    
}

//多个图片的投稿
-(void)submitTopic:(NSString *)content imageUrls:(NSArray*)imageUrls itemId:(NSInteger)itemId longitude:(CGFloat)longitude latitude:(CGFloat)latitude{
    
    if(content==nil) {
        content = @"";
    }
    
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    
    [msg setInt:(int)itemId forKey:kItemId];
    [msg setObject:content forKey:@"content"];
    [msg setObject:imageUrls forKey:@"imgs"];
    [msg setDouble:longitude forkey:@"longitude"];
    [msg setDouble:latitude forkey:@"latitude"];
    [msg setInt:70003 forKey:kMessageTypeKey];
    
    [self sendMessage:msg];
}

//转发到微博 将 @"itemid" 改成 @"xnid"，尼玛的，不早说，害老子着了半天
-(void)relayToWeiBoAtXuanNeng:(int)itemid comments:(NSString *)comments{
    
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    [msg setInt:itemid forKey:@"xnid"];
    [msg setObject:comments forKey:@"comments"];
    [msg setInt:70004 forKey:kMessageTypeKey];
    [self sendMessage:msg];
    
}

-(void)requestDeleteTopic:(int)xnid
{
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    [msg setInt:xnid forKey:@"xnid"];
    [msg setInt:70011 forKey:kMessageTypeKey];
    [self sendMessage:msg];
}

//分享到其他平台
-(void)shareJokeAtXuanNeng:(int)itemid {
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    [msg setInt:itemid forKey:@"xnid"];
    [msg setInt:70005 forKey:kMessageTypeKey];
    [self sendMessage:msg];
}


//用户评论  笑话id 评论内容
-(void)submitCommentAtXuanNeng:(int)itemid :(NSString*)comments {
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    
    [msg setInt:itemid forKey:@"xnid"];
    [msg setObject:comments forKey:@"comments"];
    [msg setInt:70006 forKey:kMessageTypeKey];
    [self sendMessage:msg];
}



//用户点赞
-(void)submitSupportAtXuanNeng:(int)itemID {
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    
    [msg setInt:itemID forKey:@"xnid"];
    [msg setInt:70007 forKey:kMessageTypeKey];
    [self sendMessage:msg];
}

-(void)requestSubmittedTopicList:(int)type start:(int)start end:(int)end userid:(NSString *)userid{
    
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    [msg setInt:type  forKey:@"type"];
    [msg setInt:start forKey:@"start"];
    [msg setInt:end forKey:@"end"];
    [msg setObject:userid forKey:@"userid"];
    [msg setInt:70008 forKey:kMessageTypeKey];
    [self sendMessage:msg];
    
}

//微墙分享回调
-(void)dispatchShareWeiBoAtWeiQian:(NSDictionary *)data{
    for(id<MoudleMessageInterface> interface in self.observerArray) {
        if([interface respondsToSelector:@selector(shareWeiBoCB:)])
        {
            int result = [data[@"result"]intValue];
            [interface shareWeiBoCB:result];
            NSLog(@"微墙分享回应。。。");
        }
    }
}

//微墙转发回调
-(void)dispatchTransmitWeiBoAtWeiQian:(NSDictionary *)data{
    for(id<MoudleMessageInterface> interface in self.observerArray) {
        if([interface respondsToSelector:@selector(relayWeiBoAtWeiQiangCB:)])
        {
            int result = [data[@"result"]intValue];
            [interface relayWeiBoAtWeiQiangCB:result];
            NSLog(@"微墙转发回应。。。");
        }
    }
}
//微墙点赞回调
-(void)dispatchSubmitSupportAtWeiQiang:(NSDictionary *)data{
    for(id<MoudleMessageInterface> interface in self.observerArray) {
        if([interface respondsToSelector:@selector(submitSupportAtWeiQiangCB:)])
        {
            int result = [data[@"returnCode"]intValue];
            [interface submitSupportAtWeiQiangCB:result];
            NSLog(@"微墙赞回应。。。");
        }
    }
}

//炫能点赞回调
-(void) dispatchSubmitSupportAtXuanNeng:(NSDictionary*)data
{
    for(id<MoudleMessageInterface> interface in self.observerArray) {
        if([interface respondsToSelector:@selector(submitSupportAtXuanNengCB:)])
        {
           int result = [data[@"returnCode"]intValue];
           [interface submitSupportAtXuanNengCB:result];
            NSLog(@"赞回应。。。");
        }
    }
}

//幽默秀分享回调
-(void)dispatchSubmitShareAtXuanNeng:(NSDictionary *)data{
    for(id<MoudleMessageInterface> interface in self.observerArray) {
        if([interface respondsToSelector:@selector(shareJokeAtXuanNengCB:)])
        {
            int result = [data[@"result"]intValue];
            [interface shareJokeAtXuanNengCB:result];
            NSLog(@"分享回应。。。");
        }
    }
}

//炫能评论回调
-(void)dispatchSubmitCommentAtXuanNeng:(NSDictionary*)data {
    for(id<MoudleMessageInterface> interface in self.observerArray) {
        if([interface respondsToSelector:@selector(submitCommentAtXuanNengCB:)])
        {
            int result = [data[@"result"]intValue];
            [interface submitCommentAtXuanNengCB:result];
            NSLog(@"评论回应。。。");
        }
    }
}

//微博详情回调
-(void)dispatchWeiQiangDetails:(NSDictionary *)data{
    for(id<MoudleMessageInterface> interface in self.observerArray) {
        if([interface respondsToSelector:@selector(contentDetailsCB:)])
        {
            [interface contentDetailsCB:data];
        }
    }
}

//上传评论回调
-(void)dispatchSubmitCommentAtWeiQiang:(NSDictionary *)data{
    for(id<MoudleMessageInterface> interface in self.observerArray) {
        if([interface respondsToSelector:@selector(submitCommentAtWeiQiangCB:)])
        {
            int result = [data[@"returnCode"]intValue];
            [interface submitCommentAtWeiQiangCB:result];
            NSLog(@"评论回应。。。");
        }
    }
}

//微博列表回调
-(void)dispatchWeiQiangList:(NSDictionary*)dic {

    NSMutableArray* array = [NSMutableArray array];
    NSArray* items = dic[@"items"];
    for(int i=0; i<items.count; i++) {
        
        weiQiangModel* model = [[weiQiangModel alloc]initWithDic:items[i]];
        [array addObject:model];
    }
    
    for(id<MoudleMessageInterface> interface in self.observerArray) {
        if([interface respondsToSelector:@selector(weiQiangListCB:)])
        {
            [interface weiQiangListCB:array];
        }
    }


}

//与我相关回调(微墙)
-(void)dispatchBeRelatedToMe:(NSDictionary *)data{
    
    //取出数组
    NSArray *merelated = data[@"merelated"];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in merelated) {
        
        WeiQiangRelatedModel *model = [[WeiQiangRelatedModel alloc] initWithDic:dic];
        [tempArray addObject:model];
        
    }
    
    for(id<MoudleMessageInterface> interface in self.observerArray) {
        if([interface respondsToSelector:@selector(beRelatedToMeCB:)])
        {
            [interface beRelatedToMeCB:tempArray];
        }
    }
    
}

//与我相关回调(炫能)
-(void)dispatchBeRelatedXNToMe:(NSDictionary *)data{
    
    //取出数组
    NSArray *merelated = data[@"merelated"];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in merelated) {
        
        XNRelatedModel *model = [[XNRelatedModel alloc] initWithDic:dic];
        [tempArray addObject:model];
        
    }
    
    for(id<MoudleMessageInterface> interface in self.observerArray) {
        if([interface respondsToSelector:@selector(beRelatedToMeXuanNengCB:)])
        {
            [interface beRelatedToMeXuanNengCB:tempArray];
        }
    }
    
}

// 提交笑话 投稿
-(void)dispatch87003WithDic:(NSDictionary*)data;
{
    int result = [data[kReturnCodeKey] intValue];
    
    for(id<MoudleMessageInterface> interface in self.observerArray) {
        if([interface respondsToSelector:@selector(submitTopicCB:)])
        {
            [interface submitTopicCB:result];
        }
    }
}

//顺序或者随机数据回调
-(void)dispatch87001WithDic:(NSDictionary*)data{
    
    //初始化数组
    NSMutableArray* jokes = [NSMutableArray array];
    
    //取出笑话数组
    NSArray* rawJoke = data[@"jokes"];
    
    //将字典数组转化成模型数组
    if (rawJoke.count != 0) {
        for(int i=0; i<rawJoke.count; i++) {
            
            //取出字典
            NSDictionary* tmpDic = rawJoke[i];
            
            //字典转化成模型
            JokeModel* joke = [[JokeModel alloc]initWithDic:tmpDic];
            
            //模型添加到数组里面
            [jokes addObject:joke];
        }
    }
    
    //回调
    for(id<MoudleMessageInterface> interface in self.observerArray) {
        if([interface respondsToSelector:@selector(requestJokeListCB:)])
        {
            [interface requestJokeListCB:jokes];
        }
    }
    
}

//排行榜数据返回
-(void)dispatch87002WithDic:(NSDictionary*)data {
    
    //初始化数组
    NSMutableArray* jokes = [NSMutableArray array];
    
    //取出笑话数组
    NSArray* rawJoke = data[@"jokes"];
    
    //将字典数组转化成模型数组
    if (rawJoke.count != 0) {
        for(int i=0; i<rawJoke.count; i++) {
            
            //取出字典
            NSDictionary* tmpDic = rawJoke[i];
            
            //字典转化成模型
            JokeModel* joke = [[JokeModel alloc]initWithDic:tmpDic];
            
            //设置排行榜排名
            if (i<=2) {
                
                joke.ranking = [NSString stringWithFormat:@"%d",i+1];
                
            }
            
            //设置模型类型为排行榜
            joke.jokeType=JokeTypeRank;
            
            //模型添加到数组里面
            [jokes addObject:joke];
        }
    }
    
    //回调
    for(id<MoudleMessageInterface> interface in self.observerArray) {
        if([interface respondsToSelector:@selector(requestChartsCB:)])
        {
            [interface requestChartsCB:jokes];
        }
    }    
}

//榜单
-(void)dispatch87019WithDic:(NSDictionary*)data {
    
    //初始化数组
    NSMutableArray* jokes = [NSMutableArray array];
    
    //取出笑话数组
    NSArray* rawJoke = data[@"jokes"];
    
    //记录下前一个的时间
    NSString *preOpartime = nil;
    
    //将字典数组转化成模型数组
    if (rawJoke.count != 0) {
        for(int i=0; i<rawJoke.count; i++) {
            
            //取出字典
            NSDictionary* tmpDic = rawJoke[i];
            
            //取出当前时间
            NSString *nowTime = tmpDic[@"opartime"];
            
            //记录下前一个时间，用来比较
            if (i!=0) {
                //取出前一个字典
                NSDictionary* preDic = rawJoke[i-1];
                preOpartime = preDic[@"opartime"];
            }
            
            //字典转化成模型
            JokeModel* joke = [[JokeModel alloc]initWithDic:tmpDic];
            
            //计算出排名
            joke.ranking = [self setupRankingWithPreOpartime:preOpartime nowTime:nowTime];
            
            //设置模型类型为榜单
            joke.jokeType = JokeTypeRankList;
            
            //模型添加到数组里面
            [jokes addObject:joke];
        }
    }
    
    //回调
    for(id<MoudleMessageInterface> interface in self.observerArray) {
        if([interface respondsToSelector:@selector(requestChartsListCB:)])
        {
            [interface requestChartsListCB:jokes];
        }
    }
}

//获取未审核
-(void)dispatch87022WithDic:(NSDictionary*)data {
    
    //初始化数组
    NSMutableArray* jokes = [NSMutableArray array];
    
    //取出笑话数组
    NSArray* rawJoke = data[@"jokes"];
    
    //将字典数组转化成模型数组
    if (rawJoke.count != 0) {
        for(int i=(int)rawJoke.count-1; i>=0; i--) {
            
            //取出字典
            NSDictionary* tmpDic = rawJoke[i];
            
            //字典转化成模型
            JokeModel* joke = [[JokeModel alloc]initWithDic:tmpDic];
            
            //模型添加到数组里面
            [jokes addObject:joke];
            
        }
    }
    
    //回调
    for(id<MoudleMessageInterface> interface in self.observerArray) {
        if([interface respondsToSelector:@selector(requestUnauditedContentCB:)])
        {
            [interface requestUnauditedContentCB:jokes];
        }
    }
    
}

//通过时间的比较返回一个排名
-(NSString *)setupRankingWithPreOpartime:(NSString *)preOpartime nowTime:(NSString *)nowTime{
    
    if (![preOpartime isEqualToString:nowTime]) {
        
        self.ranking = 1;
        
    }else{
        
        self.ranking = self.ranking+1;
        
    }
    
    return [NSString stringWithFormat:@"%d",self.ranking];
    
}

//发布成功
-(void)dispatchIssueWeiBoAtWeiQiang:(NSDictionary*)dic {
    int result = [dic[kReturnCodeKey] intValue];
    
    for(id<MoudleMessageInterface> interface in self.observerArray) {
        if([interface respondsToSelector:@selector(issueWeiBoAtWeiQiangCB:)])
        {
            [interface issueWeiBoAtWeiQiangCB:result];
        }
    }
}


// 删除微博后的回调
-(void)dispatchDeleWeiBoAtWeiQiang:(NSDictionary*)dic {
    NSLog(@"dic:%@",dic);
    
    int result = [dic[kReturnCodeKey] intValue];
    
    for(id<MoudleMessageInterface> interface in self.observerArray) {
        if([interface respondsToSelector:@selector(deleteWeiBoAtWeiQiangCB:)])
        {
            [interface deleteWeiBoAtWeiQiangCB:result];
        }
    }
}
/*
 <jokes>
 <item>
 <jokeid/>
 <userid/>
 <username/>
 <photo/>
 <distance/>
 <date_time/>
 <content/>
 <imgs>
 <img>product_img.jpg</img>//大图<img_thum>product_img_thum.jpg</img_thum>//缩略图
 </imgs>
 <like_count/>
 <comment_count/>
 <forward_count/>
 <share_count/>
 </item>
 </jokes>
 </msgbody>
*/

//我的投稿回调
-(void)dispatchSubmittedTopicList:(NSDictionary*)dic {
    
    //初始化数组
    NSMutableArray* jokes = [NSMutableArray array];
    
    //取出数组
    NSArray* rawJoke = dic[@"jokes"];
    
    //将字典转换成模型
    for(int i=0; i<rawJoke.count; i++) {
        NSDictionary* tmpDic = rawJoke[i];
        JokeModel* joke = [[JokeModel alloc]initWithDic:tmpDic];
        //设置模型类型为我的幽默秀
        joke.jokeType = JokeTypeMyHumorousShow;
        [jokes addObject:joke];
    }
    
    //回调
    for(id<MoudleMessageInterface> interface in self.observerArray) {
        if([interface respondsToSelector:@selector(requestSubmittedTopicListCB:)])
        {
            [interface requestSubmittedTopicListCB:jokes];
        }
    }
}


//查看笑话
-(void)requestJoke:(NSString*)itemID
                  :(int)comment_start
                  :(int)comment_end
{

    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    [msg setObject:itemID forKey:kXnIDKey];
    [msg setInt:comment_start forKey:kComment_startKey];
    [msg setInt:comment_end forKey:kComment_endKey];
    [msg setInt:70009 forKey:kMessageTypeKey];
    [self sendMessage:msg];
}


//笑话详情回调
-(void)dispatchJoke:(NSDictionary*)data {
    
    //TODO::将arr传到下个页面
    for(id<MoudleMessageInterface> interface in self.observerArray)
    {
        if([interface respondsToSelector:@selector(requestJokeCB:)])
        {
            [interface requestJokeCB:data];
        }
    }
    return;
}


//获取幽默秀广告
-(void)requestAD_AtHumour {
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    [msg setInt:70010 forKey:kMessageTypeKey];
    [self sendMessage:msg];
}

//会员审核 0，不审核；1审核，2原创，3举报
-(void)contentApprovalWithItemid:(int)itemid type:(int)type{
    
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    
    [msg setInt:70021 forKey:kMessageTypeKey];
    [msg setInt:itemid forKey:@"itemid"];
    [msg setInt:type forKey:@"type"];
    
    [self sendMessage:msg];
    
}

//获取未审核内容
-(void)requestUnauditedContentWithItemid:(int)itemid type:(int)type start:(int)start end:(int)end maxxnid:(int)maxxnid{
    
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    
    [msg setInt:70022 forKey:kMessageTypeKey];
    [msg setInt:itemid forKey:@"itemid"];
    [msg setInt:type forKey:@"type"];
    [msg setInt:start forKey:@"start"];
    [msg setInt:end forKey:@"end"];
    [msg setInt:maxxnid forKey:@"maxxnid"];
    
    [self sendMessage:msg];
    
}

-(void)dispatchAD_AtHumour:(NSDictionary*)dic {
    
    NSDictionary* rawDic = dic;
    
    NSMutableArray* arr = [NSMutableArray array];
    AD_ATHumorModel* ad = [[AD_ATHumorModel alloc]init];
    ad.adid = [rawDic[@"adid"] intValue];
    ad.adType = [rawDic[@"ad_type"] intValue];
    ad.adContent = rawDic[@"ad_content"];
    

    ad.imageURL =  rawDic[@"imgs"][@"img"];
    ad.imageThumURL = rawDic[@"imgs"][@"img_thum"];
    
    
    [arr addObject:ad];
    //TODO::将arr传到下个页面
    for(id<MoudleMessageInterface> interface in self.observerArray)
    {
        if([interface respondsToSelector:@selector(requestAD_AtHumourCB:)])
        {
            [interface requestAD_AtHumourCB:arr];
        }
    }
    return;
    
}




@end
