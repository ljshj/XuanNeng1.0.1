//
//  TrendViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoudleMessageInterface.h"

//定义发布微博的类型（有图片／没图片）
typedef enum {
    IssueWeiQiangTypeCommon,
    IssueWeiQiangTypeNoPhoto,
    IssueWeiQiangTypePhoto
}IssueWeiQiangType;

@interface TrendViewController : UIViewController<UITextViewDelegate,
UIScrollViewDelegate,MoudleMessageInterface,
UINavigationControllerDelegate,UIImagePickerControllerDelegate>

/**
 *发布微博的类型（有图片／没图片）
 */
@property(nonatomic,assign) IssueWeiQiangType  issueWeiQiangType;

@end
