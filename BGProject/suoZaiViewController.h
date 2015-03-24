//
//  suoZaiViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-29.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kReauestHometown 1
#define kRequestLocation 2

@interface suoZaiViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)NSArray *myCities;


@property (nonatomic,copy) NSString *m_province;

//请求标识，用于区分家乡和所在地
@property (nonatomic,assign) int requestTag;

@end
