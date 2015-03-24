//
//  rewardViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-23.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSPathManager.h"
#import "SVProgressHUD.h"
#import "FDSPublicManage.h"
#import "rewardViewController.h"
#import "addPhotoViewController.h"
#import "AppDelegate.h"
#import "FDSUserManager.h"
#import "ZZUploadManager.h"
#import "UIAlertView+Zhangxx.h"
#import "ZZUploadManager.h"
#import "MoudleMessageManager.h"
#import "MenuAddImageView.h"
#import "constants.h"
#import "RewardRulesViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ZZUserDefaults.h"

#define TextViewHeight 140

@interface rewardViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MenuAddBtnDelegate,ZZUploadInterface,CLLocationManagerDelegate>


@end

@implementation rewardViewController
{
    
    UIView *topView;
    UIButton *backBtn;
    UILabel *label;
    UITextView *tv;
    UIScrollView *myScrollerView;
    UIScrollView *mainScrollerVier;
    UIButton *button;
    UIButton *addImageBtn;
    UILabel *_locationLab;
    
    UILabel *topLabel;
    UIButton *btn1;
    BOOL _isClick;
    MenuAddImageView* addMenuView;
    MoudleMessageManager* messageManager;
    // 要上传的文件图片
    // 下面的数据,注意在使用完成后，要清空。
    NSInteger _uploadedFileCount;// 已经上传了的文件个数
    NSMutableArray* imageUrlArr;
    NSData* imgData;
    __weak UIView *_keyboardBackView;
    
    CLLocationManager *_locationManager;
    
    //用来反地理编码的
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
    
    
    
    //隐藏tabbar,注册代理
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app hiddenTabelBar];
    
    //注册代理
    [messageManager registerObserver:self];
    
    //注册这个东西干嘛用的？？亲，这是上传用的
    [[ZZUploadManager sharedUploadManager ]registerObserver:self];
}


-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    
    
    //关掉菊花
    [SVProgressHUD popActivity];
    
    //去掉代理
    [messageManager unRegisterObserver:self];
    
    [[ZZUploadManager sharedUploadManager] unRegisterObserver:self];
}


-(void)CreatView
{
    //导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    //返回按钮
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //导航栏标签
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(130, 24, 80, 40)];
    label1.text = @"有奖投稿";
    label1.textColor = [UIColor blackColor];
    label1.font =[UIFont systemFontOfSize:16];
    

    [topView addSubview:backBtn];
    [topView addSubview:label1];
    [self.view addSubview:topView];
    
    //搞这个UIScrollView与啥用？？同一页内容比较多的时候可以滚动
    mainScrollerVier = [[UIScrollView alloc]initWithFrame:CGRectMake(5, topView.frame.origin.y+topView.frame.size.height+5, 310, 500)];
    mainScrollerVier.pagingEnabled = YES;
    CGFloat contentSizeW = self.view.bounds.size.width-5*2;
    CGFloat contentSizeH = self.view.bounds.size.height-topView.frame.size.height-5;
    //现在没有投稿规则，暂时不滚动，滚动距离刚好
    mainScrollerVier.contentSize = CGSizeMake(contentSizeW, contentSizeH);
    mainScrollerVier.delegate = self;
    mainScrollerVier.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainScrollerVier];
    
    //应该是显示投稿规则的标签
    topLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    topLabel.text = [NSString stringWithFormat:@"点击查看有奖投稿规则"];
    
    topLabel.frame = CGRectMake(0,0, 180, 30);
    topLabel.font = [UIFont systemFontOfSize:15.0];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.backgroundColor= [UIColor colorWithRed:1 green:235/255.0 blue:203/255.0 alpha:1];
    topLabel.numberOfLines = 0;
    topLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *ruleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ruleTap)];
    [topLabel addGestureRecognizer:ruleTap];
    topLabel.hidden = YES;//先隐藏起来
    [mainScrollerVier addSubview:topLabel];
    
    //输入框
    CGFloat textViewX = 0;
    //CGFloat textViewY = topLabel.frame.origin.y+topLabel.frame.size.height+5;
    CGFloat textViewY = 5;
    CGFloat textViewW = self.view.bounds.size.width-5*2;
    CGFloat textViewH = TextViewHeight;
    tv = [[UITextView alloc]initWithFrame:CGRectMake(textViewX,textViewY , textViewW, textViewH)];
    tv.delegate = self;
    //这个到底有没有用？？
    tv.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tv.backgroundColor =[UIColor whiteColor];
    
    //这是占位标签
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.text = @"请输入正文";
    label.enabled = NO;
    label.backgroundColor =[UIColor clearColor];
    [tv addSubview:label];
    [mainScrollerVier addSubview:tv];
