//
//  checkSendDirectionViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-20.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "checkSendDirectionViewController.h"
#import "CheckSendDirectionTableViewCell.h"

#import "BCHTTPRequest.h"
#import "AFNetworking.h"
#import "DMCAlertCenter.h"
#import "GoldcoinsViewController.h"

@implementation WallGroupItem

+ (WallGroupItem*) wallGroupItem
{
	return [[self alloc] init];
}
@end

@interface CheckSendDirectionViewController ()<UIAlertViewDelegate>

@end

@implementation CheckSendDirectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sendDirectionArray = [[NSMutableArray alloc] initWithCapacity:100];
        selectDirectionArray = [[NSMutableArray alloc] initWithCapacity:100];
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
    self.title = @"定向发布";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
    //fabu
    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(526/2, 22, 84/2, 42/2);
    [sendButton setBackgroundImage:[UIImage imageNamed:@"login_RegistrationButton_03@2x"] forState:UIControlStateNormal];
    [sendButton setTitle:@"确定" forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:sendButton];
    self.navigationItem.rightBarButtonItem=rightbuttonitem;
    

    
    sendDirectionTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,IS_IOS_7?self.view.frame.size.height-64:self.view.frame.size.height-44)];
    sendDirectionTabelView.delegate = self;
    sendDirectionTabelView.dataSource = self;
    [self.view addSubview:sendDirectionTabelView];
    sendDirectionTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setEditing:YES animated:YES];
    
    [BCHTTPRequest getBusinessDepartmentListWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
            
            for (int i = 0; i< [resultDic[@"list"] count]; i++) {
                WallGroupItem* friendItem = [WallGroupItem wallGroupItem];
                friendItem.name = resultDic[@"list"][i][@"title"];
                friendItem.headLogo = resultDic[@"list"][i][@"logo"];
                friendItem.friendId = [resultDic[@"list"][i][@"id"] intValue];
                [sendDirectionArray addObject:friendItem];
            }
            
            
            [sendDirectionTabelView reloadData];
        }
    }];
}
#pragma mark - 返回
-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 确定
- (void)sendButtonClicked
{
    groupId = @"";
    if (selectDirectionArray.count>0) {
        WallGroupItem *wallGroupItem = selectDirectionArray[0];
        groupId = [NSString stringWithFormat:@"%d",wallGroupItem.friendId];
        
        for (int i = 1; i< selectDirectionArray.count; i++) {
            WallGroupItem *wallGroupItem = selectDirectionArray[i];
            groupId = [NSString stringWithFormat:@"%@,%d",groupId,wallGroupItem.friendId];
        }
    }
    
//    bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    bgScrollView.backgroundColor = [UIColor colorWithRed:.0f/255.0f green:.0f/255.0f blue:.0f/255.0f alpha:0.8];
//    [self.view addSubview:bgScrollView];
//    
//    alertView = [[UIView alloc] initWithFrame:CGRectMake(81/2, (self.view.frame.size.height-729/2)/2+64/2, 481/2, 320/2)];
//    alertView.backgroundColor = [UIColor colorWithRed:241.0f/255.0f green:241.0f/255.0f blue:241.0f/255.0f alpha:1];
//    alertView.layer.cornerRadius = 3;
//    [alertView.layer setMasksToBounds:YES];
//    alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7, 0.7);
//    [bgScrollView addSubview:alertView];
//    
//    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(30/2, 26/2, 424/2, 40/2)];
//    //totalLabel.text = @"发布该业务总需花费20000金币";
//    totalLabel.textColor = [UIColor colorWithRed:119.0f/255.0f green:153.0f/255.0f blue:208.0f/255.0f alpha:1];
//    totalLabel.font = [UIFont systemFontOfSize:15];
//    [alertView addSubview:totalLabel];
//    
//    UILabel *publicWallLabel = [[UILabel alloc] initWithFrame:CGRectMake(30/2, 26/2+40/2+16/2, 424/2, 40/2)];
//    //publicWallLabel.text = @"公共墙20000金币";
//    publicWallLabel.textColor = [UIColor colorWithRed:119.0f/255.0f green:153.0f/255.0f blue:208.0f/255.0f alpha:1];
//    publicWallLabel.font = [UIFont systemFontOfSize:15];
//    [alertView addSubview:publicWallLabel];
//    
//    UILabel *conditionWallLabel = [[UILabel alloc] initWithFrame:CGRectMake(30/2, 26/2+40/2+16/2+40/2+16/2, 424/2, 40/2)];
//    //conditionWallLabel.text = @"定向发布20000金币";
//    conditionWallLabel.textColor = [UIColor colorWithRed:119.0f/255.0f green:153.0f/255.0f blue:208.0f/255.0f alpha:1];
//    conditionWallLabel.font = [UIFont systemFontOfSize:15];
//    [alertView addSubview:conditionWallLabel];
//    
//    UILabel *confirmLabel = [[UILabel alloc] initWithFrame:CGRectMake(30/2, 26/2+40/2+16/2+40/2+16/2+40/2+16/2, 424/2, 40/2)];
//    confirmLabel.text = @"请确认发布";
//    confirmLabel.textColor = [UIColor colorWithRed:119.0f/255.0f green:153.0f/255.0f blue:208.0f/255.0f alpha:1];
//    confirmLabel.font = [UIFont systemFontOfSize:15];
//    [alertView addSubview:confirmLabel];
//    
//    
//    //取消
//    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelButton.frame = CGRectMake(30/2, 26/2+40/2+16/2+40/2+16/2+40/2+16/2+40/2+16/2, 165/2, 42/2);
//    [cancelButton setBackgroundImage:[UIImage imageNamed:@"yihouzaishuo@2x"] forState:UIControlStateNormal];
//    [cancelButton setTitle:@"以后再说" forState:UIControlStateNormal];
//    [cancelButton setTitleColor:[UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1] forState:UIControlStateNormal];
//    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    [cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
//    [alertView addSubview:cancelButton];
//    
//    //确定
//    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    confirmButton.frame = CGRectMake(481/2-30/2-165/2, 26/2+40/2+16/2+40/2+16/2+40/2+16/2+40/2+16/2, 165/2, 42/2);
//    [confirmButton setBackgroundImage:[UIImage imageNamed:@"fabuqiangqueding@2x"] forState:UIControlStateNormal];
//    [confirmButton setTitle:@"确定发布" forState:UIControlStateNormal];
//    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    [confirmButton addTarget:self action:@selector(clickConfirmButton) forControlEvents:UIControlEventTouchUpInside];
//    [alertView addSubview:confirmButton];
    
    
    [BCHTTPRequest getBusinessGoldsWithUsingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
        if (isSuccess == YES) {
//            publicWallLabel.text = [NSString stringWithFormat:@"公共墙%@金币",resultDic[@"public_gold"]];
//            conditionWallLabel.text = [NSString stringWithFormat:@"定向发布%d金币",([resultDic[@"orientation_gold"] intValue] *[selectDirectionArray count])];
//            totalLabel.text = [NSString stringWithFormat:@"发布该业务总需花费%d金币",[resultDic[@"public_gold"] intValue] + ([resultDic[@"orientation_gold"] intValue] *[selectDirectionArray count])];
            
            NSString *payGold = [NSString stringWithFormat:@"发布该业务总需花费%d金币",[resultDic[@"public_gold"] intValue] + ([resultDic[@"orientation_gold"] intValue] *[selectDirectionArray count])];
            UIAlertView *alertViews  = [[UIAlertView alloc] initWithTitle:@"业务发布" message:payGold delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alertViews.tag = 6000;
            [alertViews show];
        }
    }];
    
    
//    [UIView animateWithDuration:0.2 animations:^{
//        alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
//    } completion:^(BOOL finished) {
//        
//    }];
//
//    sendButton.userInteractionEnabled = NO;
    
}



