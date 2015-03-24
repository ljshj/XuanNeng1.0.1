//
//  WeiQiangViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoudleMessageInterface.h"
#import "MoudleMessageManager.h"


// 定义评论类型
typedef enum {
    ButtonTypeAll,
    ButtonTypeAttention,
}ButtonType;

@interface WeiQiangViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MoudleMessageInterface>
/**
 *  被选中按钮的类型
 */
@property (assign,nonatomic) ButtonType buttonType;
/**
 *是否是手势触发的回调
 */
@property(nonatomic,assign) BOOL isTouchByTap;
/**
 *剪头按钮，弹出框
 */
@property(nonatomic,strong) UIButton *backBtn;
/**
 *弹出框按钮点击
 */
-(void)BackMainMenu:(UIButton *)sender;
/**
 *与我相关按钮被点击
 */
-(void)relatedToMe;
@end
