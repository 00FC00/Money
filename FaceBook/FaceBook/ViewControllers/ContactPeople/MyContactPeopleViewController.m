//
//  MyContactPeopleViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-13.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "MyContactPeopleViewController.h"
#import "NewFriendsCell.h"
#import "MySweepViewController.h"

#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "DMCAlertCenter.h"
#import "InvitedMyContentPeopleViewController.h"

@interface MyContactPeopleViewController ()
{
    UITableView *newFriendsTableView;
    NSMutableArray *myFriendsArray;
}
@end

@implementation MyContactPeopleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        myFriendsArray = [[NSMutableArray alloc]initWithCapacity:100];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    //获取数据
    [BCHTTPRequest getMyLinkManWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            
            myFriendsArray = resultDic[@"list"];
            [newFriendsTableView reloadData];
            
        }
    }];
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
    self.title = @"我的联系人";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //jiahao@2x
    //+号
    UIButton *_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    _Button.frame = CGRectMake(526/2, 22, 84/2, 42/2);
    [_Button setBackgroundImage:[UIImage imageNamed:@"jiahao@2x"] forState:UIControlStateNormal];
    //[_Button setTitle:@"完成" forState:UIControlStateNormal];
    _Button.titleLabel.font = [UIFont systemFontOfSize:15];
    [_Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_Button addTarget:self action:@selector(ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:_Button];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;
    
    newFriendsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, IS_IOS_7?self.view.frame.size.height-64:self.view.frame.size.height-44) style:UITableViewStylePlain];
    //newFriendsTableView.contentInset = UIEdgeInsetsMake(- 35, 0, 0, 0);
    newFriendsTableView.delegate = self;
    newFriendsTableView.dataSource = self;
    newFriendsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [newFriendsTableView setBackgroundView:nil];
    [newFriendsTableView setBackgroundColor:[UIColor colorWithRed:248.0f/255.0f green:249.0f/255.0f blue:251.0f/255.0f alpha:1.0]];
    [self.view addSubview:newFriendsTableView];
    
    

}
#pragma mark - 返回
-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 添加群聊
- (void)ButtonClicked
{
    InvitedMyContentPeopleViewController *invitedMyContentPeopleVC = [[InvitedMyContentPeopleViewController alloc]init];
    //invitedThemePeopleVC.groupid = self.groupID;
    //invitedThemePeopleVC.fromString = @"机构群聊";
    [self.navigationController pushViewController:invitedMyContentPeopleVC animated:YES];
}

#pragma mark tableView 协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170/2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return myFriendsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
    NewFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
    if (cell == nil) {
        cell = [[NewFriendsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellBackImageView.hidden = NO;
    [cell.cellBackImageView setBackgroundColor:[UIColor clearColor]];
    
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = myFriendsArray[indexPath.row];
    
    //头像
    cell.photoButton.hidden = NO;
    cell.photoImageView.hidden = NO;
    [cell.photoImageView setImageWithURL:[NSURL URLWithString:dic[@"pic"]] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
    
    [cell.photoButton setTag:1000+indexPath.row];
    [cell.photoButton addTarget:self action:@selector(clickPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.passButton.hidden = YES;
    cell.nameLabel.hidden = NO;
    cell.nameLabel.text = dic[@"name"];
    
    cell.lineImageView.hidden = NO;
    [cell.lineImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MySweepViewController *mySweepVC = [[MySweepViewController alloc]init];
    mySweepVC.friendIdString = myFriendsArray[indexPath.row][@"uid"];
    
    mySweepVC.groupIdString = @"0";
    mySweepVC.groupTypeString = @"4";
    [self.navigationController pushViewController:mySweepVC animated:YES];
}
#pragma mark - 头像点击事件
- (void)clickPhotoButton:(UIButton *)p_Button
{
//    MySweepViewController *mySweepVC = [[MySweepViewController alloc]init];
//    mySweepVC.friendIdString = myFriendsArray[p_Button.tag-1000][@"uid"];
//    
//    mySweepVC.groupIdString = @"0";
//    mySweepVC.groupTypeString = @"4";
//    [self.navigationController pushViewController:mySweepVC animated:YES];
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
