//
//  InfoCell.m
//  BGProject
//
//  Created by ssm on 14-8-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "InfoCell.h"
#import "BGBadgeButton.h"

#define kDateColor [UIColor colorWithRed:0xa6/256.0 green:0xa6/256.0 blue:0xa6/256.0 alpha:1]
@interface InfoCell ()
/**
 *徽章
 */
@property(nonatomic,strong) BGBadgeButton *badgeButton;
@property(nonatomic,retain) UILabel* dateLabel;
@end

@implementation InfoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        _dateLabel = [[UILabel alloc]init];
        [_dateLabel setFont:kDateFont];
        [_dateLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        UIColor* dateColor = kDateColor;
        [_dateLabel setTextColor:dateColor];
        [self.contentView addSubview:_dateLabel];
        
        //徽章
        _badgeButton = [[BGBadgeButton alloc] init];
        _badgeButton.hidden = YES;
        [self.contentView addSubview:_badgeButton];
        
    }
    
    return  self;
}

//设置badgeCount
-(void)setupBadgeButtonStausWithBadgeCount:(int)badgeCount{
    
    //先赋值
    _badgeButton.badgeValue = [NSString stringWithFormat:@"%d",badgeCount];
    
    //调整状态
    if (badgeCount==0) {
        
        _badgeButton.hidden = YES;
        
    }else{
        
        _badgeButton.hidden = NO;
        
    }
    
}

-(void)setCellFrame:(InfoCellFrame *)cellFrame {
    
    [super setCellFrame:cellFrame];
    
    InfoCellModel* model = (InfoCellModel*)cellFrame.model;
    
    [_dateLabel setFrame:cellFrame.dateFrame];
    [_dateLabel setText:model.dateString];
    
    //徽章
    CGFloat badgeW = 20;
    CGFloat badgeH = 20;
    CGFloat badgeX = CGRectGetMaxX(cellFrame.iconFrame)-badgeW*0.5;
    CGFloat badgeY = cellFrame.iconFrame.origin.y-badgeH*0.3;
    _badgeButton.frame = CGRectMake(badgeX, badgeY, badgeW, badgeH);
    [self setupBadgeButtonStausWithBadgeCount:model.badgeCount];
    
}

@end
