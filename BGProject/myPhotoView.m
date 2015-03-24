//
//  myPhotoView.m
//  BGProject
//
//  Created by zhuozhong on 14-8-4.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "myPhotoView.h"

@implementation myPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = YES;
        for (int i = 0; i < 3; i++)
        {
            for (int  j = 0 ; j < 3; j++)
            {
                UIImageView *imgView =[[UIImageView alloc]initWithFrame:CGRectMake(100*i, 100*j, 90, 90)];
                imgView.image = [UIImage imageNamed:@"3"];
                imgView.tag = 100+3*i+j;
                imgView.userInteractionEnabled = YES;
                [self addSubview:imgView ];
            }
        }
    }
    return self;
}

- (void)setNumOfPage:(int)numOfPage
{
    _numOfPage = numOfPage;
    NSLog(@"_numOfPage is %d",_numOfPage);
    
    // 复用问题
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            UIView * v = self.subviews[3*i+j];
            
            if (v.tag < 100+_numOfPage)
            {
                // 复原
                v.frame = CGRectMake(100*j, 100*i, 90, 90);
            }
            else
            {
                v.frame = CGRectZero;
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
