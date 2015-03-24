//
//  useraccountViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "useraccountViewController.h"
#import "changeSercretViewController.h"
#import "myMaterialViewController.h"
#import "PersonViewController.h"
#import "AppDelegate.h"
#import "FDSUserCenterMessageManager.h"
#import "FDSUserManager.h"
#import "ZZUserDefaults.h"
#import "MenCenterViewController.h"


@interface useraccountViewController ()

@end


#define kTextColor [UIColor colorWithRed:246/255.0 green:58/255.0 blue:7/255.0 alpha:1]
@implementation useraccountViewController
{
    UIView   *topView;
    UIButton *backBtn;
    
    NSArray *lableImgArr;
    NSArray *labelTextArr;
    
    NSArray *btnImgArr;
    NSArray *btnLabelArr;
    
    UILabel *btnLabel;
    UIButton *botmBtn;
    UIButton *exitBtn;
    
    
    //add by zhangxx
    UILabel* _nicktitleLabel;
    UILabel* _expLabel;
    
    UILabel* _creditLabel;     //信用
    UILabel* _favorLabel;      //好评
    
    UILabel* _levelLabel;
    UILabel* _fansnumber;     
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        lableImgArr  = [NSArray arrayWithObjects:@"账号中心_03",@"账号中心_05",@"账号中心_09",@"账号中心_10", nil];
        labelTextArr = [NSArray arrayWithObjects:@"信用值:",@"好评:",@"等级:",@"粉丝:", nil];
        
        btnImgArr   = [NSArray arrayWithObjects:@"账号中心_14",@"账号中心_17", nil];
        btnLabelArr = [NSArray arrayWithObjects:@"修改密码",@"编辑个人资料" ,nil];
    }

    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    //将导航栏隐藏起来
    self.navigationController.navigationBarHidden = YES;
    
    //取出代理并且隐藏tabbar
    AppDelegate  *app = (AppDelegate  *)[UIApplication sharedApplication].delegate;
    [app hiddenTabelBar];
    
    //取出用户模型
    BGUser* user = [[FDSUserManager sharedManager]getNowUser];
    
    //显示信息
    [self showUserInfo:user];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //注册通知(当一个语音点击的时候通知其他cell要将GIF图删掉)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(popLogoffController)
                                                 name:PopLogoffControllerKey object:nil];
    
    //
    [self CreatTopView];
    
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0  blue:234/255.0  alpha:1];
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
    UILabel  *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    label.text = @"账号中心";
    label.textColor = TITLECOLOR;
    label.font = TITLEFONT;
    [topView addSubview:label];
    [self.view addSubview:topView];
    
    //账号标签
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, topView.frame.origin.y+topView.frame.size.height+5, 40, 20)];
    label1.text = @"账号";
    [self.view addSubview:label1];
    
    //当前头衔／经验值
    for (int i = 0 ; i < 2; i++) {
        btnLabel = [[UILabel alloc]initWithFrame:CGRectMake(5+160*i, label1.frame.origin.y+label.frame.size.height-15, 150, 33)];
        btnLabel.backgroundColor =[UIColor whiteColor];
        btnLabel.layer.borderWidth =  0.5;
        btnLabel.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0  blue:234/255.0  alpha:1].CGColor;

        btnLabel.tag = i;
        
        //直接赋值，不用请求数据吗？
        if (btnLabel.tag == 0) {
            btnLabel.text = [NSString stringWithFormat:@"当前头衔:普通平民"];
            _nicktitleLabel = btnLabel;
            
        }
        else
        {
            btnLabel.text = [NSString stringWithFormat:@"经验值:850/2500"];
            _expLabel = btnLabel;
        }
        [self.view addSubview:btnLabel];
        
    }
    
    //添加信用／好评／粉丝／等级
    for (int i = 0; i < 2; i++)
        for (int j= 0 ; j < 2; j++)
        {
            //背景按钮，改成UIView就可以了，但是UILabel为什么不能添加子控件
            UIView *lableBig = [[UIView alloc]initWithFrame:CGRectMake(5+160*j, btnLabel.frame.origin.y+btnLabel.frame.size.height+5+40*i, 150, 35)];
            lableBig.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0  blue:234/255.0  alpha:1].CGColor;
            lableBig.layer.borderWidth = 0.5;
            lableBig.tag = j+2*i;
            lableBig.backgroundColor = [UIColor whiteColor];
            
            //图标
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(20,12, 15, 15)];
            img.image = [UIImage imageNamed: lableImgArr[j+2*i]];
            
            //中间说明标签
            UILabel *lableSmall = [[UILabel alloc]initWithFrame:CGRectMake(img.frame.origin.x+img.frame.size.width+5, 10, 40, 20)];
            lableSmall.text = labelTextArr[j+2*i];
            
            if (lableBig.tag == 0) {
                lableSmall.frame = CGRectMake(img.frame.origin.x+img.frame.size.width+5, 8, 60, 20);
            }
            
            //数值的标签
            UILabel *lableEnd =[[UILabel alloc]initWithFrame:CGRectMake(lableSmall.frame.origin.x+lableSmall.frame.size.width, lableSmall.frame.origin.y, 50, 20)];
            
           
            //数值放在endLabel 中
            if(i==0) {
                if(j==0) {
                    //信用
                    _creditLabel = lableEnd;
                    [_creditLabel setTextColor:kTextColor];
                }
                if(j==1) {
                    //好评
                    _favorLabel = lableEnd;
                    [_favorLabel setTextColor:kTextColor];
                }
            }
            
            else if(i==1){
                if(j==0) {
                    //等级
                    _levelLabel = lableEnd;
                    [_levelLabel setTextColor:kTextColor];
                }
                if(j==1) {
                    //粉丝
                    _fansnumber = lableEnd;
                    [_fansnumber setTextColor:kTextColor];
                }
            }
            
            [lableBig addSubview:img];
            [lableBig addSubview:lableSmall];
            [lableBig addSubview:lableEnd];
            [self.view addSubview:lableBig];
            
            
        }
    

    // 添加个人与隐私的 tabel; 上面的label没有显示!
    UILabel *personlabel =[[UILabel alloc]initWithFrame:CGRectMake(5, 220, 100, 30)];;
    personlabel .text  =@"个人与隐私";
    [self.view addSubview:personlabel];

    //修改密码和编辑个人资料
    for (int i = 0; i < 2; i++) {
        
        botmBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, personlabel.frame.origin.y+personlabel.frame.size.height+i*44.5, 310, 44)];
        botmBtn.tag = 100+i;
        
        UIImageView *imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 22.5, 22.5)];
        imgView1.image = [UIImage imageNamed:btnImgArr[i]];
        
        UILabel *label = [[UILabel alloc ]initWithFrame:CGRectMake(imgView1.frame.origin.x+imgView1.frame.size.width+15, 5, 130, 35)];
        label.text  = btnLabelArr[i];
        
        UIImageView *imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(288, 14, 12, 12)];
        imgView2.image = [UIImage imageNamed:@"个人中心页面_21"];
        
        [botmBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [botmBtn setBackgroundColor:[UIColor whiteColor]];
        [botmBtn addSubview:imgView1];
        [botmBtn addSubview:label];
        [botmBtn addSubview:imgView2];
        [self.view addSubview:botmBtn];
    }
    
    //分割线
    UIView *barrView =[[UIView alloc]initWithFrame:CGRectMake(0, 294.5, 320, 0.5)];
    barrView.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0  blue:234/255.0  alpha:1];
    
    //退出登录按钮
    exitBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 370, 320, 44)];
    exitBtn.backgroundColor = [UIColor whiteColor];
    exitBtn.tag = 102;
    
     [exitBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [exitBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:exitBtn];
    
    
}

