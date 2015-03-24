//
//  TableViewCell.h
//  BGProject
//
//  Created by zhuozhong on 14-7-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *faceImageView;
@property(nonatomic,copy)UILabel *nameLabel;
@property(nonatomic,copy)UILabel *qianMingLabel;
@property(nonatomic,copy)UILabel *myCanLabel;
@property(nonatomic,copy)UILabel *myNecLabel;
@end
