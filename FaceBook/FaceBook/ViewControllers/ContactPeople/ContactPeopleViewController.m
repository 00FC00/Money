//
//  ContactPeopleViewController.m
//  FaceBook
//
//  Created by HMN on 14-4-28.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "ContactPeopleViewController.h"
#import "AppDelegate.h"

#import "SettingViewController.h"
#import "ContactPeopleCell.h"

#import "NewFriendsViewController.h"
#import "MyContactPeopleViewController.h"
#import "InstationContactPeopleViewController.h"
#import "PresentedFriendsViewController.h"
#import "QRCodeReadViewController.h"
#import "InviteFriendsViewController.h"
#import "AddContactPeopleViewController.h"

#import "SUNViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface ContactPeopleViewController ()
{
    UITableView *contactPeopleTableView;
    NSArray *titleArray;
    NSArray *markImageArray;
}
@end

@implementation ContactPeopleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleArray = [[NSArray alloc]initWithObjects:@"新的好友",@"我的联系人",@"站内联系人",@"赠送联系人",@"邀请好友",@"添加好友",@"扫一扫", nil];
        markImageArray = [[NSArray alloc]initWithObjects:@"xindehaoyou@2x",@"wodelianxiren@2x",@"zhanneilianxiren@2x",@"zengsonglianxiren@2x",@"yaoqinghaoyou@2x",@"tianjiahaoyou1@2x",@"saoyisao1@2x", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0];
    
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"联系人";
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
    [setButton addTarget:self action:@selector(setButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:setButton];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;
    
    contactPeopleTableView = [[UITableView alloc]initWithFrame:CGRectMake(6, 4, self.view.frame.size.width-12,IS_IOS_7?self.view.frame.size.height-64-4:self.view.frame.size.height-44-4) style:UITableViewStylePlain];
    contactPeopleTableView.delegate = self;
    contactPeopleTableView.dataSource = self;
    contactPeopleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [contactPeopleTableView setBackgroundView:nil];
    [contactPeopleTableView setBackgroundColor:[UIColor colorWithRed:248.0f/255.0f green:249.0f/255.0f blue:251.0f/255.0f alpha:1.0]];
    [self.view addSubview:contactPeopleTableView];
    
    

    
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
#pragma mark tableView 协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80/2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
        ContactPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
        if (cell == nil) {
            cell = [[ContactPeopleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.cellBackImageView setBackgroundColor:[UIColor clearColor]];
        [cell.photoImageView setImage:[UIImage imageNamed:markImageArray[indexPath.row]]];
        cell.titleLabel.text = titleArray[indexPath.row];
        [cell.lineImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        NewFriendsViewController *newFriendsVC = [[NewFriendsViewController alloc]init];
        [self.navigationController pushViewController:newFriendsVC animated:YES];
        
    }else if (indexPath.row == 1)
    {
        MyContactPeopleViewController *myContactPeopleVC = [[MyContactPeopleViewController alloc]init];
        [self.navigationController pushViewController:myContactPeopleVC animated:YES];
        
    }else if (indexPath.row == 2)
    {
        InstationContactPeopleViewController *instationContactPeopleVC = [[InstationContactPeopleViewController alloc]init];
        [self.navigationController pushViewController:instationContactPeopleVC animated:YES];
        
    }else if (indexPath.row == 3)
    {
        PresentedFriendsViewController *presentedFriendsVC = [[PresentedFriendsViewController alloc]init];
        [self.navigationController pushViewController:presentedFriendsVC animated:YES];
        
    }else if (indexPath.row == 4)
    {
        InviteFriendsViewController *inviteFriendsVC = [[InviteFriendsViewController alloc]init];
        [self.navigationController pushViewController:inviteFriendsVC animated:YES];
        
    }else if (indexPath.row == 5)
    {
        AddContactPeopleViewController *addContactPeopleVC = [[AddContactPeopleViewController alloc]init];
        [self.navigationController pushViewController:addContactPeopleVC animated:YES];
        
    }else if (indexPath.row == 6)
    {
        QRCodeReadViewController *QRCodeReadVC = [[QRCodeReadViewController alloc]init];
        [self.navigationController pushViewController:QRCodeReadVC animated:YES];
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
