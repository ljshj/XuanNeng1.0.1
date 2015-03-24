//
//  UserCardViewController.h
//  BGProject
//
//  Created by zhuozhongkeji on 14-9-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZViewController.h"
@interface UserCardViewController : ZZViewController
{
    BOOL isSelf;
}
@property(nonatomic,retain)NSString *m_userID;
-(void)initViews;
@end
