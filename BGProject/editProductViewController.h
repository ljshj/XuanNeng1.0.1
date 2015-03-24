//
//  editProductViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-29.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface editProductViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

// 保存要显示的产品
@property(nonatomic,retain) NSMutableArray* productArr;
@property(nonatomic,copy) NSString *userid;
@end
