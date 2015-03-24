//
//  addProductViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-29.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "addProductViewController.h"
#import "AppDelegate.h"
#import "FDSPublicManage.h"

#import "SVProgressHUD.h"
#import "FDSPublicManage.h"
#import "FDSPathManager.h"
#import "ZZUploadManager.h"
#import "FDSUserManager.h"
#import "UIImage+TL.h"
#import "NSString+TL.h"
#import "UserStoreMessageManager.h"

@interface addProductViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UITextViewDelegate, ZZUploadInterface, UserStoreMessageInterface>

{
    // 标记页面是否因为遮挡而向上移动
    BOOL _isMoveUP;
    CGRect _normalFrame; // 记录整个页面的正常frame;
    
    BOOL _needUpdateImage; // 是否修改了产品图片     // 如果是添加产品,可以无视这个变量。
    
    int _replaceIndex;  // 修改成功后,需要替换元素的下标
    
    // 修改后的商品图片
    NSString* _replaceImg;
    NSString* _replaceImg_thum;
}

- (IBAction)addImage:(id)sender;

// 是否推荐
@property (weak, nonatomic) IBOutlet UISwitch *recommendSwitch;

@property (strong, nonatomic) IBOutlet UIImageView *productImg;
@property (strong, nonatomic) IBOutlet UITextField *productName;

@property (weak, nonatomic) IBOutlet UITextField *productPrice;

@property (strong, nonatomic) IBOutlet UITextView *productBrief;

@property (weak, nonatomic) IBOutlet UISwitch *isBrecom;

// 显示产品简介的 placeHolder
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;

@property (weak, nonatomic) IBOutlet UIButton *addImageButton;

// 监视图片上传
-(void)uploadStateNotice:(ZZUploadRequest*)uploadRequest;


// 上传商品的回调
-(void)addProductCB:(int)isSuccess;


// 修改商品的回调
-(void)updateProductCB:(int)returnCode;
@end

@implementation addProductViewController
{
    UIView    *topView;
    UIButton  *backBtn;
    
    UIButton  *addProductBtn;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _needUpdateImage = NO;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app hiddenTabelBar];
    
    [self textViewDidChange:_productBrief];

    [[ZZUploadManager sharedUploadManager ]registerObserver:self];
    [[UserStoreMessageManager sharedManager]registerObserver:self];

}

-(void)viewWillDisappear:(BOOL)animated {
    [SVProgressHUD popActivity];
    [[ZZUploadManager sharedUploadManager ]unRegisterObserver:self];
    [[UserStoreMessageManager sharedManager]unRegisterObserver:self];
    
    [super viewWillDisappear:animated];
    
    
}

-(void)CreatTopView
{
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
   
    if([self.viewTitle length] == 0)
    {
         label1.text = @"添加产品";
    }else
    {
        label1.text = self.viewTitle;
    }
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    [self.view addSubview:topView];
    
    
    // 计算出 button 的位置
    CGFloat btnX = 10;
    CGFloat btnY = CGRectGetMaxY(self.productBrief.superview.frame)+20;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGSize btnSize = (CGSize){screenW-btnX*2, 44};
    
    addProductBtn = [[UIButton alloc]initWithFrame:(CGRect){{btnX,btnY},btnSize}];
    if([self.buttonTitle length] == 0)
    {
         [addProductBtn setTitle:@"确定添加"
                        forState:UIControlStateNormal];
        
    }else
    {
         [addProductBtn setTitle:self.buttonTitle
                        forState:UIControlStateNormal];
        [_addImageButton setTitle:@"单击此处,修改商品图片" forState:UIControlStateNormal];
    }
   
    [addProductBtn addTarget:self action:@selector(postProductToService:) forControlEvents:UIControlEventTouchUpInside];
    [addProductBtn setBackgroundImage:[UIImage resizeImageWithName:@"登录按钮"] forState:UIControlStateNormal];
    [self.view addSubview:addProductBtn];

}

#pragma mark btnClick===================

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


