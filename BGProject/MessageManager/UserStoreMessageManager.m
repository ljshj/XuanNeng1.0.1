//
//  UserStoreMessageManager.m
//  BGProject
//
//  Created by zhuozhongkeji on 14-9-16.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "UserStoreMessageManager.h"
#import "NSMutableDictionary+Zhangxx.h"

#import "ProductModel.h"
#import "ChuChuangModel.h"

//#define FDSUserCenterMessageClass @"fdsUserStoreMessageManager"
@implementation UserStoreMessageManager
static UserStoreMessageManager *instance = nil;
+(UserStoreMessageManager*)sharedManager
{
    if(nil == instance)
    {
        instance = [UserStoreMessageManager alloc ];
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
                                                        messageClass:kUserStoreMessageClass];
    
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
- (void)sendMessage:(NSMutableDictionary *)message
{
    
    // 添加发送消息的标记，等到服务器返回的时候，依据该标记找到发送者
    [message setObject:[NSNumber numberWithInt:kUserStoreMessageClass] forKey:kMessageClassKey];
    
    [super sendMessage:message];
}
// 参考FDS 的parseMessageData
- (void)parseMessageData:(NSDictionary *)data
{
    int msgType = [[data objectForKey:kMessageTypeKey] intValue];
    NSAssert(msgType!=0, @"没有解析到msgtype");
    //TODO::debug 分发任务.重点调试位置！
    
    switch (msgType) {
            
            // 添加商品回调
        case 830003:
        {
            int returnCode = [data[@"returnCode"] intValue];
            
            for(id<UserStoreMessageInterface> interface in self.observerArray)
            {
                if ([interface respondsToSelector:@selector(addProductCB:)])
                {
                    [interface addProductCB: returnCode];
                }
            }
        }
            break;
        case 830007:
        {
        
            for(id<UserStoreMessageInterface> interface in self.observerArray)
            {
                if ([interface respondsToSelector:@selector(request30007CB:)])
                {
                    [interface request30007CB:data];
                }
            }
        }
            break;
        case 830008:
        {
            // 构建数组
            NSMutableArray* productArr = [NSMutableArray array];
            
            //取出产品数组
            NSArray* rawArr = data[@"products"];
            
            //将字典数组转换成模型数组
            if (rawArr.count) {
                [rawArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    //将字典转换成数组
                    ProductModel* model = [[ProductModel alloc]initWithDic:obj];
                    
                    [productArr addObject:model];
                    
                }];
            }
            
            //回调
            for(id<UserStoreMessageInterface> interface in self.observerArray)
            {
                if ([interface respondsToSelector:@selector(requestProductListCB:)])
                {
                    [interface requestProductListCB:productArr];
                }
            }
        }
            break;
            
            // 删除商品
        case 830005:
        {
            int returnCode = [data[@"returnCode"] intValue];
            for(id<UserStoreMessageInterface> interface in self.observerArray)
            {
                if ([interface respondsToSelector:@selector(requestDeleteProductCB:)])
                {
                    [interface requestDeleteProductCB:returnCode];
                }
            }
        }
            break;
            
        // 修改商品
        case 830004:
        {
            int returnCode = [data[@"returnCode"] intValue];
            for(id<UserStoreMessageInterface> interface in self.observerArray)
            {
                if ([interface respondsToSelector:@selector(updateProductCB:)])
                {
                    [interface updateProductCB:returnCode];
                }
            }
        }
            break;
        
            
        case 830010:
        {
            int returnCode = [data[@"returnCode"] intValue];
            for(id<UserStoreMessageInterface> interface in self.observerArray)
            {
                if ([interface respondsToSelector:@selector(submitProductCommentCB:)])
                {
                    [interface submitProductCommentCB:returnCode];
                }
            }
        }
            break;
        case 830011:
        {
            
            NSArray *comments = data[@"comments"];
            
            for(id<UserStoreMessageInterface> interface in self.observerArray)
            {
                if ([interface respondsToSelector:@selector(requestProductCommentsCB:)])
                {
                    [interface requestProductCommentsCB:comments];
                }
            }
        }
            break;
        case 830001:
        {
            //获取字典
            NSMutableDictionary* rawDic = [NSMutableDictionary dictionaryWithDictionary:data];
            
            //删掉kMessageTypeKey，可能模型并不需要它吧
            [rawDic removeObjectForKey:kMessageTypeKey];
            
            //字典转换成模型，里面那个产品推荐数组还没有处理
            ChuChuangModel* model = [[ChuChuangModel alloc]initWithDic:rawDic];
            
            //橱窗回调
            for(id<UserStoreMessageInterface> interface in self.observerArray)
            {
                if([interface respondsToSelector:@selector(request30001CB:)])
                {
                    [interface request30001CB:model];
                }
            }
            
        }
            break;
            
            case 830006:
            {
                
                NSMutableArray* productArr = [NSMutableArray array];//模型数组
                
                //取出搜索产品数组
                NSArray* rawArr = data[@"products"];
                
                //遍历数组
                [rawArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    //将字典转换成数组
                    ProductModel* model = [[ProductModel alloc]initWithDic:obj];
                    
                    // 请求到的数据id是从小到大,显示的时候需要从大到小。
                    [productArr insertObject:model atIndex:0];
                }];
                
                // 不要依赖服务器的返回数据的次序，自己完成元素的排序。按照升序
                NSSortDescriptor* sortByID = [NSSortDescriptor sortDescriptorWithKey:@"product_id_int"
                                                                           ascending:YES];
                [productArr sortUsingDescriptors:@[sortByID]];
                
                //回调
                for(id<UserStoreMessageInterface> interface in self.observerArray)
                {
                    if ([interface respondsToSelector:@selector(request30006CB:)])
                    {
                        [interface request30006CB:productArr];
                    }
                }

            }
            
        default:
            break;
    }
}

