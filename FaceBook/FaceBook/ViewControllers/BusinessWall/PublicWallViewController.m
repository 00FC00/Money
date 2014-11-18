//
//  PublicWallViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-16.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "PublicWallViewController.h"
#import "TopToolCell.h"
#import "PublicWallCell.h"
#import "WallDetialsViewController.h"

#import "BCHTTPRequest.h"
#import "GlobalVariable.h"
#import "AFNetworking.h"

@interface PublicWallViewController ()

@end

@implementation PublicWallViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       // // Custom initialization
        topToolArray = [[NSMutableArray alloc] initWithCapacity:100];
        dataArray = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0];
    
    //上方的工具栏
    UIImageView *topBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 46)];
    topBackImageView.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0];
    topBackImageView.userInteractionEnabled = YES;
    [self.view addSubview:topBackImageView];
    
    topToolTableView  = [[UITableView alloc] init];
    topToolTableView.backgroundColor = [UIColor whiteColor];
    [topToolTableView.layer setAnchorPoint:CGPointMake(0.0, 0.0)];
    topToolTableView.transform = CGAffineTransformMakeRotation(M_PI/-2);
    topToolTableView.showsVerticalScrollIndicator = NO;
    topToolTableView.frame = CGRectMake(10, 41, 300, 36);
    topToolTableView.rowHeight = 100.0;
    topToolTableView.tag = 2001;
    topToolTableView.delegate = self;
    topToolTableView.dataSource = self;
    [topBackImageView addSubview:topToolTableView];
    
    if (IS_IOS_7) {
        topToolTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    //下方的数据表
    publicWallTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 46, 320, [[UIScreen mainScreen] bounds].size.height-64-97/2-46) style:UITableViewStylePlain];
    publicWallTableView.backgroundColor = [UIColor clearColor];
    publicWallTableView.delegate = self;
    publicWallTableView.dataSource = self;
    publicWallTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    publicWallTableView.tag = 4001;
    [self.view addSubview:publicWallTableView];
    
    

    //请求分类
    GlobalVariable *globalVariable = [GlobalVariable sharedGlobalVariable];
    if (globalVariable.classificationArray == nil) {
        [BCHTTPRequest getBusinessTypeListWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                topToolArray = resultDic[@"list"];
                globalVariable.classificationArray = topToolArray;
                
                [topToolTableView reloadData];
                
                
//                [self getDataWithNum:1 WithTypeId:topToolArray[0][@"id"]];
//                
//                
//                [self createHeaderView];
//                [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];

                
            }
        }];
    }else
    {
        topToolArray = globalVariable.classificationArray;
    }

    
    pageNumber =1;
    //根据分类获取数据
    classificationString = @"";
    [self getDataWithNum:pageNumber WithTypeId:@""];
    
    
    [self createHeaderView];
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    
    
}

