//
//  FirstViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController
{
    //声明一堆命名不规范的成员变量
    UIView *topView,*BootView,*MoveView;
    UILabel *label1,*label2,*label3,*label4;
    UIButton *TopLeftButton,*TopMiddleButton,*TopRightButton,*btnChageBig1,
    *btnChageBig2,*label5,*label6,*label7,*label8,*thinkBtn,*canBtn;
    
    UIImageView *imageView1,*imgView1,*imgView2,*imageView2,*MyThinkView,*MyCanView,*tanChuView;
    
    BOOL _isClick;
}

//搜索类型（我能or我想）
@property(nonatomic,assign)SearchType searchType;

@end
