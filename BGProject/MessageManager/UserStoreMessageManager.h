//
//  UserStoreMessageManager.h
//  BGProject
//
//  Created by zhuozhongkeji on 14-9-16.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ZZMessageManager.h"
#import "UserStoreMessageInterface.h"
#import "ZZSessionManager.h"
@interface UserStoreMessageManager : ZZMessageManager
+ (UserStoreMessageManager*)sharedManager;
- (void)registerObserver:(id<UserStoreMessageInterface>)observer;
- (void)unRegisterObserver:(id<UserStoreMessageInterface>)observer;
-(void)addProductWithPname:(NSString*)name
                     price:(NSString*)price
                     intro:(NSString*)intro
                    brecom:(BOOL)isBrecom// 是否推荐
                       img:(NSString*)imgurl
                  img_thum:(NSString*)img_thumurl;




-(void)requestProductListWithUserID:(NSString*)userid
                          withStart:(int)start
                            withEnd:(int)end;


//30005 删除商品
-(void)requestDeleteProductWithID:(NSString*)proid;


//<proid/>//产品id
//<pname/>//产品名
//<price/>//价格
//<intro/>//介绍
//<brecom/>//是否推荐
//<img>product_img.jpg</img>//大图，用于产品详情
//<img_thum>product_img_thum.jpg</img_thum>//缩略图，用于产品列表
//30004 修改商品
-(void)updateProductWithId:(NSString*)proid
                      name:(NSString*)pname
                     price:(NSString*)price
                     intro:(NSString*)intro
                    brecom:(BOOL)brecom
                       img:(NSString*)img
                  img_thum:(NSString*)img_thum;


//请求橱窗
-(void)request30001WithID:(NSString*)userid;



//查找商品	0x00030006	<msgbody>
//<userid/>//用户id
//<keyword/> //关键词
//</msgbody>
-(void)request30006withID:(NSString*)userid
                  keyword:(NSString*)keyword;



//30007 请求商品详情
-(void)request30007WithProID:(NSString*)product_id;

//30010，评论商品
-(void)submitProductComment:(NSString *)comments productId:(int)product_id;

//30011,获取商品评论
-(void)requestProductCommentsWithProID:(int)product_id start:(int)comment_start end:(int)comment_end;

@end
