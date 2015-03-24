//
//  RecomProductFrame.h
//  BGProject
//
//  Created by liao on 14-11-19.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecomProductModel.h"

@interface RecomProductFrame : NSObject

@property(strong,nonatomic)RecomProductModel* model;
@property(assign,nonatomic)CGRect dateFrame;
@property(assign,nonatomic)CGRect dateIconFrame;
@property(assign,nonatomic)CGRect imgFrame;
@property(assign,nonatomic)CGRect priceFrame;
@property(assign,nonatomic)CGRect nameFrame;
@property(assign,nonatomic)CGRect recomTagFrame;
@property(strong,nonatomic) UIImage *image;
@property(assign,nonatomic)CGFloat cellHight;

@end
