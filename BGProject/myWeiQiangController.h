//
//  myWeiQiangController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

// 定义评论类型
typedef enum {
    WeiQiangTypeMy,
    WeiQiangTypeOther,
}WeiQiangType;

@interface myWeiQiangController : UIViewController<UITableViewDataSource,UITableViewDelegate>
// 保存微墙实例
//<<<<<<< .mine
//@property(nonatomic,retain)NSArray* weiQianArr;
@property(nonatomic,retain)NSMutableArray* weiQianArr;

/**
 *  我的／别人的微墙
 */
@property (assign,nonatomic) WeiQiangType weiQiangType;
@property(nonatomic,copy) NSString *userid;//用于加载数据的ID
// 注意事项：
// 从零开始请求微博,表示请求最新的微博

@property(nonatomic,assign)int  maxid; // 记录最 上面 单元格的weiboid
@property(nonatomic,assign)int  minid; // 记录最 下面 单元格的weiboid

@property(nonatomic,assign)int start;
@property(nonatomic,copy) NSString* viewTitle;

@end