#pragma mark-选图片的滑动视图
    //选图片的滑动视图
    myScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, tv.frame.origin.y+tv.frame.size.height+10, 310, 110)];
    myScrollerView.contentSize = CGSizeMake(310*3, 110);
    myScrollerView.backgroundColor =[UIColor colorWithRed:218/255.0 green:220/255.0 blue:219/255.0 alpha:0];//背景
    myScrollerView.showsHorizontalScrollIndicator = YES;
    myScrollerView.bounces = NO;//不能弹跳
    
    //设置MenuAddImageView的坐标
    CGRect menuFrame = CGRectMake(0, 0, kMSScreenWith*3, 110);
    addMenuView = [[MenuAddImageView alloc] initWithFrame:menuFrame :5];
    addMenuView.delegate = self;
    addMenuView.myScrollView = myScrollerView;
    //添加到滑动视图上面去
    [myScrollerView addSubview:addMenuView];
    [mainScrollerVier addSubview:myScrollerView];
    
    //地理位置标签
    _locationLab = [[UILabel alloc] init];
    CGFloat locationX = 10;
    CGFloat locationY = 340;
    CGFloat locationW = myScrollerView.frame.size.width;
    CGFloat locationH = 20;
    _locationLab.font = [UIFont systemFontOfSize:13.0];
    _locationLab.textColor = [UIColor blackColor];
    _locationLab.frame = CGRectMake(locationX, locationY, locationW, locationH);
    
    [self.view addSubview:_locationLab];
    
    
    //确认投稿按钮
    button = [[UIButton alloc]initWithFrame:CGRectMake(5, myScrollerView.frame.origin.y+myScrollerView.frame.size.height+40, 300, 44)];
    [button addTarget:self action:@selector(submitTopic:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"登录按钮"] forState:UIControlStateNormal];
    [button setTitle:@"确认投稿" forState:UIControlStateNormal];
    //默认是不能点击的，只有输入文字后才可以点击
    button.enabled = NO;
    [mainScrollerVier addSubview:button];
    
}

-(void)ruleTap{
    
    RewardRulesViewController *rewardRulesVC = [[RewardRulesViewController alloc] init];
    [self presentViewController:rewardRulesVC animated:YES completion:nil];
    
}

#pragma mark 投稿

-(void)submitTopic:(UIButton *)sender
{
    
    [MobClick event:@"xuanneng_joke_publish_click"];
    
    //显示活动指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    //发送按钮不能点击
    sender.enabled = NO;
    
    //isInputValid干嘛用的？
    if([self isInputValid]) {
        
        //取出此时imageList数组的个数
        int imgCount = [addMenuView.imageList count];
        
        
        if(imgCount > 0)
        {
            //为何只传第一张图片的data，后面回自动判断
            [self uploadImageWithData:addMenuView.imageList[0]];
            
        }else {
            
//            MoudleMessageManager*manager =  [MoudleMessageManager sharedManager];
//            
//            //发送没有图片的投稿
//            [manager submitTopic:tv.text img:nil img_thum:nil itemId:0];
            
            //设置发布幽默秀的类型
            self.issueHumorousType=IssueHumorousTypeNoPhoto;
            
            [self locationServicesIsAbled];
            
        }
        
    }
    
}


// 是否需要同步发送到微墙
-(void)BtnClik:(UIButton *)sender
{
    if (!_isClick) {
        [btn1 setImage:[UIImage imageNamed:@"注册协议选中"] forState:UIControlStateNormal];
    }
    else
    {
        [btn1 setImage:[UIImage imageNamed:@"注册协议未选中"] forState:UIControlStateNormal];
    }
    _isClick = !_isClick;
    
}
#pragma-mark MenuAddBtnDelegate method

//点击添加按钮的回调
- (void)didSelectImagePicker
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

