//
//  WeiQiangRelatedModel.h
//  BGProject
//
//  Created by liao on 14-12-5.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "weiQiangModel.h"

@interface WeiQiangRelatedModel : weiQiangModel//只是多了两个数组

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
