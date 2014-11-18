//
//  LoginAndRegisterViewController.m
//  FaceBook
//
//  Created by HMN on 14-4-25.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "LoginAndRegisterViewController.h"
#import "LoginViewController.h"
#import "registerViewController.h"

#import "ProjectExperienceViewController.h"
#import "ProfessionExperienceViewController.h"
#import "EducationExperienceViewController.h"

@interface LoginAndRegisterViewController ()

@end

@implementation LoginAndRegisterViewController

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
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, 1136/2)];
    [backgroundImageView setImage:[UIImage imageNamed:@"firstPageBackgroundImage@2x"]];
    backgroundImageView.userInteractionEnabled = YES;
    [self.view addSubview:backgroundImageView];
    
    //注册
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    registerButton.frame = CGRectMake(74/2, self.view.frame.size.height-120, 198/2, 72/2);
//    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"firstPage_registerButton_03@2x"] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImageView addSubview:registerButton];
    
    
    //登录
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake(390/2, registerButton.frame.origin.y, 198/2, 72/2);
//    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"firstPage_loginButton_05@2x"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(clickLoginButton) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImageView addSubview:loginButton];
}

#pragma mark - 登录
- (void)clickLoginButton
{
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:loginNav animated:YES completion:^{
        ;
    }];
    
//    //项目经历
//    ProjectExperienceViewController *projectExperienceVC = [[ProjectExperienceViewController alloc] init];
//    UINavigationController *projectExperienceNav = [[UINavigationController alloc] initWithRootViewController:projectExperienceVC];
//    [self presentViewController:projectExperienceNav animated:YES completion:^{
//        ;
//    }];
    
//    //职业经历
//    ProfessionExperienceViewController *professionExperienceVC = [[ProfessionExperienceViewController alloc] init];
//    UINavigationController *professionExperienceNav = [[UINavigationController alloc] initWithRootViewController:professionExperienceVC];
//    [self presentViewController:professionExperienceNav animated:YES completion:^{
//        ;
//    }];
    
//    //教育经历
//    EducationExperienceViewController *educationExperienceVC = [[EducationExperienceViewController alloc] init];
//    UINavigationController *educationExperienceNav = [[UINavigationController alloc] initWithRootViewController:educationExperienceVC];
//    [self presentViewController:educationExperienceNav animated:YES completion:^{
//        ;
//    }];

}
#pragma mark - 注册
-(void)registerButtonClicked
{
    registerViewController *registerVC = [[registerViewController alloc] init];
    UINavigationController *registerNav = [[UINavigationController alloc] initWithRootViewController:registerVC];
    [self presentViewController:registerNav animated:YES completion:^{
        ;
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
