//
//  ViewController.m
//  FaceBook
//
//  Created by HMN on 14-4-25.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "ViewController.h"
#import "LoginAndRegisterViewController.h"
#import "BCHTTPRequest.h"

#import "AppDelegate.h"
#import "FaceBookMainHomePageViewController.h"
#import "UIImageView+AFNetworking.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
  
    
    [BCHTTPRequest getTheLoadingImagesWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        
        if (isSuccess == YES) {
            //启动页
            UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            NSString *mUrl = [[NSString alloc] init];
            if ([[UIScreen mainScreen] bounds].size.height > 481) {
                mUrl = resultDic[@"type_two"];
            }else
            {
                mUrl = resultDic[@"type_one"];
            }
            
            
            [bgImageView setImageWithURL:[NSURL URLWithString:mUrl] placeholderImage:[UIImage imageNamed:@""]];
            [self.view addSubview:bgImageView];
            
            
        }
    }];

    
    [self performSelector:@selector(clickFBMainViews) withObject:nil afterDelay:3];

    
//    //判断是否登录
//    if ([BCHTTPRequest isLogin] == YES) {
//        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"]);
//        //[[LLRequest sharedLLRequest] connect];
//        DDMenuController * rootController = ((AppDelegate*)[UIApplication sharedApplication].delegate).menuController;
//        [self presentViewController:rootController animated:NO completion:^{
//            ;
//        }];
//    }else
//    {
//        LoginAndRegisterViewController *loginAndRegisterViewController = [[LoginAndRegisterViewController alloc] init];
//        [self presentViewController:loginAndRegisterViewController animated:NO completion:^{
//            ;
//        }];    }

}

- (void)clickFBMainViews
{
    //进入广告页面
    FaceBookMainHomePageViewController *faceBookMainHomePageVC = [[FaceBookMainHomePageViewController alloc] init];
    [self presentViewController:faceBookMainHomePageVC animated:NO completion:^{
        ;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
