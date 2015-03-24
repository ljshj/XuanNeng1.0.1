//
//  FDSUser.h
//  FDS
//
//  Created by Naval on 13-12-17.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

enum USERSTATE{
    USERSTATE_NONE,
    USERSTATE_NO_ACCOUNT,
    USERSTATE_HAVE_ACCOUNT_NO_LOGIN_LOGINOUT,// 因为注销而没有登录
    USERSTATE_HAVE_ACCOUNT_NO_LOGIN_NOTNET,//因为没有网络而没有登录
    USERSTATE_LOGIN,
    USERSTATE_LOGIN_FAILED, //登录失败
    USERSTATE_MAX
};
@interface BGUser : NSObject

@property(nonatomic,retain)NSString *m_name;
@property(nonatomic,retain)NSString *m_account;

@property(nonatomic,retain)NSString *m_password;
@property(nonatomic,retain)NSString *m_phone;
@property(nonatomic,retain)NSString *m_icon;

@property(nonatomic,assign)NSInteger m_messageID;
@property (nonatomic,assign) NSInteger m_sectionNumber;


//-----------------bg用户状态------------
@property(nonatomic,retain)NSString *m_userID;// 保存bg的userid

@property(nonatomic,copy)NSString* birthday;
@property(nonatomic,copy)NSString* btype;
@property(nonatomic,copy)NSString* conste;

@property(nonatomic,copy)NSString* credit;
@property(nonatomic,copy)NSString* email;
@property(nonatomic,copy)NSString* exp;

@property(nonatomic,copy)NSString* fansnumber;
@property(nonatomic,copy)NSString* favor;
@property(nonatomic,copy)NSString* guanzhu;

@property(nonatomic,copy)NSString* hometown;
@property(nonatomic,copy)NSString* ican;
@property(nonatomic,copy)NSString* ineed;

@property(nonatomic,copy)NSString* level;
@property(nonatomic,copy)NSString* loplace;
@property(nonatomic,copy)NSString* nickn;

@property(nonatomic,copy)NSString* nicktitle;
@property(nonatomic,copy)NSString* photo;
@property(nonatomic,copy)NSString* sex; //0 1 2

@property(nonatomic,copy)NSString* signature;
@property(nonatomic,copy)NSString* userName;
@property(nonatomic,copy)NSString* weiqiang;// 整数

@property(nonatomic,copy)NSString* phonenumber;

//@property(nonatomic,copy)NSString* phone;
@property(nonatomic,copy)NSString* age;
//-----------------bg用户状态 over------------


@property(nonatomic,retain)NSString *m_sex;
@property(nonatomic,retain)NSString *m_job;
@property(nonatomic,retain)NSString *m_company;
@property(nonatomic,retain)NSString *m_handicap;
@property(nonatomic,retain)NSString *m_tel;
@property(nonatomic,retain)NSString *m_email;
@property(nonatomic,retain)NSString *m_brief;
@property(nonatomic,retain)NSString *m_golfAge;

@property(nonatomic,retain)NSString *m_remarkName;
@property(nonatomic,retain)NSString *m_joinedCompanyCount;
@property(nonatomic,retain)NSString *m_joinedBarCount;
@property(nonatomic,retain)NSString *m_friendType; //”no”,”friend”,
@property(nonatomic,retain)NSString *m_displayName;
@property(nonatomic,retain)NSString *m_friendID;
-(void)copy:(BGUser*)user;


//bg 更新用户数据
-(void)updateWithDic:(NSDictionary*)dic;


@end
