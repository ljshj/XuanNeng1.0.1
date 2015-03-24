//
//  voiceNexViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-8-1.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface voiceNexViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,copy)NSString* titleStr;
@property(nonatomic,retain)NSDictionary* allModelsArr;

// 当前页面的搜索类型 我能 or 我想
@property(nonatomic,assign)SearchType searchType;
/**
 *搜索的词语（用于搜索交流厅）
 */
@property(nonatomic,copy) NSString *searchWordTempGroup;
/**
 *交流厅的数组
 */
@property(nonatomic,strong) NSMutableArray *tempGroupFrames;
@end
