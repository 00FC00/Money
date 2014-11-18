//
//  FaceBookGroupViewController.m
//  FaceBook
//
//  Created by HMN on 14-4-28.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "FaceBookGroupViewController.h"
#import "AppDelegate.h"


#import "SettingViewController.h"

#import "FaceBookinstitutionsViewController.h"
#import "FaceBookLineViewController.h"
#import "FaceBookThemeViewController.h"

#import "SUNViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface FaceBookGroupViewController ()
{
    //上部分按钮背景
    UIImageView *topImageView;
    //机构
    UIButton *institutionsButton;
    FaceBookinstitutionsViewController *faceBookInstitutionsVC;
    //条线
    UIButton *lineButton;
    FaceBookLineViewController *faceBookLineVC;
    //主题
    UIButton *themeButton;
    FaceBookThemeViewController *faceBookThemeVC;
    
    
}
@end

@implementation FaceBookGroupViewController

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
    self.title = @"部落群";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 22, 40, 40);
    [menuButton setBackgroundImage:[UIImage imageNamed:@"caidan@2x"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //登录
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(526/2, 22, 80/2, 80/2);
    [setButton setBackgroundImage:[UIImage imageNamed:@"shezhianniu@2x"] forState:UIControlStateNormal];
    //[setButton setTitle:@"登录" forState:UIControlStateNormal];
    //setButton.titleLabel.font = [UIFont systemFontOfSize:15];
    //[setButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(setButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:setButton];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;
    
    //上部分按钮背景topImageView;
    topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 37)];
    topImageView.backgroundColor = [UIColor clearColor];
    [topImageView setImage:[UIImage imageNamed:@"dabaitiao@2x"]];
    topImageView.userInteractionEnabled = YES;
    [self.view addSubview:topImageView];
    
    //机构institutionsButton; //faceBookInstitutionsVC;
    institutionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    institutionsButton.frame = CGRectMake(20/2, 10/2, 200/2, 54/2);
    institutionsButton.backgroundColor = [UIColor clearColor];
    [institutionsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [institutionsButton setTitle:@"机  构" forState:UIControlStateNormal];
    institutionsButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [institutionsButton setBackgroundImage:[UIImage imageNamed:@"jigouanniu@2x"] forState:UIControlStateNormal];
    [institutionsButton addTarget:self action:@selector(clickInstitutionsButton) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:institutionsButton];
    
    //条线lineButton; //faceBookLineVC;
    lineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lineButton.frame = CGRectMake(220/2, 10/2, 200/2, 54/2);
    lineButton.backgroundColor = [UIColor clearColor];
    [lineButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [lineButton setTitle:@"条  线" forState:UIControlStateNormal];
    lineButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [lineButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [lineButton addTarget:self action:@selector(clickLineButton) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:lineButton];
    
    //主题themeButton; //faceBookThemeVC;
    themeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    themeButton.frame = CGRectMake(420/2, 10/2, 200/2, 54/2);
    themeButton.backgroundColor = [UIColor clearColor];
    [themeButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [themeButton setTitle:@"主  题" forState:UIControlStateNormal];
    themeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [themeButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [themeButton addTarget:self action:@selector(clickThemeButton) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:themeButton];

    NSLog(@"%f",[[UIScreen mainScreen] bounds].size.height-37-64);
    
    //默认页面
    faceBookInstitutionsVC=[[FaceBookinstitutionsViewController alloc]init];
    faceBookInstitutionsVC.view.frame=CGRectMake(0, 37, [UIScreen mainScreen].bounds.size.width , [[UIScreen mainScreen] bounds].size.height-37);
     NSLog(@"%f---",[UIScreen mainScreen].bounds.size.height);
    [self addChildViewController:faceBookInstitutionsVC];
    [self.view addSubview:faceBookInstitutionsVC.view];
    //[faceBookInstitutionsVC didMoveToParentViewController:self];
    faceBookInstitutionsVC.view.hidden = NO;

}
#pragma mark - 机构
- (void)clickInstitutionsButton
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refushFaceBookinstitutionsView" object:nil];
    
    [institutionsButton setBackgroundImage:[UIImage imageNamed:@"jigouanniu@2x"] forState:UIControlStateNormal];
    [lineButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [themeButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [institutionsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lineButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [themeButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    if (faceBookInstitutionsVC) {
        faceBookInstitutionsVC.view.hidden=NO;
        faceBookLineVC.view.hidden=YES;
        faceBookThemeVC.view.hidden=YES;

        
    }

}
#pragma  mark - 条线
- (void)clickLineButton
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refushFaceBookLineView" object:nil];
    [institutionsButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [lineButton setBackgroundImage:[UIImage imageNamed:@"tiaoxiananniu@2x"] forState:UIControlStateNormal];
    [themeButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [institutionsButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [lineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [themeButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];

    
    if (faceBookLineVC) {
        faceBookInstitutionsVC.view.hidden=YES;
        faceBookLineVC.view.hidden=NO;
        faceBookThemeVC.view.hidden=YES;
    }else
    {
        faceBookLineVC=[[FaceBookLineViewController alloc]init];
        faceBookLineVC.view.frame=CGRectMake(0, 37, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-37-64);
       
        [self addChildViewController:faceBookLineVC];
        [self.view addSubview:faceBookLineVC.view];
        faceBookInstitutionsVC.view.hidden=YES;
        faceBookLineVC.view.hidden=NO;
        faceBookThemeVC.view.hidden = YES;
    }

}
#pragma mark - 主题
- (void)clickThemeButton
{
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"refushFaceBookThemeView" object:nil];
    
    [institutionsButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [lineButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [themeButton setBackgroundImage:[UIImage imageNamed:@"zhutianniu@2x"] forState:UIControlStateNormal];
    
    [institutionsButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [lineButton setTitleColor:[UIColor colorWithRed:146.0f/255.0f green:172.0f/255.0f blue:215.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [themeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    if (faceBookThemeVC) {
        faceBookInstitutionsVC.view.hidden=YES;
        faceBookLineVC.view.hidden=YES;
        faceBookThemeVC.view.hidden=NO;
    }else
    {
        faceBookThemeVC=[[FaceBookThemeViewController alloc]init];
        faceBookThemeVC.view.frame=CGRectMake(0, 37, [UIScreen mainScreen].bounds.size.width , [[UIScreen mainScreen] bounds].size.height-37-64);
         NSLog(@"%f+++",[UIScreen mainScreen].bounds.size.height );
        [self addChildViewController:faceBookThemeVC];
        [self.view addSubview:faceBookThemeVC.view];
        faceBookInstitutionsVC.view.hidden=YES;
        faceBookLineVC.view.hidden=YES;
        faceBookThemeVC.view.hidden = NO;
    }

}
#pragma mark - 菜单
- (void)menuButtonClicked
{
    SUNViewController *drawerController = (SUNViewController *)self.navigationController.mm_drawerController;
    
    if (drawerController.openSide == MMDrawerSideNone) {
        [drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            
        }];
    }else if  (drawerController.openSide == MMDrawerSideLeft) {
        [drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            
        }];
    }

}
#pragma mark - 设置
- (void)setButtonClicked
{
    SettingViewController *settingVC = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
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
