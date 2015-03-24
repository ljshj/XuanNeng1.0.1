//
//  ContentDetailViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-10-15.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//


#import "AppDelegate.h"

#import "ContentDetailViewController.h"
#import "MoudleMessageManager.h"
#import "SVProgressHUD.h"
#import "XuanNengPaiHangBangCell.h"
#import "BGWQCommentModel.h"
#import "BGWQCommentCellFrame.h"
#import "WQComentCell.h"
#import "BottomBar.h"
#import "BGPublishView.h"
#import "UMSocial.h"
#import "MJRefresh.h"
#import "FDSUserManager.h"
#import "PersonViewController.h"
#import "UIImageView+WebCache.h"
#import "NSString+TL.h"

#define TabBarHeight 49
#define NavigationBarHeight 64
#define kTopViewHeight 64
#define kCommentsKey @"comments"

@interface ContentDetailViewController ()<UITableViewDataSource,UITableViewDelegate,MoudleMessageInterface,BottomBarDelegate,BGPublishViewDelegate>

@end

@implementation ContentDetailViewController

{
    UILabel* _titleLabel;
    __weak UITableView *_tableView;
    
    //发送框
    __weak BGPublishView *_publishView;
    
    //协助下拉键盘的背景图
    __weak UIView *_keyboardBackView;
    
    //请求微墙详情评论的开始位置
    NSInteger _commentStartTag;
    
    //用来阻塞用户操作
    UIView *_syncView;
    
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    
    //评论请求标记
    int _commentTag;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//数组的懒加载
-(NSMutableArray *)commentsArray{
    if (_commentsArray == nil) {
        _commentsArray = [[NSMutableArray alloc] init];
    }
    return _commentsArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    AppDelegate *app =(AppDelegate*) [UIApplication sharedApplication].delegate;
    [app hiddenTabelBar];
    
    //将控制器注册，方便回调
    [[MoudleMessageManager sharedManager]registerObserver:self];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
    
    //将活动指示器去掉
    [SVProgressHUD popActivity];
    
    //去掉注册
    [[MoudleMessageManager sharedManager]unRegisterObserver:self];
    
}

-(void)CreatView
{
    //导航栏
    UIView* topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    //导航栏标签
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 24, kScreenWidth, 40)];
    //直接赋值不就行了，还弄个空
    label1.text = @"";
    label1.textColor = [UIColor blackColor];
    label1.font =[UIFont systemFontOfSize:16];
    label1.textAlignment = NSTextAlignmentCenter;
    _titleLabel = label1;
    
    //返回按钮
    UIButton* backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    

    [topView addSubview:backBtn];
    [topView addSubview:label1];
    [self.view addSubview:topView];
    
    //搞个最大的y值来方便布局？？
    _viewAtY = CGRectGetMaxY(topView.frame);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化请求标记，已经有数据了
    _commentTag = self.commentsArray.count;
    
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    
    //创建了导航栏
    [self CreatView];
    
    //设置tableview
    [self setupTableView];
    
    //设置工具条
    [self setupBottmBar];
    
    //监听键盘
    [self observeKeyboard];
    
    //集成上下拉刷新
    [self setupMoreData];
}

//刷新数据
-(void)setupMoreData{
    
    // 防止block循环retain，所以用__unsafe_unretained
    __unsafe_unretained ContentDetailViewController *vc = self;
    
    //集成下拉刷新控件
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _tableView;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        
        //修改请求标记
        vc->_commentTag = 0;
        
        //修改请求类型(下拉刷新跟评论都是请求最前的一条数据，一样的)
        vc->_requestJokeDetailType=RequestJokeDetailTypeComment;
        
        //发送微博详情消息（从新开始请求数据）
        [[MoudleMessageManager sharedManager] requestJoke:vc->_model.jokeid :vc->_commentTag :vc->_commentTag+kRequestCount];
        
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadDeals) withObject:nil afterDelay:3];
    };
    
    // 集成上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _tableView;
    
    // 进入上拉加载状态就会调用这个方法
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        NSString *commentTagStr = [NSString stringWithFormat:@"%d",vc->_commentTag];
        
        if ([commentTagStr hasSuffix:@"0"]) {
            
            //修改请求类型
            vc->_requestJokeDetailType=RequestJokeDetailTypeRefresh;
            
            //发送请求详情消息（里面有评论列表）
            [[MoudleMessageManager sharedManager] requestJoke:vc->_model.jokeid :vc->_commentTag :vc->_commentTag+kRequestCount];
            
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
    [_tableView reloadData];
    // 结束刷新状态
    [_footer endRefreshing];
    [_header endRefreshing];
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

//键盘通知回调函数
-(void)keyboardWillShow:(NSNotification *)noti{
   
    //重新出现的时候要将旧的_keyboardBackView移除掉，高度不对
    [_keyboardBackView removeFromSuperview];
    
    //取出键盘高度
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    //添加一个遮盖真个屏幕的view,事件就可以接受了，神马原因？
    [self setupkeyboardBackViewWithSize:size];
    
    //防止相互强引用
    __unsafe_unretained ContentDetailViewController *CDVc = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        //修改_publishView的y值
        CGRect publishF = CDVc->_publishView.frame;
        publishF.origin.y = self.view.frame.size.height-TabBarHeight-size.height;
        CDVc->_publishView.frame = publishF;
        
        //修改tableView的高度
        CGRect tableViewF = CDVc->_tableView.frame;
        tableViewF.size.height = self.view.frame.size.height-TabBarHeight-size.height-NavigationBarHeight;
        CDVc->_tableView.frame = tableViewF;
        
    }];
    
}

