//
//  MyAttentionCellFrame.h
//  BGProject
//
//  Created by ssm on 14-9-27.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FriendModel.h"
#define kIconHeight 60
#define kIconWidth kIconHeight

#define kBigSpace 25
#define kSpace    5 //控件之间的标准距离


#define kBigFont [UIFont systemFontOfSize:17]
#define KSmallFont [UIFont systemFontOfSize:13]



@interface MyAttentionCellFrame : NSObject



@property(nonatomic,retain)FriendModel* myAttentionPerson;

@property(nonatomic,assign)CGRect imgFrame;
@property(nonatomic,assign)CGRect nameFrame;
@property(nonatomic,assign)CGRect sexImageFrame;
@property(nonatomic,assign)CGRect levelFrame;
@property(nonatomic,assign)CGRect signatrueFrame;
@property(nonatomic,assign)CGRect attentionFrame;

@property(nonatomic,assign)CGFloat cellHeight;

@end
