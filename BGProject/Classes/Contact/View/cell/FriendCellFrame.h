//
//  FriendCellFrame.h
//  BGProject
//
//  Created by ssm on 14-8-19.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

// sex 图标的size
#define kSexSize CGSizeMake(26, 26)
// vip 图标的size
//#define vipSize

#import "BaseCellFrame.h"

// 计算各个控件的位置
@interface FriendCellFrame : BaseCellFrame

@property(nonatomic,assign)CGRect sexFrame;

//@property(nonatomic,assign)CGRect vipFrame;

@end
