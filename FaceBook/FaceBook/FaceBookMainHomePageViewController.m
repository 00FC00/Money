//
//  FaceBookMainHomePageViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-6-3.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "FaceBookMainHomePageViewController.h"
#import "LoginAndRegisterViewController.h"
#import "BCHTTPRequest.h"
#import "AppDelegate.h"

#import "AFNetworking.h"

#import "LLRequest.h"

#import "SUNViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
@interface FaceBookMainHomePageViewController ()

@end

@implementation FaceBookMainHomePageViewController

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
   
}
- (void)viewDidAppear:(BOOL)animated
{

    [self clickMainViews];
    
    
}
- (void)clickMainViews
{
    
    
    //判断是否登录
    if ([BCHTTPRequest isLogin] == YES) {
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"]);
        //[[LLRequest sharedLLRequest] connect];
      SUNViewController *drawerController = ((AppDelegate*)[UIApplication sharedApplication].delegate).drawerController;
        
        [self presentViewController:drawerController animated:YES completion:^{
            ;
        }];
        [[LLRequest sharedLLRequest] connect];
    }else
    {
        LoginAndRegisterViewController *loginAndRegisterViewController = [[LoginAndRegisterViewController alloc] init];
        [self presentViewController:loginAndRegisterViewController animated:NO completion:^{
            ;
        }];   
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
