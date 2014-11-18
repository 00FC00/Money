//
//  NewFriendsViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-13.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "NewFriendsViewController.h"
#import "NewFriendsCell.h"
#import "MySweepViewController.h"

#import "BCHTTPRequest.h"
#import "AFNetworking.h"


@interface NewFriendsViewController ()
{
    UITableView *newFriendsTableView;
    NSMutableArray *newFriendsArray;
}
@end

@implementation NewFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        newFriendsArray = [[NSMutableArray alloc]initWithCapacity:100];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"新的好友";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    
    
    newFriendsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,IS_IOS_7?self.view.frame.size.height-64:self.view.frame.size.height-44) style:UITableViewStylePlain];
    newFriendsTableView.delegate = self;
    newFriendsTableView.dataSource = self;
    newFriendsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [newFriendsTableView setBackgroundView:nil];
    [newFriendsTableView setBackgroundColor:[UIColor colorWithRed:248.0f/255.0f green:249.0f/255.0f blue:251.0f/255.0f alpha:1.0]];
    [self.view addSubview:newFriendsTableView];
    
    [self ReloadTheTableView];
}
- (void)ReloadTheTableView
{
    //获取数据
    [BCHTTPRequest getMyNewFriendsWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            newFriendsArray = resultDic[@"list"];
            [newFriendsTableView reloadData];
            
        }
    }];

}
#pragma mark - 返回
-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark tableView 协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170/2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return newFriendsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
    NewFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
    if (cell == nil) {
        cell = [[NewFriendsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.cellBackImageView setBackgroundColor:[UIColor clearColor]];
    
    NSDictionary *diction = [[NSDictionary alloc]init];
    diction = newFriendsArray[indexPath.row];
    
    //头像
    
    [cell.photoImageView setImageWithURL:[NSURL URLWithString:diction[@"pic"]] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
    [cell.photoButton setTag:1000+indexPath.row];
    [cell.photoButton addTarget:self action:@selector(clickPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //确认按钮
    [cell.passButton setBackgroundImage:[UIImage imageNamed:@"tongguoyanzheng@2x"] forState:UIControlStateNormal];
    [cell.passButton setTitle:@"通过验证" forState:UIControlStateNormal];
    [cell.passButton setTag:4000+indexPath.row];
    [cell.passButton addTarget:self action:@selector(clickPassButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.nameLabel.text = diction[@"name"];
    cell.infoLabel.text = diction[@"info"];
    [cell.lineImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - 头像点击事件
- (void)clickPhotoButton:(UIButton *)p_Button
{
    MySweepViewController *mySweepVC = [[MySweepViewController alloc]init];
    mySweepVC.fromString = @"新的好友";
    mySweepVC.friendIdString = newFriendsArray[p_Button.tag-1000][@"uid"];
    [self.navigationController pushViewController:mySweepVC animated:YES];
}
#pragma mark - 确认按钮
- (void)clickPassButton:(UIButton *)passButton
{
    NSDictionary *diction = [[NSDictionary alloc]init];
    diction = newFriendsArray[passButton.tag - 4000];

    [BCHTTPRequest AgreeTheNewFriendsWithNewFriensdID:diction[@"uid"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            
            [newFriendsArray removeObjectAtIndex:passButton.tag - 4000];
            
            NSIndexPath *delegatePath = [NSIndexPath indexPathForRow:passButton.tag - 4000 inSection:0];
            
            [newFriendsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:delegatePath] withRowAnimation:UITableViewRowAnimationFade];
            
            
            [self performSelector:@selector(tableViewReloadData) withObject:nil afterDelay:0.3];
            
            
            
        }
    }];
}

- (void)tableViewReloadData
{
    [newFriendsTableView reloadData];
}
#pragma mark - tableView 滑动删除
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    NewFriendsCell *cell = (NewFriendsCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.passButton.hidden = NO;
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendsCell *cell = (NewFriendsCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.passButton.hidden = YES;
    
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
    NSDictionary *dictions = [[NSDictionary alloc]init];
    dictions = newFriendsArray[indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [BCHTTPRequest RejectTheNewFriendsWithFriendsID:dictions[@"uid"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
            if (isSuccess == YES) {
                [newFriendsArray removeObjectAtIndex:indexPath.row];
                [newFriendsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
        
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
