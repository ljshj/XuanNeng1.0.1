//
//  addFriendViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "addGroupViewController.h"
#import "CreatGroupViewController.h"
#import "PlatformMessageManager.h"
#import "AppDelegate.h"
#import "EaseMob.h"
#import "BaseCellModel.h"
#import "BaseCellFrame.h"
#import "BaseCell.h"
#import "GroupSearchInfoViewController.h"
#import "FriendCellModel.h"

#define DividerColor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]
#define DividerFrameZero CGRectMake(0,81-0.5 , self.view.bounds.size.width, 0.5)

@interface addGroupViewController ()<PlateformMessageInterface,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSMutableArray *groupFrames;

@end

@implementation addGroupViewController
{
    UIView *topView;
    UIButton *backBtn;
    UITextField *tf;
    
    __weak UITableView *_tableView;
    
    int _row;
}

-(NSMutableArray *)groupFrames{
    
    if (_groupFrames==nil) {
        
        _groupFrames = [[NSMutableArray alloc] init];
        
    }
    
    return _groupFrames;
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    AppDelegate *appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [appDelegate hiddenTabelBar];
    
    //注册代理
    [[PlatformMessageManager sharedManager] registerObserver:self];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    
    
    //去掉代理
    [[PlatformMessageManager sharedManager] unRegisterObserver:self];
    
}


-(void)CreatView
{
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(135, 24, 60, 40)];
    label1.text = @"添加群";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    
    UIButton  *button3 = [[UIButton alloc]initWithFrame:CGRectMake(250, 24, 60, 40)];
    button3.titleLabel.font = [UIFont systemFontOfSize:16];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button3 setTitle:@"创建群" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(bannerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:button3];
    
    [topView addSubview:backBtn];
    [topView addSubview:label1];
    [self.view addSubview:topView];
    
    //输入框
    tf= [[UITextField alloc]initWithFrame:CGRectMake(10, topView.frame.origin.y+topView.frame.size.height+10, 300, 44)];
    tf.delegate = self;
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.font = [UIFont systemFontOfSize:15.0];
    tf.returnKeyType = UIReturnKeySearch;
    //tf.keyboardType = UIKeyboardTypeNumberPad;//数字键盘
    tf.placeholder = @"请输入群号或群名";
    
    //放大镜
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 11, 20, 22)];
    imageView.image =[UIImage imageNamed:@"添加好友_06"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 44)];
    lineView.backgroundColor =[UIColor grayColor];
    lineView.alpha = 0.2;
    
    UIView *bigView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 41, 44)];
    [bigView addSubview:imageView];
    [bigView addSubview:lineView];
    
    tf.rightView = bigView;
    tf.rightViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:tf];
    
    
    
}
#pragma mark btnClick------------------
-(void)bannerBtnClick:(UIButton *)sender
{
    CreatGroupViewController *creatGroup =[[CreatGroupViewController alloc]init];
    [self.navigationController pushViewController:creatGroup animated:YES];
}
-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self CreatView];
    
    [self creatTableView];
    
    //背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
}

-(void)creatTableView{
    
    //tableview
    UITableView *myTableView = [[UITableView alloc] init];
    CGFloat myTableViewH = self.view.frame.size.height-CGRectGetMaxY(tf.frame)-10;
    myTableView.frame = CGRectMake(0,CGRectGetMaxY(tf.frame)+10 , self.view.bounds.size.width, myTableViewH);
    myTableView.delegate = self;
    myTableView.dataSource =  self;
    myTableView.bounces = NO;
    myTableView.separatorColor = [UIColor whiteColor];
    myTableView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:myTableView];
    _tableView = myTableView;
    
}

#pragma mark uitextFiedDelegate----
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tf  resignFirstResponder];
    
    
    [[PlatformMessageManager sharedManager] findGroupWithKeyword:tf.text start:0 end:10];
    
    return YES;
}

-(void)findGroupCB:(NSDictionary *)data{
    
    NSArray *items = data[@"items"];
    
    for (NSDictionary *dic in items) {
        
        BaseCellModel *model = [[BaseCellModel alloc] initWithDic:dic];
        
        BaseCellFrame* cellFrame = [[BaseCellFrame alloc]init];
        cellFrame.model = model;
        
        cellFrame.cellFrameType=CellFrameTypeGroup;
        
        [self.groupFrames addObject:cellFrame];
        
    }
    
    [_tableView reloadData];
    
}

#pragma mark-UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.groupFrames.count;
    
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
    
    crowedCell.cellFrame =self.groupFrames[indexPath.row];
    
    [self addDividerBottomWithCell:crowedCell indexPath:indexPath];
    
    return crowedCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self tableViewDeSelect:tableView];
    
    BaseCellFrame *frame = self.groupFrames[indexPath.row];
    
    BaseCellModel *model = frame.model;
    
    _row = indexPath.row;
    
    [[PlatformMessageManager sharedManager] requestGroupMembersWithRoomid:model.roomid];
    
}

//取消选中效果
-(void)tableViewDeSelect:(UITableView*)table
{
    NSIndexPath* indexPath = [table indexPathForSelectedRow];
    [table deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

//添加底部分割线
-(void)addDividerBottomWithCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = DividerColor;
    
    divider.frame = DividerFrameZero;
    
    
    [cell addSubview:divider];
    
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
    
    BaseCellFrame *frame = self.groupFrames[_row];
    BaseCellModel *model = frame.model;
    
    GroupSearchInfoViewController *sv = [[GroupSearchInfoViewController alloc] init];
    sv.name = model.name;
    sv.intro = model.detail;
    sv.hxgroupid = model.hxgroupid;
    sv.roomid = model.roomid;
    sv.owerName = groupOwerName;
    sv.grouptype = model.grouptype;
    [self.navigationController pushViewController:sv animated:YES];
    
}

@end
