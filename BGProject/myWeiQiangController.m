//
//  myWeiQiangController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "myWeiQiangController.h"
#import "PullingRefreshTableView.h"

#import "weiQiangModel.h"
#import "WeiQiangCell.h"

#import "AppDelegate.h"
#import "MoudleMessageInterface.h"
#import "MoudleMessageManager.h"
#import "SVProgressHUD.h"
#import "FDSPublicManage.h"
#import "detailViewController.h"
#import "BGWQCommentModel.h"
#import "MJRefresh.h"
#import "UMSocial.h"
#import "BGPublishView.h"
#import "FDSUserManager.h"
#import "FDSUserManager.h"
#import "PersonViewController.h"
#import "NSString+TL.h"

//图片数组
#define kImgsKey @"imgs"
//评论数组
#define kCommentsKey @"comments"

#define TabBarHeight 49
#define NavigationBarHeight 64

@interface myWeiQiangController ()<WeiQiangCellDelegate, MoudleMessageInterface,PullingRefreshTableViewDelegate,BGPublishViewDelegate>



// 删除单元格
-(void)WeiQiangCellDelete:(WeiQiangCell *)cell;

// 删除服务器上的一条微博
-(void)deleteWeiBoAtWeiQiangCB:(int)result;


//// 删除单元格
//-(void)WeiQiangCellDelete:(WeiQiangCell *)cell;
//
//// 删除服务器上的一条微博
//-(void)deleteWeiBoAtWeiQiangCB:(int)result;

@end

@implementation myWeiQiangController

{
    UIView    *topView;
    UIButton  *backBtn;
    UITableView *myTableView;
    
    NSMutableArray* cellHeightArr;

    NSIndexPath* deleteIndexPath;
    NSIndexPath *_selectedIndexpath;
    NSIndexPath *_selectedDetailIndexpath;
    
    // 每次请求微博的个数
    int _requstWeiCount;
    BOOL _isRequestLast;// 是否请求最新数据。如果是下拉加载则是 YES
    
    NSInteger _commentStartTag;//请求微墙详情评论的开始位置
    NSInteger _mineStartTag;// 请求所有数据的开始位置
    NSInteger _requestType;
    
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    UIView *_syncView;// 阻塞用户操作。
    BGPublishView *_publishView;
    UIView *_keyboardBackView;
    NSString *_tempUserid;

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
    
    
    
    //取出AppDelegate对象
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    //将tabbar隐藏起来
    [app hiddenTabelBar];
    
    //注册代理
    [[MoudleMessageManager sharedManager]registerObserver:self];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    
    
    //关掉活动指示器
    [SVProgressHUD popActivity];
    
    //移除代理
    [[MoudleMessageManager sharedManager]unRegisterObserver:self];
    
}

//设置评论框
-(void)setupPublishView{
    
    BGPublishView *publishView = [[BGPublishView alloc] init];
    publishView.delegate = self;
    CGFloat publishViewX = 0;
    CGFloat publishViewY = self.view.frame.size.height-TabBarHeight;
    CGFloat publishViewW = self.view.frame.size.width;
    CGFloat publishViewH = TabBarHeight;
    publishView.frame = CGRectMake(publishViewX,publishViewY ,publishViewW , publishViewH);
    [self.view addSubview:publishView];
    _publishView = publishView;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //我的微博数组里面的微博个数作为开始
    _mineStartTag = [_weiQianArr count];
    
    //每次多少条微博
    _requstWeiCount = 10;
    
    //取出自身的userid
    _tempUserid = [[FDSUserManager sharedManager] NowUserID];
    
    //添加导航栏／返回按钮／标签／tableview
    [self CreatView];
    
    //刷新数据
    [self setupMoreData];
    
    //监听键盘
    [self observeKeyboard];
    
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
    bounds.size.height = bounds.size.height-TabBarHeight-size.height;
    keyboardBackView.frame = bounds;
    UITapGestureRecognizer *resignKeyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboardTap)];
    [keyboardBackView addGestureRecognizer:resignKeyboardTap];
    [self.view addSubview:keyboardBackView];
    _keyboardBackView = keyboardBackView;
}