//#pragma mark - 取消按钮
//- (void)clickCancelButton
//{
//    alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.7, 0.7);
//    [bgScrollView removeFromSuperview];
//    
//    sendButton.userInteractionEnabled = YES;
//}

//#pragma mark - 确定
//- (void)clickConfirmButton
//{
//    [BCHTTPRequest businessSetActionWithTitle:_wallInformationDic[@"title"] WithContent:_wallInformationDic[@"content"] WithDepartment_ids:groupId WithType_id:_wallInformationDic[@"typeId"] WithNick_name:_wallInformationDic[@"identity"] WithIs_public:_wallInformationDic[@"is_public"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
//        if (isSuccess == YES) {
//            
//            sendButton.userInteractionEnabled = YES;
//            alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.7, 0.7);
//            [bgScrollView removeFromSuperview];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
//    }];
//}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        ;
    }else
    {
        if (alertView.tag == 6000) {
            [BCHTTPRequest businessSetActionWithTitle:_wallInformationDic[@"title"] WithContent:_wallInformationDic[@"content"] WithDepartment_ids:groupId WithType_id:_wallInformationDic[@"typeId"] WithNick_name:_wallInformationDic[@"identity"] WithIs_public:_wallInformationDic[@"is_public"] usingSuccessBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                if (isSuccess == YES) {
                    if ([resultDic[@"state"] intValue] == 1) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else if ([resultDic[@"state"] intValue] == 2) {
                        [self myAlert];
                    }
                    
                }
            }];

        }else if (alertView.tag == 7000)
        {
            GoldcoinsViewController *goldcoinsViewController = [[GoldcoinsViewController alloc] init];
            [self.navigationController pushViewController:goldcoinsViewController animated:YES];

        }
        
    }
}
- (void)myAlert
{
    UIAlertView *calertView  = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的金币不足，是否前往充值？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    calertView.tag = 7000;
    [calertView show];
}
#pragma mark - tableView Delegate
//进入编辑状态
- (void) setEditing:(BOOL)editting animated:(BOOL)animated
{
    [super setEditing:editting animated:animated];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170/2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return sendDirectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
    CheckSendDirectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
    if (cell == nil) {
        cell = [[CheckSendDirectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    WallGroupItem* friendItem = sendDirectionArray[indexPath.row];
    //头像
    
    [cell.photoImageView setImageWithURL:[NSURL URLWithString:friendItem.headLogo] placeholderImage:[UIImage imageNamed:@"ceshi@2x"]];
    cell.nameLabel.text = friendItem.name;
    
    [cell.lineImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];
    
    [cell setChecked:friendItem.checked];
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WallGroupItem* friendItem = sendDirectionArray[indexPath.row];
    
    //根据对象被不被选中对选中数组进行增加和删除
    if (friendItem.checked) {
        [selectDirectionArray removeObject:friendItem];
        
    }else {
        [selectDirectionArray addObject:friendItem];
        
    }
    
    //cell选中和未选中的效果
    if (self.editing)
    {
        CheckSendDirectionTableViewCell *cell = (CheckSendDirectionTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        friendItem.checked = !friendItem.checked;
        [cell setChecked:friendItem.checked];
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
