//
//  ThemeMainViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-27.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "ThemeMainViewController.h"
#import "ThemeMainMembersViewController.h"
#import "ThemeDynamicViewController.h"
#import "ThemeGroupChatViewController.h"
#import "SendInstitutionDynamicViewController.h"
#import "GlobalVariable.h"

@interface ThemeMainViewController ()
{
    //上部分按钮背景
    UIImageView *topImageView;
    //成员
    UIButton *memberThemeButton;
    ThemeMainMembersViewController *themeMembersVC;
   // ThemeMembersViewController *themeMembersVC;
    //动态
    UIButton *ThemeDynamicButton;
    ThemeDynamicViewController *themeDynamicVC;
    //群聊
    UIButton *ThemeGroupChatButton;
    ThemeGroupChatViewController *themeGroupChatVC;
    
    UIButton *setButton;
}

@end

@implementation ThemeMainViewController

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
    
    //成员memberThemeButton; //linesMembersVC;
    memberThemeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    memberThemeButton.frame = CGRectMake(20/2, 10/2, 200/2, 54/2);
    memberThemeButton.backgroundColor = [UIColor clearColor];
    [memberThemeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [memberThemeButton setTitle:@"成员" forState:UIControlStateNormal];
    memberThemeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [memberThemeButton setBackgroundImage:[UIImage imageNamed:@"jigouanniu@2x"] forState:UIControlStateNormal];
    [memberThemeButton addTarget:self action:@selector(clickmemberThemeButton) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:memberThemeButton];
    
    //动态ThemeDynamicButton; //lineDynamicVC;
    ThemeDynamicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ThemeDynamicButton.frame = CGRectMake(220/2, 10/2, 200/2, 54/2);
    ThemeDynamicButton.backgroundColor = [UIColor clearColor];
    [ThemeDynamicButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [ThemeDynamicButton setTitle:@"动态" forState:UIControlStateNormal];
    ThemeDynamicButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [ThemeDynamicButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [ThemeDynamicButton addTarget:self action:@selector(clickThemeDynamicButton) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:ThemeDynamicButton];
    
    //群聊ThemeGroupChatButton // lineGroupChatVC
    ThemeGroupChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ThemeGroupChatButton.frame = CGRectMake(420/2, 10/2, 200/2, 54/2);
    ThemeGroupChatButton.backgroundColor = [UIColor clearColor];
    [ThemeGroupChatButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [ThemeGroupChatButton setTitle:@"群聊" forState:UIControlStateNormal];
    ThemeGroupChatButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [ThemeGroupChatButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [ThemeGroupChatButton addTarget:self action:@selector(clickThemeGroupChatButton) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:ThemeGroupChatButton];
    
    NSLog(@"%f",[[UIScreen mainScreen] bounds].size.height-37-64);
    
    //默认页面
    themeMembersVC=[[ThemeMainMembersViewController alloc]init];
    themeMembersVC.view.frame=CGRectMake(0, 37, [UIScreen mainScreen].bounds.size.width , [[UIScreen mainScreen] bounds].size.height-37);
    NSLog(@"%f---",[UIScreen mainScreen].bounds.size.height);
    [self addChildViewController:themeMembersVC];
    [self.view addSubview:themeMembersVC.view];
    //[linesMembersVC didMoveToParentViewController:self];
    themeMembersVC.view.hidden = NO;

//    if ([_is_memberString integerValue] == 0) {
//        themeMembersVC.view.hidden = YES;
//    }
}
#pragma mark - 脸谱
- (void)clickmemberThemeButton
{
    [memberThemeButton setBackgroundImage:[UIImage imageNamed:@"jigouanniu@2x"] forState:UIControlStateNormal];
    [ThemeDynamicButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [ThemeGroupChatButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [memberThemeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ThemeDynamicButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [ThemeGroupChatButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    if (themeMembersVC) {
        themeMembersVC.view.hidden=NO;
        themeDynamicVC.view.hidden=YES;
        themeGroupChatVC.view.hidden=YES;
        
        
    }
    
//    if ([_is_memberString integerValue] == 0) {
//        themeMembersVC.view.hidden=YES;
//    }
}
#pragma  mark - 动态
- (void)clickThemeDynamicButton
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

    
    [memberThemeButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [ThemeDynamicButton setBackgroundImage:[UIImage imageNamed:@"tiaoxiananniu@2x"] forState:UIControlStateNormal];
    [ThemeGroupChatButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [memberThemeButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [ThemeDynamicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ThemeGroupChatButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    
    if (themeDynamicVC) {
        themeMembersVC.view.hidden=YES;
        themeDynamicVC.view.hidden=NO;
        themeGroupChatVC.view.hidden=YES;
    }else
    {
        themeDynamicVC=[[ThemeDynamicViewController alloc]init];
        themeDynamicVC.view.frame=CGRectMake(0, 37, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-37-64);
        
        [self addChildViewController:themeDynamicVC];
        [self.view addSubview:themeDynamicVC.view];
        themeMembersVC.view.hidden=YES;
        themeDynamicVC.view.hidden=NO;
        themeGroupChatVC.view.hidden = YES;
    }
    
//    if ([_is_memberString integerValue] == 0) {
//        themeDynamicVC.view.hidden=YES;
//    }
    
}
#pragma mark - 主题
- (void)clickThemeGroupChatButton
{
    [memberThemeButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [ThemeDynamicButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [ThemeGroupChatButton setBackgroundImage:[UIImage imageNamed:@"zhutianniu@2x"] forState:UIControlStateNormal];
    
    [memberThemeButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [ThemeDynamicButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [ThemeGroupChatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    if (themeGroupChatVC) {
        themeMembersVC.view.hidden=YES;
        themeDynamicVC.view.hidden=YES;
        themeGroupChatVC.view.hidden=NO;
    }else
    {
        themeGroupChatVC=[[ThemeGroupChatViewController alloc]init];
        themeGroupChatVC.view.frame=CGRectMake(0, 37, [UIScreen mainScreen].bounds.size.width , [[UIScreen mainScreen] bounds].size.height-37-64);
        NSLog(@"%f+++",[UIScreen mainScreen].bounds.size.height );
        [self addChildViewController:themeGroupChatVC];
        [self.view addSubview:themeGroupChatVC.view];
        themeMembersVC.view.hidden=YES;
        themeDynamicVC.view.hidden=YES;
        themeGroupChatVC.view.hidden = NO;
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
    sendInstitutionDynamicVC.myInstitutionID = globalVariable.themeIdString;
    sendInstitutionDynamicVC.fromString = @"主题发布动态";
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
