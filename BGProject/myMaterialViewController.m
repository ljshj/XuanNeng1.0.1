//
//  myMaterialViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//
#import "EGOImageView.h"
#import "UIAlertView+Zhangxx.h"
#import "myMaterialViewController.h"
#import "AppDelegate.h"
#import "niChengViewController.h"
#import "qianMIngViewController.h"
#import "SexViewController.h"
#import "birthdayViewController.h"
#import "phoneViewController.h"
#import "starViewController.h"
#import "ageViewController.h"
#import "homeViewController.h"
#import "suoZaiViewController.h"
#import "emailViewController.h"
#import "xueViewController.h"
#import "scanViewController.h"

#import "FDSUserCenterMessageManager.h"

#import "FDSPublicManage.h"
#import "SVProgressHUD.h"
#import "ZZUploadManager.h"
#import "FDSPathManager.h"
#import "FDSUserManager.h"
#import "PersonlCardViewController.h"
#import "NSString+TL.h"

#define kSubmitTitle @"确定"
#define kCancelTitle @"取消"
#define kReauestHometown 1
#define kRequestLocation 2

// 弹出框的高度
#define kPopViewHeight 120

@interface myMaterialViewController ()<UIAlertViewDelegate>

@end

@implementation myMaterialViewController
{
    UIView    *topView;
    UIButton  *backBtn;
    
    UIScrollView *myScrollerView;
    
    UIButton *topBtn;
    UIButton *idBtn;
    UIButton *button;
    UILabel  *btnLabel;
    
    UIButton *bottomBtn;
    
    NSArray *titieArr;
    UIView *tanchuView;
    UIButton *btn;
    
    BGUser* _user;

    EGOImageView* _iconView;
    UIImage* _iconImage;
    //显示ID
    UILabel* _idLabel;
    UILabel* _phoneLabel;
    UILabel* _nickNLabel;

    //签名
    UILabel* _signatureLabel;
    UILabel* _sexLabel;
    UILabel* _ageLabel;
    
    UILabel* _birthLabel;
    //星座
    UILabel* _consteLabel;
    UILabel* _hometownLabel;
  
    //所在地
    UILabel* _loplaceLabel;
    UILabel* _emailLabel;
    UILabel* _bTypeLabel;
    
    NSDictionary* mediaInfo;// 从pickerView中获取到的图片信息
    UIImagePickerController* imagePickerView;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    //将tabbar隐藏起来
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    [app hiddenTabelBar];
    
    //拿出用户模型
    _user = [[FDSUserManager sharedManager]getNowUser];
    
    //
    [self showUserInfo];
    
    [[ZZUploadManager sharedUploadManager]registerObserver:self];
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
}
-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    
    
    [SVProgressHUD popActivity];
    [[ZZUploadManager sharedUploadManager]unRegisterObserver:self];
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        titieArr = [NSArray arrayWithObjects:@"手机号码",@"昵称",@"个性签名",@"性别",@"年龄",@"生日",@"星座",@"家乡",@"所在地",@"邮箱",@"血型", nil];
    }
    return self;
}
-(void)CreatTopView
{
    
    //导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    //返回按钮
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    //导航栏标签
    UILabel  *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 100, 40)];
    label.text = @"编辑个人资料";
    label.textColor = TITLECOLOR;
    label.font = [UIFont systemFontOfSize:15];
    [topView addSubview:label];
    
    [self.view addSubview:topView];
    
    //滑动背景视图，要500那么长吗？
    myScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64.5, 320, 500)];
    myScrollerView.pagingEnabled = YES;
    myScrollerView.contentSize = CGSizeMake(320, 800);//有多长滚多长不就行了，干嘛整那么长？？
    [self.view addSubview:myScrollerView];
    
    //头像背景按钮
    topBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    topBtn.tag = 15;
    
    //头像标签
    UILabel *topBtnLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 30, 40, 20)];
    topBtnLabel.text =  @"头像";
    
    // 头像
