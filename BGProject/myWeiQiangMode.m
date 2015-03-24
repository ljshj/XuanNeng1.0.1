



//
//  myWeiQiangMode.m
//  BGProject
//
//  Created by zhuozhong on 14-8-4.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "myWeiQiangMode.h"

@implementation myWeiQiangMode
- (instancetype)init
{
    self = [super init];
    if (self) {
        _imgArr = [NSMutableArray array];
    }
    return self;
}

//计算内容大小
- (void)setContentStr:(NSString *)contentStr
{
    if (_contentStr != contentStr) {
        _contentStr = contentStr;
        
        _contentSize = [_contentStr sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(310, 2000)];
    }
}
//计算图片大小
- (void)setImgArr:(NSMutableArray *)imgArr
{
    if (_imgArr != imgArr) {
        _imgArr = nil;
        _imgArr = imgArr;
        
        int _numOfPic = _imgArr.count;
        if (_numOfPic == 0) {
            _imgHeight = 0;
        }else if (_numOfPic >= 1 && _numOfPic <= 3){
            _imgHeight = 100;
        }else if (_numOfPic > 3 && _numOfPic <= 6){
            _imgHeight = 200;
        }else{
            _imgHeight = 300;
        }
    }
}
@end
