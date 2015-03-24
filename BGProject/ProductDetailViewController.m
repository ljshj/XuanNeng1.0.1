//
//  ProductDetailViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-10-14.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//  显示产品详情


#import "ProductDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "NSString+TL.h"
#import "FDSUserManager.h"
#import "UserStoreMessageInterface.h"
#import "UserStoreMessageManager.h"
#import "SVProgressHUD.h"
#import "BGWQCommentModel.h"
#import "BGWQCommentCellFrame.h"
#import "ProCommentViewController.h"
#import "PersonlCardViewController.h"

#define kTopViewHeight 64
#define kPriceLabelFont [UIFont systemFontOfSize:20.0]
#define kIntroLabelFont [UIFont systemFontOfSize:15.0]
#define kProductNameFont [UIFont systemFontOfSize:16.0]
#define kPriceLabelBgColor [UIColor colorWithRed:253/255.0 green:100/255.0 blue:52/255.0 alpha:1]

#define kSpaceH 10

@interface ProductDetailViewController ()<UserStoreMessageInterface,UserCenterMessageInterface>


@end

@implementation ProductDetailViewController
{
    
    UIImageView* _productImageView;
    UILabel*  priceLabel;
    UILabel*  _productTitleLabel;
    
    UILabel* _productIntroLable;// 显示简介
    UIButton* _showCommentBtn;//查看所有评论
    CGFloat viewAtY;        //设置子控件的位置
    UIButton* _contactButton;// 联系卖家
    
    UILabel* _priceLabel;
    
}

-(void)viewDidLoad
{
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //创建导航栏
    [self CreatView];
    
    //创建页面
    [self initOtherViews];
    
    //获取产品详情信息
    [[UserStoreMessageManager sharedManager] request30007WithProID:[NSString stringWithFormat:@"%d",self.model.product_id_int]];
    
}

//请求产品详情，只为取得userid
-(void)request30007CB:(NSDictionary *)data{
    
    self.userid = data[@"userid"];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    //注册代理，商店单独一个管理中心
    [[UserStoreMessageManager sharedManager]registerObserver:self];
    
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    
    [[FDSUserCenterMessageManager sharedManager] unRegisterObserver:self];
    
    //去掉代理
    [[UserStoreMessageManager sharedManager]unRegisterObserver:self];
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
}

-(void)CreatView
{
    //导航栏
    UIView* topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopViewHeight)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    UIButton* backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    label1.text = @"产品详情";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    [self.view addSubview:topView];
    //获取导航栏最大的y
    viewAtY = CGRectGetMaxY(topView.frame);
}

