//
//  BGBadgeButton.m
//  BGTabBar-自定义
//
//  Created by liao on 14-10-10.
//  Copyright (c) 2014年 BangGu. All rights reserved.
//

#import "BGBadgeButton.h"
#import "UIImage+TL.h"

@implementation BGBadgeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.hidden = YES;
        [self setBackgroundImage:[UIImage resizeImageWithName:@"main_badge_os7"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:11.0];
    }
    return self;
}
-(void)setBadgeValue:(NSString *)badgeValue{
    
    //如果徽章大于99就不显示了，＋号表示
    if ([badgeValue intValue]>99) {
        
        badgeValue = [NSString stringWithFormat:@"99+"];
        
    }
    
    _badgeValue = [badgeValue copy];
    
    if (badgeValue) {
        // 设置文字
        [self setTitle:badgeValue forState:UIControlStateNormal];
        //设置 frame
        CGRect frame = self.frame;
        CGFloat badgeH = self.currentBackgroundImage.size.height;
        // 文字的尺寸
        CGFloat badgeW = self.currentBackgroundImage.size.width;
        if (badgeValue.length>1) {
            
         badgeW = [self badgeSizeWidthWithBadgeValue:badgeValue];
            
        }
        frame.size.width = badgeW;
        frame.size.height = badgeH;
        self.frame  = frame;
        self.hidden = NO;
    }else{
        self.hidden = YES;
    }
}
-(CGFloat)badgeSizeWidthWithBadgeValue:(NSString *)badgeValue{
    CGSize badgeSize = [badgeValue sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    return badgeSize.width+10;
}

@end
