//
//  FriendCellModel.h
//  BGProject
//
//  Created by ssm on 14-8-19.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "BaseCellModel.h"

@interface FriendCellModel : BaseCellModel

//好友userid
@property(nonatomic,copy) NSString *userid;

//群成员类型（2：群主 0:群成员）
@property(nonatomic,assign) int type;

// 是否是女性
@property(nonatomic,assign)BOOL isGirl;

//是否是VIP
@property(nonatomic,assign)BOOL isVIP;
/**
 *属于索引哪一组
 */
@property(nonatomic,assign) NSUInteger section;
/**
 *一般的字典
 */

-(instancetype)initWithDic:(NSDictionary *)dic;
@end
