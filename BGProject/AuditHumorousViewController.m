//
//  AuditHumorousViewController.m
//  BGProject
//
//  Created by liao on 15-3-12.
//  Copyright (c) 2015年 zhuozhong. All rights reserved.
//

#import "AuditHumorousViewController.h"
#import "AuditContentView.h"
#import "SVProgressHUD.h"
#import "MoudleMessageManager.h"
#import "AuditBar.h"
#import "ZZUserDefaults.h"

#define AuditBarH 44

@interface AuditHumorousViewController ()<UIScrollViewDelegate,MoudleMessageInterface,AuditBarDelegate>

@end

@implementation AuditHumorousViewController{
    
    __weak AuditContentView *_firContentView;
    
    __weak AuditContentView *_secContentView;
    
    __weak UIScrollView *_scrollView;
    
    __weak AuditBar *_auditBar;
    
    __weak UIButton *_reportButton;
    
}



-(NSMutableArray *)dataArray{
    
    if (_dataArray==nil) {
        
        _dataArray = [NSMutableArray array];
        
    }
    
    return _dataArray;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[MoudleMessageManager sharedManager] registerObserver:self];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[MoudleMessageManager sharedManager] unRegisterObserver:self];
    
    if (self.jokeid) {
        
        //将之前看到的jokeid存起来，第二次打开的时候要用到从那里开始
        [ZZUserDefaults setUserDefault:JokeidKey :self.jokeid];
        
    }
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置导航栏
    [self setupNavigationbar];
    
    //设置审核工具条
    [self setupAuditBar];
    
    //设置两个滑动的视图
    [self setupAuditContentView];
    
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    
    
    
}

//设置审核工具条
-(void)setupAuditBar{
    
    AuditBar *auditBar = [[AuditBar alloc] init];
    auditBar.delegate = self;
    CGFloat auditBarX = 0;
    CGFloat auditBarH = AuditBarH;
    CGFloat auditBarY = self.view.frame.size.height-auditBarH;
    CGFloat auditBarW = self.view.frame.size.width;
    auditBar.frame = CGRectMake(auditBarX, auditBarY, auditBarW, auditBarH);
    [self.view addSubview:auditBar];
    _auditBar = auditBar;
    
}

//设置审核内容视图
-(void)setupAuditContentView{
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    CGFloat scrollViewX = 0;
    CGFloat scrollViewY = kTopViewHeight;
    CGFloat scrollViewW = self.view.frame.size.width;
    CGFloat scrollViewH = self.view.frame.size.height-scrollViewY-AuditBarH;
    scrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);
    // 3.设置滚动的内容尺寸
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width*2, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    
    AuditContentView *firContentView = [[AuditContentView alloc] init];
    firContentView.frame = CGRectMake(10, 10, self.view.frame.size.width-2*10, 100);
    
    //如果没有数据就不能取
    if (self.dataArray.count==0) {
        
        firContentView.model = [[JokeModel alloc] init];
        
        //隐藏起来，否则会看到白色的lab
        firContentView.hidden = YES;
        
        //如果没有数据不能让它滚动
        _scrollView.scrollEnabled = NO;
        
        //设置没有更多数据占位图片
        [self setupNomoreView];
        
        //隐藏工具条
        _auditBar.hidden = YES;
        
        //隐藏举报按钮
        _reportButton.hidden = YES;
        
    }else{
        
        firContentView.model = self.dataArray[0];
        
        //记录下当前的jokeID
        self.jokeid = firContentView.model.jokeid;
        
    }
    
    self.contentIndex = 0;
    [scrollView addSubview:firContentView];
    _firContentView = firContentView;
    
    AuditContentView *secContentView = [[AuditContentView alloc] init];
    secContentView.frame = CGRectMake(self.view.frame.size.width+10, 10, self.view.frame.size.width-2*10, 100);
    if (self.dataArray.count>1) {
        
        secContentView.model = self.dataArray[1];
        
    }else{
        
        secContentView.model = [[JokeModel alloc] init];
        //隐藏起来，否则会看到白色的lab
        secContentView.hidden = YES;
        
    }
    
    [scrollView addSubview:secContentView];
    _secContentView = secContentView;
    
}

//添加没有数据的视图
-(void)setupNomoreView{
    
    UIImageView *nomoreView = [[UIImageView alloc] init];
    nomoreView.image = [UIImage imageNamed:@"bg_no content"];
    CGFloat nomoreW = 209;
    CGFloat nomoreX = (self.view.frame.size.width-nomoreW)/2;
    CGFloat nomoreY = kTopViewHeight+50;
    CGFloat nomoreH = 165;
    nomoreView.frame = CGRectMake(nomoreX, nomoreY, nomoreW, nomoreH);
    [self.view addSubview:nomoreView];
    
    
}

