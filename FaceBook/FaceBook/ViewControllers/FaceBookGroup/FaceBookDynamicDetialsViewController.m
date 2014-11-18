//
//  FaceBookDynamicDetialsViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-30.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "FaceBookDynamicDetialsViewController.h"
#import "FaceBookDynamicDetialsCell.h"
#import <QuartzCore/QuartzCore.h>

#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "DMCAlertCenter.h"

#import "PictureDetialsViewController.h"

@interface FaceBookDynamicDetialsViewController ()
{
    //头像
    UIImageView *userHeadImageView;
    //用户名
    UILabel *nameLabel;
   
    //内容
    UILabel *contectLabel;
    UIImageView *pictureBackImageView;
    //回复字段
    UILabel *markreplyLabel;
    
    //时间
    UILabel *timeLabel;
    
    NSMutableArray *pictureStrArray;
    
}
@end

@implementation FaceBookDynamicDetialsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pictureArray = [[NSMutableArray alloc]initWithCapacity:100];
        dynamicDetialsArray = [[NSMutableArray alloc] initWithCapacity:100];
        pictureStrArray = [[NSMutableArray alloc]initWithCapacity:100];
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
    self.title = @"动态详情";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //详情
    dynamicetialsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64-49) style:UITableViewStylePlain];
    dynamicetialsTableView.backgroundColor = [UIColor clearColor];
    dynamicetialsTableView.delegate = self;
    dynamicetialsTableView.dataSource = self;

    dynamicetialsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:dynamicetialsTableView];
    
    [self getHeadViewData];

    pageNumber = 1;
    [self getDataWithNum:pageNumber];
    
    [self createHeaderView];
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    
    //评论框
    commentBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,IS_IOS_7?self.view.frame.size.height-98/2-64:self.view.frame.size.height-98/2-44, self.view.frame.size.width, 98/2)];
    commentBackgroundImageView.image = [UIImage imageNamed:@"zixunpinglunshurukang@2x"];
    commentBackgroundImageView.userInteractionEnabled = YES;
    [self.view addSubview:commentBackgroundImageView];
    
    //评论
    commentTextView = [[UITextView alloc]initWithFrame:CGRectMake(24, 8, 520/2, 27)];
    commentTextView.backgroundColor = [UIColor clearColor];
    commentTextView.delegate = self;
    commentTextView.font = [UIFont systemFontOfSize:14];
    commentTextView.returnKeyType = UIReturnKeyDone;
    [commentBackgroundImageView addSubview:commentTextView];
    
    //TextView占位符
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 3, 240, 25)];
    placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    placeHolderLabel.font = [UIFont systemFontOfSize:14.0f];
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    placeHolderLabel.backgroundColor = [UIColor clearColor];
    placeHolderLabel.alpha = 0;
    placeHolderLabel.tag = 999;
    placeHolderLabel.text = @"我也说两句";
    [commentTextView addSubview:placeHolderLabel];
    if ([[commentTextView text] length] == 0) {
        [[commentTextView viewWithTag:999] setAlpha:1];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //点击背景取消键盘
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(handleBackgroundTap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [dynamicetialsTableView addGestureRecognizer:tapRecognizer];

    
}
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取信息
- (void)getDataWithNum:(int)num
{
    [BCHTTPRequest getGroupsWithFromDetail:_fromString WithAid:_aidString WithPage:num usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            if (num == 1) {
                //wallDetailsDic = [resultDic mutableCopy];
                [userHeadImageView setImageWithURL:[NSURL URLWithString:resultDic[@"action_info"][@"user_logo"]] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
                nameLabel.text = resultDic[@"action_info"][@"user_name"];
                
                NSString *contentString = resultDic[@"action_info"][@"content"];
                CGSize contentSize = [contentString sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(586/2,2000) lineBreakMode:NSLineBreakByWordWrapping];
                contectLabel.frame =CGRectMake(28/2,172/2, 586/2, contentSize.height);
                contectLabel.text = contentString;
                
                //图片
                if (pictureStrArray.count > 0) {
                    [pictureStrArray removeAllObjects];
                }
                if (pictureArray.count > 0) {
                    [pictureArray removeAllObjects];
                }
                pictureArray = resultDic[@"action_info"][@"pictures"];
                
                if (pictureArray.count > 0 ) {
                    pictureBackImageView.frame = CGRectMake(0, contectLabel.frame.origin.y+contectLabel.frame.size.height+5, 320, 72);
                    
                    for (int i = 0; i < pictureArray.count; i++) {
                        UIImageView *photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10+76*(i%4), 0, 72, 72)];
                        photoImageView.backgroundColor = [UIColor clearColor];
                        [photoImageView setImageWithURL:[NSURL URLWithString:pictureArray[i][@"logo"]] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
                        photoImageView.userInteractionEnabled = YES;
                        [pictureBackImageView addSubview:photoImageView];
                        
                        [pictureStrArray addObject:pictureArray[i][@"logo"]];
                        
                        UIButton *pictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        pictureButton.frame = CGRectMake(0, 0, 72, 72);
                        pictureButton.backgroundColor = [UIColor clearColor];
                        pictureButton.tag = 5000+i;
                        [pictureButton addTarget:self action:@selector(clickPictureButton:) forControlEvents:UIControlEventTouchUpInside];
                        [photoImageView addSubview:pictureButton];
                    }
                    
                }else
                {
                    pictureBackImageView.frame = CGRectMake(0, contectLabel.frame.origin.y+contectLabel.frame.size.height+5, 320, 1);
                }

                
                //回复
                markreplyLabel.frame = CGRectMake(540/2, pictureBackImageView.frame.origin.y+pictureBackImageView.frame.size.height+5, 62/2, 30/2);
                
                //时间
                timeLabel.frame = CGRectMake(30/2, pictureBackImageView.frame.origin.y+pictureBackImageView.frame.size.height+5, 510/2, 26/2);
                timeLabel.text = resultDic[@"action_info"][@"add_time"];
                
                
                _lineImageView.frame =  CGRectMake(10, pictureBackImageView.frame.origin.y+pictureBackImageView.frame.size.height+26, 600/2, 1);
                imgView.frame = CGRectMake(0, 0, 320, _lineImageView.frame.origin.y+1);
                
                dynamicetialsTableView.tableHeaderView = imgView;
                
                
                dynamicDetialsArray = [[NSMutableArray alloc] initWithCapacity:100];
                
            }
            
            [dynamicDetialsArray addObjectsFromArray:resultDic[@"comment_list"]];
        }
        
        [dynamicetialsTableView reloadData];
        [self removeFooterView];
        [self testFinishedLoadData];
    }];

}

