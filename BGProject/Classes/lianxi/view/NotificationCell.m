//
//  NotificationCell.m
//  BGProject
//
//  Created by liao on 14-12-27.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "NotificationCell.h"
#import "UIImageView+MJWebCache.h"
#import "EaseMob.h"
#import "FriendCellModel.h"
#import "DataBaseSimple.h"
#import "FDSUserManager.h"
#import "NSString+TL.h"

@interface NotificationCell()

/**
 *头像
 */
@property(nonatomic,weak) UIImageView *iconView;
/**
 *昵称
 */
@property(nonatomic,weak) UILabel *nameLabel;
/**
 *消息
 */
@property(nonatomic,weak) UILabel *messageLab;
/**
 *同意按钮
 */
@property(nonatomic,weak) UIButton *agreeButton;
/**
 *拒绝按钮
 */
@property(nonatomic,weak) UIButton *rejectButton;
/**
 *接受的模型在数组中的位置（不能一边遍历一边删除）
 */
@property(nonatomic,assign) NSUInteger index;
@end

@implementation NotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //模型的位置（给个－1吧）
        self.index = -1;
        
        //头像
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        //昵称
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = NameFont;
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        //消息
        UILabel *messageLab = [[UILabel alloc] init];
        messageLab.font = MessageFont;
        [self.contentView addSubview:messageLab];
        self.messageLab = messageLab;
        
        //接收按钮
        UIButton *agreeButton = [[UIButton alloc] init];
        agreeButton = [self setupButton:agreeButton title:@"接受" bg:AgreeButtonBg];
        [agreeButton addTarget:self action:@selector(agreeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:agreeButton];
        self.agreeButton = agreeButton;
        
        //拒绝按钮
        UIButton *rejectButton = [[UIButton alloc] init];
        rejectButton = [self setupButton:rejectButton title:@"拒绝" bg:RejectButtonBg];
        [rejectButton addTarget:self action:@selector(rejectButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:rejectButton];
        self.rejectButton = rejectButton;

    }
    return self;
}

//设置按钮属性
-(UIButton *)setupButton:(UIButton *)button title:(NSString *)title bg:(UIColor *)bg{
    
    button.backgroundColor = bg;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:13.0];
    button.titleLabel.textColor = [UIColor whiteColor];
    
    return button;
    
}

//同意按钮
-(void)agreeButtonClick{
    
    //检测是否有网络
    BOOL isExistenceNetwork = [self isConnectionAvailable];
    
    if (!isExistenceNetwork) {
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:[UIApplication sharedApplication].keyWindow MESSAGE:@"网络未连接"];
        return;
        
    }
    
    //取出模型
    NotificationModel *model = _cellFrame.model;
    
    //拼接用户名
    NSString *username = [NSString stringWithFormat:@"bg%@",model.userid];
    
    if (self.notificationFrameType==NotificationFrameTypeGroup) {
        
        //发送环信同意进群请求消息
        EMError *error = nil;
        [[EaseMob sharedInstance].chatManager acceptApplyJoinGroup:model.hxgroupid groupname:model.groupname applicant:username error:&error];
        
        if (!error) {
            
            NSLog(@"noerror");
            
            //先删除用户中心里面的模型
            for (NotificationFrame *notiFrame in [FDSUserManager sharedManager].messages) {
                
                NSLog(@"先删除用户中心里面的模型");
                
                //取出模型
                NotificationModel *userModel = notiFrame.model;
                
                //删除模型
                if ([userModel.userid isEqualToString:model.userid]) {
                    
                    NSLog(@"记录下模型的位置");
                    
                    //记录下模型的位置
                    self.index = [[FDSUserManager sharedManager].messages indexOfObject:notiFrame];
                    
                }
                
            }
            
            NSLog(@"删除对应的模型");
            
            
            if (self.index<100 || self.index>=0) {
                //删除对应的模型
                [[FDSUserManager sharedManager].messages removeObjectAtIndex:self.index];
                self.index = -1;//置为－1，防止用了上次的值
 
            }
            
            //修改徽章
            [FDSUserManager sharedManager].badgeCount--;
            
            //回调
            if ([self.delegate respondsToSelector:@selector(didClickAgreeButtonWithUserid:hxgroupid:)]) {
                
                NSLog(@"回调");
                
                [self.delegate didClickAgreeButtonWithUserid:model.userid hxgroupid:model.hxgroupid];
                
            }
        }
        
        return;
        
    }
    
    //发送环信接受好友请求消息
    BOOL isAgree = [[[EaseMob sharedInstance] chatManager] acceptBuddyRequest:username error:nil];
    
    //接受请求
    if (isAgree) {
        
        //先删除用户中心里面的模型
        for (NotificationFrame *notiFrame in [FDSUserManager sharedManager].messages) {
            
            //取出模型
            NotificationModel *userModel = notiFrame.model;
            
            //删除模型
            if ([userModel.userid isEqualToString:model.userid]) {
                
                //记录下模型的位置
                self.index = [[FDSUserManager sharedManager].messages indexOfObject:notiFrame];
                
            }
            
        }
        
        //删除对应的模型
        [[FDSUserManager sharedManager].messages removeObjectAtIndex:self.index];
        
        
        //修改徽章
        [FDSUserManager sharedManager].badgeCount--;
        
        //回调
        if ([self.delegate respondsToSelector:@selector(didClickAgreeButtonWithUserid:)]) {
            
            //如果hxgroupid为0，说明这是接受好友的
            [self.delegate didClickAgreeButtonWithUserid:model.userid];
            
        }
        
    }
    
}

