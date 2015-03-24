//
//  DataBaseSimple.m
//  侧滑Demo
//
//  Created by 毛志 on 14-7-2.
//  Copyright (c) 2014年 maozhi. All rights reserved.
//

#import "DataBaseSimple.h"
#import "FMDatabase.h"
#import "FDSUserManager.h"
#import "NSString+TL.h"

@implementation DataBaseSimple
{
    FMDatabase * _dataBase;
}

+ (DataBaseSimple *)shareInstance
{
    static DataBaseSimple * simple = nil;
    if (simple == nil) {
        simple = [[DataBaseSimple alloc] init];
    }
    return simple;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //设置数据库存储的路径，后缀为db
        NSString *path = [NSString pathwithFileName:@"XuanNeng.db"];
        //NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"XuanNeng.db"];
        NSLog(@"path is %@",path);
        
        //创建数据库
        _dataBase = [FMDatabase databaseWithPath:path];
        
        //打开数据库，如果打开失败返回失败信息
        if (![_dataBase open]) {
            
            NSLog(@"open dataBase error!");
            
            return nil;
            
        }
        
        // BLOB 二进制  Text 字符串  Integer 整形。。
        
        //建立Friends表格，并把属性写进去，失败返回error
        if (![_dataBase executeUpdate:@"create table if not exists Friends (ID integer primary key autoincrement,loginUserid text,userid text,detail text,image text,name text,sex text,hxgroupid text,type text)"]) {
            
            NSLog(@"create Friends error!");
            
            return nil;
            
        }
        
        //建立群表格
        if (![_dataBase executeUpdate:@"create table if not exists Groups (ID integer primary key autoincrement,loginUserid text,roomid text,hxgroupid text,name text,detail text,grouptype text)"]) {
            
            NSLog(@"create Groups error!");
            
            return nil;
            
        }
        
        //建立messageID表格
        if (![_dataBase executeUpdate:@"create table if not exists MessageIDs (ID integer primary key autoincrement,loginUserid text,messageid text,username text)"]) {
            
            NSLog(@"create MessageIDs error!");
            
            return nil;
            
        }
        
    }
    
    //数据库初始化完成，返回数据库，这是个数据库单例，只做一个
    return self;
    
}


#pragma mark-群表格

//群表格数据插入
- (void)insertGroupsWithModel:(BaseCellModel *)model
{
    
    //取出当前登录用
    self.loginUserid = [[FDSUserManager sharedManager] NowUserID];
    
    //取出数据库
    NSMutableArray *groups = [self selectAllGroups];
    
    for (BaseCellModel *tempModel in groups) {
        
        if ([tempModel.hxgroupid isEqualToString:model.hxgroupid]) {
            
            //如果重复插入会报错
            NSLog(@"群重复插入");
            
            //直接返回，不执行以下代码
            return;
            
        }
        
    }
    
    if (![_dataBase executeUpdate:@"insert into Groups (loginUserid,roomid,hxgroupid,detail,name,grouptype) values (?,?,?,?,?,?)",self.loginUserid,model.roomid,model.hxgroupid,model.detail,model.name,model.grouptype]) {
        
        //如果重复插入会报错
        NSLog(@"insert error!");
        
        return;
    }
}

//删除群数据
-(void)deleteGroupswithHxgroupid:(NSString *)hxgroupid
{
    
    //取出当前登录用
    self.loginUserid = [[FDSUserManager sharedManager] NowUserID];
    
    if (![_dataBase executeUpdate:@"delete from Groups where hxgroupid=? and loginUserid=?",hxgroupid,self.loginUserid]) {
        
        NSLog(@"delete error!");
        
        return;
        
    }
}

//删除当前登录用户的所有群数据
-(void)deleteGroups
{
    
    //取出当前登录用
    self.loginUserid = [[FDSUserManager sharedManager] NowUserID];
    
    if (![_dataBase executeUpdate:@"delete from Groups where loginUserid=?",self.loginUserid]) {
        
        NSLog(@"delete error!");
        
        return;
        
    }
}

//全部群数据
-(NSMutableArray *)selectAllGroups{
    
    //取出当前登录用
    self.loginUserid = [[FDSUserManager sharedManager] NowUserID];
    
    //创建数组
    NSMutableArray * arr = [NSMutableArray array];
    
    //全部群
    FMResultSet * set = [_dataBase executeQuery:@"select * from Groups where loginUserid=?",self.loginUserid];
    
    while ([set next]) {
        
        //用模型取数据再将一对模型放进数组返回给那边显示出来
        BaseCellModel * model = [[BaseCellModel alloc] init];
        
        model.name = [set stringForColumn:@"name"];
        model.hxgroupid = [set stringForColumn:@"hxgroupid"];
        model.detail = [set stringForColumn:@"detail"];
        model.roomid = [set stringForColumn:@"roomid"];
        
        [arr addObject:model];
        
    }
    
    return arr;
    
}

