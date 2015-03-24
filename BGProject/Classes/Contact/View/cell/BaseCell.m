//
//  BaseCell.m
//  BGProject
//
//  Created by ssm on 14-8-14.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.


#import "BaseCell.h"
#import "FDSUserManager.h"
#import "UIImageView+MJWebCache.h"
#import "NSString+TL.h"

@interface BaseCell()



//昵称
@property(nonatomic,strong)UILabel *nameLabel;

//消息
@property(nonatomic,strong)UILabel *messageLabel;
/**
 *徽章
 */
@property(nonatomic,strong) BGBadgeButton *badgeButton;
/**
 *加入按钮（交流厅）
 */
@property(nonatomic,weak) UIButton *joinButton;

@end
@implementation BaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //头像
        _iconView = [[UIImageView alloc]init];
        //设置圆角
        CGFloat radius = 5;
        [_iconView.layer setCornerRadius:radius];
        [_iconView.layer setMasksToBounds:YES];
        [_iconView setContentMode:UIViewContentModeScaleToFill];
        [self.contentView addSubview:self.iconView];
        
        //徽章
        _badgeButton = [[BGBadgeButton alloc] init];
        _badgeButton.hidden = YES;
        int badgeCount = [FDSUserManager sharedManager].badgeCount;
        [self setupBadgeButtonStausWithBadgeCount:badgeCount];
        [self.contentView addSubview:_badgeButton];
        
        //昵称
        _nameLabel = [[UILabel alloc]init];
        [_nameLabel setFont:kNameFont];
        [_nameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.contentView addSubview:_nameLabel];
        
        //消息（消息－聊天消息，好友列表－个性签名，群－群简介，列表不同，它的意思是不一样的）
        _messageLabel = [[UILabel alloc]init];
        [_messageLabel setFont:kDetailFont];
        _messageLabel.textColor = [UIColor grayColor];
        [_messageLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.contentView addSubview:_messageLabel];
        
    }
    return self;
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

-(void)setCellType:(CellType)cellType{
    
    _cellType = cellType;
    
    if (cellType==CellTypeNotification) {
        
        //监听FDSUserManager的badgeCount属性
        [[FDSUserManager sharedManager] addObserver:self forKeyPath:@"badgeCount" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    
}

-(void)setCellFrame:(BaseCellFrame *)cellFrame {
    
    //如果是申请与通知那个cell
    if (cellFrame.cellFrameType==CellFrameTypeNotification) {
        
        [self setNotificationCellFrame];
        
        
    }else{
        
        _badgeButton.hidden = YES;
        
        _cellFrame = cellFrame;
        
        //取出model
        BaseCellModel* model = cellFrame.model;
        
        //头像
        [_iconView setFrame:cellFrame.iconFrame];
        
        NSString *placeholderImage = nil;
        
        if (cellFrame.cellFrameType==CellFrameTypeGroup || cellFrame.cellFrameType==CellFrameTypeJoinJTempGroup) {
            
            placeholderImage = @"groupIcon";
            
        }else{
            
            FriendCellModel *friendModel = (FriendCellModel *)model;
            
            if ([friendModel.userid isEqualToString:@"0"]) {
                
                placeholderImage = @"logo";
                
            }else{
                
                placeholderImage = @"headphoto_s";
                
            }
            
        }
        
        [_iconView setImageWithURL:[NSURL URLWithString:[NSString setupSileServerAddressWithUrl:model.image]] placeholderImage:[UIImage imageNamed:placeholderImage] options:SDWebImageRetryFailed | SDWebImageLowPriority];
        
        //昵称
        [_nameLabel setFrame:cellFrame.nameFrame];
        [_nameLabel setText:model.name];
        
        //消息
        [_messageLabel setFrame:cellFrame.detailFrame];
        
        
        if ([model.grouptype intValue]==1&&cellFrame.cellFrameType==CellFrameTypeJoinJTempGroup) {
            
            //设置交流厅的按钮
            [self setupJoinButton];
            
            //拼接字符串
            NSString *membersStr = [NSString stringWithFormat:@"交流厅人数：%d人",model.membercount];
            
            [_messageLabel setText:membersStr];
            
            //将文本颜色变成黑色
            _messageLabel.textColor = [UIColor blackColor];
            
        }else{
            
            [_messageLabel setText:model.detail];
            
        }
        
    }
    
}

//设置加入交流厅的按钮
-(void)setupJoinButton{
    
    self.joinButton = nil;
    UIButton *joinButton = [[UIButton alloc] init];
    CGFloat joinX = CGRectGetMaxX(_iconView.frame)+130;
    CGFloat joinH = 30;
    CGFloat joinY = 20;
    CGFloat joinW = 80;
    joinButton.frame = CGRectMake(joinX, joinY, joinW, joinH);
    joinButton.backgroundColor = [UIColor colorWithRed:43/255.0 green:203/255.0 blue:93/255.0 alpha:1.0];
    [joinButton setTitle:@"马上聊天" forState:UIControlStateNormal];
    joinButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    joinButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [joinButton addTarget:self action:@selector(joinButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:joinButton];
    self.joinButton = joinButton;
    
}

//加入按钮被点击
-(void)joinButtonClick{
    
    if ([self.delegate respondsToSelector:@selector(didClickJoinButtonWithRoomid:userid:)]) {
        
        //取出userid
        NSString *userid = [[FDSUserManager sharedManager] NowUserID];
        
        [self.delegate didClickJoinButtonWithRoomid:self.cellFrame.model.roomid userid:userid];
    }
    
}

//单独设置申请与通知cell
-(void)setNotificationCellFrame{
    
    //头像
    [_iconView setFrame:(CGRect){kIconXY, kIconSize}];
    _iconView.image = [UIImage imageNamed:@"notification"];
    
    //徽章
    CGFloat badgeW = 20;
    CGFloat badgeH = 20;
    CGFloat badgeX = CGRectGetMaxX(_iconView.frame)-badgeW*0.8;
    CGFloat badgeY = _iconView.frame.origin.y;
    _badgeButton.frame = CGRectMake(badgeX, badgeY, badgeW, badgeH);
    
    //标题
    CGFloat nameX = CGRectGetMaxX(_iconView.frame)+10;
    CGFloat nameH = 20;
    CGFloat nameY = 30;
    CGFloat nameW = 200;
    _nameLabel.frame = CGRectMake(nameX, nameY, nameW, nameH);
    [_nameLabel setText:@"申请与通知"];
    
}

//属性监听回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    //赋新值
    [self setupBadgeButtonStausWithBadgeCount:[change[@"new"] intValue]];
    

}

@end
