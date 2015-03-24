//
//  SignatureView.m
//  BGProject
//
//  Created by liao on 14-12-1.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "SignatureView.h"
#import "NSString+TL.h"
#define kMargin 10
#define kSignatureFont [UIFont systemFontOfSize:13.0]
#define kCenterY self.frame.size.height*0.5

@interface SignatureView()

/**
 *  签名标签
 */
@property (nonatomic, weak) UILabel *titleLabel;
/**
 *  签名
 */
@property (nonatomic, weak) UILabel *signatureLab;

@end

@implementation SignatureView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        //签名
        UILabel *signatureLab = [[UILabel alloc] init];
        signatureLab.font = kSignatureFont;
        signatureLab.textColor = [UIColor grayColor];
        [self addSubview:signatureLab];
        self.signatureLab = signatureLab;
        
        self.user = [[BGUser alloc] init];
        
        
    }
    return self;
}

-(void)layoutSubviews{
    
    //标题
    self.titleLabel.text =@"个性签名";
    CGFloat titleLabelX = kMargin;
    CGFloat titleLabelY = 22;
    CGSize titleLabelSize = [NSString sizeWithText:@"个性签名" font:kSignatureFont maxSize:CGSizeMake(100, 1000)];
    self.titleLabel.frame = (CGRect){{titleLabelX,titleLabelY},titleLabelSize};
    
    
    //个性签名
    self.signatureLab.text = _user.signature;
    CGFloat signatureX = CGRectGetMaxX(self.titleLabel.frame)+kMargin*3;
    CGFloat signatureY = 22;
    CGFloat signatureMaxW = self.frame.size.width-signatureX-kMargin;
    CGSize signatureSize = [NSString sizeWithText:_user.signature font:kSignatureFont maxSize:CGSizeMake(signatureMaxW, 20)];
    self.signatureLab.frame = (CGRect){{signatureX,signatureY},signatureSize};
    
}

@end
