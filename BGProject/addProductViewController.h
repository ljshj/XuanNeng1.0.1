//
//  addProductViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-29.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSUserCenterMessageInterface.h"
#import "FDSUserCenterMessageManager.h"
#import "ProductModel.h"

@interface addProductViewController : UIViewController

@property(nonatomic,copy)NSString* viewTitle;

@property(nonatomic,copy)NSString* buttonTitle;
@property(nonatomic,retain)ProductModel* model;
@property(nonatomic,retain)NSMutableArray* productArr;

@end
