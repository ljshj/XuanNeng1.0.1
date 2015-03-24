//
//  SearchViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
//搜索类型（我能or我想）
@property(nonatomic,assign)SearchType searchType;

@end
