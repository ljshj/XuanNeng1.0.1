//
//  GroupMemberView.h
//  BGProject
//
//  Created by liao on 14-12-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//  群成员头像列表

#import <UIKit/UIKit.h>

#define GroupMemberViewH IconViewHW+IconMargin*2
#define IconViewHW 40
#define IconMargin 10

@interface GroupMemberView : UIView

- (instancetype)initWithMembers:(NSArray *)members;

@end
