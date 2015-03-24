//
//  BGUploadImageView.h
//  BGProject
//
//  Created by liao on 14-11-1.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BGUploadImageViewDelegate <NSObject>

@optional

-(void)didSelectedDeleteButtonWithIndex:(NSInteger)index;

@end

@interface BGUploadImageView : UIImageView

@property(weak,nonatomic) id<BGUploadImageViewDelegate>delegate;

@end
