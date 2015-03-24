//
//  NSString+TL.h
//  BGProject
//
//  Created by liao on 14-10-24.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#define WeiQiangCacheKey @"WeiQiangCache"
#define XuanNengCacheKey @"XuanNengCache"

@interface NSString (TL)
+(NSString *)pathwithFileName:(NSString *)fileName;
+(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;
+(NSString *)md5:(NSString *)str;
+(NSString *)setupSileServerAddressWithUrl:(NSString *)url;
@end
