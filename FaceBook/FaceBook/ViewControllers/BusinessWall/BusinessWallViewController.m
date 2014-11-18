//
//  BusinessWallViewController.m
//  FaceBook
//
//  Created by HMN on 14-4-29.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "BusinessWallViewController.h"
#import "AppDelegate.h"

#import "SettingViewController.h"
#import "PublicWallViewController.h"
#import "MyWallViewController.h"
#import "SendWallContectViewController.h"

#import "SUNViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface BusinessWallViewController ()
{
    //公共墙
    UIButton *publicWallButton;
    //我的墙
    UIButton *myWallButton;
    
    PublicWallViewController *publicWallMainVC;
    MyWallViewController *myWallMainVC;
}
@end

@implementation BusinessWallViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:249.0f/255.0f blue:251.0f/255.0f alpha:1.0];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    
    self.title = @"部落墙";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 22, 40, 40);
    [menuButton setBackgroundImage:[UIImage imageNamed:@"caidan@2x"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //设置
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(526/2, 22, 80/2, 80/2);
    [setButton setBackgroundImage:[UIImage imageNamed:@"shezhianniu@2x"] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(setButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:setButton];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;

    
    //底部按钮背景
    UIImageView *bottomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, IS_IOS_7?self.view.frame.size.height-64-98/2:self.view.frame.size.height-44-98/2, self.view.frame.size.width, 98/2)];
    bottomImageView.backgroundColor = [UIColor clearColor];
    [bottomImageView setImage:[UIImage imageNamed:@"yewuqiangbeijing@2x"]];
    bottomImageView.userInteractionEnabled = YES;
    [self.view bringSubviewToFront:bottomImageView];
    [self.view addSubview:bottomImageView];
    
    //公共墙
    publicWallButton = [UIButton buttonWithType:UIButtonTypeCustom];
    publicWallButton.frame =CGRectMake(34, 20/2, 132/2, 62/2);
    publicWallButton.backgroundColor = [UIColor clearColor];
    [publicWallButton setBackgroundImage:[UIImage imageNamed:@"gonggongqiang2@2x"] forState:UIControlStateNormal];
    [publicWallButton addTarget:self action:@selector(clickPublicButton) forControlEvents:UIControlEventTouchUpInside];
    [bottomImageView addSubview:publicWallButton];
    
    //我的墙
    myWallButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myWallButton.frame =CGRectMake(438/2, 20/2, 132/2, 62/2);
    myWallButton.backgroundColor = [UIColor clearColor];
    [myWallButton setBackgroundImage:[UIImage imageNamed:@"wodeqiang1@2x"] forState:UIControlStateNormal];
    [myWallButton addTarget:self action:@selector(clickMyWallButton) forControlEvents:UIControlEventTouchUpInside];
    [bottomImageView addSubview:myWallButton];
    
    //编辑按钮
    UIButton * videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [videoButton setImage:[UIImage imageNamed:@"bianjifasong@2x"] forState:UIControlStateNormal];
    [videoButton setFrame:CGRectMake(254/2, -35/2, 132.0/2, 132.0/2)];
   
    [videoButton addTarget:self action:@selector(videoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [bottomImageView addSubview:videoButton];

    
    //默认页面
    publicWallMainVC=[[PublicWallViewController alloc]init];
    publicWallMainVC.view.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-64);
    [self addChildViewController:publicWallMainVC];
    [self.view addSubview:publicWallMainVC.view];
    [self.view sendSubviewToBack:publicWallMainVC.view];
    publicWallMainVC.view.hidden = NO;
   
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

    //    //发送通知
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"showMenu" object:nil];
}
#pragma mark - 设置
- (void)setButtonClicked
{
    SettingViewController *settingVC = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - 编辑按钮
- (void)videoButtonClicked
{
    SendWallContectViewController *sendWallContectVC = [[SendWallContectViewController alloc]init];
    //UINavigationController * sendWallContectNV = [[UINavigationController alloc]initWithRootViewController:sendWallContectVC];
    [self.navigationController pushViewController:sendWallContectVC animated:YES];
//    [self presentViewController:sendWallContectNV animated:YES completion:^{
//        ;
//    }];
}
#pragma mark - 公共墙
- (void)clickPublicButton
{
    self.title = @"公共墙";
    [publicWallButton setBackgroundImage:[UIImage imageNamed:@"gonggongqiang2@2x"] forState:UIControlStateNormal];
    [myWallButton setBackgroundImage:[UIImage imageNamed:@"wodeqiang1@2x"] forState:UIControlStateNormal];
    
    if (publicWallMainVC) {
        publicWallMainVC.view.hidden=NO;
        myWallMainVC.view.hidden=YES;
    }

}
#pragma mark - 我的墙
- (void)clickMyWallButton
{
    self.title = @"我的墙";
    [publicWallButton setBackgroundImage:[UIImage imageNamed:@"gonggong1@2x"] forState:UIControlStateNormal];
    [myWallButton setBackgroundImage:[UIImage imageNamed:@"wodeqiang2@2x"] forState:UIControlStateNormal];
    
    if (myWallMainVC) {
        publicWallMainVC.view.hidden=YES;
        myWallMainVC.view.hidden=NO;
    }else
    {
        myWallMainVC=[[MyWallViewController alloc]init];
        myWallMainVC.view.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-64);
        [self addChildViewController:myWallMainVC];
        [self.view addSubview:myWallMainVC.view];
        [self.view sendSubviewToBack:myWallMainVC.view];
        publicWallMainVC.view.hidden=YES;
        myWallMainVC.view.hidden=NO;
    }

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
