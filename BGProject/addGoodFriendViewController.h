//
//  addGoodFriendViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-23.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlatformMessageManager.h"
@interface addGoodFriendViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)NSArray * friends;

@end
