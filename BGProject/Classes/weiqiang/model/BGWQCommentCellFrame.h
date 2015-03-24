//
//  BGWQCommentCellFrame.h
//  BGProject
//
//  Created by liao on 14-11-4.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGWQCommentModel.h"

//间距
#define kCommentCellMargin 10
//头像的宽高
#define kPhotoHW 40
//昵称字体
#define TLNameFont [UIFont systemFontOfSize:12]
//时间字体
#define TLTimeFont [UIFont systemFontOfSize:11]
//内容字体
#define TLContentFont [UIFont systemFontOfSize:13]

@interface BGWQCommentCellFrame : NSObject

@property(nonatomic,retain)BGWQCommentModel* model;

//图片
@property(assign,nonatomic)CGRect photoFrame;
//昵称
@property(assign,nonatomic)CGRect nameFrame;
//日期
@property(assign,nonatomic)CGRect timeFrame;
//评论内容
@property(assign,nonatomic)CGRect contentFrame;
//分割线
@property(assign,nonatomic)CGRect dividerFrame;
//cell的高度
@property(assign,nonatomic)CGFloat cellHight;


-(id)initWithModel:(BGWQCommentModel*)model;

@end