-(void)keyboardWillShow:(NSNotification *)noti{
    
    //重新出现的时候要将旧的_keyboardBackView移除掉，高度不对
    [_keyboardBackView removeFromSuperview];
    
    //取出键盘高度
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    //添加一个遮盖真个屏幕的view,事件就可以接受了，神马原因？
    [self setupkeyboardBackViewWithSize:size];
    
    //防止相互强引用
    __unsafe_unretained myWeiQiangController *MWQVc = self;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        //修改_publishView的y值
        CGRect publishF = MWQVc->_publishView.frame;
        publishF.origin.y = self.view.frame.size.height-TabBarHeight-size.height;
        MWQVc->_publishView.frame = publishF;
        
        //修改tableView的高度
        CGRect tableViewF = MWQVc->myTableView.frame;
        tableViewF.size.height = self.view.frame.size.height-TabBarHeight-size.height-tableViewF.origin.y;
        MWQVc->myTableView.frame = tableViewF;
        
    }];
}

-(void)keyboardWillHide:(NSNotification *)noti{
    
    //将从父视图遮罩移除
    [_keyboardBackView removeFromSuperview];
    
    
    __unsafe_unretained myWeiQiangController *MWQVc = self;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        //修改_publishView的y值
        CGRect publishF = MWQVc->_publishView.frame;
        publishF.origin.y = self.view.frame.size.height-TabBarHeight;
        MWQVc->_publishView.frame = publishF;
        
        //修改tableView的高度
        CGRect tableViewF = MWQVc->myTableView.frame;
        tableViewF.size.height = self.view.frame.size.height-TabBarHeight;
        MWQVc->myTableView.frame = tableViewF;
    } completion:^(BOOL finished) {
        //键盘下来的时候将输入框删掉
        [MWQVc->_publishView removeFromSuperview];
    }];
}

//把键盘放下去
-(void)resignKeyboardTap{
    [_publishView endEditing:YES];
}

//刷新数据
-(void)setupMoreData{
    
    // 防止block循环retain，所以用__unsafe_unretained
    __unsafe_unretained myWeiQiangController *vc = self;
    
    //集成下拉刷新控件
    _header = [MJRefreshHeaderView header];
    _header.scrollView = myTableView;
    
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        
        //发送消息
        vc->_mineStartTag = 0;
        
        int userid = [vc->_userid intValue];
        
        //发送获取我的或者他的微墙的消息
        [[MoudleMessageManager sharedManager] WeiQiangList:vc->_requestType start:vc->_mineStartTag end:vc->_mineStartTag+kRequestCount userid:userid];
        
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadDeals) withObject:nil afterDelay:3];
        
    };
    
    // 集成上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = myTableView;
    
    // 进入上拉加载状态就会调用这个方法
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        NSString *mineStartTagStr = [NSString stringWithFormat:@"%d",vc->_mineStartTag];
        
        if ([mineStartTagStr hasSuffix:@"0"]) {
            
            int userid = [vc->_userid intValue];
            
            //发送微墙列表的消息
            [[MoudleMessageManager sharedManager] WeiQiangList:vc->_requestType start:vc->_mineStartTag end:vc->_mineStartTag+kRequestCount userid:userid];
            
            
        }else{
            
            //提示没有更多数据
            [vc performSelector:@selector(showNoDataInfo) withObject:nil afterDelay:0];
            
        }
        
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadDeals) withObject:nil afterDelay:3];
        
    };
    
}

-(void)showNoDataInfo{
    
    [self reloadDeals];
    
    //提示框
    [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"已经没有更多的评论了"];
    
}

//刷新表格
- (void)reloadDeals
{
    [myTableView reloadData];
    // 结束刷新状态
    [_footer endRefreshing];
    [_header endRefreshing];
}

-(void)CreatView
{
    //添加自定义导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    //添加返回按钮
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    
    //导航栏标签
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    if (self.viewTitle) {
        
        label1.text = self.viewTitle;
        
    }else{
        
        label1.text = @"我的微墙";
        
    }
    
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    [self.view addSubview:topView];
    
    //取出屏幕高度
    CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height;
    //创建表格
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, viewHeight-64)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
}

