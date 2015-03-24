//
//  GroupExitAndClearView.h
//  BGProject
//
//  Created by liao on 14-12-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//  退出群和清除聊天记录

#import <UIKit/UIKit.h>

@protocol GroupExitAndClearViewDelegate <NSObject>

@optional

/**
 *清除按钮被点击
 */
-(void)didClickClearButton;
/**
 *退出按钮被点击
 */
-(void)didClickExitButton;

@end

@interface GroupExitAndClearView : UIView

@property(weak,nonatomic) id<GroupExitAndClearViewDelegate>delegate;
/**
 *是否是群主
 */
@property(nonatomic,assign) BOOL isGroupOwer;

@end
