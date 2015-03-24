//
//  ProCommentViewController.m
//  BGProject
//
//  Created by liao on 14-11-20.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ProCommentViewController.h"
#import "FDSUserManager.h"
#import "UserStoreMessageInterface.h"
#import "UserStoreMessageManager.h"
#import "SVProgressHUD.h"
#import "BGWQCommentCellFrame.h"
#import "WQComentCell.h"
#import "BGPublishView.h"
#import "PersonViewController.h"
#import "AppDelegate.h"
#import "MJRefresh.h"

#define kTopViewHeight 64
#define TabBarHeight 49

@interface ProCommentViewController ()<UserStoreMessageInterface,UITableViewDataSource,UITableViewDelegate,BGPublishViewDelegate>

@end

@implementation ProCommentViewController{
    
    __weak UITableView *_commentView;
    __weak UIButton *_commentBtn;
    __weak BGPublishView *_publishView;
    __weak UIView *_keyboardBackView;
    
    //请求产品评论的开始位置
    int _proCommentStartTag;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    
}

//数组的懒加载
-(NSMutableArray *)commentCellFrames{
    
    if (_commentCellFrames == nil) {
        
        _commentCellFrames = [[NSMutableArray alloc] init];
        
    }
    return _commentCellFrames;
}

-(void)viewWillAppear:(BOOL)animated
{
    //隐藏tabbar
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app hiddenTabelBar];
    
    [super viewWillAppear:animated];
    
    
    
    //注册代理，商店单独一个管理中心
    [[UserStoreMessageManager sharedManager]registerObserver:self];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    
    //去掉代理
    [[UserStoreMessageManager sharedManager]unRegisterObserver:self];
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //创建导航栏
    [self CreatView];
    
    //添加tableview
    [self setupTableView];
    
    //监听键盘
    [self observeKeyboard];
    
    //上下拉刷新
    [self setupMoreData];

}

//刷新数据
-(void)setupMoreData{
    
    // 防止block循环retain，所以用__unsafe_unretained
    __unsafe_unretained ProCommentViewController *vc = self;
    
    //集成下拉刷新控件
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _commentView;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        
        //将请求标记为0
        vc->_proCommentStartTag = 0;
        
        //发送获取评论消息
        [[UserStoreMessageManager sharedManager] requestProductCommentsWithProID:vc->_product_id start:vc->_proCommentStartTag end:vc->_proCommentStartTag+kRequestCount];
        
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadDeals) withObject:nil afterDelay:3];
    };
    
    // 集成上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _commentView;
    
    // 进入上拉加载状态就会调用这个方法
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        NSString *proCommentStartTagStr = [NSString stringWithFormat:@"%d",vc->_proCommentStartTag];
        
        if ([proCommentStartTagStr hasSuffix:@"0"]) {
            
            //发送获取评论消息
            [[UserStoreMessageManager sharedManager] requestProductCommentsWithProID:vc->_product_id start:vc->_proCommentStartTag end:vc->_proCommentStartTag+kRequestCount];
            
            
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
    [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"已经更多的评论了"];
    
}

//刷新表格
- (void)reloadDeals
{
    [_commentView reloadData];
    // 结束刷新状态
    [_footer endRefreshing];
    [_header endRefreshing];
}

-(void)setupTableView{
    
    UITableView *commentView = [[UITableView alloc] init];
    CGFloat tableViewX = 0;
    CGFloat tableViewY = kTopViewHeight;
    CGFloat tableViewW = kScreenWidth;
    CGFloat tableViewH = self.view.bounds.size.height-kTopViewHeight;
    commentView.frame = CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH);
    commentView.dataSource = self;
    commentView.delegate = self;
    commentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:commentView];
    _commentView = commentView;
}