//获取数据
- (void)getDataWithNum:(NSInteger)num WithTypeId:(NSString *)typeId
{
    [BCHTTPRequest getBusinessListByTypeWithTypeId:typeId WithPage:num usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            if ([resultDic[@"list"] count] > 0) {
                if (num == 1) {
                    dataArray = [[NSMutableArray alloc] initWithCapacity:100];
                   
                }
                
                [dataArray addObjectsFromArray:resultDic[@"list"]];
                
            }else
            {
                if (num == 1) {
                    [dataArray removeAllObjects];
                    
                }else
                {
                    ;
                }

            }
            
            [publicWallTableView reloadData];
            [self removeFooterView];
            [self testFinishedLoadData];
        }
        
        
    }];

}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 4001) {
        //270/2+
        NSString *str1 = dataArray[indexPath.row][@"content"];
        CGSize size1;
        //***********ios7的方法
        if (IS_IOS_7)
        {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        size1 = [str1 boundingRectWithSize:CGSizeMake(566/2, 140) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        }else
            {
        //***********ios6的方法
        size1 = [str1 sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(566/2,140) lineBreakMode:NSLineBreakByWordWrapping];
            }

        return 135+size1.height+13;
        
    }else
    {
        return 100;
    }
    return NO;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 2001) {
        return topToolArray.count;
    }else if (tableView.tag == 4001)
    {
        return dataArray.count;
    }
    return NO;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (tableView.tag == 2001) {
         static NSString *CellIdentifier = @"Cell";
        TopToolCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[TopToolCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
            cell.selectedBackgroundView.backgroundColor = [UIColor grayColor];
            cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
            cell.markTitleLabel.frame = CGRectMake(0, 5, 100, 26);
            cell.markTitleLabel.textAlignment = NSTextAlignmentCenter;
            cell.markTitleLabel.backgroundColor = [UIColor clearColor];
            cell.markTitleLabel.highlightedTextColor = [UIColor whiteColor];
            
        }
        
        
        
        
        
        cell.markTitleLabel.text = topToolArray[indexPath.row][@"name"];
        return cell;

    }else if (tableView.tag == 4001)
    {
        static NSString *Cellsimple = @"Cellsimple";
        PublicWallCell *pcell = [tableView dequeueReusableCellWithIdentifier:Cellsimple];
        if (pcell == nil) {
            pcell = [[PublicWallCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:Cellsimple];
            pcell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        pcell.backgroundColor = [UIColor clearColor];
        NSString *strf = dataArray[indexPath.row][@"content"];
        CGSize sizef;
        //***********ios7的方法
        if (IS_IOS_7)
        {
            NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
            sizef = [strf boundingRectWithSize:CGSizeMake(566/2, 140) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        }else
        {
            //***********ios6的方法
            sizef = [strf sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(566/2,140) lineBreakMode:NSLineBreakByWordWrapping];
        }
        pcell.cellBackImageView.frame = CGRectMake(10, 10, 300, 135+sizef.height+8);
        pcell.cellBackImageView.backgroundColor = [UIColor whiteColor];
        
        
        //[pcell.headImageView setImage:[UIImage imageNamed:imageStr]];
        pcell.headImageView.frame = CGRectMake(10, 6, 102/2, 102/2);
        [pcell.headImageView setImageWithURL:[NSURL URLWithString:dataArray[indexPath.row][@"user_logo"]] placeholderImage:[UIImage imageNamed:@""]];
        
        pcell.titleLabel.frame = CGRectMake(134/2, 20/2, 454/2, 30/2);
        pcell.titleLabel.text = dataArray[indexPath.row][@"user_nickname"];
        
        pcell.companyLabel.frame = CGRectMake(134/2, pcell.titleLabel.frame.origin.y+pcell.titleLabel.frame.size.height+7, 454/2, 28/2);
        pcell.companyLabel.text = dataArray[indexPath.row][@"company"];
        
        pcell.departmentLabel.frame = CGRectMake(134/2, pcell.companyLabel.frame.origin.y+pcell.companyLabel.frame.size.height+3, 454/2, 26/2);
        pcell.departmentLabel.text = dataArray[indexPath.row][@"department"];
        
        pcell.numberLabel.frame = CGRectMake(134/2, pcell.departmentLabel.frame.origin.y+pcell.departmentLabel.frame.size.height+2, 454/2, 28/2);
        pcell.numberLabel.text = [NSString stringWithFormat:@"%@人已认证ta的身份",dataArray[indexPath.row][@"accept_number"]];
        
        pcell.addressLabel.frame = CGRectMake(134/2, pcell.numberLabel.frame.origin.y+pcell.numberLabel.frame.size.height+2, 454/2, 28/2);
        pcell.addressLabel.text = dataArray[indexPath.row][@"work_city"];
        
        pcell.cutOffLineImageView.frame = CGRectMake(0, 206/2, pcell.cellBackImageView.frame.size.width, 2/2);
        [pcell.cutOffLineImageView setImage:[UIImage imageNamed:@"shouyecellxian@2x"]];
        
        pcell.markContentLabel.frame = CGRectMake(20/2, pcell.addressLabel.frame.origin.y+pcell.addressLabel.frame.size.height+15, 454/2, 30/2);
        pcell.markContentLabel.text = dataArray[indexPath.row][@"title"];
        
        pcell.contectLabel.numberOfLines = 0;
        NSString *contentString = dataArray[indexPath.row][@"content"];
        
        CGSize contentSize = [contentString sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(566/2,140) lineBreakMode:NSLineBreakByWordWrapping];
        //********************
        pcell.contectLabel.frame =CGRectMake(10/2,pcell.markContentLabel.frame.origin.y+pcell.markContentLabel.frame.size.height+6, 566/2, contentSize.height);
        pcell.contectLabel.text = contentString;
        

        return pcell;
    }
    
    return NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 2001) {
        
        pageNumber = 1;
        //获取数据
        [self getDataWithNum:pageNumber WithTypeId:topToolArray[indexPath.row][@"id"]];
        classificationString = topToolArray[indexPath.row][@"id"];
        
    }else if (tableView.tag == 4001)
    {
        WallDetialsViewController *wallDetialsVC = [[WallDetialsViewController alloc]init];
        wallDetialsVC.wallIdString = dataArray[indexPath.row][@"id"];
        [self.navigationController pushViewController:wallDetialsVC animated:YES];
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
    
	[publicWallTableView addSubview:_refreshHeaderView];
    
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:publicWallTableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:publicWallTableView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(publicWallTableView.contentSize.height, publicWallTableView.frame.size.height);
    
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              publicWallTableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         publicWallTableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [publicWallTableView addSubview:_refreshFooterView];
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
    
    
    [self getDataWithNum:pageNumber WithTypeId:classificationString];
    
    
    //[self testFinishedLoadData];
	
}
//加载调用的方法
-(void)getNextPageView
{
    pageNumber += 1;
    
    [self getDataWithNum:pageNumber WithTypeId:classificationString];
    
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
