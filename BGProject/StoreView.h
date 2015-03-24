//
//  StoreView.h
//  BGProject
//
//  Created by zhuozhong on 14-10-10.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChuChuangModel.h"


//在 我的橱窗中 显示在卷云 和tableView 之间的自定义View
// 负责显示 背景色 商店的icon， 店名,好评、产品推荐等。　ばか、困ったな。
@class StoreView;

@protocol StoreViewDelegate <NSObject>

// 脑残了一把，尽然用字符串作为逻辑判断
//-(void)storeView:(StoreView*)store buttonClick:(NSString*)buttonTitle;

-(void)storeView:(StoreView*)store buttonClick:(UIButton*)button;
@end


@interface StoreView : UIImageView


//设置风格。修改上部分的3/5的颜色
-(void)setSytle:(UIColor*)color;

@property(nonatomic,weak)id<StoreViewDelegate> delegate;

-(void)showInfo:(ChuChuangModel*)model;


-(void)removeAllButtonSelectedState;
@end
