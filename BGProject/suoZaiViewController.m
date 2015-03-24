//
//  suoZaiViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-29.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "suoZaiViewController.h"
#import "SVProgressHUD.h"
#import "FDSUserCenterMessageManager.h"
#import "FDSUserManager.h"

@interface suoZaiViewController (){
     BGUser* _user;
}

@end

@implementation suoZaiViewController

{
    UIView    *topView;
    UIButton  *backBtn;
    UITableView *myTableView;
    NSArray *_dataSource;
    NSString *_cityName;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
}
-(void)viewWillDisappear:(BOOL)animated {
    
    
    
    [super viewWillDisappear:animated];
    [SVProgressHUD popActivity];
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
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
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(140, 24, 80, 40)];
    label1.text = @"所在地";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    [self.view addSubview:topView];
    
    CGFloat tableViewX = 0;
    CGFloat tableViewY = 64;
    CGFloat tableViewW = self.view.bounds.size.width;
    CGFloat tableViewH = self.view.bounds.size.height-tableViewY;
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource =  self;
    myTableView .rowHeight =  80;
    [self.view addSubview:myTableView];
    
    
    
}

#pragma mark btnClick===================

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    
    _user = [[FDSUserManager sharedManager]getNowUser];
    
    _dataSource = [NSArray arrayWithArray:self.myCities];
    NSLog(@"nimeide%@",_dataSource);
    [myTableView reloadData];
    [super viewDidLoad];
    [self CreatTopView];
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
}
#pragma mark tabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellOne";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    _cityName = _dataSource[indexPath.row];
    NSString *hometown = [NSString stringWithFormat:@"中国%@%@",self.m_province,_cityName];
    
    
    if (self.requestTag == kReauestHometown) {
        
        //发送修改家乡消息
        [[FDSUserCenterMessageManager sharedManager]updateHometown:hometown];
        
    }else{
        //发送修改所在地消息
        [[FDSUserCenterMessageManager sharedManager]updateLocalplace:hometown];
    }
   
    
}
-(void)upDateUserInfoCB:(int)returnCode {
    
    [SVProgressHUD popActivity];
    
    NSString *place = [NSString stringWithFormat:@"中国%@%@",self.m_province,_cityName];
    
    if(returnCode==0) {
        
        if (self.requestTag == kReauestHometown) {
            
            _user.hometown = place;
            
        }else{
            
            _user.loplace = place;
        }
        
        //返回到编辑资料那个控制器
        [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
        
    } else {
        
        if (self.requestTag == kReauestHometown) {
            
            [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"家乡更新失败"];
        }else{
            
            [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"所在地更新失败"];
        }
        
        
    }
}

@end
