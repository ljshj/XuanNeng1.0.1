//
//  liaoTianViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-29.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendCellModel.h"

@class LianXiViewController;

//定义解析的消息的类型(接收的／记录的)
typedef enum {
    MessageTypeReceive,
    MessageTypeRecord,
}MessageType;

//定义聊天对象的类型（群聊／单聊）
typedef enum {
    ChatTypeSingle,
    ChatTypeGroupRegular,
    ChatTypeGroupTemp
}ChatType;

@interface liaoTianViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIView      *topView ;
    UIButton  *backBtn;
    UITableView *messageListView;

    
}

/**
 *聊天类型（群聊／单聊）
 */
@property(nonatomic,assign) ChatType chatType;
/**
 *聊天消息数组
 */
@property(nonatomic,strong) NSMutableArray   *messageList;
/**
 *群名称
 */
@property(nonatomic,copy) NSString *groupname;
/**
 *用户名(群聊／单聊都用这个用户名)
 */
@property(nonatomic,copy) NSString *username;
/**
 *好友名字(上面那个才是bgxx,下面这个是炫能名字)
 */
@property(nonatomic,copy) NSString *friendname;
/**
 *用户头像
 */
@property(nonatomic,strong) NSString *icon;
/**
 *取得会话对象的userid，聊天的时候点击头像要用到
 */
@property(nonatomic,strong) NSString *userid;
/**
 *群成员数组（群聊）
 */
@property(nonatomic,strong) NSArray *members;
/**
 *炫能的群ID(后面要用来存群的messageID的)
 */
@property(nonatomic,copy) NSString *roomid;

@end
