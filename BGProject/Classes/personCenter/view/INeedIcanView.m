//
//  INeedIcanView.m
//  BGProject
//
//  Created by liao on 14-12-1.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "INeedIcanView.h"
#import "NSString+TL.h"

#define kMargin 10
#define kTextFont [UIFont systemFontOfSize:13.0]

@interface INeedIcanView()
/**
 *  图片
 */
@property (nonatomic, weak) UIImageView *iconView;
/**
 *  标签
 */
@property (nonatomic, weak) UILabel *textLabel;

@end
@implementation INeedIcanView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        //图片
        UIImageView *iconView = [[UIImageView alloc] init];
        [self addSubview:iconView];
        self.iconView = iconView;
        
        //文本
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = kTextFont;
        textLabel.numberOfLines = 0;
        textLabel.textColor = [UIColor grayColor];
        [self addSubview:textLabel];
        self.textLabel = textLabel;
        
        self.user = [[BGUser alloc] init];
        
    }
    return self;
}

-(void)setUser:(BGUser *)user{
    
    _user = user;
    
    
    
}


-(void)layoutSubviews{
    
    if (self.type==TypeINeed) {
        
        self.iconView.image = [UIImage imageNamed:@"imiss"];
        self.textLabel.text = _user.ineed;
        
    }else{
        
        self.iconView.image = [UIImage imageNamed:@"ican"];
        self.textLabel.text = _user.ican;
        
    }
    
    //图标
    CGFloat iconViewX = kMargin;
    CGFloat iconViewY = kMargin;
    CGFloat iconViewW = self.iconView.image.size.width;
    CGFloat iconViewH = self.iconView.image.size.height;
    self.iconView.frame = CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH);
    
    //内容
    CGFloat textLabelX = CGRectGetMaxX(self.iconView.frame)+kMargin;
    CGFloat textLabelY = kMargin;
    CGFloat textLabelMaxW = self.frame.size.width-textLabelX-kMargin;
    CGSize textLabelSize = [NSString sizeWithText:self.textLabel.text font:kTextFont maxSize:CGSizeMake(textLabelMaxW, 40)];
    self.textLabel.frame = (CGRect){{textLabelX,textLabelY},textLabelSize};
    
}

@end
