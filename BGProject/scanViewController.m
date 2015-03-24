//
//  scanViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-29.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "scanViewController.h"
#import "EGOImageView.h"
#import "FDSPublicManage.h"

//名字字体大小
#define kNickNameSize [UIFont systemFontOfSize:16]
//签名字体大小
#define kSignatureSize [UIFont systemFontOfSize:13]
// other字体大小
#define kOtherFontSize [UIFont systemFontOfSize:10]

#define kSpace 10

#define kTopBgColor [UIColor colorWithRed:42/255.0 green:167/255.0 blue:190/255.0 alpha:1.0]


@interface scanViewController ()

//背景视图
@property (weak, nonatomic) IBOutlet UIView *topBackView;

@property (strong, nonatomic) IBOutlet UIView *iconView;

@property (strong, nonatomic) IBOutlet UILabel *iNeedLabel;
@property (strong, nonatomic) IBOutlet UILabel *iCanLabel;
// 放置头像等
@property (strong, nonatomic) IBOutlet UIView *HeaderView;


@property (strong, nonatomic)  UIImageView *sexImg;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *signatureLabel;
@property (strong, nonatomic)  UILabel *levelLabel;


@end

@implementation scanViewController
{
    UIView    *topView;
    UIButton  *backBtn;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    label1.text = @"我的名片";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(280, 40, 16, 16)];
    imageView.image = [UIImage imageNamed:@"分享"];
    [topView addSubview:imageView];
    
    [self.view addSubview:topView];
}

#pragma mark btnClick===================

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btn1Click:(id)sender
{
    if(self.isMyself) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"不能关注自己" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@ "确定", nil];
        [alert show];
    }
}
- (IBAction)btn2Click:(id)sender
{
    if(self.isMyself) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"不能加自己为好友" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@ "确定", nil];
        [alert show];
    }
}
- (IBAction)btn3Click:(id)sender
{
    if(self.isMyself) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"不能与自己发起临时会话" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@ "确定", nil];
        [alert show];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self CreatTopView];
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    

    self.topBackView.backgroundColor = kTopBgColor;
    
    _sexImg = [[UIImageView alloc]init];
    [_HeaderView addSubview:_sexImg];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.textColor = [UIColor whiteColor];
    [_HeaderView addSubview:_nameLabel];
    
    _signatureLabel = [[UILabel alloc]init];
    _signatureLabel.textColor = [UIColor whiteColor];
    [_HeaderView addSubview:_signatureLabel];
    
    _levelLabel = [[UILabel alloc]init];
    [_HeaderView addSubview:_levelLabel];
    [self showInfo];
    
}

-(void)showInfo {
    if(_user==nil) {
        
        return;
    }
    
    CGRect debugFrame;
    // 设置头像
    CGPoint startPoint = (CGPoint){80,25};
    
    EGOImageView* iconEGOView = [[EGOImageView alloc]initWithFrame:_iconView.bounds];
    iconEGOView.placeholderImage = [UIImage imageNamed:@"3.png"];
    iconEGOView.imageURL = [NSURL URLWithString:_user.photo];
    [_iconView addSubview:iconEGOView];
    debugFrame = iconEGOView.frame;
    
    //设置头像的圆角
    _iconView.layer.borderWidth = 2.0;
    _iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    CGFloat radius = _iconView.bounds.size.width*0.5;
    [_iconView.layer setCornerRadius:radius];
    [_iconView.layer setMasksToBounds:YES];
    
    // 设置昵称
    //用户名字的frame
//    CGRect iconFrame = _iconView.frame;
    CGFloat nameX = startPoint.x + kSpace;
    CGFloat nameY = startPoint.y;
    CGSize nameSize = [_user.nickn sizeWithFont:kNickNameSize forWidth:130 lineBreakMode:NSLineBreakByTruncatingTail];
    CGRect nickNameFrame = (CGRect){{nameX, nameY},nameSize};
    [self.nameLabel setFont:kNickNameSize];
    [self.nameLabel setText:_user.nickn];
    [self.nameLabel setFrame:nickNameFrame];
    
    
    //用户性别的frame  lineHeight
    CGFloat sexX = CGRectGetMaxX(nickNameFrame)+kSpace*0.5;
    CGFloat sexY = nameY;
    CGFloat sexH = kNickNameSize.lineHeight;//和名字的控件等高
    CGFloat sexW = sexH;
    CGRect sexFrame = (CGRect){{sexX,sexY},{sexW,sexH}};
    NSString *sexImageName = [self imageNameWithSex:_user.sex];
    _sexImg.image = [UIImage imageNamed:sexImageName];
    _sexImg.contentMode = UIViewContentModeScaleAspectFit;
    [_sexImg setFrame:sexFrame];
    
    
    
    //用户等级
    CGFloat levelX =  CGRectGetMaxX(sexFrame)+kSpace;
    CGFloat levelY = sexY;
    CGSize levelSize = [_user.level sizeWithFont:kOtherFontSize forWidth:44 lineBreakMode:NSLineBreakByTruncatingTail];
    // 等级
    CGRect leaveFrame =(CGRect){{levelX,levelY},levelSize};
    [self.levelLabel setFont:kOtherFontSize];
    //先不用显示用户等级
    //[self.levelLabel setText:_user.level];
    [self.levelLabel setFrame:leaveFrame];
    
    
    //签名
    CGFloat signatureX = nameX;
    CGFloat signatureY = CGRectGetMaxY(nickNameFrame)+kSpace;
    CGSize signatureSize = [_user.signature sizeWithFont:kSignatureSize forWidth:200 lineBreakMode:NSLineBreakByTruncatingTail];
    CGRect signFrame =(CGRect ){{signatureX,signatureY},signatureSize};
    [_signatureLabel setFont:kSignatureSize];
    [_signatureLabel setText:_user.signature];
    [_signatureLabel setFrame:signFrame];
    
    
    [self.iNeedLabel setText:_user.ineed];
    [self.iCanLabel setText:_user.ican];
    
}

-(NSString *)imageNameWithSex:(NSString *)sex{
    //0 女 1 男 2 保密
    int value = [sex intValue];
    NSString *sexImageName = nil;
    if(value == 0) {
        sexImageName = @"我的名片_04";
    }
    if(value == 1) {
        sexImageName = @"我的名片_03";
    }
    return sexImageName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
