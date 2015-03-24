//
//  myStoreViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//  我的橱窗

#import <UIKit/UIKit.h>
#import "ChuChuangModel.h"

//定义橱窗类型
typedef enum {
    StoreTypeMy,
    StoreTypeOther,
}StoreType;

@interface myStoreViewController : UIViewController<UITextFieldDelegate>


@property(nonatomic,retain)UIColor* mainColor;//设置主题背景色(风格颜色设置)
@property(nonatomic,strong)ChuChuangModel* model;
@property(nonatomic,copy) NSString *userid;
@property(nonatomic,assign)BOOL needRefreshView;//是否需要重新加载数据，刷新页面
/**
 *定义橱窗类型
 */
@property (assign,nonatomic) StoreType storeType;

@end