//查询群数据(固定群)
-(NSMutableArray *)selectGroups
{
    
    //取出当前登录用
    self.loginUserid = [[FDSUserManager sharedManager] NowUserID];
    
    //创建数组
    NSMutableArray * arr = [NSMutableArray array];
    
    //0为固定群类型
    
    FMResultSet * set = [_dataBase executeQuery:@"select * from Groups where loginUserid=? and grouptype=?",self.loginUserid,@"0"];
    
    while ([set next]) {
        
        //用模型取数据再将一对模型放进数组返回给那边显示出来
        BaseCellModel * model = [[BaseCellModel alloc] init];
        
        model.name = [set stringForColumn:@"name"];
        model.hxgroupid = [set stringForColumn:@"hxgroupid"];
        model.detail = [set stringForColumn:@"detail"];
        model.roomid = [set stringForColumn:@"roomid"];
        model.grouptype =[set stringForColumn:@"grouptype"];
        [arr addObject:model];
        
    }
    
    return arr;
    
}

-(NSMutableArray *)selectTempGroups{
    
    //取出当前登录用
    self.loginUserid = [[FDSUserManager sharedManager] NowUserID];
    
    //创建数组
    NSMutableArray * arr = [NSMutableArray array];
    
    //1为临时群类型
    
    FMResultSet * set = [_dataBase executeQuery:@"select * from Groups where loginUserid=? and grouptype=?",self.loginUserid,@"1"];
    
    while ([set next]) {
        
        //用模型取数据再将一对模型放进数组返回给那边显示出来
        BaseCellModel * model = [[BaseCellModel alloc] init];
        
        model.name = [set stringForColumn:@"name"];
        model.hxgroupid = [set stringForColumn:@"hxgroupid"];
        model.detail = [set stringForColumn:@"detail"];
        model.roomid = [set stringForColumn:@"roomid"];
        model.grouptype =[set stringForColumn:@"grouptype"];
        [arr addObject:model];
        
    }
    
    return arr;
    
}

//通过环信ID查询群数据
-(BaseCellModel *)selectGroupsWithHxgroupid:(NSString *)hxgroupid{
    
    //取出当前登录用
    self.loginUserid = [[FDSUserManager sharedManager] NowUserID];
    
    FMResultSet * set = [_dataBase executeQuery:@"select * from Groups where hxgroupid=? and loginUserid=?",hxgroupid,self.loginUserid];
    
    BaseCellModel * model = [[BaseCellModel alloc] init];
    
    while ([set next]) {
        
        //用模型取数据再将一对模型放进数组返回给那边显示出来
        model.name = [set stringForColumn:@"name"];
        model.hxgroupid = [set stringForColumn:@"hxgroupid"];
        model.detail = [set stringForColumn:@"detail"];
        model.roomid = [set stringForColumn:@"roomid"];
        model.grouptype =  [set stringForColumn:@"grouptype"];
    }
    
    return model;
}

#pragma mark-好友表格

//好友表格数据插入
- (void)insertFriendswithModel:(FriendCellModel *)model
{
    
    //取出当前登录用
    self.loginUserid = [[FDSUserManager sharedManager] NowUserID];
    
    //取出数据库
    NSMutableArray *friends = [self selectFriends];
    
    for (FriendCellModel *tempModel in friends) {
        
        if ([tempModel.userid isEqualToString:model.userid]) {
            
            //如果重复插入会报错
            NSLog(@"好友重复插入");
            
            //直接返回，不执行以下代码
            return;
            
        }
        
    }
    
    //将性别转换成字符串
    NSString *sex = [NSString stringWithFormat:@"%d",model.isGirl];
    
    //添加了了一个hxgroupid，如果是好友的插入同意为0
    if (![_dataBase executeUpdate:@"insert into Friends (loginUserid,userid,detail,image,name,sex,hxgroupid,type) values (?,?,?,?,?,?,?,?)",self.loginUserid,model.userid,model.detail,model.image,model.name,sex,@"0",@"-1"]) {
        
        //如果重复插入会报错
        NSLog(@"insert error!");
        
        return;
    }
}

//删除好友数据
- (void)deleteFriendswithUserid:(NSString *)userid
{
    
    //取出当前登录用
    self.loginUserid = [[FDSUserManager sharedManager] NowUserID];
    
    if (![_dataBase executeUpdate:@"delete from Friends where userid=? and loginUserid=?",userid,self.loginUserid]) {
        
        NSLog(@"delete error!");
        
        return;
        
    }
}

