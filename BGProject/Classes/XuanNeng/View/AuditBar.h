//
//  AuditBar.h
//  BGProject
//
//  Created by liao on 15-3-13.
//  Copyright (c) 2015年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AuditBarDelegate <NSObject>

@optional

/**
 *按钮被点击
 */
-(void)didClickButtonAtIndex:(NSInteger)index;

@end

@interface AuditBar : UIView

@property(nonatomic,weak) id<AuditBarDelegate> delegate;

@end
