//
//  PersonlHeaderView.h
//  BGProject
//
//  Created by liao on 14-12-2.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SetupFocusButtonStausKey @"SetupFocusButtonStaus"

@protocol PersonlHeaderViewDelegate <NSObject>

@optional
/**
 *立即关注按钮被点击
 */
-(void)didClickFocusButtonWithUserid:(NSString *)userid buttonStaus:(BOOL)selected;
/**
 *添加好友按钮被点击
 */
-(void)didSelectedPersonlHeaderButtonWithUsername:(NSString *)username;
/**
 *发起会话按钮回调
 */
-(void)didSelectedPersonlHeaderButtonWithUsername:(NSString *)username photo:(NSString *)photo isFriend:(BOOL)isFriend nickn:(NSString *)nickn;
@end

@interface PersonlHeaderView : UIView

@property(nonatomic,strong) NSDictionary *userDic;
/**
 *代理
 */
@property(weak,nonatomic) id<PersonlHeaderViewDelegate>delegate;
@end
