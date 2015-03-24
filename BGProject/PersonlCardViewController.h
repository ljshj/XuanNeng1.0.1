//
//  PersonlCardViewController.h
//  BGProject
//
//  Created by liao on 14-12-2.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//  个人名片

#import <UIKit/UIKit.h>

@interface PersonlCardViewController : UIViewController
/**
 *装有用户数据的字典
 */
@property(nonatomic,strong) NSDictionary *userDic;
/**
 *用户userid
 */
@property(nonatomic,copy) NSString *userid;

@end
