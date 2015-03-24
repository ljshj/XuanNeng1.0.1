//
//  MoreViewController.m
//  BGProject
//
//  Created by liao on 14-11-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "MoreViewController.h"
#import "moreModel.h"
#import "NSArray+TL.h"
#import "FeedBackViewController.h"
#import "AboutViewController.h"
#import "AppDelegate.h"
#import "FDSUserCenterMessageManager.h"
#import "SVProgressHUD.h"

@interface MoreViewController ()<UITableViewDataSource,UITableViewDelegate,UserCenterMessageInterface,UIAlertViewDelegate>{
    
    __weak UITableView *_myTableView;
    UILabel *_testLabel;
    
}

@property(nonatomic,strong) NSMutableArray *moreArray;

@end

@implementation MoreViewController

-(NSMutableArray *)moreArray{
    
    if (_moreArray == nil) {
        _moreArray = [[NSMutableArray alloc] init];
    }
    return _moreArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    AppDelegate  *app = [UIApplication sharedApplication].delegate;
    [app hiddenTabelBar];
    
    //注册代理
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
    
    
}


-(void)viewDidDisappear:(BOOL)animated{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //去掉代理
    [[FDSUserCenterMessageManager sharedManager] unRegisterObserver:self];
    
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _testLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
    _testLabel.textColor = [UIColor blackColor];
    [self.view addSubview:_testLabel];
    
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    
    //创建导航栏
    [self setupNavigationbar];
    
    //设置tableview
    [self setupTableView];
    
    //设置数据
    [self setupData];
    
}

-(void)setupData{
    
    NSArray *dataArray = [NSArray arrayWithFileName:@"moreList.plist"];
    for (NSDictionary *dic in dataArray) {
        
        moreModel *model = [[moreModel alloc] initWithDict:dic];
        [self.moreArray addObject:model];
        
    }
    
}

-(void)setupTableView{
    
    UITableView *myTableView = [[UITableView alloc] init];
    myTableView.scrollEnabled = NO;
    myTableView.delegate = self;
    myTableView.dataSource  = self;
    myTableView.separatorInset = UIEdgeInsetsZero;
    CGFloat myTableViewX = 0;
    CGFloat myTableViewY = kTopViewHeight+10;
    CGFloat myTableViewW = kScreenWidth;
    CGFloat myTableViewH = 44*3;
    myTableView.frame = CGRectMake(myTableViewX, myTableViewY, myTableViewW, myTableViewH);
    myTableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:myTableView];
    _myTableView = myTableView;

    
}

-(void)setupNavigationbar
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
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"更多";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    [self.view addSubview:topView];
    
}

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.moreArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"more";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        arrow.image = [UIImage imageNamed:@"个人中心页面_21"];
        cell.accessoryView = arrow;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    }
    
    moreModel *model = self.moreArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:model.icon];
    cell.textLabel.text = model.title;
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //取出cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //取消cell的选中效果
    [cell setSelected:NO animated:YES];
    
    if (indexPath.row == 0) {
        
        [MobClick event:@"me_feedback_click"];
        
        FeedBackViewController *FVC = [[FeedBackViewController alloc] init];//意见反馈
        [self.navigationController pushViewController:FVC animated:YES];
        
    }else if (indexPath.row == 1){
        
        //应用评分
        [self gradedAtAppStore];
    
    }else if (indexPath.row == 2){
        
        AboutViewController *AVC = [[AboutViewController alloc] init];//关于炫能
        [self.navigationController pushViewController:AVC animated:YES];
        
    }
    
}

-(void)gradedAtAppStore{
    
    //取出UIApplication
    UIApplication *app = [UIApplication sharedApplication];
    
    //炫能的app ID
    NSString *appid = @"931232202";
    
    //拼串
    NSString *urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%@?mt=8",appid];
    
    //设置url
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //判断URL是否能打开
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }
    
}

//版本更新回调
-(void)versionUpdateCB:(NSDictionary *)dic{
    
    [SVProgressHUD popActivity];

    //取出版本号
    NSString *versionStr = dic[@"versioncode"];
    
    //取出更新说明
    NSString *explain = [dic[@"explain"] stringByReplacingOccurrencesOfString:@"<div>" withString:@""];
    explain = [explain stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    explain = [explain stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
    
    //去掉黑点
    int versioncode =  [[versionStr stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
    
    //获取当前版本号
    int currentVersion =  [[[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey] stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
    
    if (currentVersion<versioncode) {
        
        //弹出对话框
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"温性提示" message:explain delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往下载", nil];
        [alertView show];
        
        
        
    }else{
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"已经是最新版本"];
        
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex) {
        
        //前往App Store下载
        [self gradedAtAppStore];
        
    }
    
}

@end
