//
//  JokeModel.m
//  BGProject
//
//  Created by ssm on 14-9-17.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "JokeModel.h"
#import "NSDate+TL.h"

@implementation JokeModel

//    "comment_count" = 0;
//    content = "\U8fd9\U662f\U4e2a\U7b11\U8bdd\U7684\U6b63\U6587:)";
//    "date_time" = "2014/9/17 18:09:10";
//    distance = "";
//    "forward_count" = 0;
//    imgs =             (
//    );
//    jokeid = 4;
//    "like_count" = 0;
//    photo = "http://114.215.189.189:80/Files/7/userinfo/small803209ba-8c25-497e-8a73-b6acd5175f11.1411634333536.jpg";
//    "rank_index" = "";
//    "share_count" = 0;
//    userid = 7;
//    username = "\U7b11\U5bf9\U4eba\U751f311";

-(id)initWithDic:(NSDictionary*)dic {
    self = [super init];
    if(self) {
        
        self.comment_count = dic[@"comment_count"];
        self.content = dic[@"content"];
        self.date_time = dic[@"date_time"];
        self.distance = dic[@"distance"];
        self.forward_count = dic[@"forward_count"];
    
        //果真是将这个数组分拆
        self.imgs= dic[@"imgs"];
        self.opartime = dic[@"opartime"];
        self.searchetype = [dic[@"searchetype"] intValue];
        self.jokeid = dic[@"jokeid"];
        self.like_count = dic[@"like_count"];
        self.photo = dic[@"photo"];
        self.rank_index = dic[@"rank_index"];
        self.share_count = dic[@"share_count"];
        self.userid = dic[@"userid"];
        self.username = dic[@"username"];
        self.imgs = dic[@"imgs"];
        self.yuanchuang = [dic[@"yuanchuang"] intValue];
        
    }
    return self;
}


-(NSNumber *)sortByID
{
    NSNumber* num = [NSNumber numberWithInteger:[_jokeid integerValue]];
    return num;
}

-(NSNumber*)sortByRandom
{
    srandom(time(0));
 
    NSNumber* num = [NSNumber numberWithInteger:random()];
    NSLog(@"num:%d",[num intValue]);
    return num;
}

-(NSString *)opartime{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDate *opartimeDate = [fmt dateFromString:_opartime];
    
    NSString *rankStr = @"";
    
    if (self.searchetype==1) {
        
        fmt.dateFormat = @"MM月dd日";
        
        rankStr = [fmt stringFromDate:opartimeDate];
        
    }else if(self.searchetype==2){
        
        fmt.dateFormat = @"MM月dd日";
        
        NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60*7 sinceDate:opartimeDate];//前七天
        
        NSString *nowStr = [fmt stringFromDate:opartimeDate];
        NSString *lastStr = [fmt stringFromDate:lastDay];
        
        rankStr = [NSString stringWithFormat:@"%@-%@",lastStr,nowStr];
        
    }else{
        
        fmt.dateFormat = @"yyyy年MM月";
        
        rankStr = [fmt stringFromDate:opartimeDate];
        
    }
    
    return rankStr;
    
}

-(NSString *)date_time{

    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDate *createDate = [fmt dateFromString:_date_time];
    if ([createDate isToday]) {
        //KK表示12小时制 HH表示24小时制
        fmt.dateFormat = @"今天 hh:mm a";
        return [fmt stringFromDate:createDate];
        
    }else if ([createDate isYesterday]){
        
        fmt.dateFormat = @"昨天 hh:mm a";
        return [fmt stringFromDate:createDate];
        
    }else if ([createDate isTheDayBeforeYesterday]){
        
        fmt.dateFormat = @"前天 hh:mm a";
        return [fmt stringFromDate:createDate];
    }else if ([createDate isThisMonth]){
        
        fmt.dateFormat = @"MM-dd hh:mm a";
        
        return [fmt stringFromDate:createDate];
    }else if ([createDate isThisYear]) { // 今年(至少是前天)
        
        fmt.dateFormat = @"MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }else{ // 非今年
        
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt stringFromDate:createDate];
    }

}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:[NSNumber numberWithBool:_jokeType] forKey:@"jokeType"];
    [aCoder encodeObject:_jokeid forKey:@"jokeid"];
    [aCoder encodeObject:_userid forKey:@"userid"];
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_photo forKey:@"photo"];
    [aCoder encodeObject:_distance forKey:@"distance"];
    [aCoder encodeObject:_date_time forKey:@"date_time"];
    [aCoder encodeObject:_opartime forKey:@"opartime"];
    [aCoder encodeObject:[NSNumber numberWithBool:_searchetype] forKey:@"searchetype"];
    [aCoder encodeObject:_rank_index forKey:@"rank_index"];
    [aCoder encodeObject:_ranking forKey:@"ranking"];
    [aCoder encodeObject:_content forKey:@"content"];
    [aCoder encodeObject:_like_count forKey:@"like_count"];
    [aCoder encodeObject:_comment_count forKey:@"comment_count"];
    [aCoder encodeObject:_forward_count forKey:@"forward_count"];
    [aCoder encodeObject:_share_count forKey:@"share_count"];
    [aCoder encodeObject:_imgs forKey:@"imgs"];
    
    
    
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    _jokeType = [[aDecoder decodeObjectForKey:@"jokeType"] intValue];
    _jokeid = [aDecoder decodeObjectForKey:@"jokeid"];
    _userid = [aDecoder decodeObjectForKey:@"userid"];
    _username = [aDecoder decodeObjectForKey:@"username"];
    _photo = [aDecoder decodeObjectForKey:@"photo"];
    _distance = [aDecoder decodeObjectForKey:@"distance"];
    _date_time = [aDecoder decodeObjectForKey:@"date_time"];
    _opartime = [aDecoder decodeObjectForKey:@"opartime"];
    _searchetype = [[aDecoder decodeObjectForKey:@"searchetype"] intValue];
    _rank_index = [aDecoder decodeObjectForKey:@"rank_index"];
    _ranking = [aDecoder decodeObjectForKey:@"ranking"];
    _content = [aDecoder decodeObjectForKey:@"content"];
    _like_count = [aDecoder decodeObjectForKey:@"like_count"];
    _comment_count = [aDecoder decodeObjectForKey:@"comment_count"];
    _forward_count = [aDecoder decodeObjectForKey:@"forward_count"];
    _share_count = [aDecoder decodeObjectForKey:@"share_count"];
    _imgs = [aDecoder decodeObjectForKey:@"imgs"];
    
    return self;
    
}

@end
