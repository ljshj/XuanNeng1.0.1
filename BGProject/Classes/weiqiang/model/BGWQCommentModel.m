//
//  BGWQCommentModel.m
//  BGProject
//
//  Created by liao on 14-11-4.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "BGWQCommentModel.h"
#import "NSDate+TL.h"

@implementation BGWQCommentModel

+(instancetype)commentWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithDict:dic];
}

-(instancetype)initWithDict:(NSDictionary *)dic{
    if (self = [super init]) {
        //KVC
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(NSString *)commenttime{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDate *createDate = [fmt dateFromString:_commenttime];
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
