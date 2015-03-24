//
//  WeiQiangCell.m
//  BGProject
//
//  Created by ssm on 14-9-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#pragma mark-IFTweetLabe
//IFTweetLabe内部改死爹了！！！
//CGSize measureSize = [NSString sizeWithText:measureText font:font maxSize:CGSizeMake(100, 100)];
//CGRect matchFrame = CGRectMake(measureSize.width - 2.5f, point.y+0.5, matchSize.width + 6.0f, matchSize.height);

#import "WeiQiangCell.h"
#import "BottomBar.h"
#import "StatusImageListView.h"
#import "UIImageView+WebCache.h"
#import "LikeuserView.h"
#import "WeiQiangRelatedModel.h"
#import "WQComentCell.h"
#import "UIImage+TL.h"
#import "NSString+TL.h"
#import "IFTweetLabel.h"

#define FromBackViewColor [UIColor colorWithRed:242/255.0 green:242/255.0 blue:245/255.0 alpha:1.0]
#define NameTextColor [UIColor colorWithRed:46/255.0 green:146/255.0 blue:255/255.0 alpha:1.0]

@interface WeiQiangCell ()<BottomBarDelegate,UITableViewDataSource,UITableViewDelegate,IFTweetLabelDelegate>

@end

@implementation WeiQiangCell
{
    UIImageView* _photo;
    UILabel* _nameLabel;
    
    UIImageView* _distanceTagImgView;
    UILabel* _distanceLab;
    UILabel* _dateLab;
    
    UILabel* _contentLab;
    UIView *_fromBackView;//转发正文的背景视图
    IFTweetLabel *_fromContentLab;//转发正文
    
    StatusImageListView *_statusImageListView;
    
    BottomBar* _bottmBar;
    
    //点赞view
    LikeuserView *_likeUserView;

    //删除按钮
    UIButton* _deleteButton;
    
    //评论列表（与我相关）
    UITableView *_commentView;

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1].CGColor;
        
        _photo = [[UIImageView alloc]init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personTap)];
        [_photo addGestureRecognizer:tap];
        _photo.userInteractionEnabled = YES;
        [self.contentView addSubview:_photo];
        
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:kBigFont];
        [self.contentView addSubview:_nameLabel];
        
        _distanceTagImgView = [[UIImageView alloc]init];
        [self.contentView addSubview:_distanceTagImgView];
        
        _distanceLab = [[UILabel alloc]init];
        [self.contentView addSubview:_distanceLab];
        
        _dateLab = [[UILabel alloc]init];
        [self.contentView addSubview:_dateLab];
        
        _contentLab = [[UILabel alloc]init];
        [_contentLab setFont:kMiddleFont];
        _contentLab.numberOfLines = 0;
        [self.contentView addSubview:_contentLab];
        
        //转发正文背景视图
        _fromBackView = [[UIView alloc] init];
        _fromBackView.backgroundColor = FromBackViewColor;
        [self.contentView addSubview:_fromBackView];
        
        //转发正文
        _fromContentLab = [[IFTweetLabel alloc] init];
        _fromContentLab.delegate = self;
        [_fromContentLab setFont:kMiddleFont];
        [_fromContentLab setNumberOfLines:0];
        [_fromContentLab setLinksEnabled:YES];
        [_fromBackView addSubview:_fromContentLab];
        
        _statusImageListView = [[StatusImageListView alloc] init];
        
        //工具条
        _bottmBar = [[BottomBar alloc]init];
        _bottmBar.delegate = self;
        [_bottmBar addButtonWithIcon:@"赞.png" title:@"0"];
        [_bottmBar addButtonWithIcon:@"评论.png" title:@"0"];
        [_bottmBar addButtonWithIcon:@"分享.png" title:@"0"];
        [self.contentView addSubview:_bottmBar];
        
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

//头像点击
-(void)personTap{
    
    if([_delegate respondsToSelector:@selector(persontap:)])
    {
        //取出cellframe
        weiQiangModel *model = self.cellFrame.model;
        
        [_delegate persontap:model.userid];
    }
    
}

