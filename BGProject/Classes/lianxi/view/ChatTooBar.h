//
//  ChatTooBar.h
//  BGProject
//
//  Created by liao on 14-12-17.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatTooBarDelegate <NSObject>

@optional

/**
 *键盘发送按钮被点击
 */
-(void)didSendMessage:(NSString *)text;
/**
 *表情按钮被点击
 */
-(void)didClickFaceButtonWithStaus:(BOOL)isSelected;
/**
 *录音按钮长按回调
 */
-(void)didClickRecordButtonWithStaus:(BOOL)isBeginRecord;
/**
 *更多按钮回调
 */
-(void)didClickMoreButtonWithStaus:(BOOL)isSelected;
/**
 *取消录制语音
 */
-(void)didCancelRecord;


@end

@interface ChatTooBar : UIView

/**
 *输入框
 */
@property (nonatomic, weak) UITextView *inputView;
/**
 *记录输入了多少个字符
 */
@property (nonatomic, assign) CGFloat inputStrLength;

@property(weak,nonatomic) id<ChatTooBarDelegate>delegate;

/**
 *清空文本，设置占位文本
 */
-(void)clearInputViewText;
/**
 *仅仅设置占位文本
 */
-(void)setupPlaceholder;
/**
 *清除占位文本
 */
-(void)clearInputViewPlaceholder;

@end
