//
//  InformationMainViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-7-28.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "InformationMainViewController.h"
#import "AppDelegate.h"


#import "SettingViewController.h"
#import "InformationMainCell.h"
#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "DMCAlertCenter.h"
#import "InformationDetailViewController.h"
#import "SUNViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "InformationCommentViewController.h"

@interface InformationMainViewController ()
{
    
}
@end

@implementation InformationMainViewController
@synthesize listArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        listArray = [[NSArray alloc] init];
        inforArray = [[NSMutableArray alloc]initWithCapacity:100];
        //typeStrId = [[NSString alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0];
    CGFloat orgin_y =0.0;
    if (IS_IOS_7) {
        orgin_y =64.0;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        orgin_y =44.0;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"部落资讯";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 22, 40, 40);
    [menuButton setBackgroundImage:[UIImage imageNamed:@"caidan@2x"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //设置
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(526/2, 22, 80/2, 80/2);
    [setButton setBackgroundImage:[UIImage imageNamed:@"shezhianniu@2x"] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(setButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:setButton];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;
    
    //分类按钮
    newsClassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    newsClassButton.frame = CGRectMake(524/2, 10/2, 100/2, 60/2);
    [newsClassButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newsClassButton setTitle:@"分类" forState:UIControlStateNormal];
    newsClassButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [newsClassButton setBackgroundImage:[UIImage imageNamed:@"zixunfenleianniu@2x"] forState:UIControlStateNormal];
    [newsClassButton addTarget:self action:@selector(clickNewsClassButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newsClassButton];
    
   
    //下拉框
    listBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(437/2, 70/2, 188/2, 420/2)];
    listBackImageView.backgroundColor = [UIColor clearColor];
    [listBackImageView setImage:[UIImage imageNamed:@"zixunfenleixiala@2x"]];
    listBackImageView.userInteractionEnabled = YES;
    [self.view addSubview:listBackImageView];
    [self.view bringSubviewToFront:listBackImageView];
    listBackImageView.hidden = YES;
    //下拉表
    listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, listBackImageView.frame.size.width, listBackImageView.frame.size.height) style:UITableViewStylePlain];
    listTableView.backgroundView = nil;
    listTableView.backgroundColor = [UIColor clearColor];
    listTableView.delegate = self;
    listTableView.dataSource = self;
    listTableView.tag = 7000;
    listTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, listBackImageView.frame.size.width, 15)];
    listTableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    listTableView.separatorColor = [UIColor colorWithRed:147.0f/255.0f green:147.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    if (IS_IOS_7) {
        listTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [listBackImageView addSubview:listTableView];
    
    //***********
    //下拉框数据
    //**************
    [BCHTTPRequest GetTheNewsClassListsUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            listArray = resultDic[@"list"];
            typeStrId = resultDic[@"list"][0][@"id"];
            pageNumber =1;
            
            [self getDataWithNum:pageNumber WithTypeId:typeStrId];
            [self createHeaderView];
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
            [listTableView reloadData];
        }
    }];
    
    //咨询表
    informationMainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,70/2, self.view.frame.size.width,IS_IOS_7?self.view.frame.size.height-64-35:self.view.frame.size.height-44-35) style:UITableViewStylePlain];
    informationMainTableView.backgroundView = nil;
    informationMainTableView.backgroundColor = [UIColor clearColor];
    informationMainTableView.delegate = self;
    informationMainTableView.dataSource = self;
    informationMainTableView.tag = 9000;
    informationMainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:informationMainTableView];
    [self.view sendSubviewToBack:informationMainTableView];

   
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"refushFaceData" object:nil queue:nil usingBlock:^(NSNotification *note) {
    
     
     pageNumber = 1;
     [self getDataWithNum:pageNumber WithTypeId:typeStrId];
     
   }];

    
}
//获取数据
- (void)getDataWithNum:(NSInteger)num WithTypeId:(NSString *)typeId
{
    
    [BCHTTPRequest GetTheNewsListsWithPages:num WithTypeID:typeId usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
    
        if (isSuccess == YES) {
            if ([resultDic[@"list"] count] > 0) {
                if (num == 1) {
                    inforArray = [[NSMutableArray alloc] initWithCapacity:100];
                }
                
                [inforArray addObjectsFromArray:resultDic[@"list"]];
                
            }
            
            [informationMainTableView reloadData];
            [self removeFooterView];
            [self testFinishedLoadData];
        }
        
        
    }];
    
}

