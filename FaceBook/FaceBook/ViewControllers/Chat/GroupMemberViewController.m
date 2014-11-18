//
//  GroupMemberViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-14.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "GroupMemberViewController.h"
#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "AddGroupMembersViewController.h"
#import "AddContactGroupViewController.h"

@interface GroupMemberViewController ()
{
    UIScrollView *backScrollView;
    NSMutableArray *allMembersArray;
    
    //照片的灰色背景
    UIImageView *photoBackImageView;
    
    //退出群聊
    UIButton *exitGroupButton;
    
}
@end

@implementation GroupMemberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        allMembersArray = [[NSMutableArray alloc]initWithCapacity:100];
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
    self.title = self.groupName;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;

    //背景
    [self GetTheDataWithStyle:self.whereType];
    
    //接受通知，刷新页面
    //接受通知
    [[NSNotificationCenter defaultCenter] addObserverForName:@"refushMembers" object:nil queue:nil usingBlock:^(NSNotification *note) {
        if (backScrollView) {
            [backScrollView removeFromSuperview];
        }
       
        [self GetTheDataWithStyle:self.whereType];
        
    }];


    
    
    
}
#pragma mark - 刷新数据
- (void)GetTheDataWithStyle:(NSString *)style
{
    if ([style intValue] == 0) //机构
    {
        [BCHTTPRequest GetTheInstitutionGroupMembersListWithInstitutionID:self.groupId usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                allMembersArray = resultDic[@"list"];
                [self addAllMemberPhotoWall];
            }
        }];
    }else if ([style intValue] == 1) //条线
    {
        [BCHTTPRequest GetTheDepartmentGroupMembersListWithDepartmentID:self.groupId usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                allMembersArray = resultDic[@"list"];
                [self addAllMemberPhotoWall];
            }
        }];
    }else if ([style intValue] == 2) //主题
    {
        [BCHTTPRequest GetTheThemeGroupMembersListWithThemeID:self.groupId usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                allMembersArray = resultDic[@"list"];
                [self addAllMemberPhotoWall];
            }
        }];
    }else if ([style intValue] == 3)
    {
        ///我的联系人
        [BCHTTPRequest TheMemberOfContactGroupPeopleWithGroupID:self.groupId usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                allMembersArray = resultDic[@"list"];
                [self addAllMemberPhotoWall];
            }
        }];
        
    }
}
#pragma mark - 返回
-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addAllMemberPhotoWall
{
    long int number;
    //int number;
    if ((allMembersArray.count + 1) %4 ==0) {
        number =((allMembersArray.count + 1)/4);
    }else
    {
        number =(((allMembersArray.count + 1)/4) + 1);
    }
    
    //整体背景  scrollerView
    
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320,IS_IOS_7?self.view.frame.size.height:self.view.frame.size.height-44)];
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.delegate = self;
    backScrollView.backgroundColor = [UIColor clearColor];
    backScrollView.userInteractionEnabled = YES;
    [backScrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, 102*number + 180)];
    [self.view addSubview:backScrollView];
    
    //照片墙的背景
    photoBackImageView=[[UIImageView alloc]init];
    photoBackImageView.frame=CGRectMake(20/2, 10, [[UIScreen mainScreen] bounds].size.width-20, 102*number);
    photoBackImageView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:235.0f/255.0f blue:244.0f/255.0f alpha:1.0];
    photoBackImageView.userInteractionEnabled = YES;
    photoBackImageView.layer.masksToBounds=YES;
    photoBackImageView.layer.cornerRadius=4.0f;
    [backScrollView addSubview:photoBackImageView];
    //循环添加照片
    NSLog(@"☺☺☺☺☺☺☺☺%d",allMembersArray.count);
    [self addPhotoToPhotoWallWithArray:allMembersArray];

    //退出群聊
    exitGroupButton=[UIButton buttonWithType:UIButtonTypeCustom];
    exitGroupButton.frame=CGRectMake(15, 86/2+photoBackImageView.frame.size.height, 580/2, 70/2);
    [exitGroupButton setBackgroundImage:[UIImage imageNamed:@"tuichudenglu@2x"] forState:UIControlStateNormal];
    [exitGroupButton setTitle:@"退出群聊" forState:UIControlStateNormal];
    [exitGroupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    exitGroupButton.titleLabel.font=[UIFont systemFontOfSize:18];
    exitGroupButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    //[exitDiscussionButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 130)];
    exitGroupButton.userInteractionEnabled=YES;
    [exitGroupButton addTarget:self action:@selector(clickExitDiscussionButton) forControlEvents:UIControlEventTouchUpInside];
    [backScrollView addSubview:exitGroupButton];



}
#pragma mark---循环添加照片
-(void)addPhotoToPhotoWallWithArray:(NSArray *)picArray
{
    NSLog(@"---------------------%@",picArray);
    for (int k=0; k<(picArray.count + 1); k++) {
        
        if (k==picArray.count) {
          UIButton *addMemberButton=[UIButton buttonWithType:UIButtonTypeCustom];
            addMemberButton.frame=CGRectMake(11+(142/2)*(k%4), 10+(196/2)*(k/4), 132/2, 132/2);
            [addMemberButton setBackgroundImage:[UIImage imageNamed:@"tianjiaren@2x.png"] forState:UIControlStateNormal];
            //[addMemberButton setBackgroundColor:[UIColor redColor]];
            [addMemberButton addTarget:self action:@selector(clickAddMemberButton) forControlEvents:UIControlEventTouchUpInside];
            [photoBackImageView addSubview:addMemberButton];
        }else
        {
            //photoImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[photoArray objectAtIndex:i]]];
           UIImageView *photoImageView=[[UIImageView alloc]init];
            
            //[photoImageView setImage:[UIImage imageNamed:@"ceshi@2x"]];
            photoImageView.frame=CGRectMake(11+(142/2)*(k%4), 10+(196/2)*(k/4), 132/2, 132/2);
            [photoImageView setImageWithURL:[NSURL URLWithString:picArray[k][@"user_logo"]] placeholderImage:[UIImage imageNamed:@"touxiangmoren@2x.png"]];
            photoImageView.backgroundColor=[UIColor clearColor];
            photoImageView.layer.masksToBounds=YES;
            photoImageView.layer.cornerRadius=4.0f;
            [photoBackImageView addSubview:photoImageView];
            
            
            UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(11+(142/2)*(k%4), 84+98*(k/4), 132/2, 32/2)];
            nameLabel.backgroundColor=[UIColor clearColor];
            nameLabel.textColor=[UIColor grayColor];
            nameLabel.textAlignment=NSTextAlignmentCenter;
            nameLabel.font=[UIFont systemFontOfSize:12];
            nameLabel.text=picArray[k][@"user_name"];
            [photoBackImageView addSubview:nameLabel];
        }
        
    }
    
}
#pragma mark - 添加群成员
- (void)clickAddMemberButton
{
    if ([self.whereType intValue]==3)
    {
        AddContactGroupViewController *addContactGroupVC = [[AddContactGroupViewController alloc] init];
        addContactGroupVC.myMemberArray = allMembersArray;
        addContactGroupVC.groupid = self.whereId;
        addContactGroupVC.myGroupIds = self.groupId;
        addContactGroupVC.fromString = @"我的联系人群聊";//我的联系人群聊
        [self.navigationController pushViewController:addContactGroupVC animated:YES];
    }else
    {

    
    AddGroupMembersViewController *addGroupMembersVC = [[AddGroupMembersViewController alloc] init];
    addGroupMembersVC.myMemberArray = allMembersArray;
    addGroupMembersVC.groupid = self.whereId;
    addGroupMembersVC.myGroupIds = self.groupId;
    if ([self.whereType intValue]==0) {
        addGroupMembersVC.fromString = @"机构群聊";//机构群聊
    }else if ([self.whereType intValue]==1)
    {
        addGroupMembersVC.fromString = @"条线群聊";//条线群聊
    }else if ([self.whereType intValue]==2)
    {
        addGroupMembersVC.fromString = @"主题群聊";//主题群聊
    }
    
    [self.navigationController pushViewController:addGroupMembersVC animated:YES];
    }
    
}
#pragma mark - 退出群聊
- (void)clickExitDiscussionButton
{
    if ([self.whereType intValue] == 0) //机构
    {
        [BCHTTPRequest exitTheInstitutionGroupWithGroupID:self.groupId WithTypeID:self.whereId WithUserId:[BCHTTPRequest getUserId] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                
            }
        }];
    }else if ([self.whereType intValue] == 1) //条线
    {
        [BCHTTPRequest exitTheDepartmentGroupWithGroupID:self.groupId WithTypeID:self.whereId WithUserId:[BCHTTPRequest getUserId] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                
            }
        }];
    }else if ([self.whereType intValue] == 2) //主题
    {
      [BCHTTPRequest exitTheThemeGroupWithGroupID:self.groupId WithTypeID:self.whereId WithUserId:[BCHTTPRequest getUserId] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
          if (isSuccess == YES) {
              
          }
      }];
    }else if ([self.whereType intValue] == 3) //我的联系人
    {
        [BCHTTPRequest ExitTheContactPeopleGroupWithGroupID:self.groupId WithUserID:[BCHTTPRequest getUserId] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                ;
            }
        }];
    }
//返回跟视图页面，发通知刷列表
     [[NSNotificationCenter defaultCenter] postNotificationName:@"exitGroup" object:self.groupId];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
