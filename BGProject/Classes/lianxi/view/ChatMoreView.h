//
//  ChatMoreView.h
//  BGProject
//
//  Created by liao on 14-12-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatMoreViewDelegate <NSObject>

@optional
/**
 *更多按钮回调
 */
-(void)didClickPhotoButton;


@end

@interface ChatMoreView : UIView

@property(weak,nonatomic) id<ChatMoreViewDelegate>delegate;

@end
