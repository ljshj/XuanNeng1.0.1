//
//  MoudleMessageManager.h
//  BGProject
//
//  Created by zhuozhongkeji on 14-9-16.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ZZMessageManager.h"
#import "MoudleMessageInterface.h"
#import "ZZSessionManager.h"
@interface MoudleMessageManager : ZZMessageManager
/**
 *榜单的排名
 */
@property(nonatomic,assign) int ranking;

+ (MoudleMessageManager*)sharedManager;
- (void)registerObserver:(id<MoudleMessageInterface>)observer;
- (void)unRegisterObserver:(id<MoudleMessageInterface>)observer;


#pragma mark 微墙
//################微墙模块#####################
//获取微墙列表
-(void)WeiQiangList:(int)type
                    start:(int)start
                end:(int)end userid:(int)userid;
//获取与我相关（微墙）
-(void)beRelatedToMeWithStart:(int)start end:(int)end;

//获取内容详情
-(void)requestContentDetailsAtWeiQiang:(int)weiboid
                     :(int)comment_start
                     :(int)comment_end;


//发布微博
-(void)issueWeiBoAtWeiQiang:(NSString*)content img:(NSString*)img img_thum:(NSString*)img_thum longitude:(CGFloat)longitude latitude:(CGFloat)latitude;


// 发送有多个图片的微博 2014年10月13日
-(void)issueWeiBoAtWeiQiangWithContent:(NSString*)content imageUrls:(NSArray*)imageUrls longitude:(CGFloat)longitude latitude:(CGFloat)latitude;


//删除微博
-(void)deleteWeiBoAtWeiQiang:(int)weiboid;

// 转发微博
-(void)relayWeiBoAtWeiQiang:(int)weiboid comments:(NSString *)comments;

//分享微博
-(void)shareWeiBoAtWeiQiang:(int)weiboid;

//用户评论  微博
-(void)submitCommentAtWeiQiang:(int)itemid :(NSString*)comments;

//微墙中 用户点赞
-(void)submitSupportAtWeiQiang:(int)itemID;


#pragma mark 炫能
//################炫能模块#####################
// 获取笑话列表
-(void)requestJokeListWithItemid:(int)itemid type:(int)type start:(int)start end:(int)end;
/**
 *获取与我相关（炫能）
 */
-(void)beRelatedToMeXuanNengWithStart:(int)start end:(int)end;

// 获取排行榜
//参考文档，提交的参数是 日、周、月、年 依次是0 1 2 3
-(void)requestCharts:(int)itemid :(int)rank_type :(int)start :(int)end;

//获取榜单
-(void)requestChartsList:(int)itemid :(int)type :(int)start :(int)end;

// 投稿（无图片）
-(void)submitTopic:(NSString*)content img:(NSString*)img img_thum:(NSString*)img_thum itemId:(NSInteger)itemId longitude:(CGFloat)longitude latitude:(CGFloat)latitude;

//发送多个图片的投稿
-(void)submitTopic:(NSString *)content imageUrls:(NSArray*)imageUrls itemId:(NSInteger)itemId longitude:(CGFloat)longitude latitude:(CGFloat)latitude;

//删除投稿	0x00070011
// 投稿
-(void)requestDeleteTopic:(int)xnid;
//转发到微博
-(void)relayToWeiBoAtXuanNeng:(int)itemid comments:(NSString *)comments;
//分享到其他平台
-(void)shareJokeAtXuanNeng:(int)itemid;

//用户评论  笑话id 评论内容
-(void)submitCommentAtXuanNeng:(int)itemid :(NSString*)comments ;

//用户点赞
-(void)submitSupportAtXuanNeng:(int)itemID;


//获取投稿列表	0x00070008	"//包括关注和非关注
//<type/>//0，所有；1：审核
//<start/>//请求从第几条
//<end/>//到第几条
-(void)requestSubmittedTopicList:(int)type start:(int)start end:(int)end userid:(NSString *)userid;

//查看笑话
-(void)requestJoke:(NSString*)itemID
                  :(int)comment_start
                  :(int)comment_end;



//获取幽默秀广告
-(void)requestAD_AtHumour;

/**
 *会员审核
 */
-(void)contentApprovalWithItemid:(int)itemid type:(int)type;

/**
 *获取未审核内容
 */
-(void)requestUnauditedContentWithItemid:(int)itemid type:(int)type start:(int)start end:(int)end maxxnid:(int)maxxnid;

@end
