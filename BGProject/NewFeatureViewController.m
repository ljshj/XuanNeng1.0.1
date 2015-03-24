//
//  NewFeatureViewController.m
//  BGProject
//
//  Created by liao on 15-1-22.
//  Copyright (c) 2015年 zhuozhong. All rights reserved.
//

#import "NewFeatureViewController.h"
#import "AppDelegate.h"
#import "UIImage+TL.h"
#define IWNewfeatureImageCount 4

@interface NewFeatureViewController ()<UIScrollViewDelegate>

@end

@implementation NewFeatureViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupScrollView];
   
}

/**
 *  添加UISrollView
 */
- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    // 2.添加图片
    CGFloat imageW = scrollView.frame.size.width;
    CGFloat imageH = scrollView.frame.size.height;
    for (int index = 0; index<IWNewfeatureImageCount; index++) {
    
        UIImageView *imageView = [[UIImageView alloc] init];
        
        // 设置图片
        NSString *name = [NSString stringWithFormat:@"new_feature_%d", index + 1];
        imageView.image = [UIImage imageWithImgName:name];
        
        // 设置frame
        CGFloat imageX = index * imageW;
        imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
        
        [scrollView addSubview:imageView];
        
        // 在最后一个图片上面添加按钮
        if (index == IWNewfeatureImageCount - 1) {
            
            [self setupLastImageView:imageView];
            
        }
    }
    
    // 3.设置滚动的内容尺寸
    scrollView.contentSize = CGSizeMake(imageW * IWNewfeatureImageCount, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    
    
}

/**
 *  添加内容到最后一个图片
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    
    // 0.让imageView能跟用户交互
    imageView.userInteractionEnabled = YES;
    
    // 1.添加开始按钮
    UIButton *startButton = [[UIButton alloc] init];
    [startButton setBackgroundImage:[UIImage imageNamed:@"show"] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"show_selected"] forState:UIControlStateHighlighted];
    
    // 2.设置frame
    CGFloat startButtonW = 160*0.5;
    CGFloat startButtonX = (self.view.bounds.size.width-startButtonW)*0.5+5;
    CGFloat startButtonY = self.view.frame.size.height*0.82;
    CGFloat startButtonH = 58*0.5;
    startButton.frame = CGRectMake(startButtonX,startButtonY , startButtonW, startButtonH);
    [startButton addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startButton];
    

}

/**
 *  开始微博
 */
- (void)start:(UIButton *)button
{
    
    button.hidden = YES;
    
    // 显示状态栏
    //[UIApplication sharedApplication].statusBarHidden = NO;
    
    // 切换窗口的根控制器
    AppDelegate *appdelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.view.window.rootViewController = appdelegate.tempTabBarController;
    
}

@end
