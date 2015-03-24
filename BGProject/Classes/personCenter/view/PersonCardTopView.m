//
//  PersonCardTopView.m
//  BGProject
//
//  Created by liao on 14-12-1.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "PersonCardTopView.h"
#import "UIImageView+WebCache.h"
#import "NSString+TL.h"

#define kNameFont [UIFont boldSystemFontOfSize:17.0]
#define kNumFont [UIFont boldSystemFontOfSize:13.0]
#define kBackGroundColor [UIColor colorWithRed:104/255.0 green:186/255.0 blue:252/255.0 alpha:1.0]
#define kMargin 10

@interface PersonCardTopView()
/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *photoView;
/**
 *  昵称
 */
@property (nonatomic, weak) UILabel *nameLabel;
/**
 *  性别图标
 */
@property (nonatomic, weak) UIImageView *sexView;
/**
 *  能能号
 */
@property (nonatomic, weak) UILabel *numLabel;

@end

@implementation PersonCardTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        //背景颜色
        self.backgroundColor = kBackGroundColor;
        
        //头像
        UIImageView *photoView = [[UIImageView alloc] init];
        [self addSubview:photoView];
        self.photoView = photoView;
        
        //名字
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = kNameFont;
        nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        //性别
        UIImageView *sexView = [[UIImageView alloc] init];
        [self addSubview:sexView];
        self.sexView=sexView;
        
        //能能号
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.textColor = [UIColor whiteColor];
        numLabel.font = kNumFont;
        [self addSubview:numLabel];
        self.numLabel = numLabel;
        
        self.user = [[BGUser alloc] init];
        
    }
    return self;
}

-(void)layoutSubviews{
    
    //头像
    [self.photoView setImageWithURL:[NSURL URLWithString:[NSString setupSileServerAddressWithUrl:_user.photo]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    CGFloat photoViewX = kMargin;
    CGFloat photoViewY = kMargin;
    CGFloat photoViewW = 80;
    CGFloat photoViewH = 80;
    //设置头像的圆角
    self.photoView.layer.borderWidth = 2.0;
    self.photoView.layer.borderColor = [UIColor whiteColor].CGColor;
    CGFloat radius = self.photoView.bounds.size.width*0.5;
    [self.photoView.layer setCornerRadius:radius];
    [self.photoView.layer setMasksToBounds:YES];
    self.photoView.frame = CGRectMake(photoViewX, photoViewY, photoViewW, photoViewH);
    
    //昵称
    self.nameLabel.text = _user.nickn;
    CGFloat nameLabelX = CGRectGetMaxX(self.photoView.frame)+kMargin;
    CGFloat nameLabelY = photoViewY+15;
    CGSize nameSize = [NSString sizeWithText:_user.nickn font:kNameFont maxSize:CGSizeMake(self.bounds.size.width-nameLabelX, 1000)];
    self.nameLabel.frame = (CGRect){{nameLabelX,nameLabelY},nameSize};
    
    //设置性别图片
    [self setSexViewImage];
    CGFloat sexViewX = CGRectGetMaxX(self.nameLabel.frame)+kMargin;
    CGFloat sexViewY = nameLabelY+3;
    CGFloat sexViewW = self.sexView.image.size.width*0.8;
    CGFloat sexViewH = self.sexView.image.size.height*0.8;
    self.sexView.frame = CGRectMake(sexViewX, sexViewY, sexViewW, sexViewH);
    
    //能能号
    NSString *num = [NSString stringWithFormat:@"能能号:%@",_user.userName];
    self.numLabel.text = num;
    CGFloat numLabelX = nameLabelX;
    CGFloat numLabelY = CGRectGetMaxY(self.nameLabel.frame)+kMargin;
    CGSize numSize = [NSString sizeWithText:num font:kNumFont maxSize:CGSizeMake(self.bounds.size.width-nameLabelX, 1000)];
    self.numLabel.frame = (CGRect){{numLabelX,numLabelY},numSize};
    
    
}


-(void)setSexViewImage{
    
    //性别
    int sexCode = [_user.sex intValue];
    UIImage* sexImg = nil;
    //女
    if(sexCode==0) {
        sexImg = [UIImage imageNamed:@"女"];
    }
    // 男
    if(sexCode==1) {
        sexImg = [UIImage imageNamed:@"男"];
    }
    //保密
    if(sexCode==2) {
        
        sexImg = nil;
        
    }
    _sexView.image = sexImg;
    
    
}

@end
