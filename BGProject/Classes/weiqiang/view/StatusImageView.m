//
//  StatusImageView.m
//  weibo
//
//  Created by apple on 13-9-3.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "StatusImageView.h"
#import "UIImageView+WebCache.h"

@interface StatusImageView()
{
    // gif标识
    UIImageView *_gifView;
}
@end

@implementation StatusImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // gif标识
        _gifView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_image_gif.png"]];
        
        // 左边间距和顶部间距都是固定
        //_gifView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        
        [self addSubview:_gifView];
    }
    return self;
}

- (void)setUrl:(NSString *)url
{
    _url = url;
    
    // 1.下载图片
    [self setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder.png"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
    
    // 2.控制是否显示gif
    if([url hasSuffix:@"gif"]) {
        _gifView.hidden = NO;
        
        CGSize size = self.frame.size;
        CGSize gifSize = _gifView.frame.size;
        
        _gifView.center = CGPointMake(size.width - gifSize.width * 0.5, size.height - gifSize.height * 0.5);
        
    } else {
        _gifView.hidden = YES;
    }
}

@end