#pragma mark btnclick=--------------

-(void)bottomBtnClick:(UIButton *)sender
{
    
    //修改密码
    if (sender.tag == 100) {
        changeSercretViewController *change = [[changeSercretViewController alloc]init];
        [self.navigationController pushViewController:change animated:YES];
    }
    
    //编辑个人资料
    else if (sender.tag == 101)
    {
        myMaterialViewController *mater = [[myMaterialViewController alloc]init];
        [self.navigationController pushViewController:mater animated:YES];
    }
    else
    {
        
        //环信账户注销
        EMError *error = nil;
        [[EaseMob sharedInstance].chatManager logoffWithError:&error];
        if (error) {
            
            //提示框
            [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"退出登录失败"];
            
        }else{
            
            //修改登录状态为没登录
            [[FDSUserManager sharedManager] setNowUserState:USERSTATE_NONE];
            
            //将用户ID置空
            [[FDSUserManager sharedManager] setNowUserIDEmpty];
            
            //清空账号即可
            [ZZUserDefaults setUserDefault:USER_COUNT    :nil];
            [ZZUserDefaults setUserDefault:USER_PASSWORD :nil];
            
            //登录页面
            PersonViewController *person = [[PersonViewController alloc]init];
            
            [self.navigationController pushViewController:person animated:YES];
            
        }
        
        
    }
}
-(void)popLogoffController{
    
    [self performSelector:@selector(BackMainMenu:) withObject:nil afterDelay:1.0];
    
}

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showUserInfo:(BGUser*) user {
    
    //这是干嘛用的？？
    CGRect testFrame;
    
    //粉丝
    [_fansnumber setText: user.fansnumber];
    testFrame = [_fansnumber frame];
    
    //好评
    [_favorLabel setText:user.favor];
    testFrame = [_favorLabel frame];
    
    //等级
    [_levelLabel setText:user.level];
    
    //信用值
    [_creditLabel setText:user.credit];

}

-(void)dealloc{
    
    //删除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PopLogoffControllerKey object:nil];
    
}

@end
