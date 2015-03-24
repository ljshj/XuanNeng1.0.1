//
//  ChatMessage.h
//  BGProject
//
//  Created by zhuozhongkeji on 14-9-16.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMessage : NSObject
@property(nonatomic,assign)int m_messageType;// 0 : 文字； 1: 图片 ；2: 其他文件
@property(nonatomic,retain)NSString *m_senderID;
@property(nonatomic,retain)NSString *m_senderName;
@property(nonatomic,retain)NSString *m_groupID;
@property(nonatomic,retain)NSString *m_content;
@property(nonatomic,retain)NSString *m_fileName;
@property(nonatomic,retain)NSString *m_fileURL;
@property(nonatomic,retain)NSString *m_sendTime;
@end