#pragma mark btnClick===================

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark tabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //返回数组的个数
    return _weiQianArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellOne";
    WeiQiangCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WeiQiangCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //设置代理，方便以后回调删除函数
        cell.delegate = self;
        
        //如果是其他人的微墙，不能删除，不显示删除按钮
        if (self.weiQiangType==WeiQiangTypeOther) {
            
            cell.needHideDeleteButton = YES;
            
        }
        
    }
    
    NSString *userid = [[FDSUserManager sharedManager] NowUserID];
    if ([userid isEqualToString:self.userid] || self.weiQiangType==WeiQiangTypeMy) {
        
        cell.needHideDeleteButton=NO;
        
    }else{
        
        cell.needHideDeleteButton=YES;
        
    }
    
    WeiQiangCellFrame* cellFrame = [[WeiQiangCellFrame alloc]init];
    
    //在setModel里面将全部的子控件算完
    cellFrame.model =  _weiQianArr[indexPath.row];
    
    //在setFrame中将全部的控件的坐标调整
    cell.cellFrame = cellFrame;
    
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    WeiQiangCellFrame* cellFrame = [[WeiQiangCellFrame alloc]init];
    cellFrame.model =  _weiQianArr[indexPath.row];
    
    NSLog(@"##%ld###%f###",indexPath.row,cellFrame.cellHight);
    
    //在赋值过程中已经算好cell的高度
    return cellFrame.cellHight;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击效果
    [self tableViewDeSelect:tableView];
    
    //取出模型
    weiQiangModel * model = _weiQianArr[indexPath.row];
    _selectedDetailIndexpath = indexPath;
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //发送微博详情消息
    [[MoudleMessageManager sharedManager] requestContentDetailsAtWeiQiang:[model.weiboid integerValue] :_commentStartTag :_commentStartTag+kRequestCount];
    
}

