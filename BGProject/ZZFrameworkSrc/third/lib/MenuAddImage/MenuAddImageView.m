//
//  MenuAddImageView.m
//  FDS
//
//  Created by saibaqiao on 14-3-15.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "MenuAddImageView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "BGUploadImageView.h"

#define COLOR(R, G, B, A)  [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define kMSScreenWith CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define kMaxButtonCount  7



@implementation MenuAddImageView{
    NSInteger _maxButtonCount;
}


- (id)initWithFrame:(CGRect)frame :(NSInteger)space
{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//        _imageList = [[NSMutableArray alloc] init];
//        spaceWidth = space;
//        [self menuAddViewInit];
//    }
//    return self;
   return  [self initWithFrame:frame :space withMaxCount:kMaxButtonCount];
}


- (id)initWithFrame:(CGRect)frame :(NSInteger)space withMaxCount:(NSInteger)count
{
    self = [super initWithFrame:frame];
    if (self) {
        // 这些东西都是干嘛用的？
        _imageList = [[NSMutableArray alloc] init];
        
        //spaceWidth：添加按钮的横坐标
        spaceWidth = space;
        
        //最多图片？？
        _maxButtonCount = count;
        
        //设置滑动视图和添加按钮
        [self menuAddViewInit];
    }
    return self;
}
- (void)menuAddViewInit
{
    //添加背景颜色
    self.backgroundColor = COLOR(225, 227, 226, 1);
    
    //设置scrollView
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 5, kMSScreenWith*4, self.frame.size.height-5*2)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    
    //设置添加按钮
    float width = 90;
    addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.tag = 1000;
    [addButton setFrame:CGRectMake(spaceWidth, 5, width, width)];
    [addButton addTarget:self action:@selector(btnAddImagePressed) forControlEvents:UIControlEventTouchUpInside];
    [addButton setBackgroundImage:[UIImage imageNamed:@"send_image_add"] forState:UIControlStateNormal];
    //addButton加在scrollView上面
    [scrollView addSubview:addButton];
    [self addSubview:scrollView];
    [scrollView release];
}

/*  点击添加 2014年10月13日 添加图片的回调*/
- (void)btnAddImagePressed
{
    if ([self.delegate  respondsToSelector:@selector(didSelectImagePicker)])
    {
        //跳到弹出框
        [self.delegate didSelectImagePicker];
    }
}

/*  添加一张图片 */
- (void)handleImageAdd:(UIImage*)image :(NSData*)imageData
{
    
    //取出图片数组的个数
    NSInteger btncount = [_imageList count];
    
    //设置大小
    CGFloat imageBtnX = 0;
    if (btncount == 0) {
        imageBtnX = spaceWidth;
    }else{
     imageBtnX = (10+90)*btncount+spaceWidth;
    }
    
    CGFloat imageBtnY = 5;
    CGFloat imageBtnW = 90;
    CGFloat imageBtnH = 90;
    BGUploadImageView *imageBtn = [[BGUploadImageView alloc] initWithFrame:CGRectMake(imageBtnX, imageBtnY, imageBtnW, imageBtnH)];
    
    //设置代理
    imageBtn.delegate = self;
    
    //开启交互
    imageBtn.userInteractionEnabled = YES;
    
    //设置标记
    imageBtn.tag = btncount;
    
    //这个图片选中的图片
    imageBtn.image = image;
    
    //添加图片
    [scrollView addSubview:imageBtn];
    
    //添加手势
    [imageBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
    [imageBtn release];
    
    //调整添加按钮的状态或者位置
    if (btncount > _maxButtonCount)
    {
        //如果添加的图片超过10张，将添加按钮隐藏起来
        addButton.hidden = YES;
    }
    else
    {
        //调整添加按钮的位置
        CGRect rect = addButton.frame;
        rect.origin.x += 10+90;
        addButton.frame = rect;
        
        //调整myScrollView的滑动范围
        CGFloat contentSizeW = CGRectGetMaxX(addButton.frame)+5;
        self.myScrollView.contentSize = CGSizeMake(contentSizeW, 110);
        
        //调整myScrollView的偏移量
        if (contentSizeW>310) {
            CGFloat contentOffsetX = contentSizeW-310;
            self.myScrollView.contentOffset = CGPointMake(contentOffsetX, 0);
        }
        
    }
    
    //将imageData二进制数据添加到数组_imageList里面
    [_imageList addObject:imageData];

}

//点击删除按钮回调
-(void)didSelectedDeleteButtonWithIndex:(NSInteger)index{
    for (UIView *view in scrollView.subviews) {
        if (view.tag == index) {
            
            [view removeFromSuperview];
            NSLog(@"%d被删除",view.tag);
            [_imageList removeObjectAtIndex:index];

            
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            if (view.tag == 1000) {
                CGRect addButtonF = view.frame;
                addButtonF.origin.x -= 10+90;
                addButton.frame = addButtonF;
            }
            
            if (view.tag>index && view.tag < 100) {
                view.tag -= 1;
                NSLog(@"调整后的tag值%d",view.tag);
                CGRect imageF = view.frame;
                imageF.origin.x -= 10+90;
                view.frame = imageF;
                CGFloat contentSizeW = CGRectGetMaxX(addButton.frame)+5;
                self.myScrollView.contentSize = CGSizeMake(contentSizeW, 110);
                
            }
        }];
        
        
    }
    
}


- (void)tapImage:(UITapGestureRecognizer *)tap
{
    
    int count = [_imageList count];
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        MJPhoto *photo = [[MJPhoto alloc] init];
        
        //第一个是添加按钮，所以i+1
        photo.srcImageView = scrollView.subviews[i+1]; // 来源于哪个UIImageView
        photo.image = ((UIImageView*)scrollView.subviews[i+1]).image;
        [photos addObject:photo];
        [photo release];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    [browser release];
}


- (void)dealloc
{
    [self.imageList removeAllObjects];
    self.imageList = nil;
    [super dealloc];
}

@end