-(void)setCellFrame:(WeiQiangCellFrame *)cellFrame {
    
    _cellFrame  = cellFrame;
    
    //取出微墙模型
    weiQiangModel* model = cellFrame.model;
    
    //头像
    [_photo setFrame:cellFrame.photoFrame];
    
    [_photo setImageWithURL:[NSURL URLWithString:[NSString setupSileServerAddressWithUrl:model.photo]] placeholderImage:[UIImage imageNamed:@"headphoto_s"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    
    //昵称
    [_nameLabel setText:model.name];
    [_nameLabel setFrame:cellFrame.nameFrame];
   
    
    //距离图标
    [_distanceTagImgView setFrame:cellFrame.distanceTagFrame];
    [_distanceTagImgView setImage:[UIImage imageNamed:@"距离.png"]];
    
    
    [_distanceLab setText:[self getIntWithNSNumber:model.distance]];
    [_distanceLab setFrame:cellFrame.distanceFrame];
    [_distanceLab setFont:kMiddleFont];
    
    
    [_dateLab setText:model.date_time];
    [_dateLab setFont:kMiddleFont];
    [_dateLab setFrame:cellFrame.dateFrame];
    
    if (![model.fromname isEqualToString:@""]){
        //有转发，放转发评论
        if (model.comments.length==0) {
            //如果没有转发评论
            [_contentLab setText:@"转发微墙"];
        }else{
            
           [_contentLab setText:model.comments];
        }
        
        
    }else{
        //没有转发
        [_contentLab setText:model.content];
        
    }
    [_contentLab setFrame:cellFrame.contentFrame];
    
    if (![model.fromname isEqualToString:@""]){
        
        //有转发
        //背景
        _fromBackView.hidden = NO;
        _fromBackView.frame = cellFrame.fromBackViewFrame;
        
        //转发正文
        //_fromContentLab.frame = cellFrame.fromContentFrame;
        [_fromContentLab setFrame:cellFrame.fromContentFrame];
        [_fromContentLab setText:model.content];
        
        //将图片父视图放下来
        [_statusImageListView removeFromSuperview];
        
        //有转发就添加到转发背景
        [_fromBackView addSubview:_statusImageListView];
        
    }else{
        //没有转发的时候，隐藏起来
        _fromBackView.hidden = YES;
        
        //将图片父视图放下来
        [_statusImageListView removeFromSuperview];
        
        //添加到cell背景图上面去
        [self.contentView addSubview:_statusImageListView];
    }

    if (model.imgs) {
        _statusImageListView.hidden = NO;
        [_statusImageListView setFrame:cellFrame.imageListViewFrame];
        _statusImageListView.imageUrls = model.imgs;
    }else{
        _statusImageListView.hidden = YES;
    }
    
    [_bottmBar setText:model.like_count AtIndex:0];
    [_bottmBar setText:model.comment_count AtIndex:1];
    [_bottmBar setText:model.forward_count AtIndex:2];
    [_bottmBar setText:model.share_count AtIndex:3];
    [_bottmBar setFrame:cellFrame.boomBarFrame];
    
    //点赞的view
    if (cellFrame.cellType==CellTypeRelated) {
        
        _likeUserView.hidden = NO;
        
        //转换模型
        WeiQiangRelatedModel *relatedModel = (WeiQiangRelatedModel *)model;
        
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
        //[_commentView reloadData];
        
    }else{
        
        _likeUserView.hidden = YES;
        _commentView.hidden = YES;
        
    }
    
    //添加删除按钮
    if(_needHideDeleteButton == YES)
    {
    }else {
        // 添加删除按钮,为空的时候才添加
        if (_deleteButton==nil) {
            
            _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            CGSize deletebtnSize  = (CGSize){58/2,41/2};
            CGFloat deleteX = kScreenWidth - deletebtnSize.width - 30;
            CGFloat deleteY = _nameLabel.frame.origin.y + 5;
            CGRect deleteBtnFrame = (CGRect){{deleteX,deleteY}, deletebtnSize};
            [_deleteButton setFrame:deleteBtnFrame];
            [_deleteButton setBackgroundImage:[UIImage imageNamed:@"删除_03.png"] forState:UIControlStateNormal];
            [_deleteButton addTarget:self action:@selector(onDeleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:_deleteButton];
            
        }
        
    }
}

-(void)reloloadComment{
    
    [_commentView reloadData];
    
}

// 删除自己
-(void)onDeleteBtnClick
{
    if([_delegate respondsToSelector:@selector(WeiQiangCellDelete:)])
    {
        
        [_delegate WeiQiangCellDelete:self];
    }
}

//BottomBar回调代理（点赞／转发／分享／评论）
-(void)bottomBar:(BottomBar *)bar didClickButtonAtIndex:(NSInteger)index{
    if([_delegate respondsToSelector:@selector(WeiQiangCell:didSelectedButtonIndex:)])
    {
        
        [_delegate WeiQiangCell:self didSelectedButtonIndex:index];
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

#pragma mark-IFTweetLabelDelegate

//@用户名被选中回调
-(void)didSelectedIFTweetLabel:(NSString *)text{
    
    //NSLog(@"didSelectedIFTweetLabel==%@writeBackUserid==%@",text,self.cellFrame.model.fromuserid);
    
    if ([self.delegate respondsToSelector:@selector(persontap:)]) {
        
        [self.delegate persontap:self.cellFrame.model.fromuserid];
        
    }
    
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
