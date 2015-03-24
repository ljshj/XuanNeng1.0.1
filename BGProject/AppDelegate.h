//
//  AppDelegate.h
//  BGProject
//
//  Created by zhuozhong on 14-7-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSUserCenterMessageInterface.h"
#import "EaseMob.h"
#import "MoudleMessageManager.h"
#import <CoreLocation/CoreLocation.h>

//tabBarItem的高度
#define BTNHIGHT 50
//tabBarItem的宽度
#define BTNJIANGE 64
//存储用户状态的key
#define kUserName @"userLoginName"


@interface AppDelegate : UIResponder <UIApplicationDelegate,UserCenterMessageInterface,EMChatManagerDelegate,MoudleMessageInterface,CLLocationManagerDelegate>
/**
 *看程序是否进入前台
 */
@property(nonatomic,assign) BOOL isAppActive;
@property (strong, nonatomic) UIWindow *window;
@property(weak,nonatomic) UITabBarController *tempTabBarController;
//判断登录状态，set方法是isONload
@property (nonatomic,assign,setter = isONload:)BOOL isONload;
+(UIColor *)shareColor;

//将TableBar显示出来
-(void)showTableBar;

//将TableBar隐藏
-(void)hiddenTabelBar;


-(void)updateOnLoadStateWithUsername:(NSString*)userName;


//判断用户是否登录
-(BOOL)isUserlogin;

// 用户注销后，重新将个人中心和联系 设置为 根页面 登录页面
- (void)userLogoutCB:(NSString*)result; //用户注销

@end
