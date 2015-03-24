//
//  UIImage+TL.m
//  BGTabBar-自定义
//
//  Created by liao on 14-10-10.
//  Copyright (c) 2014年 BangGu. All rights reserved.
//

#import "UIImage+TL.h"
#import "ZZSessionManager.h"

@implementation UIImage (TL)
+(UIImage *)resizeImageWithName:(NSString *)name{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
}
+(UIImage *)imageWithImgName:(NSString *)name{
    
    UIImage *img = nil;
    
    if (!iPhone5) {
        
        img = [UIImage imageNamed:[NSString stringWithFormat:@"%@_4",name]];
        
        
    }else{
        
        img = [UIImage imageNamed:name];
        
    }
    
    return img;
}

@end
