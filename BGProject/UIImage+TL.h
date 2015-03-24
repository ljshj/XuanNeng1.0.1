//
//  UIImage+TL.h
//  BGTabBar-自定义
//
//  Created by liao on 14-10-10.
//  Copyright (c) 2014年 BangGu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface UIImage (TL)
+(UIImage *)resizeImageWithName:(NSString *)name;
+(UIImage *)imageWithImgName:(NSString *)name;
@end
