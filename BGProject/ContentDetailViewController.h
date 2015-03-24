//
//  ContentDetailViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-10-15.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//
// 为了显示各类详情信息：炫能详情 微博详情等
#import <UIKit/UIKit.h>
#import "JokeModel.h"

//定义控制器请求详情类型（评论／刷新）
typedef enum {
    RequestJokeDetailTypeNormal,
    RequestJokeDetailTypeComment,
    RequestJokeDetailTypeRefresh,
}RequestJokeDetailType;

@interface ContentDetailViewController : UIViewController

@property (assign,nonatomic)CGFloat viewAtY; // 方便子控件布局
@property (nonatomic,strong) JokeModel *model;
/**
 *评论列表
 */
@property(nonatomic,strong) NSMutableArray *commentsArray;
/**
 *请求类型(评论／刷新)
 */
@property(nonatomic,assign) RequestJokeDetailType requestJokeDetailType;
-(void)resetTitle:(NSString*)title;

@end
