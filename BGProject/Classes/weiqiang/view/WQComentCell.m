//
//  WQComentCell.m
//  BGProject
//
//  Created by liao on 14-11-4.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "WQComentCell.h"
#import "UIImageView+WebCache.h"
#import "IFTweetLabel.h"
#import "NSString+TL.h"

#define kTimeTextColor [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0]

#define kDividerColor [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0]

@interface WQComentCell()<IFTweetLabelDelegate>
/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *photoView;
/**
 *  时间
 */
@property (nonatomic, weak) UILabel *timeLab;
/**
 *  昵称
 */
@property (nonatomic, weak) UILabel *nameLab;
/**
 *  正文
 */
@property (nonatomic, weak) IFTweetLabel *contentLab;
/**
 *  分割线
 */
@property (nonatomic, weak) UIView *divider;

@end

@implementation WQComentCell

/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 1.头像
        UIImageView *photoView = [[UIImageView alloc] init];
        photoView.layer.masksToBounds = YES;
        photoView.layer.cornerRadius = 6.0;
        [self.contentView addSubview:photoView];
        self.photoView = photoView;
        
        // 2.昵称
        UILabel *nameLab = [[UILabel alloc] init];
        nameLab.font = TLNameFont;
        [self.contentView addSubview:nameLab];
        self.nameLab = nameLab;
        
        // 3.时间
        UILabel *timeLab = [[UILabel alloc] init];
        timeLab.numberOfLines = 0;
        timeLab.font = TLTimeFont;
        timeLab.textColor = kTimeTextColor;
        [self.contentView addSubview:timeLab];
        self.timeLab = timeLab;
        
        // 4.正文
//        UILabel *contentLab = [[UILabel alloc] init];
//        contentLab.numberOfLines = 0;
//        contentLab.font = TLContentFont;
//        [self.contentView addSubview:contentLab];
//        self.contentLab = contentLab;
        
        // 4.正文
        IFTweetLabel *contentLab = [[IFTweetLabel alloc] init];
        contentLab.delegate = self;
        [contentLab setNumberOfLines:0];
        [contentLab setFont:[UIFont systemFontOfSize:13.0f]];
        [contentLab setTextColor:[UIColor blackColor]];
        [contentLab setLinksEnabled:YES];
        [contentLab setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:contentLab];
        self.contentLab = contentLab;
        
        //5.分割线
        UIView *divider = [[UIView alloc] init];
        divider.backgroundColor = kDividerColor;
        [self.contentView addSubview:divider];
        self.divider = divider;
        
    }
    return self;
}

-(void)setCommentFrame:(BGWQCommentCellFrame *)commentFrame
{
    _commentFrame = commentFrame;
    
    // 1.设置数据
    [self settingData];
    
    // 2.设置frame
    [self settingFrame];
}

- (void)settingData
{
    // 微博数据
    BGWQCommentModel *model = self.commentFrame.model;
    
    // 1.头像
    [self.photoView setImageWithURL:[NSURL URLWithString:[NSString setupSileServerAddressWithUrl:model.photo]] placeholderImage:[UIImage imageNamed:@"headphoto_s"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    
    // 2.昵称
    self.nameLab.text = model.name;
    
    
    //3.时间
    self.timeLab.text = model.commenttime;
    
    //4.正文
    [self.contentLab setText:model.content];
    
}

/**
 *  设置frame
 */
- (void)settingFrame
{
    // 1.头像
    self.photoView.frame = self.commentFrame.photoFrame;
    
    // 2.昵称
    self.nameLab.frame = self.commentFrame.nameFrame;
    
    // 2.时间
    self.timeLab.frame = self.commentFrame.timeFrame;
    
    // 4.正文
    self.contentLab.frame = self.commentFrame.contentFrame;
    
    //5.分割线
    self.divider.frame = self.commentFrame.dividerFrame;
    
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"comment";
    WQComentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WQComentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

//@用户名被选中回调
-(void)didSelectedIFTweetLabel:(NSString *)text{
    NSLog(@"didSelectedIFTweetLabel==%@writeBackUserid==%@",text,self.writeBackUserid);
}

@end
