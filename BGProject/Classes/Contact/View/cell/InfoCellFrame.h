//
//  InfoCellFrame.h
//  BGProject
//
//  Created by ssm on 14-8-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "BaseCellFrame.h"
#import "InfoCellModel.h"


#define kDateFont [UIFont systemFontOfSize:9]

@interface InfoCellFrame : BaseCellFrame

//父类里面有基础model了，所以子类这里不需要再设置一个model了
//@property(nonatomic,retain)InfoCellModel* infoCellModel;

@property(nonatomic,assign)CGRect dateFrame;


@end
