//
//  MyFaceBookGroupViewController.m
//  FaceBook
//
//  Created by HMN on 14-4-28.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "MyFaceBookGroupViewController.h"
#import "MyFaceBookGroupCell.h"
#import "AppDelegate.h"

#import "SettingViewController.h"

#import "BCHTTPRequest.h"
#import "AFNetworking.h"

#import "GlobalVariable.h"
#import "InstitutionsMainViewController.h"
#import "LinesMainViewController.h"
#import "ThemeMainViewController.h"

#import "SUNViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
@interface MyFaceBookGroupViewController ()

@end

@implementation MyFaceBookGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        allGroupArray = [[NSMutableArray alloc]initWithCapacity:100];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijing"] forBarMetrics:UIBarMetricsDefault];
//    self.title = @"我的群";
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"我的部落";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 22, 40, 40);
    [menuButton setBackgroundImage:[UIImage imageNamed:@"caidan@2x"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //登录
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(526/2, 22, 80/2, 80/2);
    [setButton setBackgroundImage:[UIImage imageNamed:@"shezhianniu@2x"] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(setButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:setButton];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;

    //群列表
    groupTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 6, self.view.frame.size.width,IS_IOS_7?self.view.frame.size.height-64-12:self.view.frame.size.height-44-12) style:UITableViewStylePlain];
    groupTableView.delegate = self ;
    groupTableView.dataSource = self ;
    groupTableView.backgroundView = nil ;
    //groupTableView.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:249.0f/255.0f blue:251.0f/255.0f alpha:1.0];
    groupTableView.backgroundColor = [UIColor clearColor];
    groupTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:groupTableView];
    
    //获取数据
    [BCHTTPRequest getMyGroupListWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            allGroupArray = resultDic[@"list"];
            if (allGroupArray.count > 0) {
                 [groupTableView reloadData];
            }
           
        }
    }];

    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allGroupArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100/2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
    MyFaceBookGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
    if (cell == nil) {
        cell = [[MyFaceBookGroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.cellBackImageView.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dictions = [[NSDictionary alloc]init];
    dictions = allGroupArray[indexPath.row];
    
    [cell.groupImageView setImageWithURL:[NSURL URLWithString:dictions[@"logo"]] placeholderImage:[UIImage imageNamed:@"touxiangmoren@2x"]];
    cell.groupNameLabel.text =dictions[@"title"];
    [cell.bottomLineImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //根据不同类型群，进不同页面，根据不同身份获得不同权限
    NSDictionary *dictionary = [[NSDictionary alloc]init];
    dictionary = allGroupArray[indexPath.row];
    GlobalVariable *globalVariable = [GlobalVariable sharedGlobalVariable];
    
    if ([dictionary[@"type"] intValue]==1) {
        //机构群
        InstitutionsMainViewController *institutionsMainVC= [[InstitutionsMainViewController alloc]init];
        institutionsMainVC.isMember = dictionary[@"is_member"];
        globalVariable.institutionis_memberString = dictionary[@"is_member"];
        institutionsMainVC.GroupID = dictionary[@"id"];
        globalVariable.institutionsIdString = dictionary[@"id"];
        NSLog(@"########%@",dictionary[@"id"]);
        [self.navigationController pushViewController:institutionsMainVC animated:YES];
        
    }else if ([dictionary[@"type"] intValue]==2) {
        //条线群
        LinesMainViewController *linesMainVC= [[LinesMainViewController alloc]init];
        GlobalVariable *globalVariable = [GlobalVariable sharedGlobalVariable];
        globalVariable.departmentIdString = dictionary[@"id"];
        
        globalVariable.lineis_memberString = dictionary[@"is_member"];
        
        linesMainVC.is_memberString = dictionary[@"is_member"];
        
        [self.navigationController pushViewController:linesMainVC animated:YES];
        
    }else if ([dictionary[@"type"] intValue]==3) {
        //主题群
        ThemeMainViewController *themeMainVC = [[ThemeMainViewController alloc]init];
        GlobalVariable *globalVariable = [GlobalVariable sharedGlobalVariable];
        globalVariable.themeIdString = dictionary[@"id"];
        
        globalVariable.themeis_memberString = dictionary[@"is_member"];
        
        themeMainVC.is_memberString = dictionary[@"is_member"];
        
        [self.navigationController pushViewController:themeMainVC animated:YES];
    }
    
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
