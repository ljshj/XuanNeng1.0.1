//
//  myStoreViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//


#define kScreenRect [UIScreen mainScreen].bounds


#import "myStoreViewController.h"
#import "addProductViewController.h"
#import "editProductViewController.h"
#import "modeViewController.h"
#import "AppDelegate.h"

#import "FDSUserManager.h"
#import "UserStoreMessageInterface.h"
#import "UserStoreMessageManager.h"
#import "SVProgressHUD.h"

#import "StoreView.h"
#import "FDSPublicManage.h"
#import "ProductCell.h"
#import "ProductDetailViewController.h"
#import "MJRefresh.h"
#import "RecomProductCell.h"
#import "RecomProductModel.h"

@interface myStoreViewController ()<UserStoreMessageInterface,StoreViewDelegate,UITableViewDataSource,
UITextFieldDelegate,UITableViewDelegate>


-(void)requestProductListCB:(NSMutableArray*)productArr;
-(void)storeView:(StoreView *)store buttonClick:button;

-(void)request30006CB:(NSArray *)models;

@end

@implementation myStoreViewController

{
    UIView    *topView;// 最上面的菜单栏
    UIButton  *backBtn;
    UIButton *rightBtn;
    
    UIView * allView;
    UIView *rightView;
    UITextField *tf;
    
    UIButton *botmBtn;
    NSArray *fontImageArr;
    NSArray *labelContent;
    UIImage *endImg;
    
    UIImageView* _tfBackView;//将tf 搜索框放在界面的窗帘后面

    //2014年10月10日 先做表头 tableHeaerView 在tf的下面
    StoreView* _tableHeaderView;
    
    //TODO::2014年10月10日 完成产品的显示
    UITableView* _recorProductTableView; // 显示推荐产品
    UITableView* _allPruductTableView;
    UITableView* _searchedProductTableView;
    
    
    NSMutableArray* _recorProductArr;//应该是推荐产品吧
    NSMutableArray* _allPruductArr;//应该是所有的产品吧
    NSMutableArray* _searchedProudctArr; //搜索到的产品
    

    int _allProductStartTag;     //请求所有产品的开始位置
 
    UIButton* _selectedButton;          // 标记被选中的button
    
    BOOL _needPushView;   // 因为该页面有两个地方需要请求产品30008 一个需要在CB中跳转页面
    
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        fontImageArr = [NSArray arrayWithObjects:@"添加",@"编辑",@"模版", nil];
        labelContent  = [NSArray arrayWithObjects:@"添加产品",@"产品编辑",@"个性化模版", nil];
        endImg = [UIImage imageNamed:@"橱窗操作_"];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    //隐藏tabbar
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    [app hiddenTabelBar];
    
    //神马按钮？右边那个被选中？
    rightBtn.selected = YES;
    
    //一开始就被点击，为啥一开始要这样子？
    [self btnClick:rightBtn];
    
    //注册代理，商店单独一个管理中心
    [[UserStoreMessageManager sharedManager]registerObserver:self];
    
    //2014年10月10日
    // 设置风格颜色
    if(_needRefreshView == YES)
    {
        _needRefreshView = YES;
        
        //原来是在这里设置颜色
        [self setStyle];
        
        //显示模型数据
        [_tableHeaderView showInfo:_model];
        
    }
    
    //权宜之计只能这样了，这样子比较浪费流量，先留着
    [NSThread detachNewThreadSelector:@selector(refreshProductList) toTarget:self withObject:nil];
    
    [NSThread detachNewThreadSelector:@selector(refreshReProductList) toTarget:self withObject:nil];
    
    
    [super viewWillAppear:animated];

    [MobClick beginLogPageView:@"橱窗"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"橱窗"];
    
    //去掉代理
    [[UserStoreMessageManager sharedManager]unRegisterObserver:self];
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
}

