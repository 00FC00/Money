//
//  FaceBookThemeViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-26.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "FaceBookThemeViewController.h"
#import "FaceBookLineCell.h"
#import "TopToolCell.h"
#import "CreateNewThemeViewController.h"
#import "ThemeMainViewController.h"
#import "MyPersonCenterViewController.h"
#import "GoldBuyVisitedStatusViewController.h"
#import "MypersonCenterDetialsViewController.h"

#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "DMCAlertCenter.h"
#import "GlobalVariable.h"

#import "UpgradeVIPViewController.h"


@interface FaceBookThemeViewController ()
{
     UITextField *searchField;
}
@end

@implementation FaceBookThemeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        institutionsArray = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0];
    
    //搜索框背景
    UIImageView *searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30/2, 20/2, 580/2, 72/2)];
    searchImageView.backgroundColor = [UIColor clearColor];
    searchImageView.userInteractionEnabled = YES;
    [searchImageView setImage:[UIImage imageNamed:@"sousuozhutiqun@2x"]];
    [self.view addSubview:searchImageView];
    
    //搜索框
    searchField = [[UITextField alloc]initWithFrame:CGRectMake(18/2, 0, 416/2, 72/2)];
    searchField.backgroundColor = [UIColor clearColor];
    searchField.delegate = self;
    searchField.textAlignment = NSTextAlignmentLeft;
    searchField.textColor = [UIColor blackColor];
    searchField.placeholder = @"搜主题";
    searchField.font = [UIFont systemFontOfSize:15];
    searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchField.returnKeyType =UIReturnKeyDone;
    [searchImageView addSubview:searchField];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(442/2, 0, 140/2, 36);
    [searchButton setBackgroundImage:[UIImage imageNamed:@"fangdajing@2x"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [searchImageView addSubview:searchButton];
    
    //主题列表
    institutionsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 53, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height-37-64-53) style:UITableViewStylePlain];
    institutionsTableView.delegate = self ;
    institutionsTableView.dataSource = self ;
    institutionsTableView.backgroundView = nil ;
    institutionsTableView.tag = 6007;
    institutionsTableView.backgroundColor = [UIColor clearColor];
    institutionsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:institutionsTableView];
    
    //创建主题320*72
    UIButton *createThemeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    createThemeButton.frame = CGRectMake(120, [[UIScreen mainScreen] bounds].size.height-10-64-68 , 320/4, 72/2);
    createThemeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    createThemeButton.backgroundColor = [UIColor clearColor];
    [createThemeButton setBackgroundImage:[UIImage imageNamed:@"chuangjianzhutianniu@2x"] forState:UIControlStateNormal];
    [createThemeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [createThemeButton setTitle:@"创建主题" forState:UIControlStateNormal];
    [createThemeButton addTarget:self action:@selector(clickCreateThemeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createThemeButton];
    

    
    pageNumber =1;
    //根据分类获取数据
    keyString = @"";
    [self getDataWithNum:pageNumber];
    
    [self createHeaderView];
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"CreateThemeGroup" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        pageNumber = 1;
        keyString = @"";
        searchField.text = @"";
        [self getDataWithNum:pageNumber];
        
    }];
}

//获取数据
- (void)getDataWithNum:(NSInteger)num
{
    [BCHTTPRequest getGroupsThemeListWithKeys:[keyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] WithPage:num usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            if (num == 1) {
                institutionsArray = [[NSMutableArray alloc] initWithCapacity:100];
            }
            
            if ([resultDic[@"list"] count] > 0) {
                
                [institutionsArray addObjectsFromArray:resultDic[@"list"]];
                
            }
            
            [institutionsTableView reloadData];
            [self removeFooterView];
            [self testFinishedLoadData];
        }
    }];
    
}

#pragma mark - 创建主题
- (void)clickCreateThemeButton
{
    CreateNewThemeViewController *createNewThemeVC = [[CreateNewThemeViewController alloc]init];
    [self.navigationController pushViewController:createNewThemeVC animated:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        
        [searchField resignFirstResponder];
        
        if ([searchField.text length] < 1 && [keyString length] > 0) {
            keyString = @"";
            pageNumber = 1;
            [self getDataWithNum:pageNumber];
        }
        
        return NO;
    }
    return YES;

}

