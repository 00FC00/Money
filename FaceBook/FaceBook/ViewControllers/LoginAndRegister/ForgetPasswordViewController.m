//
//  ForgetPasswordViewController.m
//  FaceBook
//
//  Created by 虞海云 on 14-5-4.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "ForgetPasswordViewController.h"

#import "AppDelegate.h"
#import "DMCAlertCenter.h"
#import "BCBaseObject.h"
#import "BCHTTPRequest.h"
@interface ForgetPasswordViewController ()
{
    UITextField *phoneNumTextField;     //手机号
    UITextField *securityCodeTextField; //验证码
    UITextField *newPasswordTextField;  //新密码
    UITextField *newPasswordAgainTextField;//再次输入新密码
    UIButton *sendSecurityCodeButton;   //发送验证码按钮
    int secondsCountDown;               //倒计时
    NSTimer *countDownTimer;            //倒计时定时器
}

@end

@implementation ForgetPasswordViewController

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
    self.title = @"忘记密码";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
   // [self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    
    //手机号
    UIImageView *phoneNumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30/2, 48/2, 422/2, 74/2)];
    [phoneNumImageView setImage:[UIImage imageNamed:@"forgetPassword_textFieldBackground_03@2x"]];
    phoneNumImageView.userInteractionEnabled = YES;
    [self.view addSubview:phoneNumImageView];
    
    phoneNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(30/2, 0, 370/2, 74/2)];
    phoneNumTextField.placeholder = @"请输入手机号";
    phoneNumTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneNumTextField.font = [UIFont systemFontOfSize:14];
    phoneNumTextField.keyboardType = UIKeyboardTypeDecimalPad;
    phoneNumTextField.delegate = self;
    [phoneNumImageView addSubview:phoneNumTextField];
    //发送验证码
    sendSecurityCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendSecurityCodeButton.frame = CGRectMake(466/2, 48/2, 154/2, 74/2);
    [sendSecurityCodeButton setBackgroundImage:[UIImage imageNamed:@"forgetPassword_sendSecurityCodeButtonBackground_03@2x"] forState:UIControlStateNormal];
    [sendSecurityCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [sendSecurityCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendSecurityCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [sendSecurityCodeButton addTarget:self action:@selector(sendSecurityCodeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendSecurityCodeButton];
    
    //验证码
    UIImageView *securityCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30/2, phoneNumImageView.frame.origin.y+phoneNumImageView.frame.size.height+40/2, 582/2, 74/2)];
    [securityCodeImageView setImage:[UIImage imageNamed:@"forgetPassword_textFieldBackground_03@2x"]];
    securityCodeImageView.userInteractionEnabled = YES;
    [self.view addSubview:securityCodeImageView];
    
    securityCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(30/2, 0, 526/2, 74/2)];
    securityCodeTextField.placeholder = @"请输入验证码";
    securityCodeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    securityCodeTextField.font = [UIFont systemFontOfSize:14];
    securityCodeTextField.keyboardType = UIKeyboardTypeDecimalPad;
    securityCodeTextField.delegate = self;
    [securityCodeImageView addSubview:securityCodeTextField];
    
    //登录密码
    UIImageView *newPasswordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30/2, securityCodeImageView.frame.origin.y+securityCodeImageView.frame.size.height+40/2, 582/2, 74/2)];
    [newPasswordImageView setImage:[UIImage imageNamed:@"forgetPassword_textFieldBackground_03@2x"]];
    newPasswordImageView.userInteractionEnabled = YES;
    [self.view addSubview:newPasswordImageView];
    
    newPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(30/2, 0, 526/2, 74/2)];
    newPasswordTextField.placeholder = @"请输入您新的登录密码";
    [newPasswordTextField setSecureTextEntry:YES];
    newPasswordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    newPasswordTextField.font = [UIFont systemFontOfSize:14];
    newPasswordTextField.delegate = self;
    [newPasswordImageView addSubview:newPasswordTextField];
    
    //再次输入登录密码
    UIImageView *newPasswordAgainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30/2, newPasswordImageView.frame.origin.y+newPasswordImageView.frame.size.height+40/2, 582/2, 74/2)];
    [newPasswordAgainImageView setImage:[UIImage imageNamed:@"forgetPassword_textFieldBackground_03@2x"]];
    newPasswordAgainImageView.userInteractionEnabled = YES;
    [self.view addSubview:newPasswordAgainImageView];
    
    newPasswordAgainTextField = [[UITextField alloc] initWithFrame:CGRectMake(30/2, 0, 526/2, 74/2)];
    newPasswordAgainTextField.placeholder = @"请再次输入您新的登录密码";
    [newPasswordAgainTextField setSecureTextEntry:YES];
    newPasswordAgainTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    newPasswordAgainTextField.font = [UIFont systemFontOfSize:14];
    newPasswordAgainTextField.delegate = self;
    [newPasswordAgainImageView addSubview:newPasswordAgainTextField];

    //完成按钮
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(30/2, newPasswordAgainImageView.frame.origin.y+newPasswordAgainImageView.frame.size.height+40/2, 583.0/2, 75.0/2);
    [finishButton setBackgroundImage:[UIImage imageNamed:@"forgetPassword_finishButtonBackground_03@2x"] forState:UIControlStateNormal];
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(finishButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 发送验证码
-(void)sendSecurityCodeButtonClicked:(UIButton *)sender
{
    if (phoneNumTextField.text == nil || [phoneNumTextField.text isEqualToString:@""]) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入手机号"];
    }else if ([BCBaseObject isMobileNumber:phoneNumTextField.text] == NO) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入正确的手机号"];
    }else{
        secondsCountDown = 30;//60秒倒计时
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        sender.enabled = NO;
        [BCHTTPRequest GetTheRegisterCodeWithType:2 WithPhone:phoneNumTextField.text UsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess) {
                NSLog(@"code=%@",[resultDic objectForKey:@"code"]);
            }
        }];
    }
}

