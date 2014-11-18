//
//  TownsmanViewController.m
//  FaceBook
//
//  Created by HMN on 14-4-29.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "TownsmanViewController.h"
#import "TownViewController.h"
#import "SchoolViewController.h"
#import "AppDelegate.h"

#import "SUNViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

#import "SettingViewController.h"
@interface TownsmanViewController ()
@property(strong,nonatomic)TownViewController* townViewController;
@property(strong,nonatomic)SchoolViewController* schoolViewController;

@property(nonatomic,strong)UIButton* townButton;
@property(nonatomic,strong)UIButton* schoolButton;
@end

@implementation TownsmanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"同乡校友";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 22, 40, 40);
    [menuButton setBackgroundImage:[UIImage imageNamed:@"caidan@2x"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //登录
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(526/2, 22, 80/2, 80/2);
    [setButton setBackgroundImage:[UIImage imageNamed:@"shezhianniu@2x"] forState:UIControlStateNormal];
    //[setButton setTitle:@"登录" forState:UIControlStateNormal];
    //setButton.titleLabel.font = [UIFont systemFontOfSize:15];
    //[setButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(setButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:setButton];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;

    //按钮背景
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 72/2)];
    topImageView.backgroundColor = [UIColor clearColor];
    [topImageView setImage:[UIImage imageNamed:@"tongxianghaoyoubeijing@2x"]];
    topImageView.userInteractionEnabled = YES;
    [self.view addSubview:topImageView];
    
    //设置同乡button
    self.townButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 150, 26)];
    self.townButton.layer.cornerRadius=2.0f;
    [self.townButton setTitleColor:[UIColor colorWithRed:167/255.0 green:196/255.0 blue:240/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.townButton setBackgroundColor:[UIColor clearColor]];
    [self.townButton setBackgroundImage:[UIImage imageNamed:@"zuoanniu@2x"] forState:UIControlStateNormal];
    [self.townButton setTitle:@"同乡" forState:UIControlStateNormal];
    [self.townButton addTarget:self action:@selector(townPage) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:self.townButton];
    
    //设置同校button
    self.schoolButton=[[UIButton alloc]initWithFrame:CGRectMake(160, 5, 150, 26)];
    self.schoolButton.layer.cornerRadius=2.0f;
    [self.schoolButton setTitleColor:[UIColor colorWithRed:167/255.0 green:196/255.0 blue:240/255.0 alpha:1.0] forState:
     UIControlStateNormal];
    [self.schoolButton setBackgroundColor:[UIColor clearColor]];
    [self.schoolButton setTitle:@"校友" forState:UIControlStateNormal];
    [self.schoolButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.schoolButton addTarget:self action:@selector(schoolpage) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:self.schoolButton];
    
   //默认页面
    self.townViewController=[[TownViewController alloc]init];
    self.townViewController.view.frame=CGRectMake(0, 36, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-36-64);
    [self addChildViewController:self.townViewController];
    [self.view addSubview:self.townViewController.view];
    self.townViewController.view.hidden = NO;


    
    
}
#pragma mark - 菜单
- (void)menuButtonClicked
{
    SUNViewController *drawerController = (SUNViewController *)self.navigationController.mm_drawerController;
    
    if (drawerController.openSide == MMDrawerSideNone) {
        [drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            
        }];
    }else if  (drawerController.openSide == MMDrawerSideLeft) {
        [drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            
        }];
    }
}
#pragma mark - 设置
- (void)setButtonClicked
{
    SettingViewController *settingVC = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

-(void)townPage{
   
    self.title=@"同乡好友";
    [self.townButton setBackgroundImage:[UIImage imageNamed:@"zuoanniu@2x"] forState:UIControlStateNormal];
    [self.schoolButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
   
    if (self.townViewController) {
        self.townViewController.view.hidden=NO;
        self.schoolViewController.view.hidden=YES;
    }
    
    ///发通知刷新页面
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showtown" object:nil];
    
}

-(void)schoolpage{
    if (!self.schoolViewController) {
        
    }
    
    self.title=@"同校好友";
    [self.townButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.schoolButton setBackgroundImage:[UIImage imageNamed:@"youanniu@2x"] forState:UIControlStateNormal];
    if (self.schoolViewController) {
        self.townViewController.view.hidden=YES;
        self.schoolViewController.view.hidden=NO;
    }else
    {
        self.schoolViewController=[[SchoolViewController alloc]init];
        self.schoolViewController.view.frame=CGRectMake(0, 36, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-100);
        [self addChildViewController:self.schoolViewController];
        [self.view addSubview:self.schoolViewController.view];
    }
    ///发通知刷新页面
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showschool" object:nil];
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
