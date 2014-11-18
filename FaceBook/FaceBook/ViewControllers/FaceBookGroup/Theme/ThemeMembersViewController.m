//
//  ThemeMembersViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-27.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "ThemeMembersViewController.h"
#import "LineMemberCell.h"

#import "MySweepViewController.h"

#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "GlobalVariable.h"

@interface ThemeMembersViewController ()

@end

@implementation ThemeMembersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        themeArray = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:249.0f/255.0f blue:251.0f/255.0f alpha:1.0];
    
    //机构表
    themeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height-37-64) style:UITableViewStylePlain];
    themeTableView.delegate = self ;
    themeTableView.dataSource = self ;
    themeTableView.backgroundView = nil ;
    themeTableView.backgroundColor = [UIColor clearColor];
    themeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:themeTableView];
    
    GlobalVariable *globalVariable = [GlobalVariable sharedGlobalVariable];
    _themeIdString = globalVariable.themeIdString;
    
    if ([globalVariable.themeis_memberString integerValue] == 1) {
        pageNumber =1;
        //根据分类获取数据
        
        [self getDataWithNum:pageNumber];
        
        [self createHeaderView];
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    }
    

    
}
#pragma mark - 获取数据
- (void)getDataWithNum:(NSInteger)num
{
    
    [BCHTTPRequest getGroupsThemeUsersWithTid:_themeIdString WithPage:num usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            if (num == 1) {
                themeArray = [[NSMutableArray alloc] initWithCapacity:100];
            }
            
            if ([resultDic[@"list"] count] > 0) {
                
                [themeArray addObjectsFromArray:resultDic[@"list"]];
                
            }
            
            [themeTableView reloadData];
            [self removeFooterView];
            [self testFinishedLoadData];
        }
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return myActivityArray.count;
    
    return themeArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 156/2;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *SimepleNewsListjmycell = @"SimpleNewsListcells";
    LineMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListjmycell];
    if (cell == nil) {
        cell = [[LineMemberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListjmycell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    [cell.headerImageView setImageWithURL:[NSURL URLWithString:themeArray[indexPath.row][@"user_logo"]] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
    cell.headButton.tag = indexPath.row;
    [cell.headButton addTarget:self action:@selector(clickHeadButton:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.titleLabel.text = themeArray[indexPath.row][@"user_name"];
    cell.companyLabel.text = [NSString stringWithFormat:@"公司：%@",themeArray[indexPath.row][@"user_com"]];
    
    [cell.lineImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];
    
    return cell;

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 点击头像
- (void)clickHeadButton:(UIButton *)button
{
    MySweepViewController *mySweepVC = [[MySweepViewController alloc]init];
    mySweepVC.fromString = @"群成员";
    mySweepVC.friendIdString = themeArray[button.tag][@"user_id"];
    mySweepVC.groupIdString = _themeIdString;
    mySweepVC.groupTypeString = @"3";
    [self.navigationController pushViewController:mySweepVC animated:YES];
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
    
	[themeTableView addSubview:_refreshHeaderView];
    
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:themeTableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:themeTableView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(themeTableView.contentSize.height, themeTableView.frame.size.height);
    
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              themeTableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         themeTableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [themeTableView addSubview:_refreshFooterView];
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
