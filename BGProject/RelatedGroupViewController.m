//
//  relatedGroupViewController.m
//  BGProject
//
//  Created by liao on 15-1-13.
//  Copyright (c) 2015年 zhuozhong. All rights reserved.
//

#import "RelatedGroupViewController.h"
#import "PlatformMessageManager.h"
#import "BaseCell.h"
#import "FriendCellModel.h"
#import "GroupSearchInfoViewController.h"

@interface RelatedGroupViewController ()<UITableViewDataSource,UITableViewDelegate,PlateformMessageInterface>

@end

@implementation RelatedGroupViewController{
    
    int _row;
    __weak UITableView *_tableView;
    
}

-(NSMutableArray *)groups{
    
    if (_groups==nil) {
        
        _groups = [[NSMutableArray alloc] init];
        
    }
    
    return _groups;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    //注册代理
    [[PlatformMessageManager sharedManager] registerObserver:self];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    
    
    //去掉代理
    [[PlatformMessageManager sharedManager] unRegisterObserver:self];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addTopBar];
    
    [self creatTableView];
}



// 最上方类似于导航栏的界面
-(void) addTopBar {
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    [self.view addSubview:topView];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    label1.text = @"相关群组";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
}

-(void)creatTableView{
    
    //tableview
    UITableView *myTableView = [[UITableView alloc] init];
    CGFloat myTableViewH = self.view.frame.size.height-kTopViewHeight;
    myTableView.frame = CGRectMake(0,kTopViewHeight , self.view.bounds.size.width, myTableViewH);
    myTableView.delegate = self;
    myTableView.dataSource =  self;
    myTableView.bounces = NO;
    myTableView.backgroundColor = [UIColor redColor];
    myTableView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:myTableView];
    _tableView = myTableView;
    
}

-(void)BackMainMenu:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark-UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.groups.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier3 = @"CellTwo";
    
    BaseCell *crowedCell = [tableView dequeueReusableCellWithIdentifier:identifier3];
    if (!crowedCell)
    {
        crowedCell = [[BaseCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier3];
    }
    crowedCell.cellFrame =self.groups[indexPath.row];
    return crowedCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BaseCellFrame *frame = self.groups[indexPath.row];
    
    BaseCellModel *model = frame.model;
    
    _row = indexPath.row;
    
    [[PlatformMessageManager sharedManager] requestGroupMembersWithRoomid:model.roomid];
    
}

-(void)requestGroupMembersCB:(NSArray *)data{
    
    NSString *groupOwerName = nil;
    
    //取出群主模型
    for (FriendCellModel *model in data) {
        
        if (model.type==2) {
            
            //记录下群主的userid
            groupOwerName = model.name;
            
        }
        
    }
    
    BaseCellFrame *frame = self.groups[_row];
    BaseCellModel *model = frame.model;
    
    GroupSearchInfoViewController *sv = [[GroupSearchInfoViewController alloc] init];
    sv.name = model.name;
    sv.intro = model.detail;
    sv.hxgroupid = model.hxgroupid;
    sv.roomid = model.roomid;
    sv.owerName = groupOwerName;
    sv.grouptype = model.grouptype;
    sv.model = model;
    [self.navigationController pushViewController:sv animated:YES];
    
}

@end
