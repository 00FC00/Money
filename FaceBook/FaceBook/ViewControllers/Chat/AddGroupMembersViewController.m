//
//  AddGroupMembersViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-7-21.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "AddGroupMembersViewController.h"
#import "InvitedPeopleCell.h"
#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "CreateInstitutionGroupNameViewController.h"

@implementation FriendsItems
@synthesize friendId;
@synthesize name;
@synthesize headImageUrlString;
@synthesize userCompany;
@synthesize userInstitutionID;
@synthesize checked;

+ (FriendsItems*) friendsItem
{
	return [[self alloc] init];
}


@end

@interface AddGroupMembersViewController ()
{
    NSString *receiveId;
}

@end

@implementation AddGroupMembersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pageNumber = 1;
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
    self.title = @"添加群成员";
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
    [self getData:pageNumber];
    
    [self createHeaderView];
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.001f];
    
    
    isSelected = YES;
    
    //进入编辑状态
    [self setEditing:YES animated:YES];

}
#pragma mark - 获取数据
- (void)getData:(int)num
{
    //机构群聊
    if ([_fromString isEqualToString:@"机构群聊"]) {
        //获取数据
        [BCHTTPRequest GetTheFaceBookInstitutionMembersWithInstitutionID:self.groupid WithPages:num usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                if (num == 1) {
                    _listArray = [[NSMutableArray alloc]initWithCapacity:300];
                }
                
                if([resultDic[@"list"] count] > 0 ) {
                    
                    [_listArray addObjectsFromArray:resultDic[@"list"]];
                    
                    
                }
                
                NSMutableArray * mListArray = [[NSMutableArray alloc] initWithCapacity:200];
                mListArray = [_listArray mutableCopy];
                
                
                for (int j = 0; j< [mListArray count]; j++) {
                    
                    NSDictionary *studentInfo =[ mListArray objectAtIndex:j];
                    FriendsItems* friendItem = [FriendsItems friendsItem];
                    friendItem.name = studentInfo[@"user_name"];
                    friendItem.headImageUrlString = studentInfo[@"user_logo"];
                    friendItem.friendId = [studentInfo[@"user_id"] integerValue];
                    friendItem.userCompany = studentInfo[@"user_com"];
                    friendItem.userInstitutionID = studentInfo[@"institution_id"];
                    
                    for (int z = 0; z<self.myMemberArray.count; z++) {
                        NSString *idString = self.myMemberArray[z][@"user_id"];
                        if ([studentInfo[@"user_id"] isEqualToString:idString]) {
                            friendItem.checked = YES;
                        }
//                        for(NSDictionary *dic in mListArray)
//                        {
//                            if ([dic[@"user_id"] isEqualToString:idString]) {
//                                friendItem.checked = YES;
//                            }else
//                            {
//                                friendItem.checked = NO;
//                            }
//                        }
                        
                    }

                    [_friendsArray addObject:friendItem];
                }
                
                [self.friendTabelView reloadData];
                [self removeFooterView];
                [self testFinishedLoadData];
            }
            
            
            
            
        }];
        //条线群聊
    }else if ([_fromString isEqualToString:@"条线群聊"]) {
        
        [BCHTTPRequest getGroupsDepartmentUsersWithDid:_groupid WithPage:num usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                if (num == 1) {
                    _listArray = [[NSMutableArray alloc]initWithCapacity:300];
                }
                
                if([resultDic[@"list"] count] > 0 ) {
                    
                    [_listArray addObjectsFromArray:resultDic[@"list"]];
                    
                    
                }
                
                NSMutableArray * mListArray = [[NSMutableArray alloc] initWithCapacity:200];
                mListArray = [_listArray mutableCopy];
                
                               
                for (int j = 0; j< [_listArray count]; j++) {
                    
                    NSDictionary *studentInfo =[ _listArray objectAtIndex:j];
                    FriendsItems* friendItem = [FriendsItems friendsItem];
                    friendItem.name = studentInfo[@"user_name"];
                    friendItem.headImageUrlString = studentInfo[@"user_logo"];
                    friendItem.friendId = [studentInfo[@"user_id"] integerValue];
                    friendItem.userCompany = studentInfo[@"user_com"];
                    friendItem.userInstitutionID = studentInfo[@"institution_id"];
                    
                    for (int x = 0; x<self.myMemberArray.count; x++) {
                        NSString *idString = self.myMemberArray[x][@"user_id"];
                        if ([studentInfo[@"user_id"] isEqualToString:idString]) {
                            friendItem.checked = YES;
                        }
                    }

                    [_friendsArray addObject:friendItem];
                }
                
                [self.friendTabelView reloadData];
                [self removeFooterView];
                [self testFinishedLoadData];
            }
        }];
        
        
        //主题群聊
    }else if ([_fromString isEqualToString:@"主题群聊"]) {
        
        [BCHTTPRequest getGroupsThemeUsersWithTid:_groupid WithPage:num usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                if (num == 1) {
                    _listArray = [[NSMutableArray alloc]initWithCapacity:300];
                }
                
                if([resultDic[@"list"] count] > 0 ) {
                    
                    [_listArray addObjectsFromArray:resultDic[@"list"]];
                    
                    
                }
                
                NSMutableArray * mListArray = [[NSMutableArray alloc] initWithCapacity:200];
                mListArray = [_listArray mutableCopy];
                
                
                for (int j = 0; j< [_listArray count]; j++) {
                    
                    NSDictionary *studentInfo =[ _listArray objectAtIndex:j];
                    FriendsItems* friendItem = [FriendsItems friendsItem];
                    friendItem.name = studentInfo[@"user_name"];
                    friendItem.headImageUrlString = studentInfo[@"user_logo"];
                    friendItem.friendId = [studentInfo[@"user_id"] integerValue];
                    friendItem.userCompany = studentInfo[@"user_com"];
                    friendItem.userInstitutionID = studentInfo[@"institution_id"];
                    for (int b = 0; b<self.myMemberArray.count; b++) {
                        NSString *idString = self.myMemberArray[b][@"user_id"];
                        if ([studentInfo[@"user_id"] isEqualToString:idString]) {
                            friendItem.checked = YES;
                        }

                        
                    }

                    [_friendsArray addObject:friendItem];
                }
                
                [self.friendTabelView reloadData];
                [self removeFooterView];
                [self testFinishedLoadData];
            }
        }];
        
    }
    
    
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
            FriendsItems *receivefriends = _selectedFriendsArray[0];
            receiveId = [NSString stringWithFormat:@"%d",receivefriends.friendId];
            // receivedStr = [NSString stringWithFormat:@"%d",receivefriends.friendId];
        }
        
        for (int i = 1; i< _selectedFriendsArray.count; i++) {
            FriendsItems *receivefriends = _selectedFriendsArray[i];
            //        receivedChatStr = [NSString stringWithFormat:@"%@,%d",receivedChatStr,[NSString stringWithFormat:@"%d",receivefriends.friendId]];
            
            receiveId = [NSString stringWithFormat:@"%@,%d",receiveId,receivefriends.friendId];
            
        }
        
