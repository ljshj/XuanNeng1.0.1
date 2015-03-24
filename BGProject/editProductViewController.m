//
//  editProductViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-29.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "editProductViewController.h"
#import "enditNextViewController.h"
#import "UserStoreMessageInterface.h"
#import "UserStoreMessageManager.h"
#import "SVProgressHUD.h"
#import "ProductModel.h"
#import "ProductCell.h"

#import "FDSUserManager.h"
#import "addProductViewController.h"
#import "FDSPublicManage.h"
#import "MJRefresh.h"

@interface editProductViewController ()<UserStoreMessageInterface>


@end

@implementation editProductViewController

{
    UIView      *topView;
    UIButton    *backBtn;
    UITableView *myTabelView;
    UIButton   *netBtn;
    
    NSIndexPath* _deleteIndexPath;
    
    int _startCode;// 下拉加载，请求后面的数据使用。记录已经请求到的数据。
    BOOL _isResponseByDelete;
    
    BOOL _isFirstViewAppear;
    NSUInteger _allProductStartTag;     //请求所有产品的开始位置
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
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
    //导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    label1.text = @"产品编辑";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    [self.view addSubview:topView];
    
    //tableview
    CGFloat tablevViewX = 0;
    CGFloat tablevViewY = CGRectGetMaxY(topView.frame);
    CGFloat tablevViewW = self.view.bounds.size.width;
    CGFloat tablevViewH = self.view.bounds.size.height-tablevViewY;
    myTabelView =[[UITableView alloc]initWithFrame:CGRectMake(tablevViewX, tablevViewY, tablevViewW, tablevViewH)];
    myTabelView.delegate = self;
    myTabelView.dataSource = self;

    [self.view addSubview:myTabelView];
    
}


#pragma mark- 协议注册
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    //注册代理
    [[UserStoreMessageManager sharedManager]registerObserver:self];
    
    //不是第一次出现的话，模型数据可能修改了，因此需要刷新数据
    if(_isFirstViewAppear == YES) {
        
        //如果是第一次就改为no
        _isFirstViewAppear = NO;
        
    } else {
        
        //如果是第二次进来就直接刷新
        [myTabelView reloadData];
        
    }

}


-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //去掉代理
    [[UserStoreMessageManager sharedManager]unRegisterObserver:self];
    
}
#pragma mark btnClick===================

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(id)init
{
    if(self = [super init])
    {
            _productArr = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //取得当前userid
    self.userid = [[FDSUserManager sharedManager] NowUserID];
    
    //修改请求标记
    _allProductStartTag = self.productArr.count;
    
    //是否是第一次显示？这是干啥用的？
    _isFirstViewAppear = YES;
    
    //创建页面
    [self CreatTopView];
    
    //设置背景颜色
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    
    //上下拉刷新更多数据
    [self setupMoreData];
    
}

//刷新数据
-(void)setupMoreData{
    
    // 防止block循环retain，所以用__unsafe_unretained
    __unsafe_unretained editProductViewController *vc = self;
    
    //集成下拉刷新控件
    _header = [MJRefreshHeaderView header];
    _header.scrollView = myTabelView;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        
        //将请求标记为0
        vc->_allProductStartTag = 0;
        
        //删除所有产品的元素
        [vc->_productArr removeAllObjects];
        
        //发送请求所有产品的消息
        [[UserStoreMessageManager sharedManager]requestProductListWithUserID:vc->_userid
                                                                   withStart:vc->_allProductStartTag
                                                                     withEnd:vc->_allProductStartTag+kRequestCount];

        
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadDeals) withObject:nil afterDelay:3];
    };
    
    // 集成上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = myTabelView;
    
    // 进入上拉加载状态就会调用这个方法
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        NSString *allProductStartTagStr = [NSString stringWithFormat:@"%d",vc->_allProductStartTag];
        
        if ([allProductStartTagStr hasSuffix:@"0"]) {
            
            //发送请求所有产品的消息,不能点一次就发送一次消息
            [[UserStoreMessageManager sharedManager]requestProductListWithUserID:vc->_userid
                                                                       withStart:vc->_allProductStartTag
                                                                         withEnd:vc->_allProductStartTag+kRequestCount];
            
            
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
    [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"已经没有的商品了"];
    
}

//刷新表格
- (void)reloadDeals
{
    [myTabelView reloadData];
    // 结束刷新状态
    [_footer endRefreshing];
    [_header endRefreshing];
}

#pragma mark uitabelViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [_productArr count];
//    if(count == 0)
//    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }
//    else
//    {
//        tableView.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
//    }
    return count;
}

-(ProductCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellOne";
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ProductCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamedForResizeAble:@"cell_bg.png"]];
    }
   
    ProductModel* model = _productArr[indexPath.row];
    ProductCellFrame* cellFrame = [[ProductCellFrame alloc]init];
    cellFrame.model = model;
    cell.cellframe =cellFrame;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //添加商品和修改商品都是用同一个控制器
    addProductViewController* vc = [[addProductViewController alloc]init];
    
    //改变按钮和导航栏标签的标题
    vc.buttonTitle = @"确定修改";
    vc.viewTitle = @"编辑产品";
    
    //取得模型
    vc.model = _productArr[indexPath.row];
    
    //取得产品数组
    vc.productArr = _productArr;
    
    //切换到编辑控制器
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProductModel* model = _productArr[indexPath.row];
    ProductCellFrame* cellFrame = [[ProductCellFrame alloc]init];
    cellFrame.model = model;
    
    return cellFrame.cellHight;
}



#pragma mark- 侧滑删除
//2014年10月10日
//要求委托方的编辑风格在表视图的一个特定的位置。
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
    if ([tableView isEqual:myTabelView]) {
        result = UITableViewCellEditingStyleDelete;//设置编辑风格为删除风格
    }
    return result;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [myTabelView setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{//请求数据源提交的插入或删除指定行接收者。
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        if (indexPath.row<[_productArr count]) {
            
            //2014年10月10日 发送删除请求
            ProductModel* model =  _productArr[indexPath.row];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            NSString* idStr = [NSString stringWithFormat:@"%d", model.product_id_int];
            [[UserStoreMessageManager sharedManager]requestDeleteProductWithID:idStr];
            
            _deleteIndexPath = indexPath;
        }
    }
}

-(void)requestDeleteProductCB:(int)returnCode
{
    [SVProgressHUD popActivity];
    
    if(returnCode == 0) {
        
        [self.productArr removeObjectAtIndex:_deleteIndexPath.row];//移除数据源的数据
        [myTabelView deleteRowsAtIndexPaths:[NSArray arrayWithObject:_deleteIndexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
        
        
    }
    else
    {
        
//        [UIAlertView showMessage:@"删除失败，请稍后再试"];
          [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"删除失败，请稍后再试"];
        
    }
}

//请求请求全部产品的回调
-(void)requestProductListCB:(NSMutableArray*)productArr
{
    //关掉菊花
    [SVProgressHUD popActivity];
    
    
    //往所有产品中添加最新的数据
    [self.productArr addObjectsFromArray:productArr];
    
    _allProductStartTag = _allProductStartTag+productArr.count;
    
    //刷新全部表格
    [myTabelView reloadData];
    
}

@end
