//
//  AdvertisementDetialsViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-7-31.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "AdvertisementDetialsViewController.h"
#import "SUNViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
@interface AdvertisementDetialsViewController ()

@end

@implementation AdvertisementDetialsViewController

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
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"广告详情";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickbackButton) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;

    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, IS_IOS_7?self.view.frame.size.height-64:self.view.frame.size.height-44)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dic[@"link"]]]]];
    [self.view addSubview:webView];
    
    
}
- (void)clickbackButton
{
//    SUNViewController *drawerController = (SUNViewController *)self.navigationController.mm_drawerController;
//    
//    if (drawerController.openSide == MMDrawerSideNone) {
//        [drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
//            
//        }];
//    }else if  (drawerController.openSide == MMDrawerSideLeft) {
//        [drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
//            
//        }];
//    }
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];

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
