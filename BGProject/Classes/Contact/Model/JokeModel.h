//
//  JokeModel.h
//  BGProject
//
//  Created by ssm on 14-9-17.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

// 定义评论类型
typedef enum {
    JokeTypeNormal,
    JokeTypeRankList,//榜单
    JokeTypeRank,//排行榜
    JokeTypeMyHumorousShow,//排行榜
}JokeType;

@interface JokeModel : NSObject

/**
 *模型的类型（榜单／排行榜／我的幽默秀）
 */
@property(nonatomic,assign) JokeType jokeType;

@property(nonatomic,retain)NSString* jokeid;//笑话ID
@property(nonatomic,retain)NSString* userid;//用户ID
@property(nonatomic,retain)NSString* username;//用户名

@property(nonatomic,retain)NSString* photo;//头像
@property(nonatomic,retain)NSNumber* distance;//距离
@property(nonatomic,retain)NSString* date_time;//创建时间
@property(nonatomic,retain)NSString* opartime;//获奖时间
/**
 *榜单搜索类型（1:日榜单2:周榜单3:月榜单）
 */
@property(nonatomic,assign) int searchetype;
@property(nonatomic,retain)NSString* rank_index;//排名
@property(nonatomic,retain)NSString* ranking;//榜单排名
//@property(nonatomic,assign)int xnid;
@property(nonatomic,retain)NSString* content;//笑话内容

//不会想将图片数组分成两个数组吧？
@property(nonatomic,retain)NSMutableArray* imgURLs;
@property(nonatomic,retain)NSMutableArray* imgThumURLs;


@property(nonatomic,retain)NSString* like_count;    //赞数
@property(nonatomic,retain)NSString* comment_count; // 评论数
@property(nonatomic,retain)NSString* forward_count; // 转发数
@property(nonatomic,retain)NSString* share_count;   // 分享数
@property(nonatomic,retain) NSArray *imgs;//图片数组
@property(nonatomic,assign) int yuanchuang;//是否是原创

-(NSNumber*)sortByID;

-(NSNumber*)sortByRandom;


//包含 CommentModel
@property(nonatomic,retain)NSArray*  commentsArr;
-(id)initWithDic:(NSDictionary*)dic;
@end
