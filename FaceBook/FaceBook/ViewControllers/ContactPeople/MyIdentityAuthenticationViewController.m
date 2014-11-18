//
//  MyIdentityAuthenticationViewController.m
//  ContactGroup
//
//  Created by 蓝凌 on 14-5-13.
//  Copyright (c) 2014年 蓝凌. All rights reserved.
//

#import "MyIdentityAuthenticationViewController.h"
#import "BCHTTPRequest.h"


@interface MyIdentityAuthenticationViewController ()

@property(nonatomic,strong)UILabel* tipLabel;
@property(nonatomic,strong)UIImageView* tipMessageImageView;
@property(nonatomic,strong)UITextField* tipMessageTextField;

@end

@implementation MyIdentityAuthenticationViewController

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
    self.title = @"身份验证";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //发送
    UIButton *_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    _Button.frame = CGRectMake(526/2, 22, 84/2, 42/2);
    [_Button setBackgroundImage:[UIImage imageNamed:@"login_RegistrationButton_03@2x"] forState:UIControlStateNormal];
    [_Button setTitle:@"发送" forState:UIControlStateNormal];
    _Button.titleLabel.font = [UIFont systemFontOfSize:15];
    [_Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_Button addTarget:self action:@selector(ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:_Button];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;
    
    //设置提示label
    self.tipLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 35)];
    self.tipLabel.text=@"  您需要发送验证申请，才能成为好友";
    self.tipLabel.font=[UIFont systemFontOfSize:14];
    self.tipLabel.textColor=[UIColor colorWithRed:118/255.0 green:148/255.0 blue:198/255.0 alpha:1.0f];
    self.tipLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.tipLabel];
    
    //设置验证消息imageView
    self.tipMessageImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 35, 320, 112/2)];
    self.tipMessageImageView.userInteractionEnabled=YES;
    [self.tipMessageImageView setImage:[UIImage imageNamed:@"yaoqinghaoyoukuang@2x"]];
    [self.view addSubview:self.tipMessageImageView];
    
    //设置验证消息textView
    self.tipMessageTextField=[[UITextField alloc]initWithFrame:CGRectMake(50/2, 18/2, 530/2, 72/2)];
    self.tipMessageTextField.placeholder=@"我是XXX";
    self.tipMessageTextField.font = [UIFont systemFontOfSize:15];
    self.tipMessageTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.tipMessageTextField.backgroundColor=[UIColor clearColor];
    [self.tipMessageImageView addSubview:self.tipMessageTextField];
    

}
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.tipMessageTextField resignFirstResponder];
}
#pragma mark 发送验证消息
-(void)ButtonClicked
{
    NSLog(@"发送的消息：%@",self.tipMessageTextField.text);
    
    //好友类型 1：找老乡找好友时添加的，扫一扫、搜手机号、脸谱号 2：app其他途径加的好友3：手机通讯录4：从群中加好友
    [BCHTTPRequest AddTheNewFriendsWithFriendsID:_friendIdString WithFriendsType:@"1" WithGroupID:@"" WithGroupType:@"" WithInforString:[self.tipMessageTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}
@end
