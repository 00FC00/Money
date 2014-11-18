//
//  UseTermsViewController.m
//  FaceBook
//
//  Created by 虞海云 on 14-5-6.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "UseTermsViewController.h"

@interface UseTermsViewController ()

@end

@implementation UseTermsViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"使用条款";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //网页显示条款
    NSString *u_Url =[NSString stringWithFormat:@"%@index.php?r=default/start/user_clause",kMainUrlString];
    webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width,IS_IOS_7?self.view.frame.size.height-64:self.view.frame.size.height-44)];
   // webView.backgroundColor = [UIColor clearColor];
    webView.scalesPageToFit=YES;
    webView.delegate=self;
   // [webView.layer setMasksToBounds:YES];
   // [webView.layer setCornerRadius:8.0f];
    //. NSString
    // 控制页面是否可以滑动
    //self.Web.scrollView.scrollEnabled=NO;
    [ self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:u_Url]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 返回
-(void)backButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

@end
