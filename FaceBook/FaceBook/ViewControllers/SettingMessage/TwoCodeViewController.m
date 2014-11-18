//
//  TwoCodeViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-11.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "TwoCodeViewController.h"
#import "QRCodeGenerator.h"
#import "BCHTTPRequest.h"

@interface TwoCodeViewController ()

@end

@implementation TwoCodeViewController

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
    self.title = @"我的二维码";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;

    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100/2, 91, 220, 220)];
    backImageView.backgroundColor = [UIColor clearColor];
    [backImageView setImage:[UIImage imageNamed:@"twoCode@2x"]];
    backImageView.userInteractionEnabled = YES;
    [self.view addSubview:backImageView];
    
    //二维码
    qrcodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 436/2, 436/2)];
    qrcodeImageView.backgroundColor = [UIColor whiteColor];
    [backImageView addSubview:qrcodeImageView];
    //本人学识渊博，经验丰富，代码风骚，效率恐怖。
    NSString *codeString= [NSString stringWithFormat:@"lp_sn%@",[BCHTTPRequest getUserLPNumber]];
    [self creatQRCode:codeString];
}
- (void)creatQRCode:(NSString*)qrcodeStr
{
    qrcodeImageView.image = [QRCodeGenerator qrImageForString:qrcodeStr imageSize:qrcodeImageView.bounds.size.width];
}
#pragma mark - 返回
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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