#pragma mark-UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    if (scrollView.contentOffset.x==0) {
        
        return;
        
    }
    
    
    if (self.contentIndex==self.dataArray.count-1) {
        
        //发送请求
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        
        [[MoudleMessageManager sharedManager] requestUnauditedContentWithItemid:0 type:0 start:0 end:5 maxxnid:[self.jokeid intValue]];
        
        return;
    }
    
    //数据为0是不会到达这里的，不能滑动
    _firContentView.model = self.dataArray[self.contentIndex+1];
    
    //记录下当前的jokeid
    self.jokeid = _firContentView.model.jokeid;
    
    //当标识比最大的要大的时候就不能取了
    if (self.contentIndex+2>self.dataArray.count-1 || self.dataArray.count<2) {
        
        //将右边的内容置空
        _secContentView.model = [[JokeModel alloc] init];
        
        //隐藏起来，否则会看到白色的lab
        _secContentView.hidden = YES;
        
    }else{
        
        _secContentView.model = self.dataArray[self.contentIndex+2];
        
    }
    
    self.contentIndex = self.contentIndex+1;
    
    scrollView.contentOffset = CGPointMake(0, 0);
    
}

//设置导航栏
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
    label1.text = @"我要审核";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    
    //顶部灰色横线
    UIView *barr1 =[[UIView alloc]initWithFrame:CGRectMake(0, topView.frame.origin.y+topView.frame.size.height, 320, 0.5)];
    barr1.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [self.view addSubview:barr1];
    
    //举报按钮
    UIButton *reportButton = [[UIButton alloc] init];
    reportButton.tag = 3;//举报类型
    CGFloat reportW = 40;
    CGFloat reportX = self.view.frame.size.width-10-reportW;
    CGFloat reportH = 40;
    CGFloat reportY = 22.5;
    reportButton.frame = CGRectMake(reportX, reportY, reportW, reportH);
    [reportButton setTitle:@"举报" forState:UIControlStateNormal];
    [reportButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    reportButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [reportButton addTarget:self action:@selector(reportButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _reportButton = reportButton;
    [topView addSubview:reportButton];
    
    [self.view addSubview:topView];
    
}

//举报按钮被点击
-(void)reportButtonClick:(UIButton *)button{
    
    [self didClickButtonAtIndex:button.tag];
    
}

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

//未审核数据返回
-(void)requestUnauditedContentCB:(NSArray *)result{
    
    [SVProgressHUD popActivity];
    
    
    if (result.count) {
        
        //先去掉全部数据
        [self.dataArray removeAllObjects];
        
        //将标识归0
        self.contentIndex = 0;
        
        //添加数据
        [self.dataArray addObjectsFromArray:result];
        
        //重新构建页面数据
        _firContentView.model = self.dataArray[0];
        self.jokeid = _firContentView.model.jokeid;
        
        //如果只有一个，不能取
        if (self.dataArray.count==1) {
            
            _secContentView.model = [[JokeModel alloc] init];
            _secContentView.hidden = YES;
            
        }else{
            
            _secContentView.model = self.dataArray[1];
            
        }
        
        _scrollView.contentOffset = CGPointMake(0, 0);
        
    }else{
        
        //如果没有数据了，隐藏第一个view
        _firContentView.hidden = YES;
        
        //构建没有数据占位图片
        [self setupNomoreView];
        
        //不能滑动
        _scrollView.scrollEnabled = NO;
        
        //隐藏工具条
        _auditBar.hidden = YES;
        
        //隐藏举报按钮
        _reportButton.hidden = YES;
        
    }

    
}

-(void)contentApprovalCB:(int)result{
    
    if (!result) {
        
        if (self.contentIndex==self.dataArray.count-1) {
            
            //发送请求
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            
            [[MoudleMessageManager sharedManager] requestUnauditedContentWithItemid:0 type:0 start:0 end:5 maxxnid:[self.jokeid intValue]];
            
            return;
        }
        
        _firContentView.model = self.dataArray[self.contentIndex+1];
        
        //记录下当前的jokeid
        self.jokeid = _firContentView.model.jokeid;
        
        //当标识比最大的要大的时候就不能取了
        if (self.contentIndex+2>self.dataArray.count-1) {
            
            //将右边的内容置空
            _secContentView.model = [[JokeModel alloc] init];
            
            //隐藏起来，否则会看到白色的lab
            _secContentView.hidden = YES;
            
        }else{
            
            _secContentView.model = self.dataArray[self.contentIndex+2];
            
        }
        
        self.contentIndex = self.contentIndex+1;
        
    }
    
}

#pragma mark-AuditBarDelegate

-(void)didClickButtonAtIndex:(NSInteger)index{
    
    //发送审核消息（0，不审核；1审核，2原创，3举报）
    [[MoudleMessageManager sharedManager] contentApprovalWithItemid:[self.jokeid intValue] type:(int)index];
    
    
}



@end