//添加商品
-(void)addProductWithPname:(NSString *)name
                     price:(NSString *)price
                     intro:(NSString *)intro
                    brecom:(BOOL)isBrecom
                       img:(NSString *)imgurl
                  img_thum:(NSString *)img_thumurl
{
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    
    [msg setInt:kMessageType_AddProduct forKey:kMessageTypeKey];
    [msg setObject:name forKey:@"pname"];
    [msg setObject:price forKey:@"price"];
    // 0 1, 1 表示推荐
    if(isBrecom){
        [msg setInt:1  forKey:@"brecom"];
    }else {
        [msg setInt:0 forKey:@"brecom"];
    }
    
    [msg setObject:imgurl forKey:@"img"];
    
    [msg setObject:img_thumurl forKey:@"img_thum"];
    [msg setObject:intro forKey:@"intro"];
    [self sendMessage:msg];
}

//获取商品列表30008
-(void)requestProductListWithUserID:(NSString*)userid
                          withStart:(int)start
                            withEnd:(int)end
{
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    [msg setInt:30008 forKey:kMessageTypeKey];
    [msg setObject:userid  forKey:kUseridKey];
    [msg setInt:start forKey:@"start"];
    
    //多了keyword的字段
    [msg setObject:@"" forKey:@"keyword"];
    [msg setInt:end forKey:@"end"];
    
    [self sendMessage:msg];
}


//30005 删除商品
-(void)requestDeleteProductWithID:(NSString*)proid
{
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    [msg setInt:30005 forKey:kMessageTypeKey];
    [msg setObject:proid forKey:@"proid"];
    [self sendMessage:msg];
}

// 修改商品 30004
-(void)updateProductWithId:(NSString*)proid
                      name:(NSString*)pname
                     price:(NSString*)price
                     intro:(NSString*)intro
                    brecom:(BOOL)brecom
                       img:(NSString*)img
                  img_thum:(NSString*)img_thum
{
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    [msg setInt:30004 forKey:kMessageTypeKey];
    [msg setObject:proid forKey:@"proid"];
    [msg setObject:pname forKey:@"pname"];
    [msg setObject:price forKey:@"price"];
    // 0 1, 1 表示推荐
    if(brecom){
        [msg setInt:1  forKey:@"brecom"];
    }else {
        [msg setInt:0 forKey:@"brecom"];
    }
    
    [msg setObject:img forKey:@"img"];
    
    [msg setObject:img_thum forKey:@"img_thum"];
    [msg setObject:intro forKey:@"intro"];
    
    [self sendMessage:msg];
}

//评论商品30010
-(void)submitProductComment:(NSString *)comments productId:(int)product_id{
    
    //初始化一个字典
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    
    //消息类型
    [msg setInt:30010 forKey:kMessageTypeKey];
    
    [msg setInt:product_id forKey:@"product_id"];
    
    [msg setObject:comments forKey:@"comments"];
    
    [self sendMessage:msg];
}

//请求商品评论
-(void)requestProductCommentsWithProID:(int)product_id start:(int)comment_start end:(int)comment_end{
    
    //初始化一个字典
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    
    //消息类型
    [msg setInt:30011 forKey:kMessageTypeKey];
    
    [msg setInt:product_id forKey:@"product_id"];
    
    [msg setInt:comment_start forKey:@"comment_start"];
    
    [msg setInt:comment_end forKey:@"comment_end"];
    
    [self sendMessage:msg];
    
}

//请求橱窗30001

-(void)request30001WithID:(NSString*)userid
{
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    
    [msg setInt:30001 forKey:kMessageTypeKey];
    [msg setObject:userid  forKey:kUseridKey];
    [self sendMessage:msg];
}

//<userid/>//用户id
//<keyword/> //关键词
//</msgbody>
-(void)request30006withID:(NSString*)userid
                  keyword:(NSString*)keyword
{
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    
    [msg setInt:30006 forKey:kMessageTypeKey];
    [msg setObject:userid  forKey:kUseridKey];
    [msg setObject:keyword forKey:@"keyword"];
    [self sendMessage:msg];
}

//30007 请求商品详情
-(void)request30007WithProID:(NSString*)product_id
{
 
  
        NSMutableDictionary* msg = [NSMutableDictionary dictionary];
        
        [msg setInt:30007 forKey:kMessageTypeKey];
        [msg setObject:product_id  forKey:@"product_id"];
        [self sendMessage:msg];
 

}



@end
