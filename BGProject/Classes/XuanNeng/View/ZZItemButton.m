//
//  ZZItemButton.m
//  BGProject
//
//  Created by zhuozhong on 14-10-9.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ZZItemButton.h"

@implementation ZZItemButton


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    NSLog(@"titleRectForContentRect c rect:%@",NSStringFromCGRect(contentRect));
    
    return [super titleRectForContentRect:contentRect];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    NSLog(@"imageRectForContentRect c rect:%@",NSStringFromCGRect(contentRect));
    
    return [super titleRectForContentRect:contentRect];
}
@end
