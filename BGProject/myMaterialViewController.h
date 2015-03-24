//
//  myMaterialViewController.h
//  BGProject
//
//  Created by zhuozhong on 14-7-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZUploadInterface.h"
#import "FDSUserCenterMessageInterface.h"
@interface myMaterialViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,
UIActionSheetDelegate,ZZUploadInterface,UserCenterMessageInterface,UIApplicationDelegate>

-(void)uploadStateNotice:(ZZUploadRequest*)uploadRequest;
//bg TODO::2014年09月18日
-(void)upDateUserInfoCB:(int)returnCode;
@end
