//
//  PushManager.h
//  FDS
//
//  Created by zhuozhong on 14-1-22.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "FDSUserCenterMessageManager.h"
#import "PlatformMessageManager.h"
#import "ZZSessionManager.h"

#import "EGOImageLoader.h"
@interface FDSPushManager : NSObject<PlateformMessageInterface>

+ (FDSPushManager *)sharePushManager;

@end