-(void)btnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //导航栏／规则标签／输入框／添加图片的滑动视图／同步按钮／发表按钮
    [self CreatView];
    
    _geocoder = [[CLGeocoder alloc] init];
    
    //设置self.view的背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    
    //3.装图片的数组？？
    imageUrlArr = [NSMutableArray array];
    
    //初始化messageManager
    messageManager = [MoudleMessageManager sharedManager];
    
    //监听键盘弹出
    [self observeKeyboard];
    
    //初始化定位
    [self setupLlocationManager];
    
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

#pragma mark TextViewDelegate------
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        label.text = @"请输入正文";
        button.enabled = NO;
    }
    else
    {
        label.text = @"";
        button.enabled = YES;
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
    
    //判断是否允许调用摄像头
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //设置图片来源
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        //设置代理
        [imagePicker setDelegate:self];
        
        //是否允许编辑
        [imagePicker setAllowsEditing:YES];
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}




-(void)addPicFromAlbum {
    
    //初始化一个UIImagePickerController
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    //设置图片来源
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //设置代理
    picker.delegate = self;
    
    //模态视图
    [self presentViewController:picker animated:YES completion:nil ];
    
}
#pragma mark-UIImagePickerController代理
//选完图片后的回调
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {

    // 首先将文件传到文件服务器
    UIImage *img = nil;
	if (!img)
	{
		img = [info objectForKey:UIImagePickerControllerOriginalImage]; //原始图片
	}

    //获取图片路径
    NSString *filepath = [FDSPublicManage fitSmallWithImage:img];
    
    //推下去
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

// 投稿成功后回调
-(void)submitTopicCB:(int)result {
    if(result == 0) {
        
        [UIAlertView showMessage:@"投稿成功!"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [UIAlertView showMessage:@"投稿失败!"];
    }
}
//判断是否能够发表
-(BOOL)isInputValid {
    return YES;
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
        
        //设置发布的幽默秀类型
        self.issueHumorousType=IssueHumorousTypePhoto;
        
        //判断能否定位
        [self locationServicesIsAbled];
        
        
    }
}

-(void)uploadImageWithData:(NSData*)tempImgData{
    
    //将imgData转换成图片
    UIImage* img = [UIImage imageWithData:tempImgData];
    
    //又生成一个路径
    NSString *filepath = [FDSPublicManage fitSmallWithImage:img];
    
    
    if (filepath && filepath.length>0)
    {
        //生成二进制数据
        
        //这个路径又是干嘛用的？
        NSString* filePath = [[FDSPathManager sharePathManager]getServerUserIcon];
        
        //获取文件名
        NSString* fileName = [[FDSPublicManage sharePublicManager] getGUID];
        
        //获取当前的用户id
        NSString* uploadSessionID = [[FDSUserManager sharedManager] NowUserID];
        
        [[ZZUploadManager sharedUploadManager] beginUploadRequest:filePath :fileName :uploadSessionID :@"all" :tempImgData :@"jpg" :@"xuannenginfo" ];
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
    double latitude = [[ZZUserDefaults getUserDefault:LatitudeKey] doubleValue];
    double longitude = [[ZZUserDefaults getUserDefault:LongitudeKey] doubleValue];

    //停止定位
    [_locationManager stopUpdatingLocation];
    
    //上传幽默秀
    [self submitHumorousShowsWithLongitude:longitude latitude:latitude];
    
    
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    double latitude = 0.0;
    double longitude = 0.0;
    
    //停止定位
    [_locationManager stopUpdatingLocation];
    
    //上传幽默秀
    [self submitHumorousShowsWithLongitude:longitude latitude:latitude];
    
}

//发布幽默秀
-(void)submitHumorousShowsWithLongitude:(CGFloat)longitude latitude:(CGFloat)latitude{
    
    if (self.issueHumorousType==IssueHumorousTypeNoPhoto) {
        
        //爆菊花
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        
        //发布幽默秀
        [[MoudleMessageManager sharedManager] submitTopic:tv.text img:nil img_thum:nil itemId:0 longitude:longitude latitude:latitude];
        
    }else if(self.issueHumorousType==IssueHumorousTypePhoto){
        
        //爆菊花
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        
        //发布幽默秀(多张图片)
        [[MoudleMessageManager sharedManager] submitTopic:tv.text imageUrls:imageUrlArr itemId:0 longitude:longitude latitude:latitude];
        
    }
    
}

@end
