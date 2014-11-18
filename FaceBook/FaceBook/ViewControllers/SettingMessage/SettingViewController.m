//
//  SettingViewController.m
//  FaceBook
//
//  Created by fengshaohui on 14-5-11.
//  Copyright (c) 2014年 HMN. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
//#import <QuartzCore/QuartzCore.h>
#import "FaceBookMainHomePageViewController.h"
#import "MessageRewardViewController.h"
#import "TwoCodeViewController.h"
#import "Harpy.h"
#import "AboutUsViewController.h"
#import "BCHTTPRequest.h"
#import "SVProgressHUD.h"
#import "DMCAlertCenter.h"
#import "UpgradeVIPViewController.h"
#import "MyPersonCenterViewController.h"

#import "LoginAndRegisterViewController.h"

#import "OtherNotice.h"
#import "OtherNoticeObject.h"
#import "PrivateChatMessagesDB.h"

@interface SettingViewController ()
{
    UITableView *setTableView;
    NSArray *setArray;
    //退出登录按钮
    UIButton *exitButton;
    
    UISwitch *imageSaveSwitch;
    OtherNotice *otherNotice;
    OtherNoticeObject *otherObj;
    
    LoginAndRegisterViewController *loginAndRegisterViewController;
    
}
@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        setArray = [[NSArray alloc]initWithObjects:@"个人资料",@"我的二维码",@"消息设置",@"升级VIP",@"拍照自动保存到手机",@"清空聊天记录",@"版本升级",@"关于我们", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    otherNotice = [[OtherNotice alloc]init];
    [otherNotice createDataBase];
    
    otherObj = [otherNotice getAllOthersRemindStyleWithNumber:@"1"];
    
    self.view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:249.0f/255.0f blue:251.0f/255.0f alpha:1.0];
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios7"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbeijingios6"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @"设置";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 22, 40, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_backButton@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:backButton];
    UIBarButtonItem *backbuttonitem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backbuttonitem;
    
   
    setTableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-30,IS_IOS_7?self.view.frame.size.height-64:self.view.frame.size.height-44) style:UITableViewStyleGrouped];
    if (IS_IOS_7) {
        setTableView.contentInset = UIEdgeInsetsMake(- 25, 0, 0, 0);
    }
    
    setTableView.showsVerticalScrollIndicator = NO;
    setTableView.delegate = self ;
    setTableView.dataSource = self ;
