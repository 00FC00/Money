//
//  MyWallViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-16.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "MyWallViewController.h"
#import "TopToolCell.h"
#import "PublicWallCell.h"
#import "WallDetialsViewController.h"

#import "BCHTTPRequest.h"
#import "AFNetworking.h"


@interface MyWallViewController ()

@end

@implementation MyWallViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        myWallArray = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0];
    
    //下方的数据表
    myWallTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-64-98/2) style:UITableViewStylePlain];
    myWallTableView.backgroundColor = [UIColor clearColor];
    myWallTableView.delegate = self;
    myWallTableView.dataSource = self;
    myWallTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myWallTableView.tag = 7001;
    [self.view addSubview:myWallTableView];

    pageNumber = 1;
    [self getDataWithNmu:pageNumber];

    [self createHeaderView];
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
}

//获取数据
- (void)getDataWithNmu:(NSInteger)num
{
    [BCHTTPRequest getMyBusinessListWithPage:num usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            if ([resultDic[@"list"] count] > 0) {
                if (num == 1) {
                    myWallArray = [[NSMutableArray alloc] initWithCapacity:100];
                    
                }
                
                [myWallArray addObjectsFromArray:resultDic[@"list"]];
                
            }
            [myWallTableView reloadData];
            [self removeFooterView];
            [self testFinishedLoadData];
        }
    }];
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str1 = myWallArray[indexPath.row][@"content"];
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

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return myWallArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Cellsimple = @"Cellsimple";
    PublicWallCell *pcell = [tableView dequeueReusableCellWithIdentifier:Cellsimple];
    if (pcell == nil) {
        pcell = [[PublicWallCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:Cellsimple];
    }
    pcell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    pcell.backgroundColor = [UIColor clearColor];
    NSString *strf = myWallArray[indexPath.row][@"content"];
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
    [pcell.headImageView setImageWithURL:[NSURL URLWithString:myWallArray[indexPath.row][@"user_logo"]] placeholderImage:[UIImage imageNamed:@""]];
    
    pcell.titleLabel.frame = CGRectMake(134/2, 20/2, 454/2, 30/2);
    pcell.titleLabel.text = myWallArray[indexPath.row][@"user_nickname"];
    
    pcell.companyLabel.frame = CGRectMake(134/2, pcell.titleLabel.frame.origin.y+pcell.titleLabel.frame.size.height+7, 454/2, 28/2);
    pcell.companyLabel.text = myWallArray[indexPath.row][@"company"];
    
    pcell.departmentLabel.frame = CGRectMake(134/2, pcell.companyLabel.frame.origin.y+pcell.companyLabel.frame.size.height+3, 454/2, 26/2);
    pcell.departmentLabel.text = myWallArray[indexPath.row][@"department"];
    
    pcell.numberLabel.frame = CGRectMake(134/2, pcell.departmentLabel.frame.origin.y+pcell.departmentLabel.frame.size.height+2, 454/2, 28/2);
    pcell.numberLabel.text = [NSString stringWithFormat:@"%@人已认证ta的身份",myWallArray[indexPath.row][@"accept_number"]];
    
    pcell.addressLabel.frame = CGRectMake(134/2, pcell.numberLabel.frame.origin.y+pcell.numberLabel.frame.size.height+2, 454/2, 28/2);
    pcell.addressLabel.text = myWallArray[indexPath.row][@"work_city"];
    
    pcell.cutOffLineImageView.frame = CGRectMake(0, 206/2, pcell.cellBackImageView.frame.size.width, 2/2);
    [pcell.cutOffLineImageView setImage:[UIImage imageNamed:@"shouyecellxian@2x"]];
    
    pcell.markContentLabel.frame = CGRectMake(20/2, pcell.addressLabel.frame.origin.y+pcell.addressLabel.frame.size.height+15, 454/2, 30/2);
    pcell.markContentLabel.text = myWallArray[indexPath.row][@"title"];
    
    pcell.contectLabel.numberOfLines = 0;
    NSString *contentString = myWallArray[indexPath.row][@"content"];
    
    CGSize contentSize = [contentString sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(566/2,500) lineBreakMode:NSLineBreakByWordWrapping];
    //********************
    pcell.contectLabel.frame =CGRectMake(10/2,pcell.markContentLabel.frame.origin.y+pcell.markContentLabel.frame.size.height+6, 566/2, contentSize.height);
    pcell.contectLabel.text = contentString;
    
    
    return pcell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        WallDetialsViewController *wallDetialsVC = [[WallDetialsViewController alloc]init];
    wallDetialsVC.wallIdString = myWallArray[indexPath.row][@"id"];
        [self.navigationController pushViewController:wallDetialsVC animated:YES];
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
    
	[myWallTableView addSubview:_refreshHeaderView];
    
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:myWallTableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:myWallTableView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(myWallTableView.contentSize.height, myWallTableView.frame.size.height);
    
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              myWallTableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         myWallTableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [myWallTableView addSubview:_refreshFooterView];
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
    
    
    [self getDataWithNmu:pageNumber];
    
    
    //[self testFinishedLoadData];
	
}
//加载调用的方法
-(void)getNextPageView
{
    pageNumber += 1;
    
    [self getDataWithNmu:pageNumber];
    
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
