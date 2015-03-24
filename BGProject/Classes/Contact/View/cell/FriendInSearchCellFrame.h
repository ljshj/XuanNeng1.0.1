//
//  FriendInSearchCellFrame.h
//  BGProject
//
//  Created by ssm on 14-9-22.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//  控制 FriendInSearchCell 的各个子控件的位置

#import <Foundation/Foundation.h>
#import "FriendModel.h"


#define kFriendInSearchBigFont [UIFont boldSystemFontOfSize:16]
#define kFrinedInsarchSmallFont [UIFont systemFontOfSize:10]



// 这个类用来计算出各个cell中子控件的位置。和要显示的内容
@interface FriendInSearchCellFrame : NSObject

//好友模型
@property(nonatomic,retain)FriendModel* friendModel;

//距离图标
@property(nonatomic,assign)CGRect distanceTagFrame;

//距离
@property(nonatomic,assign)CGRect distanceFrame;

//我能
@property(nonatomic,assign)CGRect icanFrame;

//头像
@property(nonatomic,assign)CGRect imgFrame;

//我想
@property(nonatomic,assign)CGRect ineedFrame;

//等级
@property(nonatomic,assign)CGRect levelFrame;

//昵称
@property(nonatomic,assign)CGRect nameFrame;

//性别
@property(nonatomic,assign)CGRect sexImageFrame;

//个性签名
@property(nonatomic,assign)CGRect signatrueFrame;

//添加按钮
@property(nonatomic,assign)CGRect addButtonFrame;

//cell的高度
@property(nonatomic,assign)CGFloat cellHeight;

@end
