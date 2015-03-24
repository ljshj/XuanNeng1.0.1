//
//  ProductTableViewCell.m
//  BGProject
//
//  Created by liao on 14-10-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ProductTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+TL.h"
#import "TLProductModel.h"
#define kPriceTextColor [UIColor colorWithRed:231/255.0 green:64/255.0 blue:28/255.0 alpha:1.0]

@implementation ProductTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(TLProductModel *)model{
    _model = model;
    
    [_myImageView setImageWithURL:[NSURL URLWithString:[NSString setupSileServerAddressWithUrl:model.img]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    _titleLabel.numberOfLines = 2;
    
    _titleLabel.text = model.title;
    
    _priceLabel.text = model.price;
    _priceLabel.textColor = kPriceTextColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
