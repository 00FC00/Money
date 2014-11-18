//
//  InstitutionsMainViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-27.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "InstitutionsMainViewController.h"

#import "InstitutionsFaceBookViewController.h"
#import "InstitutionsDynamicViewController.h"
#import "DynamicGroupChatViewController.h"

#import "SendInstitutionDynamicViewController.h"

@interface InstitutionsMainViewController ()
{
    //上部分按钮背景
    UIImageView *topImageView;
    //脸谱
    UIButton *institutionsFaceBookButton;
    InstitutionsFaceBookViewController *institutionsFaceBookVC;
    //动态
    UIButton *institutionsDynamicButton;
    InstitutionsDynamicViewController *institutionsDynamicVC;
    //群聊
    UIButton *institutionsGroupChatButton;
    DynamicGroupChatViewController *dynamicGroupChatVC;
    
    UIButton *setButton;
    
}

@end

@implementation InstitutionsMainViewController

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
    
    //脸谱institutionsFaceBookButton; //institutionsFaceBookVC;
    institutionsFaceBookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    institutionsFaceBookButton.frame = CGRectMake(20/2, 10/2, 200/2, 54/2);
    institutionsFaceBookButton.backgroundColor = [UIColor clearColor];
    [institutionsFaceBookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [institutionsFaceBookButton setTitle:@"脸谱" forState:UIControlStateNormal];
    institutionsFaceBookButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [institutionsFaceBookButton setBackgroundImage:[UIImage imageNamed:@"jigouanniu@2x"] forState:UIControlStateNormal];
    [institutionsFaceBookButton addTarget:self action:@selector(clickinstitutionsFaceBookButton) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:institutionsFaceBookButton];
    
    //条线institutionsDynamicButton; //faceBookLineVC;
    institutionsDynamicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    institutionsDynamicButton.frame = CGRectMake(220/2, 10/2, 200/2, 54/2);
    institutionsDynamicButton.backgroundColor = [UIColor clearColor];
    [institutionsDynamicButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [institutionsDynamicButton setTitle:@"动态" forState:UIControlStateNormal];
    institutionsDynamicButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [institutionsDynamicButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [institutionsDynamicButton addTarget:self action:@selector(clickinstitutionsDynamicButton) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:institutionsDynamicButton];
    
    //主题institutionsGroupChatButton; //faceBookThemeVC;
    institutionsGroupChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    institutionsGroupChatButton.frame = CGRectMake(420/2, 10/2, 200/2, 54/2);
    institutionsGroupChatButton.backgroundColor = [UIColor clearColor];
    [institutionsGroupChatButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [institutionsGroupChatButton setTitle:@"群聊" forState:UIControlStateNormal];
    institutionsGroupChatButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [institutionsGroupChatButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [institutionsGroupChatButton addTarget:self action:@selector(clickinstitutionsGroupChatButton) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:institutionsGroupChatButton];
    
    NSLog(@"%f",[[UIScreen mainScreen] bounds].size.height-37-64);
    
    //默认页面
    institutionsFaceBookVC=[[InstitutionsFaceBookViewController alloc]init];
    institutionsFaceBookVC.view.frame=CGRectMake(0, 37, [UIScreen mainScreen].bounds.size.width , [[UIScreen mainScreen] bounds].size.height-37);
    NSLog(@"%f---",[UIScreen mainScreen].bounds.size.height);
    [self addChildViewController:institutionsFaceBookVC];
    [self.view addSubview:institutionsFaceBookVC.view];
    //[institutionsFaceBookVC didMoveToParentViewController:self];
    institutionsFaceBookVC.view.hidden = NO;
    
//    if ([_isMember integerValue] == 0) {
//        institutionsFaceBookVC.view.hidden = YES;
//    }


}
#pragma mark - 脸谱
- (void)clickinstitutionsFaceBookButton
{
    self.navigationItem.rightBarButtonItem = nil;
    [institutionsFaceBookButton setBackgroundImage:[UIImage imageNamed:@"jigouanniu@2x"] forState:UIControlStateNormal];
    [institutionsDynamicButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [institutionsGroupChatButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [institutionsFaceBookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [institutionsDynamicButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [institutionsGroupChatButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    if (institutionsFaceBookVC) {
        institutionsFaceBookVC.view.hidden=NO;
        institutionsDynamicVC.view.hidden=YES;
        dynamicGroupChatVC.view.hidden=YES;
        
        
    }
//    if ([_isMember integerValue] == 0) {
//        institutionsFaceBookVC.view.hidden = YES;
//    }
    
}
#pragma  mark - 动态
- (void)clickinstitutionsDynamicButton
{
    if (setButton) {
        setButton.hidden = NO;
    }else {
        setButton = [UIButton buttonWithType:UIButtonTypeCustom];
        setButton.frame = CGRectMake(526/2, 22, 80/2, 80/2);
        [setButton setBackgroundImage:[UIImage imageNamed:@"fadongtaianniu@2x"] forState:UIControlStateNormal];
        [setButton addTarget:self action:@selector(SendDynamicClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ([_isMember integerValue] == 0) {
        self.navigationItem.rightBarButtonItem=nil;
    }else
    {
        UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:setButton];
        self.navigationItem.rightBarButtonItem=rightbuttonitem;
    }

    
    [institutionsFaceBookButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [institutionsDynamicButton setBackgroundImage:[UIImage imageNamed:@"tiaoxiananniu@2x"] forState:UIControlStateNormal];
    [institutionsGroupChatButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [institutionsFaceBookButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [institutionsDynamicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [institutionsGroupChatButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    
    if (institutionsDynamicVC) {
        institutionsFaceBookVC.view.hidden=YES;
        institutionsDynamicVC.view.hidden=NO;
        dynamicGroupChatVC.view.hidden=YES;
        institutionsDynamicVC.groupId = self.GroupID;
        NSLog(@"########111111%@",self.GroupID);
        
    }else
    {
        institutionsDynamicVC=[[InstitutionsDynamicViewController alloc]init];
        institutionsDynamicVC.groupId = self.GroupID;
        NSLog(@"########11%@",self.GroupID);
        institutionsDynamicVC.view.frame=CGRectMake(0, 37, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-37-64);
        
        [self addChildViewController:institutionsDynamicVC];
        [self.view addSubview:institutionsDynamicVC.view];
        institutionsFaceBookVC.view.hidden=YES;
        institutionsDynamicVC.view.hidden=NO;
        
        dynamicGroupChatVC.view.hidden = YES;
    }
    
//    if ([_isMember integerValue] == 0) {
//        institutionsDynamicVC.view.hidden = YES;
//    }
    
}
#pragma mark - 主题
- (void)clickinstitutionsGroupChatButton
{
    self.navigationItem.rightBarButtonItem = nil;
    
    [institutionsFaceBookButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [institutionsDynamicButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [institutionsGroupChatButton setBackgroundImage:[UIImage imageNamed:@"zhutianniu@2x"] forState:UIControlStateNormal];
    
    [institutionsFaceBookButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [institutionsDynamicButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [institutionsGroupChatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    if (dynamicGroupChatVC) {
        institutionsFaceBookVC.view.hidden=YES;
        institutionsDynamicVC.view.hidden=YES;
        dynamicGroupChatVC.view.hidden=NO;
        dynamicGroupChatVC.groupID = self.GroupID;
    }else
    {
        dynamicGroupChatVC=[[DynamicGroupChatViewController alloc]init];
        dynamicGroupChatVC.groupID = self.GroupID;
        dynamicGroupChatVC.view.frame=CGRectMake(0, 37, [UIScreen mainScreen].bounds.size.width , [[UIScreen mainScreen] bounds].size.height-37-64);
        NSLog(@"%f+++",[UIScreen mainScreen].bounds.size.height );
        [self addChildViewController:dynamicGroupChatVC];
        [self.view addSubview:dynamicGroupChatVC.view];
        institutionsFaceBookVC.view.hidden=YES;
        institutionsDynamicVC.view.hidden=YES;
        dynamicGroupChatVC.view.hidden = NO;
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
    sendInstitutionDynamicVC.myInstitutionID = self.GroupID;
    sendInstitutionDynamicVC.fromString = @"机构发布动态";
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
