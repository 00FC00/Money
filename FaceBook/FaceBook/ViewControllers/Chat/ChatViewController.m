//
//  ChatViewController.m
//  FaceBook
//
//  Created by HMN on 14-4-28.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "ChatViewController.h"
#import "AppDelegate.h"


#import "SettingViewController.h"
#import "ChatViewCell.h"
#import "GroupMemberViewController.h"
#import "RecentlyContactsDB.h"
#import "FMDBRecentlyContactsObject.h"
#import "AFNetworking.h"
#import "NSDate+TimeAgo.h"
#import "CMChatMainViewController.h"

#import "SUNViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface ChatViewController ()
{
    UITableView *chatListTableView;
    NSMutableArray *allChatListArray;
    
    GroupNoticeObject *obj;
    GroupNotice * groupNotice;
}
@end

@implementation ChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        allChatListArray = [[NSMutableArray alloc]initWithCapacity:100];
        self.messages = [[NSMutableArray alloc]initWithCapacity:100];
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    if (chatListTableView) {
        [self refreshData];
    }else
    {
        chatListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 4, self.view.frame.size.width,IS_IOS_7?self.view.frame.size.height:self.view.frame.size.height-4) style:UITableViewStylePlain];
        //chatListTableView.contentInset = UIEdgeInsetsMake(- 35, 0, 0, 0);
        chatListTableView.delegate = self;
        chatListTableView.dataSource = self;
        chatListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [chatListTableView setBackgroundView:nil];
        [chatListTableView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:chatListTableView];
        
        [self refreshData];
        
    }
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0];
    
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"聊天";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 22, 40, 40);
    [menuButton setBackgroundImage:[UIImage imageNamed:@"caidan@2x"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //设置
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(526/2, 22, 80/2, 80/2);
    [setButton setBackgroundImage:[UIImage imageNamed:@"shezhianniu@2x"] forState:UIControlStateNormal];
    //[setButton setTitle:@"登录" forState:UIControlStateNormal];
    //setButton.titleLabel.font = [UIFont systemFontOfSize:15];
    //[setButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(setButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:setButton];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;
    
    
    //接受通知
    [[NSNotificationCenter defaultCenter] addObserverForName:@"recentlyList" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        NSLog(@"接收到舒心通知");
        [self refreshData];
        
    }];
    
    //接收到我退群通知，删除与该群聊天记录，刷新最近联系人列表
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"exitGroup" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        
        RecentlyContactsDB * recentlyContactsDB = [[RecentlyContactsDB alloc] init];
        [recentlyContactsDB createDataBase];
        NSLog(@"退群通知");
        allChatListArray = [recentlyContactsDB getAllRecentlyContactsInfo];
        NSLog(@"data array is %@",allChatListArray);
        self.messages = allChatListArray;
        
        NSString *str = note.object;
        for (FMDBRecentlyContactsObject *recentlyObj in self.messages) {
            if ([recentlyObj.messageFaceId isEqualToString:str]) {
                RecentlyContactsDB *recentlyContactsDB2 = [[RecentlyContactsDB alloc]init];
                [recentlyContactsDB2 createDataBase];
                [recentlyContactsDB2 delegateTrcentlyConMessageWithObj:recentlyObj];
            }
        }
        
        
        [chatListTableView reloadData];
        
        
    }];

    
}
#pragma mark - 获取刷新数据
- (void)refreshData
{
    
    RecentlyContactsDB * recentlyContactsDB = [[RecentlyContactsDB alloc] init];
    [recentlyContactsDB createDataBase];
    
    allChatListArray = [recentlyContactsDB getAllRecentlyContactsInfo];
    NSLog(@"data array is %@",allChatListArray);
    self.messages = allChatListArray;
    
    
    
    [chatListTableView reloadData];
    
    
    
    
    //    NSMutableArray * dataArray = [privateChat searchMessagesArrayWithChannelId:self.channelId andFromId:self.userId andToId:[NSString stringWithFormat:@"%d",[CMHTTPRequest getLocalUserID]]];
    
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
#pragma mark tableView 协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 148/2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
    ChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
    if (cell == nil) {
        cell = [[ChatViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.cellBackImageView setBackgroundColor:[UIColor whiteColor]];
    
//    [cell.headImageView setImage:[UIImage imageNamed:@"ceshi@2x"]];
//    //当信息大于0，显示，否则不显示
//    [cell.numberBackImageView setImage:[UIImage imageNamed:@"xinxishuliangbeijing@2x"]];
//    cell.numberLabel.text = @"16";
//    
//    cell.nameLabel.text = @"小白小黑如此碉堡很凶残";
//    cell.messageLabel.text = @"本人学识渊博，经验丰富，代码风骚，算法犀利，逻辑敏捷，精通各种编程工具";
//    cell.dateLabel.text = @"昨晚11:11";
//    
//    if (indexPath.row%2 == 0) {
//        [cell.chatImageView setImage:[UIImage imageNamed:@""]];
//    }else
//    {
//        [cell.chatImageView setImage:[UIImage imageNamed:@"qunliaobiaozhi@2x"]];
//    }
//    
//    [cell.lineImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];
    
    FMDBRecentlyContactsObject *recentlyObj = [[FMDBRecentlyContactsObject alloc]init];
    recentlyObj = self.messages[indexPath.row];
    if ([recentlyObj.messageChatType intValue]==0) {
        NSLog(@"冯绍辉%@",recentlyObj.messageChatType);
        [cell.headImageView setImageWithURL:[NSURL URLWithString:recentlyObj.faceHeadLogo] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
    }else{
        [cell.headImageView setImage:[UIImage imageNamed:@"lianpuqunchat@2x"]];
    }
    
    __weak typeof(self) bself = self;
    [cell setHeaderViewtap:^(ChatViewCell *cell) {
        MySweepViewController *mySweepVC = [[MySweepViewController alloc]init];
        mySweepVC.friendIdString = recentlyObj.messageFaceId;
        mySweepVC.groupIdString = @"0";
        mySweepVC.groupTypeString = @"4";
        [bself.navigationController pushViewController:mySweepVC animated:YES];
    }];
   
    
    //当信息大于0，显示，否则不显示
    if ([recentlyObj.unReadNumber intValue] > 0) {
        [cell.numberBackImageView setImage:[UIImage imageNamed:@"xinxishuliangbeijing@2x"]];
        cell.numberLabel.text = [NSString stringWithFormat:@"%@",recentlyObj.unReadNumber];
        
    }else
    {
        [cell.numberBackImageView setImage:[UIImage imageNamed:@""]];
        cell.numberLabel.text = @"";
        
    }
    
    cell.nameLabel.text = recentlyObj.messageFaceName;
    NSLog(@"信息类型%@",recentlyObj.messageType);
    if ([recentlyObj.messageType intValue]==0 ) {
        cell.messageLabel.text = recentlyObj.content;
    }else if ([recentlyObj.messageType intValue] == 1)
    {
        cell.messageLabel.text = @"【图片】";
    }else if ([recentlyObj.messageType intValue] == 2)
    {
        cell.messageLabel.text = @"【语音】";
    }
    
    
    //时间
   
    NSString * strs = [NSString stringWithFormat:@"%@",recentlyObj.messageDate];
    NSString *mstrs =  [strs substringToIndex:10];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[mstrs intValue]];
    NSLog(@"时间戳4%@",confromTimesp);

    
    cell.dateLabel.text = [confromTimesp timeAgo];
    NSLog(@"❤❤%@,",recentlyObj.messageChatType);
    if ([recentlyObj.messageChatType intValue] == 0) {
        [cell.chatImageView setImage:[UIImage imageNamed:@""]];
    }else
    {
        [cell.chatImageView setImage:[UIImage imageNamed:@"qunliaobiaozhi@2x"]];
        [groupNotice insertTheRecordsWithGroupID:recentlyObj.messageFaceId];
    }
    
    [cell.lineImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FMDBRecentlyContactsObject *recentlyObj = [[FMDBRecentlyContactsObject alloc]init];
    recentlyObj = self.messages[indexPath.row];
    RecentlyContactsDB *recentlyContactsDB1 = [[RecentlyContactsDB alloc]init];
    [recentlyContactsDB1 createDataBase];
    [recentlyContactsDB1 emptyisReadWithRecentlyObj:recentlyObj];
//    CMChatMainViewController *CMChatMainVC = [[CMChatMainViewController alloc]init];
//    CMChatMainVC.toUserID = recentlyObj.messageFaceId;
//    NSLog(@"对方的id----%@",recentlyObj.messageFaceId);
//    CMChatMainVC.toUserName = recentlyObj.messageFaceName;
//    CMChatMainVC.toUserHeadLogo = recentlyObj.faceHeadLogo;
//    CMChatMainVC.messageWhereTypes = recentlyObj.messageWhereType;
//    CMChatMainVC.messageWhereIds = recentlyObj.messageWhereId;
    
    CMChatMainViewController *cMChatMainVC = [[CMChatMainViewController alloc]init];
    cMChatMainVC.toUserID = recentlyObj.messageFaceId;
    cMChatMainVC.toUserName = recentlyObj.messageFaceName;
    cMChatMainVC.messageWhereTypes = recentlyObj.messageWhereType;
    cMChatMainVC.messageWhereIds = recentlyObj.messageWhereId;
    cMChatMainVC.toUserHeadLogo = recentlyObj.faceHeadLogo;
   
    
    
    if ([recentlyObj.messageChatType intValue] == 1) {
        cMChatMainVC.isGroupChat = YES;
    }else
    {
        cMChatMainVC.isGroupChat = NO;
    }
    [self.navigationController pushViewController:cMChatMainVC animated:YES];
    
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
