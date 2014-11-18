//
//  LineDynamicViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-27.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "LineDynamicViewController.h"
#import "InstitutionsDynamicCell.h"
#import "FaceBookDynamicDetialsViewController.h"

#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "GlobalVariable.h"

@interface LineDynamicViewController ()

@end

@implementation LineDynamicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        lineArray = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0];
    //动态列表lineDynamicTableView;
    lineDynamicTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height-37-64) style:UITableViewStylePlain];
    lineDynamicTableView.delegate = self ;
    lineDynamicTableView.dataSource = self ;
    lineDynamicTableView.backgroundView = nil ;
    
    lineDynamicTableView.backgroundColor = [UIColor clearColor];
    lineDynamicTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:lineDynamicTableView];
    
    GlobalVariable *globalVariable = [GlobalVariable sharedGlobalVariable];
    _departmentIdString = globalVariable.departmentIdString;
    
    if ([globalVariable.lineis_memberString integerValue] == 1) {
        pageNumber =1;
        //根据分类获取数据
        
        [self getDataWithNum:pageNumber];
        
        [self createHeaderView];
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"LineReload" object:nil queue:nil usingBlock:^(NSNotification *note) {
        pageNumber = 1;
        [self getDataWithNum:pageNumber];
    }];
}

#pragma mark - 获取数据
- (void)getDataWithNum:(NSInteger)num
{
    [BCHTTPRequest getGroupsDepartmentActionListWithDid:_departmentIdString WithPage:num usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            if (num == 1) {
                lineArray = [[NSMutableArray alloc] initWithCapacity:100];
            }
            
            if ([resultDic[@"list"] count] > 0) {
                
                [lineArray addObjectsFromArray:resultDic[@"list"]];
                
            }
            
            [lineDynamicTableView reloadData];
            [self removeFooterView];
            [self testFinishedLoadData];
        }

    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return lineArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([lineArray[indexPath.row][@"pictures"] count] > 0) {
        return 173;
    }else
    {
        return 93;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
    InstitutionsDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
    if (cell == nil) {
        cell = [[InstitutionsDynamicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    pictureArray = lineArray[indexPath.row][@"pictures"];
    
    if (pictureArray.count > 0) {
        cell.cellBackImageView.frame = CGRectMake(10, 20/2, 301, 163);
        //[cell.cellBackImageView setImage:[UIImage imageNamed:@"dongtaicell1@2x"]];
    }else
    {
        cell.cellBackImageView.frame = CGRectMake(10, 20/2, 301, 83);
       // [cell.cellBackImageView setImage:[UIImage imageNamed:@"dongtaicell2@2x"]];
    }
    [cell.markHeaderBackImageView setImage:[UIImage imageNamed:@"dongtaitouxiangbeijing@2x"]];
    
    [cell.headerImageView setImageWithURL:[NSURL URLWithString:lineArray[indexPath.row][@"user_logo"]] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
    cell.markTitleLabel.text = lineArray[indexPath.row][@"user_name"];
    cell.markTimeLabel.text = lineArray[indexPath.row][@"add_time"];
    [cell.replyImageView setImage:[UIImage imageNamed:@"huifutubiao@2x"]];
    
    cell.cutOffLineImageView.frame = CGRectMake(44, 35, cell.cellBackImageView.frame.size.width-44, 2/2);
    [cell.cutOffLineImageView setImage:[UIImage imageNamed:@"shouyecellxian@2x"]];

    
    cell.contectLabel.numberOfLines = 0;
    NSString *str1 = lineArray[indexPath.row][@"content"];
    CGSize size1;
    //***********ios7的方法
    if (IS_IOS_7)
    {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        size1 = [str1 boundingRectWithSize:CGSizeMake(252, 70/2) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    }else
    {
        //***********ios6的方法
        size1 = [str1 sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(252,70/2) lineBreakMode:NSLineBreakByWordWrapping];
    }
    cell.contectLabel.frame =CGRectMake(47, 46, 252, size1.height);
    cell.contectLabel.text = str1;

    
    
    
    //根据图片的数组加载图片
    for (UIView * sview in cell.photoBackImageView.subviews) {
        if (sview.tag >= 10000000) {
            [sview removeFromSuperview];
        }
    }
    
    if (pictureArray.count > 0) {
        cell.photoBackImageView.frame = CGRectMake(6, cell.contectLabel.frame.origin.y+cell.contectLabel.frame.size.height+5, 588/2, 147/2);
        for (int k = 0; k < pictureArray.count; k++) {
            UIImageView *picImageView = [[UIImageView alloc]initWithFrame:CGRectMake(44+(126/2)*(k%4), 4, 120/2, 120/2)];
            picImageView.backgroundColor = [UIColor clearColor];
            picImageView.userInteractionEnabled = YES;
            picImageView.tag = 10000000+k;
            [picImageView setImageWithURL:[NSURL URLWithString:pictureArray[k][@"logo"]] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
            [cell.photoBackImageView addSubview:picImageView];
        }
        
    }else
    {
        cell.photoBackImageView.frame = CGRectMake(6, 210/2, 0, 1);
        //根据图片的数组加载图片
        for (UIView * sview in cell.photoBackImageView.subviews) {
            if (sview.tag >= 10000000) {
                [sview removeFromSuperview];
            }
        }
        
        
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    FaceBookDynamicDetialsViewController *faceBookDynamicDetialsVC = [[FaceBookDynamicDetialsViewController alloc]init];
    faceBookDynamicDetialsVC.aidString = lineArray[indexPath.row][@"id"];
    faceBookDynamicDetialsVC.iIdString = _departmentIdString;
    faceBookDynamicDetialsVC.fromString = @"条线动态";
    
    [self.navigationController pushViewController:faceBookDynamicDetialsVC animated:YES];
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
    
	[lineDynamicTableView addSubview:_refreshHeaderView];
    
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:lineDynamicTableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:lineDynamicTableView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(lineDynamicTableView.contentSize.height, lineDynamicTableView.frame.size.height);
    
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              lineDynamicTableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         lineDynamicTableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [lineDynamicTableView addSubview:_refreshFooterView];
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
