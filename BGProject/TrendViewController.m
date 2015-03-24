//
//  TrendViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "TrendViewController.h"
#import "addPhotoViewController.h"
#import "AppDelegate.h"
#import "MenuAddImageView.h"

#import "ZZUploadManager.h"
#import "ZZUploadInterface.h"
#import "MoudleMessageManager.h"
#import "FDSUserManager.h"

#import "FDSPathManager.h"
#import "SVProgressHUD.h"
#import "UIImage+TL.h"
#import "constants.h"
#import "ZZSessionManager.h"
#import <CoreLocation/CoreLocation.h>
#import "ZZUserDefaults.h"

@interface TrendViewController ()<UIActionSheetDelegate,MenuAddBtnDelegate,ZZUploadInterface,CLLocationManagerDelegate>
-(void)uploadStateNotice:(ZZUploadRequest*)uploadRequest;
@end

@implementation TrendViewController
{
    UIView *topView;
    UIButton *backBtn;
    UILabel *label;
    UITextView *tv;
    UIScrollView *myScrollerView;
    UIButton *button;
    UILabel *_locationLab;
    
    MenuAddImageView* addMenuView;
    MoudleMessageManager* messageManager;

    // 下面的数据,注意在使用完成后，要清空。
    NSInteger _uploadedFileCount;// 已经上传了的文件个数
    NSMutableArray* imageUrlArr;   //[{ url:http, smallurl:http:// },   ]
    
    __weak UIView *_keyboardBackView;
    
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:animated];
    
    
    
    //取得AppDelegate对象
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    //隐藏tabblebar
    [app hiddenTabelBar];
    
    //将控制器注册，方便回调
    [[MoudleMessageManager sharedManager]registerObserver:self];
    
    //注册这个东西干嘛用的？？亲，这是上传用的
    [[ZZUploadManager sharedUploadManager ]registerObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    //将活动指示器去掉
    [SVProgressHUD popActivity];
    
    //去掉注册
    [[MoudleMessageManager sharedManager]unRegisterObserver:self];
    [[ZZUploadManager sharedUploadManager ] unRegisterObserver:self];
    
    [super viewWillDisappear:animated];
    
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1.拥有MoudleMessageManager对象
    messageManager = [MoudleMessageManager sharedManager];
    
    _geocoder = [[CLGeocoder alloc] init];
    
    //2.已经上传的文件个数
    _uploadedFileCount = 0;
    
    //3.装图片的数组？？
    imageUrlArr = [NSMutableArray array];
    
    
    //4.添加导航栏／返回按钮／导航栏标签／输入框／提示输入标签／滑动视图／自定义的图片列表／发表按钮
    [self CreatView];
    
    //5.设置self,view的背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    
    //监听键盘
    [self observeKeyboard];
    
    //初始化定位
    [self setupLlocationManager];
    
    //先定位显示出来，后面仔定位一次
    [self locationServicesIsAbled];
    
}

//监听键盘弹出
-(void)observeKeyboard{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//设置keyboardBackView
-(void)setupkeyboardBackViewWithSize:(CGSize)size{
    
    UIView *keyboardBackView = [[UIView alloc] init];
    CGRect bounds = self.view.bounds;
    bounds.size.height = bounds.size.height-size.height;
    keyboardBackView.frame = bounds;
    UITapGestureRecognizer *resignKeyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboardTap)];
    [keyboardBackView addGestureRecognizer:resignKeyboardTap];
    [self.view addSubview:keyboardBackView];
    _keyboardBackView = keyboardBackView;
}

//把键盘放下去
-(void)resignKeyboardTap{
    [tv endEditing:YES];
}

//键盘通知回调函数
-(void)keyboardWillShow:(NSNotification *)noti{
    
    //重新出现的时候要将旧的_keyboardBackView移除掉，高度不对
    [_keyboardBackView removeFromSuperview];
    
    //取出键盘高度
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    //添加一个遮盖真个屏幕的view,事件就可以接受了，神马原因？
    [self setupkeyboardBackViewWithSize:size];
    
}

