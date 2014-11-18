//
//  SchoolViewController.m
//  Mytownsman
//
//  Created by 蓝凌 on 14-5-14.
//  Copyright (c) 2014年 蓝凌. All rights reserved.
//

#import "SchoolViewController.h"
#import "NewFriendsCell.h"
#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "DMCAlertCenter.h"
#import "MyPersonCenterViewController.h"
#import "MypersonCenterDetialsViewController.h"

#import "MySweepViewController.h"


@interface SchoolViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* myTableView;
@property (strong, nonatomic) NSMutableArray *allSchoolArray;
@end

@implementation SchoolViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.allSchoolArray = [[NSMutableArray alloc]initWithCapacity:100];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0];
    
    self.myTableView=[[UITableView alloc]initWithFrame:CGRectMake(6, 0, [UIScreen mainScreen].bounds.size.width-12 ,IS_IOS_7?self.view.frame.size.height-100:self.view.frame.size.height-80) style:UITableViewStylePlain];
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    if (IS_IOS_7) {
        self.myTableView.separatorInset=UIEdgeInsetsMake(0, 10, 0, 10);
    }
    
    UIView* myView=[[UIView alloc]init];
    myView.backgroundColor=[UIColor clearColor];
    [self.myTableView setTableHeaderView:myView];
    [self.myTableView setTableFooterView:myView];
    
    
    [self.view addSubview:self.myTableView];
    
    
    //self.title=@"新的好友";
    [[NSNotificationCenter defaultCenter]addObserverForName:@"showschool" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        NSLog(@"========%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"STYPE"]);
        
        //if ([BCHTTPRequest getTheCicyType] == YES) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"STYPE"] integerValue] == 1) {
        
        NSLog(@"已经完善");
            //获取数据
            [BCHTTPRequest GetTheSameSchoolListWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                
                if (isSuccess == YES) {
                    self.allSchoolArray = resultDic[@"list"];
                    [self.myTableView reloadData];
                }
            }];
            
        }else
        {
            //未完善------>去完善
            UIAlertView *messageAlertView = [[UIAlertView alloc]initWithTitle:@"" message:@"要想使用该功能，需要完善您的个人资料" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即完善", nil];
            messageAlertView.tag = 9000;
            [messageAlertView show];
        }

        
    }];
    
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"随后完善");
    }else
    {
//        MyPersonCenterViewController *myPersonCenterVC = [[MyPersonCenterViewController alloc]init];
//        [self.navigationController pushViewController:myPersonCenterVC animated:YES];
        MypersonCenterDetialsViewController *mypersonCenterDetialsVC = [[MypersonCenterDetialsViewController alloc]init];
        [self.navigationController pushViewController:mypersonCenterDetialsVC animated:YES];
    }
    

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allSchoolArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewFriendsCell* cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[NewFriendsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellBackImageView.hidden = NO;
    [cell.cellBackImageView setBackgroundColor:[UIColor clearColor]];
    
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = self.allSchoolArray[indexPath.row];
    
    //头像
    cell.photoButton.hidden = NO;
    cell.photoImageView.hidden = NO;
    [cell.photoImageView setImageWithURL:[NSURL URLWithString:dic[@"pic"]] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
    [cell.photoButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    //[cell.photoButton setTag:1000+indexPath.row];
    //[cell.photoButton addTarget:self action:@selector(clickPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.passButton.hidden = NO;
    //加好友//huiseyanzheng@2x//tongguoyanzheng@2x
    
    if ([dic[@"is_friend"] intValue]==0) {
        [cell.passButton setBackgroundImage:[UIImage imageNamed:@"tongguoyanzheng@2x"] forState:UIControlStateNormal];
        [cell.passButton setTitle:@"加好友" forState:UIControlStateNormal];
    }else if ([dic[@"is_friend"] intValue]==1)
    {
        [cell.passButton setBackgroundImage:[UIImage imageNamed:@"huiseyanzheng@2x"] forState:UIControlStateNormal];
        [cell.passButton setTitle:@"已添加" forState:UIControlStateNormal];
    }
    
     [cell.passButton setTag:4000+indexPath.row];
     [cell.passButton addTarget:self action:@selector(clickPassButton:) forControlEvents:UIControlEventTouchUpInside];

    
    cell.nameLabel.hidden = NO;
    cell.nameLabel.text = dic[@"nickname_first"];
    
    cell.lineImageView.hidden = NO;
    [cell.lineImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];

    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = self.allSchoolArray[indexPath.row];
    MySweepViewController *otherPeopleMessageDetialsVC = [[MySweepViewController alloc] init];
    otherPeopleMessageDetialsVC.friendIdString = [NSString stringWithFormat:@"%@",dic[@"uid"]];
    [self.navigationController pushViewController:otherPeopleMessageDetialsVC animated:YES];
}

#pragma mark - 加好友
- (void)clickPassButton:(UIButton *)button
{
    //AddTheNewFriendsWithFriendsID
    NSDictionary *diction = [[NSDictionary alloc]init];
    diction = self.allSchoolArray[button.tag - 4000];
    
    [BCHTTPRequest AddTheNewFriendsWithFriendsID:diction[@"uid"] WithFriendsType:@"1" WithGroupID:@"" WithGroupType:@"" WithInforString:@"" usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请求已发送，等待对方确认"];
        }
    }];

}
@end