//拒绝按钮
-(void)rejectButtonClick{
    
    //取出模型
    NotificationModel *model = _cellFrame.model;
    
    //拼接用户名
    NSString *username = [NSString stringWithFormat:@"bg%@",model.userid];
    
    if (self.notificationFrameType==NotificationFrameTypeGroup) {
        
        //发送环信拒绝进群请求消息
        [[EaseMob sharedInstance].chatManager rejectApplyJoinGroup:model.hxgroupid groupname:model.groupname toApplicant:username reason:nil];
        
        //先删除用户中心里面的模型
        for (NotificationFrame *notiFrame in [FDSUserManager sharedManager].messages) {
            
            //取出模型
            NotificationModel *userModel = notiFrame.model;
            
            //删除模型
            if ([userModel.userid isEqualToString:model.userid]) {
                
                //记录下模型的位置
                self.index = [[FDSUserManager sharedManager].messages indexOfObject:notiFrame];
                
            }
            
        }
        
        //删除对应的模型
        [[FDSUserManager sharedManager].messages removeObjectAtIndex:self.index];
        self.index = -1;//置为－1，防止用了上次的值
        
        //修改徽章
        [FDSUserManager sharedManager].badgeCount--;
        
        //回调
        if ([self.delegate respondsToSelector:@selector(didClickRejectButtonWithUserid:hxgroupid:)]) {
            
            [self.delegate didClickRejectButtonWithUserid:model.userid hxgroupid:model.hxgroupid];
        }
        
        return;
        
    }
    
    
    //发送环信接受好友请求消息
    BOOL isReject = [[[EaseMob sharedInstance] chatManager] rejectBuddyRequest:username reason:@"拒绝" error:nil];
    
    //接受请求
    if (isReject) {
        
        //先删除用户中心里面的模型
        for (NotificationFrame *notiFrame in [FDSUserManager sharedManager].messages) {
            
            //取出模型
            NotificationModel *userModel = notiFrame.model;
            
            //删除模型
            if ([userModel.userid isEqualToString:model.userid]) {
                
                //记录下模型的位置
                self.index = [[FDSUserManager sharedManager].messages indexOfObject:notiFrame];
                
            }
            
        }
        
        //删除对应的模型
        [[FDSUserManager sharedManager].messages removeObjectAtIndex:self.index];
        self.index = -1;//置为－1，防止用了上次的值
        
        //修改徽章
        [FDSUserManager sharedManager].badgeCount--;
        
        //回调
        if ([self.delegate respondsToSelector:@selector(didClickRejectButtonWithUserid:)]) {
            
            //如果hxgroupid为0，说明这是接受好友的
            [self.delegate didClickRejectButtonWithUserid:model.userid];
            
        }
        
    }
    
}

-(void)setCellFrame:(NotificationFrame *)cellFrame{
    
    _cellFrame = cellFrame;
    
    //根据cellFrame确定cell的类型
    self.notificationFrameType = cellFrame.notificationFrameType;
    
    //取出模型
    NotificationModel *model = cellFrame.model;
    
    //头像
    NSString *placeholderImage = nil;
    
    //群跟好友是用不同的用户头像的
    if (cellFrame.notificationFrameType==NotificationFrameTypeGroup) {
        
        placeholderImage = @"groupIcon";
        
    }else{
        
        placeholderImage = @"headphoto_s";
        
    }
    
    [self.iconView setImageWithURL:[NSURL URLWithString:[NSString setupSileServerAddressWithUrl:model.image]] placeholderImage:[UIImage imageNamed:placeholderImage] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    self.iconView.frame = cellFrame.IconFrame;
    
    //昵称
    self.nameLabel.text = model.name;
    self.nameLabel.frame = cellFrame.nameFrame;
    
    //消息
    self.messageLab.text = model.message;
    self.messageLab.frame = cellFrame.messageFrame;
    
    //添加按钮
    CGFloat agreeW = 45;
    CGFloat agreeH = 25;
    CGFloat agreeX = self.frame.size.width-agreeW-10;
    CGFloat agreeY = (cellFrame.cellHeight-agreeH)*0.5;
    self.agreeButton.frame = CGRectMake(agreeX, agreeY, agreeW, agreeH);
    
    //拒绝按钮
    CGFloat rejectW = 45;
    CGFloat rejectH = 25;
    CGFloat rejectX = agreeX-rejectW-10;
    CGFloat rejectY = (cellFrame.cellHeight-rejectH)*0.5;;
    self.rejectButton.frame = CGRectMake(rejectX, rejectY, rejectW, rejectH);
    
}

//检测网络状态
-(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    switch ([reach currentReachabilityStatus]) {
            
        case NotReachable:
            
            isExistenceNetwork = NO;
            
            NSLog(@"notReachable");
            
            break;
            
        case ReachableViaWiFi:
            
            isExistenceNetwork = YES;
            
            NSLog(@"WIFI");
            
            break;
            
        case ReachableViaWWAN:
            
            isExistenceNetwork = YES;
            
            NSLog(@"3G");
            
            break;
            
    }
    
    return isExistenceNetwork;
    
}

@end