#pragma mark - 菜单
- (void)menuButtonClicked
{
    SUNViewController *drawerController = (SUNViewController *)self.navigationController.mm_drawerController;
    
    if (drawerController.openSide == MMDrawerSideNone) {
        [drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            
        }];
    }else if  (drawerController.openSide == MMDrawerSideLeft) {
        [drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            
        }];
    }

}
#pragma mark - 设置
- (void)setButtonClicked
{
    SettingViewController *settingVC = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}
#pragma mark - 分类按钮事件
- (void)clickNewsClassButton
{
    if (isListShow == NO) {
        listBackImageView.hidden = NO;
        isListShow = YES;
    }else if (isListShow == YES)
    {
        listBackImageView.hidden = YES;
        isListShow = NO;
    }
}

#pragma mark - tableViewDelegate
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 7000) {
        return 40;
    }else if (tableView.tag == 9000)
    {
        //242/2+37+number*80/2
        NSMutableArray *numArray = [[NSMutableArray alloc] initWithCapacity:100];
        numArray = inforArray[indexPath.row][@"comments"];
        return 242/2+37+40*[numArray count]+6;
    }
    return NO;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 7000) {
        return listArray.count;
    }else if (tableView.tag == 9000)
    {
        return inforArray.count;
    }
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 7000) {
        static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = listArray[indexPath.row][@"name"];
        
        return cell;

    }else if (tableView.tag == 9000)
    {
        static NSString *SimepleNewsListcell = @"NewsListcells";
        InformationMainCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
        if (cell == nil) {
            cell = [[InformationMainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.cellBackImageView.frame = CGRectMake(15/2, 0, 610/2, 242/2+37+40*[inforArray[indexPath.row][@"comments"] count]);
        //CGRectMake(12/2, 40/2, 572/2, 80/2)
        
        cell.pictureImageView.frame = CGRectMake(0, 0, cell.cellBackImageView.frame.size.width, 242/2);
        [cell.pictureImageView setImageWithURL:[NSURL URLWithString:inforArray[indexPath.row][@"logo"]] placeholderImage:[UIImage imageNamed:@""]];
        
        cell.titleBackImageView.frame = CGRectMake(0, 182/2, cell.pictureImageView.frame.size.width, 60/2);
//        cell.titleLabel.numberOfLines = 0;
        NSString *str1 = inforArray[indexPath.row][@"title"];
//        CGSize size1;
//        //***********ios7的方法
//        if (IS_IOS_7)
//        {
//            NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
//            size1 = [str1 boundingRectWithSize:CGSizeMake(572/2, 60/2) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
//        }else
//        {
//            //***********ios6的方法
//            size1 = [str1 sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(572/2,60/2) lineBreakMode:NSLineBreakByWordWrapping];
//        }
        cell.titleLabel.frame = CGRectMake(10, 16/2, cell.titleBackImageView.frame.size.width-20, 36/2);
        cell.titleLabel.text = str1;
        
        
        [cell.markImageView setImage:[UIImage imageNamed:@"pinglunmarkbiao@2x"]];
        cell.numberLabel.text = [NSString stringWithFormat:@"评论(%@)",inforArray[indexPath.row][@"comments_count"]];
        
        cell.commentBackImageView.frame =CGRectMake(0, 316/2, 610/2, 40*[inforArray[indexPath.row][@"comments"] count]);
        
        for (UIView * sview in cell.commentBackImageView.subviews) {
           // if (sview.tag >= 10000000) {
                [sview removeFromSuperview];
          //  }
        }

        NSMutableArray *mynumArray = [[NSMutableArray alloc] initWithCapacity:100];
        mynumArray = inforArray[indexPath.row][@"comments"];
        
        if ([mynumArray count] > 0) {
            for (int i = 0; i<[mynumArray count]; i++) {
                UIImageView *m_backView = [[UIImageView alloc] initWithFrame:CGRectMake(0,40*i, 610/2, 40)];
                m_backView.backgroundColor = [UIColor clearColor];
                [cell.commentBackImageView addSubview:m_backView];
                
                UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(22/2, 2/2, 60/2, 60/2)];
                headImageView.backgroundColor = [UIColor clearColor];
                [headImageView setImageWithURL:[NSURL URLWithString:mynumArray[i][@"user_logo"]] placeholderImage:[UIImage imageNamed:@"Icon@2x"]];
                [m_backView addSubview:headImageView];
                
                UILabel *commentLabel = [[UILabel alloc] init];
                commentLabel.backgroundColor = [UIColor clearColor];
                commentLabel.textAlignment = NSTextAlignmentLeft;
                commentLabel.textColor = [UIColor darkGrayColor];
                commentLabel.font = [UIFont systemFontOfSize:12];
                commentLabel.numberOfLines = 0;
                
                
                NSString *str2 = mynumArray[i][@"content"];
                CGSize size2;
                //***********ios7的方法
                if (IS_IOS_7)
                {
                    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
                    size2 = [str2 boundingRectWithSize:CGSizeMake(476/2, 58/2) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                }else
                {
                    //***********ios6的方法
                    size2 = [str2 sizeWithFont:[UIFont systemFontOfSize:12]constrainedToSize:CGSizeMake(476/2,58/2) lineBreakMode:NSLineBreakByWordWrapping];
                }
                
                commentLabel.frame = CGRectMake(106/2, 10/2, 476/2, size2.height);
                commentLabel.text = str2;
                [m_backView addSubview:commentLabel];
            }
        }else
        {
            for (UIView * sview in cell.commentBackImageView.subviews) {
                //if (sview.tag >= 10000000) {
                    [sview removeFromSuperview];
               // }
            }

        }
        cell.moreButton.frame = CGRectMake(0, 0, 610/2, 242/2);
        cell.moreButton.tag = 20000+indexPath.row;
        [cell.moreButton addTarget:self action:@selector(clickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.commentButton.frame = CGRectMake(0, 316/2, 610/2, 40*[inforArray[indexPath.row][@"comments"] count]);
        cell.commentButton.tag = 40000+indexPath.row;
         [cell.commentButton addTarget:self action:@selector(clickCommentButton:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    }
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 7000) {
        
        listBackImageView.hidden = YES;
        isListShow = NO;
        
        NSDictionary *dic = [[NSDictionary alloc] init];
        dic = listArray[indexPath.row];
        typeStrId = dic[@"id"];
        
        pageNumber = 1;
        [self getDataWithNum:pageNumber WithTypeId:typeStrId];
    }
}

#pragma mark -咨询详情
- (void)clickMoreButton:(UIButton *)myButton
{
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = inforArray[myButton.tag-20000];
    InformationDetailViewController *informationDetailViewController = [[InformationDetailViewController alloc] init];
    informationDetailViewController.nowPage = myButton.tag-20000;
    informationDetailViewController.allNewsArray = inforArray;
    //        informationDetailViewController.informationId = dict[@"id"];
    //        informationDetailViewController.informationTitle = dict[@"title"];
    //        informationDetailViewController.informationAddTime = dict[@"add_time"];
    [self.navigationController pushViewController:informationDetailViewController animated:YES];

}
#pragma mark - 评论页面
- (void)clickCommentButton:(UIButton *)mySender
{
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = inforArray[mySender.tag-40000];
    InformationCommentViewController *informationCommentViewController = [[InformationCommentViewController alloc] init];
    informationCommentViewController.informationId = dict[@"id"];
    
    
    informationCommentViewController.informationTitle = dict[@"title"];
    informationCommentViewController.informationAddTime = dict[@"add_time"];
    [self.navigationController pushViewController:informationCommentViewController animated:YES];
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
    
	[informationMainTableView addSubview:_refreshHeaderView];
    
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:informationMainTableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:informationMainTableView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(informationMainTableView.contentSize.height, informationMainTableView.frame.size.height);
    
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              informationMainTableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         informationMainTableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [informationMainTableView addSubview:_refreshFooterView];
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
    
    
    [self getDataWithNum:pageNumber WithTypeId:typeStrId];
    
    
    //[self testFinishedLoadData];
	
}
//加载调用的方法
-(void)getNextPageView
{
    pageNumber += 1;
    
    [self getDataWithNum:pageNumber WithTypeId:typeStrId];
    
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
