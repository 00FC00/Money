//
//  ThemeMainMembersViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-8-1.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "ThemeMainMembersViewController.h"
#import "LineMainMemberCell.h"
#import "MySweepViewController.h"

#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "GlobalVariable.h"

#import "OtherPeopleMessageDetialsViewController.h"
@interface ThemeMainMembersViewController ()

@end

@implementation ThemeMainMembersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:249.0f/255.0f blue:251.0f/255.0f alpha:1.0];
    
    _collectionView = [[PSCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,IS_IOS_7?self.view.frame.size.height:self.view.frame.size.height-20)];
    _collectionView.collectionViewDelegate = self;
    _collectionView.collectionViewDataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _collectionView.numColsPortrait = 4;
    _collectionView.numColsLandscape = 4;
    [self.view addSubview:_collectionView];

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
            
            [_collectionView reloadData];
            [self removeFooterView];
            [self testFinishedLoadData];
        }
    }];
    
}
#pragma mark - PSCollectionViewDelegate and DataSource
- (NSInteger)numberOfViewsInCollectionView:(PSCollectionView *)collectionView {
    
    return [themeArray count];
}

- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView viewAtIndex:(NSInteger)index {
    
    LineMainMemberCell *cell = (LineMainMemberCell *)[self.collectionView dequeueReusableView];
    if (!cell) {
        cell = [[LineMainMemberCell alloc] initWithFrame:CGRectZero];
    }
    
    NSDictionary *item = [themeArray objectAtIndex:index];
    cell.cellBackImageView.frame = CGRectMake(0, 0, 160/2, 203/2);
    
    if (index % 4 ==0) {
        cell.headImageView.frame = CGRectMake(36/2, 37/2, 122/2, 122/2);
        
        cell.nameLabel.frame = CGRectMake(36/2, 170/2, 122/2, 30/2);
    }else if (index % 4 ==1)
    {
        cell.headImageView.frame = CGRectMake(28/2, 37/2, 122/2, 122/2);
        
        cell.nameLabel.frame = CGRectMake(28/2, 170/2, 122/2, 30/2);
    }else if (index % 4 ==2)
    {
        cell.headImageView.frame = CGRectMake(14/2, 37/2, 122/2, 122/2);
        cell.nameLabel.frame = CGRectMake(14/2, 170/2, 122/2, 30/2);
    }else if (index % 4 ==3)
    {
        cell.headImageView.frame = CGRectMake(0/2, 37/2, 122/2, 122/2);
        cell.nameLabel.frame = CGRectMake(0/2, 170/2, 122/2, 30/2);
    }
    [cell.headImageView setImageWithURL:[NSURL URLWithString:item[@"user_logo"]] placeholderImage:[UIImage imageNamed:@"touxiangmoren@2x"]];
    cell.nameLabel.text = item[@"user_name"];
    
    return cell;
}


- (CGFloat)heightForViewAtIndex:(NSInteger)index {
    return (136+37+30)/2;
}

- (void)collectionView:(PSCollectionView *)collectionView didSelectView:(PSCollectionViewCell *)view atIndex:(NSInteger)index {
    
    NSDictionary *item = [themeArray objectAtIndex:index];
    GlobalVariable *globalVariable = [GlobalVariable sharedGlobalVariable];
    
    if ([globalVariable.themeis_memberString integerValue]==0) {
        ///进入加站内联系人页面
        OtherPeopleMessageDetialsViewController *otherPeopleMessageDetialsVC = [[OtherPeopleMessageDetialsViewController alloc] init];
        otherPeopleMessageDetialsVC.friendIdString = item[@"user_id"];
        otherPeopleMessageDetialsVC.isInHere = @"yes";
        [self.navigationController pushViewController:otherPeopleMessageDetialsVC animated:YES];
        
    }else
    {

    MySweepViewController *mySweepVC = [[MySweepViewController alloc]init];
    mySweepVC.fromString = @"群成员";
    mySweepVC.friendIdString = item[@"user_id"];
    mySweepVC.groupIdString = _themeIdString;
    mySweepVC.groupTypeString = @"3";
    [self.navigationController pushViewController:mySweepVC animated:YES];

    
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
    
	[self.collectionView addSubview:_refreshHeaderView];
    
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_collectionView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_collectionView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(_collectionView.contentSize.height, _collectionView.frame.size.height);
    
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              _collectionView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         _collectionView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [_collectionView addSubview:_refreshFooterView];
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
    
    themeArray = [[NSMutableArray alloc] initWithCapacity:100];
    [self getDataWithNum:pageNumber];
    
    
    [self testFinishedLoadData];
	
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
