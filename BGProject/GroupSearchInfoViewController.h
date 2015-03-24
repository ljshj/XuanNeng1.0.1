//
//  GroupSearchInfoViewController.h
//  BGProject
//
//  Created by liao on 15-1-5.
//  Copyright (c) 2015年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCellModel.h"

@interface GroupSearchInfoViewController : UIViewController
/**
 *群模型
 */
@property(nonatomic,strong) BaseCellModel *model;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *intro;
@property(nonatomic,copy) NSString *owerName;
@property(nonatomic,copy) NSString *hxgroupid;
@property(nonatomic,copy) NSString *roomid;
/**
 *群类型（0：固定群／1:临时群）
 */
@property(nonatomic,copy) NSString *grouptype;
@end
