//
//  UserTableViewCell.m
//  BGProject
//
//  Created by zhuozhongkeji on 14-9-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "UserTableViewCell.h"
#import "EGOImageView.h"
@implementation UserTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.m_height =  USER_TABLE_CELL_HEIGHT;
        // Initialization code
    }
    return self;
}
// ##进行cell初始化
-(void)initView
{
   if(self.m_icon)
   {
       EGOImageView *ownIconView = [[EGOImageView alloc]initWithFrame:CGRectMake(5, 5, USER_TABLE_CELL_HEIGHT - 10, USER_TABLE_CELL_HEIGHT - 10)];
       ownIconView.placeholderImage = nil;
       ownIconView.imageURL = [NSURL URLWithString:self.m_icon];
       [self addSubview:ownIconView];
   }
    if(self.m_title)
    {
      //  self.
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(USER_TABLE_CELL_HEIGHT, 5, 200, 20)];
        [titleLabel setText:self.m_title];
        [self addSubview:titleLabel ];
    }
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
