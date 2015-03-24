//
//  UIAlertView+Zhangxx.m
//  BGProject
//
//  Created by ssm on 14-9-13.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "UIAlertView+Zhangxx.h"

@implementation UIAlertView (Zhangxx)

+(void)showMessage:(NSString*)msg {
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
