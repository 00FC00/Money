//
//  QRCodeDetialsViewController.m
//  LifeTogether
//
//  Created by fengshaohui on 14-3-25.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "QRCodeDetialsViewController.h"
#import "PublicObject.h"
//#import "CustomTabBarViewController.h"

@interface QRCodeDetialsViewController ()

@end

@implementation QRCodeDetialsViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"二维码详细信息";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    
    if ([_detialsType isEqualToString:@"web"]) {
        UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
        //Web.backgroundColor=[UIColor whiteColor];
        webView.scalesPageToFit=YES;
        webView.delegate=self;
        //. NSString
        // 控制页面是否可以滑动
        //self.Web.scrollView.scrollEnabled=NO;
        [self.view addSubview:webView];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_detialsUrls]]];
    }else
    {
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 80, 280, 320)];
        textView.font = [UIFont systemFontOfSize:16];
        textView.textAlignment = NSTextAlignmentLeft;
        textView.textColor = [UIColor blackColor];
        textView.editable = NO;
        textView.text = _detialsUrls;
        [self.view addSubview:textView];
    }
    
    

}
- (void)backButtonClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
