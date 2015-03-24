//
//  AuditHumorousViewController.h
//  BGProject
//
//  Created by liao on 15-3-12.
//  Copyright (c) 2015年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JokeModel.h"

@interface AuditHumorousViewController : UIViewController

/**
 *数组
 */
@property(strong,nonatomic) NSMutableArray *dataArray;
/**
 *记录下来是当前是数组哪个元素
 */
@property(nonatomic,assign) int contentIndex;
/**
 *记录下当前的jokeid
 */
@property(nonatomic,copy) NSString *jokeid;

@end
