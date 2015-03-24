//
//  MemberCellFrame.h
//  BGProject
//
//  Created by ssm on 14-10-8.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberModel.h"

#define kFriendInSearchBigFont [UIFont systemFontOfSize:13]
#define kFrinedInsarchSmallFont [UIFont systemFontOfSize:10]
// 这个类用来计算出各个cell中子控件的位置。和要显示的内容
@interface MemberCellFrame : NSObject


@property(nonatomic,retain)MemberModel* model;

@property(nonatomic,assign)CGRect distanceTagFrame;// 距离文字左边的小图
@property(nonatomic,assign)CGRect distanceFrame;
@property(nonatomic,assign)CGRect icanFrame;
@property(nonatomic,assign)CGRect imgFrame;
@property(nonatomic,assign)CGRect ineedFrame;
@property(nonatomic,assign)CGRect levelFrame;
@property(nonatomic,assign)CGRect nameFrame;
@property(nonatomic,assign)CGRect sexImageFrame;
@property(nonatomic,assign)CGRect signatrueFrame;

@property(nonatomic,assign)CGFloat cellHeight;//整个单元格的高度

@end
