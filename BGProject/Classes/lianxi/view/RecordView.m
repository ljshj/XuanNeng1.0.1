//
//  RecordView.m
//  BGProject
//
//  Created by liao on 14-12-19.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "RecordView.h"

@implementation RecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
        
    }
    return self;
}

-(void)layoutSubviews{
    
    //话筒
    UIImageView *micView = [[UIImageView alloc] init];
    micView.image = [UIImage imageNamed:@"record"];
    CGFloat micViewX = 22.5;
    CGFloat micViewY = 0;
    CGFloat micViewW = self.frame.size.width-2*micViewX;
    CGFloat micViewH = self.frame.size.height*0.7;
    micView.frame = CGRectMake(micViewX, micViewY, micViewW, micViewH);
    micView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:micView];
    
    //标签
    UILabel *cancelLabel = [[UILabel alloc] init];
    CGFloat cancelX = 0;
    CGFloat cancelY = CGRectGetMaxY(micView.frame);
    CGFloat cancelW = self.frame.size.width;
    CGFloat cancelH = self.frame.size.height*0.3;
    cancelLabel.textAlignment = NSTextAlignmentCenter;
    cancelLabel.font = [UIFont systemFontOfSize:11.0];
    cancelLabel.textColor = [UIColor whiteColor];
    cancelLabel.text = @"手指上滑，取消发送";
    cancelLabel.frame = CGRectMake(cancelX, cancelY, cancelW, cancelH);
    [self addSubview:cancelLabel];
    
    
    
}

@end
