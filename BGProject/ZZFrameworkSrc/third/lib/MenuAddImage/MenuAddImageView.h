//
//  MenuAddImageView.h
//  FDS
//
//  Created by saibaqiao on 14-3-15.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGUploadImageView.h"

@protocol MenuAddBtnDelegate <NSObject>

@optional
- (void)didSelectImagePicker;

@end

@interface MenuAddImageView : UIView<BGUploadImageViewDelegate>
{
    
    UIScrollView   *scrollView;//滑动视图干嘛用的？
    UIButton       *addButton;//添加按钮，应该是那个＋号
    NSInteger      spaceWidth;//什么宽度？
}

@property(nonatomic,retain) NSMutableArray   *imageList;
@property(nonatomic,assign) id<MenuAddBtnDelegate> delegate;
@property(nonatomic,assign) UIScrollView *myScrollView;

- (id)initWithFrame:(CGRect)frame :(NSInteger)space;

/*  添加一张图片 */
- (void)handleImageAdd:(UIImage*)image :(NSData*)imageData;

@end
