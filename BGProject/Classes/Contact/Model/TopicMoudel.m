//
//  TopicMoudel.m
//  BGProject
//
//  Created by ssm on 14-9-17.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "TopicMoudel.h"
//870008 70008 用户投的“稿”

@implementation TopicMoudel

-(id)initWithDic:(NSDictionary*)dic {
    if(self = [super init]) {
      
        self.jokeid = [dic[@"jokeid"] integerValue];
        self.username = dic[@"username"];
        self.photoURL = dic[@"photo"];
        self.distance = dic[@"distance"];
        self.dateTime = dic[@"date_time"];
        self.content = dic[@"content"];
    
        self.imgURL = dic[@"imgs"][@"img"];
        self.imgThumURL =dic[@"imgs"][@"img_thum"];
        self.likeCount = [dic[@"like_count"] intValue];
        self.commentCount = [dic[@"comment_count"]intValue];
        self.forwardCount = [dic[@"forward_count"]intValue];
        self.shareCount = [dic[@"share_count"]intValue];
    
    }
    return self;
}
@end
