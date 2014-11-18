//
//  LoginViewController.m
//  FaceBook
//
//  Created by HMN on 14-4-25.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

#import "registerViewController.h"
#import "ForgetPasswordViewController.h"
#import "DMCAlertCenter.h"
#import "BCHTTPRequest.h"
#import "BCBaseObject.h"
#import "LLRequest.h"

#import "SUNViewController.h"

#import "SUNLeftMenuViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"

@interface LoginViewController ()
{
    UITextField *userNameTextField;//用户名
    UITextField *passwordTextField;//密码
    DDMenuController * rootController;
    
    SUNViewController * drawerController;
}

@end

@implementation LoginViewController

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
    self.title = @"登录";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //注册
    UIButton *registrationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registrationButton.frame = CGRectMake(526/2, 20+(44-42/2)/2, 84/2, 42/2);
    [registrationButton setBackgroundImage:[UIImage imageNamed:@"login_RegistrationButton_03@2x"] forState:UIControlStateNormal];
    [registrationButton setTitle:@"注册" forState:UIControlStateNormal];
    registrationButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [registrationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registrationButton addTarget:self action:@selector(registrationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:registrationButton];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:registrationButton];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;

    
    //用户名
    UIImageView *userNameImageView = [[UIImageView alloc] initWithFrame:CGRectMake((320-582/2)/2, 40/2, 582/2, 74/2)];
    [userNameImageView setImage:[UIImage imageNamed:@"login_passwordBackground_11@2x"]];
    userNameImageView.userInteractionEnabled = YES;
    [self.view addSubview:userNameImageView];
    
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(14/2, 0, 114/2, 74/2)];
    userNameLabel.text = @"用户名";
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    [userNameImageView addSubview:userNameLabel];
    
    userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(164/2, 0, 390/2, 74/2)];
    userNameTextField.placeholder = @"请输入手机号";
    userNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userNameTextField.font = [UIFont systemFontOfSize:15];
    userNameTextField.keyboardType = UIKeyboardTypeDecimalPad;
    userNameTextField.delegate = self;
    [userNameImageView addSubview:userNameTextField];
    
    //密码
    UIImageView *passWordImageView = [[UIImageView alloc] initWithFrame:CGRectMake((320-582/2)/2, 40+74/2, 582/2, 74/2)];
    [passWordImageView setImage:[UIImage imageNamed:@"login_passwordBackground_11@2x"]];
    passWordImageView.userInteractionEnabled = YES;
    [self.view addSubview:passWordImageView];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(14/2, 0, 114/2, 74/2)];
    passwordLabel.text = @"密码";
    passwordLabel.backgroundColor = [UIColor clearColor];
    passwordLabel.textAlignment = NSTextAlignmentCenter;
    [passWordImageView addSubview:passwordLabel];
    
    passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(164/2, 0, 390/2, 74/2)];
    passwordTextField.placeholder = @"请输入密码";
    [passwordTextField setSecureTextEntry:YES];
    passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTextField.font = [UIFont systemFontOfSize:15];
    passwordTextField.delegate = self;
    [passWordImageView addSubview:passwordTextField];
    
    //忘记密码
    UIButton *forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPasswordButton.frame = CGRectMake(470/2, 240/2, 140/2, 44/2);
    [forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetPasswordButton setTitleColor:[UIColor colorWithRed:181/255.0 green:199/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
    [forgetPasswordButton addTarget:self action:@selector(forgetPasswordButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPasswordButton];
    
    //登录
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake((320-583.0/2)/2, 334/2, 583.0/2, 75.0/2);
    [loginButton setBackgroundImage:[UIImage imageNamed:@"forgetPassword_finishButtonBackground_03@2x"] forState:UIControlStateNormal];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(clickLoginButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
}

#pragma mark - 登录
- (void)clickLoginButton
{
    if (userNameTextField.text == nil || [userNameTextField.text isEqualToString:@""]) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入手机号"];
    }else if ([BCBaseObject isMobileNumber:userNameTextField.text] == NO) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入正确的手机号"];
    }else if ([BCBaseObject checkInputPassword:passwordTextField.text] == NO)
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入密码6-16位"];
    }else {
        [BCHTTPRequest loginTheFaceBookWithPhone:userNameTextField.text WithPassWord:passwordTextField.text UsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess) {
                [[LLRequest sharedLLRequest] connect];
                if (drawerController) {
                    NSLog(@"feng.sh");
                    [self presentViewController:drawerController animated:NO completion:^{
                        ;
                    }];
                }else
                {
                 NSLog(@"冯绍辉");
                    
                    
                    SUNLeftMenuViewController *leftVC = [[SUNLeftMenuViewController alloc] init];
                    drawerController = [[SUNViewController alloc]
                                         initWithCenterViewController:leftVC.navSlideSwitchVC
                                         leftDrawerViewController:leftVC
                                         rightDrawerViewController:nil];
                    [drawerController setMaximumLeftDrawerWidth:280.0f];
                    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
                    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
                    [drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
                        MMDrawerControllerDrawerVisualStateBlock block;
                        block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
                        block(drawerController, drawerSide, percentVisible);
                    }];

                        [self presentViewController:drawerController animated:NO completion:^{
                            ;
                        }];
                    
                
                //[self performSelector:@selector(doit) withObject:nil afterDelay:0.1];
                    
              
                }
                
                
               
            }
        }];
    }
}
- (void)doit
{
    [self presentViewController:drawerController animated:NO completion:^{
        ;
    }];
}
#pragma mark - 注册
-(void)registrationButtonClicked
{
    if ([_fromString isEqualToString:@"注册"]) {
        [self dismissViewControllerAnimated:YES completion:^{
            ;
        }];
    }else
    {
        registerViewController *registerVC = [[registerViewController alloc] init];
        registerVC.fromString = @"登录";
        UINavigationController *registerNav = [[UINavigationController alloc] initWithRootViewController:registerVC];
        [self presentViewController:registerNav animated:YES completion:^{
            ;
        }];
    }
    
}
#pragma mark - 忘记密码
-(void)forgetPasswordButtonClicked
{
    ForgetPasswordViewController *forgetPasswordVC = [[ForgetPasswordViewController alloc] init];
    UINavigationController *forgetPasswordNav = [[UINavigationController alloc] initWithRootViewController:forgetPasswordVC];
    [self presentViewController:forgetPasswordNav animated:YES completion:^{
        ;
    }];
}
#pragma mark - 返回
-(void)backButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}
#pragma mark - 键盘隐藏
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [userNameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