-(void)CreatTopView
{
    
    //整个屏幕那么大,干啥用的？
    allView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    allView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];

    //导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    if (self.storeType==StoreTypeOther) {
        label1.text = @"TA的橱窗";
    }else{
        
        label1.text = @"我的橱窗";  
        
    }
    
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(260, 20, 50, 44)];
    NSString *userid = [[FDSUserManager sharedManager] NowUserID];
    
    if (self.storeType==StoreTypeOther) {
        
        rightBtn.hidden = YES;
        
    }else{
        
        rightBtn.hidden = NO;
        
    }
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"更多点击效果"] forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightBtn];
    [allView addSubview:topView];
    
    //搜索输入框
    tf= [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 300, 30)];
    tf.delegate = self;
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.placeholder = @"请输入你要搜索的产品";
    tf.font = [UIFont systemFontOfSize:13.0];
    tf.returnKeyType = UIReturnKeySearch;
    //监听回车按钮
    tf.delegate = self;
    
    //搜索图标
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 17, 17)];
    imageView.image =[UIImage imageNamed:@"searchIcon"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //分割线
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(36, 10, 1, 24)];
    lineView.backgroundColor =[UIColor grayColor];
    lineView.alpha = 0.3;
    
    //背景视图
    UIView *bigView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 41, 44)];
    [bigView addSubview:imageView];
    [bigView addSubview:lineView];
    
    tf.leftView = bigView;
    tf.leftViewMode = UITextFieldViewModeAlways;

    //创建搜索的背景卷云图片
    CGFloat tfBackViewX = 0;
    CGFloat tfBackViewY = topView.frame.origin.y+topView.frame.size.height;
    CGFloat tfBackViewW = kScreenWidth;
    CGFloat tfBackViewH = 60;
    _tfBackView = [[UIImageView alloc]initWithFrame:(CGRect){tfBackViewX,tfBackViewY,tfBackViewW,tfBackViewH}];
    _tfBackView.userInteractionEnabled = YES;
    [_tfBackView addSubview:tf];
    [_tfBackView setImage:[UIImage imageNamed:@"窗帘_02.png"]];
    
    //直接加上去不行吗？为何要添加这个呢，不解
    [allView addSubview:_tfBackView];
    [self.view addSubview:allView];
}

//创建侧滑
-(void)CreatRightView
{
    //侧滑背景view
    CGFloat rightViewX = self.view.bounds.size.width;
    CGFloat rightViewY = 20;
    CGFloat rightViewH = self.view.bounds.size.height;
    CGFloat rightViewW = 160;
    rightView = [[UIView alloc]initWithFrame:CGRectMake(rightViewX, rightViewY, rightViewW, rightViewH)];
    rightView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [self.view addSubview:rightView];
    
    //侧滑头部视图
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 44)];
    topLabel.backgroundColor = [UIColor colorWithRed:217/255.0 green:246/255.0 blue:163/255.0 alpha:1.0];
    topLabel.text = @"店铺操作";
    topLabel.textAlignment = UITextAlignmentCenter;
    [rightView addSubview:topLabel];
    
    //创建三个cell（添加／编辑／个性化模版）
    for (int i = 0; i < 3; i++) {
        
        botmBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 44+i*44, 160, 44)];
        botmBtn.tag = i;
        
        UIImageView *imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 13.5, 13.5)];
        imgView1.image = [UIImage imageNamed:fontImageArr[i]];
        
        UILabel *label = [[UILabel alloc ]initWithFrame:CGRectMake(imgView1.frame.origin.x+imgView1.frame.size.width+5, 5, 100, 30)];
        label.text  = labelContent[i];
        
        UIImageView *imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(140, 14, 8.5, 12)];
        imgView2.image = endImg;
        
        [botmBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [botmBtn addSubview:imgView1];
        [botmBtn addSubview:label];
        [botmBtn addSubview:imgView2];
        [rightView addSubview:botmBtn];
    }
    
    //分割线
    for (int i = 0; i<4; i++) {
        
        UIView *barr = [[UIView alloc]initWithFrame:CGRectMake(0, (i+1)*44, 160, 0.5)];
        barr.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"橱窗操作线"]];
        [rightView addSubview:barr];
        
    }

}


