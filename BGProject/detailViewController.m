//
//  detailViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "detailViewController.h"
#import "WeiQiangCell.h"
#import "WQComentCell.h"
#import "BGWQCommentCellFrame.h"
#import "FDSUserManager.h"
#import "PersonViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "BGPublishView.h"
#import "BottomBar.h"
#import "UMSocial.h"
#import "MJRefresh.h"
#import "NSString+TL.h"

#define TabBarHeight 49
#define NavigationBarHeight 64
//评论数组
#define kCommentsKey @"comments"

@interface detailViewController ()<WeiQiangCellDelegate,BGPublishViewDelegate,BottomBarDelegate,UMSocialUIDelegate>

@end

@implementation detailViewController

{
    UIView    *topView;
    UIButton  *backBtn;
    UITableView *myTabelView;
    
    //发送框
    __weak BGPublishView *_publishView;
    
    //请求微墙详情评论的开始位置
    NSInteger _commentStartTag;
    
    //被回复的用户ID
    NSString *_writeBackUserid;
    
    //协助下拉键盘的背景图
    __weak UIView *_keyboardBackView;
    
    UIView *_syncView;
    
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;

}

//数组的懒加载
-(NSMutableArray *)commentsArray{
    if (_commentsArray == nil) {
        _commentsArray = [[NSMutableArray alloc] init];
    }
    return _commentsArray;
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
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    label1.text = @"详情";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    [self.view addSubview:topView];
    
    //设置tableview
    [self setupTableView];

}

//设置tableview
-(void)setupTableView{
    
    CGFloat tableViewX = 0;
    CGFloat tableViewY = topView.frame.origin.y+topView.frame.size.height;
    CGFloat tableViewW = self.view.bounds.size.width;
    CGFloat tableViewH = self.view.bounds.size.height - tableViewY-TabBarHeight;
    myTabelView = [[UITableView alloc]initWithFrame:CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH) style:UITableViewStylePlain];
    myTabelView.delegate = self;
    myTabelView.dataSource = self;
    myTabelView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    myTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:myTabelView];
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



#pragma mark btnClick===================

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    //取得AppDelegate对象
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    //隐藏tabblebar
    [app hiddenTabelBar];
    
    //将控制器注册，方便回调
    [[MoudleMessageManager sharedManager]registerObserver:self];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    //将活动指示器去掉
    [SVProgressHUD popActivity];
    
    //去掉注册
    [[MoudleMessageManager sharedManager]unRegisterObserver:self];
    
    [super viewWillDisappear:animated];
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self CreatTopView];
    
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    
    _commentStartTag = self.commentsArray.count;
    
    //监听键盘
    [self observeKeyboard];
    
    //设置发送框
    [self setupPublishView];
    
    //设置底部选项卡
    [self setupBottmBar];
    
    //设置上下拉刷新
    [self setupMoreData];
    
}

//添加底部视图
-(void)setupBottmBar{
    
    BottomBar *bottmBar = [[BottomBar alloc]init];
    bottmBar.delegate = self;
    
    [bottmBar addButtonWithIcon:@"赞.png" title:@"赞"];
    [bottmBar addButtonWithIcon:@"评论.png" title:@"评论"];
    [bottmBar addButtonWithIcon:@"分享.png" title:@"分享"];
    
    CGFloat bottmBarX = 0;
    CGFloat bottmBarY = self.view.frame.size.height-TabBarHeight;
    CGFloat bottmBarW = self.view.frame.size.width;
    CGFloat bottmBarH = TabBarHeight;
    
    CGRect bottmBarF = CGRectMake(bottmBarX, bottmBarY, bottmBarW, bottmBarH);
    [bottmBar setFrame:bottmBarF];
    
    [self.view addSubview:bottmBar];
}


