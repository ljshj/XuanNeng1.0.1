//
//  XNRelatedModel.h
//  BGProject
//
//  Created by liao on 15-1-16.
//  Copyright (c) 2015年 zhuozhong. All rights reserved.
//

#import "JokeModel.h"

@interface XNRelatedModel : JokeModel
/**
 *与我相关的评论
 */
@property(nonatomic,strong) NSMutableArray *commentlist;
/**
 *点赞列表
 */
@property(nonatomic,strong) NSMutableArray *likeuserlist;

-(id)initWithDic:(NSDictionary *)dic;

@end
