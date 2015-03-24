//
//  StatusImageListView.h
//  weibo
//
//  Created by apple on 13-9-3.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  展示多张配图

#import <UIKit/UIKit.h>

@interface StatusImageListView : UIView

@property (nonatomic, strong) NSArray *imageUrls;

+ (CGSize)imageSizeWithCount:(int)count;

@end