//
//  addPhotoViewController.m
//  BGProject
//
//  Created by zhuozhong on 14-7-23.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "addPhotoViewController.h"

@interface addPhotoViewController ()

@end

@implementation addPhotoViewController
{
    UIView   *topView;
    UIButton *backBtn;
    UICollectionView *myCollectionView;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)CreatView
{
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部通用背景"]];
    
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 24, 50, 40)];
    [backBtn setImage:[UIImage imageNamed:@"返回_02"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮点中效果_02"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(BackMainMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 24, 80, 40)];
    label1.text = @"相机胶卷";
    label1.textColor = TITLECOLOR;
    label1.font = TITLEFONT;
    
    [topView addSubview:backBtn];
    [topView addSubview:label1];
    [self.view addSubview:topView];
    
    
    UICollectionViewFlowLayout  *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, topView.frame.origin.y+topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:flowLayout];
}
#pragma mark btnClick:--------------
-(void)BackMainMenu:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self  CreatView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
