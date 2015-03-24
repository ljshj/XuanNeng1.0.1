//
//  XuanNengPaiHangBangCell.m
//  BGProject
//
//  Created by ssm on 14-9-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "XuanNengPaiHangBangCell.h"
#import "EGOImageView.h"
#import "BottomBar.h"
#import "StatusImageListView.h"
#import "UIImageView+WebCache.h"
#import "LikeuserView.h"
#import "XNRelatedModel.h"
#import "BGWQCommentCellFrame.h"
#import "WQComentCell.h"
#import "NSString+TL.h"

#define OriginalViewWH 44

@interface XuanNengPaiHangBangCell()<BottomBarDelegate>

-(void)bottomBar:(BottomBar *)bar didClickButtonAtIndex:(NSInteger)index;

@end

@implementation XuanNengPaiHangBangCell
{
    /**
     *  头像
     */
    UIImageView* _photo;
    /**
     *  获奖时间
     */
    UILabel* _rankDateLab;
    /**
     *  等级照片
     */
    UIImageView* _rankingImage;
    /**
     *是否是原创
     */
    UIImageView* _originalImage;
    /**
     *  昵称
     */
    UILabel* _nameLabel;
    /**
     *  地图图标
     */
    UIImageView* _distanceTagImgView;
    /**
     *  距离
     */
    UILabel* _distanceLab;
    /**
     *  时间
     */
    UILabel* _dateLab;
    /**
     *  内容
     */
    UILabel* _contentLab;
    /**
     *  工具条
     */
    BottomBar* _bottmBar;
    
    /**
     *  图片列表
     */
    StatusImageListView *_statusImageListView;
    
    /**
     *  删除按钮
     */
    UIButton *_deleteButton;
    //点赞view
    LikeuserView *_likeUserView;
    
    //评论列表（与我相关）
    UITableView *_commentView;
    
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if(self) {
        
        //初始化所有的视图
        _photo = [[UIImageView alloc]init];
        _photo.userInteractionEnabled  =YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personTap)];
        [_photo addGestureRecognizer:tap];
        [self.contentView addSubview:_photo];
        
        _rankDateLab = [[UILabel alloc]init];
        _rankDateLab.font = [UIFont systemFontOfSize:13.0];
        _rankDateLab.textColor = [UIColor redColor];
        [self.contentView addSubview:_rankDateLab];
        
        _rankingImage = [[UIImageView alloc] init];
        _rankingImage.frame = CGRectMake(kScreenWidth-40-25, 10, 72/2, 45/2);
        _rankingImage.hidden = YES;//一开始要隐藏起来
        [self.contentView addSubview:_rankingImage];
        
        //原创图标
        _originalImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_originality"]];
        _originalImage.frame = CGRectMake(kScreenWidth-2*CellMargin-OriginalViewWH, 0, OriginalViewWH, OriginalViewWH);
        _originalImage.hidden = YES;
        [self.contentView addSubview:_originalImage];
        
        _nameLabel = [[UILabel alloc]    init];
        [self.contentView addSubview:_nameLabel];
        
        _distanceTagImgView = [[UIImageView alloc]init];
        [self.contentView addSubview:_distanceTagImgView];
        
        _distanceLab = [[UILabel alloc]init];
        [self.contentView addSubview:_distanceLab];
        
        _dateLab = [[UILabel alloc]init];
        [self.contentView addSubview:_dateLab];
        
        _contentLab = [[UILabel alloc]init];
        _contentLab.numberOfLines  =0;
        [self.contentView addSubview:_contentLab];
        
        _statusImageListView = [[StatusImageListView alloc] init];
        [self.contentView addSubview:_statusImageListView];
        
        _bottmBar = [[BottomBar alloc]init];
        [_bottmBar addButtonWithIcon:@"赞.png" title:@"0"];
        [_bottmBar addButtonWithIcon:@"评论.png" title:@"0"];
        [_bottmBar addButtonWithIcon:@"分享.png" title:@"0"];

        _bottmBar.delegate = self;
        
        [self.contentView addSubview:_bottmBar];
        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamedForResizeAble:@"cell_bg.png"]];
        
        //2014年10月11日 添加删除按钮,并完成委托定义
        // 添加删除按钮
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGSize deletebtnSize  = (CGSize){58/2,41/2};
        CGFloat deleteX = kScreenWidth - deletebtnSize.width - 30;
        CGFloat deleteY = _nameLabel.frame.origin.y + 15;
        CGRect deleteBtnFrame = (CGRect){{deleteX,deleteY}, deletebtnSize};
        [_deleteButton setFrame:deleteBtnFrame];
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"删除_03.png"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(onDeleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_deleteButton];
        
        //点赞列表（与我相关）
        _likeUserView = [[LikeuserView alloc] init];
        [self.contentView addSubview:_likeUserView];
        
        //评论列表（与我相关）
        _commentView = [[UITableView alloc] init];
        _commentView.delegate = self;
        _commentView.dataSource = self;
        _commentView.bounces = NO;
        _commentView.scrollEnabled = NO;
        [self.contentView addSubview:_commentView];
        
    }
    return self;
}

