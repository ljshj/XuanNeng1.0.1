//
//  PersonlCardViewController.m
//  BGProject
//
//  Created by liao on 14-12-2.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "PersonlCardViewController.h"
#import "FDSUserCenterMessageManager.h"
#import "PersonlHeaderView.h"
#import "AppDelegate.h"
#import "moreModel.h"
#import "NSArray+TL.h"
#import "MoudleMessageManager.h"
#import "FDSUserManager.h"
#import "myWeiQiangController.h"
#import "SVProgressHUD.h"
#import "UserStoreMessageManager.h"
#import "myStoreViewController.h"
#import "myXuanNengViewController.h"
#import "EaseMob.h"
#import "liaoTianViewController.h"
#import "PersonViewController.h"
#import "UMSocial.h"

#define DividerColor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]
#define DividerFrameZero CGRectMake(0,44-0.5 , self.view.bounds.size.width, 0.5)

@interface PersonlCardViewController ()<UserCenterMessageInterface,UITableViewDataSource,UITableViewDelegate,MoudleMessageInterface,UserStoreMessageInterface,PersonlHeaderViewDelegate,UMSocialUIDelegate>{
    
    __weak UITableView *_myTableView;
    PersonlHeaderView *_header;
    
    //记录下要添加的用户名
    NSString *_username;
    
    //记录下关注按钮的状态
    BOOL _buttonStatus;
    
    UIImage *_cutImage;
    
}

@property(nonatomic,strong) NSMutableArray *cardArray;

@end

@implementation PersonlCardViewController

-(NSMutableArray *)cardArray{
    
    if (_cardArray == nil) {
        _cardArray = [[NSMutableArray alloc] init];
    }
    return _cardArray;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    
    //注册代理
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
    
    [[MoudleMessageManager sharedManager] registerObserver:self];
    
    [[UserStoreMessageManager sharedManager] registerObserver:self];
    
    AppDelegate  *app = [UIApplication sharedApplication].delegate;
    [app hiddenTabelBar];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    
    
    //去掉注册
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
    [[MoudleMessageManager sharedManager] unRegisterObserver:self];
    [[UserStoreMessageManager sharedManager] unRegisterObserver:self];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _header = [[PersonlHeaderView alloc] init];
    NSString *nowUserid = [[FDSUserManager sharedManager]NowUserID];
    NSString *modelUserid = self.userDic[@"userid"];
    int headerH = 0;
    //如果是用户本身或者是未登录的游客都不显示操作条，nowUserid为nil,说明未登录
    if ([nowUserid isEqualToString:modelUserid] || nowUserid==nil) {
        
        headerH = 310-50;
        
    }else{
        
        headerH = 310;
        
    }
    _header.frame = CGRectMake(0, 0, self.view.frame.size.width, headerH+10);
    _header.delegate = self;
    _header.userDic = self.userDic;
    
    //设置导航栏
    [self setupNavigationbar];
    
    //设置tableview
    [self setupTableView];
    
    //设置数据
    [self setupData];
    
}

-(void)setupData{
    
    NSArray *dataArray = [NSArray arrayWithFileName:@"personCardList.plist"];
    for (NSDictionary *dic in dataArray) {
        
        moreModel *model = [[moreModel alloc] initWithDict:dic];
        [self.cardArray addObject:model];
        
    }
    
}

-(void)setupTableView{
    
    UITableView *myTableView = [[UITableView alloc] init];
    //myTableView.scrollEnabled = NO;
    myTableView.delegate = self;
    myTableView.dataSource  = self;
    myTableView.separatorInset = UIEdgeInsetsZero;
    CGFloat myTableViewX = 0;
    CGFloat myTableViewY = kTopViewHeight;
    CGFloat myTableViewW = kScreenWidth;
    //CGFloat myTableViewH = 44*3+_header.frame.size.height;
    CGFloat myTableViewH = self.view.bounds.size.height-kTopViewHeight;
    myTableView.frame = CGRectMake(myTableViewX, myTableViewY, myTableViewW, myTableViewH);
    myTableView.tableHeaderView = _header;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    label1.text = @"名片";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    
    UIButton *shareButton = [[UIButton alloc] init];
    CGFloat shareW = 25*344/400;
    CGFloat shareX = self.view.frame.size.width-shareW-15;
    CGFloat shareH = 25;
    CGFloat shareY = 30;
    shareButton.frame = CGRectMake(shareX, shareY, shareW, shareH);
    [shareButton setImage:[UIImage imageNamed:@"sharePersonCard"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:shareButton];
    
    NSString *currentUserid = [[FDSUserManager sharedManager] NowUserID];
    if ([currentUserid isEqualToString:self.userid]) {
        
        shareButton.hidden = NO;
        
    }else{
        
        shareButton.hidden = YES;
        
    }
    [self.view addSubview:topView];
    
}

-(void)shareButtonClick{
    
    UIGraphicsBeginImageContextWithOptions(_myTableView.frame.size, YES, 0);
    
    [_myTableView.layer renderInContext:UIGraphicsGetCurrentContext()];
    _cutImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"54f6d2a1fd98c5d705000132"
                                      shareText:nil
                                     shareImage:_cutImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToTencent,UMShareToRenren,UMShareToQQ,UMShareToQzone,nil]
                                       delegate:self];
    
    
}

