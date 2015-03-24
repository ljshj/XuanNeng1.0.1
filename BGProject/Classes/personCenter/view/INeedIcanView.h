//
//  INeedIcanView.h
//  BGProject
//
//  Created by liao on 14-12-1.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGUser.h"

// 定义评论类型
typedef enum {
    TypeINeed,
    TypeICan,
}Type;

@interface INeedIcanView : UIView

@property(nonatomic,strong) BGUser *user;
/**
 *  我能／我想
 */
@property (assign,nonatomic) Type type;

@end
