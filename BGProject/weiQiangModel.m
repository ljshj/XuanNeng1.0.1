
//
//  weiQiangModel.m
//  BGProject
//
//  Created by zhuozhong on 14-7-24.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "weiQiangModel.h"
#import "NSDate+TL.h"

@implementation weiQiangModel


-(id)initWithDic:(NSDictionary*)dic {
    self = [super init];
    if(self) {
//        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//            [self setValue:obj forKeyPath:key]
//        }];
        
        
        int tmpid = [dic[@"weiboid"] intValue];
        self.weiboid = [@"" stringByAppendingFormat:@"%d", tmpid];
        self.fromname = dic[@"fromname"];
        self.fromuserid = dic[@"fromuserid"];
        self.name = dic[@"name"];
        self.photo = dic[@"photo"];
        self.content = dic[@"content"];
        self.date_time = dic[@"date_time"];
        self.distance = dic[@"distance"];
        self.imgs = dic[@"imgs"];
        self.comments = dic[@"comments"];

        int tmpInt = 0;
        tmpInt = [dic[@"comment_count"] intValue];
        self.comment_count = [@"" stringByAppendingFormat:@"%d",tmpInt];
        
        tmpInt = [dic[@"forward_count"] intValue];
        self.forward_count = [@"" stringByAppendingFormat:@"%d",tmpInt];
        
        tmpInt = [dic[@"share_count"] intValue];
        self.share_count = [@"" stringByAppendingFormat:@"%d",tmpInt];
        
        tmpInt =  [dic[@"like_count"] intValue];
        self.like_count =[@"" stringByAppendingFormat:@"%d",tmpInt];
        self.userid = [NSString stringWithFormat:@"%d",[dic[@"userid"] intValue]];
        
        
    }
    return self;
}

#pragma mark-实现归档

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_weiboid forKey:@"weiboid"];
    [aCoder encodeObject:_fromname forKey:@"fromname"];
    [aCoder encodeObject:_fromuserid forKey:@"fromuserid"];
    [aCoder encodeObject:_userid forKey:@"userid"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_photo forKey:@"photo"];
    [aCoder encodeObject:_distance forKey:@"distance"];
    [aCoder encodeObject:_date_time forKey:@"_date_time"];
    [aCoder encodeObject:_content forKey:@"content"];
    [aCoder encodeObject:_like_count forKey:@"like_count"];
    [aCoder encodeObject:_comment_count forKey:@"comment_count"];
    [aCoder encodeObject:_forward_count forKey:@"forward_count"];
    [aCoder encodeObject:_share_count forKey:@"share_count"];
    [aCoder encodeObject:_comments forKey:@"comments"];
    [aCoder encodeObject:_imgs forKey:@"imgs"];
    [aCoder encodeObject:[NSNumber numberWithBool:_isSearchWeiQiang] forKey:@"isSearchWeiQiang"];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    _weiboid = [aDecoder decodeObjectForKey:@"weiboid"];
    _fromname = [aDecoder decodeObjectForKey:@"fromname"];
    _fromuserid = [aDecoder decodeObjectForKey:@"fromuserid"];
    _userid = [aDecoder decodeObjectForKey:@"userid"];
    _name = [aDecoder decodeObjectForKey:@"name"];
    _photo = [aDecoder decodeObjectForKey:@"photo"];
    _distance = [aDecoder decodeObjectForKey:@"distance"];
    _date_time = [aDecoder decodeObjectForKey:@"_date_time"];
    _content = [aDecoder decodeObjectForKey:@"content"];
    _like_count = [aDecoder decodeObjectForKey:@"like_count"];
    _comment_count = [aDecoder decodeObjectForKey:@"comment_count"];
    _forward_count = [aDecoder decodeObjectForKey:@"forward_count"];
    _share_count = [aDecoder decodeObjectForKey:@"share_count"];
    _comments = [aDecoder decodeObjectForKey:@"comments"];
    _imgs = [aDecoder decodeObjectForKey:@"imgs"];
    _isSearchWeiQiang = [[aDecoder decodeObjectForKey:@"weiboid"] boolValue];
    
    
    return self;
}


-(NSString*)description {
    return [@"_weiboid:%@" stringByAppendingFormat:@"%@",_weiboid];
}

-(NSString *)content{
    
    if (_isSearchWeiQiang==YES) {
        return _content;
    }
    
    if (![_fromname isEqualToString:@""]) {
        
        NSString *newContent = [NSString stringWithFormat:@"@%@ %@",_fromname,_content];
        return newContent;
        
    }
    return _content;
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

@end