-(void)timeFireMethod{
    secondsCountDown--;
    sendSecurityCodeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [sendSecurityCodeButton setTitle:[NSString stringWithFormat:@"%d秒",secondsCountDown] forState:UIControlStateDisabled];
    if(secondsCountDown==0){
        [countDownTimer invalidate];
        sendSecurityCodeButton.enabled = YES;
        sendSecurityCodeButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [sendSecurityCodeButton setTitle:@"再次发送" forState:UIControlStateNormal];
    }
}

#pragma mark - 完成
-(void)finishButtonClicked
{
    NSLog(@"passwordTextField.text==%@%@",phoneNumTextField.text,securityCodeTextField.text);
    if ([BCBaseObject isMobileNumber:phoneNumTextField.text] == NO) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入正确的手机号"];
    }else if (securityCodeTextField.text == nil || [securityCodeTextField.text isEqualToString:@""])
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入验证码"];
    }else if ([BCBaseObject checkInputPassword:newPasswordTextField.text]==NO)
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入6-16位密码"];
    }else if (newPasswordAgainTextField.text == nil || [newPasswordAgainTextField.text isEqualToString:@""])
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入确认密码"];
    }else if(![newPasswordTextField.text isEqualToString:newPasswordAgainTextField.text]){
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入相同的密码"];
    }
    else {
        [BCHTTPRequest findMyPassWordWithPhone:phoneNumTextField.text WithCode:securityCodeTextField.text WithNewPassWord:newPasswordTextField.text UsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess) {
//                DDMenuController * rootController = ((AppDelegate*)[UIApplication sharedApplication].delegate).menuController;
//                [self presentViewController:rootController animated:NO completion:^{
//                    ;
//                }];
                [self dismissViewControllerAnimated:YES completion:^{
                    ;
                }];
            }
        }];
    }
    
}
#pragma mark - 返回
-(void)backButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.view.frame = CGRectMake(0,IS_IOS_7?64:0, self.view.frame.size.width, self.view.frame.size.height);

	return YES;
}



#pragma mark - 键盘隐藏
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
        return [textField resignFirstResponder];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   //  self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [phoneNumTextField resignFirstResponder];
    [securityCodeTextField resignFirstResponder];
    [newPasswordTextField resignFirstResponder];
    [newPasswordAgainTextField resignFirstResponder];
}

#pragma mark - 移动视图
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([[UIScreen mainScreen] bounds].size.height < 481) {
        
        
        if (textField == newPasswordTextField ||textField == newPasswordAgainTextField ) {
            //[backgroundScrollView setContentOffset:CGPointMake(0,480/2) animated:YES];
            self.view.frame = CGRectMake(0, -40, self.view.frame.size.width, self.view.frame.size.height);
        }
    }
    
}

@end
