//
//  ProductTableViewCell.h
//  BGProject
//
//  Created by liao on 14-10-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLProductModel.h"

@interface ProductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong,nonatomic) TLProductModel *model;
@end