//- (void)updateDBwithKey:(NSInteger)key withModel:(ThingsModel *)model
//{
////    ID,ShopID,CateID,Price,Oprice,ImgURL,area,name
//    if (![_dataBase executeUpdate:@"update TaoBao set ID=?,ShopID=?,CateID=?,Price=?,Oprice=?,ImgURL=?,area=?,name=? where ID=?",[NSNumber numberWithInteger:model.ID.intValue],model.shopID,model.cateID,model.price,model.originalPrice,model.imgURL,model.area,model.name,[NSNumber numberWithInteger:key]]) {
//        NSLog(@"update error!");
//        return;
//    }
//}

//查询好友数据
-(NSMutableArray *)selectFriends
{
    
    //取出当前登录用
    self.loginUserid = [[FDSUserManager sharedManager] NowUserID];
    
    //创建数组
    NSMutableArray * arr = [NSMutableArray array];

    //好友数据默认hxgroupid为0
    FMResultSet * set = [_dataBase executeQuery:@"select * from Friends where loginUserid=? and hxgroupid=?",self.loginUserid,@"0"];
    
    while ([set next]) {
        
        //用模型取数据再将一对模型放进数组返回给那边显示出来
        FriendCellModel * model = [[FriendCellModel alloc] init];
        
        model.name = [set stringForColumn:@"name"];
        model.image = [set stringForColumn:@"image"];
        model.detail = [set stringForColumn:@"detail"];
        model.userid = [set stringForColumn:@"userid"];
        model.isGirl = [[set stringForColumn:@"sex"] intValue];
        
        [arr addObject:model];
        
    }
    
    return arr;
    
}

//删除当前登录用户的所有好友数据
-(void)deleteFriends{
    
    //取出当前登录用
    self.loginUserid = [[FDSUserManager sharedManager] NowUserID];
    
    //一定要区分hxgroupid，否则会把群成员都删除掉
    if (![_dataBase executeUpdate:@"delete from Friends where hxgroupid=? and loginUserid=?",@"0",self.loginUserid]) {
        
        NSLog(@"delete error!");
        
        return;
        
    }
    
}

-(FriendCellModel *)selectFriendsWithUserid:(NSString *)userid{
    
    //取出当前登录用
    self.loginUserid = [[FDSUserManager sharedManager] NowUserID];
    
    FMResultSet * set = [_dataBase executeQuery:@"select * from Friends where userid=? and loginUserid=? and hxgroupid=?",userid,self.loginUserid,@"0"];
    
    FriendCellModel * model = [[FriendCellModel alloc] init];
    while ([set next]) {
        
        //用模型取数据再将一对模型放进数组返回给那边显示出来
        model.name = [set stringForColumn:@"name"];
        model.image = [set stringForColumn:@"image"];
        model.detail = [set stringForColumn:@"detail"];
        model.userid = [set stringForColumn:@"userid"];
        model.isGirl = [[set stringForColumn:@"sex"] intValue];
    }
    
    return model;
    
}

#pragma mark-群成员操作

//插入群成员
- (void)insertMemberWithModel:(FriendCellModel *)model hxgroupid:(NSString *)hxgroupid
{
    
    //取出当前登录用
    self.loginUserid = [[FDSUserManager sharedManager] NowUserID];
    
    //取出数据库(同一个群的成员插入不能重复)
    NSMutableArray *friends = [self selectMembersWithHxgroupid:hxgroupid];
    
    for (FriendCellModel *tempModel in friends) {
        
        if ([tempModel.userid isEqualToString:model.userid]) {
            
            //如果重复插入会报错
            NSLog(@"群成员重复插入");
            
            //直接返回，不执行以下代码
            return;
            
        }
        
    }
    
    //成员类型（群主或者是普通群成员）
    NSString *type = [NSString stringWithFormat:@"%d",model.type];
    
    //添加了了一个hxgroupid，如果是好友的插入同意为0
    if (![_dataBase executeUpdate:@"insert into Friends (loginUserid,userid,detail,image,name,hxgroupid,type) values (?,?,?,?,?,?,?)",self.loginUserid,model.userid,model.detail,model.image,model.name,hxgroupid,type]) {
        
        //如果重复插入会报错
        NSLog(@"insert error!");
        
        return;
    }
}

