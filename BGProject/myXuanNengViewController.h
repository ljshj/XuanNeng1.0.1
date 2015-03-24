//
//  myXuanNengViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
// 定义炫能控制器的类型
typedef enum {
    XuanNengTypeMy,
    XuanNengTypeOther,
}XuanNengType;

@interface myXuanNengViewController : UIViewController

@property(nonatomic,copy) NSString *userid;
@property(assign,nonatomic) XuanNengType xuanNengType;

@end
