//
//  ChatCell.m
//  BubbleChat
//


#import "ChatCell.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "EaseMob.h"
#import "NSString+TL.h"

#define removeGifViewKey @"removeGifView"

//根据方向决定放那个gif图
#define RightDirection  @"right"
#define LeftDirection  @"left"

@interface ChatCell()<EMChatManagerDelegate>

@end

@implementation ChatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //背景颜色
        self.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
        
        //初始化子控件
        [self makeView];
        
        //注册环信代理接收消息
        [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
        
        
        
    }
    return self;
}

-(void)setChatItemFrame:(ChatItemFrame *)chatItemFrame{
    
    _chatItemFrame = chatItemFrame;
    
    //取出模型
    ChatItem *item = _chatItemFrame.item;
    
    if (item.isSelf) {
        
        //YES和NO确定左右冒泡是否隐藏
        _leftBubble.hidden = YES;
        _leftIconVIew.hidden = YES;
        
        _rightBubble.hidden = NO;
        _rightIconVIew.hidden = NO;
        
        //赋值
        _rightLabel.text = item.content;
        
        //根据内容长度调整标签和气泡的坐标
        _rightIconVIew.frame = chatItemFrame.rightIconFrame;
        [_rightIconVIew setImageWithURL:[NSURL URLWithString:[NSString setupSileServerAddressWithUrl:item.icon]] placeholderImage:[UIImage imageNamed:@"headphoto_s"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
        _rightLabel.frame = chatItemFrame.rightLabelFrame;
        _rightThumView.frame = chatItemFrame.rightThumFrame;
        _rightThumView.image=[UIImage imageWithContentsOfFile:item.localPath];
        _rightBubble.frame = chatItemFrame.rightBubbleFrame;
        _rightVoiceButton.frame = chatItemFrame.rightVoiceFrame;
        
    } else {
        
        _leftBubble.hidden = NO;
        _leftIconVIew.hidden = NO;
        _rightBubble.hidden = YES;
        _rightIconVIew.hidden = YES;
        
        _leftLabel.text = item.content;
        NSString *placeholder = nil;
        if ([item.userid isEqualToString:@"0"]) {
            placeholder = @"logo";//小秘书的头像
        }else{
            placeholder = @"headphoto_s";
        }
        _leftIconVIew.frame = chatItemFrame.leftIconFrame;
        [_leftIconVIew setImageWithURL:[NSURL URLWithString:[NSString setupSileServerAddressWithUrl:item.icon]] placeholderImage:[UIImage imageNamed:placeholder] options:SDWebImageRetryFailed | SDWebImageLowPriority];
        _leftLabel.frame = chatItemFrame.leftLabelFrame;
        _leftThumView.frame=chatItemFrame.leftThumFrame;
        _leftThumView.image = [UIImage imageWithContentsOfFile:item.localPath];
        _leftBubble.frame = chatItemFrame.leftBubbleFrame;
        _leftVoiceButton.frame = chatItemFrame.leftVoiceFrame;
        
    }
    
}

//返回一个拉伸过后的气泡
-(UIImage *)imageWithName:(NSString *)name{
    
    UIImage *image = [UIImage imageNamed:name];
    //在35行35列像素上面进行拉伸
    image = [image stretchableImageWithLeftCapWidth:35 topCapHeight:35];
    return image;
}

//返回一个气泡
-(UIImageView *)bubbleWithImage:(UIImage *)image{
    
    UIImageView *bubble = [[UIImageView alloc] init];
    bubble.userInteractionEnabled = YES;
    bubble.image = image;
    //在返回之前已经添加到cell上面去了
    [self.contentView addSubview:bubble];
    return bubble;
    
}

//返回一个标签
-(UILabel *)chatlLabel{
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14.0];
    label.numberOfLines = 0;
    return label;
}

//返回一个头像
-(UIImageView *)iconWithImage:(NSString *)name{
    
    UIImageView *iconView = [[UIImageView alloc] init];
    
    //设置圆角
    CGFloat radius = 5;
    [iconView.layer setCornerRadius:radius];
    [iconView.layer setMasksToBounds:YES];
    
    //开启用户交互
    iconView.userInteractionEnabled = YES;
    
    //添加手势
    [iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personTap)]];
    [self.contentView addSubview:iconView];
    return iconView;
    
}

//头像被点击
-(void)personTap{
    
    if ([self.delegate respondsToSelector:@selector(chatCellPersontapWithUserid:)]) {
        
        //返回userid
        [self.delegate chatCellPersontapWithUserid:self.chatItemFrame.item.userid];
        
    }
    
}