//    UIImageView *topBtnBigImg = [[UIImageView alloc]initWithFrame:CGRectMake(208, 20, 60, 60)];
//    topBtnBigImg .image = [UIImage imageNamed:@"7"];
    
    //头像 ps：为啥没显示出来呢？
    EGOImageView* topBtnBigImg = [[EGOImageView alloc]initWithFrame:CGRectMake(208, 20, 60, 60)];
    _iconView = topBtnBigImg;
    
    //这个是箭头吧
    UIImageView *topBtnImg = [[UIImageView alloc]initWithFrame:CGRectMake(288, 44, 12, 12)];
    topBtnImg.image = [UIImage imageNamed:@"个人中心页面_21"];
    
    
    topBtn.backgroundColor = [UIColor whiteColor];
    [topBtn addTarget:self action:@selector(btnClik:) forControlEvents:UIControlEventTouchUpInside];
    
    [topBtn addSubview:topBtnLabel];
    [topBtn addSubview:topBtnBigImg];
    [topBtn addSubview:topBtnImg];
    
    //分割线
    UIView *barrlin =[[UIView alloc]initWithFrame:CGRectMake(0, 100, 320, 0.5)];
    barrlin.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    
    //id背景按钮
    idBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 100.5, 320, 40)];
    
    //id标签
    UILabel *idLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    idLabel.text =  @"ID";
    
    //id内容
    UILabel *idEndLabel = [[UILabel alloc]initWithFrame:CGRectMake(100/*80*/, 10, 200, 20)];
    //TODO::
    idEndLabel.text = @"";
    _idLabel = idEndLabel;
    
    
    idBtn.backgroundColor = [UIColor whiteColor];
    [idBtn addSubview:idLabel];
    [idBtn addSubview:idEndLabel];
    
    
    [myScrollerView addSubview:topBtn];
    [myScrollerView addSubview:idBtn];
    [myScrollerView addSubview:barrlin];
    
    
    for (int  i =  0; i < 11; i ++)
    {
        UIView *barrLine = [[UIView alloc]initWithFrame:CGRectMake(0, idBtn.frame.origin.y+idBtn.frame.size.height+i*40.5, 320, 0.5)];
        barrLine.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        
        UILabel *titeleLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 20)];
        titeleLabel.text =  titieArr[i];
        
        btnLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 180, 20)];
        btnLabel.tag = 100+i;
//        btnLabel.text =  @"谁知道啊 ";
        
        
        UIImageView *btnImg = [[UIImageView alloc]initWithFrame:CGRectMake(288, 14, 12, 12)];
        btnImg.image = [UIImage imageNamed:@"个人中心页面_21"];
        if ([titeleLabel.text isEqualToString:@"手机号码"]) {
            btnImg.hidden = YES;
        }
        
        button = [[UIButton alloc]initWithFrame:CGRectMake(0, idBtn.frame.origin.y+idBtn.frame.size.height+0.5+i*40, 320, 40)];
        button.tag = i;
        [button addTarget:self action:@selector(btnClik:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor whiteColor];
        [button addSubview:titeleLabel];
        [button addSubview:btnLabel];
        [button addSubview:btnImg];
        [myScrollerView addSubview:button];
        [myScrollerView addSubview:barrLine];
        
        //初始化各个Lable
        switch (i) {
            
            //电话
            case 0:
                _phoneLabel = btnLabel; break;
                
            //昵称
            case 1:
                _nickNLabel = btnLabel; break;
                
            //个性签名
            case 2:
                _signatureLabel = btnLabel; break;
            
            //性别
            case 3:
                _sexLabel = btnLabel; break;
                
            //年龄
            case 4:
                _ageLabel = btnLabel; break;
                
            //生日
            case 5:
                _birthLabel = btnLabel; break;
            
            //星座
            case 6:
                _consteLabel = btnLabel;break;
                
            //家乡
            case 7:
                _hometownLabel = btnLabel; break;
                
            //所在地
            case 8:
                _loplaceLabel = btnLabel; break;
            
            //邮箱
            case 9:
                _emailLabel = btnLabel; break;
                
            //血型
            case 10:
                _bTypeLabel = btnLabel; break;
                
            default:
                
                break;
        }
    }
    
    //预览名片
    bottomBtn =[[UIButton alloc]initWithFrame:CGRectMake(10,610, 300, 40)];
    [bottomBtn setTitle:@"立即预览我的名片" forState:UIControlStateNormal];
    bottomBtn.tag = 12;
    [bottomBtn addTarget:self action:@selector(btnClik:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    [myScrollerView addSubview:bottomBtn];
    
}

#pragma mark btnClick===================

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnClik:(UIButton *)sender
{
    switch (sender.tag) {
            //TODO:: 完善个人中心
        case 0:// 更改手机号
        {
            //手机号不可修改！
            return;
            phoneViewController *nicheng =[[phoneViewController alloc]init];
            [self.navigationController pushViewController:nicheng animated:YES];

        }
            break;
        case 1:
        {
            //昵称
            niChengViewController *nicheng =[[niChengViewController alloc]init];
            [self.navigationController pushViewController:nicheng animated:YES];
        }
            break;
        case 2:
        {
            //签名
            qianMIngViewController *nicheng =[[qianMIngViewController alloc]init];
            [self.navigationController pushViewController:nicheng animated:YES];
        }
            break;
        case 3:
        {
            //性别
            SexViewController *nicheng =[[SexViewController alloc]init];
            [self.navigationController pushViewController:nicheng animated:YES];
        }
            break;
        case 4:
        {
            //年龄
            ageViewController *nicheng =[[ageViewController alloc]init];
            [self.navigationController pushViewController:nicheng animated:YES];
            
        }
            break;
        case 5:
        {
            //生日
            birthdayViewController *nicheng =[[birthdayViewController alloc]init];
            [self.navigationController pushViewController:nicheng animated:YES];
            
        }
            break;
        case 6:
        {
            //星座
            starViewController *nicheng =[[starViewController alloc]init];
            [self.navigationController pushViewController:nicheng animated:YES];
            
        }
            break;
        case 7:
        {

            homeViewController *nicheng =[[homeViewController alloc]init];
            nicheng.requestTag = kReauestHometown;
            [self.navigationController pushViewController:nicheng animated:YES];
        }
            break;
        case 8:
        {
            //所在地
            homeViewController *nicheng =[[homeViewController alloc]init];
            nicheng.requestTag = kRequestLocation;
            [self.navigationController pushViewController:nicheng animated:YES];
            
        }
            break;
        case 9:
        {
            //邮箱
            emailViewController *nicheng =[[emailViewController alloc]init];
            [self.navigationController pushViewController:nicheng animated:YES];
        }
            break;
        case 10:
        {
            //血型
            xueViewController *nicheng =[[xueViewController alloc]init];
            [self.navigationController pushViewController:nicheng animated:YES];
        }
            break;
        case 12:
        {
            //取得当前登录用户的userid
            NSString *userid = [[FDSUserManager sharedManager] NowUserID];
            
            //获取个人资料
            [[FDSUserCenterMessageManager sharedManager] userRequestUserInfo:userid];
            
            //是用户本身的
            [FDSUserCenterMessageManager sharedManager].userInfoType=UserInfoTypeCurrentUserInfo;
            
        }
            break;
        case 15:
        {
            // 用户选择图片来源
            UIActionSheet*alert = [[UIActionSheet alloc]
                                   initWithTitle:@"选择照相还是相册"
                                   delegate:self
                                   cancelButtonTitle:NSLocalizedString(@"取消",nil)
                                   destructiveButtonTitle:nil
                                   otherButtonTitles:NSLocalizedString(@"相机拍摄",nil),
                                   NSLocalizedString(@"手机相册",nil),
                                   nil];
            [alert showInView:self.view];
    
        }
            break;
            
        default:
            break;
    }
}


#pragma mark viewDidLoad========

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //自定义各种cell
    [self CreatTopView];
    
    //背景颜色
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    
}

