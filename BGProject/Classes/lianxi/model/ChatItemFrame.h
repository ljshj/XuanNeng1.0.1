//
//  ChatItemFrame.h
//  BGProject
//
//  Created by liao on 14-12-15.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatItem.h"

@interface ChatItemFrame : NSObject

@property(strong,nonatomic) ChatItem *item;

//左边头像
@property(nonatomic,assign) CGRect leftIconFrame;

//右边头像
@property(nonatomic,assign) CGRect rightIconFrame;

//右边标签
@property(nonatomic,assign) CGRect rightLabelFrame;

//右边气泡
@property(nonatomic,assign) CGRect rightBubbleFrame;

//左边标签
@property(nonatomic,assign) CGRect leftLabelFrame;

//左边气泡
@property(nonatomic,assign) CGRect leftBubbleFrame;

//左边预览图
@property(nonatomic,assign) CGRect leftThumFrame;

//右边预览图
@property(nonatomic,assign) CGRect rightThumFrame;

//左边语音按钮
@property(nonatomic,assign) CGRect leftVoiceFrame;

//右边语音按钮
@property(nonatomic,assign) CGRect rightVoiceFrame;

//cell高度
@property(nonatomic,assign) CGFloat cellHeight;


-(instancetype)initWithChatItem:(ChatItem*)item;

@end
