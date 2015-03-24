//
//  GroupInfoViewController.h
//  BGProject
//
//  Created by liao on 14-12-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//  群信息

#import <UIKit/UIKit.h>
#import "liaoTianViewController.h"

#define DisbandGroupKey @"DisbandGroup"
#define ClearChatHistoryKey @"ClearChatHistory"
#define isDeleteKey @"isDeleteKey"

//定义弹框类型
typedef enum {
    AlertViewTypeClearHistory,
    AlertViewTypeExit
}AlertViewType;

@interface GroupInfoViewController : UIViewController
/**
 *对话框类型
 */
@property(nonatomic,assign) AlertViewType alertViewType;
/**
 *定义群消息类型（临时／固定）
 */
@property(nonatomic,assign) ChatType chatType;
/**
 *群名称
 */
@property(nonatomic,copy) NSString *groupname;
/**
 *炫能ID(清除messageID用到)
 */
@property(nonatomic,copy) NSString *roomid;
/**
 *环信群组id（清除会话对象用到）
 */
@property(nonatomic,copy) NSString *hxgroupid;
/**
 *成员数组
 */
@property(nonatomic,strong) NSMutableArray *members;
/**
 *解散按钮是否按下了确定
 */
@property(nonatomic,assign) BOOL isExitButtonEnsure;
/**
 *是否显示删除按钮（监听属性）
 */
@property(nonatomic,assign) BOOL isDelete;

@end
