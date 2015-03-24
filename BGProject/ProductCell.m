//
//  ProductCell.m
//  BGProject
//
//  Created by zhuozhong on 14-10-10.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ProductCell.h"
#import "EGOImageView.h"
#import "UIImageView+WebCache.h"
#import "NSString+TL.h"

@interface ProductCell()


@property(nonatomic,retain)UIImageView* photoImage;
@property(nonatomic,retain)UILabel* productNameLab;
@property(nonatomic,retain)UILabel* priceLabel;

@end

@implementation ProductCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _photoImage = [[EGOImageView alloc]init];
        [_photoImage setContentMode:UIViewContentModeScaleToFill];
        [self.contentView addSubview:_photoImage];
        
        _productNameLab = [[UILabel alloc]init];
        [_productNameLab setNumberOfLines:0];
        [_productNameLab setFont:kIntroFont];
        [self.contentView addSubview:_productNameLab];
        

        _priceLabel = [[UILabel alloc]init];
        [_priceLabel setNumberOfLines:0];
        [_priceLabel setFont:kPriceFont];
        [_priceLabel setTextColor:[UIColor redColor] ];
        
        [self.contentView addSubview:_priceLabel];
        
        //self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamedForResizeAble: @"cell_bg_3side_03.png"]];
    }
    
    return self;
}

-(void)setCellframe:(ProductCellFrame *)cellframe
{
    _cellframe = cellframe;
    ProductModel* model = cellframe.model;
    
    [_photoImage setImageWithURL:[NSURL URLWithString:[NSString setupSileServerAddressWithUrl:model.img]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    [_photoImage setFrame:cellframe.photoFrame];
    
    [_productNameLab setFrame:cellframe.nameFrame];
    [_productNameLab setText:model.product_name];
    
    [_priceLabel setFrame:cellframe.priceFrame];
    [_priceLabel setText:model.priceStr ];
    
}
@end