//分享回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        NSLog(@"responseCode == UMSResponseCodeSuccess");
        
        
    }
}

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.cardArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"personlCard";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        arrow.image = [UIImage imageNamed:@"个人中心页面_21"];
        cell.accessoryView = arrow;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    }
    
    moreModel *model = self.cardArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:model.icon];
    
    NSString *userid = [[FDSUserManager sharedManager] NowUserID];
    if (![userid isEqualToString:self.userid]) {
        
        cell.textLabel.text = model.title;
        
    }else{
        
        if (indexPath.row==0) {
            
            cell.textLabel.text = @"我的炫能";
            
        }else if (indexPath.row==1){
            
            cell.textLabel.text = @"我的微墙";
            
        }else if (indexPath.row==2){
            
            cell.textLabel.text = @"我的橱窗";
            
        }
        
    }
    
    [self addDividerBottomWithCell:cell indexPath:indexPath];
    
    return cell;
    
    
}

//添加底部分割线
-(void)addDividerBottomWithCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = DividerColor;
    
    divider.frame = DividerFrameZero;
    
    [cell addSubview:divider];
    
}

//取消选中效果
-(void)tableViewDeSelect:(UITableView*)table
{
    NSIndexPath* indexPath = [table indexPathForSelectedRow];
    [table deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self tableViewDeSelect:tableView];

    if (indexPath.row==1) {
        
        [MobClick event:@"namecard_weiqiang_friend_click"];
        
        // 显示我的微墙
        int type = 0;//表示我的
        int start = 0;
        
        //获取用户id
        int userid = [self.userid intValue];
        
        //发送获取微墙的消息
        [[MoudleMessageManager sharedManager] WeiQiangList:type start:start end:start+kRequestCount userid:userid];
        
    }else if (indexPath.row==2){
        
        [MobClick event:@"namecard_chuchuang_friend_click"];
        
        //爆菊花
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        
        //发送请求橱窗消息
        [[UserStoreMessageManager sharedManager]request30001WithID:self.userid];
        
    }else{
        
        [MobClick event:@"namecard_xuanneng_friend_click"];
        
        myXuanNengViewController *mv = [[myXuanNengViewController alloc] init];
        
        NSString *userid = [[FDSUserManager sharedManager] NowUserID];
        
        //如果userID相等，显示的是我的炫能
        if (![userid isEqualToString:self.userid]) {
            
            mv.xuanNengType=XuanNengTypeOther;
            
        }
        
        mv.userid = self.userid;
        [self.navigationController pushViewController:mv animated:YES];
        
    }
    
}

//我的微墙回调
-(void)weiQiangListCB:(NSArray *)result {
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //如果数组为空，说明没有微博
    if([result count] == 0)
    {
        //显示提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"暂时没有微博数据"];
        
    } else {
        
        // 我的微墙的回调 2014年09月27日 copy之前写的jock 完成微墙的单元格
        myWeiQiangController *weiQiang =[[myWeiQiangController alloc]init];
        
        weiQiang.weiQianArr = [NSMutableArray array];
        NSString *userid = [[FDSUserManager sharedManager] NowUserID];
        if ([userid isEqualToString:self.userid]) {
            weiQiang.weiQiangType=WeiQiangTypeMy;
            weiQiang.viewTitle = @"我的微墙";
            
        }else{
            weiQiang.weiQiangType=WeiQiangTypeOther;
            weiQiang.viewTitle = @"TA的微墙";
            
        }
        
        weiQiang.userid = self.userid;
        
        //遍历数组，将元素加进weiQianArr
        [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [weiQiang.weiQianArr addObject:obj];
        }];
        
        //切换控制器
        [self.navigationController pushViewController:weiQiang animated:YES];
    }
}