#pragma mark btnClick===================

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)btnClick:(UIButton *)sender
{
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //转换选中状态
    sender.selected = !sender.selected;
    
    
    if ([sender isSelected])
    {
        //创建右边的侧滑view
        [self CreatRightView];

        
        [UIView animateWithDuration:0.3 animations:^{
            
            //横坐标－160
            CGRect allViewF = allView.frame;
            allViewF.origin.x -= 160;
            allView.frame = allViewF;
            
            CGRect rightViewF = rightView.frame;
            rightViewF.origin.x -= 160;
            rightView.frame = rightViewF;
            
        }];

    }else
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            //rightView是哪一个？右边那个侧滑？
            [rightView removeFromSuperview];
            
            //480，没用相对坐标，没问题？
            allView.frame = CGRectMake(0, 0, 320, 480);
        }];
    }
    

}

//侧滑三个cell的点击监听
-(void)bottomBtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            addProductViewController *add = [[addProductViewController alloc]init];
            [self.navigationController pushViewController:add animated:YES];
        }
            break;
        case 1:
        {
#pragma mark-产品编辑
            //取出用户id
            NSString* userID = [[FDSUserManager sharedManager ] NowUserID];
            
            //开始请求标识为0
            int start = 0;
            
            //爆菊花
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            
            //发送请求全部商品列表的消息
            [[UserStoreMessageManager sharedManager]requestProductListWithUserID:userID withStart:start withEnd:start+kRequestCount];
            
            //修改bool值
            _needPushView = YES;//返回数据后跳转页面。
            
        }
            break;
        case 2:
        {
            modeViewController *add = [[modeViewController alloc]init];
            add.mainColor = _mainColor;
            [self.navigationController pushViewController:add animated:YES];
        }
            break;
            
        default:
            break;
    }
}

-(void)nextPage:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//刷新数据
-(void)setupMoreData{
    
    // 防止block循环retain，所以用__unsafe_unretained
    __unsafe_unretained myStoreViewController *vc = self;
    
    //集成下拉刷新控件
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _allPruductTableView;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        
        //将请求标记为0
        vc->_allProductStartTag = 0;
        
        //删除所有产品的元素
        [vc->_allPruductArr removeAllObjects];
    
        //发送请求所有产品的消息
        [[UserStoreMessageManager sharedManager]requestProductListWithUserID:vc->_userid
                                                                   withStart:vc->_allProductStartTag
                                                                     withEnd:vc->_allProductStartTag+kRequestCount];
        
        //啥意思？不要切换控制器，这是全部的，不是产品编辑
        vc->_needPushView = NO;
        
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadDeals) withObject:nil afterDelay:3];
    };
    
    // 集成上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _allPruductTableView;
    
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
        
        //啥意思？不要切换控制器，这是全部的，不是产品编辑
        vc->_needPushView = NO;
        
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
    [_allPruductTableView reloadData];
    // 结束刷新状态
    [_footer endRefreshing];
    [_header endRefreshing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化模型数据，一开始就要刷新数据
    _needRefreshView = YES;
    
    _recorProductArr=[NSMutableArray array];
    _allPruductArr = [NSMutableArray array];
    
    //不解，这个又是干嘛用的
    _needPushView = NO;
    
    //获取颜色的存储路径
    NSString* colorFilePath = [FDSPublicManage getColorFilePath];
    
    //获取存储内容，这个是在哪里存储了？
    NSArray* RGB  = [NSArray arrayWithContentsOfFile:colorFilePath];
    
    if([RGB count] == 0 )
    {
        _mainColor = [UIColor colorWithRed:74/255.0 green:161/255.0 blue:180/255.0 alpha:1];
    }else
    {
        CGFloat r = [RGB[0] floatValue];
        CGFloat g = [RGB[1] floatValue];
        CGFloat b = [RGB[2] floatValue];
        _mainColor = [UIColor colorWithRed:r green:g  blue:b alpha:1];
    }
    
    //创建页面
    [self CreatTopView];
    
    //背景颜色
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    
    //这是封装了神马东西呢？
    CGFloat headerY = CGRectGetMaxY(_tfBackView.frame);
    CGFloat headerW = kScreenWidth;
    CGFloat headerH = 140;
    _tableHeaderView = [[StoreView alloc]initWithFrame:CGRectMake(0, headerY, headerW, headerH)];
    _tableHeaderView.delegate = self;
    [allView addSubview:_tableHeaderView];
    
    //表头视图
    CGFloat tableY = CGRectGetMaxY(_tableHeaderView.frame);
    CGFloat tableW = kScreenWidth;
    CGFloat tableH = kScreenRect.size.height - tableY;
    CGRect tableViewFrame = CGRectMake(0, tableY, tableW, tableH);
   
    //产品推荐表格
    _recorProductTableView = [[UITableView alloc]initWithFrame:tableViewFrame
                                                         style:UITableViewStylePlain];
    _recorProductTableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    _recorProductTableView.dataSource = self;
    _recorProductTableView.delegate = self;
    _recorProductTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    //搜索结果列表
    _searchedProductTableView = [[UITableView alloc]initWithFrame:tableViewFrame
                                                            style:UITableViewStylePlain];
    _searchedProductTableView.dataSource = self;
    _searchedProductTableView.delegate = self;
    _searchedProductTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    //所有产品列表
    _allPruductTableView =  [[UITableView alloc]initWithFrame:tableViewFrame
                                                        style:UITableViewStylePlain];
    
    _allPruductTableView.dataSource = self;
    _allPruductTableView.delegate = self;
    _allPruductTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    //先添加产品推荐列表，其他的先不添加,但是折帐表格是没有数据的
    [allView addSubview:_recorProductTableView];
    
    //创建上下拉刷新
    [self setupMoreData];
    
}


