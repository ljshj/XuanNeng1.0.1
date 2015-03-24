//
//  UserCardViewController.m
//  BGProject
//
//  Created by zhuozhongkeji on 14-9-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "UserCardViewController.h"
#import "FDSUserManager.h"

#import "Navgation.h"
@interface UserCardViewController ()

@end

@implementation UserCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isSelf = false;
        
    }
    return self;
}
-(void)initViews
{
    NSString *systemUserID = [[FDSUserManager sharedManager] getNowUser].m_userID;
    if(self.m_userID != nil && [self.m_userID isEqualToString:systemUserID])
    {
        isSelf = true;
    }
   // self.navigationController.title = @"名片";
    Navgation *nav = [[Navgation alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    [nav initView:@"名片"];
    nav.m_delete = self;
    [self.view addSubview:nav];
    
    // bg
    UIImageView * topBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 100)];
    [topBgImageView setImage:[UIImage imageNamed:@""]];
    [self.view addSubview:topBgImageView];
    
    
}
- (void)viewDidLoad
{
   // [self.navigationController ]
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    [self initViews];
    // Do any additional setup after loading the view.
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