// 发送添加商品的请求
//-(void)addproduct
-(void)postProductToService:(UIButton*)btn;
{
    
   if([btn.titleLabel.text isEqualToString:@"确定添加"])
   {
       //检查图片／产品名称／简介等是否为空，价格不用判断
       if([self isPrepareToupLoad])
       {
           
           //取出产品图片
           UIImage* img = _productImg.image;
           
           //获取图片路径
           NSString *filepath = [FDSPublicManage fitSmallWithImage:img];
           
           //如果文件名不为空并且长度大于0
           if (filepath && filepath.length>0)
           {
               
               //爆菊花
               [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
               
               //转换成二进制数据
               //NSData *thumbData = [NSData dataWithContentsOfFile:filepath];
               //先转化成二进制数据，需要路径
               NSData *thumbData = UIImageJPEGRepresentation(img, 1.0);
               
               //如果数据长度大于200kb,才按照比例压缩
               if (thumbData.length>200*1024) {
                   
                   CGFloat compressScale = 200*1024/thumbData.length;
                   thumbData = UIImageJPEGRepresentation(img,compressScale);
                   
                   
               }
               
               //这是神马路径？
               NSString* filePath = [[FDSPathManager sharePathManager]getServerUserIcon];
               
               //还是看不懂
               NSString* fileName = [[FDSPublicManage sharePublicManager] getGUID];
               
               //获取userid
               NSString* uploadSessionID = [[FDSUserManager sharedManager] NowUserID];
               
               //上传图片
               [[ZZUploadManager sharedUploadManager] beginUploadRequest:filePath :fileName :uploadSessionID :@"all" :thumbData :@"jpg" :@"ShopProduct" ];
           }
           
       }
   }
   else if([btn.titleLabel.text isEqualToString:@"确定修改"])
   {
       [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];

       // 修改产品
       if(_needUpdateImage == NO)
       {
           //只是修改了产品的价格和名字等,不需要上传图片
           NSString* strid = [NSString stringWithFormat:@"%d", _model.product_id_int];
           [[UserStoreMessageManager sharedManager]updateProductWithId:strid
                                                                  name:_productName.text//_model.product_name
                                                                 price:_productPrice.text //_model.priceStr
                                                                 intro:_productBrief.text//_model.intro
                                                                brecom:[_isBrecom isOn]     //[_model.brecom intValue]
                                                                   img:_model.img
                                                              img_thum:_model.img_thum];
       }else {
           
           //修改了产品的图片,首先上传产品图片
           
           UIImage* img = _productImg.image;
           NSString *filepath = [FDSPublicManage fitSmallWithImage:img];
           if (filepath && filepath.length>0)
           {
               //NSData *thumbData = [NSData dataWithContentsOfFile:filepath];
               //先转化成二进制数据，需要路径
               NSData *thumbData = UIImageJPEGRepresentation(img, 1.0);
               
               //如果数据长度大于200kb,才按照比例压缩
               if (thumbData.length>200*1024) {
                   
                   CGFloat compressScale = 200*1024/thumbData.length;
                   thumbData = UIImageJPEGRepresentation(img,compressScale);
                   
                   
               }
               [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
               
               NSString* filePath = [[FDSPathManager sharePathManager]getServerUserIcon];
               NSString* fileName = [[FDSPublicManage sharePublicManager] getGUID];
               NSString* uploadSessionID = [[FDSUserManager sharedManager] NowUserID];
    
               [[ZZUploadManager sharedUploadManager] beginUploadRequest:filePath :fileName :uploadSessionID :@"all" :thumbData :@"jpg" :@"ShopProduct"];
           }
           
       }
   }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _productBrief.delegate = self;
    _productName.delegate = self;
    
    self.productImg.contentMode = UIViewContentModeScaleAspectFill;
    self.productImg.clipsToBounds = YES;//剪切掉多余的图片
    
    [self CreatTopView];
    
    // 添加键盘上面的辅助tool
    [self initBriefInputAccessory];
    [self initPriceInputAccessory];
    
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    _normalFrame = self.view.frame;
    
   
    //如果是修改商品,则显示修改商品的信息
    if(_model !=nil)
    {
        //找出被编辑产品的index标识
        _replaceIndex = [_productArr indexOfObject:_model];
        
        // 显示产品简介
        [_productBrief setText:_model.intro];
        
        //显示产品名称
        [_productName setText:_model.product_name];
        
        //显示产品价格
        [_productPrice setText:[_model.price stringValue]];
        // 显示是否推荐
        if([_model.brecom intValue] ==  1)
        {
            [_isBrecom setOn:YES];
        }else
        {
            [_isBrecom setOn:NO];
        }

        // 显示产品图片
        dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(defaultQueue, ^{
            // 1.1下载图片
            NSData* imgData =  [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString setupSileServerAddressWithUrl:_model.img]]];
            UIImage* productImg =  [UIImage imageWithData:imgData];

            // 1.2显示图片
            dispatch_sync(dispatch_get_main_queue(), ^{
                [_productImg setImage:productImg];
            });
        });

    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker  dismissViewControllerAnimated:YES completion:nil];
}


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
    
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setDelegate:self];
        [imagePicker setAllowsEditing:YES];
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

-(void)addPicFromAlbum {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil ];
    
}


- (IBAction)addImage:(id)sender {
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage * img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [_productImg setImage:img];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        //
    }];
    
    // 如果是添加产品,可以无视这个变量。
    _needUpdateImage = YES;
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}



-(void)textViewDidChange:(UITextView *)textView
{
 
       _productBrief.text = textView.text;
    if (_productBrief.text.length == 0) {
        _placeHolderLabel.text = @"请输入产品简介";
    }else{
        _placeHolderLabel.text = @"";
    }
}



