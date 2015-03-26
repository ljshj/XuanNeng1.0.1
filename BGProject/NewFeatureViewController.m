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

@implementation NewFeatureViewController{
    
    UIImageView *_rightImageView;
    UIImageView *_leftImageView;
    UIView *_backView;
    UIImageView *_waitView;
}

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
        
        UIImageView *imageView = nil;
        
        if (index==IWNewfeatureImageCount-1) {
            
            _backView = [[UIView alloc] init];
            _backView.userInteractionEnabled = YES;
           
            _leftImageView = [[UIImageView alloc] init];
            NSString *leftname = [NSString stringWithFormat:@"new_feature_%d_left", index + 1];
            
            _leftImageView.image = [UIImage imageWithImgName:leftname];
            
            _rightImageView = [[UIImageView alloc] init];
            NSString *rightname = [NSString stringWithFormat:@"new_feature_%d_right", index + 1];
            _rightImageView.image = [UIImage imageWithImgName:rightname];
            
            
        }else{
            
            imageView = [[UIImageView alloc] init];
            // 设置图片
            NSString *name = [NSString stringWithFormat:@"new_feature_%d", index + 1];
            imageView.image = [UIImage imageWithImgName:name];
            
        }
        
        
        if (index==IWNewfeatureImageCount-1) {
            
            CGFloat leftImageX = 0;
            _leftImageView.frame = CGRectMake(leftImageX, 0, imageW*0.5, imageH);
            
            CGFloat rightImageX = imageW*0.5;
            _rightImageView.frame = CGRectMake(rightImageX, 0, imageW*0.5, imageH);
            
            CGFloat backX = index * imageW;
            _backView.frame = CGRectMake(backX, 0, imageW, imageH);
            
        }else{
            
            // 设置frame
            CGFloat imageX = index * imageW;
            imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
            
        }
        
        // 在最后一个图片上面添加按钮
        if (index == IWNewfeatureImageCount - 1){
            
            [scrollView addSubview:_backView];
            
            [_backView addSubview:_leftImageView];
            [_backView addSubview:_rightImageView];
            
        }else{
            
            [scrollView addSubview:imageView];
            
        }
        
        // 在最后一个图片上面添加按钮
        if (index == IWNewfeatureImageCount - 1) {
            
            [scrollView bringSubviewToFront:_leftImageView];
            
            [self setupLastImageView:_leftImageView];
        }
    }
    
    // 3.设置滚动的内容尺寸
    scrollView.contentSize = CGSizeMake(imageW * IWNewfeatureImageCount, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    
    _waitView = [[UIImageView alloc] init];
    NSString *waitname = [NSString stringWithFormat:@"wait"];
    _waitView.image = [UIImage imageWithImgName:waitname];
    _waitView.frame = _backView.frame;
    _waitView.hidden = YES;
    [scrollView addSubview:_waitView];
    
    [scrollView sendSubviewToBack:_waitView];
    
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
    CGFloat startButtonW = 503*0.5;
    CGFloat startButtonX = (self.view.bounds.size.width-startButtonW)*0.5+5;
    CGFloat startButtonY = self.view.frame.size.height*0.65;
    CGFloat startButtonH = 89*0.5;
    startButton.frame = CGRectMake(startButtonX,startButtonY , startButtonW, startButtonH);
    [startButton addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:startButton];
    

}

/**
 *  开始微博
 */
- (void)start:(UIButton *)button
{
    
    button.hidden = YES;
    
    // 显示状态栏
    //[UIApplication sharedApplication].statusBarHidden = NO;
    
    __unsafe_unretained NewFeatureViewController *nv = self;
    
    [UIView animateWithDuration:2.0 animations:^{
        
        nv->_waitView.hidden = NO;
        nv->_waitView.alpha = 0.2;
        
        CGRect leftframe = _leftImageView.frame;
        leftframe.origin.x = leftframe.origin.x-leftframe.size.width;
        nv->_leftImageView.frame = leftframe;
        
        CGRect rightframe = _rightImageView.frame;
        rightframe.origin.x = rightframe.origin.x+rightframe.size.width;
        nv->_rightImageView.frame = rightframe;
        
    } completion:^(BOOL finished) {
        
        // 切换窗口的根控制器
        AppDelegate *appdelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
        self.view.window.rootViewController = appdelegate.tempTabBarController;
        
    }];
    
    
}

@end