#pragma mark - 搜索
- (void)searchButtonClicked
{
    if ([searchField.text length] > 0) {
        keyString = searchField.text;
        pageNumber = 1;
        [self getDataWithNum:pageNumber];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return myActivityArray.count;
    if (tableView.tag == 6007) {
        return institutionsArray.count;
    }
    return NO;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 6007) {
        return 120/2;
    }
    return NO;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 6007) {
        static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
        FaceBookLineCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
        if (cell == nil) {
            cell = [[FaceBookLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.backgroundColor = [UIColor clearColor];
        [cell.addButton setBackgroundColor:[UIColor clearColor]];
        
        [cell.addButton setBackgroundImage:[UIImage imageNamed:@"lianpujiahao@2x"] forState:UIControlStateNormal];

        if ([institutionsArray[indexPath.row][@"is_add"] integerValue] == 1) {
            //[cell.cellBackImageView setImage:[UIImage imageNamed:@"linecellbeijing2@2x"]];
            
            cell.addButton.hidden = YES;
            
        }else
        {
            //[cell.cellBackImageView setImage:[UIImage imageNamed:@"linecellbeijing@2x"]];
            cell.addButton.hidden = NO;
            cell.addButton.tag = 7000+indexPath.row;
            [cell.addButton addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [cell.headerImageView setImageWithURL:[NSURL URLWithString:institutionsArray[indexPath.row][@"logo"]] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
        cell.titleLabel.text = institutionsArray[indexPath.row][@"title"];
        [cell.bottomImageView setImage:[UIImage imageNamed:@"shouyecellxian@2x"]];
//        cell.peopleNumberLabel.text = @"";
//        cell.visiterLabel.text = @"";
        
        return cell;
        
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 6007)
    {
        //进入详情页面
        
        if ([institutionsArray[indexPath.row][@"is_add"] integerValue] == 1) {
            //进入活动详情页面
            ThemeMainViewController *themeMainVC = [[ThemeMainViewController alloc]init];
            GlobalVariable *globalVariable = [GlobalVariable sharedGlobalVariable];
            globalVariable.themeIdString = institutionsArray[indexPath.row][@"id"];
            globalVariable.themeis_memberString = institutionsArray[indexPath.row][@"is_member"];
            
            themeMainVC.is_memberString = institutionsArray[indexPath.row][@"is_member"];
            
            [self.navigationController pushViewController:themeMainVC animated:YES];
        }else
        {
            [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请先加入该群"];
        }

        
    }
}


#pragma mark - 添加按钮
- (void)clickAddButton:(UIButton *)addButton
{
    
    groupTypeId = [institutionsArray[addButton.tag-7000][@"add_jurisdiction"] integerValue];
    
    rowTag = addButton.tag-7000;
    
    //判断资料是否完整【不完整->(完善资料)】
    if ([BCHTTPRequest getUserType ] == YES) {
        NSLog(@"已经完善");
        
        if ([institutionsArray[addButton.tag-7000][@"is_vip"] integerValue] == 1) {
            //vip用户可进入
            if ([BCHTTPRequest getUserVIP] == YES)
            {
                //是VIP，直接进入
                [self addDepartmentGroupWithType:@"" WithVip:YES];
                
                
            }else
            {
                //不是VIP，提醒只有VIP可加入，请升级为VIP用户
                UIAlertView *vipAlertView = [[UIAlertView alloc]initWithTitle:@"" message:@"VIP机构群，加入该群须升级为VIP用户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                vipAlertView.tag = 9003;
                [vipAlertView show];
                
            }

        }else {
            //add_jurisdiction【判断群的类型】
            if ((groupTypeId == 0)||(groupTypeId == 2)) {
                //vip用户可进入
                if ([BCHTTPRequest getUserVIP] == YES)
                {
                    //是VIP，直接进入
                    [self addDepartmentGroupWithType:@"" WithVip:NO];
                    
                    
                }else
                {
                    //不是VIP，提醒只有VIP可加入，请升级为VIP用户
                    UIAlertView *vipAlertView = [[UIAlertView alloc]initWithTitle:@"" message:@"VIP机构群，加入该群须升级为VIP用户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                    vipAlertView.tag = 9004;
                    [vipAlertView show];
                    
                }
            }else if (groupTypeId == 1)
            {
                //花费金币和VIP用户可进入
                if ([BCHTTPRequest getUserVIP] == YES) {
                    //是VIP，直接进入
                    [self addDepartmentGroupWithType:@"" WithVip:NO];
                    
                }else if ([BCHTTPRequest getUserVIP] == NO)
                {
                    UIAlertView *moneyAlertView = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"您不是该机构的成员，进入该群需%@个金币，时效%@天。",institutionsArray[addButton.tag-7000][@"days_coins"],institutionsArray[addButton.tag-7000][@"days"]] delegate:self cancelButtonTitle:@"购买资格" otherButtonTitles:@"确认加入", nil];
                    moneyAlertView.tag = 9001;
                    [moneyAlertView show];
                }
            }else if (groupTypeId == 3)
            {
                //免费群所有用户可进入
                [self addDepartmentGroupWithType:@"" WithVip:NO];
            }

        }
        
        
    }else
    {
        //未完善------>去完善
        UIAlertView *messageAlertView = [[UIAlertView alloc]initWithTitle:@"" message:@"要想使用该功能，需要完善您的个人资料" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即完善", nil];
        messageAlertView.tag = 9000;
        [messageAlertView show];
        
        
    }

    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (alertView.tag == 9001) {
            //购买资格
            GoldBuyVisitedStatusViewController *goldBuyVisitedStatusVC = [[GoldBuyVisitedStatusViewController alloc]init];
            goldBuyVisitedStatusVC.delegate = self;
            goldBuyVisitedStatusVC.diction = institutionsArray[rowTag];
            
            [self.navigationController pushViewController:goldBuyVisitedStatusVC animated:YES];
        }
    }else
    {
        if (alertView.tag == 9000) {
            //完善资料
//            MyPersonCenterViewController *myPersonCenterVC = [[MyPersonCenterViewController alloc]init];
//            [self.navigationController pushViewController:myPersonCenterVC animated:YES];
            MypersonCenterDetialsViewController *mypersonCenterDetialsVC = [[MypersonCenterDetialsViewController alloc]init];
            [self.navigationController pushViewController:mypersonCenterDetialsVC animated:YES];
        }else if (alertView.tag == 9001)
        {
            //金币购买，确认加入
            [self addDepartmentGroupWithType:@"1" WithVip:NO];
            
        }else if (alertView.tag == 9004)
        {
            //去升级VIP
            
            UpgradeVIPViewController *UpgradeVIPVC = [[UpgradeVIPViewController alloc]init];
            [self.navigationController pushViewController:UpgradeVIPVC animated:YES];
            
        }else if (alertView.tag == 9003)
        {
            //去升级VIP
            
            UpgradeVIPViewController *UpgradeVIPVC = [[UpgradeVIPViewController alloc]init];
            [self.navigationController pushViewController:UpgradeVIPVC animated:YES];
            
        }

        
    }
}

#pragma mark - 购买资格
- (void)setStyleValueWith:(NSString *)goldStyle
{
    [self addDepartmentGroupWithType:goldStyle WithVip:NO];
}

#pragma mark - 申请加入
- (void)addDepartmentGroupWithType:(NSString *)type WithVip:(BOOL)vip
{
    [BCHTTPRequest addThemeGroupWithTheme_id:[NSString stringWithFormat:@"%@",institutionsArray[rowTag][@"id"]] WithType:type usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            
            if (vip == YES) {
                [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"申请成功，等待审核"];
                [institutionsTableView reloadData];
            }else
            {
                [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"加入成功"];
                
                [institutionsArray[rowTag] removeObjectForKey:@"is_add"];
                
                [institutionsArray[rowTag] setValue:@"1" forKey:@"is_add"];
                
                [institutionsTableView reloadData];
            }
            
        }
    }];

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
    
	[institutionsTableView addSubview:_refreshHeaderView];
    
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:institutionsTableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:institutionsTableView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(institutionsTableView.contentSize.height, institutionsTableView.frame.size.height);
    
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              institutionsTableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         institutionsTableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [institutionsTableView addSubview:_refreshFooterView];
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
    
    
    [self getDataWithNum:pageNumber];
    
    
    //[self testFinishedLoadData];
	
}
//加载调用的方法
-(void)getNextPageView
{
    pageNumber += 1;
    
    [self getDataWithNum:pageNumber];
    
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