-(void)keyboardWillHide:(NSNotification *)noti{
    
    //将从父视图遮罩移除
    [_keyboardBackView removeFromSuperview];

    
}

-(void)CreatView
{
    //自定义导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    //设置返回按钮
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    //导航栏标签
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(130, 24, 60, 40)];
    label1.text = @"发微墙";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    
    [topView addSubview:backBtn];
    [topView addSubview:label1];
    [self.view addSubview:topView];
    
    
    //设置输入框
    tv = [[UITextView alloc]initWithFrame:CGRectMake(5, topView.frame.origin.y+topView.frame.size.height+5, 310, 140)];
    tv.delegate = self;
    tv.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tv.backgroundColor =[UIColor whiteColor];
    
    //在输入框中加一个提示输入的标签
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.text = @"请输入正文";
    label.enabled = NO;
    label.backgroundColor =[UIColor clearColor];
    [tv addSubview:label];
    [self.view addSubview:tv];
    
    
    //设置滑动视图
    myScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(5, tv.frame.origin.y+tv.frame.size.height+10, 310, 110)];
    //myScrollerView.pagingEnabled = YES;//分页
    myScrollerView.contentSize = CGSizeMake(310*3, 110);//滑动距离
    //myScrollerView.delegate = self;//代理
    myScrollerView.backgroundColor =[UIColor colorWithRed:218/255.0 green:220/255.0 blue:219/255.0 alpha:0];//背景
    myScrollerView.showsHorizontalScrollIndicator = YES;//去掉进度条
    myScrollerView.bounces = NO;//不能弹跳

    
    //2014年10月13日
    
    //设置MenuAddImageView的坐标
    CGRect menuFrame = CGRectMake(0, 0, kMSScreenWith*3, 110);
      addMenuView = [[MenuAddImageView alloc] initWithFrame:menuFrame :5];
    addMenuView.delegate = self;
    addMenuView.myScrollView = myScrollerView;
    //添加到滑动视图上面去
    [myScrollerView addSubview:addMenuView];
    [self.view addSubview:myScrollerView];
    
    //地理位置标签
    _locationLab = [[UILabel alloc] init];
    CGFloat locationX = myScrollerView.frame.origin.x+5;
    CGFloat locationY = CGRectGetMaxY(myScrollerView.frame)+10;
    CGFloat locationW = myScrollerView.frame.size.width;
    CGFloat locationH = 20;
    _locationLab.font = [UIFont systemFontOfSize:13.0];
    _locationLab.textColor = [UIColor blackColor];
    _locationLab.frame = CGRectMake(locationX, locationY, locationW, locationH);
    
    [self.view addSubview:_locationLab];
    _locationLab.hidden = YES;//先隐藏起来
    
    //发表按钮
    button = [[UIButton alloc]initWithFrame:CGRectMake(10, myScrollerView.frame.origin.y+myScrollerView.frame.size.height+42, 300, 44)];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage resizeImageWithName:@"登录按钮"] forState:UIControlStateNormal];
    //一开始是不能点击的，只有输入文字的时候开启点击
    button.enabled = NO;
    [button setTitle:@"确认发表" forState:UIControlStateNormal];
    [self.view addSubview:button];

}




-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)addImage:(UIButton *)sender
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


#pragma mark-UIImagePickerController代理
-(void)imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *img = nil;
    
	if (!img)
	{
		img = [info objectForKey:UIImagePickerControllerOriginalImage]; //取出原始图片
	}
    
    //FDSPublicManage返回一个路径，里面怎么封装的不清楚
    NSString *filepath = [FDSPublicManage fitSmallWithImage:img];
    
    
    //将模态视图放下去
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //如果路径存在并且长度大于0
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
        
        //将图片和二进制数据传进去
        [addMenuView handleImageAdd:img :thumbData];

    }
    
    
}