-(void)initOtherViews
{
    
    //产品图片
    _productImageView = [[UIImageView alloc] init];
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, viewAtY, kScreenWidth, 160);
    backView.clipsToBounds = YES;
    [self.view addSubview:backView];
    _productImageView.backgroundColor = [UIColor whiteColor];
    
    NSData *data = nil;
    if (self.productType==ProductTypeAll) {
        
        [_productImageView setImageWithURL:[NSURL URLWithString:[NSString setupSileServerAddressWithUrl:_model.img]] placeholderImage:[UIImage imageNamed:@"headphoto_s"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString setupSileServerAddressWithUrl:_model.img]]];

        
    }else{
        
        [_productImageView setImageWithURL:[NSURL URLWithString:[NSString setupSileServerAddressWithUrl:_reModel.img]] placeholderImage:[UIImage imageNamed:@"headphoto_s"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString setupSileServerAddressWithUrl:_reModel.img]]];
        
    }
    
    UIImage *img = [UIImage imageWithData:data];
    CGFloat imgY = 0;
    CGFloat imgH = kScreenWidth*(img.size.height/img.size.width);//这个才是按照比例缩放后的高
    if (imgH>160) {
        imgY = -(imgH-160)*0.5;
    }else{
        imgY = (imgH-160)*0.5;
    }
    _productImageView.frame = CGRectMake(0, imgY, kScreenWidth, imgH);
    
    
    [backView addSubview:_productImageView];
    
    //价格
    _priceLabel = [[UILabel alloc]init];
    if (self.productType==ProductTypeAll) {
        
        _priceLabel.text = _model.priceStr;
        
    }else{
        
        _priceLabel.text = _reModel.price;
        
        
    }
    CGSize priceSize = [NSString sizeWithText:_priceLabel.text font:kPriceLabelFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];//算出价格的size
    CGFloat priceH = priceSize.height+10;//高度加多10
    CGFloat priceW = priceSize.width+20;//宽度加多20
    CGFloat priceX = kScreenWidth-priceW;
    CGFloat priceY = backView.frame.size.height-priceH;
    _priceLabel.frame = CGRectMake(priceX, priceY, priceW, priceH);
    _priceLabel.font = kPriceLabelFont;
    [_priceLabel setBackgroundColor:kPriceLabelBgColor];
    [_priceLabel setTextColor:[UIColor whiteColor]];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    
    [backView addSubview:_priceLabel];
    
    //产品标题
    _productTitleLabel = [[UILabel alloc] init];
    NSString *productName = nil;
    if (self.productType==ProductTypeAll) {
        
        productName=_model.product_name;
        
    }else{
        
        productName=_reModel.product_name;
        
    }
    CGSize titleSize = [NSString sizeWithText:productName font:kProductNameFont maxSize:CGSizeMake(kScreenWidth-2*kSpaceH, MAXFLOAT)];
    CGFloat titleX = kSpaceH;
    CGFloat titleY = CGRectGetMaxY(backView.frame)+kSpaceH;
    CGFloat titleW = titleSize.width;
    CGFloat titleH = titleSize.height;
    _productTitleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    _productTitleLabel.backgroundColor = [UIColor whiteColor];
    _productTitleLabel.numberOfLines = 0;
    _productTitleLabel.font = kProductNameFont;
    _productTitleLabel.text = productName;
    [self.view addSubview:_productTitleLabel];
    
    //获取_productTitleLabel的最大y值
    viewAtY = CGRectGetMaxY(_productTitleLabel.frame)+kSpaceH;
    
    //简介标题背景视图
    UILabel* grayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, viewAtY, kScreenWidth, 25)];
    grayLabel.backgroundColor =[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    [self.view addSubview:grayLabel];
    
    //简介标签
    UILabel* briefLable = [[UILabel alloc]initWithFrame:CGRectMake(kSpaceH, viewAtY, kScreenWidth-2*kSpaceH, 25)];
    briefLable.backgroundColor =[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    [briefLable setFont:[UIFont systemFontOfSize:13]];
    [briefLable setText:@"简介"];
    [self.view addSubview:briefLable];
    
    //简介详情标签
    NSString *intro = nil;
    if (self.productType==ProductTypeAll) {
        
        intro=_model.intro;
        
    }else{
        
        intro=_reModel.intro;
        
    }
    _productIntroLable = [[UILabel alloc] init];
    CGSize introSize = [NSString sizeWithText:intro font:kIntroLabelFont maxSize:CGSizeMake(kScreenWidth-2*kSpaceH, MAXFLOAT)];
    CGFloat introX = kSpaceH;
    CGFloat introY = CGRectGetMaxY(briefLable.frame)+kSpaceH;
    CGFloat introW = introSize.width;
    CGFloat introH = introSize.height;
    _productIntroLable.frame = CGRectMake(introX, introY, introW, introH);
    _productIntroLable.numberOfLines = 0;
    _productIntroLable.font = kIntroLabelFont;
    _productIntroLable.text = intro;
    [self.view addSubview:_productIntroLable];
    
    //标识
    viewAtY = CGRectGetMaxY(_productIntroLable.frame)+kSpaceH;
    
    //评论
    _showCommentBtn = [self createButtonWithTitle:@"查看所有评论"
                                        imageName:@"个人中心页面_21"
                                              atY:viewAtY
                                       titleAlign:@"left"];
    [_showCommentBtn addTarget:self action:@selector(showComments) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_showCommentBtn];
    
    //标识
    viewAtY = self.view.bounds.size.height - 44;
    
    //联系商家和上面那个查看评论都调用了同一个方法来创建
    _contactButton = [self createButtonWithTitle:@"联系卖家" imageName:nil atY:viewAtY titleAlign:@"center"];
    [_contactButton addTarget:self action:@selector(contractSomebody) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_contactButton];
    
    
}


-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 显示所有评论
-(void)showComments
{
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    int productid = -1;
    if (self.productType==ProductTypeAll) {
        
        productid = _model.product_id_int;
        
    }else{
        
        productid=[_reModel.product_id intValue];
        
    }
    
    //发送获取评论消息
    [[UserStoreMessageManager sharedManager] requestProductCommentsWithProID:productid start:0 end:kRequestCount];
    
    
}

//请求商品评论回调
-(void)requestProductCommentsCB:(NSArray *)data{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //创建评论控制器
    ProCommentViewController *commentVC = [[ProCommentViewController alloc] init];
    
    //获取产品ID
    
    int productid = -1;
    if (self.productType==ProductTypeAll) {
        
        productid=_model.product_id_int;
        
    }else{
        
        productid=[_reModel.product_id intValue];
        
    }
    
    commentVC.product_id = productid;
    
    //字典数组转换成模型数组
    for (NSDictionary *dic in data) {
        
        //将字典转换成模型
        BGWQCommentModel *model = [BGWQCommentModel commentWithDic:dic];
        
        //将模型转换成cellframe
        BGWQCommentCellFrame *cellFrame = [[BGWQCommentCellFrame alloc] initWithModel:model];
        
        //添加到数组
        [commentVC.commentCellFrames addObject:cellFrame];
        
    }
    
    //切换控制器
    [self.navigationController pushViewController:commentVC animated:YES];

    
}

// 联系卖家
-(void)contractSomebody
{
    
    [MobClick event:@"me_contact_seller_click"];
    
    //获取个人资料
    [[FDSUserCenterMessageManager sharedManager] userRequestUserInfo:self.userid];
    
    //不是用户本身的
    [FDSUserCenterMessageManager sharedManager].userInfoType=UserInfoTypeOtherUserInfo;
    
}
-(void)getUserInfoCB:(NSDictionary *)dic{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if ([FDSUserCenterMessageManager sharedManager].userInfoType==UserInfoTypeOtherUserInfo) {
        
        PersonlCardViewController *pv = [[PersonlCardViewController alloc] init];
        pv.userDic = dic;
        pv.userid = self.userid;
        
        [self.navigationController pushViewController:pv animated:YES];
        
    }
    
    
    
}


-(UIButton*)createButtonWithTitle:(NSString*)title
                   imageName:(NSString*)imageName
                         atY:(CGFloat)atY
                        titleAlign:(NSString*)align
{
    //背景按钮
    UIButton* btn = nil;
    btn = [[UIButton alloc]initWithFrame:CGRectMake(0, atY, kScreenWidth, 44)];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    //这是啥？
    UILabel* infoLabel = [[UILabel alloc ]init];
    infoLabel.font = [UIFont systemFontOfSize:15.0];
    
    //箭头？？
    UIImageView *imgView2 = [[UIImageView alloc]init ];
    
    
   if([align isEqualToString:@"left"] || align == nil)
   {
        [infoLabel setFrame:CGRectMake(10, 0, 200, 44)];
        [imgView2 setFrame:CGRectMake(288, 14, 12, 12)];
   }else
   {
       [infoLabel setFrame:CGRectMake(0, 0, kScreenWidth, 44)];
       infoLabel.textAlignment =    NSTextAlignmentCenter;
       [imgView2 setFrame:CGRectMake(288, 14, 12, 12)];
   }
    
    
    infoLabel.text  = title;//@"查看所有评论";
    
    //果然是箭头
    imgView2.image = [UIImage imageNamed:imageName ] ;//@"个人中心页面_21"];
    [btn addSubview:infoLabel];
    [btn addSubview:imgView2];
    
    
    return  btn;
}


@end
