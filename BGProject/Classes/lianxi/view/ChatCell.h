//
//  ChatCell.h
//  BubbleChat
//


#import <UIKit/UIKit.h>
#import "ChatItemFrame.h"
#import "OLImageView.h"
#import "OLImage.h"

@protocol ChatCellDelegate <NSObject>

@optional

/**
 *头像被点击
 */
-(void)chatCellPersontapWithUserid:(NSString *)userid;

@end

@interface ChatCell : UITableViewCell

/**
 *代理
 */
@property(nonatomic,weak) id<ChatCellDelegate> delegate;

//坐标
@property(nonatomic,strong) ChatItemFrame *chatItemFrame;

//左边气泡
@property(nonatomic,strong) UIImageView *leftBubble;

//左边文本
@property(nonatomic,strong) UILabel *leftLabel;

//右边气泡
@property(nonatomic,strong) UILabel *rightLabel;

//右边文本
@property(nonatomic,strong) UIImageView *rightBubble;

//左边头像
@property(nonatomic,strong) UIImageView *leftIconVIew;

//右边头像
@property(nonatomic,strong) UIImageView *rightIconVIew;

//左边预览图
@property(nonatomic,strong) UIImageView *leftThumView;

//右边预览图
@property(nonatomic,strong) UIImageView *rightThumView;

//左边语音按钮
@property(nonatomic,strong) UIButton *leftVoiceButton;

//右边语音按钮
@property(nonatomic,strong) UIButton *rightVoiceButton;

//左边gif图
@property(nonatomic,strong) OLImageView *leftGifView;

//右边gif图
@property(nonatomic,strong) OLImageView *rightGifView;

@end
