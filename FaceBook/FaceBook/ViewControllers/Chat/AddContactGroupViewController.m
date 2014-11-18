//
//  AddContactGroupViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-8-12.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "AddContactGroupViewController.h"
#import "InvitedPeopleCell.h"
#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "CreateInstitutionGroupNameViewController.h"

@implementation CmfriendsItem
@synthesize friendId;
@synthesize name;
@synthesize headImageUrlString;
@synthesize userCompany;
@synthesize userInstitutionID;
@synthesize checked;

+ (CmfriendsItem *) friendsItem
{
	return [[self alloc] init];
}


@end

@interface AddContactGroupViewController ()
{
    NSString *receiveId;
}

@end

@implementation AddContactGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _selectedFriendsArray = [[NSMutableArray alloc] initWithCapacity:300];
        _friendsArray = [[NSMutableArray alloc] initWithCapacity:300];
        _listArray = [[NSMutableArray alloc] initWithCapacity:300];
        _myMemberArray = [[NSMutableArray alloc] initWithCapacity:200];
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
    self.title = @"添加联系人";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //确定
    UIButton *_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    _Button.frame = CGRectMake(526/2, 22, 84/2, 42/2);
    [_Button setBackgroundImage:[UIImage imageNamed:@"login_RegistrationButton_03@2x"] forState:UIControlStateNormal];
    [_Button setTitle:@"确定" forState:UIControlStateNormal];
    _Button.titleLabel.font = [UIFont systemFontOfSize:15];
    [_Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_Button addTarget:self action:@selector(ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:_Button];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;
    
    
    //选择好友tableview---多选
    self.friendTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-64) style:UITableViewStylePlain];
    self.friendTabelView.delegate = self;
    self.friendTabelView.dataSource = self;
    self.friendTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //self.friendTabelView.contentInset = UIEdgeInsetsMake(-34, 0, 0, 0);
    [self.view addSubview:self.friendTabelView];
    if (IS_IOS_7) {
        if ([self.friendTabelView respondsToSelector:@selector(setSectionIndexColor:)]) {
            self.friendTabelView.sectionIndexBackgroundColor = [UIColor clearColor];
            self.friendTabelView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        }
        
    }
    
    
    self.dataDic = [[NSMutableDictionary alloc] initWithCapacity:100];
    
    //获取数据
    [self getData];
    isSelected = YES;
    
    //进入编辑状态
    [self setEditing:YES animated:YES];

}
#pragma mark - 获取数据
- (void)getData
{
    //获取数据
    [BCHTTPRequest getMyLinkManWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            
            [_listArray addObjectsFromArray:resultDic[@"list"]];
            
            
            NSMutableArray * mListArray = [[NSMutableArray alloc] initWithCapacity:200];
            mListArray = [_listArray mutableCopy];
            
            
            for (int j = 0; j< [_listArray count]; j++) {
                
                NSDictionary *studentInfo =[ _listArray objectAtIndex:j];
                CmfriendsItem* friendItem = [CmfriendsItem friendsItem];
                friendItem.name = studentInfo[@"name"];
                friendItem.headImageUrlString = studentInfo[@"pic"];
                friendItem.friendId = [studentInfo[@"uid"] integerValue];
                for (int b = 0; b<self.myMemberArray.count; b++) {
                    NSString *idString = self.myMemberArray[b][@"user_id"];
                    if ([studentInfo[@"uid"] isEqualToString:idString]) {
                        friendItem.checked = YES;
                    }
                    
                    
                }
                
                [_friendsArray addObject:friendItem];
            }
            
            [self.friendTabelView reloadData];
            
        
        
        }
        
    }];
    
}
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
//完成
- (void)ButtonClicked
{
    NSLog(@"--%@",_selectedFriendsArray);
    if ([_selectedFriendsArray count] > 0) {
        
        receiveId = @"";
        if (_selectedFriendsArray.count>0) {
            CmfriendsItem *receivefriends = _selectedFriendsArray[0];
            receiveId = [NSString stringWithFormat:@"%d",receivefriends.friendId];
            // receivedStr = [NSString stringWithFormat:@"%d",receivefriends.friendId];
        }
        
        for (int i = 1; i< _selectedFriendsArray.count; i++) {
            CmfriendsItem *receivefriends = _selectedFriendsArray[i];
            //        receivedChatStr = [NSString stringWithFormat:@"%@,%d",receivedChatStr,[NSString stringWithFormat:@"%d",receivefriends.friendId]];
            
            receiveId = [NSString stringWithFormat:@"%@,%d",receiveId,receivefriends.friendId];
            
        }

        [BCHTTPRequest AddMemberOfContactPeopleGroupWithUsers:receiveId WithGroupId:self.myGroupIds usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        
            if (isSuccess == YES) {
                ;
                //发通知，刷新成员页面
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refushMembers" object:nil];

            }
        }];

                [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择好友" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    
}
//进入编辑状态
- (void) setEditing:(BOOL)editting animated:(BOOL)animated
{
    //	if (!editting)
    //	{
    //		for (FriendsItem* item in _friendsArray)
    //		{
    //			item.checked = NO;
    //		}
    //	}
	[super setEditing:editting animated:animated];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    
    return [_listArray count];
    
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    NSArray *allKeys = [[self.dataDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
//    return allKeys;
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 174/2;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *header = [[UIView alloc] init];
//    header.backgroundColor = [UIColor colorWithRed:155.0f/255.0f green:155.0f/255.0f blue:155.0f/255.0f alpha:0.7];
//
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 200, 22)];
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.backgroundColor = [UIColor clearColor];
//
//    NSArray *allKeys = [[self.dataDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
//    titleLabel.text = [allKeys objectAtIndex:section];
//    [header addSubview:titleLabel];
//    return header;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    InvitedPeopleCell *cell = (InvitedPeopleCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[InvitedPeopleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //选中颜色
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:233.0f/255.0f green:233.0f/255.0f blue:233.0f/255.0f alpha:1.0f];
    }
    
    
    CmfriendsItem* friendItem = [_friendsArray objectAtIndex:indexPath.row];
    [cell.cellBackImageView setBackgroundColor:[UIColor clearColor]];
    cell.nameLabel.text = friendItem.name;
	//cell.headImageView.image = [UIImage imageNamed:friendItem.headImageUrlString];
    
    [cell.pictureImageView setImageWithURL:[NSURL URLWithString:friendItem.headImageUrlString] placeholderImage:[UIImage imageNamed:@"touxiangmoren@2x"]];
    
    [cell.lineImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];
    
    
    [cell setChecked:friendItem.checked];
    
    return cell;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     //  <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    
    
    CmfriendsItem* friendItem = [_friendsArray objectAtIndex:indexPath.row];
    NSString *isHave = [[NSString alloc]init];
    for (int m = 0; m<self.myMemberArray.count; m++) {
        NSString *idString = self.myMemberArray[m][@"user_id"];
        NSLog(@"已经在的%@",idString);
        
        NSString *isingStr =[NSString stringWithFormat:@"%d",friendItem.friendId];
        NSLog(@"点击的%@",isingStr);
        
        if ([idString isEqualToString:isingStr] ) {
            isHave = @"have";
            break;
        }else
        {
            isHave = @"nohave";
        }
    }
    if ([isHave isEqualToString:@"nohave"]) {
        //根据对象被不被选中对选中数组进行增加和删除
        if (friendItem.checked) {
            [_selectedFriendsArray removeObject:friendItem];
            
        }else {
            [_selectedFriendsArray addObject:friendItem];
            
        }
        
        
        //cell选中和未选中的效果
        if (self.editing)
        {
            InvitedPeopleCell *cell = (InvitedPeopleCell*)[tableView cellForRowAtIndexPath:indexPath];
            friendItem.checked = !friendItem.checked;
            [cell setChecked:friendItem.checked];
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        isSelected = YES;
        
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