//监听键盘弹出
-(void)observeKeyboard{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


//键盘通知回调函数
-(void)keyboardWillShow:(NSNotification *)noti{
    
    //重新出现的时候要将旧的_keyboardBackView移除掉，高度不对
    [_keyboardBackView removeFromSuperview];
    
    //取出键盘高度
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    //添加一个遮盖真个屏幕的view,事件就可以接受了，神马原因？
    UIView *keyboardBackView = [[UIView alloc] init];
    CGRect bounds = self.view.bounds;
    bounds.size.height = bounds.size.height-TabBarHeight-size.height;
    keyboardBackView.frame = bounds;
    UITapGestureRecognizer *resignKeyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboardTap)];
    [keyboardBackView addGestureRecognizer:resignKeyboardTap];
    [self.view addSubview:keyboardBackView];
    _keyboardBackView = keyboardBackView;
    
    //防止相互强引用
    __unsafe_unretained detailViewController *detail = self;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        //修改_publishView的y值
        CGRect publishF = detail->_publishView.frame;
        publishF.origin.y = self.view.frame.size.height-TabBarHeight-size.height;
        detail->_publishView.frame = publishF;
        
        //修改tableView的高度
        CGRect tableViewF = detail->myTabelView.frame;
        tableViewF.size.height = self.view.frame.size.height-TabBarHeight-size.height-NavigationBarHeight;
        detail->myTabelView.frame = tableViewF;
        
    }];
    
}
-(void)keyboardWillHide:(NSNotification *)noti{
    
    //将从父视图遮罩移除
    [_keyboardBackView removeFromSuperview];
    
    
    
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    __unsafe_unretained detailViewController *detail = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        //修改_publishView的y值
        CGRect publishF = detail->_publishView.frame;
        publishF.origin.y = publishF.origin.y+size.height;
        detail->_publishView.frame = publishF;
        
        //修改tableView的高度
        CGRect tableViewF = detail->myTabelView.frame;
        tableViewF.size.height = self.view.frame.size.height-TabBarHeight-NavigationBarHeight;
        detail->myTabelView.frame = tableViewF;
    } completion:^(BOOL finished) {
        //将发送框移除
        [detail->_publishView removeFromSuperview];
    }];
}

#pragma mark tableviewDatasource=====

//个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.commentsArray.count;
    }
    return 1;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

//高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //评论高度
    if (indexPath.section == 1) {
        BGWQCommentModel *model = self.commentsArray[indexPath.row];
        BGWQCommentCellFrame* commentFrame = [[BGWQCommentCellFrame alloc] initWithModel:model];
        return commentFrame.cellHight;
    }
    
    
    //微博详情高度
    WeiQiangCellFrame* cellFrame = [[WeiQiangCellFrame alloc]initWithModel:self.model cellType:CellTypeWeiQiang];
    return  cellFrame.cellHight;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //微博内容
    if (indexPath.section == 0) {
        static NSString* cellReuseForAll = @"WeiQiangViewController_cellForAll";
        WeiQiangCell* cell = [tableView dequeueReusableCellWithIdentifier:cellReuseForAll];
        if(cell == nil)
        {
            cell = [[WeiQiangCell alloc]initWithStyle:0 reuseIdentifier:cellReuseForAll];
            
            //cell.delegate = self;
            cell.needHideDeleteButton = YES;// 不显示删除按钮
            
        }
        
        //计算出所有控件的frame
        WeiQiangCellFrame* cellFrame = [[WeiQiangCellFrame alloc]initWithModel:self.model cellType:CellTypeWeiQiang];
        cell.cellFrame = cellFrame;
        
        return cell;
    }
    
    //微博评论
    WQComentCell *commentCell = [WQComentCell cellWithTableView:tableView];
    
    //如果是第一个就将之前点击的时候记录下来的userid绑定到第一个cell里面，以后点击用户名就可以拿到响应的userid了
    if (indexPath.row == 0) {
        commentCell.writeBackUserid = _writeBackUserid;
        _writeBackUserid = nil;
    }
    
    BGWQCommentModel *model = self.commentsArray[indexPath.row];
    BGWQCommentCellFrame* commentFrame = [[BGWQCommentCellFrame alloc] initWithModel:model];
    commentCell.commentFrame = commentFrame;
    
    return commentCell;
    
}

