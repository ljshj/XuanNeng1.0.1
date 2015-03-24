//
//  HistoryTableView.m
//  BGProject
//
//  Created by liao on 14-10-24.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "HistoryTableView.h"

@implementation HistoryTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//截获事件，将键盘放下去
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_tf resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
}
@end
