//
//  BGPublishView.h
//  BGProject
//
//  Created by liao on 14-11-4.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PlaceholderComment @"请输入你要评论的内容"
#define PlaceholderFrom @"说点什么吧"


//定义评论类型
typedef enum {
    commentTypeFrom,
    commentTypeComment,
}CommentType;

@protocol BGPublishViewDelegate <NSObject>

@optional

-(void)didSelectedPublishButton:(NSString *)text;

@end
@interface BGPublishView : UIView<UITextFieldDelegate>
/**
 *  评论输入框
 */
@property (nonatomic, weak) UITextField *commentField;
@property (weak,nonatomic) id<BGPublishViewDelegate>delegate;
/**
 *  被评论的微博ID
 */
@property (assign,nonatomic) int weiboid;
/**
 *  评论类型
 */
@property (assign,nonatomic) CommentType commentType;
/**
 *  被评论的笑话ID
 */
@property (assign,nonatomic) int jokeid;
@end
