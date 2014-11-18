//
//  LineGroupChatViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-27.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "LineGroupChatViewController.h"
#import "MyFaceBookGroupCell.h"
#import "ThemeGroupChatCell.h"
#import "InvitedThemePeopleViewController.h"

#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "GlobalVariable.h"

#import "CMChatMainViewController.h"

@interface LineGroupChatViewController ()
{
    //常用联系人
    UIButton *oftenChatPeopleButton;
    UITableView *oftenChatPeopleTableView;
    NSMutableArray *oftenChatPeopleArray;
    //群聊
    UIButton *groupChatButton;
    UITableView *groupChatTableView;
    NSMutableArray *groupChatArray;
    //添加群
    UIButton *addGroupChat;
}

@end

@implementation LineGroupChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        oftenChatPeopleArray = [[NSMutableArray alloc]initWithCapacity:100];
        groupChatArray = [[NSMutableArray alloc]initWithCapacity:100];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 640/2, 170/2)];
    backImageView.backgroundColor = [UIColor whiteColor];
    backImageView.userInteractionEnabled = YES;
    [self.view addSubview:backImageView];
    
    //常用联系人oftenChatPeopleButton;
    oftenChatPeopleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    oftenChatPeopleButton.frame = CGRectMake(10, 9 , 132/2, 132/2);
    oftenChatPeopleButton.backgroundColor = [UIColor clearColor];
    [oftenChatPeopleButton setBackgroundImage:[UIImage imageNamed:@"jingchanglianxi@2x"] forState:UIControlStateNormal];
    [oftenChatPeopleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [oftenChatPeopleButton setTitle:@"" forState:UIControlStateNormal];
    [oftenChatPeopleButton addTarget:self action:@selector(clickoftenChatPeopleButton) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:oftenChatPeopleButton];
    
    //群聊groupChatButton;
    groupChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    groupChatButton.frame = CGRectMake(172/2, 9 , 132/2, 132/2);
    groupChatButton.backgroundColor = [UIColor clearColor];
    [groupChatButton setBackgroundImage:[UIImage imageNamed:@"qunliao@2x"] forState:UIControlStateNormal];
    [groupChatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [groupChatButton setTitle:@"" forState:UIControlStateNormal];
    [groupChatButton addTarget:self action:@selector(clickgroupChatButton) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:groupChatButton];
    
    //添加群addGroupChat;
    addGroupChat = [UIButton buttonWithType:UIButtonTypeCustom];
    addGroupChat.frame = CGRectMake(326/2, 9 , 132/2, 132/2);
    addGroupChat.backgroundColor = [UIColor clearColor];
    [addGroupChat setBackgroundImage:[UIImage imageNamed:@"tianjiaren@2x"] forState:UIControlStateNormal];
    [addGroupChat setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addGroupChat setTitle:@"" forState:UIControlStateNormal];
    [addGroupChat addTarget:self action:@selector(clickaddGroupChat) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:addGroupChat];
    
    UIImageView *xianImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 168/2, 640/2, 2/2)];
    xianImageView.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0];
    xianImageView.userInteractionEnabled = YES;
    [backImageView addSubview:xianImageView];
    
    //经常联系人列表
    oftenChatPeopleTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 170/2, self.view.frame.size.width, self.view.frame.size.height-37-64-85) style:UITableViewStylePlain];
    oftenChatPeopleTableView.delegate = self ;
    oftenChatPeopleTableView.dataSource = self ;
    oftenChatPeopleTableView.backgroundView = nil ;
    oftenChatPeopleTableView.tag = 5007;
    oftenChatPeopleTableView.backgroundColor = [UIColor clearColor];
    oftenChatPeopleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:oftenChatPeopleTableView];
    oftenChatPeopleTableView.hidden = NO;
    
    GlobalVariable *globalVariable = [GlobalVariable sharedGlobalVariable];
    _departmentIdString = globalVariable.departmentIdString;
    
    
    //经常联系人请求数据
    [self getTheOftenChatPeopleData];
    
    //群聊列表
    groupChatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 170/2, self.view.frame.size.width, self.view.frame.size.height-37-64-85) style:UITableViewStylePlain];
    groupChatTableView.delegate = self ;
    groupChatTableView.dataSource = self ;
    groupChatTableView.backgroundView = nil ;
    groupChatTableView.tag = 7007;
    groupChatTableView.backgroundColor = [UIColor clearColor];
    groupChatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:groupChatTableView];
    groupChatTableView.hidden = YES;
    
    
    //lineChatGroupReload
    //接受通知
    [[NSNotificationCenter defaultCenter] addObserverForName:@"lineChatGroupReload" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        
        [self gettheGroupChatData];
        
    }];
    

}
#pragma mark - 经常联系人
- (void)getTheOftenChatPeopleData
{
    
    [BCHTTPRequest getDepartmentTopContactsWithDepartment_id:_departmentIdString usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            oftenChatPeopleArray = resultDic[@"list"];
            [oftenChatPeopleTableView reloadData];
        }
    }];
    
}
#pragma mark - 群聊列表
- (void)gettheGroupChatData
{
    [BCHTTPRequest getDepartmentGroupUsersWithDepartment_id:_departmentIdString usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            groupChatArray = resultDic[@"list"];
            
            [groupChatTableView reloadData];
        }
    }];
}
#pragma mark - 常用联系人
- (void)clickoftenChatPeopleButton
{
    oftenChatPeopleTableView.hidden = NO;
    groupChatTableView.hidden = YES;
    
    
}
#pragma mark - 群聊
- (void)clickgroupChatButton
{
    oftenChatPeopleTableView.hidden = YES;
    groupChatTableView.hidden = NO;
    
    if (groupChatArray.count < 1) {
        [self gettheGroupChatData];
    }
}
#pragma mark - 添加群
- (void)clickaddGroupChat
{
    InvitedThemePeopleViewController *invitedThemePeopleVC = [[InvitedThemePeopleViewController alloc]init];
    invitedThemePeopleVC.groupid = _departmentIdString;
    invitedThemePeopleVC.fromString = @"条线群聊";
    [self.navigationController pushViewController:invitedThemePeopleVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 5007) {
        return oftenChatPeopleArray.count;
    }else if (tableView.tag == 7007)
    {
        return groupChatArray.count;
    }
    return NO;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 5007) {
        return 174/2;
    }else if (tableView.tag == 7007)
    {
        return 68/2;
    }
    return NO;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 5007) {
        static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
        MyFaceBookGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
        if (cell == nil) {
            cell = [[MyFaceBookGroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
        }
        //cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
        cell.cellBackImageView.backgroundColor = [UIColor clearColor];
        NSDictionary *dic = [[NSDictionary alloc]init];
        dic = oftenChatPeopleArray[indexPath.row];
        [cell.groupImageView setImageWithURL:[NSURL URLWithString:dic[@"user_logo"]] placeholderImage:[UIImage imageNamed:@"touxiangmoren@2x"]];
        cell.groupNameLabel.text = dic[@"user_name"];
        [cell.bottomLineImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];
        return cell;
        
    }else if (tableView.tag == 7007)
    {
        static NSString *CellIdentifier = @"Cell";
        ThemeGroupChatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ThemeGroupChatCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            
        }
        cell.groupNameLabel.text = groupChatArray[indexPath.row][@"group_name"];
        cell.numberLabel.text = [NSString stringWithFormat:@"%@人",groupChatArray[indexPath.row][@"nums"]];
        [cell.lineImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];
        return cell;
        
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 5007) {
        //经常联系人
        CMChatMainViewController *cMChatMainVC = [[CMChatMainViewController alloc]init];
        cMChatMainVC.toUserID = oftenChatPeopleArray[indexPath.row][@"user_id"];
        cMChatMainVC.toUserName = oftenChatPeopleArray[indexPath.row][@"user_name"];
        cMChatMainVC.messageWhereTypes = @"3";
        cMChatMainVC.messageWhereIds = @"0";
        cMChatMainVC.toUserHeadLogo = oftenChatPeopleArray[indexPath.row][@"user_logo"];
        cMChatMainVC.isGroupChat = NO;
        [self.navigationController pushViewController:cMChatMainVC animated:YES];
    }else if (tableView.tag == 7007)
    {
        //点击群聊列表事件
        NSString *myWhereType = [[NSString alloc]init];
        
        myWhereType = @"1";
    
        CMChatMainViewController *cMChatMainVC = [[CMChatMainViewController alloc]init];
        cMChatMainVC.toUserID = groupChatArray[indexPath.row][@"group_id"];
        cMChatMainVC.toUserName = groupChatArray[indexPath.row][@"group_name"];
        cMChatMainVC.messageWhereTypes = myWhereType;
        cMChatMainVC.messageWhereIds = self.departmentIdString;
        cMChatMainVC.toUserHeadLogo = @"";
        
        cMChatMainVC.isGroupChat = YES;
        [self.navigationController pushViewController:cMChatMainVC animated:YES];
        
    }
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
