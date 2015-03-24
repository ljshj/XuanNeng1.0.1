//
//  ChatItem.h
//  BubbleChat
//


#import <Foundation/Foundation.h>
#import "EMChatVoice.h"

//定义消息类型
typedef enum {
    TypeText,
    TypeImage,
    TypeVoice
}Type;

@interface ChatItem : NSObject
/**
 *userid，点击头像要传出去的
 */
@property(nonatomic,copy) NSString *userid;
//头像
@property(nonatomic,copy) NSString *icon;

//内容
@property(nonatomic,copy) NSString *content;

//预览图的远程服务器路径
@property(nonatomic,copy) NSString *thumbnailRemotePath;

//预览图的远程服务器路径
@property(nonatomic,copy) NSString *remotePath;

//预览图的远程服务器路径
@property(nonatomic,copy) NSString *thumbnailLocalPath;

//预览图的远程服务器路径
@property(nonatomic,copy) NSString *localPath;

//预览图的尺寸
@property(nonatomic,assign) CGSize thumbnailSize;

//语音对象
@property(nonatomic,strong) EMChatVoice *voice;

//是否为自己发出
@property(nonatomic,assign) BOOL isSelf;

/**
 *  item类型（文本／图片）
 */
@property (assign,nonatomic) Type type;

@end
