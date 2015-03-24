//
//  NSString+TL.m
//  BGProject
//
//  Created by liao on 14-10-24.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "NSString+TL.h"
#import "ZZSessionManager.h"
#import "ZZUserDefaults.h"

@implementation NSString (TL)

+(NSString *)pathwithFileName:(NSString *)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = paths[0];
    NSString *historyPath = [documentPath stringByAppendingPathComponent:fileName];
    return historyPath;
}

+(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
}

//MD5加密
+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//拼接文件服务器地址
+(NSString *)setupSileServerAddressWithUrl:(NSString *)url{
    
    if ([url hasPrefix:@"http"]) {
        
        return url;
        
    }
    
    //取出文件服务器地址
    NSString *fileServerAddress = [ZZSessionManager sharedSessionManager].fileServerAddress;
    
    //尼玛的，被害死了，还以为怎么会缓存不了的，是这个文件服务器地址之前没有存起来
    if (!fileServerAddress) {
        
        fileServerAddress = [ZZUserDefaults getUserDefault:FserverKey];
        
    }
    
    NSString *tempUrl = [NSString stringWithFormat:@"%@%@",fileServerAddress,url];
    
    return tempUrl;
    
}

@end
