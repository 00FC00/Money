//
//  registerViewController.m
//  FaceBook
//
//  Created by 虞海云 on 14-5-4.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "registerViewController.h"
#import "LoginViewController.h"
#import "WorkCityViewController.h"
#import "WorkAreaViewController.h"
#import "UseTermsViewController.h"
#import "DetailInfoViewController.h"
#import "DMCAlertCenter.h"
#import "BCHTTPRequest.h"
#import "BCBaseObject.h"
#import "CitiesManager.h"

#import "OtherNotice.h"
#import "OtherNoticeObject.h"

@interface registerViewController ()
{
    UIScrollView *backgroundScrollView; //背景
    
    UITextField *nameTextField;         //真实姓名
    UITextField *phoneNumTextField;     //手机号
    UITextField *securityCodeTextField; //验证码
    UITextField *passwordTextField;     //密码
    UITextField *passwordAgainTextField;//确认密码
    UITextField *invitationCodeTextField;//邀请码
    UITextField *nickname1TextField;    //昵称1
    UITextField *nickname2TextField;    //昵称2
    
    UIButton *sendSecurityCodeButton;   //发送验证码按钮
    int secondsCountDown;               //倒计时
    NSTimer *countDownTimer;            //倒计时定时器
    
    UIButton *femaleButton;             //性别男
    UIButton *maleButton;               //性别女
    UIButton *secretButton;             //性别保密
    
    UIButton *workCityButton;           //工作城市-省
    UIButton *workAreaButton;           //工作城市-市
    
    UIButton *headButton;               //上传头像按钮
    UIButton *agreeButton;              //同意使用条款
    
    NSString *phoneNumString;
    NSString *securityCodeString;
    NSString *genderString;            //性别参数1：男，2：女，0：保密
    NSString *logoStr;                 //上传头像后返回的头像id
    NSString *workCityString;          //工作城市-省
    NSString *workAreaString;          //工作城市-市
    
    OtherNotice *otherNotice;
    OtherNoticeObject *otherObj;
    
    NSString *isPai;     //是否是相机拍照【1:是 0:不是】
}

@property (strong, nonatomic) UIImagePickerController* picker;
@end

