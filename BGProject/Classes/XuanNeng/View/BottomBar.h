//
//  ButtonsView.h
//  FOURBUTTON
//
//  Created by ssm on 14-9-26.
//  Copyright (c) 2014年 com.ssm. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BottomBar;
@protocol BottomBarDelegate <NSObject>

@optional
// 方便父控件监控到该bottomBar被当单击的按钮
-(void)bottomBar:(BottomBar*)bar
didClickButtonAtIndex:(NSInteger)index;


@end

//
@interface BottomBar : UIView

@property(nonatomic,weak)id<BottomBarDelegate> delegate;


-(void)addButtonWithIcon:(NSString*)icon
                   title:(NSString*)title;


-(void)setText:(NSString*)text AtIndex:(int)index;


@end