-(void)CreatView
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
    label1.text = @"产品评论";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    //评论按钮
    UIButton *commentBtn = [[UIButton alloc] init];
    CGFloat commentBtnW = 50;
    CGFloat commentBtnX = kScreenWidth-commentBtnW-20;
    CGFloat commentBtnH = 30;
    CGFloat commentBtnY = 20+(kTopViewHeight-commentBtnH-20)*0.5;
    commentBtn.frame = CGRectMake(commentBtnX, commentBtnY, commentBtnW, commentBtnH);
    [commentBtn setTitle:@"新评论" forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commentBtn setBackgroundImage:[UIImage imageNamed:@"proCommentButton_highlighted"] forState:UIControlStateHighlighted];
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    //设置圆角和边框
    commentBtn.layer.borderWidth = 1.0;
    commentBtn.layer.borderColor = [UIColor grayColor].CGColor;
    CGFloat radius = 5;
    [commentBtn.layer setCornerRadius:radius];
    [commentBtn.layer setMasksToBounds:YES];
    [commentBtn addTarget:self action:@selector(commentButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //太他妈的噁心了
    
    [topView addSubview:commentBtn];
    _commentBtn = commentBtn;
    [self.view addSubview:topView];
    
}

//监听键盘弹出
-(void)observeKeyboard{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//设置评论框
-(void)setupPublishView{
    
    BGPublishView *publishView = [[BGPublishView alloc] init];
    publishView.delegate = self;
    CGFloat publishViewX = 0;
    CGFloat publishViewY = self.view.frame.size.height- TabBarHeight;
    CGFloat publishViewW = self.view.frame.size.width;
    CGFloat publishViewH = TabBarHeight;
    publishView.frame = CGRectMake(publishViewX,publishViewY ,publishViewW , publishViewH);
    [self.view addSubview:publishView];
    _publishView = publishView;
    
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

//把键盘放下去
-(void)resignKeyboardTap{
    [_publishView endEditing:YES];
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
    __unsafe_unretained ProCommentViewController *PCVc = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        //修改_publishView的y值
        CGRect publishF = PCVc->_publishView.frame;
        publishF.origin.y = self.view.frame.size.height-TabBarHeight-size.height;
        PCVc->_publishView.frame = publishF;
        
        //修改tableView的高度
        CGRect tableViewF = PCVc->_commentView.frame;
        tableViewF.size.height = self.view.frame.size.height-TabBarHeight-size.height-tableViewF.origin.y;
        PCVc->_commentView.frame = tableViewF;
        
    }];
}

-(void)keyboardWillHide:(NSNotification *)noti{
    
    //将从父视图遮罩移除
    [_keyboardBackView removeFromSuperview];
    
    
    __unsafe_unretained ProCommentViewController *PCVc = self;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        //修改_publishView的y值
        CGRect publishF = PCVc->_publishView.frame;
        publishF.origin.y = self.view.frame.size.height-TabBarHeight;
        PCVc->_publishView.frame = publishF;
        
        //修改tableView的高度
        CGRect tableViewF = PCVc->_commentView.frame;
        tableViewF.size.height = self.view.frame.size.height-tableViewF.origin.y;
        PCVc->_commentView.frame = tableViewF;
    } completion:^(BOOL finished) {
        //键盘下来的时候将输入框删掉
        [PCVc->_publishView removeFromSuperview];
    }];
}

-(void)commentButtonClick{
    
    [MobClick event:@"me_comment_product_click"];
    
    //判断是否已经登录
    if ([[FDSUserManager sharedManager] getNowUserState]!=USERSTATE_LOGIN) {
        PersonViewController *perVC = [[PersonViewController alloc] init];
        perVC.isAppearBackBtn = YES;
        [self.navigationController pushViewController:perVC animated:YES];
        return;
    }
    
    //创建发送框
    [self setupPublishView];
    
    //通过这个tempView成为第一响应者将键盘弹出
    [_publishView.commentField becomeFirstResponder];
    
    //设置评论类型
    _publishView.commentField.placeholder = PlaceholderComment;
    
    
}
-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.commentCellFrames.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BGWQCommentCellFrame *commentF = self.commentCellFrames[indexPath.row];
    return commentF.cellHight;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WQComentCell *cell = [WQComentCell cellWithTableView:tableView];
    
    cell.commentFrame = self.commentCellFrames[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //取消点中效果
    [self tableViewDeSelect:tableView];
    
    return;//现在不做回复评论，下面的东西暂时不执行
    
    //添加发送框
    [self setupPublishView];
    
    //通过这个tempView成为第一响应者将键盘弹出
    [_publishView.commentField becomeFirstResponder];
    
    //取出对应的模型
    BGWQCommentCellFrame *cellFrame = self.commentCellFrames[indexPath.row];
    
    //设置占位文字
    NSString *placeholder = [NSString stringWithFormat:@"回复: @%@ ",cellFrame.model.name];
    _publishView.commentField.placeholder = placeholder;
}

//deselected the cell
-(void)tableViewDeSelect:(UITableView*)table
{
    NSIndexPath* indexPath = [table indexPathForSelectedRow];
    [table deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

//点击发送按钮的回调
-(void)didSelectedPublishButton:(NSString *)text{
    
    //爆菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    //发送评论产品消息
    [[UserStoreMessageManager sharedManager] submitProductComment:text productId:self.product_id];
    
    //将键盘放下去
    [_publishView endEditing:YES];
}

//评论商品回调
-(void)submitProductCommentCB:(int)returnCode{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //评论成功
    if (returnCode == 0) {
        
        //将请求标记为0
        _proCommentStartTag = 0;
        
        //发送获取评论消息
        [[UserStoreMessageManager sharedManager] requestProductCommentsWithProID:self.product_id start:0 end:kRequestCount];
        
        _publishView.commentField.text = @"";
    }
    
}

//请求商品评论回调
-(void)requestProductCommentsCB:(NSArray *)data{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    if (_proCommentStartTag==0) {
        
        [self.commentCellFrames removeAllObjects];
        
    }
    
    //字典数组转换成模型数组
    for (NSDictionary *dic in data) {
        
        //将字典转换成模型
        BGWQCommentModel *model = [BGWQCommentModel commentWithDic:dic];
        
        //将模型转换成cellframe
        BGWQCommentCellFrame *cellFrame = [[BGWQCommentCellFrame alloc] initWithModel:model];
        
        //添加到数组
        [self.commentCellFrames addObject:cellFrame];
        
    }
    
    _proCommentStartTag = _proCommentStartTag+(int)self.commentCellFrames.count;
    
    //刷新数据
    [_commentView reloadData];
    
    
}

@end