-(void)keyboardWillHide:(NSNotification *)noti{
    
    //将从父视图遮罩移除
    [_keyboardBackView removeFromSuperview];
    
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    __unsafe_unretained ContentDetailViewController *CDVc = self;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        //修改_publishView的y值
        CGRect publishF = CDVc->_publishView.frame;
        publishF.origin.y = publishF.origin.y+size.height;
        CDVc->_publishView.frame = publishF;
        
        //修改tableView的高度
        CGRect tableViewF = CDVc->_tableView.frame;
        tableViewF.size.height = self.view.frame.size.height-TabBarHeight-tableViewF.origin.y;
        CDVc->_tableView.frame = tableViewF;
    } completion:^(BOOL finished) {
        //键盘下来的时候将输入框删掉
        [CDVc->_publishView removeFromSuperview];
    }];
}

//把键盘放下去
-(void)resignKeyboardTap{
    [_publishView endEditing:YES];
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

//设置tableview
-(void)setupTableView{
    
    
    CGFloat tableViewX = 0;
    CGFloat tableViewY = _viewAtY;
    CGFloat tableViewW = self.view.bounds.size.width;
    CGFloat tableViewH = self.view.bounds.size.height - tableViewY-TabBarHeight;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:tableView];
    _tableView = tableView;
}

-(void)btnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//设置标签名字
-(void)resetTitle:(NSString*)title;
{
    [_titleLabel setText:title];

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

//组数
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
    
    //笑话详情高度
    XuanNengPaiHangBangCellFrame* cf =[[XuanNengPaiHangBangCellFrame alloc] init];
    cf.model = self.model;
    return cf.cellHight;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //微博内容
        static NSString* cellReuseForAll = @"XuanNengPaiHangBangCell";
        XuanNengPaiHangBangCell* cell = [tableView dequeueReusableCellWithIdentifier:cellReuseForAll];
        if(cell == nil)
        {
            cell = [[XuanNengPaiHangBangCell alloc]initWithStyle:0 reuseIdentifier:cellReuseForAll];
            cell.needHideDeleteButton = YES;
            
            //以后要搞这个属性
            //        cell.delegate = self;
            //        cell.needHideDeleteButton = YES;// 不显示删除按钮
            
        }
        
        
        XuanNengPaiHangBangCellFrame* cellFrame = [[XuanNengPaiHangBangCellFrame alloc] init];
        
        //计算出所有控件的frame
        cellFrame.model = self.model;
        
        //给所有子控件设置内容和位置
        cell.cellFrame = cellFrame;
        
        return cell;
    }
    
    //笑话评论，都一样的，拿微墙的模型过来用一下
    WQComentCell *commentCell = [WQComentCell cellWithTableView:tableView];
    
    //如果是第一个就将之前点击的时候记录下来的userid绑定到第一个cell里面，以后点击用户名就可以拿到响应的userid了
    
    BGWQCommentModel *model = self.commentsArray[indexPath.row];
    BGWQCommentCellFrame* commentFrame = [[BGWQCommentCellFrame alloc] initWithModel:model];
    commentCell.commentFrame = commentFrame;
    
    return commentCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        return;
    }
    
    //取消点中效果
    [self tableViewDeSelect:tableView];
    
    //添加发送框
    [self setupPublishView];
    
    //通过这个tempView成为第一响应者将键盘弹出
    [_publishView.commentField becomeFirstResponder];
    
    //取出对应的模型
    BGWQCommentModel *model = self.commentsArray[indexPath.row];
    
    //设置占位文字
    NSString *placeholder = [NSString stringWithFormat:@"回复: @%@ ",model.name];
    _publishView.commentField.placeholder = placeholder;
    
}

