//
//  MessageViewController.m
//  FaceBook
//
//  Created by HMN on 14-4-29.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "MessageViewController.h"
#import "AppDelegate.h"

#import "SettingViewController.h"
#import "MessageListTableViewCell.h"
#import "BCHTTPRequest.h"
#import "DMCAlertCenter.h"
#import "MessageListDetialsViewController.h"

#import "SUNViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface MessageViewController ()
{
    UITableView *messageListTableView;
    NSMutableArray *messageListArray;
}
@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        messageListArray = [[NSMutableArray alloc]initWithCapacity:100];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.tag = 77777777;
    self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1.0];
    
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"部落消息";
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

    messageListTableView = [[UITableView alloc]initWithFrame:CGRectMake(6, 6, self.view.frame.size.width-12,IS_IOS_7?self.view.frame.size.height-64-6:self.view.frame.size.height-44-6) style:UITableViewStylePlain];
    //messageListTableView.contentInset = UIEdgeInsetsMake(- 35, 0, 0, 0);
    messageListTableView.delegate = self;
    messageListTableView.dataSource = self;
    messageListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [messageListTableView setBackgroundView:nil];
    [messageListTableView setBackgroundColor:[UIColor colorWithRed:248.0f/255.0f green:249.0f/255.0f blue:251.0f/255.0f alpha:1.0]];
    [self.view addSubview:messageListTableView];
    [self getMyData];
    
}
- (void)getMyData
{
    [BCHTTPRequest getTheMessageListWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            messageListArray = resultDic[@"list"];
            [messageListTableView reloadData];
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
#pragma mark tableView 协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72/2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return messageListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
    MessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
    if (cell == nil) {
        cell = [[MessageListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.cellBackImageView setBackgroundColor:[UIColor clearColor]];
    
    cell.contactLabel.text = messageListArray[indexPath.row][@"content"];
    
    if ([ messageListArray[indexPath.row][@"type"] integerValue]==2 || [ messageListArray[indexPath.row][@"type"] integerValue]==3 || [ messageListArray[indexPath.row][@"type"] integerValue]==4 || [ messageListArray[indexPath.row][@"type"] integerValue]==9) {
        if ([messageListArray[indexPath.row][@"is_do"] intValue]==1) {
            cell.passButton.hidden = YES;
            cell.refuseButton.hidden = YES;
        }else
        {
            cell.passButton.hidden = NO;
            cell.refuseButton.hidden = NO;
        }
        
        
    [cell.passButton setBackgroundImage:[UIImage imageNamed:@"tongguoanniu@2x"] forState:UIControlStateNormal];
    [cell.passButton setTag:3000+indexPath.row];
    [cell.passButton addTarget:self action:@selector(clickPassButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.refuseButton setBackgroundImage:[UIImage imageNamed:@"jujueanniu@2x"] forState:UIControlStateNormal];
    [cell.refuseButton setTag:5000+indexPath.row];
    [cell.refuseButton addTarget:self action:@selector(clickRefuseButton:) forControlEvents:UIControlEventTouchUpInside];
        
        }else
        {
            cell.passButton.hidden = YES;
            cell.refuseButton.hidden = YES;
        }
    
    [cell.lineImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];
    
    ///长按cell删除消息操作
    UILongPressGestureRecognizer * longPressGesture =  [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    cell.tag = 100000+indexPath.row;
    [cell addGestureRecognizer:longPressGesture];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([ messageListArray[indexPath.row][@"type"] integerValue]==2 || [ messageListArray[indexPath.row][@"type"] integerValue]==3 || [ messageListArray[indexPath.row][@"type"] integerValue]==4 || [ messageListArray[indexPath.row][@"type"] integerValue]==9) {
        if ([messageListArray[indexPath.row][@"is_do"] intValue]==0) {
            MessageListDetialsViewController *messageListDetialsVC = [[MessageListDetialsViewController alloc] init];
            messageListDetialsVC.friendIdString = messageListArray[indexPath.row][@"fid"];
            messageListDetialsVC.isComment = messageListArray[indexPath.row][@"content"];//content
            messageListDetialsVC.dic = messageListArray[indexPath.row];
            [self.navigationController pushViewController:messageListDetialsVC animated:YES];

        }
        
    }
}

#pragma mark - 长按cell删除消息操作
- (void)cellLongPress:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        MessageListTableViewCell *cell = (MessageListTableViewCell *)recognizer.view;
        NSLog(@"-----%d",cell.tag);
        UIAlertView * deleteAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否删除此消息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        deleteAlertView.tag = 200000 + cell.tag;
        [deleteAlertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"back");
    }else {
        [BCHTTPRequest deleteTheRemindMessageWithMessageID:messageListArray[alertView.tag-300000][@"id"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                [messageListArray removeObjectAtIndex:alertView.tag-300000];
                [messageListTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag-300000 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    }
}

#pragma mark - 通过验证
- (void)clickPassButton:(UIButton *)passButton
{
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = messageListArray[passButton.tag - 3000];
    if ([dic[@"type"] integerValue]==1) {
        NSLog(@"确认关系 ");
        [BCHTTPRequest PassTheConfirmationRelationshipsWithMessageID:dic[@"id"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"通过验证"];
            }
        }];
    }else if ([dic[@"type"] integerValue]==2)
    {
        NSLog(@"发布人批准参加活动，是否参加");
        //1.74接口
        [BCHTTPRequest AgreeJoinThePartyWithFid:dic[@"fid"] WithRelation:dic[@"relation"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                ;
            }
        }];
        
    }else if ([dic[@"type"] integerValue]==3)
    {
        NSLog(@"发布人收到活动申请");
        //1.73
        [BCHTTPRequest CreaterAgreeOtherPeopleJoinThePartyFid:dic[@"fid"] WithRelation:dic[@"relation"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                ;
            }
        }];
    }else if ([dic[@"type"] integerValue]==4)
    {
        NSLog(@"申请创建的主题群");
        //4.32
        [BCHTTPRequest PassTheJoinApplicationOfGroupWithMessageID:dic[@"id"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                ;
            }
        }];
    }else if ([dic[@"type"] integerValue]==5)
    {
        NSLog(@"参加活动人确认参加活动");
    }else if ([dic[@"type"] integerValue]==6)
    {
        NSLog(@"发布人拒绝活动申请");
    }else if ([dic[@"type"] integerValue]==7)
    {
        NSLog(@"拒绝好友申请");
    }else if ([dic[@"type"] integerValue]==8)
    {
        NSLog(@"成为好友");
    }else if ([dic[@"type"] integerValue]==9)
    {
        NSLog(@"xx申请加好友");
        //1.77
        [BCHTTPRequest AgreeTheOthersAddMeFriendsWithFid:dic[@"fid"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                ;
            }
        }];
    }else if ([dic[@"type"] integerValue]==10)
    {
        NSLog(@"参加活动人拒绝活动申请");
    }else if ([dic[@"type"] integerValue]==11)
    {
        NSLog(@"活动人删除活动");
    }else if ([dic[@"type"] integerValue]==12)
    {
        NSLog(@"VIP申请失败");
    }else if ([dic[@"type"] integerValue]==13)
    {
        NSLog(@"VIP申请成功");
    }

//    [messageListArray removeObjectAtIndex:passButton.tag-3000];
//    NSIndexPath *delegatePath = [NSIndexPath indexPathForRow:passButton.tag-3000 inSection:0];
//    
//    [messageListTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:delegatePath] withRowAnimation:UITableViewRowAnimationFade];
//    
//    
//    [self performSelector:@selector(tableViewReloadData) withObject:nil afterDelay:0.3];
}
#pragma mark - 拒绝按钮
- (void)clickRefuseButton:(UIButton *)refuseButton
{
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = messageListArray[refuseButton.tag - 5000];
    if ([dic[@"type"] integerValue]==1) {
        NSLog(@"拒绝关系 ");
        [BCHTTPRequest RefusedTheConfirmationRelationshipsWithMessageID:dic[@"id"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                ;
            }
        }];
    }else if ([dic[@"type"] integerValue]==2)
    {
        NSLog(@"发布人批准参加活动，是否参加");
        //1.76接口
        [BCHTTPRequest RefusedJoinThePartyWithFid:dic[@"fid"] WithRelation:dic[@"ralation"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                ;
            }
        }];
        
    }else if ([dic[@"type"] integerValue]==3)
    {
        NSLog(@"发布人收到活动申请");
        //1.75
        [BCHTTPRequest CreaterRefusedOtherPeopleJoinThePartyFid:dic[@"fid"] WithRelation:dic[@"ralation"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                ;
            }
        }];
    }else if ([dic[@"type"] integerValue]==4)
    {
        NSLog(@"申请创建的主题群");
        //4.42
        [BCHTTPRequest RefusedTheJoinApplicationOfGroupWithMessageID:dic[@"id"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                ;
            }
        }];
    }else if ([dic[@"type"] integerValue]==5)
    {
        NSLog(@"参加活动人确认参加活动");
    }else if ([dic[@"type"] integerValue]==6)
    {
        NSLog(@"发布人拒绝活动申请");
    }else if ([dic[@"type"] integerValue]==7)
    {
        NSLog(@"拒绝好友申请");
    }else if ([dic[@"type"] integerValue]==8)
    {
        NSLog(@"成为好友");
    }else if ([dic[@"type"] integerValue]==9)
    {
        NSLog(@"xx申请加好友");
        //1.72
        [BCHTTPRequest RefusedTheOthersAddMeFriendsWithFid:dic[@"fid"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                ;
            }
        }];
    }else if ([dic[@"type"] integerValue]==10)
    {
        NSLog(@"参加活动人拒绝活动申请");
    }else if ([dic[@"type"] integerValue]==11)
    {
        NSLog(@"活动人删除活动");
    }else if ([dic[@"type"] integerValue]==12)
    {
        NSLog(@"VIP申请失败");
    }else if ([dic[@"type"] integerValue]==13)
    {
        NSLog(@"VIP申请成功");
    }

