//
//  projectSetting.h
//  BGProject
//
//  Created by ssm on 14-8-8.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#ifndef BGProject_projectSetting_h
#define BGProject_projectSetting_h


#define FDS_gobalRes_h
enum SYSTEM_STATE{
    SYSTEM_STATE_NONE,
    SYSTEM_STATE_NO_NET,//没有网络
    SYSTEM_STATE_FILE_EXIST,//文件已经存在
    SYSTEM_STATE_MAX
    
};
/* function define */
#define RELEASE_SALF(x) \
if(x != nil)\
{\
[x release];\
x=nil;\
}
/*  define the kes  */
#define USER_COUNT @"userCount"
#define USER_PASSWORD @"userPassword"
#define ISLOGOUT @"isLogout"
#define ISFIRSTRUN @"isFirstRun"



#define USER_NIGHT_DISTURB  @"nightDisturb"  //夜间免打扰
#endif