//    [setTableView.layer setMasksToBounds:YES];
//    [setTableView.layer setCornerRadius:5.0f];
//    setTableView.layer.borderWidth = 1;
//    setTableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];//设置列表边框
    setTableView.backgroundView = nil ;
    setTableView.backgroundColor = [UIColor clearColor];
    setTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    setTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    setTableView.tableFooterView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:setTableView];
    
    //退出登录
    exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exitButton.frame = CGRectMake(0, 33, 580/2, 36);
    [exitButton setBackgroundImage:[UIImage imageNamed:@"tuichudenglu@2x"] forState:UIControlStateNormal];
    [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(exitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [setTableView.tableFooterView addSubview:exitButton];
    
}
#pragma mark - 返回
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 退出登录
- (void)exitButtonClicked
{
    NSLog(@"退出登录");
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定退出登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86/2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimepleNewsListcell = @"SimpleNewsListcells";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:SimepleNewsListcell];
    if (cell == nil) {
        cell = [[SettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimepleNewsListcell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellBackImageView.backgroundColor = [UIColor clearColor];
    cell.titleLabel.text = setArray[indexPath.row];
    if (indexPath.row == 4) {
        [cell.markImageView setImage:[UIImage imageNamed:@""]];
        imageSaveSwitch = [[ UISwitch alloc]init];
        if (IS_IOS_7) {
            imageSaveSwitch.frame = CGRectMake(446/2,6,104/2,31);
        }else
        {
            imageSaveSwitch.frame = CGRectMake(406/2,6,104/2,31);
        }
        
        if ([otherObj.isSavePhoto isEqualToString:@"1"]) {
            [ imageSaveSwitch setOn:YES animated:YES];
        }else
        {
            [ imageSaveSwitch setOn:NO animated:YES];
        }

        
        [ imageSaveSwitch addTarget: self action:@selector(imageSaveSwitchValueChanged) forControlEvents:UIControlEventValueChanged];
        [cell.cellBackImageView addSubview:imageSaveSwitch];
    }else
    {
        [cell.markImageView setImage:[UIImage imageNamed:@"celljiantou@2x"]];
    }
    if (IS_IOS_7) {
        [cell.lineImageView setImage:[UIImage imageNamed:@"xiahuaxian@2x"]];
    }
    //
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        MyPersonCenterViewController *myPersonCenterVC = [[MyPersonCenterViewController alloc]init];
        [self.navigationController pushViewController:myPersonCenterVC animated:YES];
        
    }else if (indexPath.row == 1)
    {
        TwoCodeViewController *twoQRCodeVC = [[TwoCodeViewController alloc]init];
        [self.navigationController pushViewController:twoQRCodeVC animated:YES];
        
    }else if (indexPath.row == 2)
    {
        MessageRewardViewController *messageRewardVC = [[MessageRewardViewController alloc]init];
        [self.navigationController pushViewController:messageRewardVC animated:YES];
        
    }else if (indexPath.row == 3)
    {
        //升级VIP
        UpgradeVIPViewController *upgradeVIPVC = [[UpgradeVIPViewController alloc]init];
        upgradeVIPVC.isSetting = @"yes";
        [self.navigationController pushViewController:upgradeVIPVC animated:YES];
        
    }else if (indexPath.row == 5)
    {
        UIAlertView *cleanalertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定清除聊天记录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        cleanalertView.tag = 3002;
        [cleanalertView show];

    }else if (indexPath.row == 6)
    {
        //软件升级
        [Harpy checkVersion];
        
    }else if (indexPath.row == 7)
    {
        //关于我们
        AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc]init];
        [self.navigationController pushViewController:aboutUsVC animated:YES];
        
    }





}
#pragma mark - 照片保存至手机
- (void)imageSaveSwitchValueChanged
{
    if (imageSaveSwitch.on == YES) {
        
        
        
        [otherNotice UpdateTheRemindStyleWith:@"savePhoto" WithValues:@"1" WithNumber:@"1"];
    }else if (imageSaveSwitch.on == NO){
        NSLog(@"2222222");
        [otherNotice UpdateTheRemindStyleWith:@"savePhoto" WithValues:@"2" WithNumber:@"1"];
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView.tag == 3002) {
            [SVProgressHUD showWithStatus:@"聊天记录清理中" maskType:SVProgressHUDMaskTypeBlack];
            PrivateChatMessagesDB * privateChat = [[PrivateChatMessagesDB alloc] init];
            [privateChat createDataBase];

            [privateChat delegeteMessageAllArray];
            
            //3秒钟跳转
            [self performSelector:@selector(clickdismissSVP) withObject:nil afterDelay:3];
            
            
            
        }else
        {
            NSLog(@"退出");
            [BCHTTPRequest exitLogin];
      
//            [self dismissViewControllerAnimated:YES completion:^{
//                ;
//            }];
          
            loginAndRegisterViewController = [[LoginAndRegisterViewController alloc] init];
            [self presentViewController:loginAndRegisterViewController animated:NO completion:^{
                ;
            }];

            
        }
    }
}

- (id)getCurNavController{
    UINavigationController* navController = (UINavigationController*)self.tabBarController.selectedViewController;
    return navController;
    
}
- (void)clickdismissSVP
{
    [SVProgressHUD dismiss];
    [[DMCAlertCenter defaultCenter] postAlertWithMessage:@"聊天记录清除完毕"];
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
