//
//  WallDetialsViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-19.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "WallDetialsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WallDetialswCell.h"

#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "DMCAlertCenter.h"
#import "SendWallContectViewController.h"
#import "MySweepViewController.h"

@interface WallDetialsViewController ()
{
    //头像
    UIImageView *userHeadImageView;
    //用户名
    UILabel *nameLabel;
    //标题
    UILabel *titleLabel;
    //内容
    UILabel *contectLabel;
    //类型
    UILabel *markTypeLabel;
    UILabel *typeLabel;
    //时间
    UILabel *timeLabel;

    CGSize size;
    CGSize size1;
    CGSize size2;
    
    
    //回复框背景
    UIImageView *replyImageView;
    //回复按钮
    UIButton *replyButton;
    //回复框
    UITextView *replyField;
    UILabel *placeHolderLabel;
    
    NSMutableDictionary *wallDetailsDic;
}
@end

@implementation WallDetialsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        wallDetialsArray = [[NSMutableArray alloc] initWithCapacity:100];
        wallDetailsDic = [[NSMutableDictionary alloc] initWithCapacity:100];
        targetId = @"";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:247.0f/255.0f blue:249.0f/255.0f alpha:1];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"详情";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    
    
    //详情
    wallDetialsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64) style:UITableViewStylePlain];
    wallDetialsTableView.backgroundColor = [UIColor clearColor];
    wallDetialsTableView.delegate = self;
    wallDetialsTableView.dataSource = self;
    [self.view addSubview:wallDetialsTableView];
    wallDetialsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getHeadViewData];
    
    //回复框背景replyImageView;
    replyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-64, [[UIScreen mainScreen] bounds].size.width, 49)];
    replyImageView.backgroundColor = [UIColor clearColor];
    replyImageView.userInteractionEnabled = YES;
    [replyImageView setImage:[UIImage imageNamed:@"huifukuangbeijing@2x"]];
    //[self.view bringSubviewToFront:replyImageView];
    [self.view addSubview:replyImageView];
    
    //回复按钮replyButton;
    replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    replyButton.frame = CGRectMake(526/2, 0, 114/2, 49);
    replyButton.backgroundColor = [UIColor clearColor];
    [replyButton setBackgroundImage:[UIImage imageNamed:@"huifuanniu@2x"] forState:UIControlStateNormal];
    [replyButton addTarget:self action:@selector(clickReplyButton) forControlEvents:UIControlEventTouchUpInside];
    [replyImageView addSubview:replyButton];
    
    //回复框replyField;
    replyField = [[UITextView alloc]initWithFrame:CGRectMake(24, 8, 240, 27)];
    replyField.backgroundColor = [UIColor clearColor];
    replyField.delegate = self;
    replyField.font = [UIFont systemFontOfSize:14];
    replyField.returnKeyType = UIReturnKeyDone;
    [replyImageView addSubview:replyField];
    
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
    [replyField addSubview:placeHolderLabel];
    if ([[replyField text] length] == 0) {
        [[replyField viewWithTag:999] setAlpha:1];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //点击背景取消键盘
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(handleBackgroundTap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [wallDetialsTableView addGestureRecognizer:tapRecognizer];
    
    pageNumber = 1;
    [self getDataWithNum:pageNumber];

    [self createHeaderView];
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    
}

#pragma mark - 获取信息
- (void)getDataWithNum:(int)num
{
    [BCHTTPRequest getBusinessDetailWithWallId:_wallIdString WithPage:num usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            if (num == 1) {
                wallDetailsDic = [resultDic mutableCopy];
                if ([wallDetailsDic[@"is_me"] intValue]==1) {
                    //本人
                    //修改
                    _Button = [UIButton buttonWithType:UIButtonTypeCustom];
                    _Button.frame = CGRectMake(526/2, 22, 84/2, 42/2);
                    [_Button setBackgroundImage:[UIImage imageNamed:@"login_RegistrationButton_03@2x"] forState:UIControlStateNormal];
                    //如果是楼主的话，就显示修改，如果是游客的话就显示评论
                    
                    [_Button setTitle:@"修改" forState:UIControlStateNormal];
                    _Button.titleLabel.font = [UIFont systemFontOfSize:15];
                    [_Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [_Button addTarget:self action:@selector(ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:_Button];
                    self.navigationItem.rightBarButtonItem=rightbuttonitem;
                    
                }else
                {
                    //其他人发布的
                    //修改
                    _Button = [UIButton buttonWithType:UIButtonTypeCustom];
                    _Button.frame = CGRectMake(526/2, 22, 84/2, 42/2);
                    [_Button setBackgroundImage:[UIImage imageNamed:@"login_RegistrationButton_03@2x"] forState:UIControlStateNormal];
                    //如果是楼主的话，就显示修改，如果是游客的话就显示评论
                    
                    [_Button setTitle:@"回复" forState:UIControlStateNormal];
                    _Button.titleLabel.font = [UIFont systemFontOfSize:15];
                    [_Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [_Button addTarget:self action:@selector(ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:_Button];
                    self.navigationItem.rightBarButtonItem=rightbuttonitem;
                    
                }
                [userHeadImageView setImageWithURL:[NSURL URLWithString:resultDic[@"user_logo"]] placeholderImage:[UIImage imageNamed:@""]];
                self.userIdStr = resultDic[@"user_id"];
                nameLabel.text = resultDic[@"user_nickname"];
                NSString *titleString = resultDic[@"title"];
                CGSize titleSize = [titleString sizeWithFont:[UIFont systemFontOfSize:16]constrainedToSize:CGSizeMake(432/2,40) lineBreakMode:NSLineBreakByWordWrapping];
                titleLabel.frame =CGRectMake(170/2,74/2, 432/2, titleSize.height);
                titleLabel.text = titleString;
                
                NSString *contentString = resultDic[@"content"];
                CGSize contentSize = [contentString sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(586/2,2000) lineBreakMode:NSLineBreakByWordWrapping];
                contectLabel.frame =CGRectMake(28/2,172/2, 586/2, contentSize.height);
                contectLabel.text = contentString;
                
                markTypeLabel.frame = CGRectMake(28/2, 172/2+contectLabel.frame.size.height+5, 66/2, 28/2);
                typeLabel.frame = CGRectMake(102/2, 172/2+contectLabel.frame.size.height+5, 240/2, 28/2);
                typeLabel.text = resultDic[@"type"];
                timeLabel.frame = CGRectMake(344/2, 172/2+contectLabel.frame.size.height+5, 274/2, 28/2);
                timeLabel.text = resultDic[@"add_time"];
                lineImageView.frame =  CGRectMake(10, 172/2+contectLabel.frame.size.height+5+17, 600/2, 1);
                imgView.frame = CGRectMake(0, 0, 320, 172/2+contectLabel.frame.size.height+5+19);
                wallDetialsTableView.tableHeaderView = imgView;
                
//                if ([resultDic[@"is_me"] integerValue] == 0) {
//                    _Button.hidden = YES;
//                }
                
                wallDetialsArray = [[NSMutableArray alloc] initWithCapacity:100];
            }
            
            [wallDetialsArray addObjectsFromArray:resultDic[@"comment_list"]];
        }
        
        [wallDetialsTableView reloadData];
        [self removeFooterView];
        [self testFinishedLoadData];
    }];
}

//取消键盘
- (void) handleBackgroundTap:(UITapGestureRecognizer*)sender
{
    [replyField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        replyImageView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-64, [[UIScreen mainScreen] bounds].size.width, 49);
    }];
    
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [replyField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        replyImageView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-64, [[UIScreen mainScreen] bounds].size.width, 49);
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        
        [replyField resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            replyImageView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-49-64, [[UIScreen mainScreen] bounds].size.width, 49);
        }];
        
        return NO;
        
    }
    
    return YES;
    
}
- (void)keyboardWillShown:(NSNotification*)aNotification{
    // 键盘信息字典
    NSValue *keyboardBoundsValue = [[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
    NSLog(@"height = %f",keyboardBounds.size.height);
   
    [UIView animateWithDuration:0.3 animations:^{
            replyImageView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-keyboardBounds.size.height-64-49, [[UIScreen mainScreen] bounds].size.width, 49);
    }];
}
//输入框要编辑的时候
- (void)textChanged:(NSNotification *)notification
{
    if ([[replyField text] length] == 0) {
        [[replyField viewWithTag:999] setAlpha:1];
    }
    else {
        [[replyField viewWithTag:999] setAlpha:0];
    }

    
}

#pragma mark - 回复
- (void)clickReplyButton
{
    if ([replyField.text length] < 1) {
        [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"请输入评论内容"];
    }else
    {
        [BCHTTPRequest businessSetCommentWithWallId:_wallIdString WithContent:[replyField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] WithToID:targetId usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
//                NSMutableDictionary *commentDic = [[NSMutableDictionary alloc] initWithCapacity:100];
//                [commentDic setValue:[BCHTTPRequest getUserName] forKey:@"user_name"];
//                [commentDic setValue:replyField.text forKey:@"content"];
//                
//                [wallDetialsArray insertObject:commentDic atIndex:0];
//                
//                [wallDetialsTableView reloadData];
//                [self removeFooterView];
//                [self testFinishedLoadData];
//                replyField.text = @"";
                pageNumber = 1;
                [self getDataWithNum:pageNumber];
                replyField.text = @"";
                [[replyField viewWithTag:999] setAlpha:1];

            }
        }];
    }
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
    userHeadImageView.userInteractionEnabled = YES;
    //[userHeadImageView setImage:[UIImage imageNamed:@"ceshi@2x"]];
    [imgView addSubview:userHeadImageView];
    
    UIButton *userHeadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userHeadButton.frame = CGRectMake(0, 0, 132/2, 132/2);
    userHeadButton.backgroundColor = [UIColor clearColor];
    [userHeadButton addTarget:self action:@selector(clickUserHeadButton) forControlEvents:UIControlEventTouchUpInside];
    [userHeadImageView addSubview:userHeadButton];
    
    //用户名nameLabel;
    nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(170/2, 34/2, 442/2, 32/2)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor lightGrayColor];
    nameLabel.font = [UIFont systemFontOfSize:15];
    //nameLabel.text = @"北京蓝凌科技有限公司ios研发部";
    [imgView addSubview:nameLabel];
    
    //标题titleLabel;
    titleLabel=[[UILabel alloc]init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.numberOfLines = 0;
    [imgView addSubview:titleLabel];
    
    //内容contectLabel;
    contectLabel=[[UILabel alloc]init];
    contectLabel.backgroundColor = [UIColor clearColor];
    contectLabel.textAlignment = NSTextAlignmentLeft;
    contectLabel.textColor = [UIColor blackColor];
    contectLabel.font = [UIFont systemFontOfSize:15];
    contectLabel.numberOfLines = 0;
    [imgView addSubview:contectLabel];
    
    //类型markTypeLabel;typeLabel;
    markTypeLabel=[[UILabel alloc]initWithFrame:CGRectMake(28/2, 172/2+contectLabel.frame.size.height+5, 66/2, 28/2)];
    markTypeLabel.backgroundColor = [UIColor clearColor];
    markTypeLabel.textAlignment = NSTextAlignmentLeft;
    markTypeLabel.textColor = [UIColor lightGrayColor];
    markTypeLabel.font = [UIFont systemFontOfSize:14];
    markTypeLabel.text = @"类型:";
    [imgView addSubview:markTypeLabel];
    
    typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(102/2, 172/2+contectLabel.frame.size.height+5, 240/2, 28/2)];
    typeLabel.backgroundColor = [UIColor clearColor];
    typeLabel.textAlignment = NSTextAlignmentLeft;
    typeLabel.textColor = [UIColor lightGrayColor];
    typeLabel.font = [UIFont systemFontOfSize:14];
    //typeLabel.text = @"招聘娱乐新闻国际等";
    [imgView addSubview:typeLabel];
    
    //时间timeLabel;
    timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(344/2, 172/2+contectLabel.frame.size.height+5, 274/2, 28/2)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.font = [UIFont systemFontOfSize:14];
    //timeLabel.text = @"2014-04-18 16:33:33";
    [imgView addSubview:timeLabel];
    
    //下划线
    lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 172/2+contectLabel.frame.size.height+5+17, 600/2, 1)];
    lineImageView.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:214.0f/255.0f blue:218.0f/255.0f alpha:1];
    lineImageView.userInteractionEnabled = YES;
    [imgView addSubview:lineImageView];
    
     imgView.frame = CGRectMake(0, 0, 320, 172/2+contectLabel.frame.size.height+5+19);
     wallDetialsTableView.tableHeaderView = imgView;
}
#pragma mark - 返回
-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 点击头像
- (void)clickUserHeadButton
{
    MySweepViewController *otherPeopleMessageDetialsVC = [[MySweepViewController alloc] init];
    otherPeopleMessageDetialsVC.friendIdString = self.userIdStr;
    [self.navigationController pushViewController:otherPeopleMessageDetialsVC animated:YES];
}
#pragma mark - 修改
- (void)ButtonClicked
{
    NSLog(@"%@",wallDetailsDic[@"is_me"]);
    if ([wallDetailsDic[@"is_me"] intValue]==1) {
        SendWallContectViewController *sendWallContectViewController = [[SendWallContectViewController alloc] init];
        sendWallContectViewController.titleString = @"修改";
        sendWallContectViewController.wallDetailDic = wallDetailsDic;
        [self.navigationController pushViewController:sendWallContectViewController animated:YES];
    }else
    {
        NSLog(@"键盘");
        targetId = wallDetailsDic[@"user_id"];
        [replyField becomeFirstResponder];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardWillShown:)
//                                                     name:UIKeyboardWillShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    
}
#pragma mark - tableView Delegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *commentString = [NSString stringWithFormat:@"%@:%@",wallDetialsArray[indexPath.row][@"user_name"],wallDetialsArray[indexPath.row][@"content"]];
    
    
    CGSize commentSize = [commentString sizeWithFont:[UIFont systemFontOfSize:13]constrainedToSize:CGSizeMake(584/2,1000) lineBreakMode:NSLineBreakByWordWrapping];
    

    return commentSize.height+10+10;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return wallDetialsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
    WallDetialswCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
    if (cell == nil) {
        cell = [[WallDetialswCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //xiahuaxian@2x
    //[cell.lineImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];
    
    
    NSString *commentString = [NSString stringWithFormat:@"%@:%@",wallDetialsArray[indexPath.row][@"user_name"],wallDetialsArray[indexPath.row][@"content"]];
    //user_logo
    [cell.headImageView setImageWithURL:[NSURL URLWithString:wallDetialsArray[indexPath.row][@"user_logo"]] placeholderImage:[UIImage imageNamed:@"touxiangmoren@2x"]];
    cell.headButton.tag = 5000+indexPath.row;
    [cell.headButton addTarget:self action:@selector(clickHeadButton:) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize commentSize = [commentString sizeWithFont:[UIFont systemFontOfSize:13]constrainedToSize:CGSizeMake(483/2,1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    cell.wcontectLabel.numberOfLines = 0;
    cell.wcontectLabel.frame =CGRectMake(101/2, 10, 483/2, commentSize.height);
    cell.wcontectLabel.text = commentString;
    
    cell.lineImageView.frame = CGRectMake(10, commentSize.height+9+10, 600/2, 1);
    cell.lineImageView.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:214.0f/255.0f blue:218.0f/255.0f alpha:1];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *str = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInformation"] objectForKey:@"id"];
    if ([wallDetialsArray[indexPath.row][@"user_id"] isEqualToString:str]) {
        
    }else
    {
        targetId = wallDetialsArray[indexPath.row][@"user_id"];
        [replyField becomeFirstResponder];
    }
}

#pragma mark - 点击头像查看详情
- (void)clickHeadButton:(UIButton *)button
{
    MySweepViewController *otherPeopleMessageDetialsVC = [[MySweepViewController alloc] init];
    otherPeopleMessageDetialsVC.friendIdString = wallDetialsArray[button.tag-5000][@"user_id"];
    [self.navigationController pushViewController:otherPeopleMessageDetialsVC animated:YES];
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
    
	[wallDetialsTableView addSubview:_refreshHeaderView];
    
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:wallDetialsTableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:wallDetialsTableView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(wallDetialsTableView.contentSize.height, wallDetialsTableView.frame.size.height);
    
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              wallDetialsTableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         wallDetialsTableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [wallDetialsTableView addSubview:_refreshFooterView];
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