//deselected the cell
-(void)tableViewDeSelect:(UITableView*)table
{
    NSIndexPath* indexPath = [table indexPathForSelectedRow];
    [table deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点中效果
    [self tableViewDeSelect:tableView];
    
    
}

//刷新数据
-(void)setupMoreData{
    
    // 防止block循环retain，所以用__unsafe_unretained
    __unsafe_unretained detailViewController *vc = self;
    
    //集成下拉刷新控件
    _header = [MJRefreshHeaderView header];
    _header.scrollView = myTabelView;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        
        //修改请求标记
        vc->_commentStartTag = 0;
        
        //修改请求类型(下拉刷新跟评论都是请求最前的一条数据，一样的)
        vc->_requestWQDetailType=RequestWQDetailTypeComment;
        
        //发送微博详情消息（从新开始请求数据）
        [[MoudleMessageManager sharedManager] requestContentDetailsAtWeiQiang:[self.model.weiboid integerValue] :_commentStartTag :_commentStartTag+kRequestCount];
        
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadDeals) withObject:nil afterDelay:3];
    };
    
    // 集成上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = myTabelView;
    
    // 进入上拉加载状态就会调用这个方法
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        NSString *commentStartTagStr = [NSString stringWithFormat:@"%d",vc->_commentStartTag];
        
        if ([commentStartTagStr hasSuffix:@"0"]) {
            
            //修改请求类型
            vc->_requestWQDetailType=RequestWQDetailTypeRefresh;
            
            //发送请求详情消息（里面有评论列表）
            [[MoudleMessageManager sharedManager] requestContentDetailsAtWeiQiang:[self.model.weiboid integerValue] :_commentStartTag :_commentStartTag+kRequestCount];
            
        }else{
            
            //提示没有更多数据
            [vc performSelector:@selector(showNoDataInfo) withObject:nil afterDelay:0];
            
        }
        
        // 3秒后刷新表格
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
    [myTabelView reloadData];
    // 结束刷新状态
    [_footer endRefreshing];
    [_header endRefreshing];
}

//把键盘放下去
-(void)resignKeyboardTap{
    [_publishView endEditing:YES];
}

//发表按钮回调
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
    
    //评论成功
    if (result == 0) {
        
        //取出cell,取出model,改变forward_count
        weiQiangModel* model = self.model;
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
        [myTabelView reloadData];
        
        //发送微博详情消息
        [[MoudleMessageManager sharedManager] requestContentDetailsAtWeiQiang:[self.model.weiboid integerValue] :_commentStartTag :_commentStartTag+kRequestCount];
        
        
        //去掉菊花
        [SVProgressHUD popActivity];
        
        [_publishView endEditing:YES];
        
        _publishView.commentField.text = @"";
    }
    
}

