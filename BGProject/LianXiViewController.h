//
//  LianXiViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LianXiViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    // 消息的数据源
    NSMutableArray* _messageCellFrames;
    NSMutableArray* _friendCellFrames;
    NSMutableArray* _crowdCellFrames;
    NSMutableArray* _tempCrowdCellFrames;
    
    
    NSMutableArray *friendArr;
    NSMutableArray *groupArr;
    NSMutableArray *exchangeArr;
    NSMutableArray *recDataArr;
}

/**
 *不在聊天页面接收到的聊天消息
 */
@property(nonatomic,strong) NSMutableArray *messages;

-(void)isPushChatNotification;
@end