@implementation registerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        logoStr = @"";
        isPai = [[NSString alloc]init];
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
    self.title = @"注册";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //登录
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(526/2, 20+(44-42/2)/2, 84/2, 42/2);
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login_RegistrationButton_03@2x"] forState:UIControlStateNormal];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:loginButton];
    
    otherNotice = [[OtherNotice alloc]init];
    [otherNotice createDataBase];
    
    otherObj = [otherNotice getAllOthersRemindStyleWithNumber:@"1"];
    
    //ScrollView背景
    backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.height)];
    backgroundScrollView.delegate = self;
    backgroundScrollView.contentSize = CGSizeMake(320, 1778/2);
    backgroundScrollView.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:251/255.0 alpha:1];
    [self.view addSubview:backgroundScrollView];
    //上部分文案
    UIView *topWordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 120/2)];
    topWordView.backgroundColor = [UIColor whiteColor];
    [backgroundScrollView addSubview:topWordView];
    
    UILabel *topWordLabel = [[UILabel alloc] initWithFrame:CGRectMake(28/2, 10/2, 574/2, 94/2)];
    topWordLabel.text = @"金融部落是基于真实身份的社交平台,请如实填写身份信息。一经注册，六个月不能更改。";
    topWordLabel.backgroundColor = [UIColor clearColor];
    topWordLabel.font = [UIFont systemFontOfSize:13];
    topWordLabel.textColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1];
    topWordLabel.numberOfLines = 0;
    [topWordView addSubview:topWordLabel];
    
    //姓名手机号验证码
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, topWordView.frame.size.height, 320, 300/2)];
    nameView.backgroundColor = [UIColor colorWithRed:208/255.0 green:210/255.0 blue:215/255.0 alpha:1];
    nameView.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:nameView];
    //姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20/2, 160/2, 72/2)];
    nameLabel.text = @"真实姓名：";
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.font = [UIFont systemFontOfSize:15];
    [nameView addSubview:nameLabel];
    
    UIImageView *nameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, 20/2, 443.0/2, 72/2)];
    [nameImageView setImage:[UIImage imageNamed:@"registration_textFieldBackground_03@2x"]];
    nameImageView.userInteractionEnabled = YES;
    [nameView addSubview:nameImageView];
    
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 410/2, 72/2)];
    nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameTextField.placeholder = @"必填，注册成功后无法更改";
    nameTextField.font = [UIFont systemFontOfSize:14];
    nameTextField.delegate = self;
    [nameImageView addSubview:nameTextField];
    
    //手机号
    UILabel *phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.frame.origin.y+nameLabel.frame.size.height+20/2, 160/2, 72/2)];
    phoneNumLabel.text = @"手机号：";
    phoneNumLabel.backgroundColor = [UIColor clearColor];
    phoneNumLabel.textAlignment = NSTextAlignmentRight;
    phoneNumLabel.font = [UIFont systemFontOfSize:15];
    [nameView addSubview:phoneNumLabel];
    
    UIImageView *phoneNumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, nameImageView.frame.origin.y+nameImageView.frame.size.height+20/2, 280.0/2, 72/2)];
    [phoneNumImageView setImage:[UIImage imageNamed:@"registration_textFieldBackground_03@2x"]];
    phoneNumImageView.userInteractionEnabled = YES;
    [nameView addSubview:phoneNumImageView];
    
    phoneNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 250/2, 72/2)];
    phoneNumTextField.placeholder = @"请输入手机号";
    phoneNumTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneNumTextField.font = [UIFont systemFontOfSize:14];
    phoneNumTextField.keyboardType = UIKeyboardTypeDecimalPad;
    phoneNumTextField.delegate = self;
    [phoneNumImageView addSubview:phoneNumTextField];
    
    //验证码
    UILabel *securityCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, phoneNumLabel.frame.origin.y+phoneNumLabel.frame.size.height+20/2, 160/2, 72/2)];
    securityCodeLabel.text = @"验证码：";
    securityCodeLabel.backgroundColor = [UIColor clearColor];
    securityCodeLabel.textAlignment = NSTextAlignmentRight;
    securityCodeLabel.font = [UIFont systemFontOfSize:15];
    [nameView addSubview:securityCodeLabel];
    
    UIImageView *securityCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, securityCodeLabel.frame.origin.y, 443.0/2, 72/2)];
    [securityCodeImageView setImage:[UIImage imageNamed:@"registration_textFieldBackground_03@2x"]];
    securityCodeImageView.userInteractionEnabled = YES;
    [nameView addSubview:securityCodeImageView];
    
    securityCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 410/2, 72/2)];
    securityCodeTextField.placeholder = @"输入验证码";
    securityCodeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    securityCodeTextField.font = [UIFont systemFontOfSize:14];
    securityCodeTextField.keyboardType = UIKeyboardTypeDecimalPad;
    securityCodeTextField.delegate = self;
    [securityCodeImageView addSubview:securityCodeTextField];
    
    //发送验证码
    sendSecurityCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendSecurityCodeButton.frame = CGRectMake(470/2, phoneNumImageView.frame.origin.y, 142/2, 74/2);
    [sendSecurityCodeButton setBackgroundImage:[UIImage imageNamed:@"forgetPassword_sendSecurityCodeButtonBackground_03@2x"] forState:UIControlStateNormal];
    [sendSecurityCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [sendSecurityCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendSecurityCodeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [sendSecurityCodeButton addTarget:self action:@selector(sendSecurityCodeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [nameView addSubview:sendSecurityCodeButton];
    
    
    //密码邀请码
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(0, nameView.frame.size.height+nameView.frame.origin.y+20/2, 320, 300/2)];
    passwordView.backgroundColor = [UIColor colorWithRed:208/255.0 green:210/255.0 blue:215/255.0 alpha:1];
    passwordView.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:passwordView];
    
    //密码
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20/2, 160/2, 72/2)];
    passwordLabel.text = @"密码：";
    passwordLabel.backgroundColor = [UIColor clearColor];
    passwordLabel.textAlignment = NSTextAlignmentRight;
    passwordLabel.font = [UIFont systemFontOfSize:15];
    [passwordView addSubview:passwordLabel];
    
    UIImageView *passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, 20/2, 443.0/2, 72/2)];
    [passwordImageView setImage:[UIImage imageNamed:@"registration_textFieldBackground_03@2x"]];
    passwordImageView.userInteractionEnabled = YES;
    [passwordView addSubview:passwordImageView];
    
    passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 410/2, 72/2)];
    passwordTextField.placeholder = @"请输入密码";
    [passwordTextField setSecureTextEntry:YES];
    passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTextField.font = [UIFont systemFontOfSize:14];
