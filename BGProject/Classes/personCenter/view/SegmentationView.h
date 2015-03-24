//
//  SegmentationView.h
//  BGProject
//
//  Created by liao on 14-12-1.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGUser.h"
#define SetupFocusButtonStausKey @"SetupFocusButtonStaus"

@protocol BGSegmentationViewDelegate <NSObject>

@optional

-(void)didSelectedButtonWithIndex:(NSInteger)index;
-(void)didSelectedButtonWithIndex:(NSInteger)index staus:(BOOL)selected;
@end

@interface SegmentationView : UIView

@property(weak,nonatomic) id<BGSegmentationViewDelegate>delegate;
/**
 *是否是好友
 */
@property(assign,nonatomic) BOOL isFriend;
/**
 *是否已经关注
 */
@property(assign,nonatomic) BOOL isguanzhu;
@end