//    [messageListArray removeObjectAtIndex:refuseButton.tag-5000];
//    NSIndexPath *delegatePath = [NSIndexPath indexPathForRow:refuseButton.tag-5000 inSection:0];
//    
//    [messageListTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:delegatePath] withRowAnimation:UITableViewRowAnimationFade];
//    
//    
//    [self performSelector:@selector(tableViewReloadData) withObject:nil afterDelay:0.3];
    
}
//刷新
- (void)tableViewReloadData
{
    [messageListTableView reloadData];
}

#pragma mark - tableView 滑动删除
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    MessageListTableViewCell *cell = (MessageListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
  //  cell.passButton.hidden = NO;
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageListTableViewCell *cell = (MessageListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    //cell.passButton.hidden = YES;
    
    return UITableViewCellEditingStyleDelete;
}
/*改变删除按钮的title*/
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *dictions = [[NSDictionary alloc]init];
//    dictions = newFriendsArray[indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source

        //if ([ messageListArray[indexPath.row][@"type"] integerValue]==2 || [ messageListArray[indexPath.row][@"type"] integerValue]==3 || [ messageListArray[indexPath.row][@"type"] integerValue]==4 || [ messageListArray[indexPath.row][@"type"] integerValue]==9) {
        [BCHTTPRequest deleteTheRemindMessageWithMessageID:messageListArray[indexPath.row][@"id"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                [messageListArray removeObjectAtIndex:indexPath.row];
                [messageListTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
        
       // }
        
    }else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