#pragma mark uitextfiedDelegate

#pragma mark  搜索商品
#pragma mark- textfield
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if([textField.text length] > 0)
    {
        
        //爆菊花
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        
        //发送橱窗搜索请求
        [[UserStoreMessageManager sharedManager]request30006withID:self.userid keyword:textField.text];
        
        [MobClick event:@"me_search_product_click"];
        
    }
    
}

//好像调这个没啥用吧？都没发请求，只是放下了键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tf  resignFirstResponder];
    
    // 发送请求
    return  YES;
}

//请求请求全部产品的回调
-(void)requestProductListCB:(NSMutableArray*)productArr
{
    //关掉菊花
    [SVProgressHUD popActivity];

    
    //在开始请求的时候就修改了
    if(_needPushView== YES)
    {
        //拿到数组并且推到产品编辑控制器
        editProductViewController *editVC = [[editProductViewController alloc]init];
        [editVC.productArr addObjectsFromArray:productArr];
        [self.navigationController pushViewController:editVC animated:YES];
        
    } else
    {
        
        //往所有产品中添加最新的数据
        [_allPruductArr addObjectsFromArray:productArr];
        
        _allProductStartTag = _allProductStartTag+productArr.count;
        
        NSString *buttonTitle = _selectedButton.titleLabel.text;
        
        if (![buttonTitle hasPrefix:@"所有产品"]) {
            
            return;
            
        }
        
        //将推荐产品表格删除
        [_recorProductTableView removeFromSuperview];
        
        //再将搜索表格移除
        [_searchedProductTableView removeFromSuperview];

        //添加全部产品表格
        [self.view addSubview:_allPruductTableView];
        
        //刷新全部表格
        [_allPruductTableView reloadData];
        
    }

}

//设置风格
-(void)setStyle
{
//    _mainColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"主题背景.png"]];
    [_tfBackView setBackgroundColor:_mainColor];

    [_tableHeaderView setSytle:_mainColor];
    
}