//
- (void) addPicFromCamera
{

    UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setDelegate:self];
        [imagePicker setAllowsEditing:YES];
    }
    [self presentViewController:imagePicker animated:YES completion:nil];

}

//相册
-(void)addPicFromAlbum {
    
    //创建图片选择控制器
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    //设置图片来源为相册
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //设置代理
    picker.delegate = self;
    
    //通过模态视图退出来
    [self presentViewController:picker animated:YES completion:nil ];
    
}


- (void)saveImage:(UIImage *)image {
    NSLog(@"保存");
}
#pragma mark –
#pragma mark Camera View Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {

    //来源是相机的
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera) {

        [self uploadImageFile:info];
        [picker dismissViewControllerAnimated:YES completion:^{
           //do nothing;
        }];
        
    } else {
        
        //赋值干嘛？
        imagePickerView = picker;
        
        //那这个字典干嘛？
        mediaInfo = info;
        
        //弹出对话框
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请确定要上传图片到服务器上" delegate:self cancelButtonTitle:kCancelTitle otherButtonTitles:kSubmitTitle,nil];
        
        [alert show];
        
    }

    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker  dismissViewControllerAnimated:YES completion:nil];
}

//UIActionSheet回调
- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString* btnTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([btnTitle isEqualToString:@"相机拍摄"]) {
        [self addPicFromCamera];
    }
    
    if([btnTitle isEqualToString:@"手机相册"]) {

        [self addPicFromAlbum];
    }
}


- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    
}