#pragma mark- 发布微博
-(void)btnClick:(UIButton *)sender
{
    
    [MobClick event:@"weiqiang_publish_click"];
    
    //发送按钮不能点击
    sender.enabled = NO;
    
    //isInputValid干嘛用的？
    if([self isInputValid]) {
        
        //显示活动指示器
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        
       
        //取出此时imageList数组的个数
        int imgCount = (int)[addMenuView.imageList count];
        
        
        if(imgCount > 0)
        {
            //为何只传第一张图片的data，后面回自动判断
            [self uploadImageWithData:addMenuView.imageList[0]];
            
        }else {
            
            //设置发布微博的类型
            self.issueWeiQiangType=IssueWeiQiangTypeNoPhoto;
            
            [self locationServicesIsAbled];
            
        }

    }
}

//上传完图片后会回调
-(void)issueWeiBoAtWeiQiangCB:(int) result {

    //按钮可以点击
    button.enabled = YES;
    
    //拿来储存返回的url的，之前都没存，干嘛要清空？？已经上传了，可以删除掉了
    [imageUrlArr removeAllObjects];
    
    //将全部图片数据删除
    //[addMenuView.imageList removeAllObjects];
    
    //_uploadedFileCount将上传图片的个数设置为0
    _uploadedFileCount = 0;

    
    if(result == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        
        [UIAlertView showMessage:@"发布微博失败"];
    }
    

//    if(result == 0) {
//        UIAlertView* alert =  [[UIAlertView alloc]initWithTitle:@"提示" message:@"发布成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        
//    } else {
//        UIAlertView* alert =  [[UIAlertView alloc]initWithTitle:@"提示" message:@"发布失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }
    
    
}

//判断是否能够发表
-(BOOL)isInputValid {
    
    return YES;
}


#pragma mark TextViewDelegate------
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        label.text = @"请输入正文";
        button.enabled = NO;
    }
    else
    {
        button.enabled = YES;
        label.text = @"";
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [tv resignFirstResponder];
        return NO;
    }
    return YES;
}
#pragma mark-UIActionSheet代理
//UIActionSheet的代理
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



- (void) addPicFromCamera
{
    
    //初始化一个UIImagePickerController
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
    
    //判断能否用相机功能
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //设置setSourceType类型为相机
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        //设置代理
        [imagePicker setDelegate:self];
        
        //是否能否编辑
        [imagePicker setAllowsEditing:YES];
        
    }
    
    //将imagePicker通过模态视图弹出来
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}



//从相册中添加图片
-(void)addPicFromAlbum {
    
    //初始化UIImagePickerController
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    //设置图片来源？？
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //设置picker代理
    picker.delegate = self;
    
    //将picker通过模态视图弹出来
    [self presentViewController:picker animated:YES completion:nil ];
}

#pragma mark- 添加图片
#pragma-mark MenuAddBtnDelegate method

//点击添加按钮的回调
- (void)didSelectImagePicker
{
    //NSLocalizedString：把字符串本地化？？
    //弹出UIActionSheet对话框
    UIActionSheet*alert = [[UIActionSheet alloc]
                           initWithTitle:@"选择照相还是相册"
                           delegate:self
                           cancelButtonTitle:NSLocalizedString(@"取消",nil)
                           destructiveButtonTitle:nil
                           otherButtonTitles:NSLocalizedString(@"相机拍摄",nil),
                           NSLocalizedString(@"手机相册",nil),
                           nil];
    //显示对话框
    [alert showInView:self.view];
    
}