-(void)initPriceInputAccessory
{
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [toolbar setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * priceLeftBtn = [[UIBarButtonItem alloc]initWithTitle:@"清除"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self action:@selector(clearPrice)];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(dismissKeyBoard)];
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:priceLeftBtn,btnSpace,doneButton,nil];
    
    [toolbar setItems:buttonsArray];
    [_productPrice setInputAccessoryView:toolbar];
}


-(void)initBriefInputAccessory
{
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [toolbar setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"清除"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self action:@selector(clearBriefText)];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
 
    [toolbar setItems:buttonsArray];
    [_productBrief setInputAccessoryView:toolbar];
    
    
}

-(void)dismissKeyBoard
{
    if([_productPrice isFirstResponder])
    {
        [_productPrice resignFirstResponder];
    }
    else if([_productBrief isFirstResponder])
    {
        [_productBrief resignFirstResponder];
    }

    if(_isMoveUP) {
        _isMoveUP = NO;
        
        
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
          self.view.frame = _normalFrame;
        [UIView commitAnimations];
        

    }
}


-(void)clearPrice
{
    [_productPrice setText:@""];
}

-(void)clearBriefText
{
    [_productBrief setText:@""];
    _placeHolderLabel.text = @"请输入产品简介";
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{

    int offset = 246.0;//键盘高度216
    _isMoveUP = YES;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard1" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}



-(BOOL)isPrepareToupLoad
{
    if (_productImg.image == nil)
    {
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"请设置商品图片"];
        return NO;
    }
    
    if([_productName.text length] == 0 )
    {
       [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"填写商品价格"];
        return NO;
    }
    
    if([_productBrief.text length] == 0)
    {
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"填写产品简介"];
        return NO;
    }
    
    return YES;
}


#pragma mark -回调函数
-(void)uploadStateNotice:(ZZUploadRequest*)uploadRequest
{
     // 图片上传成功
    if(uploadRequest.m_uploadState == ZZUploadState_UPLOAD_OK) {
        
        if([_viewTitle isEqualToString:@"编辑产品"])
        {
            //获取图片返回的地址
            _replaceImg_thum = uploadRequest.m_responseSmallURL;
            _replaceImg = uploadRequest.m_responseImgURL;
            
            //取出产品id
            NSString* proid = [NSString stringWithFormat:@"%d", _model.product_id_int];
            
            //发送产品修改消息
            [[UserStoreMessageManager sharedManager]updateProductWithId:proid
                                                                   name:_productName.text//_model.product_name
                                                                  price:_productPrice.text //_model.priceStr
                                                                  intro:_productBrief.text//_model.intro
                                                                 brecom:[_isBrecom isOn]     //[_model.brecom intValue]
                                                                    img:_replaceImg
                                                               img_thum:_replaceImg_thum];
            
        }
        else
        {
            // 上传商品（产品名称／产品价格／产品简介／是否推荐／图片地址)
            [[UserStoreMessageManager sharedManager]addProductWithPname:[_productName text]
                                                                  price:[_productPrice text]
                                                                  intro:[_productBrief text]
                                                                 brecom:[_isBrecom isOn]
                                                                    img:uploadRequest.m_responseImgURL
                                                               img_thum:uploadRequest.m_responseSmallURL];
        }
        
        
    }else if(uploadRequest.m_uploadedSize == ZZUploadState_UPLOAD_FAIL){
        
        // 图片上传失败
        
        //去掉菊花
        [SVProgressHUD popActivity];
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"商品上传失败"];
    }
}

//添加产品回调
-(void)addProductCB:(int)isSuccess
{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if(isSuccess == 0) {
        
        [MobClick event:@"me_add_product_click"];
        
        //将控制器弹出栈
        [self.navigationController popViewControllerAnimated:YES];

        
    } else {
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"添加商品失败"];
        
    }
}

//修改产品回调
-(void)updateProductCB:(int)returnCode
{
    if(returnCode == 0)
    {
        // 更新修改后的模型，更新模型数据
        double price = [_productPrice.text doubleValue];
        _model.price = [NSNumber numberWithDouble:price];
        _model.brecom = [NSNumber numberWithInt:[_isBrecom isOn]?1:0];
        _model.intro = [_productBrief text];
        if(_replaceImg !=nil)
        {
            _model.img = _replaceImg;
        }
    
        if(_replaceImg_thum != nil)
        {
            _model.img_thum = _replaceImg_thum;
        }
        
        //修改数组里面的对应的模型
        [_productArr  replaceObjectAtIndex:_replaceIndex withObject:_model];
        
        //将控制器弹出栈
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"修改商品失败"];

    }
}



//-(void)loadView
//{
//    CGRect screenFrame = [UIScreen mainScreen].bounds;
//    screenFrame.size.height += 30;
//    self.view = [[UIScrollView alloc]initWithFrame:screenFrame];
//}
@end