//返回一个预览图
-(UIImageView *)thumView{
    
    UIImageView *thumView = [[UIImageView alloc] init];
    thumView.userInteractionEnabled = YES;
    //添加手势
    [thumView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
    return thumView;
    
}

//返回一个语音按钮
-(UIButton *)voiceButton{
    
    UIButton *voiceButton = [[UIButton alloc] init];
    [voiceButton setBackgroundImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    [voiceButton addTarget:self action:@selector(voiceButtonClick) forControlEvents:UIControlEventTouchUpInside];
    return voiceButton;
    
}


-(void)makeView{
    
    //初始化气泡图片
    UIImage *leftImage = [self imageWithName:@"chatBubble_left.png"];
    UIImage *rightImage = [self imageWithName:@"chatBubble_right.png"];
    
    //左边气泡
    self.leftBubble = [self bubbleWithImage:leftImage];
    
    //左边标签
    self.leftLabel = [self chatlLabel];
    [self.leftBubble addSubview:self.leftLabel];
    
    //右边气泡
    self.rightBubble = [self bubbleWithImage:rightImage];
   
    //右边标签
    self.rightLabel = [self chatlLabel];
    [self.rightBubble addSubview:self.rightLabel];
    
    //右边头像
    self.rightIconVIew=[self iconWithImage:@"rightIcon"];
    
    
    //左边头像
    self.leftIconVIew=[self iconWithImage:@"leftIcon"];
    
    //左边预览图
    self.leftThumView = [self thumView];
    [self.leftBubble addSubview:self.leftThumView];
    
    //右边预览图
    self.rightThumView = [self thumView];
    [self.rightBubble addSubview:self.rightThumView];
    
    //左边语音按钮
    self.leftVoiceButton = [self voiceButton];
    [self.leftBubble addSubview:self.leftVoiceButton];
    
    //右边语音按钮
    self.rightVoiceButton = [self voiceButton];
    [self.rightBubble addSubview:self.rightVoiceButton];
    
    
}

//语音按钮被点击
-(void)voiceButtonClick{
    
    //注册通知(当一个语音点击的时候通知其他cell要将GIF图删掉)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeGifView)
                                                 name:removeGifViewKey object:nil];
    
    //取出模型
    ChatItem *item = self.chatItemFrame.item;
    
    if (item.isSelf) {
        
        //改变按钮的状态
        self.rightVoiceButton.hidden=YES;
        self.rightGifView = [self creatGifViewWithDirection:RightDirection];
        [self.rightGifView setFrame:self.rightVoiceButton.frame];
        [self.rightBubble addSubview:self.rightGifView];
        
    }else{
        
        //改变按钮的状态
        self.leftVoiceButton.hidden=YES;
        
        self.leftGifView = [self creatGifViewWithDirection:LeftDirection];
        [self.leftGifView setFrame:self.leftVoiceButton.frame];
        [self.leftBubble addSubview:self.leftGifView];
        
    }
    
    //播放器是否在运行
    BOOL isPlayingAudio = [[EaseMob sharedInstance].chatManager isPlayingAudio];
    
    if (isPlayingAudio) {
        
        //停止播放语音
        [[EaseMob sharedInstance].chatManager stopPlayingAudio];
        
        //发送通知
        [[NSNotificationCenter defaultCenter]
         postNotificationName:removeGifViewKey object:nil];
        
        
    }
    
    //播放语音
    [[EaseMob sharedInstance].chatManager asyncPlayAudio:item.voice];

}

//创建播放语音的GIF图
-(OLImageView *)creatGifViewWithDirection:(NSString *)direction{
    
    //根据方向决定gif文件名
    
    NSString *gifname = nil;
    
    if ([direction isEqualToString:RightDirection]) {
        
        gifname = @"voicePlayingRight";
        
    }else{
        
        gifname = @"voicePlayingLeft";
        
    }
    
    OLImageView *gifView = [OLImageView new];
    gifView.userInteractionEnabled=YES;
    [gifView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGif:)]];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:gifname ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:filePath];
    gifView.image = [OLImage imageWithData:gifData];

    return gifView;
}

//gif点击
-(void)tapGif:(UITapGestureRecognizer *)tap{
    
    //停止播放语音
    [[EaseMob sharedInstance].chatManager stopPlayingAudio];
    
    //将gif图移除
    [self removeGifView];
    
}

//语音播放完毕回调
-(void)didPlayAudio:(EMChatVoice *)aChatVoice error:(NSError *)error{
    
    //将gif图移除
    [self removeGifView];
    
}

//将gif图移除
-(void)removeGifView{
    
    //改变按钮的状态
    self.rightVoiceButton.hidden=NO;
    self.leftVoiceButton.hidden=NO;
    
    //移除GIF图(除了从父视图移除还要将其设置为nil才真正释放内存，以前的代码有很多要修改)
    [self.rightGifView removeFromSuperview];
    self.rightGifView=nil;
    [self.leftGifView removeFromSuperview];
    self.leftGifView=nil;
    
    //删除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:removeGifViewKey object:nil];
    
}

//预览图被点击
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    
    int count = 1;
    
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    
    UIImageView *tapView = (UIImageView *)tap.view;
    
    for (int i = 0; i<count; i++)
    {
        MJPhoto *photo = [[MJPhoto alloc] init];
        
        //第一个是添加按钮，所以i+1
        photo.srcImageView = tapView;//来源于哪个UIImageView
        photo.image = tapView.image;
        [photos addObject:photo];
        
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; //弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    
}

@end
