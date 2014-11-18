//
//  LinesMainViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-27.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "LinesMainViewController.h"
#import "LinesMembersViewController.h"
#import "LineDynamicViewController.h"
#import "LineGroupChatViewController.h"
#import "SendInstitutionDynamicViewController.h"
#import "GlobalVariable.h"
#import "LineMainMemberViewController.h"
@interface LinesMainViewController ()
{
    //上部分按钮背景
    UIImageView *topImageView;
    //成员
    UIButton *memberLineButton;
    LineMainMemberViewController *linesMembersVC;
//    LinesMembersViewController *linesMembersVC;
    //动态
    UIButton *lineDynamicButton;
    LineDynamicViewController *lineDynamicVC;
    //群聊
    UIButton *lineGroupChatButton;
    LineGroupChatViewController *lineGroupChatVC;
    
    UIButton *setButton;
}
@end

@implementation LinesMainViewController

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
    self.title = @"群名称";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //上部分按钮背景topImageView;
    topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 37)];
    topImageView.backgroundColor = [UIColor clearColor];
    [topImageView setImage:[UIImage imageNamed:@"dabaitiao@2x"]];
    topImageView.userInteractionEnabled = YES;
    [self.view addSubview:topImageView];
    
    //成员memberLineButton; //linesMembersVC;
    memberLineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    memberLineButton.frame = CGRectMake(20/2, 10/2, 200/2, 54/2);
    memberLineButton.backgroundColor = [UIColor clearColor];
    [memberLineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [memberLineButton setTitle:@"成员" forState:UIControlStateNormal];
    memberLineButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [memberLineButton setBackgroundImage:[UIImage imageNamed:@"jigouanniu@2x"] forState:UIControlStateNormal];
    [memberLineButton addTarget:self action:@selector(clickmemberLineButton) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:memberLineButton];
    
    //动态lineDynamicButton; //lineDynamicVC;
    lineDynamicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lineDynamicButton.frame = CGRectMake(220/2, 10/2, 200/2, 54/2);
    lineDynamicButton.backgroundColor = [UIColor clearColor];
    [lineDynamicButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [lineDynamicButton setTitle:@"动态" forState:UIControlStateNormal];
    lineDynamicButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [lineDynamicButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [lineDynamicButton addTarget:self action:@selector(clicklineDynamicButton) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:lineDynamicButton];
    
    //群聊lineGroupChatButton // lineGroupChatVC
    lineGroupChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lineGroupChatButton.frame = CGRectMake(420/2, 10/2, 200/2, 54/2);
    lineGroupChatButton.backgroundColor = [UIColor clearColor];
    [lineGroupChatButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [lineGroupChatButton setTitle:@"群聊" forState:UIControlStateNormal];
    lineGroupChatButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [lineGroupChatButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [lineGroupChatButton addTarget:self action:@selector(clicklineGroupChatButton) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:lineGroupChatButton];
    
    NSLog(@"%f",[[UIScreen mainScreen] bounds].size.height-37-64);
    
    //默认页面
    linesMembersVC=[[LineMainMemberViewController alloc]init];
    linesMembersVC.view.frame=CGRectMake(0, 37, [UIScreen mainScreen].bounds.size.width , [[UIScreen mainScreen] bounds].size.height-37);
    
    [self addChildViewController:linesMembersVC];
    [self.view addSubview:linesMembersVC.view];
    linesMembersVC.view.hidden = NO;
    
//    if ([_is_memberString integerValue] == 0) {
//        linesMembersVC.view.hidden = YES;
//    }

}
#pragma mark - 脸谱
- (void)clickmemberLineButton
{
    self.navigationItem.rightBarButtonItem = nil;
    
    [memberLineButton setBackgroundImage:[UIImage imageNamed:@"jigouanniu@2x"] forState:UIControlStateNormal];
    [lineDynamicButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [lineGroupChatButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [memberLineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lineDynamicButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [lineGroupChatButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    if (linesMembersVC) {
        linesMembersVC.view.hidden=NO;
        lineDynamicVC.view.hidden=YES;
        lineGroupChatVC.view.hidden=YES;
    }
    
//    if ([_is_memberString integerValue] == 0) {
//        linesMembersVC.view.hidden=YES;
//    }
    
}
#pragma  mark - 动态
- (void)clicklineDynamicButton
{
    if (setButton) {
        setButton.hidden = NO;
    }else {
        setButton = [UIButton buttonWithType:UIButtonTypeCustom];
        setButton.frame = CGRectMake(526/2, 22, 80/2, 80/2);
        [setButton setBackgroundImage:[UIImage imageNamed:@"fadongtaianniu@2x"] forState:UIControlStateNormal];
        [setButton addTarget:self action:@selector(SendDynamicClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ([_is_memberString integerValue] == 0) {
        self.navigationItem.rightBarButtonItem=nil;
    }else
    {
        UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:setButton];
        self.navigationItem.rightBarButtonItem=rightbuttonitem;
    }
    
    [memberLineButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [lineDynamicButton setBackgroundImage:[UIImage imageNamed:@"tiaoxiananniu@2x"] forState:UIControlStateNormal];
    [lineGroupChatButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [memberLineButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [lineDynamicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lineGroupChatButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    
    if (lineDynamicVC) {
        linesMembersVC.view.hidden=YES;
        lineDynamicVC.view.hidden=NO;
        lineGroupChatVC.view.hidden=YES;
    }else
    {
        lineDynamicVC=[[LineDynamicViewController alloc]init];
        lineDynamicVC.view.frame=CGRectMake(0, 37, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-37-64);
        
        [self addChildViewController:lineDynamicVC];
        [self.view addSubview:lineDynamicVC.view];
        linesMembersVC.view.hidden=YES;
        lineDynamicVC.view.hidden=NO;
        lineGroupChatVC.view.hidden = YES;
    }
    
//    if ([_is_memberString integerValue] == 0) {
//        lineDynamicVC.view.hidden= YES;
//    }
    
}
#pragma mark - 主题
- (void)clicklineGroupChatButton
{
    self.navigationItem.rightBarButtonItem = nil;
    [memberLineButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [lineDynamicButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [lineGroupChatButton setBackgroundImage:[UIImage imageNamed:@"zhutianniu@2x"] forState:UIControlStateNormal];
    
    [memberLineButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [lineDynamicButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [lineGroupChatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    if (lineGroupChatVC) {
        linesMembersVC.view.hidden=YES;
        lineDynamicVC.view.hidden=YES;
        lineGroupChatVC.view.hidden=NO;
    }else
    {
        lineGroupChatVC=[[LineGroupChatViewController alloc]init];
        lineGroupChatVC.view.frame=CGRectMake(0, 37, [UIScreen mainScreen].bounds.size.width , [[UIScreen mainScreen] bounds].size.height-37-64);
        NSLog(@"%f+++",[UIScreen mainScreen].bounds.size.height );
        [self addChildViewController:lineGroupChatVC];
        [self.view addSubview:lineGroupChatVC.view];
        linesMembersVC.view.hidden=YES;
        lineDynamicVC.view.hidden=YES;
        lineGroupChatVC.view.hidden = NO;
    }
    
}
#pragma mark - 返回
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 发表动态
- (void)SendDynamicClicked
{
    SendInstitutionDynamicViewController *sendInstitutionDynamicVC = [[SendInstitutionDynamicViewController alloc]init];
    GlobalVariable *globalVariable = [GlobalVariable sharedGlobalVariable];
    sendInstitutionDynamicVC.myInstitutionID = globalVariable.departmentIdString;
    sendInstitutionDynamicVC.fromString = @"条线发布动态";
    [self.navigationController pushViewController:sendInstitutionDynamicVC animated:YES];
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
