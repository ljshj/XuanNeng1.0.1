//
//  RecomProductCell.m
//  BGProject
//
//  Created by liao on 14-11-19.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "RecomProductCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+TL.h"


#define kRecomButtonBgColor [UIColor colorWithRed:252/255.0 green:69/255.0 blue:72/255.0 alpha:1.0]

@interface RecomProductCell()
/**
 *  头像
 */
@property (nonatomic, weak) UIView *photoBackView;
/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *photoView;
/**
 *  时间
 */
@property (nonatomic, weak) UILabel *dateLab;
/**
 *  昵称
 */
@property (nonatomic, weak) UILabel *nameLab;
/**
 *  价格
 */
@property (nonatomic, weak) UILabel *priceLab;
/**
 *  日期图标
 */
@property (nonatomic, weak) UIImageView *dateIcon;
/**
 *  推荐标识
 */
@property (nonatomic, weak) UIButton *recomButton;

@end

@implementation RecomProductCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        //图片的底层view,可以剪切图片
        UIView *photoBackView = [[UIView alloc] init];
        photoBackView.clipsToBounds = YES;
        [self.contentView addSubview:photoBackView];
        self.photoBackView = photoBackView;
        
        //商品图片
        UIImageView *photoView = [[UIImageView alloc]init];
        [self.photoBackView addSubview:photoView];
        self.photoView = photoView;
        
        //商品名称
        UILabel *nameLab = [[UILabel alloc]init];
        [nameLab setNumberOfLines:0];
        [nameLab setFont:[UIFont systemFontOfSize:14.0]];
        [self.contentView addSubview:nameLab];
        self.nameLab = nameLab;
        
        //商品价格
        UILabel *priceLab = [[UILabel alloc]init];
        [priceLab setNumberOfLines:0];
        [priceLab setFont:[UIFont systemFontOfSize:14.0]];
        [priceLab setTextColor:[UIColor redColor] ];
        [self.contentView addSubview:priceLab];
        self.priceLab = priceLab;
        
        //日期
        UILabel *dateLab = [[UILabel alloc] init];
        [dateLab setFont:[UIFont systemFontOfSize:13.0]];
        [self.contentView addSubview:dateLab];
        self.dateLab = dateLab;
        
        //日期图标
        UIImageView *dateIcon = [[UIImageView alloc] init];
        [dateIcon setImage:[UIImage imageNamed:@"我的橱窗－产品推荐_12"]];
        [self.contentView addSubview:dateIcon];
        self.dateIcon = dateIcon;
        
        UIButton *recomButton = [[UIButton alloc] init];
        recomButton.backgroundColor = kRecomButtonBgColor;
        [recomButton setTitle:@"推荐" forState:UIControlStateNormal];
        [recomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        recomButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        recomButton.enabled = NO;
        [self.contentView addSubview:recomButton];
        self.recomButton = recomButton;
        
    }
    
    return self;
}

-(void)setCellframe:(RecomProductFrame *)cellframe{
    
    _cellframe = cellframe;
    
    // 1.设置数据
    [self settingData];
    
    // 2.设置frame
    [self settingFrame];
    
}

-(void)settingData{
   
    // 获取推荐产品模型
    RecomProductModel *model = self.cellframe.model;
    
    // 1.头像
    [self.photoView setImageWithURL:[NSURL URLWithString:[NSString setupSileServerAddressWithUrl:model.img]] placeholderImage:[UIImage imageNamed:@"recomProductPlaceholderimage"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    self.photoView.contentMode = UIViewContentModeScaleAspectFill;
    
    // 2.商品名称
    self.nameLab.text = model.product_name;
    
    //商品日期
    self.dateLab.text = model.date_time;
    
    //商品价格
    self.priceLab.text = model.price;
    
}

-(void)settingFrame{
    
    RecomProductFrame *cellF = self.cellframe;
    
    self.dateIcon.frame = cellF.dateIconFrame;
    
    self.dateLab.frame = cellF.dateFrame;
    
    self.photoBackView.frame = cellF.imgFrame;
    
    self.photoView.frame = CGRectMake(0, 0, cellF.imgFrame.size.width, cellF.imgFrame.size.height);
    
    self.nameLab.frame = cellF.nameFrame;
    
    self.priceLab.frame = cellF.priceFrame;
    
    self.recomButton.frame = cellF.recomTagFrame;
    
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"recomProductCell";
    RecomProductCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[RecomProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(void)setFrame:(CGRect)frame{
    
    frame.origin.y += 10;
    frame.size.height = frame.size.height - 10;
    [super setFrame:frame];
}



@end