//取消选中效果
-(void)tableViewDeSelect:(UITableView*)table
{
    NSIndexPath* indexPath = [table indexPathForSelectedRow];
    [table deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

//微博详情数据回调
-(void)contentDetailsCB:(NSDictionary *)result{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //跳到下个页面
    if (result) {
        
        detailViewController *detail = [[detailViewController alloc]init];
        
        //取出对应的model
        weiQiangModel *model = _weiQianArr[_selectedDetailIndexpath.row];
        //取出图片数组
        NSArray *imgs = result[kImgsKey];
        
        //赋值
        model.imgs = imgs;
        detail.model = model;
        
        //取出对应的评论字典数组并且转换成模型数组
        NSArray *comments = result[kCommentsKey];
        for (NSDictionary *dic in comments) {
            BGWQCommentModel *model = [BGWQCommentModel commentWithDic:dic];
            [detail.commentsArray addObject:model];
            
        }
        
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}

// tableView 删除单元格 2014年10月11日 抄袭目标，不想动脑了
-(void)WeiQiangCellDelete:(WeiQiangCell *)cell
{
    //请求删除服务器删除  60004
    // 首先计算出要删除单元格的位置 ，保存到 deleteIndexPath,后面的cb用到该位置
    
    //将cell对应的model拿出来
    weiQiangModel* model = cell.cellFrame.model;
    
    //找出在数组中的标记
    NSInteger index = [_weiQianArr indexOfObject:model];
    
    //取出对应位置的indexpath
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
    
    //用deleteIndexPath保存起来
    deleteIndexPath = indexpath;
    
    //取出对应的weiboid
    int weiboid = [model.weiboid intValue];
    
    //显示活动指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //发送消息，删除对应的微博
    [[MoudleMessageManager sharedManager]deleteWeiBoAtWeiQiang:weiboid];
}

// 删除服务器上的一条微博，消息回调
-(void)deleteWeiBoAtWeiQiangCB:(int)result
{
    //关掉活动指示器
    [SVProgressHUD popActivity];
    
    //如果result表示服务器删除成功
    if (result == 0) {
    
    //删除数组中的对应的数据模型
    [_weiQianArr removeObjectAtIndex:deleteIndexPath.row];
    
        //不知为啥iOS8删除的时候高度不对，如果是8的话全部刷新
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [myTableView reloadData];
        }
        else {
            //删除tableview上面对应deleteIndexPath的cell
            [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:deleteIndexPath]
                               withRowAnimation:UITableViewRowAnimationFade];
        }
    
        
    } else {
        
        //弹出对话框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"服务器繁忙,删除失败"];
    }
}

//下面的工具条的回调
-(void)WeiQiangCell:(WeiQiangCell *)cell didSelectedButtonIndex:(NSInteger)index{
    
    //判断是否已经登录
    if ([[FDSUserManager sharedManager] getNowUserState]!=USERSTATE_LOGIN) {
        PersonViewController *perVC = [[PersonViewController alloc] init];
        perVC.isAppearBackBtn = YES;
        [self.navigationController pushViewController:perVC animated:YES];
        return;
    }
    
    NSLog(@"%d",index);
    
    //评论的时候不用添加这个阻塞的，本来键盘就有一个背景view
    if (index == 0) {
        //加了一个view覆盖再tableview上面
        _syncView = [[UIView alloc]initWithFrame:myTableView.frame];
        [self.view addSubview:_syncView];//权宜之计。阻止用户乱点。
        
        //爆菊花
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    }
    
    //记录下cell的indexPath
    _selectedIndexpath = [myTableView indexPathForCell:cell];

    
    switch (index) {
        case 0:
            //赞 60008
        {
            //拿出模型
            weiQiangModel* model = cell.cellFrame.model;
            
            //拿出weiboid
            int weiboid = [model.weiboid integerValue];
            
            //发送消息
            [[MoudleMessageManager sharedManager]submitSupportAtWeiQiang:weiboid];
        }
            
            break;
        case 1:
        {//评论
            
            //创建_publishView
            [self setupPublishView];
            
            //通过这个commentField成为第一响应者将键盘弹出
            [_publishView.commentField becomeFirstResponder];
            
            //微博评论
            _publishView.commentType = commentTypeComment;
            
            //拿出模型
            weiQiangModel* model = cell.cellFrame.model;
            
            //取得被评论的weiboid
            _publishView.weiboid = [model.weiboid intValue];
            
            //设置占位文字
            _publishView.commentField.placeholder = PlaceholderComment;
            
            [myTableView scrollToRowAtIndexPath:_selectedIndexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            break;
            
        }
        case 2:
            //转发60005
        {
            
            //创建_publishView
            [self setupPublishView];
            
            //通过这个commentField成为第一响应者将键盘弹出
            [_publishView.commentField becomeFirstResponder];
            
            //取出模型
            weiQiangModel *model = cell.cellFrame.model;
            
            //取得被评论的weiboid
            _publishView.weiboid = [model.weiboid intValue];
            
            //设置占位文字
            _publishView.commentField.placeholder = PlaceholderFrom;
            
            [myTableView scrollToRowAtIndexPath:_selectedIndexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            break;
            
        }
        case 3:
            //分享60006
        {
            //取出cell，取出model，取出like_count＋1.再刷新页面
            WeiQiangCell* cell =(WeiQiangCell*) [myTableView cellForRowAtIndexPath:_selectedIndexpath];
            weiQiangModel* model = cell.cellFrame.model;
            
            //如果有图片就分享第一张
            if (model.imgs.count!=0) {
                
                NSDictionary *urlDic = model.imgs[0];
                
                NSString *img = urlDic[@"img"];
                
                //处于分享状态，不能删除代理
                [self shareWeiQiang:model.content imageUrl:[NSString setupSileServerAddressWithUrl:img]];
                
                
            }else{
                
                
                //处于分享状态，不能删除代理
                [self shareWeiQiang:model.content imageUrl:nil];
            }
        }
            break;
            
        default:
            break;
    }
    
}

//点赞回调
-(void)submitSupportAtWeiQiangCB:(int)result{
    NSLog(@"result:%d",result);
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //数据回来后，将_syncView删掉
    [_syncView removeFromSuperview];
    
    //取出cell，取出model，取出like_count＋1.再刷新页面
    WeiQiangCell* cell =(WeiQiangCell*) [myTableView cellForRowAtIndexPath:_selectedIndexpath];
    weiQiangModel* model = cell.cellFrame.model;
    int tmpInt = [model.like_count intValue];
    tmpInt += 1;
    
    if (tmpInt>=10000) {
        //大于一万的全都表示x万
        tmpInt = tmpInt/10000;
        model.like_count = [NSString stringWithFormat:@"%d万", tmpInt];
    }else{
        model.like_count = [NSString stringWithFormat:@"%d", tmpInt];
        
    }
    
    //刷新页面
    [myTableView reloadData];
}

//转发回调
-(void)relayWeiBoAtWeiQiangCB:(int)result{
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //数据回来后，将_syncView删掉
    [_syncView removeFromSuperview];
    
    //取出cell,取出model,改变forward_count
    WeiQiangCell* cell =(WeiQiangCell*) [myTableView cellForRowAtIndexPath:_selectedIndexpath];
    
    weiQiangModel* model = cell.cellFrame.model;
    int tmpInt = [model.forward_count intValue];
    tmpInt += 1;
    
    if (tmpInt>=10000) {
        //大于一万的全都表示x万
        tmpInt = tmpInt/10000;
        model.forward_count = [NSString stringWithFormat:@"%d万", tmpInt];
    }else{
        model.forward_count = [NSString stringWithFormat:@"%d", tmpInt];
        
    }
    
    //刷新页面
    [myTableView reloadData];
}

//弹出分享框
-(void)shareWeiQiang:(NSString *)content imageUrl:(NSString *)url{
    
    UIImage *shareImage = nil;
    
    if (url==nil) {
        
        shareImage = [UIImage imageNamed:@"logo.png"];
        
    }else{
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        
        //这里暂时同步下载，影响用户体验
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        shareImage = [UIImage imageWithData:imageData];
        
    }
    
    [SVProgressHUD popActivity];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"54f6d2a1fd98c5d705000132"
                                      shareText:content
                                     shareImage:shareImage
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
        
        //取出cell，取出model，取出like_count＋1.再刷新页面
        WeiQiangCell* cell =(WeiQiangCell*) [myTableView cellForRowAtIndexPath:_selectedIndexpath];
        weiQiangModel* model = cell.cellFrame.model;
        
        //取出weiboid
        int weiboid = [model.weiboid integerValue];
        
        //发送消息60006
        [[MoudleMessageManager sharedManager] shareWeiBoAtWeiQiang:weiboid];
    }
}

//点击发送按钮的回调
-(void)didSelectedPublishButton:(NSString *)text{
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    //发送评论
    if (_publishView.commentType==commentTypeComment) {
        
        //评论微博
        [[MoudleMessageManager sharedManager] submitCommentAtWeiQiang:_publishView.weiboid :text ];
        
    }else{
        //发送转发消息
        [[MoudleMessageManager sharedManager] relayWeiBoAtWeiQiang:_publishView.weiboid comments:text];
        
    }
    
    [_publishView endEditing:YES];
    
}

//微博评论回调
-(void)submitCommentAtWeiQiangCB:(int)result{
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if (result == 0) {
        //取出cell,取出model,改变forward_count
        WeiQiangCell* cell =(WeiQiangCell*) [myTableView cellForRowAtIndexPath:_selectedIndexpath];
        
        weiQiangModel* model = cell.cellFrame.model;
        int tmpInt = [model.comment_count intValue];
        tmpInt += 1;
        
        if (tmpInt>=10000) {
            //大于一万的全都表示x万
            tmpInt = tmpInt/10000;
            model.comment_count = [NSString stringWithFormat:@"%d万", tmpInt];
        }else{
            model.comment_count = [NSString stringWithFormat:@"%d", tmpInt];
            
        }
        
        //刷新页面
        [myTableView reloadData];
    }else{
        [UIAlertView showMessage:@"评论失败"];
    }
    
}

//type/>//0，我的；1：关注；2：非关注
//微博列表回调
-(void)weiQiangListCB:(NSArray *)models {
    
    //将活动指示器关掉
    [SVProgressHUD popActivity];
    
    if(_requestType == 0) {
        
        //初始化数组
        if(_weiQianArr == nil) {
            
            _weiQianArr = [NSMutableArray arrayWithArray:models];
            
        }
        
        if (models.count) {
            
            //如果_mineStartTag＝＝0，说明是下拉刷新或者是刚开始
            if (_mineStartTag == 0) {
                
                //确定有数据后才将全部的元素删掉
                [_weiQianArr removeAllObjects];
                
            }
            
            //将全部返回的模型加进去
            [_weiQianArr addObjectsFromArray:models];
            
            //确定有新数据后才修改发送请求的标识
            _mineStartTag += models.count;
            
            
        }
        
        
    }
    
}

@end