-(void)showUserInfo {
    
    //头像
    _iconView.imageURL = [NSURL URLWithString:[NSString setupSileServerAddressWithUrl:_user.photo]];
    
    //昵称
    [_nickNLabel setText:_user.nickn];
    
    //TODO::
    
    //用户ID
    [_idLabel setText:_user.userName];
    
    //手机号码
    [_phoneLabel setText:_user.phonenumber];
    
    //用户名怎么会设置两次？？
    [_nickNLabel setText:_user.nickn];
    
    //个人签名
    [_signatureLabel setText:_user.signature];
    _signatureLabel.numberOfLines = 0;
    _signatureLabel.font = [UIFont systemFontOfSize:16];
    _signatureLabel.adjustsFontSizeToFitWidth = YES;
    _signatureLabel.minimumFontSize = 7;
    
    //性别
    if([_user.sex intValue]==0) {
        [_sexLabel setText:@"女"];
    }else if([_user.sex intValue]==1) {
        [_sexLabel setText:@"男"];
    }else {
        [_sexLabel setText:@"保密"];
    }

    //年龄
    [_ageLabel setText:_user.age];
    
    //生日
    [_birthLabel setText:_user.birthday];
    
    //应该是星座吧？
    [_consteLabel setText:_user.conste];
    
    //家乡
    [_hometownLabel setText:_user.hometown];
    
    //所在地
    [_loplaceLabel setText:_user.loplace];
    
    //邮箱
    [_emailLabel setText:_user.email];
    
    //血型
    [_bTypeLabel setText:_user.btype];
    
    
}

#pragma mark 图片上传回调

-(void)uploadStateNotice:(ZZUploadRequest*)uploadRequest {
//    NSLog(@"upload state:%d", uploadRequest.m_uploadState);
    if(uploadRequest.m_uploadState == ZZUploadState_UPLOAD_OK) {
        
        //修改用户模型为最新的用户模型地址，直接修改
        _user.photo = uploadRequest.m_responseImgURL;
        
        // 头像上传成功，发送修改后的图片地址上服务器
        [[FDSUserCenterMessageManager sharedManager]
         updateUserIcon:uploadRequest.m_responseImgURL];
        
    }else if(uploadRequest.m_uploadedSize == ZZUploadState_UPLOAD_FAIL){
        // 头像上传失败
        [SVProgressHUD popActivity];
        [UIAlertView showMessage:@"头像上传失败"];
    }
}

//所有的用的是同一个接口20002，修改用户资料回调
-(void)upDateUserInfoCB:(int)returnCode {
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    
    if(returnCode==0) {
        
        //将图片换过来，换上刚刚存起来的图片，个人中心的图片还没修改
        [_iconView setImage:_iconImage];
        
        
    }else {
         [UIAlertView showMessage:@"头像修改失败"];
    }
}

//UIAlertView代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //取出被点击按钮的标题
    NSString* title = [alertView buttonTitleAtIndex:buttonIndex];
    
    //将图片选择控制器放下去
    [imagePickerView dismissViewControllerAnimated:YES completion:^{
       
    }];
    
    //如果是确定
    if ([title isEqualToString:kSubmitTitle]) {
        
        //将装有图片信息的字典传过去
        [self uploadImageFile:mediaInfo];
        
        
    } else {
        
        //取消，则什么都不会发生。

    }
    
    //选择完后将字典置空
    mediaInfo = nil;    
}

//
-(void)uploadImageFile:(NSDictionary*)info {
    
    // 首先将文件传到文件服务器
    UIImage *img = nil;
	if (!img)
	{
        //取出字典的图片
		img = [info objectForKey:UIImagePickerControllerOriginalImage]; //原始图片
	}
    
    //获取图片的文件路径
    NSString *filepath = [FDSPublicManage fitSmallWithImage:img];
    
    //先将选择的图片存在_iconImage里面
    _iconImage = img;
    
    //如果文件路径存在并且长度大于0
    if (filepath && filepath.length>0)
    {

        //先转化成二进制数据，需要路径
        NSData *thumbData = UIImageJPEGRepresentation(img, 1.0);
        
        //如果数据长度大于200kb,才按照比例压缩
        if (thumbData.length>200*1024) {
            
            CGFloat compressScale = 200*1024/thumbData.length;
            thumbData = UIImageJPEGRepresentation(img,compressScale);
            
            
        }
        
        //NSUInteger len = thumbData.length/1024;
        
        //爆菊花
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        
        //获取这个是什么路径，用户头像的路径字段？
        NSString* filePath = [[FDSPathManager sharePathManager]getServerUserIcon];
        
        //这又是神马文件名？
        NSString* fileName = [[FDSPublicManage sharePublicManager] getGUID];
        
        //获取用户id
        NSString* uploadSessionID = [[FDSUserManager sharedManager] NowUserID];
        
        //发送消息
        [[ZZUploadManager sharedUploadManager] beginUploadRequest:filePath :fileName :uploadSessionID :@"all" :thumbData :@"jpg" :@"userinfo" ];
    }
    
}

//个人信息回调
-(void)getUserInfoCB:(NSDictionary *)dic{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if ([FDSUserCenterMessageManager sharedManager].userInfoType==UserInfoTypeOtherUserInfo) {
    
        PersonlCardViewController *pv = [[PersonlCardViewController alloc] init];
        pv.userDic = dic;
        pv.userid = [[FDSUserManager sharedManager] NowUserID];
        [self.navigationController pushViewController:pv animated:YES];
    }
    
    
    
}

@end
