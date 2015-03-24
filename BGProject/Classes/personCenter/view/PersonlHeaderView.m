//
//  PersonlHeaderView.m
//  BGProject
//
//  Created by liao on 14-12-2.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "PersonlHeaderView.h"
#import "PersonCardTopView.h"
#import "SignatureView.h"
#import "SegmentationView.h"
#import "INeedIcanView.h"
#import "FDSUserManager.h"

@interface PersonlHeaderView()<BGSegmentationViewDelegate>
/**
 *  卡片头部
 */
@property (nonatomic, weak) PersonCardTopView *cardTopView;
/**
 *  个性签名
 */
@property (nonatomic, weak) SignatureView *signView;
/**
 *  操作条
 */
@property (nonatomic, weak) SegmentationView *segView;
/**
 *  我想
 */
@property (nonatomic, weak) INeedIcanView *iNeedView;
/**
 *  我能
 */
@property (nonatomic, weak) INeedIcanView *iCanView;

@end

@implementation PersonlHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //背景颜色
        self.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
        
        //头部
        PersonCardTopView *cardTopView = [[PersonCardTopView alloc] init];
        [self addSubview:cardTopView];
        self.cardTopView = cardTopView;
        
        //个性签名
        SignatureView *signView = [[SignatureView alloc] init];
        [self addSubview:signView];
        self.signView = signView;
        
        //操作条
        SegmentationView *segView = [[SegmentationView alloc] init];
        segView.delegate = self;
        [self addSubview:segView];
        self.segView = segView;
        
        //我想
        INeedIcanView *iNeedView = [[INeedIcanView alloc] init];
        iNeedView.type = TypeINeed;
        [self addSubview:iNeedView];
        self.iNeedView = iNeedView;
        
        //我能
        INeedIcanView *iCanView = [[INeedIcanView alloc] init];
        iCanView.type = TypeICan;
        [self addSubview:iCanView];
        self.iCanView = iCanView;
        
    }
    return self;
}

-(void)setUserDic:(NSDictionary *)userDic{
    
    _userDic = userDic;
    
    //传递模型
    [self.cardTopView.user updateWithDic:userDic];
    
    [self.signView.user updateWithDic:userDic];
    
    [self.iNeedView.user updateWithDic:userDic];
    
    [self.iCanView.user updateWithDic:userDic];
    
    BOOL isFriend = [userDic[@"isfriend"] boolValue];
    self.segView.isFriend = isFriend;
    
    BOOL isguanzhu = [userDic[@"isguanzhu"] boolValue];
    self.segView.isguanzhu = isguanzhu;
    
    NSString *nowUserid = [[FDSUserManager sharedManager] NowUserID];
    NSString *modelUserid = self.userDic[@"userid"];
    
    //如果是用户本身或者是未登录的游客都不显示操作条，nowUserid为nil,说明未登录
    if ([nowUserid isEqualToString:modelUserid] || nowUserid==nil) {
        
        self.segView.hidden = YES;
        
    }
    
}

-(void)layoutSubviews{

    //头部
    CGFloat cardTopViewX = 0;
    CGFloat cardTopViewY = 0;
    CGFloat cardTopViewW = self.bounds.size.width;
    CGFloat cardTopViewH = 100;
    self.cardTopView.frame = CGRectMake(cardTopViewX, cardTopViewY, cardTopViewW, cardTopViewH);
    
    //个性签名
    CGFloat signViewX = 0;
    CGFloat signViewY = CGRectGetMaxY(self.cardTopView.frame)+4;
    CGFloat signViewW = cardTopViewW;
    CGFloat signViewH = 60;
    self.signView.frame = CGRectMake(signViewX, signViewY, signViewW, signViewH);
    
    //操作条
    CGFloat segViewX = 0;
    CGFloat segViewY = CGRectGetMaxY(self.signView.frame);
    CGFloat segViewW = cardTopViewW;
    CGFloat segViewH = 50;
    self.segView.frame = CGRectMake(segViewX, segViewY, segViewW, segViewH);
    
    NSString *nowUserid = [[FDSUserManager sharedManager] NowUserID];
    NSString *modelUserid = self.userDic[@"userid"];
    CGFloat iNeedViewY = 0;
    
    //如果是用户本身或者是未登录的游客都不显示操作条，nowUserid为nil,说明未登录
    if ([nowUserid isEqualToString:modelUserid] || nowUserid==nil) {
        
        iNeedViewY = CGRectGetMaxY(self.signView.frame)+2;
        
    }else{
        
        iNeedViewY = CGRectGetMaxY(self.segView.frame)+2;
        
    }
    
    //我想
    CGFloat iNeedViewX = 0;
    CGFloat iNeedViewW = cardTopViewW;
    CGFloat iNeedViewH = 50;
    self.iNeedView.frame = CGRectMake(iNeedViewX, iNeedViewY, iNeedViewW, iNeedViewH);
    
    //我能
    CGFloat iCanViewX = 0;
    CGFloat iCanViewY = CGRectGetMaxY(self.iNeedView.frame)+2;
    CGFloat iCanViewW = cardTopViewW;
    CGFloat iCanViewH = 50;
    self.iCanView.frame = CGRectMake(iCanViewX, iCanViewY, iCanViewW, iCanViewH);
    
    //修改高度
    CGRect personF = self.frame;
    personF.size.height = CGRectGetMaxY(self.iCanView.frame)+2;
    self.frame = personF;
    
}

#pragma mark-BGSegmentationViewDelegate

-(void)didSelectedButtonWithIndex:(NSInteger)index staus:(BOOL)selected{
    
    if (index==0) {
        
        NSString *userid = [NSString stringWithFormat:@"%d",[self.userDic[@"userid"] intValue]];
        
        [self.delegate didClickFocusButtonWithUserid:userid buttonStaus:selected];
        
    }
    
}

-(void)didSelectedButtonWithIndex:(NSInteger)index{
    
    if (index==0) {
        
        
        
    }else if (index==1){
        
        if ([self.delegate respondsToSelector:@selector(didSelectedPersonlHeaderButtonWithUsername:)]) {
            
            //取出用户ID
            NSString *userid = self.userDic[@"userid"];
            
            //拼接用户名
            NSString *username = [NSString stringWithFormat:@"bg%@",userid];
            
            [self.delegate didSelectedPersonlHeaderButtonWithUsername:username];
        }
        
    }else{
        
        if ([self.delegate respondsToSelector:@selector(didSelectedPersonlHeaderButtonWithUsername:photo:isFriend:nickn:)]) {
            
            //取出用户ID
            NSString *userid = self.userDic[@"userid"];
            
            //取出用户昵称
            NSString *nickn = self.userDic[@"nickn"];
            
            //拼接用户名
            NSString *username = [NSString stringWithFormat:@"bg%@",userid];
            
            //取出头像
            NSString *photo = self.userDic[@"photo"];
            
            //是否是好友
            BOOL isFriend = [self.userDic[@"isfriend"] boolValue];
            
            [self.delegate didSelectedPersonlHeaderButtonWithUsername:username photo:photo isFriend:isFriend nickn:nickn];
            
        }
        
    }
    
}

@end
