//
//  ChatTooBar.m
//  BGProject
//
//  Created by liao on 14-12-17.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ChatTooBar.h"
#import "RecordView.h"

#define ToobarSubviewMargin 10
#define InputViewBorderColor [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0]
#define PlaceholderColor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]
#define Placeholder @"请输入消息"
#define RecordButtonBg [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0]
#define RecordLongPressTitle @"按住录音"
#define RecordLongPublishTitle @"松开发送"
#define RecordViewTag 102

@interface ChatTooBar()<UITextViewDelegate>
/**
 *输入框占位标签
 */
@property (nonatomic, weak) UILabel *placeholderLab;
/**
 *语音按钮
 */
@property (nonatomic, weak) UIButton *voiceButton;
/**
 *录音按钮
 */
@property (nonatomic, weak) UIButton *recordButton;
/**
 *表情按钮
 */
@property (nonatomic, weak) UIButton *faceButton;
/**
 *更多按钮
 */
@property (nonatomic, weak) UIButton *moreButton;


@end

@implementation ChatTooBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        
        //语音按钮
        UIButton *voiceButton = [[UIButton alloc] init];
        [voiceButton setBackgroundImage:[UIImage imageNamed:@"聊天语音_31"] forState:UIControlStateNormal];
        [voiceButton setBackgroundImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateSelected];
        [voiceButton addTarget:self action:@selector(voiceButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:voiceButton];
        self.voiceButton = voiceButton;
        
        //输入框
        UITextView *inputView = [[UITextView alloc] init];
        inputView = [self setBorderRadiusWithView:inputView];//设置圆角
        inputView.delegate=self;
        inputView.font = [UIFont systemFontOfSize:14.0];
        inputView.returnKeyType=UIReturnKeySend;//设置return
        inputView.enablesReturnKeyAutomatically = YES;
        ;
        [self addSubview:inputView];
        self.inputView = inputView;
        
        //输入框占位标签
        UILabel *placeholderLab = [[UILabel alloc] initWithFrame:CGRectMake(6, 6, 100, 20)];
        placeholderLab.text = Placeholder;
        placeholderLab.font=[UIFont systemFontOfSize:14.0];
        placeholderLab.textColor = PlaceholderColor;
        [self.inputView addSubview:placeholderLab];
        self.placeholderLab=placeholderLab;
        
        //录音按钮
        UIButton *recordButton = [[UIButton alloc] init];
        recordButton.hidden = YES;//一开始隐藏起来
        recordButton.backgroundColor = RecordButtonBg;
        [recordButton setTitle:RecordLongPressTitle forState:UIControlStateNormal];
        recordButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [recordButton addTarget:self action:@selector(recordButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        
        //添加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(recordButtonLongPress:)];
        [recordButton addGestureRecognizer:longPress];
        
        //添加拖动手势
        UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [recordButton addGestureRecognizer:pan];
        
        //拖动失败之后才会执行长按
        [longPress requireGestureRecognizerToFail:pan];
        
        [self addSubview:recordButton];
        self.recordButton = recordButton;
        
        //表情按钮
        UIButton *faceButton = [[UIButton alloc] init];
        [faceButton setBackgroundImage:[UIImage imageNamed:@"聊天表情_33"] forState:UIControlStateNormal];
        [faceButton setBackgroundImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateSelected];
        [faceButton addTarget:self action:@selector(faceButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:faceButton];
        self.faceButton = faceButton;
        
        //更多按钮
        UIButton *moreButton = [[UIButton alloc] init];
        [moreButton setBackgroundImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
        [moreButton setBackgroundImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateSelected];
        [moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:moreButton];
        self.moreButton = moreButton;
        
        
    }
    return self;
}

//录音按钮被点击
-(void)recordButtonTouchDown{
    
    //添加录音按钮
    [self addRecordView];
    
    BOOL isBegin;
    
    if ([self.delegate respondsToSelector:@selector(didClickRecordButtonWithStaus:)]) {
        
        [self.recordButton setTitle:RecordLongPublishTitle forState:UIControlStateNormal];
        
        isBegin = YES;
        
        //返回输入框文本
        [self.delegate didClickRecordButtonWithStaus:isBegin];
        
        
    }
    
}

//录音按钮拖动手势
-(void)pan:(UIPanGestureRecognizer *)pan{
    
    //将语音图删除
    [self removeRecordView];
    
    //修改按钮标题
    [self.recordButton setTitle:RecordLongPressTitle forState:UIControlStateNormal];
    
    //回调
    if ([self.delegate respondsToSelector:@selector(didCancelRecord)]) {
        
        
        [self.delegate didCancelRecord];
        
        
    }
    
}

-(void)moreButtonClick{
    
    //改变其他按钮的状态
    self.voiceButton.selected = NO;
    self.faceButton.selected= NO;
    self.recordButton.hidden = YES;
    
    self.moreButton.selected = !self.moreButton.selected;
    
    if ([self.delegate respondsToSelector:@selector(didClickMoreButtonWithStaus:)]) {
        
        //返回输入框文本
        [self.delegate didClickMoreButtonWithStaus:self.moreButton.selected];
        
        
    }
    
}

//添加语音图
-(void)addRecordView{
    
    RecordView *recordView = [[RecordView alloc] init];
    recordView.tag = RecordViewTag;
    CGFloat recordViewW = 120;
    CGFloat recordViewX = (self.frame.size.width-recordViewW)*0.5;
    CGFloat recordViewH = recordViewW+10;
    CGFloat recordViewY = self.recordButton.frame.origin.y-recordViewH-50;
    recordView.frame = CGRectMake(recordViewX, recordViewY, recordViewW, recordViewH);
    [self addSubview:recordView];
    
}

//删除语音图
-(void)removeRecordView{
    
    UIView *recordView = [self viewWithTag:RecordViewTag];
    [recordView removeFromSuperview];
    recordView = nil;
    
}

//录音按钮长按手势触发
-(void)recordButtonLongPress:(UILongPressGestureRecognizer *)longPress{
    
    BOOL isBegin;
    
    if ([longPress state] == UIGestureRecognizerStateEnded){
        
        //将语音图删除
        [self removeRecordView];
        
        if ([self.delegate respondsToSelector:@selector(didClickRecordButtonWithStaus:)]) {
            
            [self.recordButton setTitle:RecordLongPressTitle forState:UIControlStateNormal];
            
            isBegin = NO;
            
            //返回输入框文本
            [self.delegate didClickRecordButtonWithStaus:isBegin];
            
            
        }
        
    }
    
}

//语音按钮被点击
-(void)voiceButtonClick{
    
    //改变其他按钮的状态
    self.faceButton.selected = NO;
    self.moreButton.selected = NO;
    
    //切换状态
    self.voiceButton.selected =!self.voiceButton.selected;
    
    
    if (self.voiceButton.selected) {
        
        //将录音按钮显示出来
        self.recordButton.hidden = NO;
        
        //如果此时是第一响应者将键盘放下去
        if ([self.inputView isFirstResponder]) {
            
            [self.inputView resignFirstResponder];
            
        }
        
    }else{
        
        self.recordButton.hidden = YES;
        
        [self.inputView becomeFirstResponder];
        
        
    }

}

//表情按钮被点击
-(void)faceButtonClick{
    
    //先将语音按钮改变状态
    self.voiceButton.selected = NO;
    
    //改变更多按钮的状态
    self.moreButton.selected = NO;
    
    //再将录音按钮隐藏起来
    self.recordButton.hidden = YES;
    
    //切换状态
    self.faceButton.selected =!self.faceButton.selected;
    
    if ([self.delegate respondsToSelector:@selector(didClickFaceButtonWithStaus:)]) {
        
        //返回输入框文本
        [self.delegate didClickFaceButtonWithStaus:self.faceButton.selected];
    
        
    }
    
}

//设置输入框圆角
-(UITextView *)setBorderRadiusWithView:(UITextView *)view{
    
    view.layer.borderWidth = 1;
    view.layer.borderColor = InputViewBorderColor.CGColor;
    CGFloat radius = 5;
    [view.layer setCornerRadius:radius];
    [view.layer setMasksToBounds:YES];
    
    return view;
    
}

-(void)layoutSubviews{
    
    //按钮的按钮的宽高
    CGFloat buttonWH = 34;
    
    //toobar的高度
    CGFloat toobarH = self.bounds.size.height;
    
    //语音
    CGFloat voiceButtonY = (toobarH-buttonWH)/2;
    self.voiceButton.frame = CGRectMake(ToobarSubviewMargin, voiceButtonY, buttonWH, buttonWH);

    //更多
    CGFloat moreButtonX = kScreenWidth-buttonWH-ToobarSubviewMargin;
    self.moreButton.frame = CGRectMake(moreButtonX, voiceButtonY, buttonWH, buttonWH);
    
    //表情
    CGFloat faceButtonX = moreButtonX-buttonWH-ToobarSubviewMargin;
    self.faceButton.frame = CGRectMake(faceButtonX, voiceButtonY, buttonWH, buttonWH);
    
    //输入框
    CGFloat inputViewX = CGRectGetMaxX(self.voiceButton.frame)+ToobarSubviewMargin;
    CGFloat inputViewW = faceButtonX-inputViewX-ToobarSubviewMargin;
    self.inputView.frame = CGRectMake(inputViewX, voiceButtonY, inputViewW, buttonWH);
    
    //录音按钮
    self.recordButton.frame = self.inputView.frame;

}


#pragma mark-UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.placeholderLab.text = Placeholder;
    }
    else
    {
        self.placeholderLab.text = @"";
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    //判断输入的字是否是回车，即按下return
    if ([text isEqualToString:@"\n"]){
        
        if ([self.delegate respondsToSelector:@selector(didSendMessage:)]) {
            
            //将键盘放下去
            [self.inputView resignFirstResponder];
            
            //返回输入框文本
            [self.delegate didSendMessage:self.inputView.text];
            
            //清空文本
            self.inputView.text = @"";
            
            //设置占位文本
            self.placeholderLab.text = Placeholder;
            
        }
        
        //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        return NO;
    }
    
    return YES;
}

//将文本清空并且设置占位文本
-(void)clearInputViewText{
    
    self.inputView.text = @"";
    self.placeholderLab.text=Placeholder;
    
}

-(void)setupPlaceholder{
    
    self.placeholderLab.text=Placeholder;
    
}

-(void)clearInputViewPlaceholder{
    
    self.placeholderLab.text = @"";
    
}

@end