//请求推荐产品 or 所有产品,全部和推荐按钮的回调
#pragma mark-请求产品
-(void)storeView:(StoreView *)store buttonClick:(UIButton*)btn
{
    //取出按钮的标题
    NSString* buttonTitle = btn.titleLabel.text;
    
    //将按钮记录下来
    _selectedButton = btn;
    
    if([buttonTitle hasPrefix:@"产品推荐"])
    {
        NSLog(@"产品推荐");
        if([_model.recommend_list count]== 0)
        {
        
              [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"没有推荐产品"];
        }
 
        //不需要再次请求数据，因为进入该页面的时候，有了若干数据。
        
        //将所有产品表格删除
        [_allPruductTableView removeFromSuperview];
        
        //将搜索表格删除
        [_searchedProductTableView removeFromSuperview];
        
        [allView addSubview:_recorProductTableView];
        
        //刷新推荐产品列表
        [_recorProductTableView reloadData];
        
        return;
    }
    
    if([buttonTitle hasPrefix:@"所有产品"])
    {
        
        NSLog(@"所有产品");
        
        //先将产品推荐表格移除
        [_recorProductTableView removeFromSuperview];
        
        //再将搜索表格移除
        [_searchedProductTableView removeFromSuperview];
        
        //添加所有产品的表格
        [allView addSubview:_allPruductTableView];
        
        [_allPruductTableView reloadData];
        
        //只有所有产品的数组元素个数为0时才需要请求数据
        if (!_allPruductArr.count) {
            
            //爆菊花
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            
            //发送请求所有产品的消息,不能点一次就发送一次消息
            [[UserStoreMessageManager sharedManager]requestProductListWithUserID:self.userid
                                                                       withStart:0
                                                                         withEnd:0+kRequestCount];
            
            //啥意思？不要切换控制器，这是全部的，不是弹出框的产品编辑,产品编辑才需要却换控制器，返回的数据
            _needPushView = NO;
        }
        
        return;
    }
}



#pragma  mark- tableview的代理

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* reuseForAllPro = @"ProductCell";
    static NSString* reuseForSearchedPro = @"SearchedProductCell";
    
    if(tableView == _recorProductTableView)
    {
       
        RecomProductCell *cell = [RecomProductCell cellWithTableView:tableView];
        
        RecomProductFrame *cellFame = [[RecomProductFrame alloc] init];
        cellFame.model = self.model.recommend_list[indexPath.row];
        cell.cellframe = cellFame;
        return cell;
    }
    
    if(tableView == _allPruductTableView)
    {
        //创建cell
        ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseForAllPro];
        if (!cell) {
            cell = [[ProductCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseForAllPro];
            
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamedForResizeAble:@"cell_bg.png"]];
        }
        
        //从数组取出模型
        ProductModel* model = _allPruductArr[indexPath.row];
        ProductCellFrame* cellFrame = [[ProductCellFrame alloc]init];
        
        //把cell所有的控件frame都算好
        cellFrame.model = model;
        
        //为cell的控件赋值并且
        cell.cellframe =cellFrame;
        
        return cell;
        
    }
    
    //ps:看着这代码也是醉了
    
    //
    if(tableView == _searchedProductTableView)
    {
        
        //创建cell
        ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseForSearchedPro];
        if (!cell) {
            cell = [[ProductCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseForSearchedPro];
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamedForResizeAble:@"cell_bg.png"]];
        }
        
        //取出模型
        ProductModel* model = _searchedProudctArr[indexPath.row];
        
        ProductCellFrame* cellFrame = [[ProductCellFrame alloc]init];
        //将所有的子控件frame算好
        cellFrame.model = model;
        
        //为cell赋值
        cell.cellframe =cellFrame;
        
        return cell;
    }
    
    //最后显示这货
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    
    //根据tableview来判断返回那个数组的个数
    if(tableView == _recorProductTableView)
    {
        count = [_model.recommend_list count];

    }
    else if(tableView == _allPruductTableView)
    {
        count = [_allPruductArr count];
    } else if(tableView == _searchedProductTableView)
    {
        count = [_searchedProudctArr count];
    }
    
    //cell没有选中效果
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return count;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _allPruductTableView) {
        ProductModel* model = _allPruductArr[indexPath.row];
        ProductCellFrame* cellFrame = [[ProductCellFrame alloc]init];
        cellFrame.model = model;
        
        return cellFrame.cellHight;
    } else if(tableView == _searchedProductTableView)
    {
        //取出产品模型
        ProductModel* model = _searchedProudctArr[indexPath.row];
        
        ProductCellFrame* cellFrame = [[ProductCellFrame alloc]init];
        
        //将所有cell的空间的frame都算好
        cellFrame.model = model;
        
        //返回高度
        return cellFrame.cellHight;
    }
    
    //取出产品模型
    RecomProductModel* model = self.model.recommend_list[indexPath.row];
    RecomProductFrame* cellFrame = [[RecomProductFrame alloc]init];
    cellFrame.model = model;
    
    return cellFrame.cellHight;
}

