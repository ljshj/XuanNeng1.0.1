//
//  BaseCellData.h
//  BGProject
//
//  Created by ssm on 14-8-14.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseCellModel : NSObject
/**
 *群ID
 */
@property(nonatomic,copy)NSString *roomid;
/**
 *环信群ID
 */
@property(nonatomic,copy)NSString *hxgroupid;
/**
 *头像
 */
@property(nonatomic,copy)NSString *image;
/**
 *名字
 */
@property(nonatomic,copy)NSString *name;
/**
 *文本
 */
@property(nonatomic,copy)NSString *detail;
/**
 *群类型（0：固定群／1:临时群）
 */
@property(nonatomic,copy) NSString *grouptype;
/**
 *群成员数量
 */
@property(nonatomic,assign) int membercount;

-(instancetype)initWithDic:(NSDictionary *)dic;

@end
