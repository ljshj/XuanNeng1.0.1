//
//  homeViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

//这样写神马状况？这个是个类吗？？
@interface GIFTArea: NSObject

@property(nonatomic,assign)NSInteger  m_section;
@property(nonatomic,retain)NSString   *m_province;
@property(nonatomic,retain)NSArray    *m_areaList;

@end
@interface homeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView       *cityTable;
    
    NSMutableArray    *provinces;
}

//@property(nonatomic,assign)enum GIFT_PROFILE_TYPE  operType;

//请求标识，用于区分家乡和所在地
@property (nonatomic,assign) int requestTag;

@end
