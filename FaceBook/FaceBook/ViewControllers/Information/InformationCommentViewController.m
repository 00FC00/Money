//
//  InformationCommentViewController.m
//  FaceBook
//
//  Created by HMN on 14-6-26.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "InformationCommentViewController.h"
#import "CommentTableViewCell.h"
#import "BCHTTPRequest.h"
#import "AFNetworking.h"

@interface InformationCommentViewController ()

@end

@implementation InformationCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        commentArray = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:249.0f/255.0f blue:251.0f/255.0f alpha:1.0];
    CGFloat orgin_y =0.0;
    if (IS_IOS_7) {
        orgin_y =64.0;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        orgin_y =44.0;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"评论";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    
    commentTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, IS_IOS_7?self.view.frame.size.height-67-98/2:self.view.frame.size.height-44-98/2)];
    commentTabelView.delegate = self;
    commentTabelView.dataSource = self;
    [self.view addSubview:commentTabelView];
    commentTabelView.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:249.0f/255.0f blue:251.0f/255.0f alpha:1.0];
    
    commentTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    commentTabelView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150/2)];
    
    NSString *titleString = _informationTitle;
    CGSize titleSize = [titleString sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(430/2, 80/2) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(38/2, 34/2, 430/2, titleSize.height)];
    titleLabel.text = titleString;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setNumberOfLines:0];
    [commentTabelView.tableHeaderView addSubview:titleLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(330/2, 114/2, 290/2, 30/2)];
    timeLabel.text = _informationAddTime;
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [commentTabelView.tableHeaderView addSubview:timeLabel];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 148/2, self.view.frame.size.width, 1)];
    lineImageView.image = [UIImage imageNamed:@"shouyecellxian@2x"];
    [commentTabelView.tableHeaderView addSubview:lineImageView];
    
    
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
    [commentTabelView addGestureRecognizer:tapRecognizer];
    
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
            [BCHTTPRequest CommentInformationWithNews_id:_informationId WithContent:[textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
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
#pragma mark - 返回
-(void)backButtonClicked
{
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refushFaceData" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

//获取数据
- (void)getDataWithNum:(NSInteger)num
{
    [BCHTTPRequest informationCommentWithNews_id:_informationId WithPage:num usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            if ([resultDic[@"list"] count] > 0) {
                if (num == 1) {
                    commentArray = [[NSMutableArray alloc] initWithCapacity:100];
                }
                [commentArray addObjectsFromArray:resultDic[@"list"]];
            }
            [commentTabelView reloadData];
            
            [self removeFooterView];
            [self testFinishedLoadData];
        }
    }];
    
}


#pragma mark tableView 协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *contentString = commentArray[indexPath.row][@"content"];
    CGSize contentSize = [contentString sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(440/2, 100000) lineBreakMode:NSLineBreakByWordWrapping];
    if (contentSize.height > 98/2) {
        return contentSize.height+ 50/2 +8;
    }else
    {
        return 164/2;
    }
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
    if (cell == nil) {
        cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.headImageView setImageWithURL:[NSURL URLWithString:commentArray[indexPath.row][@"user_logo"]] placeholderImage:[UIImage imageNamed:@""]];
    cell.headImageView.backgroundColor = [UIColor grayColor];
    
    cell.nameLabel.text = commentArray[indexPath.row][@"user_name"];
    
    NSString *contentString = commentArray[indexPath.row][@"content"];
    CGSize contentSize = [contentString sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(440/2, 100000) lineBreakMode:NSLineBreakByWordWrapping];
    cell.contentLable.frame = CGRectMake(cell.nameLabel.frame.origin.x, cell.nameLabel.frame.origin.y+ cell.nameLabel.frame.size.height, 440/2, contentSize.height);
    [cell.contentLable setNumberOfLines:0];
    cell.contentLable.text = contentString;
    
    cell.timeLabel.text = commentArray[indexPath.row][@"add_time"];
    
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
    
	[commentTabelView addSubview:_refreshHeaderView];
    
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:commentTabelView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:commentTabelView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(commentTabelView.contentSize.height, commentTabelView.frame.size.height);
    
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              commentTabelView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         commentTabelView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [commentTabelView addSubview:_refreshFooterView];
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
