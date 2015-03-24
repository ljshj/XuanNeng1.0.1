//
//  PublicMessageManager.h
//  BGProject
//
//  Created by zhuozhongkeji on 14-9-16.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ZZMessageManager.h"
#import "PublicMessageInterface.h"
#import "ZZSessionManager.h"
@interface PublicMessageManager : ZZMessageManager
+ (PublicMessageManager*)sharedManager;
- (void)registerObserver:(id<PublicMessageInterface>)observer;
- (void)unRegisterObserver:(id<PublicMessageInterface>)observer;


-(void)sendMessage:(NSMutableDictionary *)message;

//检查软件升级
-(void)checkLastVersion:(NSString*)version;
@end
