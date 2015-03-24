//
//  rewardViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-23.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoudleMessageInterface.h"

//定义发布幽默秀的类型（有图片／没图片）
typedef enum {
    IssueHumorousTypeCommon,
    IssueHumorousTypeNoPhoto,
    IssueHumorousTypePhoto
}IssueHumorousType;

@interface rewardViewController : UIViewController<UITextViewDelegate,UIScrollViewDelegate,MoudleMessageInterface>

/**
 *发布幽默秀的类型（有图片／没图片）
 */
@property(nonatomic,assign) IssueHumorousType  issueHumorousType;

//这个是干嘛用的
@property(nonatomic,copy)NSString *recStr;

//神马东东
-(void)submitTopicCB:(int)result;
@end
