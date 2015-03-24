//
//  NewFeatureViewController.h
//  BGProject
//
//  Created by liao on 15-1-22.
//  Copyright (c) 2015年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) 

@interface NewFeatureViewController : UIViewController

@end
