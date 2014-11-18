//
//  AddContactPeopleViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-13.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "AddContactPeopleViewController.h"
#import "MySweepViewController.h"
#import "BCHTTPRequest.h"
#import "DMCAlertCenter.h"

@interface AddContactPeopleViewController ()
{
    UITextField *searchField;
}
@end

@implementation AddContactPeopleViewController

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
    self.title = @"添加好友";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //搜索好友
    //搜索框背景
    UIImageView *searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 112/2)];
    searchImageView.backgroundColor = [UIColor clearColor];
    searchImageView.userInteractionEnabled = YES;
    [searchImageView setImage:[UIImage imageNamed:@"yaoqinghaoyoukuang@2x"]];
    [self.view addSubview:searchImageView];

    //搜索框
    searchField = [[UITextField alloc]initWithFrame:CGRectMake(46/2, 10, 414/2, 72/2)];
    searchField.backgroundColor = [UIColor clearColor];
    searchField.delegate = self;
    searchField.textAlignment = NSTextAlignmentLeft;
    searchField.textColor = [UIColor blackColor];
    searchField.placeholder = @"手机号/脸谱号";
    searchField.font = [UIFont systemFontOfSize:16];
    searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchField.keyboardType = UIKeyboardTypeASCIICapable;
    //searchField.returnKeyType =UIReturnKeySearch;
    [searchImageView addSubview:searchField];

   UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(470/2, 10, 140/2, 36);
    [searchButton setBackgroundImage:[UIImage imageNamed:@"fangdajing@2x"] forState:UIControlStateNormal];
//    [searchButton setTitle:@"退出登录" forState:UIControlStateNormal];
//    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [searchImageView addSubview:searchButton];

    
}
#pragma mark - 返回
-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 搜索
- (void)searchButtonClicked
{
     [searchField resignFirstResponder];
    if ([searchField.text length] > 0) {
        [BCHTTPRequest getSearchTheFriendsWithPhone:searchField.text usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
               
                //如果搜出结果跳转页面
                MySweepViewController *mySweepVC = [[MySweepViewController alloc]init];
                mySweepVC.mySweepDictionary = resultDic;
                mySweepVC.fromString = @"搜索";
                mySweepVC.friendIdString = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"id"]];
                [self.navigationController pushViewController:mySweepVC animated:YES];

            }else
            {
                //若果未搜出结果，显示提示语
                [self MarkalertImageView];
            }
        }];
    }else
    {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"输入框不能为空"];
    }
    

    
    
    
    
}
- (void)MarkalertImageView
{
    UIImageView *searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 56+45, 320, 147/2)];
    searchImageView.backgroundColor = [UIColor clearColor];
    searchImageView.userInteractionEnabled = YES;
    [searchImageView setImage:[UIImage imageNamed:@"tianjiatishiyu@2x"]];
    [self.view addSubview:searchImageView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [searchField resignFirstResponder];
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
