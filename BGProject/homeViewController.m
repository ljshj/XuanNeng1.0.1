

//
//  homeViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "homeViewController.h"
#import "CityModel.h"
#import "suoZaiViewController.h"
#import "constants.h"
@implementation GIFTArea

@end

@interface homeViewController ()

@end

@implementation homeViewController

{
    UIView    *topView;
    UIButton  *backBtn;
    UITableView *myTableView;
    NSMutableArray *_dataSource;
   // NSMutableArray *provinces;
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
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(140, 24, 80, 40)];
    label1.text = @"家乡";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    [topView addSubview:label1];
    [self.view addSubview:topView];
    
    //tableview
    CGFloat tableViewX = 0;
    CGFloat tableViewY = 64;
    CGFloat tableViewW = self.view.bounds.size.width;
    CGFloat tableViewH = self.view.bounds.size.height-tableViewY;
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource =  self;
    myTableView .rowHeight =  80;
    myTableView.sectionIndexColor = [UIColor blackColor];
    [self.view addSubview:myTableView];
    
    
    
}

#pragma mark btnClick===================

-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化数据源
    _dataSource = [[NSMutableArray alloc] initWithObjects:@"nihao",@"sdfsd",@"sdfsdf", nil];
    
    //创建表格视图
    [self CreatTopView];
    
    //
    [self loadSortData];
    
    //背景颜色
    self.view.backgroundColor =[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
}
- (void)loadSortData
{
    //初始化数组
    provinces = [[NSMutableArray alloc] init];
    //干嘛用的？
    NSMutableArray *contentData = [[NSMutableArray alloc] init];
    //从plist文件里面获取数组
    NSArray * tmpArr = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"]];
    
    //这个类包含有m_province和m_province属性，是一个描述位置的类
    GIFTArea *area = nil;
    for (int i=0;i < tmpArr.count;i++)
    {
        area = [[GIFTArea alloc] init];
        area.m_province = [tmpArr[i] objectForKey:@"state"];
        area.m_areaList = [tmpArr[i] objectForKey:@"cities"];
        
        //数组装有GIFTArea模型
        [contentData addObject:area];
    }
    
    //这是个什么类？？
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    
    //遍历数组contentData
    for (GIFTArea *area in contentData)
    {
        //记录下每个模型属于哪一组
        area.m_section = [theCollation sectionForObject:area collationStringSelector:@selector(m_province)];
    }
    
    //创建一个装有所有Section数组的数组，为什么会是27呢？不是26个字母吗？
    NSInteger highSection = [[theCollation sectionTitles] count];
    
    //设置一个26个元素的数组
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection-1];

    
    //初始化所有的26个section数组
    for (int i=0; i<highSection-1; i++)
    {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    //将相应的模型放到相应的数组
    for (GIFTArea *area in contentData)
    {
        [(NSMutableArray *)[sectionArrays objectAtIndex:area.m_section] addObject:area];
    }
    
    //对每个section数组内部元素进行排序
    for (NSMutableArray *sectionArray in sectionArrays)
    {
        
        //得到排序后的数组
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(m_province)];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:sortedSection];
        [provinces addObject:tempArray];
    }
}

#pragma mark tabelViewDelegate methods

//行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return provinces.count;
}

//每一行的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[provinces objectAtIndex:section] count];
}

//每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

//取出对应section的标题，如果没有元素则不显示
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[provinces objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;

}

//每一行标题的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [[provinces objectAtIndex:section] count] ? tableView.sectionHeaderHeight : 0;
}

//将要展示的HeaderView的回调
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    //颜色
    view.tintColor = COLOR(201, 202, 202, 1);
    
    // 字体颜色
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
}

//
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出组别和行号
    int se = indexPath.section;
    int ro = indexPath.row;
    
    //取出cell
    static NSString *cellIndentify = @"arelistCell";
    UITableViewCell *areaListCell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if (nil == areaListCell)
    {
        areaListCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify] ;
        areaListCell.backgroundColor = [UIColor whiteColor];
        areaListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //取出对应的模型
    GIFTArea *area = (GIFTArea*)[[provinces objectAtIndex:se] objectAtIndex:ro];
    
    //显示省份
    areaListCell.textLabel.text = area.m_province;
    //***config cell***
    return areaListCell;
}

//选择省份,哥，你也恁坏了，害我搞了一个下午
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    //取出对应的模型
    GIFTArea *areaInfo = (GIFTArea *)[[provinces objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    suoZaiViewController *cityVC = [[suoZaiViewController alloc]init];
    cityVC.requestTag = self.requestTag;
    cityVC.myCities = areaInfo.m_areaList;
    cityVC.m_province = areaInfo.m_province;
    //cityVC. = areaInfo.m_province;
    //cityVC.operType = self.operType;
    [self.navigationController pushViewController:cityVC animated:YES];
}
//索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    NSArray *titles = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
    
    //返回一个没有＃的数组
   return [self tempArrayWithArray:titles];;
    
}

//返回一个没有＃的数组
-(NSMutableArray *)tempArrayWithArray:(NSArray *)titles{
    int titlesCount = titles.count;
    NSMutableArray *tempTitles = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < titles.count; i++) {
        if (i != titlesCount-1) {
            NSString *title = titles[i];
            [tempTitles addObject:title];
        }
    }
    return tempTitles;
}

//返回用户点击到的第几个索引
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
