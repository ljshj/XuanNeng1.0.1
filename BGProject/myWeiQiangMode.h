//
//  myWeiQiangMode.h
//  BGProject
//
//  Created by zhuozhong on 14-8-4.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myWeiQiangMode : NSObject

@property (nonatomic,copy) UIImage  *image;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString *destence;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString * contentStr;
@property (nonatomic,strong) NSMutableArray * imgArr;

@property (nonatomic,assign,readonly) CGSize contentSize;
@property (nonatomic,assign,readonly) CGFloat imgHeight;

@end