//查询群成员
-(NSMutableArray *)selectMembersWithHxgroupid:(NSString *)hxgroupid
{
    
    //取出当前登录用
    self.loginUserid = [[FDSUserManager sharedManager] NowUserID];
    
    //创建数组
    NSMutableArray * arr = [NSMutableArray array];
    
    
    FMResultSet * set = [_dataBase executeQuery:@"select * from Friends where loginUserid=? and hxgroupid=?",self.loginUserid,hxgroupid];
    
    while ([set next]) {
        
        //用模型取数据再将一对模型放进数组返回给那边显示出来
        FriendCellModel * model = [[FriendCellModel alloc] init];
        
        model.name = [set stringForColumn:@"name"];
        model.image = [set stringForColumn:@"image"];
        model.detail = [set stringForColumn:@"detail"];
        model.userid = [set stringForColumn:@"userid"];
        model.type = [[set stringForColumn:@"type"] intValue];//转化成int类型
        [arr addObject:model];
        
    }
    
    return arr;
    
}

//删除群成员数据
- (void)deleteGroupMemberWithHxgroupid:(NSString *)hxgroupid userid:(NSString *)userid
{
    
    //取出当前登录用
    self.loginUserid = [[FDSUserManager sharedManager] NowUserID];
    
    if (![_dataBase executeUpdate:@"delete from Friends where userid=? and loginUserid=? and hxgroupid=?",userid,self.loginUserid,hxgroupid]) {
        
        NSLog(@"delete error!");
        
        return;
        
    }
}

//删除群成员数据
- (void)deleteGroupMemberWithHxgroupid:(NSString *)hxgroupid
{
    
    //取出当前登录用
    self.loginUserid = [[FDSUserManager sharedManager] NowUserID];
    
    if (![_dataBase executeUpdate:@"delete from Friends where loginUserid=? and hxgroupid=?",self.loginUserid,hxgroupid]) {
        
        NSLog(@"delete error!");
        
        return;
        
    }
}

#pragma mark-messageIDs表格

-(void)messagidCountWithUsername:(NSString *)username{
    
    
    
}

//messageids表格数据插入
- (void)insertMessageidWithMessageid:(NSString *)messageid username:(NSString *)username
{
    
    //取出当前登录用
    self.loginUserid = [[FDSUserManager sharedManager] NowUserID];
    
    //取出数据库(某个会话对象的不能重复插入)
    NSMutableArray *messageids = [self selectMessageidsWithUsername:username];
    
    for (NSString *tempMsgId in messageids) {
        
        if ([tempMsgId isEqualToString:messageid]) {
            
            //如果重复插入会报错
            NSLog(@"messageid重复插入");
            
            //直接返回，不执行以下代码
            return;
            
        }
        
    }
    
    if (![_dataBase executeUpdate:@"insert into MessageIDs (loginUserid,messageid,username) values (?,?,?)",self.loginUserid,messageid,username]) {
        
        //如果重复插入会报错
        NSLog(@"insert error!");
        
        return;
    }
}

//查询messageids（全部）
-(NSMutableArray *)selectMessageidsWithUsername:(NSString *)username
{
    
    //取出当前登录用
    self.loginUserid = [[FDSUserManager sharedManager] NowUserID];
    
    //创建数组
    NSMutableArray * arr = [NSMutableArray array];
    
    FMResultSet * set = [_dataBase executeQuery:@"select * from MessageIDs where loginUserid=? and username=?",self.loginUserid,username];
    
    while ([set next]) {
        
        NSString *messageid = [set stringForColumn:@"messageid"];
        
        [arr addObject:messageid];
        
    }
    
    return arr;
    
}

//查询messageID（分页查询）
-(NSMutableArray *)selectPageMessageidsWithUsername:(NSString *)username start:(int)start count:(int)count
{
    
    //取出当前登录用
    self.loginUserid = [[FDSUserManager sharedManager] NowUserID];
    
    NSString *countStr = [NSString stringWithFormat:@"%d",count];
    NSString *startStr = [NSString stringWithFormat:@"%d",start];
    
    //创建数组
    NSMutableArray * arr = [NSMutableArray array];
    
    FMResultSet * set = [_dataBase executeQuery:@"select * from MessageIDs where loginUserid=? and username=? order by ID limit ? offset ?",self.loginUserid,username,countStr,startStr];
    
    while ([set next]) {
        
        NSString *messageid = [set stringForColumn:@"messageid"];
        
        [arr addObject:messageid];
        
    }
    
    return arr;
    
}


//删除某个会话对象的所有messageids
- (void)deleteMessageidWithUsername:(NSString *)username
{
    
    //取出当前登录用
    self.loginUserid = [[FDSUserManager sharedManager] NowUserID];
    
    if (![_dataBase executeUpdate:@"delete from MessageIDs where username=? and loginUserid=?",username,self.loginUserid]) {
        
        NSLog(@"delete messageids error!");
        
        return;
        
    }
}

@end
