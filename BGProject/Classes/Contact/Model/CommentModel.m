//
//  CommentModel.m
//  BGProject
//
//  Created by ssm on 14-9-17.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel


-(id)initWithDic:(NSDictionary *)dic {
    if(self = [super init]) {
        //    <userid/>
        //    <name/>//用户名
        //    <photo/>//用户头像
        //    <content/>//评论内容
        self.userid = [dic[@"userid"] intValue];
        self.name = dic[@"name"];
        self.photo = dic[@"photo"];
        self.content = dic[@"content"];
    }
    return self;
}
@end