#pragma mark- 上传文件
//这个是回调的，在将要出现的时候就已经注册了代理
-(void)uploadStateNotice:(ZZUploadRequest*)uploadRequest
{//ZZUploadState_UPLOAD_FAIL 特殊处理
    
    //如果上传状态为ZZUploadState_UPLOAD_OK就执行后面的代码
    if(uploadRequest.m_uploadState != ZZUploadState_UPLOAD_OK)
    {
        return;
    }
    
    
    // save imgURL and thumUrl
    //上传一次，_uploadedFileCount就＋1
    _uploadedFileCount += 1;
    
    NSDictionary* imgItem = @{@"img":uploadRequest.m_responseImgURL,
                              @"img_thum":uploadRequest.m_responseSmallURL};
    [imageUrlArr addObject:imgItem];

    //这里有点绕，如果上传数量为1，数组数量为3，那么，1<3,那么就把此时的文件数寻找数组元素，1就是在数组里面就是第二个
    if(_uploadedFileCount != [addMenuView.imageList count])
    {
        [self uploadImageWithData:addMenuView.imageList[_uploadedFileCount]];
    }
    else
    {
        //是否能定位
        [self locationServicesIsAbled];
        
    }
}


-(void)uploadImageWithData:(NSData*) imgData {
    
    //将imgData转换成图片
    UIImage* img = [UIImage imageWithData:imgData];
    
    //又生成一个路径
    NSString *filepath = [FDSPublicManage fitSmallWithImage:img];
    
    
    if (filepath && filepath.length>0)
    {
        
        //这个路径又是干嘛用的？
        NSString* filePath = [[FDSPathManager sharePathManager]getServerUserIcon];
        
        //获取文件名
        NSString* fileName = [[FDSPublicManage sharePublicManager] getGUID];
        
        //获取当前的用户id
        NSString* uploadSessionID = [[FDSUserManager sharedManager] NowUserID];
        
        [[ZZUploadManager sharedUploadManager] beginUploadRequest:filePath :fileName :uploadSessionID :@"all" :imgData :@"jpg" :@"weiboinfo"];
    }
}

//初始化定位
-(void)setupLlocationManager{
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    //精度
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //每隔5米更新一次定位
    _locationManager.distanceFilter = 5.0;
}

#pragma mark-CLLocationManagerDelegate

//判断是否能够定位，根据系统用不同的方法

-(void)locationServicesIsAbled{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startUpdatingLocation];
        
    }else{
        if ([CLLocationManager locationServicesEnabled]) {
            [_locationManager startUpdatingLocation];
        }else{
            [SVProgressHUD popActivity];
            [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"定位失败，请开启GPS定位"];
        }
    }
    
}

//ios8,调用的函数
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [_locationManager requestAlwaysAuthorization];
            }
            break;
        default:
            break;
            
            
    }
}

//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    //取出经纬度
    double latitude = [[ZZUserDefaults getDefault:LatitudeKey] doubleValue];
    double longitude = [[ZZUserDefaults getDefault:LongitudeKey] doubleValue];
    
    //停止定位
    [_locationManager stopUpdatingLocation];
    
    if (self.issueWeiQiangType==IssueWeiQiangTypeNoPhoto) {
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        
        //发布微墙
        [[MoudleMessageManager sharedManager] issueWeiBoAtWeiQiang:tv.text img:nil img_thum:nil longitude:longitude latitude:latitude];
        
    }else if(self.issueWeiQiangType==IssueWeiQiangTypePhoto){
        
        //发布微墙(多张图片)
        [[MoudleMessageManager sharedManager] issueWeiBoAtWeiQiangWithContent:tv.text imageUrls:imageUrlArr longitude:longitude latitude:latitude];
        
    }
    
    
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    double latitude = 0.0;
    double longitude = 0.0;
    
    //停止定位
    [_locationManager stopUpdatingLocation];
    
    if (self.issueWeiQiangType==IssueWeiQiangTypeNoPhoto) {
        
        //爆菊花
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        
        //发布微墙
        [[MoudleMessageManager sharedManager] issueWeiBoAtWeiQiang:tv.text img:nil img_thum:nil longitude:longitude latitude:latitude];
        
    }else if(self.issueWeiQiangType==IssueWeiQiangTypePhoto){
        
        //爆菊花
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        
        [[MoudleMessageManager sharedManager] issueWeiBoAtWeiQiangWithContent:tv.text imageUrls:imageUrlArr longitude:longitude latitude:latitude];
        
    }
    
}

@end
