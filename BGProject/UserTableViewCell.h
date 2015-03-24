//
//  UserTableViewCell.h
//  BGProject
//
//  Created by zhuozhongkeji on 14-9-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell
{
    
}

@property(nonatomic,assign)float m_height;
@property(nonatomic,assign)int m_type;
@property(nonatomic,retain)NSString *m_icon;
@property(nonatomic,retain)NSString *m_title;
@property(nonatomic,retain)NSString *m_content1;
@property(nonatomic,retain)NSString *m_content2;
@property(nonatomic,retain)NSString *m_content3;

-(void)initView;
@end