//橱窗搜索回调
-(void)request30006CB:(NSArray *)models
{
    
    //去掉菊花
    [SVProgressHUD popActivity];
    
    //如果搜索数组为空，则初始化数组
    if(_searchedProudctArr == nil)
    {
        _searchedProudctArr = [NSMutableArray array];
    }
    
    //将原有的元素全部删除
    [_searchedProudctArr removeAllObjects];
    
    //装进新的数组
    [_searchedProudctArr addObjectsFromArray:models];
    
    //删除所有产品列表
    [_allPruductTableView removeFromSuperview];
    [_recorProductTableView removeFromSuperview];
    
    //添加搜索产品列表
    [allView addSubview:_searchedProductTableView];
    
    //刷新列表
    [_searchedProductTableView reloadData];
    
    //现在既不是全部产品也不是推荐产品，所以将他们两个的选中状态去掉
    [_tableHeaderView removeAllButtonSelectedState];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取被点击的cell
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //创建产品详情控制器
    ProductDetailViewController* vc = [[ProductDetailViewController alloc]initWithNibName:nil bundle:nil ];

    
    //判断是否是ProductCell
    if([cell isKindOfClass:[ProductCell class]])
    {
        ProductCell* targetCell = (ProductCell*)cell;
        //获取产品模型
        ProductModel* model = targetCell.cellframe.model;
        
        vc.model = model;
        vc.productType=ProductTypeAll;
    }else{
        
        RecomProductCell* targetCell = (RecomProductCell*)cell;
        //获取产品模型
        RecomProductModel* model = targetCell.cellframe.model;
        
        vc.reModel = model;
        
        vc.productType=ProductTypeRecomment;
        
    }
    
    //0.5s后执行方法tableViewDisSelected:，为了取消选中效果？？
    [self performSelector:@selector(tableViewDisSelected:) withObject:tableView afterDelay:0.5];
    
    //取得userid
    vc.userid = self.userid;
    
    //切换控制器
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)tableViewDisSelected:(UITableView*)tableview{
    NSIndexPath* indexPath= [tableview indexPathForSelectedRow];
    [tableview deselectRowAtIndexPath:indexPath animated:YES];
}

//通知刷新所有列表
-(void)refreshProductList{
    
    //将请求标记为0
    _allProductStartTag = 0;
    
    //删除所有产品的元素
    [_allPruductArr removeAllObjects];
    
    //发送请求所有产品的消息
    [[UserStoreMessageManager sharedManager]requestProductListWithUserID:_userid
                                                               withStart:_allProductStartTag
                                                                 withEnd:_allProductStartTag+kRequestCount];
    
    //啥意思？不要切换控制器，这是全部的，不是产品编辑
    _needPushView = NO;

}

-(void)refreshReProductList{
    
    //发送请求橱窗消息(先不做刷新推荐列表的，留着)
    [[UserStoreMessageManager sharedManager]request30001WithID:self.userid];
    
}

//橱窗消息回调
-(void)request30001CB:(ChuChuangModel*)model{
    
    self.model = model;
    
    //数据回来后重新刷新
    [_tableHeaderView showInfo:_model];
    
}


@end