//取消键盘
- (void) handleBackgroundTap:(UITapGestureRecognizer*)sender
{
    [commentTextView resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        commentBackgroundImageView.frame = CGRectMake(0,self.view.frame.size.height-98/2, self.view.frame.size.width, 98/2);
    }];
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        if ([textView.text length] > 0) {
            
            [BCHTTPRequest GetGroupsWithFromComment:_fromString WithIid:_iIdString WithAid:_aidString WithContent:[textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                if (isSuccess == YES) {
                    pageNumber = 1;
                    [self getDataWithNum:pageNumber];
                    
                    commentTextView.text = @"";
                    [[commentTextView viewWithTag:999] setAlpha:1];
                }
            }];
            
        }
        
        return NO;
    }
    return YES;
    
}
//输入框要编辑的时候
- (void)textChanged:(NSNotification *)notification
{
    if ([[commentTextView text] length] == 0) {
        [[commentTextView viewWithTag:999] setAlpha:1];
    }
    else {
        [[commentTextView viewWithTag:999] setAlpha:0];
    }
    
    
    
}
#pragma mark -键盘通知
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    // 键盘信息字典
    NSValue *keyboardBoundsValue = [[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
    NSLog(@"height = %f",keyboardBounds.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        commentBackgroundImageView.frame = CGRectMake(0,self.view.frame.size.height-keyboardBounds.size.height-98/2, self.view.frame.size.width, 98/2);
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.3 animations:^{
        commentBackgroundImageView.frame = CGRectMake(0,self.view.frame.size.height-98/2, self.view.frame.size.width, 98/2);
    }];
}



- (void)getHeadViewData
{
    imgView = [[UIImageView alloc]init];
    imgView.backgroundColor = [UIColor clearColor];
    imgView.userInteractionEnabled = YES;
    
    //头像userHeadImageView;
    userHeadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 132/2, 132/2)];
    userHeadImageView.backgroundColor = [UIColor clearColor];
    [userHeadImageView.layer setMasksToBounds:YES];
    [userHeadImageView.layer setCornerRadius:3.0f];
    //[userHeadImageView setImage:[UIImage imageNamed:@"ceshi@2x"]];
    [imgView addSubview:userHeadImageView];
    
    //用户名nameLabel;
    nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(170/2, 34/2, 442/2, 32/2)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor colorWithRed:111.0f/255.0f green:111.0f/255.0f blue:111.0f/255.0f alpha:1];
    nameLabel.font = [UIFont systemFontOfSize:15];
    //nameLabel.text = @"北京蓝凌科技有限公司ios研发部";
    [imgView addSubview:nameLabel];
    
    //内容contectLabel;
    contectLabel=[[UILabel alloc]init];
    contectLabel.backgroundColor = [UIColor clearColor];
    contectLabel.textAlignment = NSTextAlignmentLeft;
    contectLabel.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1];
    contectLabel.font = [UIFont systemFontOfSize:15];
    contectLabel.numberOfLines = 0;
    [imgView addSubview:contectLabel];
    
    pictureBackImageView = [[UIImageView alloc]init];
    pictureBackImageView.backgroundColor = [UIColor clearColor];
    pictureBackImageView.userInteractionEnabled = YES;
    [imgView addSubview:pictureBackImageView];
    
    
    
    //回复标记字段
    markreplyLabel=[[UILabel alloc]initWithFrame:CGRectMake(540/2, pictureBackImageView.frame.origin.y+pictureBackImageView.frame.size.height+5, 62/2, 30/2)];
    markreplyLabel.backgroundColor = [UIColor clearColor];
    markreplyLabel.textAlignment = NSTextAlignmentLeft;
    markreplyLabel.textColor = [UIColor lightGrayColor];
    markreplyLabel.font = [UIFont systemFontOfSize:14];
    markreplyLabel.text = @"回复";
    [imgView addSubview:markreplyLabel];
    
    //时间timeLabel;
    timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(30/2, pictureBackImageView.frame.origin.y+pictureBackImageView.frame.size.height+5, 510/2, 26/2)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.text = @"2014-04-18 16:33:33";
    [imgView addSubview:timeLabel];
    
    //下划线
    _lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, pictureBackImageView.frame.origin.y+pictureBackImageView.frame.size.height+26, 600/2, 1)];
    _lineImageView.backgroundColor = [UIColor lightGrayColor];
    _lineImageView.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:214.0f/255.0f blue:218.0f/255.0f alpha:1];
    _lineImageView.userInteractionEnabled = YES;
    [imgView addSubview:_lineImageView];
    
    
    
    imgView.frame = CGRectMake(0, 0, 320,_lineImageView.frame.origin.y+_lineImageView.frame.size.height);
    dynamicetialsTableView.tableHeaderView = imgView;
}
#pragma mark - 点击图片事件
- (void)clickPictureButton:(UIButton *)picButton
{
    PictureDetialsViewController *pictureDetialsVC = [[PictureDetialsViewController alloc]init];
    
    pictureDetialsVC.allPicArray = pictureStrArray;
    pictureDetialsVC.myPage =[NSString stringWithFormat:@"%lu",picButton.tag%1000];
    
    [self.navigationController pushViewController:pictureDetialsVC animated:YES];
}
#pragma mark - tableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *contentString = dynamicDetialsArray[indexPath.row][@"content"];
    CGSize contentSize = [contentString sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(440/2, 100000) lineBreakMode:NSLineBreakByWordWrapping];
    if (contentSize.height > 98/2) {
        return contentSize.height+ 50/2 +8;
    }else
    {
        return 164/2;
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dynamicDetialsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
    FaceBookDynamicDetialsCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
    if (cell == nil) {
        cell = [[FaceBookDynamicDetialsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.headImageView setImageWithURL:[NSURL URLWithString:dynamicDetialsArray[indexPath.row][@"user_logo"]] placeholderImage:[UIImage imageNamed:@"ceshi,jpg"]];
    cell.headImageView.backgroundColor = [UIColor grayColor];
    
    cell.nameLabel.text = dynamicDetialsArray[indexPath.row][@"user_name"];
    
    NSString *contentString = dynamicDetialsArray[indexPath.row][@"content"];
    CGSize contentSize = [contentString sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(440/2, 100000) lineBreakMode:NSLineBreakByWordWrapping];
    cell.contentLable.frame = CGRectMake(cell.nameLabel.frame.origin.x, cell.nameLabel.frame.origin.y+ cell.nameLabel.frame.size.height, 440/2, contentSize.height);
    [cell.contentLable setNumberOfLines:0];
    cell.contentLable.text = contentString;
    
    cell.timeLabel.text = dynamicDetialsArray[indexPath.row][@"add_time"];
    
    if (contentSize.height > 98/2) {
        cell.lineImageView.frame = CGRectMake(30/2, cell.contentLable.frame.origin.y+contentSize.height+8, 280, 1);
    }else
    {
        cell.lineImageView.frame = CGRectMake(30/2, cell.headImageView.frame.origin.y+cell.headImageView.frame.size.height+5, 280, 1);
    }
    
    
    
    [cell.lineImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
    
	[dynamicetialsTableView addSubview:_refreshHeaderView];
    
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:dynamicetialsTableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:dynamicetialsTableView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(dynamicetialsTableView.contentSize.height, dynamicetialsTableView.frame.size.height);
    
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              dynamicetialsTableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         dynamicetialsTableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [dynamicetialsTableView addSubview:_refreshFooterView];
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
