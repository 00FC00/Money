//
//  InstationContactPeopleViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-13.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "InstationContactPeopleViewController.h"
#import "NewFriendsCell.h"
#import "MySweepViewController.h"

#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "DMCAlertCenter.h"


@interface InstationContactPeopleViewController ()
{
    UITableView *instationFriendsTableView;
    NSMutableArray *instationFriendsArray;
}
@end

@implementation InstationContactPeopleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        instationFriendsArray = [[NSMutableArray alloc]initWithCapacity:100];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    //获取数据
    [BCHTTPRequest getMyInstationManWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            instationFriendsArray = resultDic[@"list"];
            [instationFriendsTableView reloadData];
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
    self.title = @"站内联系人";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    
    
    instationFriendsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, IS_IOS_7?self.view.frame.size.height-64:self.view.frame.size.height-44) style:UITableViewStylePlain];
    //instationFriendsTableView.contentInset = UIEdgeInsetsMake(- 35, 0, 0, 0);
    instationFriendsTableView.delegate = self;
    instationFriendsTableView.dataSource = self;
    instationFriendsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [instationFriendsTableView setBackgroundView:nil];
    [instationFriendsTableView setBackgroundColor:[UIColor colorWithRed:248.0f/255.0f green:249.0f/255.0f blue:251.0f/255.0f alpha:1.0]];
    [self.view addSubview:instationFriendsTableView];
    
    }
#pragma mark - 返回
-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark tableView 协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170/2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return instationFriendsArray.count;
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
    dic = instationFriendsArray[indexPath.row];
    
    //头像
    cell.photoButton.hidden = NO;
    cell.photoImageView.hidden = NO;
    [cell.photoImageView setImageWithURL:[NSURL URLWithString:dic[@"pic"]] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
    [cell.photoButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [cell.photoButton setTag:1000+indexPath.row];
    [cell.photoButton addTarget:self action:@selector(clickPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.passButton.hidden = YES;
    cell.nameLabel.hidden = NO;
    if ([dic[@"type"] intValue]==1) {
        [cell.nameLabel setTextColor:[UIColor blackColor]];
    }else if ([dic[@"type"] intValue]==0)
    {
        [cell.nameLabel setTextColor:[UIColor lightGrayColor]];
    }
    cell.nameLabel.text = dic[@"name"];
    
    cell.lineImageView.hidden = NO;
    [cell.lineImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([instationFriendsArray[indexPath.row][@"type"] intValue]==1) {
        MySweepViewController *mySweepVC = [[MySweepViewController alloc]init];
        mySweepVC.friendIdString = instationFriendsArray[indexPath.row][@"uid"];
        [self.navigationController pushViewController:mySweepVC animated:YES];
    }

}
#pragma mark - 头像点击事件
- (void)clickPhotoButton:(UIButton *)p_Button
{
//    if ([instationFriendsArray[p_Button.tag-1000][@"type"] intValue]==1) {
//        MySweepViewController *mySweepVC = [[MySweepViewController alloc]init];
//        mySweepVC.friendIdString = instationFriendsArray[p_Button.tag-1000][@"uid"];
//        [self.navigationController pushViewController:mySweepVC animated:YES];
//    }
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
