//
//  WeiQiangRelatedModel.m
//  BGProject
//
//  Created by liao on 14-12-5.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "WeiQiangRelatedModel.h"
#import "BGWQCommentModel.h"
#import "LikeUser.h"
#import "BGWQCommentCellFrame.h"

@implementation WeiQiangRelatedModel

-(id)initWithDic:(NSDictionary*)dic {
    
    self = [super initWithDic:dic];
    
    if(self) {
        
        //设置与我姓关评论数组
        [self setupCommentlist:dic];
        
        //设置点赞
        [self setupLikeuserlist:dic];
        
        
    }
    return self;
}

-(void)setupCommentlist:(NSDictionary *)dic{
    
    NSMutableArray *commentlist = [[NSMutableArray alloc] init];
    NSArray *tempLists =dic[@"commentlist"];
    for (NSDictionary *dic in tempLists) {
        
        BGWQCommentModel *model = [BGWQCommentModel commentWithDic:dic];
        BGWQCommentCellFrame* commentFrame = [[BGWQCommentCellFrame alloc] initWithModel:model];
        [commentlist addObject:commentFrame];
        
        
    }
    self.commentlist=commentlist;
    
}

-(void)setupLikeuserlist:(NSDictionary *)dic{
    
    NSMutableArray *likeuserlist = [[NSMutableArray alloc] init];
    NSArray *tempLists =dic[@"likeuserlist"];
    for (NSDictionary *dic in tempLists) {
        
        LikeUser *model = [LikeUser likeUserWithDic:dic];
        [likeuserlist addObject:model];
        
        
    }
    self.likeuserlist=likeuserlist;
    
}

@end
