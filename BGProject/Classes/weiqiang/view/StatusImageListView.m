//
//  StatusImageListView.m
//  weibo
//
//  Created by apple on 13-9-3.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "StatusImageListView.h"
#import "StatusImageView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "NSString+TL.h"

#define kStatusOneImageWidth 120
#define kStatusOneImageHeight 120

#define kStatusImageWidth 80
#define kStatusImageHeight 80

#define kStatusImageMargin 10

@implementation StatusImageListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加9个StatusImageView
        for (int i = 0; i<9; i++) {
            StatusImageView *imageView = [[StatusImageView alloc] init];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            //添加手势
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
            [self addSubview:imageView];
        }
    }
    return self;
}
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    
    int count = [self.imageUrls count];
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        MJPhoto *photo = [[MJPhoto alloc] init];
        
        //第一个是添加按钮，所以i+1
        photo.srcImageView = self.subviews[i]; // 来源于哪个UIImageView
       NSURL *url =  [NSURL URLWithString:[NSString setupSileServerAddressWithUrl:self.imageUrls[i][@"img"]]];
        photo.url = url;
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}
- (void)setImageUrls:(NSArray *)imageUrls
{
    _imageUrls = imageUrls;
    
    NSInteger imageCount = imageUrls.count;
    NSInteger subCount = self.subviews.count;
    
    // 遍历所有的ImageView
    for (int i = 0; i<subCount;  i++) {
        // 1.取出i位置对应的图片控件
        StatusImageView *child = self.subviews[i];
        
        // 2.i位置对应的图片控件 没有 图片
        if (i >= imageCount) {
            child.hidden = YES;
        } else {
            child.hidden = NO;
            
            // 只有一张配图
            if (imageCount == 1) {
                child.frame = CGRectMake(0, 0, kStatusOneImageWidth, kStatusOneImageHeight);
                //不是这里的问题，是图片那边压到变形了，全都是正方形
                child.contentMode = UIViewContentModeScaleAspectFit;
            } else {
                // 3.设置frame
                int divide = (imageCount == 4) ? 2 : 3;
                
                // 列数
                int column = i%divide;
                // 行数
                int row = i/divide;
                // 很据列数和行数算出x、y
                int childX = column * (kStatusImageWidth + kStatusImageMargin);
                int childY = row * (kStatusImageHeight + kStatusImageMargin);
                child.frame = CGRectMake(childX, childY, kStatusImageWidth, kStatusImageHeight);
                
                child.contentMode = UIViewContentModeScaleToFill;
            }
            
            // 4.设置图片url
            NSString *img_thum = imageUrls[i][@"img_thum"];
            child.url = [NSString setupSileServerAddressWithUrl:img_thum];
        }
    }
}

// 200
// 14
// (200 + 14 -1)/14

+ (CGSize)imageSizeWithCount:(int)count
{
    if (count == 1) return CGSizeMake(kStatusOneImageWidth, kStatusOneImageHeight);
    
    // 1.总行数
    int rows = (count + 2)/3;
    
    // 2.总高度
    CGFloat height = rows * kStatusImageHeight + (rows - 1) * kStatusImageMargin;
    
    // 3.总列数
    int columns = (count>=3) ? 3 : count;
    
    // 4.总宽度
    CGFloat width = columns * kStatusImageWidth + (columns - 1) * kStatusImageMargin;
    
    return CGSizeMake(width, height);
}
@end