//        receiveId = [NSString stringWithFormat:@"%@,%@",receiveId,[BCHTTPRequest getUserId]];
        
//        CreateInstitutionGroupNameViewController *createInstitutionGroupNameVC = [[CreateInstitutionGroupNameViewController alloc]init];
//        createInstitutionGroupNameVC.receiveId = receiveId;
//        createInstitutionGroupNameVC.institutionID = self.groupid;
//        createInstitutionGroupNameVC.fromString = _fromString;
//        
//        
//        //InstitutionChatGroupAddNewMemberWithMembers
//        [self.navigationController pushViewController:createInstitutionGroupNameVC animated:YES];
//NSLog(@"%@",_selectedFriendsArray);
        if ([self.fromString isEqualToString:@"机构群聊"]) {
            [BCHTTPRequest InstitutionChatGroupAddNewMemberWithMembers:receiveId WithGroupID:self.myGroupIds WithInstitutionID:self.groupid usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                if (isSuccess == YES) {
                    ;
                }
            }];
        }else if ([self.fromString isEqualToString:@"条线群聊"])
        {
            [BCHTTPRequest DepartmentChatGroupAddNewMemberWithMembers:receiveId WithGroupID:self.myGroupIds WithDepartmentID:self.groupid usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                if (isSuccess == YES) {
                    ;
                }
            }];
        }else if ([self.fromString isEqualToString:@"主题群聊"])
        {
            [BCHTTPRequest ThemeChatGroupAddNewMemberWithMembers:receiveId WithGroupID:self.myGroupIds WithThemeID:self.groupid usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                if (isSuccess == YES) {
                    ;
                }
            }];
        }
        //发通知，刷新成员页面
         [[NSNotificationCenter defaultCenter] postNotificationName:@"refushMembers" object:nil];
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
    
    
    FriendsItems* friendItem = [_friendsArray objectAtIndex:indexPath.row];
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
    
    
    FriendsItems* friendItem = [_friendsArray objectAtIndex:indexPath.row];
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

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
	[_friendTabelView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)testFinishedLoadData{
	
    [self finishReloadingData];
    [self setFooterView];
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_friendTabelView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_friendTabelView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(_friendTabelView.contentSize.height, _friendTabelView.frame.size.height);
    
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              _friendTabelView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         _friendTabelView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [_friendTabelView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView)
	{
        [_refreshFooterView refreshLastUpdatedDate];
    }
}


-(void)removeFooterView
{
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
	{
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
    }else if(aRefreshPos == EGORefreshFooter)
	{
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
    }
	
	// overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
-(void)refreshView
{
	NSLog(@"刷新完成");
    
    pageNumber = 1;
    
    
    [self getData:pageNumber];
    
    
    //[self testFinishedLoadData];
	
}
//加载调用的方法
-(void)getNextPageView
{
    pageNumber += 1;
    
    [self getData:pageNumber];
    
    [self removeFooterView];
    [self testFinishedLoadData];
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	
	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
    
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
	
	[self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
	
	return [NSDate date]; // should return date data source was last changed
	
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
