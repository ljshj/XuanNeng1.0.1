//
//  ContentDetailModel.h
//  BGProject
//
//  Created by ssm on 14-9-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentModel.h"

@interface ContentDetailModel : NSObject
@property(nonatomic,copy)NSString* content;
@property(nonatomic,copy)NSString* imgURL;
@property(nonatomic,copy)NSString* imgThumURL;
@property(nonatomic,copy)NSArray* commentsArr;


@end