//    passwordTextField.keyboardType = UIKeyboardTypeDecimalPad;
    passwordTextField.delegate = self;
    [passwordImageView addSubview:passwordTextField];
    
    //确认密码
    UILabel *passwordAgainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, passwordLabel.frame.origin.y+passwordLabel.frame.size.height+20/2, 160/2, 72/2)];
    passwordAgainLabel.text = @"确认密码：";
    passwordAgainLabel.backgroundColor = [UIColor clearColor];
    passwordAgainLabel.textAlignment = NSTextAlignmentRight;
    passwordAgainLabel.font = [UIFont systemFontOfSize:15];
    [passwordView addSubview:passwordAgainLabel];
    
    UIImageView *passwordAgainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, passwordAgainLabel.frame.origin.y, 443.0/2, 72/2)];
    [passwordAgainImageView setImage:[UIImage imageNamed:@"registration_textFieldBackground_03@2x"]];
    passwordAgainImageView.userInteractionEnabled = YES;
    [passwordView addSubview:passwordAgainImageView];
    
    passwordAgainTextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 410/2, 72/2)];
    passwordAgainTextField.placeholder = @"请再次输入密码";
    [passwordAgainTextField setSecureTextEntry:YES];
    passwordAgainTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordAgainTextField.font = [UIFont systemFontOfSize:14];
    //    passwordTextField.keyboardType = UIKeyboardTypeDecimalPad;
    passwordAgainTextField.delegate = self;
    [passwordAgainImageView addSubview:passwordAgainTextField];
    
    //邀请码
    UILabel *invitationCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, passwordAgainLabel.frame.origin.y+passwordAgainLabel.frame.size.height+20/2, 160/2, 72/2)];
    invitationCodeLabel.text = @"邀请码：";
    invitationCodeLabel.backgroundColor = [UIColor clearColor];
    invitationCodeLabel.textAlignment = NSTextAlignmentRight;
    invitationCodeLabel.font = [UIFont systemFontOfSize:15];
    [passwordView addSubview:invitationCodeLabel];
    
    UIImageView *invitationCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, invitationCodeLabel.frame.origin.y, 443.0/2, 72/2)];
    [invitationCodeImageView setImage:[UIImage imageNamed:@"registration_textFieldBackground_03@2x"]];
    invitationCodeImageView.userInteractionEnabled = YES;
    [passwordView addSubview:invitationCodeImageView];
    
    invitationCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 410/2, 72/2)];
    invitationCodeTextField.placeholder = @"请输入邀请码";
    invitationCodeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    invitationCodeTextField.font = [UIFont systemFontOfSize:14];
    //    passwordTextField.keyboardType = UIKeyboardTypeDecimalPad;
    invitationCodeTextField.delegate = self;
    [invitationCodeImageView addSubview:invitationCodeTextField];
    
    //性别
    UIImageView *sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, passwordView.frame.size.height+passwordView.frame.origin.y+20/2, 320, 92/2)];
    [sexImageView setImage:[UIImage imageNamed:@"registration_sexBackground_06@2x"]];
    sexImageView.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:sexImageView];
    
    UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10/2, 160/2, 72/2)];
    sexLabel.text = @"性别：";
    sexLabel.backgroundColor = [UIColor clearColor];
    sexLabel.textAlignment = NSTextAlignmentRight;
    sexLabel.font = [UIFont systemFontOfSize:15];
    [sexImageView addSubview:sexLabel];
    
    genderString = @"1";//默认性别为男
    maleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    maleButton.backgroundColor = [UIColor clearColor];
    maleButton.frame = CGRectMake(166/2, 22/2, 110/2, 42/2);
    [maleButton setImage:[UIImage imageNamed:@"registration_sexChecked_10@2x"] forState:UIControlStateNormal];
    [maleButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 33)];
    [maleButton setTitle:@"男" forState:UIControlStateNormal];
    [maleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [maleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    maleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    maleButton.tag = 101;
    [maleButton addTarget:self action:@selector(sexButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sexImageView addSubview:maleButton];
    
    femaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    femaleButton.backgroundColor = [UIColor clearColor];
    femaleButton.frame = CGRectMake(300/2, 22/2, 110/2, 42/2);
    [femaleButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
    [femaleButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 33)];
    [femaleButton setTitle:@"女" forState:UIControlStateNormal];
    [femaleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [femaleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    femaleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    femaleButton.tag = 102;
    [femaleButton addTarget:self action:@selector(sexButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sexImageView addSubview:femaleButton];
    
    secretButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secretButton.backgroundColor = [UIColor clearColor];
    secretButton.frame = CGRectMake(436/2, 22/2, 140/2, 42/2);
    [secretButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
    [secretButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 48)];
    [secretButton setTitle:@"保密" forState:UIControlStateNormal];
    [secretButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [secretButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    secretButton.titleLabel.font = [UIFont systemFontOfSize:15];
    secretButton.tag = 103;
    [secretButton addTarget:self action:@selector(sexButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sexImageView addSubview:secretButton];
    
    //昵称
    UIView *nicknameView = [[UIView alloc] initWithFrame:CGRectMake(0, sexImageView.frame.size.height+sexImageView.frame.origin.y+20/2, 320, 200/2)];
    nicknameView.backgroundColor = [UIColor colorWithRed:208/255.0 green:210/255.0 blue:215/255.0 alpha:1];
    nicknameView.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:nicknameView];
    //昵称1
    UILabel *nickname1Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20/2, 160/2, 72/2)];
    nickname1Label.text = @"昵称1：";
    nickname1Label.backgroundColor = [UIColor clearColor];
    nickname1Label.textAlignment = NSTextAlignmentRight;
    nickname1Label.font = [UIFont systemFontOfSize:15];
    [nicknameView addSubview:nickname1Label];
    
    UIImageView *nickname1ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, 20/2, 443.0/2, 72/2)];
    [nickname1ImageView setImage:[UIImage imageNamed:@"registration_textFieldBackground_03@2x"]];
    nickname1ImageView.userInteractionEnabled = YES;
    [nicknameView addSubview:nickname1ImageView];
    
    nickname1TextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 410/2, 72/2)];
    nickname1TextField.placeholder = @"请输入昵称1";
    nickname1TextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nickname1TextField.font = [UIFont systemFontOfSize:14];
    //    passwordTextField.keyboardType = UIKeyboardTypeDecimalPad;
    nickname1TextField.delegate = self;
    [nickname1ImageView addSubview:nickname1TextField];
    //昵称2
    UILabel *nickname2Label = [[UILabel alloc] initWithFrame:CGRectMake(0, nickname1Label.frame.origin.y+nickname1Label.frame.size.height+20/2, 160/2, 72/2)];
    nickname2Label.text = @"昵称2：";
    nickname2Label.backgroundColor = [UIColor clearColor];
    nickname2Label.textAlignment = NSTextAlignmentRight;
    nickname2Label.font = [UIFont systemFontOfSize:15];
    [nicknameView addSubview:nickname2Label];
    
    UIImageView *nickname2ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164/2, nickname2Label.frame.origin.y, 443.0/2, 72/2)];
    [nickname2ImageView setImage:[UIImage imageNamed:@"registration_textFieldBackground_03@2x"]];
    nickname2ImageView.userInteractionEnabled = YES;
    [nicknameView addSubview:nickname2ImageView];
    
    nickname2TextField = [[UITextField alloc] initWithFrame:CGRectMake(16/2, 0, 410/2, 72/2)];
    nickname2TextField.placeholder = @"请输入昵称2";
    nickname2TextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nickname2TextField.font = [UIFont systemFontOfSize:14];
    nickname2TextField.delegate = self;
    [nickname2ImageView addSubview:nickname2TextField];
    
    //工作城市
    UIImageView *workCityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, nicknameView.frame.size.height+nicknameView.frame.origin.y+20/2, 320, 112/2)];
    [workCityImageView setImage:[UIImage imageNamed:@"registration_cityBackground_16@2x"]];
    workCityImageView.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:workCityImageView];
    
    //工作城市
    UILabel *workCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20/2, 160/2, 72/2)];
    workCityLabel.text = @"工作城市：";
    workCityLabel.backgroundColor = [UIColor clearColor];
    workCityLabel.textAlignment = NSTextAlignmentRight;
    workCityLabel.font = [UIFont systemFontOfSize:15];
    [workCityImageView addSubview:workCityLabel];
    
    workCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    workCityButton.backgroundColor = [UIColor clearColor];
    workCityButton.frame = CGRectMake(164/2, 20/2, 212/2, 72/2);
    [workCityButton setBackgroundImage:[UIImage imageNamed:@"registration_cityCheckButton_19@2x"] forState:UIControlStateNormal];
    [workCityButton setTitle:@"北京" forState:UIControlStateNormal];
    [workCityButton setTitleColor:[UIColor colorWithRed:203/255.0 green:205/255.0 blue:211/255.0 alpha:1] forState:UIControlStateNormal];
    [workCityButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
    workCityButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [workCityButton addTarget:self action:@selector(workCityButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [workCityImageView addSubview:workCityButton];
    
    workAreaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    workAreaButton.backgroundColor = [UIColor clearColor];
    workAreaButton.frame = CGRectMake(396/2, 20/2, 212/2, 72/2);
    [workAreaButton setBackgroundImage:[UIImage imageNamed:@"registration_cityCheckButton_19@2x"] forState:UIControlStateNormal];
    [workAreaButton setTitle:@"朝阳" forState:UIControlStateNormal];
    [workAreaButton setTitleColor:[UIColor colorWithRed:203/255.0 green:205/255.0 blue:211/255.0 alpha:1] forState:UIControlStateNormal];
    [workAreaButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
    workAreaButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [workAreaButton addTarget:self action:@selector(workAreaButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [workCityImageView addSubview:workAreaButton];
    
    //上传头像，下一步按钮
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, workCityImageView.frame.origin.y+workCityImageView.frame.size.height, 320, 448/2)];
    headView.backgroundColor = [UIColor clearColor];
    headView.userInteractionEnabled = YES;
    [backgroundScrollView addSubview:headView];
    //上传头像
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20/2, 160/2, 72/2)];
    headLabel.text = @"上传头像：";
    headLabel.backgroundColor = [UIColor clearColor];
    headLabel.textAlignment = NSTextAlignmentRight;
    headLabel.font = [UIFont systemFontOfSize:15];
    [headView addSubview:headLabel];
    
    headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame = CGRectMake(166/2, 68/2, 132/2, 132/2);
    headButton.backgroundColor = [UIColor colorWithRed:231.0f/255.0f green:231.0f/255.0f blue:231.0f/255.0f alpha:1.0];
    [headButton addTarget:self action:@selector(headButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:headButton];
    //同意条款
    agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeButton.frame = CGRectMake(headButton.frame.origin.x, headButton.frame.origin.y+headButton.frame.size.height+20/2, 240/2, 42/2);
    agreeButton.backgroundColor = [UIColor clearColor];
    [agreeButton setImage:[UIImage imageNamed:@"registration_agreeImage_03@2x"] forState:UIControlStateNormal];
    [agreeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 98)];
    [agreeButton setTitle:@"已阅读并同意" forState:UIControlStateNormal];
    [agreeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [agreeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    agreeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    agreeButton.tag = 1;
    [agreeButton addTarget:self action:@selector(agreeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:agreeButton];
    //使用条款
    UIButton *useTermsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    useTermsButton.frame = CGRectMake(agreeButton.frame.origin.x+agreeButton.frame.size.width+3, agreeButton.frame.origin.y, 180/2, 42/2);
    useTermsButton.backgroundColor = [UIColor clearColor];
    [useTermsButton setTitle:@"用户使用条款" forState:UIControlStateNormal];
    [useTermsButton setTitleColor:[UIColor colorWithRed:163/255.0 green:181/255.0 blue:219/255.0 alpha:1] forState:UIControlStateNormal];
    useTermsButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [useTermsButton addTarget:self action:@selector(useTermsButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:useTermsButton];
    //下一步
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake((320-583.0/2)/2, agreeButton.frame.origin.y+agreeButton.frame.size.height+20,  583.0/2, 75.0/2);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"forgetPassword_finishButtonBackground_03@2x"] forState:UIControlStateNormal];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:nextButton];
}
#pragma mark - 登录
-(void)loginButtonClicked
{
    if ([_fromString isEqualToString:@"登录"]) {
        [self dismissViewControllerAnimated:YES completion:^{
            ;
        }];
    }else
    {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.fromString = @"注册";
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNav animated:YES completion:^{
            ;
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

#pragma mark - 发送验证码
-(void)sendSecurityCodeButtonClicked:(UIButton *)sender
{
    if (phoneNumTextField.text == nil || [phoneNumTextField.text isEqualToString:@""]) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入手机号"];
    }else if ([BCBaseObject isMobileNumber:phoneNumTextField.text] == NO) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入正确的合法的手机号"];
    }else{
        secondsCountDown = 30;//60秒倒计时
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        sender.enabled = NO;
        [BCHTTPRequest GetTheRegisterCodeWithType:1 WithPhone:phoneNumTextField.text UsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
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
        [sendSecurityCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
    }
}

#pragma mark - 选择性别
-(void)sexButtonClicked:(UIButton *)sender
{
    if (sender.tag == 101) {
        genderString = @"1";
        [maleButton setImage:[UIImage imageNamed:@"registration_sexChecked_10@2x"] forState:UIControlStateNormal];
        [femaleButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
        [secretButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
    }else if (sender.tag == 102) {
        genderString = @"2";
        [maleButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
        [femaleButton setImage:[UIImage imageNamed:@"registration_sexChecked_10@2x"] forState:UIControlStateNormal];
        [secretButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
    }else if (sender.tag == 103) {
        genderString = @"0";
        [maleButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
        [femaleButton setImage:[UIImage imageNamed:@"registration_sexUnchecked_12@2x"] forState:UIControlStateNormal];
        [secretButton setImage:[UIImage imageNamed:@"registration_sexChecked_10@2x"] forState:UIControlStateNormal];
    }
}

#pragma mark - 选择城市区域
-(void)workCityButtonClicked
{
    WorkCityViewController *WorkCityVC = [[WorkCityViewController alloc] init];
    WorkCityVC.delegete = self;
    UINavigationController *WorkCityNav = [[UINavigationController alloc] initWithRootViewController:WorkCityVC];
    [self presentViewController:WorkCityNav animated:YES completion:^{
        ;
    }];
}

-(void)workAreaButtonClicked
{
    if (workCityString == nil || [workCityString isEqualToString:@""]) {
        //
        //[[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请先选择省份"];
        workCityString = workCityButton.titleLabel.text;
    }else {
        WorkAreaViewController *WorkAreaVC = [[WorkAreaViewController alloc] init];
        WorkAreaVC.delegate = self;
        WorkAreaVC.workCity = workCityString;
        UINavigationController *WorkAreaNav = [[UINavigationController alloc] initWithRootViewController:WorkAreaVC];
        [self presentViewController:WorkAreaNav animated:YES completion:^{
            ;
        }];
    }
}

#pragma mark - 上传头像
-(void)headButtonClicked
{
    if ([phoneNumTextField.text length]>0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.view];

    }else
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请先填写您的手机号码"];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    picker.allowsEditing = YES;  //是否可编辑
    
    if (buttonIndex == 0) {
        //相册
        isPai = @"0";
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }else if (buttonIndex == 1) {
        //拍照
        isPai = @"1";
        //判断是否可以打开相机，模拟器此功能无法使用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            picker.delegate = self;
            //_picker.allowsEditing = YES;  //是否可编辑
            //摄像头
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }else{
//            //如果没有提示用户
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"好的!" otherButtonTitles:nil];
//            [alert show];
        }
        
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    if ([otherObj.isSavePhoto isEqualToString:@"1"] && [isPai isEqualToString:@"1"]) {
    SEL selectorToCall = @selector(imageWasSavedSuccessfully:didFinishSavingWithError:contextInfo:);
    UIImageWriteToSavedPhotosAlbum(image, self,selectorToCall, NULL);
    }
    //。。。上传图片接口
    [BCHTTPRequest postHeadImageWithImage:image WithPhone:phoneNumTextField.text usingSuccessBlock:^(BOOL isSuccess, NSString *imageId) {
        if (isSuccess == YES) {
            [headButton setImage:image forState:UIControlStateNormal];
            logoStr = [NSString stringWithFormat:@"%@",imageId];
            NSLog(@"-----%@",imageId);
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"上传成功"];
        }
    }];

    [picker dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}
- (void) imageWasSavedSuccessfully:(UIImage *)paramImage didFinishSavingWithError:(NSError *)paramError contextInfo:(void *)paramContextInfo{
    if (paramError == nil){
        NSLog(@"Image was saved successfully.");
    } else {
        NSLog(@"An error happened while saving the image.");
        NSLog(@"Error = %@", paramError);
    }
}

//取消返回
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}


#pragma mark - 同意checkBox
-(void)agreeButtonClicked:(UIButton *)sender
{
    if (sender.tag == 1) {
        [sender setImage:[UIImage imageNamed:@"registration_unAgreeImage_03@2x"] forState:UIControlStateNormal];
        sender.tag = 2;
    }else if(sender.tag == 2)
    {
        [sender setImage:[UIImage imageNamed:@"registration_agreeImage_03@2x"] forState:UIControlStateNormal];
        sender.tag = 1;
    }
}
#pragma mark - 使用条款
-(void)useTermsButtonClicked
{
    UseTermsViewController *UseTermsVC = [[UseTermsViewController alloc] init];
    UINavigationController *UseTermsNav = [[UINavigationController alloc] initWithRootViewController:UseTermsVC];
    [self presentViewController:UseTermsNav animated:YES completion:^{
        ;
    }];
}
#pragma mark - 下一步
-(void)nextButtonClicked
{
    if (nameTextField.text == nil || [nameTextField.text isEqualToString:@""]) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入真实姓名"];
    }else if ([BCBaseObject isMobileNumber:phoneNumTextField.text] == NO) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入正确的合法的手机号"];
    }else if (securityCodeTextField.text == nil || [securityCodeTextField.text isEqualToString:@""])
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入验证码"];
    }else if ([BCBaseObject checkInputPassword:passwordTextField.text]==NO)
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入6-16位密码"];
    }else if (passwordAgainTextField.text == nil || [passwordAgainTextField.text isEqualToString:@""])
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请再次输入密码"];
    }else if (![passwordTextField.text isEqualToString:passwordAgainTextField.text]){
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入一致的密码"];
    }else if (nickname1TextField.text == nil)
    {
        nickname1TextField.text = @"";
    }else if (nickname2TextField.text == nil)
    {
        nickname2TextField.text = @"";
    }
    else if (invitationCodeTextField.text == nil || [invitationCodeTextField.text isEqualToString:@""])
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入邀请码"];
    }else if (agreeButton.tag != 1)
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请阅读并同意用户使用条款"];
    }else {
        NSString *cityStr = workCityButton.titleLabel.text;
        NSString *areaStr = workAreaButton.titleLabel.text;
        [BCHTTPRequest RegisterTheFirstWithName:nameTextField.text WithPhone:phoneNumTextField.text WithCode:securityCodeTextField.text WithPassWord:passwordTextField.text WithGender:genderString WithNickName_First:nickname1TextField.text WithNickName_Second:nickname2TextField.text WithWorkCicy:cityStr WithWorkArea:areaStr WithPicture:logoStr WithClause:[NSString stringWithFormat:@"%d",agreeButton.tag] WithInvitation:invitationCodeTextField.text usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess) {
                
                DetailInfoViewController *DetailInfoVC = [[DetailInfoViewController alloc] init];
                UINavigationController *DetailInfoNav = [[UINavigationController alloc] initWithRootViewController:DetailInfoVC];
                [self presentViewController:DetailInfoNav animated:YES completion:^{
                    ;
                }];
            }
        }];
    }
    