//请求橱窗信息，橱窗信息里面包含有推荐列表的信息
-(void)request30001CB:(ChuChuangModel*)model
{
    //去掉菊花
    [SVProgressHUD popActivity];
    
    
    myStoreViewController *store = [[myStoreViewController alloc]init];
    
    NSString *userid = [[FDSUserManager sharedManager] NowUserID];
    
    if (![userid isEqualToString:self.userid]) {
        
        store.storeType = StoreTypeOther;
        
    }
    
    //获取模型
    store.model = model;
    
    //获取userid
    store.userid = self.userid;
    
    //切换控制器
    [self.navigationController pushViewController:store animated:YES];
    
}

//发起会话回调
-(void)didSelectedPersonlHeaderButtonWithUsername:(NSString *)username photo:(NSString *)photo isFriend:(BOOL)isFriend nickn:(NSString *)nickn{
    
    [MobClick event:@"namecard_chat_friend_click"];
    
    //只有是好友才能发起会话
    if (!isFriend) {
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"请添加为好友"];
        return;
    }
    
    liaoTianViewController *lv = [[liaoTianViewController alloc] init];
    
    //设置聊天类型
    lv.chatType = ChatTypeSingle;
    
    //取得用户名
    lv.username = username;
    
    //取得真正的用户名
    lv.friendname = nickn;
    
    //取得用户头像
    lv.icon = photo;
    
    [self.navigationController pushViewController:lv animated:YES];
    
}

//关注按钮回调
-(void)didClickFocusButtonWithUserid:(NSString *)userid buttonStaus:(BOOL)selected{
    
    if (!selected) {
        
        [MobClick event:@"namecard_follow_friend_click"];
        
    }
    
    //如果selected为NO发送的是关注消息，YES的就是发送取消关注消息（关注0、取消关注1）
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //记录下操作的userid
    _userid = userid;
    
    //记录下关注按钮的状态
    _buttonStatus = selected;
    
    //发送关注或者取消关注消息
    [[FDSUserCenterMessageManager sharedManager]attentionPerson:userid type:selected];
    
}

//粉丝列表回调（关注／取消关注）
-(void)attentionPersonCB:(int)returnCode {
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if (returnCode==0) {
        
        //发送通知（修改按钮的状态）
        [[NSNotificationCenter defaultCenter]
         postNotificationName:SetupFocusButtonStausKey object:nil];
        
        //取出当前登录用户模型
        BGUser *user = [[FDSUserManager sharedManager] getNowUser];
        
        //取出关注数
        int focusNum = [user.guanzhu intValue];
        
        //根据按钮状态修改关注数(NO增加关注数，YES减少关注数)
        if (_buttonStatus) {
            
            //较少关注数
            user.guanzhu = [NSString stringWithFormat:@"%d",focusNum-1];
            
        }else{
            
            //增加关注数
            user.guanzhu = [NSString stringWithFormat:@"%d",focusNum+1];
            
        }
        
    }
    
    
}

//添加好友回调
-(void)didSelectedPersonlHeaderButtonWithUsername:(NSString *)username{
    
    [MobClick event:@"namecard_add_friend_click"];
    
    //记录下要添加的用户名
    _username = username;
    
    //弹出对话框，捎点啥
    [self alertviewShow];
    
}

//弹出邀请对话框
-(void)alertviewShow{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"说点啥吧" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
}

//alertView代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        
        //得到输入框
        UITextField *inviteField=[alertView textFieldAtIndex:0];
        
        //发送环信添加好友消息前，设定布尔值,在更新列表过滤
        [FDSUserManager sharedManager].isAddAndDeleteByHX=YES;
        
        //发送环信添加好友消息
        EMError *error = nil;
        [[EaseMob sharedInstance].chatManager addBuddy:_username message:inviteField.text error:&error];
        if (!error) {
            
            //提示框
            [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"好友申请已发送"];
            
        }
        
    }
    
}

@end
