//
//  InfoCellModel.h
//  BGProject
//
//  Created by ssm on 14-8-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "BaseCellModel.h"

//定义信息模型的类型(群／个人)
typedef enum {
    InfoModelTypeFriend,
    InfoModelTypeGroup,
    InfoModelTypeTempGroup
}InfoModelType;

@interface InfoCellModel : BaseCellModel
/**
 *模型类型
 */
@property(nonatomic,assign)InfoModelType infoModelType;
/**
 *日期
 */
@property(nonatomic,retain)NSDate* date;
/**
 *通过发送日期计算得到的字符串
 */
@property(nonatomic,copy)  NSString* dateString;
/**
 *徽章
 */
@property(nonatomic,assign) int badgeCount;
/**
 *用户ID
 */
@property(nonatomic,copy) NSString *userid;



@end
