//
//  CommentModel.h
//  BGProject
//
//  Created by ssm on 14-9-17.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

//    <userid/>
//    <name/>//用户名
//    <photo/>//用户头像
//    <content/>//评论内容
@property(nonatomic,assign)int userid;
@property(nonatomic,retain)NSString* name;
@property(nonatomic,retain)NSString* photo;
@property(nonatomic,retain)NSString* content;


-(id)initWithDic:(NSDictionary*)dic;
@end
