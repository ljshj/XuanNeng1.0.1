//
//  Navgation.h
//  BGProject
//
//  Created by zhuozhongkeji on 14-9-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavigationDelete <NSObject>

-(void)buttonCallCB:(int)flag;

@end
@interface Navgation : UIView
@property(nonatomic,retain)id<NavigationDelete>m_delete;
-(void)initView:(NSString*)title;
-(void)initView:(NSString*)leftButton :(NSString*)title:(NSString*)rightButton;
@end
