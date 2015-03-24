//
//  AuditContentView.m
//  BGProject
//
//  Created by liao on 15-3-12.
//  Copyright (c) 2015年 zhuozhong. All rights reserved.
//

#import "AuditContentView.h"
#import "NSString+TL.h"
#import "StatusImageListView.h"

#define Margin 10

#define ContentFont [UIFont systemFontOfSize:15.0]

@interface AuditContentView ()

/**
 *正文
 */
@property (nonatomic, weak) UILabel *contentLab;
/**
 *图片列表
 */
@property (nonatomic, weak) StatusImageListView *statusImageListView;


@end

@implementation AuditContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        //正文
        UILabel *contentLab = [[UILabel alloc] init];
        contentLab.textColor = [UIColor blackColor];
        contentLab.numberOfLines = 0;
        contentLab.font = ContentFont;
        [self addSubview:contentLab];
        self.contentLab = contentLab;
        
        //图片列表
        StatusImageListView *statusImageListView = [[StatusImageListView alloc] init];
        [self addSubview:statusImageListView];
        self.statusImageListView = statusImageListView;
        
    }
    return self;
}

-(void)setModel:(JokeModel *)model{
    
    _model = model;
    
    //计算内容高度
    CGSize contentSize = [NSString sizeWithText:model.content font:ContentFont maxSize:CGSizeMake(self.frame.size.width-2*Margin, 1000)];
    self.contentLab.frame = CGRectMake(Margin, Margin, contentSize.width, contentSize.height);
    self.contentLab.text = model.content;
    
    //图片
    if (model.imgs) {
        
        self.statusImageListView.hidden = NO;
        CGSize imageListViewSize = [StatusImageListView imageSizeWithCount:(int)model.imgs.count];
        self.statusImageListView.frame = CGRectMake(self.contentLab.frame.origin.x, CGRectGetMaxY(self.contentLab.frame)+Margin, imageListViewSize.width, imageListViewSize.height);
        self.statusImageListView.imageUrls = model.imgs;
        
    }else{
        
        self.statusImageListView.hidden = YES;
        
    }
    
}

-(void)layoutSubviews{
    
    CGRect auditViewF = self.frame;
    
    if (self.model.imgs) {
    
        auditViewF.size.height = CGRectGetMaxY(self.statusImageListView.frame)+Margin;
        
    }else{
        
        auditViewF.size.height = CGRectGetMaxY(self.contentLab.frame)+Margin;
        
    }
    
    self.frame = auditViewF;
    
}

@end