//    DetailInfoViewController *DetailInfoVC = [[DetailInfoViewController alloc] init];
//    UINavigationController *DetailInfoNav = [[UINavigationController alloc] initWithRootViewController:DetailInfoVC];
//    [self presentViewController:DetailInfoNav animated:YES completion:^{
//        ;
//    }];

    
}

#pragma mark - 键盘隐藏
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [nameTextField resignFirstResponder];
    [phoneNumTextField resignFirstResponder];
    [securityCodeTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [passwordAgainTextField resignFirstResponder];
    [invitationCodeTextField resignFirstResponder];
    [nickname1TextField resignFirstResponder];
    [nickname2TextField resignFirstResponder];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [nameTextField resignFirstResponder];
    [phoneNumTextField resignFirstResponder];
    [securityCodeTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [passwordAgainTextField resignFirstResponder];
    [invitationCodeTextField resignFirstResponder];
    [nickname1TextField resignFirstResponder];
    [nickname2TextField resignFirstResponder];
}
#pragma mark - 移动视图
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == passwordTextField ||textField == passwordAgainTextField ||textField == invitationCodeTextField ) {
        [backgroundScrollView setContentOffset:CGPointMake(0,480/2) animated:YES];
    }else if(textField == nickname2TextField ||textField == nickname1TextField)
    {
        [backgroundScrollView setContentOffset:CGPointMake(0,740/2) animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - WorkCityDelegate
- (void)getWorkCity:(NSDictionary *)cityDict
{
    workCityString = [cityDict objectForKey:@"name"];
    [workCityButton setTitle:workCityString forState:UIControlStateNormal];
    
    NSArray *m_cityArray = [[NSArray alloc]init];
    NSArray *m_array = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    
//    NSLog(@"cityarray is %@",m_array);
//    if ([workCityString length] > 0) {
    
        for (NSDictionary * itemDict in m_array) {
            if ([[itemDict objectForKey:@"state"] isEqualToString:workCityString]) {
                //找到了选择的省
                m_cityArray = [itemDict objectForKey:@"cities"];//这个数组里面是字典
                break;
            }
        }
        
 //   }
    NSLog(@"%@",m_cityArray[0][@"city"]);
    [workAreaButton setTitle:m_cityArray[0][@"city"] forState:UIControlStateNormal];
}

#pragma mark - WorkAreaDelegate
- (void)getWorkArea:(NSDictionary *)areaDict
{
    workAreaString = [areaDict objectForKey:@"city"];
    [workAreaButton setTitle:workAreaString forState:UIControlStateNormal];
}

@end