-(void)setCellFrame:(XuanNengPaiHangBangCellFrame *)cellFrame {
    
    _cellFrame  = cellFrame;
    
    //取出模型
    JokeModel* model = cellFrame.model;
    
    //头像
    [_photo setFrame:cellFrame.photoFrame];
    [_photo setImageWithURL:[NSURL URLWithString:[NSString setupSileServerAddressWithUrl:model.photo]] placeholderImage:[UIImage imageNamed:@"headphoto_s"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    
    //如果是榜单要设置排名
    if (model.jokeType==JokeTypeRankList) {
        
        _rankingImage.hidden = NO;
        
        _rankDateLab.hidden = NO;
        
        //如果是榜单一概不显示原创
        _originalImage.hidden = YES;
        
        //设置获奖图片
        [self setupRankingImageWithRanking:model.ranking];
        
    }else if (model.jokeType==JokeTypeRank){
        
        //只有这个有值的时候才会显示
        if (model.ranking) {
            
            _rankingImage.hidden = NO;
            
            //设置获奖图片
            [self setupRankingImageWithRanking:model.ranking];
            
        }else{
            
            _rankingImage.hidden = YES;
            
        }
        
        _rankDateLab.hidden = YES;
        
        //如果是榜单一概不显示原创
        _originalImage.hidden = YES;
    
    }else if (model.jokeType==JokeTypeMyHumorousShow){
        
        //在我的幽默秀里面只显示删除按钮，原创不显示
        _rankDateLab.hidden = YES;
        _rankingImage.hidden = YES;
        _originalImage.hidden = YES;
        
    }else{
        _rankDateLab.hidden = YES;
        _rankingImage.hidden = YES;
        
        //只有是原创才会显示出啦
        if (model.yuanchuang) {
            
            _originalImage.hidden = NO;
            
        }else{
            
            _originalImage.hidden = YES;
            
        }
        
    }
    
    //昵称
    [_nameLabel setText:model.username];
    [_nameLabel setFont:kBigFont];
    [_nameLabel setFrame:cellFrame.nameFrame];
    
    _rankDateLab.text = model.opartime;
    _rankDateLab.frame = cellFrame.rankDateFrame;
    
    //距离图标
    [_distanceTagImgView setFrame:cellFrame.distanceTagFrame];
    [_distanceTagImgView setImage:[UIImage imageNamed:@"距离.png"]];
    
    //距离标签
    NSString *distanceStr = [self getIntWithNSNumber:model.distance];
    [_distanceLab setText:distanceStr];
    [_distanceLab setFrame:cellFrame.distanceFrame];
    [_distanceLab setFont:kMiddleFont];
    
    //时间标签
    [_dateLab setText:model.date_time];
    [_dateLab setFont:kMiddleFont];
    [_dateLab setFrame:cellFrame.dateFrame];
    
    //内容标签
    [_contentLab setText:model.content];
    [_contentLab setFont:kMiddleFont];
    [_contentLab setFrame:cellFrame.contentFrame];
    
    //图片
    if (model.imgs) {
        _statusImageListView.hidden = NO;
        [_statusImageListView setFrame:cellFrame.imageListViewFrame];
        _statusImageListView.imageUrls = model.imgs;
    }else{
        _statusImageListView.hidden = YES;
    }
        
    //工具条
    [_bottmBar setText:model.like_count AtIndex:0];
    [_bottmBar setText:model.comment_count AtIndex:1];
    [_bottmBar setText:model.share_count AtIndex:2];
    [_bottmBar setFrame:cellFrame.boomBarFrame];
    
    if (cellFrame.needHideBottomBar == YES) {
        
        _bottmBar.hidden = YES;
        
    }else{
        
        _bottmBar.hidden = NO;
        
    }
    
    //点赞的view
    if (cellFrame.cellType==CellTypeRelated) {
        
        _likeUserView.hidden = NO;
        
        //转换模型
        XNRelatedModel *relatedModel = (XNRelatedModel *)model;
        
        //将之前的点赞按钮删除
        for (UIView *subview in _likeUserView.subviews) {
            if ([subview isKindOfClass:[UIButton class]]) {
                
                [subview removeFromSuperview];
                
            }
        }
        
        //拿数据
        _likeUserView.likeUserList = relatedModel.likeuserlist;
        _likeUserView.frame = cellFrame.likeuserViewFrame;
        
        //拿数据
        _commentView.frame = cellFrame.commentViewFrame;
        _commentView.hidden = NO;
        self.commentlist = nil;
        self.commentlist = relatedModel.commentlist;
        [NSThread detachNewThreadSelector:@selector(reloloadComment) toTarget:self withObject:nil];
        
    }else{
        
        _likeUserView.hidden = YES;
        _commentView.hidden = YES;
        
    }
    
    //是否隐藏删除按钮
    if (self.needHideDeleteButton==YES) {
        
        _deleteButton.hidden = YES;
        
    }else{
    
        _deleteButton.hidden = NO;
    }
    
}

//根据名次设置排名图片
-(void)setupRankingImageWithRanking:(NSString *)ranking{
    
    if ([ranking intValue]==1) {
        
        _rankingImage.image = [UIImage imageNamed:@"icon_joke_one"];
        
    }else if ([ranking intValue]==2){
        
        _rankingImage.image = [UIImage imageNamed:@"icon_joke_two"];
        
    }else if([ranking intValue]==3){
        
        _rankingImage.image = [UIImage imageNamed:@"icon_joke_three"];
        
    }else{
        
        _originalImage.image = nil;
        
    }
    
    
    
}

//头像点击
-(void)personTap{
    
    if([_delegate respondsToSelector:@selector(xuanNengPersontap:)])
    {
        //取出cellframe
        JokeModel *model = self.cellFrame.model;
        
        [_delegate xuanNengPersontap:model.userid];
    }
    
}

-(void)reloloadComment{
    
    [_commentView reloadData];
    
}

-(void)bottomBar:(BottomBar *)bar didClickButtonAtIndex:(NSInteger)index{
    if([_delegate respondsToSelector:@selector(XuanNengPaiHangBangCell:didClickButtonAtIndex:)])
    {
        [_delegate XuanNengPaiHangBangCell:self didClickButtonAtIndex:index];
    }
}

//delete my self
-(void)onDeleteBtnClick
{
    if([_delegate respondsToSelector:@selector(SubmittedTopicCellDelete:)])
    {
        [_delegate SubmittedTopicCellDelete:self];
    }
}

-(void)setFrame:(CGRect)frame{
    frame.origin.x = 8;
    frame.size.width = frame.size.width-8*2;
    frame.origin.y += 10;
    
    frame.size.height = frame.size.height - 10;
    
    [super setFrame:frame];
}

#pragma mark-UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.commentlist.count;
    
}

//高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //评论高度
    BGWQCommentCellFrame* commentFrame = self.commentlist[indexPath.row];
    
    return commentFrame.cellHight;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //微博评论
    WQComentCell *commentCell = [WQComentCell cellWithTableView:tableView];
    
    BGWQCommentCellFrame* commentFrame = self.commentlist[indexPath.row];
    commentCell.commentFrame = commentFrame;
    
    return commentCell;
    
}

//nsnumber转换成NSString
-(NSString *)getIntWithNSNumber:(NSNumber *)nsnumber{
    
    double x = [nsnumber doubleValue];
    int distance = 0;
    NSString *distanceStr = @"";
    
    if (x>1000) {
        
        x = x/1000.00000000;
        distance = (int)(x<0 ? x-0.5 : x+0.5);
        distanceStr = [NSString stringWithFormat:@"%dkm",distance];
        
    }else{
        
        distance = (int)(x<0 ? x-0.5 : x+0.5);
        distanceStr = [NSString stringWithFormat:@"%dm",distance];
    }
    
    return distanceStr;
    
}

@end
