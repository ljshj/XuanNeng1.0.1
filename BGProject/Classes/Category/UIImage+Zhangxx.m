//
//  UIImage+Zhangxx.m
//  BGProject
//
//  Created by zhuozhong on 14-10-12.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "UIImage+Zhangxx.h"

@implementation UIImage (Zhangxx)

+ (UIImage *)imageNamedForResizeAble:(NSString *)name
{
    
    UIImage* rawImg = [UIImage imageNamed:name];
    
    CGSize imgSize = [rawImg size];
    
    CGFloat top = imgSize.height*0.5-1;
    CGFloat left = imgSize.width*0.5 -1;
    CGFloat bottom = imgSize.height*0.5;
    CGFloat right = imgSize.width*0.5;
    
    UIEdgeInsets inset = UIEdgeInsetsMake(top, left, bottom, right);
    
    //UIImageResizingModeTile 平铺被拉升的区域
    //UIImageResizingModeStretch：拉伸模式，通过拉伸UIEdgeInsets指定的矩形区域来填充图片
    UIImage* resizeImg = [rawImg resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeTile];
    return resizeImg;
}

@end
