//
//  MoudleMessageInterface.h
//  BGProject
//
//  Created by zhuozhongkeji on 14-9-16.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AD_ATHumorModel.h"

@protocol MoudleMessageInterface <NSObject>

@optional
#pragma mark 微墙
//################微墙模块#####################
//获取微墙列表
-(void)weiQiangListCB:(NSArray*)result;

//获取与我相关
-(void)beRelatedToMeCB:(NSArray *)result;

//获取内容详情
-(void)contentDetailsCB:(NSDictionary*)result;


//发布微博
-(void)issueWeiBoAtWeiQiangCB:(int)result;

//删除微博
-(void)deleteWeiBoAtWeiQiangCB:(int)result;

// 转发微博
-(void)relayWeiBoAtWeiQiangCB:(int)result;

//分享微博
-(void)shareWeiBoCB:(int)result;

//用户评论  微博
-(void)submitCommentAtWeiQiangCB:(int)result;

//微墙中 用户点赞
-(void)submitSupportAtWeiQiangCB:(int)result;


#pragma mark 炫能
//################炫能模块#####################
// 获取笑话列表（随机或者顺序）
-(void)requestJokeListCB:(NSArray*)result;
/**
 *获取与我相关(炫能)
 */
-(void)beRelatedToMeXuanNengCB:(NSArray *)result;
// 获取排行榜
//，参考文档，提交的参数是 日、周、月、年 0 1 2 3
-(void)requestChartsCB:(NSArray*)result;

//排行榜
-(void)requestChartsListCB:(NSArray*)result;

//获取未审核内容
-(void)requestUnauditedContentCB:(NSArray *)result;

//审核提交
-(void)contentApprovalCB:(int)result;

// 投稿
-(void)submitTopicCB:(int)result;

//转发到微博
-(void)relayToWeiBoAtXuanNengCB:(int)result;
//分享到其他平台
-(void)shareJokeAtXuanNengCB:(int)result;

//用户评论  笑话id 评论内容
-(void)submitCommentAtXuanNengCB:(int)result;

//用户点赞
-(void)submitSupportAtXuanNengCB:(int)result;

//70011 870011 删除投稿
-(void)requestDeleteTopicCB:(int)result;




//获取投稿列表	0x00070008	"//包括关注和非关注
//<type/>//0，所有；1：审核
//<start/>//请求从第几条
//<end/>//到第几条
-(void)requestSubmittedTopicListCB:(NSArray*)result;
//查看笑话
-(void)requestJokeCB:(NSDictionary*)result;


//获取幽默秀广告
-(void)requestAD_AtHumourCB:(NSArray*)result;
@end