//deselected the cell
-(void)tableViewDeSelect:(UITableView*)table
{
    NSIndexPath* indexPath = [table indexPathForSelectedRow];
    [table deselectRowAtIndexPath:indexPath animated:YES];
    
    
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
//bottomBar代理
-(void)bottomBar:(BottomBar *)bar didClickButtonAtIndex:(NSInteger)index{
    
    //判断是否已经登录
    if ([[FDSUserManager sharedManager] getNowUserState]!=USERSTATE_LOGIN) {
        PersonViewController *perVC = [[PersonViewController alloc] init];
        perVC.isAppearBackBtn = YES;
        [self.navigationController pushViewController:perVC animated:YES];
        return;
    }
    
    if (index == 0) {
        //加了一个view覆盖再tableview上面
        _syncView = [[UIView alloc]initWithFrame:_tableView.frame];
        [self.view addSubview:_syncView];//权宜之计。阻止用户乱点。
        
    }
    
    switch (index) {
        case 0:
            //赞
            
        {
            //发送消息
            [[MoudleMessageManager sharedManager] submitSupportAtXuanNeng:[self.model.jokeid intValue]];
        }
            
            break;
        case 1:
        {
            //创建发送框
            [self setupPublishView];
            
            //通过这个tempView成为第一响应者将键盘弹出
            [_publishView.commentField becomeFirstResponder];
            
            //拿出weiboid
            _publishView.jokeid = [self.model.jokeid integerValue];
            
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
        
        //取出cell，取出model，取出like_count＋1.再刷新页面
        JokeModel* model = self.model;
        
        //取出jokeid
        int jokeid = [model.jokeid intValue];
        
        //发送消息70005
        [[MoudleMessageManager sharedManager] shareJokeAtXuanNeng:jokeid];
        
    }
}

//发表按钮回调
-(void)didSelectedPublishButton:(NSString *)text{
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //发送评论
    if (_publishView.commentType==commentTypeComment) {
        
        //评论微博
        [[MoudleMessageManager sharedManager] submitCommentAtXuanNeng:_publishView.jokeid :text];
        
    }else{
        //发送转发消息
        [[MoudleMessageManager sharedManager] relayToWeiBoAtXuanNeng:_publishView.jokeid comments:text];
        
    }
    
    [_publishView endEditing:YES];
    
}
//评论回调
-(void)submitCommentAtXuanNengCB:(int)result{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //评论成功
    if (result == 0) {
        
        //取出cell,取出model,改变forward_count
        JokeModel* model = self.model;
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
        [_tableView reloadData];
        
        //修改请求类型
        self.requestJokeDetailType=RequestJokeDetailTypeComment;
        
        //发送微博详情消息（从新开始请求数据）
        [[MoudleMessageManager sharedManager] requestJoke:self.model.jokeid :0 :0+kRequestCount];
        
        _publishView.commentField.text = @"";
    }

}

//笑话详情回调
-(void)requestJokeCB:(NSDictionary *)result{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if (self.requestJokeDetailType==RequestJokeDetailTypeRefresh) {
        
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
            _commentTag = _commentTag+comments.count;
            
            [_tableView reloadData];
            
        }
        
        return;
        
    }
    
    if (result) {
        
        //取出对应的评论字典数组并且转换成模型数组
        NSArray *comments = result[kCommentsKey];
        
        //先将之前的数据清空，再重新加
        [self.commentsArray removeAllObjects];
        
        for (int i = 0; i < comments.count; i++) {
            
            //取出字典
            NSDictionary *dic = comments[i];
            
            //字典转成模型
            BGWQCommentModel *model = [BGWQCommentModel commentWithDic:dic];
            
            //添加到数组中去
            [self.commentsArray addObject:model];
            
            
        }
        
        //修改请求标记,重新开始请求的话下次就是10开始了
        _commentTag = self.commentsArray.count;
        
        //没有评论的时候，还没创建cell就滚动会崩掉
        if (self.commentsArray.count > 1) {
            
            //最后一行(之前删掉的元素的cell还存在，只需要新增加一行就行了)
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            
            //将第一行滚动到第一行
            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
        //刷新页面
        [_tableView reloadData];
        
    }
}

//点赞回调
-(void)submitSupportAtXuanNengCB:(int)result
{
    
    //数据回来后，将_syncView删掉
    [_syncView removeFromSuperview];
    
    if (result==205) {
        
        //提示框
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"你已点赞"];
        return;
        
    }
    
    //取出cell，取出model，取出like_count＋1.再刷新页面
    JokeModel* model = self.model;
    int tmpInt = [model.like_count intValue];
    tmpInt += 1;
    model.like_count = [NSString stringWithFormat:@"%d", tmpInt];
    
    //刷新页面
    [_tableView reloadData];
    
}

//转发微博回调
-(void)relayToWeiBoAtXuanNengCB:(int)result
{
    //去掉菊花
    [SVProgressHUD popActivity];
    
    JokeModel* model = self.model;
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
    [_tableView reloadData];
    
}

//分享回调
-(void)shareJokeAtXuanNengCB:(int)result{
    
    if (result==0) {
        
        //取出cell,取出model,改变forward_count
        JokeModel* model = self.model;
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
        [_tableView reloadData];
        
    }

}

@end