//微博详情回调
-(void)contentDetailsCB:(NSDictionary *)result{
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if (self.requestWQDetailType==RequestWQDetailTypeRefresh) {
        
        //如果字典存在
        if (result) {
            
            //取出评论数组
            NSArray *comments = result[kCommentsKey];
            
            //将字典转换成模型
            for (NSDictionary *dic in comments) {
                
                //字典转换成模型
                BGWQCommentModel *model = [BGWQCommentModel commentWithDic:dic];
                
                //添加到评论模型数组中去
                [self.commentsArray addObject:model];
                
            }
            
            //修改请求标记
            _commentStartTag = _commentStartTag+comments.count;
            
            [myTabelView reloadData];
            
        }
        
        return;
        
    }
    
    //如果成功
    if (result) {
        
        //取出对应的评论字典数组并且转换成模型数组
        NSArray *comments = result[kCommentsKey];
        
        //先将之前的数据清空，再重新加
        [self.commentsArray removeAllObjects];
        
        for (int i = 0; i < comments.count; i++) {
            
            NSDictionary *dic = comments[i];
            
            //字典转成模型
            BGWQCommentModel *model = [BGWQCommentModel commentWithDic:dic];
            [self.commentsArray addObject:model];
            
            
        }
        
        //修改请求标记,重新开始请求的话下次就是10开始了
        _commentStartTag = self.commentsArray.count;
        
        //没有评论的时候，还没创建cell就滚动会崩掉
        if (self.commentsArray.count > 1) {
            //最后一行(之前删掉的元素的cell还存在，只需要新增加一行就行了)
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            
            //滚动到最后一行
            [myTabelView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
        //刷新页面
        [myTabelView reloadData];
        
    }
    
}

//bottomBar代理
-(void)bottomBar:(BottomBar *)bar didClickButtonAtIndex:(NSInteger)index{
    
    //判断是否已经登录
    if ([[FDSUserManager sharedManager] getNowUserState]!=USERSTATE_LOGIN) {
        PersonViewController *perVC = [[PersonViewController alloc] init];
        perVC.isAppearBackBtn = YES;
        [self.navigationController pushViewController:perVC animated:YES];
        return;
    }
    
    //评论的时候不用添加这个阻塞的，本来键盘就有一个背景view
    if (index == 0) {
        //加了一个view覆盖再tableview上面
        _syncView = [[UIView alloc]initWithFrame:myTabelView.frame];
        [self.view addSubview:_syncView];//权宜之计。阻止用户乱点。
        
    }
    
    switch (index) {
        case 0:
        {
            //赞
            //取出模型
            weiQiangModel *model = self.model;
            
            //拿出weiboid
            int weiboid = [model.weiboid integerValue];
            
            //发送消息
            [[MoudleMessageManager sharedManager]submitSupportAtWeiQiang:weiboid];
        }
            
            break;
        case 1:
        {
            //创建发送框
            [self setupPublishView];
            
            //通过这个tempView成为第一响应者将键盘弹出
            [_publishView.commentField becomeFirstResponder];
            
            //拿出weiboid
            _publishView.weiboid = [self.model.weiboid integerValue];
            
            //设置评论的类型
            _publishView.commentType=commentTypeComment;
            
            //设置占位文字
            _publishView.commentField.placeholder = PlaceholderComment;
            
        }
            break;
        case 2:
            //分享60006
            
        {
            
            //取出cell，取出model，取出like_count＋1.再刷新页面
            //如果有图片就分享第一张
            if (self.model.imgs.count!=0) {
                
                NSDictionary *urlDic = self.model.imgs[0];
                
                NSString *img = urlDic[@"img"];
                
                //处于分享状态，不能删除代理
                [self shareWeiQiang:self.model.content imageUrl:[NSString setupSileServerAddressWithUrl:img]];
    
                
            }else{
                
                
                //处于分享状态，不能删除代理
                [self shareWeiQiang:self.model.content imageUrl:nil];
            }
            
        }
            
            break;
            
        default:
            break;
    }
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
        weiQiangModel* model = self.model;
        
        //取出weiboid
        int weiboid = [model.weiboid integerValue];
        
        //发送消息60006
        [[MoudleMessageManager sharedManager] shareWeiBoAtWeiQiang:weiboid];
    }
}

//点赞回调
-(void)submitSupportAtWeiQiangCB:(int)result{
    
    //数据回来后，将_syncView删掉
    [_syncView removeFromSuperview];
    
    if (result==205) {
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"你已点赞"];
        return;
        
    }
    
    //取出cell，取出model，取出like_count＋1.再刷新页面
    weiQiangModel* model = self.model;
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
    [myTabelView reloadData];
    
}

//转发回调
-(void)relayWeiBoAtWeiQiangCB:(int)result{
    //去掉菊花
    [SVProgressHUD popActivity];
    
    weiQiangModel* model = self.model;
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
    [myTabelView reloadData];
}

//分享回调
-(void)shareWeiBoCB:(int)result{
    
    //取出cell,取出model,改变forward_count
    weiQiangModel* model = self.model;
    int tmpInt = [model.share_count intValue];
    tmpInt += 1;
    
    if (tmpInt>=10000) {
        //大于一万的全都表示x万
        tmpInt = tmpInt/10000;
        model.share_count = [NSString stringWithFormat:@"%d万", tmpInt];
    }else{
        model.share_count = [NSString stringWithFormat:@"%d", tmpInt];
        
    }
    
    //刷新页面
    [myTabelView reloadData];
}

@end
