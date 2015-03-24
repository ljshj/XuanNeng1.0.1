    //
//  FDSUser.m
//  FDS
//
//  Created by Naval on 13-12-17.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "BGUser.h"

@implementation BGUser

- (void)copy:(BGUser*)user
{
   if(user == nil)
       return;
    /* 针对切换账号内容更新  账号秘密字段服务器不返回 需判空*/
//    if (user.m_name && 0 < user.m_name.length)
//    {
        self.m_name = user.m_name;
//    }
    if (user.m_account && 0 < user.m_account.length)
    {
        self.m_account = user.m_account;
    }
    if (user.m_userID && 0 < user.m_userID.length)
    {
        self.m_userID = user.m_userID;
    }
    if (user.m_password && 0 < user.m_password.length)
    {
        self.m_password = user.m_password;
    }
    self.m_friendID = user.m_friendID;
//    if (user.m_phone && 0 < user.m_phone.length)
//    {
        self.m_phone = user.m_phone;
//    }
//    if (user.m_icon && 0 < user.m_icon.length)
//    {
        self.m_icon = user.m_icon;
//    }

        self.m_messageID = user.m_messageID;
    

    self.m_friendType = user.m_friendType;

}


//格式化保存
//-(void)setBirthday:(NSString *)birthday {
//    NSDateFormatter* fmt = [[NSDateFormatter alloc]init];
//    fmt.dateFormat = @"yyyy/MM/dd HH:mm:ss";//2015/4/20 0:00:00
//    if(birthday!=nil) {
//        NSDate* tmpDate = [fmt dateFromString:birthday];
//        fmt.dateFormat = @"yyyy-MM-dd";
//        _birthday = [fmt stringFromDate:tmpDate];
//    }
//}

-(void)updateWithDic:(NSDictionary *)dic {
    self.age = dic[@"age"];
    
    self.birthday = dic[@"birthday"];
    self.btype = dic[@"btype"];
    self.conste = dic[@"conste"];
    
    //信誉 信用
    self.credit = dic[@"credit"];
    self.email = dic[@"email"];
    self.exp = dic[@"exp"];
    
    self.fansnumber = dic[@"fansnumber"];
    self.favor = dic[@"favor"];
    self.guanzhu = dic[@"guanzhu"];
    
    self.hometown = dic[@"hometown"];
    self.ican = dic[@"ican"];
    self.ineed = dic[@"ineed"];
    
    self.level = dic[@"level"];
    self.loplace = dic[@"loplace"];
    self.nickn = dic[@"nickn"];
    
    self.nicktitle = dic[@"nicktitle"];
    self.phonenumber = dic[@"phonenumber"];
    self.photo = dic[@"photo"];
    
    self.sex = dic[@"sex"];
    self.signature = dic[@"signature"];
    self.userName = dic[@"username"];
    
    self.weiqiang = dic[@"weiqiang"];
}

@end
